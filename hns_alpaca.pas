unit hns_alpaca; {Client for ASCOM ALPACA communication}

{Copyright (C) 2016,2022 by Han Kleijn, www.hnsky.org
 email: han.k.. at...hnsky.org

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

{$MODE objfpc}{$H+} //essential for synapse
interface

uses
  {cthreads is defined in.lpr file}
  Classes, SysUtils,
  strutils,
  {$ifdef mswindows}
  {$else} {unix}
  {$endif}
  math,
  blcksock, synsock; {laz_synapse}

const
  alpaca_connected : boolean=false;
  Alpaca_port           : string='11111';
  Alpaca_address        : string='127.0.0.1' ;
  alpaca_telescope      : string='0' ;

  alpaca_ra             : double=0;
  alpaca_dec            : double=0;

  procedure alpaca_read(s:string);
  procedure alpaca_get_radec;
  procedure alpaca_send_http_put(mess,param: string);{send a http PUT to Alpaca}
  procedure alpaca_put_generic(command: string; ra,dec : double);{slewToCoordinatesasync, slewtocoordinates or synctocoordinates}
  procedure alpaca_get_tracking;{get tracking status}
  procedure alpaca_put_string(command,value1: string);{put for tracking=true/false, abort,findhome, park}
  procedure alpaca_get_athome;{mount at home position}
  procedure alpaca_get_atpark;{mount in park position}
  procedure alpaca_get_canslew; {slew possible but not feedback of position at the same time}
  procedure alpaca_get_canslewasync;{async slew possible, live feed back Ra/DEC}
  procedure alpaca_get_equatorialsystem; {equinox of telescope}
  procedure alpaca_get_sideofpier; {side of pier, East, West or unknown?}



type
  TMyTCPClient = class (TThread)
    FSock:TTCPBlockSocket;
  private
    FDataSend:String;
    FDataReceived:String;
    Ftextlabel_status:String;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Execute; override;
    procedure SendData(Data:String);
    procedure Process_incoming;
    procedure Set_status;
    procedure connection_lost;
  end;

var
  client_request :array of string;

implementation

uses hns_main;

function floattostr3(x:double):string;{no spaces in string}
begin
  str(x:0:6,result);
end;

procedure alpaca_send_http_put(mess,param: string);{send a http PUT to Alpaca}
var st:string;
begin
  if alpaca_connected then
   begin
     {'PUT /api/v1/telescope/0/slewtocoordinates HTTP/1.1'+#13+#10}
     {'Host: 127.0.0.1:11111'+#13+#10}
     {Content-Length: 65}
     {#13+#10}
     {'RightAscension=23.000&Declination=89.0000&ClientID=0&ClientTransactionID=0'#13+#10}
     {#13+#10}

     {'PUT /api/v1/telescope/0/park HTTP/1.1'+#13+#10}
     {'Host: 127.0.0.1:11111'+#13+#10}
     {Content-Length: 32}
     {#13+#10}
     {'ClientID=0&ClientTransactionID=0'#13+#10}
     {#13+#10}

     {'PUT /api/v1/telescope/0/tracking HTTP/1.1'+#13+#10}
     {'Host: 127.0.0.1:11111'+#13+#10}
     {Content-Length: 42}
     {#13+#10}
     {'tracking=true&ClientID=0&ClientTransactionID=0'#13+#10}
     {#13+#10}

     st:='PUT /api/v1/telescope/'+alpaca_telescope+'/'+mess+' HTTP/1.1'+#13+#10+
         'Host: '+alpaca_address+':'+alpaca_port+#13+#10+
         'Keep-Alive: 300'+#13+#10+
         'Connection: keep-alive'+#13+#10+
         'Content-Type: application/x-www-form-urlencoded'+#13+#10+  {data that is sent in a single block in the HTTP message body}
         'Content-Length: '+inttostr(length(param))+#13+#10+  {the length of the body}
         #13+#10+              {An empthy line equals twice CRLF indicated the end of the HTTP header}
         param;  {The body}

     setlength(client_request,min(10,length(client_request)+1));{add maximum 10 messages}
     client_request[length(client_request)-1]:=st;
 end;
end;


procedure alpaca_send_http_get(mess: string);{send a http GET to Alpaca}
var st: string;
begin
//  if alpaca_connected=false then
//  begin
//    switch_alpaca_client_onoff(true); {try to reconnect}
//    mainwindow.statusbar1.caption:='Alpaca <=/ /=>';
//  end;


  if alpaca_connected then
  begin
    {'GET /api/v1/telescope/0/rightascension HTTP/1.1'+#13+#10}
    {'Host: 127.0.0.1:11111'+#13+#10}
    {#13+#10}
     st:='GET /api/v1/telescope/'+alpaca_telescope+'/'+mess+' HTTP/1.1'+#13+#10+
                                     'Host: '+alpaca_address+':'+alpaca_port+#13+#10+
                                     'Keep-Alive: 300'+#13+#10+
                                     'Connection: keep-alive'+#13+#10+
                                     #13+#10;   {An empthy line equals twice CRLF indicated the end of the HTTP header}



     setlength(client_request,min(10,length(client_request)+1));{add making 10 messages}
     client_request[length(client_request)-1]:=st;
  end;
end;



procedure alpaca_read(s:string); {read alpaca message}
var
   b,e, err1,err2,tid,bool_value: integer;
   ss    :string;
   value : double;
begin
  {"Value":0.48790888091360546,"ClientTransactionID":0,"ServerTransactionID":85,"ErrorNumber":0,"ErrorMessage":"","DriverException":null}
  bool_value:=0;{assume no boolean}
  err1:=0; {for boolean values}
  ss:='Value":';
  b:=posex(ss,s,1);
  if b=0 then exit;
  inc(b,length(ss));
  e:=posex(',',s,b);
  ss:=copy(s,b,e-b);
  if ss='true' then bool_value:=+1
  else
  if ss='false' then bool_value:=-1
  else
  val(ss,value,err1);

  ss:='ClientTransactionID":';
  b:=posex(ss,s,1);
  if b=0 then exit;{need the id to identify}
  inc(b,length(ss));
  e:=posex(',',s,b);
  ss:=copy(s,b,e-b);
  val(ss,tid,err2);


  ss:='ErrorMessage":"';
  b:=posex(ss,s,1);
  if b>0 then
  begin
    inc(b,length(ss));
    e:=posex('"',s,b); {different end}
    ss:=copy(s,b,e-b);
    if length(ss)>0 then
    begin
       mainwindow.statusbar1.caption:='Alpaca: '+ss;
       mainwindow.error_message1.visible:=true;
       mainwindow.error_message1.caption:=ss;
    end;
  end;

  if ((err1=0) and (err2=0)) then
  begin
    if tid=8265 then alpaca_ra:=value; {R=char(82), A=char(65)}
    if tid=6869 then alpaca_dec:=value;{D=char(68), E=char(69)}
    if tid=8482 then {tracking?}
    begin
      if bool_value=+1 then mainwindow.tracking1.checked:=true;
      if bool_value=-1 then mainwindow.tracking1.checked:=false;
    end;
    if tid=8065 then {atpark?}
    begin
      if bool_value=+1 then mainwindow.park1.checked:=true;
      if bool_value=-1 then mainwindow.park1.checked:=false;
    end;
    if tid=7279 then {athome?}
    begin
      if bool_value=+1 then mainwindow.home1.checked:=true;
      if bool_value=-1 then mainwindow.home1.checked:=false;
    end;
    if tid=6583 then {async slew possible, live feed back Ra/DEC}
    begin
      if bool_value=+1 then Ascom_mount_capability:=2;
      if bool_value=-1 then Ascom_mount_capability:=0;
    end;
    if tid=6783 then {slew possible but not feedback of position at the same time}
    begin
      if bool_value=+1 then Ascom_mount_capability:=1;
      if bool_value=-1 then Ascom_mount_capability:=0;
    end;
    if tid=ord('S')+ord('I')+ord('D')+ord('E')+ord('P') then
      sideofpier_alpaca:=round(value); //Indicates the pointing state of the mount. 0 = pierEast, 1 = pierWest, -1= pierUnknown

    if tid=6981 then {equatorialsystem}
    begin
      case round(value) of
         0 : equinox_telescope:=0;    {equOther	0	Custom or unknown equinox and/or reference frame.}
         1 : equinox_telescope:=0;    {equLocalTopocentric	1	Local topocentric; this is the most common for amateur telescopes.}
         2 : equinox_telescope:=2000; {equJ2000	2	J2000 equator/equinox, ICRS reference frame.}
         3 : equinox_telescope:=2050; {equJ2050	3	J2050 equator/equinox, ICRS reference frame.}
         4 : equinox_telescope:=1950; {equB1950	4	B1950 equinox, FK4 reference frame.}
         else
           equinox_telescope:=0;
      end;
    end;



  end;
end;

procedure alpaca_get_radec;
begin
  alpaca_send_http_get('rightascension?clientid=7&clienttransactionid=8265');{HNSKY specific transactions numbers R=char(82), A=char(65)}
  alpaca_send_http_get('declination?clientid=7&clienttransactionid=6869');{HNSKY specific transactions D=char(68), E=char(69)}
end;

procedure alpaca_put_generic(command: string; ra,dec : double);{slewToCoordinatesAsync, slewtocoordinates or synctocoordinates}
begin
  alpaca_send_http_put(command,'RightAscension='+floattostr3(ra)+'&Declination='+floattostr3(dec)+'&ClientID=7&ClientTransactionID=100');
end;


procedure alpaca_get_generic(command : string);{generic GET command for abortslew, park, home}
begin
  alpaca_send_http_get(command+'?clientid=7&clienttransactionid=9999');
end;

procedure alpaca_get_tracking;{get tracking}
begin
  alpaca_send_http_get('tracking?clientid=7&clienttransactionid=8482');{HNSKY specific transactions T=char(84), E=char(82)}
end;

procedure alpaca_get_atpark;{mount in park position}
begin
  alpaca_send_http_get('atpark?clientid=7&clienttransactionid=8065');{HNSKY specific transactions P=char(80), A=char(65)}
end;
procedure alpaca_get_athome;{mount at home position}
begin
  alpaca_send_http_get('athome?clientid=7&clienttransactionid=7279');{HNSKY specific transactions H=char(72), O=char(79)}
end;

procedure alpaca_get_canslewasync;{async slew possible, live feed back Ra/DEC}
begin
  alpaca_send_http_get('canslewasync?clientid=7&clienttransactionid=6583');{HNSKY specific transactions A=#65, S=#83}
end;
procedure alpaca_get_canslew; {slew possible but not feedback of position at the same time}
begin
  alpaca_send_http_get('canslew?clientid=7&clienttransactionid=6783');{HNSKY specific transactions C=#67, S=#83}
end;

procedure alpaca_get_equatorialsystem; {equinox of telescope}
begin
  alpaca_send_http_get('equatorialsystem?clientid=7&clienttransactionid=6981');{HNSKY specific transactions E=#69, Q=#81}
end;

procedure alpaca_get_sideofpier; {side of pier, East, West or unknown?}
begin
  alpaca_send_http_get('sideofpier?clientid=7&clienttransactionid='+inttostr(ord('S')+ord('I')+ord('D')+ord('E')+ord('P')));{HNSKY specific transactions number #SIDEP}
end;

procedure alpaca_put_string(command,value1: string);{put for tracking=true or false, abort,findhome, park}
begin
  if length(value1)>0 then value1:=value1+'&';
  alpaca_send_http_put(command,value1+'ClientID=7&ClientTransactionID=9999');{true or false}
end;

{Synapse routines}
Constructor TMyTCPClient.Create;
begin
  inherited create(false);
  Fsock:=TTCPBlockSocket.create;
  FreeOnTerminate:=true;
end;

Destructor TMyTCPClient.Destroy;
begin
  FSock.free;
  inherited destroy; //Destroy thread
end;


procedure TMyTCPClient.Execute;
var
  i,j,k,rport :Integer;
begin
  with fsock do
  begin
    Connect(alpaca_address, alpaca_port);
    rport:=GetRemoteSinPort;
    Ftextlabel_status:='Connected to port '+IntToStr(rport);
    Synchronize(@Set_status);           // Never access form1 from another thread

    while ((not Terminated) and (rport<>0)) do
    begin
      k:=length(client_request);
      if k>0 then
      begin
        for j:=0 to k-1 do
        begin
          FSock.SendString(client_request[j]); //send data
          if lastError<>0 then break;{break for FOR loop}
        end;
        setlength(client_request,0);{clear}
        if lastError<>0 then break;  {break while loop}
      end;
      if CanRead (100) then
      begin
        i:=WaitingData;
        if i>0 then
        begin
          SetLength (FdataReceived, i);
          RecvBuffer (@FdataReceived[1], i);
          if lastError<>0 then break;
          synchronize (@process_incoming);
        end
        else
        if canread(0) then break; {lost connection detection}
      end;
    end;

    AbortSocket; // Free socket
  end;
  Ftextlabel_status:='<=/ /=>';
  Synchronize(@connection_lost); // Report lost connection
end;


procedure TMyTCPClient.SendData(Data:String);
begin
  FDataSend := FDataSend + Data;
//  mainwindow.memo1.lines.add(Fdatasend);
end;


procedure TMyTCPClient.process_incoming;
begin
  alpaca_read(FdataReceived);
//  mainwindow.statusbar1.caption:=s+' | '+Stext;

end;


procedure TMyTCPClient.Set_status;
begin
  mainwindow.statusbar1.caption:=alpaca_connection_string+', '+Ftextlabel_status;   // Always run from main thread;
  statusbarfree:=false;
  mainwindow.error_message1.visible:=false;
end;

procedure TMyTCPClient.connection_lost;
begin
  mainwindow.error_message1.caption:=Alpaca_conn_lost_string;
  mainwindow.error_message1.visible:=true;
  alpaca_connected:=false; {Essential. Actual connection}
  update_telescope_menu(false);
end;



end.


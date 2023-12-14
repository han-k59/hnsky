unit hns_Userver;

{Copyright (C) 2016,2023 by Han Kleijn, www.hnsky.org
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


{$MODE objfpc}{$H+} //essential
interface

uses
  {cthreads is defined in.lpr file}
  {$ifdef mswindows}
  {$else} {unix}
  LCLIntf, {for invalidaterect}
  {$endif}
  Classes, SysUtils,strutils,
  blcksock, synsock;

type
  TTCPServerDaemon = class(TThread)
  private
    Sock:TTCPBlockSocket;
    Ftextlabel_status:string;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Execute; override;
    procedure Set_status;
  end;

  TTCPServerThrd = class(TThread)
  private
    Sock:TTCPBlockSocket;
    CSock: TSocket;
    Stext: string;
  public
    Constructor Create (hsock:tSocket);
    procedure Execute; override;
    procedure process_incoming;
    procedure connection_lost;
  end;

var
  server_text_out : string='';

implementation

uses hns_main, hns_Uast;


function read_request(s:string):string;
var commd,p1,p2,p3,p4,p5,p6   :string;
    error1 :integer;
    d1,d2,d3,d4,d5,pa  : double;
    List: TStrings;
begin
  s:=StringReplace(s, #39, '',[rfReplaceAll]); {remove all single apostrophe}
  if local_DecimalSeparator<>'.' then s:=StringReplace(s,local_DecimalSeparator,'.',[]); {replaces komma by dot}

  result:='?';

  List := TStringList.Create;
  try
    List.Clear;
    list.StrictDelimiter:=true;{accept spaces in command but reconstruct since they are split over several parameters}
    ExtractStrings([' '], [], PChar(s),List);
    if list.count>0  then commd:=upcase(list[0])
                     else commd:='';{empthy command}
    if list.count>1 then
    p1:=list[1] else p1:='';
    if list.count>2 then p2:=list[2] else p2:='';
    if list.count>3 then p3:=list[3] else p3:='';
    if list.count>4 then p4:=list[4] else p4:='';
    if list.count>5 then p5:=list[5] else p5:='';
    if list.count>6 then p6:=list[6] else p6:='';
  finally
    List.Free;
  end;

  {commands with test as second parameter}
  if commd ='SEARCH' then
  begin
    goto_str:=p1+p2+p3+p4;{names with spaces will be split across the parameters. Just add them to fix}
    action2:=1; {find action in hns_main at Tmainwindow.FormPaint}
    result:='';{result will come later in find_object procedure, if server_on then search request via TCP outstanding}
    missedupdate:=1;
    paint_sky;
    exit;
  end
  else
  if commd ='LOAD_FITS' then
  begin
    dss_mask:=ExtractFilePath(p1);{change FITs path for next load. Do not use dss_path, dss_path will be extracted from dss_mask}
    plot_fits(nil,p1);
    fits_insert:=1;{activate, for redraw action}
    missedupdate:=2;
    paint_sky;{rewrite window}
    result:='OK';
    exit;
  end
  else
  if commd ='DELETE_FRAME' then
  begin
    result:=remove_rectangle(p1 {label name});{in supplement2}
    missedupdate:=2;
    paint_sky;
    exit;
  end
  else
  if commd ='GET_TARGET' then
  begin
    if orientation2<>999{unknown} then pa:=orientation2*pi/180 {orientation is in degrees} else pa:=pi/2;{orientation is in degrees}
    result:=floattostrF_local(found_ra2,0,7)+' '+floattostrF_local(found_dec2,0,7)+' '+found_name+' '+floattostrF_local(pa,0,7){radians}+
            ' '+floattostrF_local(found_velocity,0,4)+' '+floattostrF_local(found_velocity_pa,0,4);//comets, #13+#10 will be added in TTCPServerThrd.process_incoming;
    exit;
  end
  else
  if commd ='GET_FRAMES' then {export all mosaic frames}
  begin
    export_frames:=true;{export via plotting supplement2}
    missedupdate:=1;
    paint_sky;{frames will be send while plotting supplement 2}
    export_frames:=false;{export only once}
    result:='';  {result is already send in plot_supplement}
    exit;
  end
  else
  if commd ='GET_POS' then begin result:=floattostrF_local(telescope_RA,0,7)+' '+floattostrF_local(telescope_DEC,0,7); exit; end {radians}
  else
  if commd ='HELP' then begin
          result:=
          'Requests to HNSKY:'+#13+#10+
          'ADD_FRAME width height angle ra dec (label) ==> OK'+#13+#10+
          'SET_FRAME width height angle ra dec (label) ==> OK'+#13+#10+
          'DELETE_FRAME (label) ==> OK'+#13+#10+
          'SET_POS RA DEC (field_height) ==> OK'+#13+#10+
          'LOAD_FITS file_name ==> OK'+#13+#10+
          'GET_POS ==> ra dec'+#13+#10+
          'GET_TARGET ==> ra dec object_name pa (v vpa)'+#13+#10+
          'GET_FRAMES ==> ra dec object_name pa (v vpa)'+#13+#10+
          'SEARCH object_name ==> ra dec object_name pa (v vpa)'+#13+#10+
          'GET_LOCATION ==> long lat JD'+#13+#10+
          'SHUTDOWN'+#13+#10+
           #13+#10+
          'Unsolicitated info from HNSKY:'+#13+#10+
          'ra dec object_name pa (v vpa)'+#13+#10;
          exit;
  end
  else
  if commd ='GET_LOCATION' then begin
                                  result:=floattostrF_local(longitude*pi/180,0,7)+' '+floattostrF_local(latitude*pi/180,0,7)+' '+floattostrF_local(julian_ut,0,5);
                                  exit;
                                end
  else

  if commd ='SHUTDOWN' then
  begin
    halt;
    result:='';
    exit;
  end;


  {commands with numerical parameters}
  if length(p1)>0 then val(p1,d1,error1); if error1<>0 then exit; {parameter1}
  if length(p2)>0 then val(p2,d2,error1); if error1<>0 then exit;{parameter2}
  if length(p3)>0 then val(p3,d3,error1); if error1<>0 then exit;{parameter3}
  if length(p4)>0 then val(p4,d4,error1); if error1<>0 then exit;{parameter4}
  if length(p5)>0 then val(p5,d5,error1); if error1<>0 then exit;{parameter5}

  result:='OK';

  if commd ='SET_POS' then begin ra_az(d1, d2,latitude,0, wtime2,viewx,viewy); if p3<>'' then zoom:=(pi/180)*114.59045/d3; missedupdate:=2; paint_sky {rewrite window} end
  else
  if ((commd ='SET_FRAME') or (commd ='ADD_FRAME'))   then
  begin
    if (commd ='SET_FRAME') then  remove_rectangle(p6 {label name});{in supplement2}

    {The frame angle is opposite to crota2. If frame is turned clockwise 35 degrees, the image will have a CROTA2 of 35 degrees, so image up is 35 east of north. If the CCD turn right, the image turn left}
    supplstring2.Append(floattostr2(d4*12/pi){ra}+',,,'+
                        floattostr2(d5*180/pi){dec}+',,,-25,'+
                        p6 {label}+',frame,-8,'+
                        floattostr2(d1*10*60*180/pi){the largest, width or length}+','+
                        floattostr2(d2*10*60*180/pi){height}+','+
                        floattostr2(d3*180/pi));{frame rotation}

    suppl2_activated:=1;{activate supplement 2 to show}

    ra_az(d4, d5,latitude,0, wtime2,viewx,viewy);{show object in center}
    missedupdate:=2;
    paint_sky; {rewrite window}
  end
  else
  result:='?';
end;

{ TEchoDaemon }

Constructor TTCPServerDaemon.Create;
begin
  inherited create(false);
  sock:=TTCPBlockSocket.create;
  FreeOnTerminate:=true;
end;

Destructor TTCPServerDaemon.Destroy;
begin
  Sock.free;
  inherited destroy;        //Destroy thread
end;

procedure TTCPServerDaemon.Execute;
var
  ClientSock:TSocket;            //One per client connection, use array or list if multiple connection is possible
  Clientthrd:TTCPServerThrd;
begin
  Clientthrd:=nil;{has to be defined for testing later}
  with sock do
  begin
    CreateSocket;
    setLinger(true,10000);
    bind(server_address,server_port);
    listen;
    repeat
      if terminated then break;
      if canread(100) then
        begin
          ClientSock:=accept;
          if lastError=0 then
          begin
            Clientthrd:=TTCPServerThrd.create(ClientSock);
            if terminated then break;
            Ftextlabel_status:='Port '+IntToStr(GetLocalSinPort);  // Real port can be different if specified port is busy
            Synchronize(@set_status);
          end;
        end;
    until false;
    if ((Clientthrd<>nil) and (not Clientthrd.Terminated)) then
       Clientthrd.Terminate; // Stop client thread
    AbortSocket;             // Free socket
  end;
end;


procedure TTCPServerDaemon.Set_status;
begin
  mainwindow.statusbar1.caption:=tcp_online_string+', '+Ftextlabel_status;   // Always run from main thread
  statusbarfree:=false;
end;


{ TEchoThrd }
Constructor TTCPServerThrd.Create(Hsock:TSocket);
begin
  inherited create(false);
  Csock := Hsock;
  FreeOnTerminate:=true;
end;

procedure TTCPServerThrd.Execute;
begin
  sock:=TTCPBlockSocket.create;
  try
    Sock.socket:=CSock;
    sock.GetSins;
    with sock do
      while not Terminated do  // Stop when Terminated is set
      begin
        if server_text_out<>'' then
        begin
          SendString(server_text_out);          // send message out
          server_text_out:='';
          if lastError<>0 then break;
        end;
        Stext:= RecvTerminated(100,#13+#10);  // Use short timeout to frequently check for Terminated and to send out messages
         if stext='' then Stext := RecvPacket(0); //temporary for APT unterminated request 2022-04-30

        if LastError=WSAETIMEDOUT then continue;// Timeout, try to read next

        if lastError<>0 then break;             // Other error, maybe client disconnect
        Synchronize(@process_incoming);         // Proccess incoming. Never access form1 from another thread
      end;
  finally
    Sock.Free;
    Synchronize(@connection_lost);
  end;
end;


procedure TTCPServerThrd.process_incoming;
var
  s : string;
begin
  s:=Stext;
  Stext:=read_request(Stext); {process incoming string and report back to the same string}
  if length(stext)<>0 then
  begin
    server_text_out:=Stext+#13+#10;{reply}
    Stext:=' | '+Stext;{a none empthy reply}
    mainwindow.statusbar1.caption:=s+Stext;
  end;
end;


procedure TTCPServerThrd.connection_lost;
begin
  mainwindow.statusbar1.caption:=tcp_offline_string;   // Always run from main thread
  statusbarfree:=false;
end;

end.


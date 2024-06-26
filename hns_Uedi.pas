unit hns_Uedi;
{Copyright (C) 1997, 2022 by Han Kleijn, www.hnsky.org
 email: han.k.. at...hnsky.org  }

{This program is free software: you can redistribute it and/or modify
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

interface

uses
  {$ifdef mswindows}
  Windows, {for messagebox}
  {$endif}
  {$ifdef unix}
  LCLType, {for messagebox}
  {$endif}
{  Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Menus, ComCtrls, clipbrd, ExtCtrls{, LazHelpHTML}, SynEdit,
  StrUtils, simpleipc, {for posex}
  SynHighlighterPosition,SynEditHighlighter,SyneditTypes ;
type

  { Tedit2 }

  Tedit2 = class(TForm)
    ImageList_edit: TImageList;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Selectall2: TMenuItem;
    MenuItem4: TMenuItem;
    Paste_supplement_lines1: TMenuItem;
    paste_supplement_labels1: TMenuItem;
    replace1: TButton;
    replace_all1: TButton;
    findtext1: TEdit;
    find2: TLabel;
    replace2: TLabel;
    MainMenu1: TMainMenu;
    OpenDialog1: TOpenDialog;
    find1: TButton;
    replacetext1: TEdit;
    SaveDialog1: TSaveDialog;
    File1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Font1: TMenuItem;
    FontDialog1: TFontDialog;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    {$IFDEF fpc}
    {$ELSE} {delphi}
      synedit1: TRichEdit;
    {$ENDIF}

    Search1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    Checksyntax1: TMenuItem;
    synedit1: TSynEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Undo1: TMenuItem;
    Selectall1: TMenuItem;
    Tools1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    N3: TMenuItem;
    edithelp: TMenuItem;
    JPLOrbitalelementsconversion1: TMenuItem;
    Saveas1: TMenuItem;

    procedure Exit1Click(Sender: TObject);
    procedure findClick1(Sender: TObject);
    procedure findtext1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Selectall2Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure paste_supplement_labels1Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Checksyntax1Click(Sender: TObject);
    procedure synedit1Change(Sender: TObject);
    procedure synedit1KeyPress(Sender: TObject; var Key: char);
    procedure synedit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure Undo1Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure edithelpClick(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure JPLOrbitalelementsconversion1Click(Sender: TObject);
    procedure replace1Click(Sender: TObject);
    procedure replace_all1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    Highlighter: TSynPositionHighlighter;{for synedit}
  end;


var
  edit2: Tedit2;
const
  errors :array[2..6,0..1] of integer=((0,0),(0,0),(0,0),(0,0),(0,0)); {contains position of line with errors}


Const
   font1        : string[25]='Arial';

  fontname_E: string ='Courier new';
  fontsize_E:integer=9;

  about_editor1 :string='HNSKY internal editor for comet, asteroid and supplement files. '+
                        'Modifications in editor will be automatically loaded in HNSKY. '+
                        'To make them permanent, save editor file. '+
                        'Editor could be slow above 10.000 objects.';
  about_editor2 :string='Hints:';
  about_editor3 :string='Use copy and paste functions to enter new data from other sources.';
  about_editor4 :string='To create new supplements, save spreadsheet data as CSV format.';

 {syntax check in editor}
  No_syntax_errors_found :string='No syntax errors found.';

  Check_out  :string= 'Check result';
  About_edit :string= 'About:';
  Lines_file :string= 'Lines';
  Size_file  :string= 'Size:';


function convert_MPCORB_line(txt : string): string;

implementation

uses hns_main, hns_Unon, hns_Unumint, hns_Uset, hns_Uast;

{$IFDEF fpc}
  {$R *.lfm}
{$ELSE} {delphi}
  {$R *.DFM}
{$ENDIF}

var
   ast1         :  packed record
                  name  : string[100];
                  year  : integer;
                  month : integer;
                  day   : real;
                  ecc   : real;
                  sma   : real;
                  inc   : real;
                  loa   : real;
                  aop   : real;
                  eqn   : real;
                  ma    : real;
                  h     : real;
                  g     : real;
                    end;
var
  caption_comet,caption_asteroid, caption_sup1,caption_sup2,caption_sup3,caption_sup4,caption_sup5 :string;
  Attr_red, Attr_blue: TtkTokenKind; {for highlighting}
  esc_pressed :boolean;

var
  xy0:tpoint=(x:1;y:1);//last position editor
  xy1:tpoint=(x:1;y:1);
  xy2:tpoint=(x:1;y:1);
  xy3:tpoint=(x:1;y:1);
  xy4:tpoint=(x:1;y:1);
  xy5:tpoint=(x:1;y:1);
  xy6:tpoint=(x:1;y:1);


procedure markerror(red : boolean);
var
  z,p1,p2 : integer;
  regel: string;
  sep  : char;
begin
  if errors[editfile,1]=0 {sellenght} then exit; {somehow if this is not there font selection does not work}

  with edit2.synedit1 do
  begin
    if red then
    begin
      {find data field in text}
      if editfile<=1 then sep:='|' else sep:=',';
      regel:=edit2.synedit1.lines[errors[editfile,0]];
      p1:=0;
      z:=0;
      while ((p1<length(regel)) and (z<errors[editfile,1]-1)) do
      begin
        p1:=posex(sep,regel,p1+1);  {find komma, so start data field}
        inc(z);
      end;
      p2:=posex(sep,regel,p1+1)-1;
      if p2<=0 then p2:=length(regel);

      edit2.Highlighter.AddToken(errors[editfile,0],p1,tkText);// mark with token
      edit2.Highlighter.AddToken(errors[editfile,0],p2,Attr_red);//  highlighted as Attr_red

      edit2.synedit1.CaretX :=p1+1;{go to position}
      edit2.synedit1.CaretXY:=point(p1+1,errors[editfile,0]+1);{go to error position}
    end
    else
    begin {clear red}
      edit2.highlighter.clearalltokens;
      edit2.synedit1.repaint;
    end;
  end;
end;
procedure Tedit2.Exit1Click(Sender: TObject);
begin
  edit2.close;   {normal this form is not loaded}
  mainwindow.setfocus;
end;
procedure replace_routine(do_replace,replace_all:boolean);
var
  mySearchTypes                  : tSynSearchOption;
  count                          : integer;
  start_pointer  : Tpoint;
begin
  with edit2 do
  begin
    with synedit1 do
    begin
      start_pointer:=synedit1.CaretXY;{start from caret}
      if replace_all then
      begin
         mySearchTypes :=(ssoReplaceAll);
         start_pointer:=point(1,1);
      end
      else
      if do_replace then
        mySearchTypes :=(ssoReplace)
      else
      mySearchTypes :=(ssoPrompt);

      count:=SynEdit1.SearchReplaceEx(findtext1.text, replacetext1.text,[mySearchTypes] ,start_pointer);
      if count=0 then
      begin
        synedit1.CaretXY:=Point(1,1);{go to beginning}
        MessageDlg(Concat('"', findtext1.text, '" ',not_found), mtwarning, [mbOk], 0);
      end;
    end;
  end;
end;

procedure Tedit2.findClick1(Sender: TObject);
begin
  replace_routine(false,false);
end;

procedure Tedit2.findtext1EditingDone(Sender: TObject);
begin
  if length(findtext1.text)>0 then
      findClick1(Sender);
end;

procedure Tedit2.FormCreate(Sender: TObject);
begin
  // create highlighter
  Highlighter:=TSynPositionHighlighter.Create(Self);


  // add some attributes
  Attr_red:=Highlighter.CreateTokenID('Attr_red',clRed,clNone,[fsBold]);
  Attr_blue:=Highlighter.CreateTokenID('Attr_blue',clBlue,clNone,[fsBold]);

  // use highlighter
  synedit1.Highlighter:=Highlighter;
end;

procedure Tedit2.FormDestroy(Sender: TObject);
begin
  Highlighter.destroy;
end;

procedure Tedit2.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then if toolbar1.visible then toolbar1.visible:=false else edit2.Exit1Click(nil);
end;

procedure Tedit2.FormShow(Sender: TObject);
begin
//remove  caption_comet:=striphotkey(mainwindow.Cometdataeditor.caption); {for title editor}
//remove  caption_asteroid:=striphotkey(mainwindow.Asteroiddataeditor.caption);
  caption_sup1:=striphotkey(mainwindow.Supplement1editor.caption);
  caption_sup2:=striphotkey(mainwindow.Supplement2editor.caption);
  caption_sup3:=striphotkey(mainwindow.Supplement3editor.caption);
  caption_sup4:=striphotkey(mainwindow.Supplement4editor.caption);
  caption_sup5:=striphotkey(mainwindow.Supplement5editor.caption);

  synedit1.font.size:=fontsize_E; {somehow this does not work with Tfont}
  synedit1.font.name:=fontname_E;
  case editfile of 2: begin
                        synedit1.text:= supplstring1.text; {important make in object inspector lines empty otherwise it does not work}
                        synedit1.CaretXY:=xy2;{go to last position}
                      end;
                   3:begin
                       synedit1.text:= supplstring2.text; {important make in object inspector lines empty otherwise it does not work}
                       synedit1.CaretXY:=xy3;{go to last position}
                     end;
                   4: begin
                        synedit1.text:= supplstring3.text; {important make in object inspector lines empty otherwise it does not work}
                        synedit1.CaretXY:=xy4;{go to last position}
                      end;
                   5: begin
                        synedit1.text:= supplstring4.text; {important make in object inspector lines empty otherwise it does not work}
                        synedit1.CaretXY:=xy5;{go to last position}
                      end;
                   6: begin
                        synedit1.text:= supplstring5.text; {important make in object inspector lines empty otherwise it does not work}
                        synedit1.CaretXY:=xy6;{go to last position}
                      end;
                  10: begin
                        synedit1.text:= foundstring1.text; {important make in object inspector lines empty otherwise it does not work}
                      end;
                   end;
                     {synedit1.Lines:=asteroidstring; is too slow }
end;


procedure Tedit2.replace1Click(Sender: TObject);
begin
  replace_routine(true,false);
end;
procedure Tedit2.replace_all1Click(Sender: TObject);
begin
  replace_routine(true,true);
end;





//A brief header is given below:
//Des'n     H     G   Epoch     M        Peri.      Node       Incl.       e            n           a        Reference #Obs #Opp    Arc    rms  Perts   Computer
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//00001    3.4   0.15 K205V 162.68631   73.73161   80.28698   10.58862  0.0775571  0.21406009   2.7676569  0 MPO492748  6751 115 1801-2019 0.60 M-v 30h Williams   0000      (1) Ceres              20190915
//00002    4.2   0.15 K205V 144.97567  310.20237  173.02474   34.83293  0.2299723  0.21334458   2.7738415  0 MPO492748  8027 109 1821-2019 0.58 M-v 28h Williams   0000      (2) Pallas             20190812
//00003    5.2   0.15 K205V 125.43538  248.06618  169.85147   12.99105  0.2569364  0.22612870   2.6682853  0 MPO525910  7020 106 1821-2020 0.59 M-v 38h Williams   0000      (3) Juno               20200109
//00004    3.0   0.15 K205V 204.32771  150.87483  103.80908    7.14190  0.0885158  0.27150657   2.3620141  0 MPO525910  6941 102 1821-2019 0.60 M-p 18h Williams   0000      (4) Vesta              20191229
//00005    6.9   0.15 K205V  17.84635  358.64840  141.57102    5.36742  0.1909134  0.23866119   2.5740373  0 MPO525910  2784  77 1845-2020 0.53 M-v 38h Williams   0000      (5) Astraea            20200105
//00006    5.7   0.15 K205V 190.68653  239.73624  138.64343   14.73966  0.2032188  0.26107303   2.4245327  0 MPO525910  5745  90 1848-2020 0.53 M-v 38h Williams   0007      (6) Hebe               20200110


function convert_MPCORB_line(txt : string): string;
var
  code2           : integer;
  date_regel      : string[5];
  centuryA,monthA,dayA : string[2];
  epochA          : string[15];
  designation     : string;
begin
  date_regel:=copy(txt,21,25-21+1); {21 -  25  a5     Epoch (in packed form, .0 TT), see http://www.minorplanetcenter.net/iau/info/MPOrbitFormat.html}
   //    date_regel:='J9611';
   //   1996 Jan. 1    = J9611
   //   1996 Jan. 10   = J961A
   //   1996 Sept.30   = J969U
   //   1996 Oct. 1    = J96A1
   //   2001 Oct. 22   = K01AM

  str(Ord(date_regel[1])-55:2,centuryA); // 'A'=65

  code2:=Ord(date_regel[4]);
  if code2<65 then code2:=code2-48 {1..9} else code2:=code2-55; {A..Z}
  monthA := Formatfloat('00', code2);{convert to string with 2 digits}

  code2:=Ord(date_regel[5]);
  if code2<65 then code2:=code2-48 {1..9} else code2:=code2-55; {A..Z}
  dayA := Formatfloat('00', code2); {convert to string with 2 digits}

  EpochA:=centuryA+date_regel[2]+date_regel[3]+monthA+dayA+'.000';

  if ((centuryA='19') or (centuryA='20') or (centuryA='21')) then {do only data}
  begin
    designation:=copy(txt,167,194-167+1);
    if copy(txt,6,1)<>' ' then //temporary provisional 7 digit designation, add to the name
    begin
      designation:=trim(designation)+' ('+copy(txt,1,7)+')'
    end;
    result:=designation+'|' {name}  {use asteroidsstring as buffer, faster then using lines[counter]:=}
    +epochA+'|'  {epoch}
    +copy(txt,71,79-71+1)+'|' {71 -  79  f9.7   Orbital eccentricity}

    +copy(txt,93,103-93+1)+'|' {93 - 103  f11.7  Semimajor axis (AU)}
    +copy(txt,60,68-60+1)+'|' {60 -  68  f9.5   Inclination to the ecliptic, J2000.0 (degrees)}
    +copy(txt,49,57-49+1)+'|' {49 -  57  f9.5   Longitude of the ascending node, J2000.0  (degrees)}
    +copy(txt,38,46-38+1)+'|' {38 -  46  f9.5   Argument of perihelion, J2000.0 (degrees)}
    +'2000|'    {equinox}
    +copy(txt,27,35-27+1)+'|' {27 -  35  f9.5   Mean anomaly at the epoch, in degrees}
    +copy(txt,9,13-9+1)+'|' {9 -  13  f5.2   Absolute magnitude, H}
    +copy(txt,15,19-15+1)+'|'; {15 -  19  f5.2   Slope parameter, G}
  end
  else
  result:=';'+txt;{add comment prefix}
end;



procedure Tedit2.Load1Click(Sender: TObject);
begin
  opendialog1.initialdir:=documents_path;
  case editfile of 2: begin
                        opendialog1.filename:=name_supl1;
                        opendialog1.Filter := 'HNSKY supplement files (*.sup)|*.sup|Comma delimited (*.csv)|*.csv';
                      end;
                   3: begin
                        opendialog1.filename:=name_supl2;
                        opendialog1.Filter := 'HNSKY supplement files (*.sup)|*.sup|Comma delimited (*.csv)|*.csv';
                      end;
                   4: begin
                        opendialog1.filename:=name_supl3;
                        opendialog1.Filter := 'HNSKY supplement files (*.sup)|*.sup|Comma delimited (*.csv)|*.csv';
                      end;
                   5: begin
                        opendialog1.filename:=name_supl4;
                        opendialog1.Filter := 'HNSKY supplement files (*.sup)|*.sup|Comma delimited (*.csv)|*.csv';
                      end;
                   6: begin
                        opendialog1.filename:=name_supl5;
                        opendialog1.Filter := 'HNSKY supplement files (*.sup)|*.sup|Comma delimited (*.csv)|*.csv';
                      end;
                   end; {case}
  if opendialog1.execute then
  begin
     filename:=opendialog1.filename;
     case editfile of 2:name_supl1:={ExtractFileName}(FileName);
                      3:name_supl2:={ExtractFileName}(FileName);
                      4:name_supl3:={ExtractFileName}(FileName);
                      5:name_supl4:={ExtractFileName}(FileName);
                      6:name_supl5:={ExtractFileName}(FileName);
                   end;{case}

     with synedit1.Lines do
     begin
       screen.cursor:=crHourglass;
       LoadFromFile(filename);	{ load from file }
       screen.cursor:=crdefault;
     end;
  end;
end;


Procedure Tedit2.Saveas1Click(Sender: TObject);
begin
  savedialog1.initialdir:=documents_path;{2015 doesn't work for win7 and higher, keep for winXP?}

  savedialog1.filename:=documents_path+'*.sup';
  savedialog1.Filter :='HNSKY supplement files (*.sup)|*.sup|';

  case editfile of 2:begin
                       if name_supl1<>'' then savedialog1.filename:=documents_path+name_supl1;
                     end;
                   3:begin
                       if name_supl2<>'' then savedialog1.filename:=documents_path+name_supl2;
                     end;
                   4:begin
                       if name_supl3<>'' then savedialog1.filename:=documents_path+name_supl3;
                     end;
                   5:begin
                       if name_supl4<>'' then savedialog1.filename:=documents_path+name_supl4;
                     end;
                   6:begin
                       if name_supl5<>'' then savedialog1.filename:=documents_path+name_supl5;
                     end;
                   end;
  if savedialog1.execute then
  begin
    if pos('.',savedialog1.filename)=0 then savedialog1.filename:=savedialog1.filename+'.sup';
    with synedit1.Lines do
        {$IFDEF fpc}
        SaveToFile(savedialog1.FileName {,TEncoding.UTF8}  );
        {$ELSE} {delphi}
        SaveToFile(savedialog1.FileName ,TEncoding.UTF8  );  { save to file }
        {$ENDIF}
        {When you expect to work with text which is mostly ASCII, but which may contain the occasional international text, use UTF8Strings. They use less memory and are reference counted in Delphi.}
    case editfile of
                   2:begin
                       name_supl1:=extractfilename(savedialog1.filename);
                     end;
                   3:begin
                       name_supl2:=extractfilename(savedialog1.filename);
                     end;
                   4:begin
                      name_supl3:=extractfilename(savedialog1.filename);
                     end;
                   5:begin
                       name_supl4:=extractfilename(savedialog1.filename);
                     end;
                   6:begin
                       name_supl5:=extractfilename(savedialog1.filename);
                     end;
                 end;
  end;
end;

procedure Tedit2.Save1Click(Sender: TObject);
begin
  case editfile of 2:begin
                       if name_supl1='' then begin edit2.saveas1click(sender);exit; end
                       else
                       filename:=name_supl1;
                     end;
                   3:begin
                       if name_supl2='' then begin edit2.saveas1click(sender);exit; end
                       else
                       filename:=name_supl2;
                     end;
                   4:begin
                       if name_supl3='' then begin edit2.saveas1click(sender);exit; end
                       else
                       filename:=name_supl3;
                     end;
                   5:begin
                       if name_supl4='' then begin edit2.saveas1click(sender);exit; end
                       else
                       filename:=name_supl4;
                     end;
                   6:begin
                       if name_supl5='' then begin edit2.saveas1click(sender);exit; end
                       else
                       filename:=name_supl5;
                     end;
                   end;

  if
  {$ifdef mswindows}
  (pos(':',filename)=0)
  {$ELSE}{linux}
  (pos('/',filename)=0)
  {$ENDIF}
  then {not a full path specified}
      filename:=documents_path+FileName;

  with synedit1.Lines do
  {$IFDEF fpc}
     SaveToFile(FileName{,TEncoding.UTF8} ); { save into backup file }
  {$ELSE} {delphi}
     SaveToFile(FileName,TEncoding.UTF8 ); { save into backup file }
   {$ENDIF}
   {When you expect to work with text which is mostly ASCII, but which may contain the occasional international text, use UTF8Strings. They use less memory and are reference counted in Delphi.}

  mainwindow.statusbar1.caption:='Saved: '+filename;
end;


procedure Tedit2.Font1Click(Sender: TObject);
begin
   fontdialog1.Font:=synedit1.Font;
   FontDialog1.Execute;
   synedit1.Font:=fontdialog1.Font;
   fontsize_E:=synedit1.Font.size;{save for next session}
   {carefull name fontsize is already used in delphi !!!!}
   fontname_E:=synedit1.Font.name;
end;



procedure Tedit2.FormDeactivate(Sender: TObject);
begin
//  if synedit1.modified then Save1Click(Sender);
//  synedit1.modified:=false;
  case editfile of
    2:begin
        supplstring1.clear;  {tstrings}
        supplstring1.text:=synedit1.text;{update string with synedit1}
        xy2:=synedit1.CaretXY;//store last position
      end;
    3:begin
        supplstring2.clear;  {tstrings}
        supplstring2.text:=synedit1.text;{update string with synedit1}
        xy3:=synedit1.CaretXY;//store last position
      end;
    4:begin
        supplstring3.clear;  {tstrings}
        supplstring3.text:=synedit1.text;{update string with synedit1}
        xy4:=synedit1.CaretXY;//store last position
      end;
    5:begin
        supplstring4.clear;  {tstrings}
        supplstring4.text:=synedit1.text;{update string with synedit1}
        xy5:=synedit1.CaretXY;//store last position
      end;
    6:begin
        supplstring5.clear;  {tstrings}
        supplstring5.text:=synedit1.text;{update string with synedit1}
        xy6:=synedit1.CaretXY;//store last position
      end;
    end;
end;



procedure JPL_Asteroid_Orbitalelementsconversion1Click;  {test for Firefox, Chrome and Edge}
var
   start1,stop1,fout,i                                               :integer;
   buffer1, date1,buf, e1,a1,i1,ohm1,w1,h1,g1, asteroid_name,anomoly1 :string;

   FUNCTION reformat(inp1:string):string;
   var  rr:double;
   begin
     inp1:=trim(inp1);
     val(inp1,rr,fout);
     if fout<>0 then  result:=error_string
     else
     str(rr:0:7,result);
   end;

   PROCEDURE report_error;
   begin
     edit2.synedit1.SelText :=error_string+', copy all text from https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html using ctrl+A & ctrl+C '+#10+#13;
   end;

begin
  date1:=''; e1:='';a1:='';i1:='';ohm1:='';w1:='';g1:='';  h1:='';asteroid_name:='';anomoly1:='';
  buffer1:=   Clipboard.AsText;

  if length(buffer1)>300 then
  begin


  //;Asteroid name            Epoch       Eccen-     Semi     Orbit   Longitude Argument Equinox Mean      Abs.  Magn   by HNSKY internally
  //;                                     tricity    major    incli   of the      of       of    anomoly   magn. slope  for skipping faint asteroids.
  //;                                                axis     nation  ascending  peri-   orbital                 para-  Magnitude range  [A..Z]
  //;                                                                  node     helion   elements                meter            equals [0..25]
  //;                                                                                                                   will be overwritten
  //;                     yyyy mm dd.ddd    e        a [ae]     i       ohm         w     [yyyy]             H     G    next time

  //     1 Ceres         |2014 12 09.000|0.075823  |2.767506| 10.5934| 80.3293 | 72.5220 | 2000| 95.9892  | 3.34| 0.12|J1

    start1:=pos('show instructions',buffer1);{find object name}
    stop1:=pos('Classification:',buffer1);
    if ((start1>0) and (stop1>0)) then asteroid_name:=copy(buffer1,start1+19,(stop1-2)-(start1+19)) {get object name. 2 for #13+#10}
    else
    begin
      report_error;
      exit;
    end;
    start1:=posex('Epoch',buffer1,stop1);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+6,9);
      date1:=JdToDate_2(strtofloat(buf));{use julian date}
    end;

    start1:=posex('Units',buffer1,start1);

    for i:=start1 to length(buffer1) do
      if buffer1[i]=#9 then buffer1[i]:=' '; {convert Chrome #9 to space as in firefox}

    start1:=posex('e ',buffer1,start1+5);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      e1:=reformat(buf);
    end;

    start1:=posex('a ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      a1:=reformat(buf);
    end;

    start1:=posex('i ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      i1:=reformat(buf);
    end;

    start1:=posex('node ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+5,17);
      ohm1:=reformat(buf);
    end;

    start1:=posex('peri ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+5,17);
      w1:=reformat(buf);
    end;

    start1:=posex('M ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      anomoly1:=reformat(buf);
    end;

    start1:=posex('[H] absolute magnitude',buffer1,start1+30);
    if start1>0 then
    begin
    buf:=copy(buffer1,start1+23,5);
     h1:=trim(buf);
    end;

    start1:=posex('[G] magnitude slope',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+20,5);
      g1:=trim(buf);
    end
    else
    g1:='0.15';


    edit2.synedit1.SelText := asteroid_name+' |'+date1+' |'+e1+' |'+a1+' |'+i1+' |'+ohm1+' |'+w1+'|2000 |'+anomoly1+' |'+h1+' |'+g1+#13;{Replace selected text with ReplaceText }
  end {buffer longer then 100}
  else
  begin {to short buffer}
    if length(buffer1)>1 then report_error;
  end;
end;


procedure JPL_Comet_Orbitalelementsconversion1Click;
var
   start1,stop1,shift,fout,i                                  :integer;
   buffer1, buf, perh_epoch, q1,e1,w1,ohm1,i1,h0,k1, asteroid_name :string;
   FUNCTION reformat(inp1:string):string;
    var  rr:double;
    begin
      inp1:=trim(inp1);
      val(inp1,rr,fout);
      if fout<>0 then  result:=error_string
      else
      str(rr:0:7,result);
    end;

    PROCEDURE report_error;
    begin
      edit2.synedit1.SelText :=error_string+', copy all text from https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html using ctrl+A & ctrl+C '+#10+#13;
    end;
begin
   perh_epoch:='';
   q1:='';
   e1:='';
   w1:='';
   ohm1:='';
   i1:='';
   h0:='';
   k1:='';
   asteroid_name:='';
  buffer1:=   Clipboard.AsText;
  if length(buffer1)>300 then
  begin
//                                       [yyyy]yyyymmdd.dddd   q [ae]       e        w         ohm          i     H0    k
//C/2013 US10 (Catalina)                 |2000|20151115.7213 | 0.822961 |1.000312 |340.3603 |186.1448 |148.8784 | 4.4 |10.0 | MPC 95731

    start1:=pos('show instructions',buffer1);{find object name}
    stop1:=pos('Classification:',buffer1);
    if ((start1>0) and (stop1>0)) then asteroid_name:=copy(buffer1,start1+17+2,(stop1-2)-(start1+17+2)) {get object name. 2 for #13+#10}
    else
    begin
      report_error;
      exit;
    end;

    shift:=pos('Units',buffer1);

    for i:=start1 to length(buffer1) do
      if buffer1[i]=#9 then buffer1[i]:=' '; {convert Chrome #9 to space as in firefox}


    start1:=posex('e ',buffer1,shift);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      e1:=reformat(buf);
    end;

    start1:=posex('q ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      q1:=reformat(buf);
    end;

    start1:=posex('i ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+2,17);
      i1:=reformat(buf);
    end;

    start1:=posex('node ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+5,17);
      ohm1:=reformat(buf);
    end;

    start1:=posex('peri ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+5,17);
      w1:=reformat(buf);
    end;

    start1:=posex('tp ',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+3,20);
      perh_epoch:=reformat(buf);
      perh_epoch:=JdToDate_2(strtofloat(perh_epoch));{use julian date}
    end;

    start1:=posex('[M1] comet total magnitude',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+27,5);
      h0:=trim(buf);
    end;

    start1:=posex('[K1] comet total magnitude slope',buffer1,start1+30);
    if start1>0 then
    begin
      buf:=copy(buffer1,start1+32,5);
      k1:=trim(buf);
    end;

     edit2.synedit1.SelText :=asteroid_name+' |2000|'+ perh_epoch+' |'+q1+' |'+e1+' |'+w1+' |'+ohm1+' |'+i1+' |'+h0+'|'+k1+#13;{Replace selected text with ReplaceText }

   end {buffer longer then 300}
   else
   begin {to short buffer}
     if length(buffer1)>1 then report_error;
   end;
end;

procedure Tedit2.JPLOrbitalelementsconversion1Click(Sender: TObject);
begin
  case editfile of
    0:
     begin
       JPL_Comet_Orbitalelementsconversion1Click
    end;
    1:begin
        JPL_Asteroid_Orbitalelementsconversion1Click
      end;
  end; {case}
end;

procedure Tedit2.Cut1Click(Sender: TObject);
begin
//  synedit1.CutToClipboard; {not implemented in Linux !!!}
  Clipboard.AsText:=synedit1.SelText;
  synedit1.SelText := '';{Replace selected text with nothing, Note richmemo.cuttoclipboard is not implemented in Linux}
end;

ProcedurE Tedit2.Copy1Click(SendEr: TObjEct);
beGin
//  synedit1.CopyToClIpboard; not implemented in Linux, use alternative solution
  Clipboard.AsText:=synedit1.SelText; {Note richmemo.copy to clipboard is not implemented in Linux}
end;


procedure Tedit2.Selectall2Click(Sender: TObject);
begin
    synedit1.selectall;
end;

procedure Tedit2.Paste1Click(Sender: TObject);
begin
  synedit1.SelText := Clipboard.AsText;{Replace selected text with ReplaceText, Note richmemo.pasteclipboard is not implemented in Linux }
end;

procedure Tedit2.paste_supplement_labels1Click(Sender: TObject);
var
   i, start1,stop1  :integer;
   buffer1,comments1,names1,orien1,width1 :string;
   oldCursor : TCursor;

begin
  esc_pressed:=false;
  oldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  buffer1:= Clipboard.astext;
  for i:=1 to length(buffer1) do
  begin {strip non- ascii chars}
    if ((buffer1[i] >= #43){+}  and (buffer1[i] <= #127))=false then
      buffer1[I] := ','
    else
    if ((buffer1[i]= #13){enter}  or (buffer1[i]=' ') or (buffer1[i]=';') or (buffer1[i]='/')) then
      buffer1[I] := ',';
  end;{strip non- ascii chars}
  start1:=1;
  if length(buffer1)>0 then
  begin
    repeat
      stop1:=posex(',',buffer1,start1);
      if ((stop1<>0) and (stop1-start1>=3)) then {something found}
      begin
        if esc_pressed then begin Screen.Cursor := oldCursor;  exit; end;{stop this suppelement filling}
        goto_str:=copy(buffer1,start1,stop1-start1);
        if ((ANSIContainsText(edit2.synedit1.text,','+goto_str)=false) and (ANSIContainsText(edit2.synedit1.text,'/'+goto_str)=false)) then {no duplicates in synedit1,  case insensitive search }
        if find_object(mainwindow.canvas,'D') then {find object in current deepsky database}
        begin
          if sender=paste_supplement_lines1 then names1:=naam2
             else
              names1:=naam2+'∇';
          if naam3<>'' then  names1:=names1+'/'+naam3;{add all names in name1}
          if naam4<>'' then  names1:=names1+'/'+naam4;{add all names in name1}

          if sender=paste_supplement_lines1 then
               begin
                 if orientation2=999 then  orien1:='' else orien1:=floattostr(orientation2);{remove 0 for space saving}
                 if width2=0 then  width1:='' else width1:=floattostr(width2);
                 edit2.synedit1.lines.add(comments1+
                             floattostr(ra2*12/pi)+',,,'
                           + floattostr(dec2*180/pi)+',,,'
                           + inttostr(mag2)
                           +','+names1
                           +','+spectr
                           +','+floattostr(brightn)  {import as label} {inttostr(brightn)}
                           +','+floattostr(length2)
                           +','+width1
                           +','+orien1+#13);  {info to synedit1}
               end
               else {labels}
               edit2.synedit1.lines.add(comments1+
                             floattostr(ra2*12/pi)+',,,'
                           + floattostr(dec2*180/pi)+',,,'
                           +','+names1
                           +','
                           +','+'-98'  {import as label} {inttostr(brightn)}
                           +#13);  {info to synedit1}
        end;
      end;
      start1:=stop1+1;
    until stop1=0;
  end;
  Screen.Cursor := oldCursor;
end;

procedure Tedit2.Search1Click(Sender: TObject);
begin
 if toolbar1.visible=false then
 begin
   toolbar1.Visible:=true;
   findtext1.SetFocus;
 end
 else
 toolbar1.visible:=false;{hide again}
end;

procedure Tedit2.About1Click(Sender: TObject);
var  linenr,size,ber                     : string;

begin
  str(synedit1.Lines.count,linenr);
  str(length(synedit1.text)/1024:0:0,size);
  ber:=
  about_editor1+#10+#13+#10+#13+
  about_editor2+#10+#13+
  about_editor3+#10+#13+
  about_editor4+
  #10+#13+
  #10+#13+linenr+'  '+lines_file+',    '+Size_file+' '+size+' [KBytes]';

  application.messagebox(pchar(ber),pchar(About_edit),MB_OK);
end;

Procedure Tedit2.FormActivate(Sender: TObject);
begin
  markerror(true);
  if language_mode<>0 then load_edit;
end;

procedure Tedit2.Checksyntax1Click(Sender: TObject);
var olddeep2: integer;
begin
  olddeep2:=deepnr;
  deepnr:=9999; {all}
  mag:=0;
  markerror(false);
  errors[editfile,1]:=0; {allow error finding}
  counter:=0;
  case editfile of
    2:begin {supplement 1}
        supplstring1.clear;  {tstrings}
        supplstring1.text:=synedit1.text;{update string with synedit1}
        repeat read_supplement('T',1);until mag=999;
      end;
    3:begin {supplement 2}
        supplstring2.clear;  {tstrings}
        supplstring2.text:=synedit1.text;{update string with synedit1}
        repeat read_supplement('T',2);until mag=999;
      end;
    4:begin
        supplstring3.clear;  {tstrings}
        supplstring3.text:=synedit1.text;{update string with synedit1}
        repeat read_supplement('T',3);until mag=999;
      end;
    5:begin
        supplstring4.clear;  {tstrings}
        supplstring4.text:=synedit1.text;{update string with synedit1}
        repeat read_supplement('T',4);until mag=999;
      end;
    6:begin
        supplstring5.clear;  {tstrings}
        supplstring5.text:=synedit1.text;{update string with synedit1}

        repeat
          read_supplement('T',5);
          until mag=999
      end;
    end;

  if errors[editfile,1]=0 then
      application.messagebox(pchar(No_syntax_errors_found),pchar(Check_out),MB_OK)
  else
    markerror(true);
  deepnr:=olddeep2;{return value}
end;

procedure Tedit2.synedit1Change(Sender: TObject);
begin

end;

procedure Tedit2.synedit1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then
    esc_pressed:=true;
end;

procedure Tedit2.synedit1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var  sx,sy:string;
  begin
    str(edit2.synedit1.CaretX:6 {selstart},sx);
    str(edit2.synedit1.CaretY:10 {selstart},sy);

    case editfile of 2: edit2.caption:=caption_sup1+':  '+name_supl1+ sy+':'+sx;
                     3: edit2.caption:=caption_sup2+':  '+name_supl2+ sy+':'+sx;
                     4: edit2.caption:=caption_sup3+':  '+name_supl3+ sy+':'+sx;
                     5: edit2.caption:=caption_sup4+':  '+name_supl4+ sy+':'+sx;
                     6: edit2.caption:=caption_sup5+':  '+name_supl5+ sy+':'+sx;
                     end;
end;

procedure Tedit2.Undo1Click(Sender: TObject);
begin
  synedit1.undo;
end;

procedure Tedit2.Selectall1Click(Sender: TObject);
begin
  synedit1.SelectAll;
end;


procedure Tedit2.edithelpClick(Sender: TObject);
begin
  open_file_with_parameters(help_path,'#supplements');
end;

end.

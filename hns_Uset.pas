unit hns_Uset;
{Copyright (C) 1997, 2024 by Han Kleijn, www.hnsky.org
 email: han.k.. at...hnsky.org }

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
  Windows,
 {$endif}
 {$ifdef unix}
  lclintf, {for getrvalue}
  LCLType, {for MB_YESNO}
  math,  // for min() function
 {$endif}

  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, inifiles ;


type
  {for internetlinks,  this lines before class(tform}
  TLabel = class(StdCtrls.TLabel)
    PROCEDURE CMMouseEnter( VAR Msg : TMessage ); MESSAGE CM_MOUSEENTER;
    PROCEDURE CMMouseLeave( VAR Msg : TMessage ); MESSAGE CM_MOUSELEAVE;
  end;
  //This way you are redefining TLabel and for this form you will
  //have their ancestors - This way to avoid installing new components.



  { TSettings }

  TSettings = class(TForm)
    alpaca_radiobutton1: TRadioButton;
    alpaca_adress1: TEdit;
    alpaca_telescope1: TEdit;
    alpaca_groupBox1: TGroupBox;
    asteroid_epoch1: TLabel;
    epoch1: TLabel;
    export_asteroids1: TButton;
    grp_import_export1: TGroupBox;
    grp_asteroid_database1: TGroupBox;
    Label14: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    import_asteroids1: TButton;
    SaveDialog1: TSaveDialog;
    grp_numerical_integration1: TGroupBox;
    col42: TLabel;
    col41: TLabel;
    col42_1: TLabel;
    col23: TLabel;
    no_telescope1: TRadioButton;
    num_integration1: TButton;
    ProgressBar1: TProgressBar;
    trackingmethod1: TComboBox;
    solartrackingmethod1: TGroupBox;
    internetcomet1: TComboBox;
    nr_asteroids_extracted1: TLabel;
    selectpath3: TBitBtn;
    selectpath4: TBitBtn;
    up_to_number1: TLabel;
    max_nr_asteroids1: TEdit;
    internetasteroid1: TComboBox;
    selectpath1: TBitBtn;
    documentspath1: TLabel;
    grs_offset3: TLabel;
    alpaca_port1: TEdit;
    alpaca_port_number1: TLabel;
    alpaca_telescope2: TLabel;
    interneteso: TEdit;
    internetLeda1: TEdit;
    internetmast: TEdit;
    internetNed: TEdit;
    internetsimbad: TEdit;
    internetskyview: TEdit;
    internetskyviewwide: TEdit;
    Jupiter_GroupBox1: TGroupBox;
    grs_offset1: TUpDown;
    Label11: TLabel;
    GroupBox_stars1: TLabel;
    selectpath2: TBitBtn;
    DE430_file_select1: TBitBtn;
    DE431_file_select1: TBitBtn;
    SpeedButton1: TSpeedButton;
    grs_offset2: TEdit;
    UpDown2: TUpDown;
    PageControl1: TPageControl;
    applybutton1: TBitBtn;
    Azimuth_degrees1: TCheckBox;
    Bevel1: TBevel;
    bright_limit: TUpDown;
    button_asteroid_update1: TBItBtN;
    button_comet_update1: TBItBtN;
    cancelbutton1: TBitBtn;
    applysave1: TBitBtn;
    Label_frame1: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    server_info1: TLabel;
    server_checkbox1: TCheckBox;
    click_on: TLabel;
    col1: TLabel;
    col10: TLabel;
    col11: TLabel;
    col12: TLabel;
    col13: TLabel;
    col14: TLabel;
    col14line: TLabel;
    col15: TLabel;
    col16: TLabel;
    col17: TLabel;
    col18: TLabel;
    col19: TLabel;
    col19line: TLabel;
    col2: TLabel;
    col20: TLabel;
    col20line: TLabel;
    col21: TLabel;
    col24: TLabel;
    col25: TLabel;
    col26: TLabel;
    col27: TLabel;
    col28: TLabel;
    col28line: TLabel;
    col29: TLabel;
    col3: TLabel;
    col30: TLabel;
    col30b: TLabel;
    col31: TLabel;
    col31line: TLabel;
    col32: TLabel;
    col33: TLabel;
    col34: TLabel;
    col35: TLabel;
    col36: TLabel;
    col37: TLabel;
    col38: TLabel;
    col39: TPanel;
    col4: TLabel;
    col40: TLabel;
    col40line: TLabel;
    col5: TLabel;
    col6: TEdit;
    col7: TEdit;
    col8: TLabel;
    col9: TLabel;
    colorpanel: TPanel;
    Colors_tab: TTabSheet;
    cometfiledate1: TLabel;
    dayl_saving1: TCheckBox;
    de430info: TLabel;
    DE430_file1: TEdit;
    DE430_GroupBox1: TGroupBox;
    DE430_on1: TCheckBox;
    DE431_file1: TEdit;
    dss1: TGroupBox;
    dssmask1: TEdit;
    EarlyFITS: TCheckBox;
    EarthcoversStars1: TCheckBox;
    east2: TRadioButton;
    server_port1: TEdit;
    server_host_address1: TLabel;
    server_port2: TLabel;
    server_title1: TLabel;
    server_host_address_edit1: TEdit;
    equinoxmap: TLabel;
    equinoxtelescope: TLabel;
    equinox_map1: TComboBox;
    equinox_telescope2: TComboBox;
    eso_link: TLabel;
    fonts1: TEdit;
    fonts2: TEdit;
    fonts3: TEdit;
    font_setting: TBitBtn;
    font_sizes1: TLabel;
    frequencyof: TLabel;
    gemini: TLabel;
    geminifontsize: TUpDown;
    grp_documents_path: TGroupBox;
    grp_equinox: TGroupBox;
    grp_fits: TGroupBox;
    grp_language_file: TGroupBox;
    grp_latitude: TGroupBox;
    grp_location: TGroupBox;
    grp_longitude: TGroupBox;
    grp_measuring: TGroupBox;
    grp_moon_and_horizon: TGroupBox;
    grp_pointing: TGroupBox;
    grp_screen: TGroupBox;
    grp_timezone: TGroupBox;
    grp_usno: TGroupBox;
    grp_mouse1: TGroupBox;
    height1: TEdit;
    height_label: TLabel;
    hnsky_link: TLabel;
    Image1: TImage;
    infofontsize: TUpDown;
    internet_tab: TTabSheet;
    inverse_colors: TBitBtn;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label_lo1: TLabel;
    Label_la1: TLabel;
    Label_NS1: TLabel;
    Label_EW1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lang_combobox1: TComboBox;
    latitude2: TEdit;
    leda_link: TLabel;
    location_tab: TTabSheet;
    longitude2: TEdit;
    MAST_link: TLabel;
    medium_limit: TUpDown;
    moon: TLabel;
    MooncoversStars1: TCheckBox;
    moonfontsize: TUpDown;
    mousewheelreverse1: TCheckBox;
    ned_link: TLabel;
    North2: TRadioButton;
    FontDialog1: TFontDialog;
    help_settings: TLabel;
    ColorDialog1: TColorDialog;
    new_charset: TLabel;
    parallax: TCheckBox;
    path_label: TLabel;
    show_plot_time1: TCheckBox;
    refraction: TCheckBox;
    reset_to_default: TBitBtn;
    screenupdate1: TUpDown;
    searchby1: TGroupBox;
    OpenDialog1:TOpenDialog;
    Settings_tab: TTabSheet;
    Shape1: TShape;
    simbad_link: TLabel;
    skyview_link: TLabel;
    south2: TRadioButton;
    supdate1: TEdit;
    telrad01: TEdit;
    telrad02: TEdit;
    telrad03: TEdit;
    telrad04: TEdit;
    telrad05: TEdit;
    timezone_shape: TShape;
    time_zone1: TComboBox;
    UCACpath1: TEdit;
    underline1: TLabel;
    update_TAB: TTabSheet;
    DeltaT_correction1: TCheckBox;
    vizier_server1: TComboBox;
    west2: TRadioButton;
    width1: TEdit;
    width_label: TLabel;


    {$IFDEF fpc}
    telescope_tab1: TTabSheet;
    server_tab1: TTabSheet;
    telescope_name_select1: TComboBox;
    connect_server_Button1: TBitBtn;
    disconnect_server_Button1: TBitBtn;
    indi_address1: TLabel;
    indi_port_number1: TLabel;
    select_telescope_name1: TLabel;
    Ascom_radiobutton1: TRadioButton;
    disconnect_telescope_button1: TBitBtn;
    connect_telescope_button1: TBitBtn;
    indi_radioButton1: TRadioButton;
    indi_host_address1: TEdit;
    indi_port1: TEdit;
    show_indi_client_button1: TBitBtn;
    INDI_groupBox1: TGroupBox;


    procedure alpaca_radiobutton1Change(Sender: TObject);
    procedure Ascom_radiobutton1Click(Sender: TObject);
    procedure import_asteroids1Click(Sender: TObject);
    procedure export_asteroids1Click(Sender: TObject);
    procedure num_integration1Click(Sender: TObject);
    procedure DE430_on1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure no_telescope1Change(Sender: TObject);
    procedure screenupdate1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure showlocation(Sender: TObject);
    procedure longitude2Exit(Sender: TObject);
    procedure telescope_name_select1CloseUp(Sender: TObject);
    procedure vizier_server1Change(Sender: TObject);
    procedure DE430_file1DblClick(Sender: TObject);

    procedure show_indi_client_button1Click(Sender: TObject);
    procedure disconnect_telescope_button1Click(Sender: TObject);
    procedure connect_telescope_button1Click(Sender: TObject);
    procedure connect_server_Button1Click(Sender: TObject);
    procedure disconnect_server_Button1Click(Sender: TObject);
    procedure indi_radioButton1Change(Sender: TObject);
    {$ELSE} {delphi}
    {$ENDIF}
    procedure underline1Click(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure reset_to_defaultClick(Sender: TObject);
    procedure inverse_colorsClick(Sender: TObject);
    procedure applysave1Click(Sender: TObject);
    procedure colorClick(Sender: TObject);
    procedure UCACpath1DblClick(Sender: TObject);
    procedure dssmask1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure font_settingClick(Sender: TObject);
    procedure fontsizeClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
    procedure Colors_tabShow(Sender: TObject);
    procedure Settings_tabShow(Sender: TObject);
    procedure internet_tabShow(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure location_tabShow(Sender: TObject);
    procedure internet_linkClick(Sender: TObject);
    procedure time_zone1Change(Sender: TObject);
    procedure filelist_comboboxDropDown(Sender: TObject);
    procedure button_comet_update1Click(Sender: TObject);
    procedure button_asteroid_update1Click(Sender: TObject);
    procedure limitClick(Sender: TObject; Button: TUDBtnType);
    procedure FormPaint(Sender: TObject);
    procedure show_plot_time1Click(Sender: TObject);


  private
    { Private declarations }

  public
    { Public declarations }
  end;


var
  Settings: TSettings;
  sure_string : string='Are you sure ?';
const
      fontsize1 : integer=7;
      fontsize2 : integer=8;
      fontsize3 : integer=8;
      gridstep  : integer =1;
      page_settings : integer =0;

      showfullindicommunication: boolean=false;
      internet_eso : string='http://archive.eso.org/dss/dss?mime-type=download-fits&equinox=J2000&Sky-Survey=DSS1';
      internet_skyview : string='https://skyview.gsfc.nasa.gov/cgi-bin/pskcall?return=fits&sampler=Lanczos&Survey=DSS2R';
      internet_skyview_wide : string='https://skyview.gsfc.nasa.gov/cgi-bin/pskcall?return=fits&sampler=Lanczos&Survey=MELL-R';
      internet_mast : string='http://archive.stsci.edu/cgi-bin/dss_search?v=3';

      internet_asteroid : string='https://minorplanetcenter.net/iau/MPCORB/MPCORB.DAT';
      asteroids_maxnr: string='1000';

      internet_comet :string='https://minorplanetcenter.net/iau/MPCORB/CometEls.txt';
      internet_simbad :string='http://simbad.u-strasbg.fr/simbad/sim-sam?submit=submit+query&maxObject=1000&Criteria=(Vmag<15+|+Bmag<15+)';
      internet_leda :  string='http://atlas.obs-hp.fr/hyperleda/fG.cgi?n=a000&c=o&ob=ra&sql=bt<18';
      internet_ned : string='http://ned.ipac.caltech.edu/cgi-bin/nph-objsearch?search_type=Near+Position+Search&img_stamp=YES&radius=';
      internet_link:integer=1;
      language_module: string='';{hns_uk.ini}


implementation
{$IFDEF fpc}
  {$R *.lfm}
{$ELSE} {delphi}
  {$R *.lfm}
{$ENDIF}

uses hns_main, hns_unon, hns_Utim, hns_Ucen, hns_uast, hns_uDE, hns_Uedi, hns_Unumint
    {$IFDEF fpc}
     ,hns_indi, hns_alpaca
     {$ELSE} {delphi}
     {$ENDIF}
     ;

var
   north3,south3,west3,east3  : string;
   numerical_int_running : boolean=false;


procedure TSettings.connect_server_Button1Click(Sender: TObject);
begin
  settings.telescope_name_select1.items.clear;{clear drivers from list box}
  INDI_server_address:=indi_host_address1.text; {localhost}
  INDI_port:=indi_port1.text;{7624}
  indi_client_on(true);

  telescope_name_select1.items.clear; {remove devices list, allow update}
  if indi<>nil then //if form exists
    indi.telescope_name_select2.items.clear; {remove devices list, allow update}
  request_indi_properties;{ask server for an update and therefore start to rebuild}
end;


procedure TSettings.connect_telescope_button1Click(Sender: TObject);
begin
  if indi_client_connected then
  begin
    INDI_telescope_name:=telescope_name_select1.text;
    connect_indi_device(indi_telescope_name);
  end;
end;


procedure TSettings.show_indi_client_button1Click(Sender: TObject);
begin
  indi.visible:=true;
  indi.setfocus;
end;


procedure TSettings.disconnect_telescope_button1Click(Sender: TObject);
begin
  disconnect_indi_device(indi_telescope_name);{in indi form}
end;


procedure TSettings.disconnect_server_Button1Click(Sender: TObject);
begin
  indi_client_on(false);
end;


procedure TSettings.indi_radioButton1Change(Sender: TObject);
begin
  if indi_radioButton1.checked then
  begin
    telescope_interface:='I';
    alpaca_groupBox1.enabled:=false;
    switch_alpaca_client_onoff(false);
    INDI_groupBox1.enabled:=true;
    indi_client_on(true);
  end;
end;


function time_zone_name(auto_timezone:boolean; time_zone1:double): string;
var
   timez :integer;
begin
  result:='';
  timez:=round(time_zone1);
  if auto_timezone then
    case timez of -8 : result:='PST/PDT';
                  -7 : result:='MST/MDT';
                  -6 : result:='CST/CDT';
                  -5 : result:='EST/EDT';
                  -4 : result:='AST/ADT';
                   0 : result:='GMT/BST';
                  +1 : result:='CET/CEST';
                  end;{case}
 if result='' then
    result:=floattostrF_local(time_zone1,4,4);
end;
procedure time_zone_number(text1:string; var auto_timezone:boolean; var time_zone1:double);
var
   err: integer;
begin
  auto_timezone:=false;
  val_local(text1,time_zone1,err);
  if err<>0 then {do auto mode}
  begin
    if text1='PST/PDT'  then begin time_zone1:=-8;auto_timezone:=true;end else
    if text1='MST/MDT'  then begin time_zone1:=-7;auto_timezone:=true;end else
    if text1='CST/CDT'  then begin time_zone1:=-6;auto_timezone:=true;end else
    if text1='EST/EDT'  then begin time_zone1:=-5;auto_timezone:=true;end else
    if text1='AST/ADT'  then begin time_zone1:=-4;auto_timezone:=true;end else
    if text1='GMT/BST'  then begin time_zone1:= 0;auto_timezone:=true;end else
    if text1='CET/CEST' then begin time_zone1:=+1;auto_timezone:=true;end else
                             begin time_zone1:= 0;auto_timezone:=false;end;{don't know}
  end;
end;


procedure TSettings.Ascom_radiobutton1Click(Sender: TObject);
begin
  if Ascom_radiobutton1.checked=true then
  begin
    telescope_interface:='A';
    INDI_groupBox1.enabled:=false;

    indi_client_on(false);
    switch_alpaca_client_onoff(false);
  end;
end;



procedure TSettings.export_asteroids1Click(Sender: TObject);
var
   f :text;
   i  : integer;
   line : string;
const
   mpc : string[31]='123456789ABCDEFGHIJKLMNOPQRSTUV';

begin
//  Des'n     H     G   Epoch     M        Peri.      Node       Incl.       e            n           a        Reference #Obs #Opp    Arc    rms  Perts   Computer
//
//  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
//  00001    3.34  0.15 K243V 102.95074   73.36090   80.25352   10.58760  0.0790273  0.21412733   2.7670775  0 E2024-C06  7335 124 1801-2023 0.65 M-v 30k MPCLINUX   0000      (1) Ceres              20230618
//  00002    4.12  0.15 K243V  83.32723  310.88725  172.91472   34.92284  0.2303399  0.21373952   2.7704235  0 E2024-DC2  8902 123 1804-2024 0.59 M-c 28k MPCLINUX   0000      (2) Pallas             20240223
//  00003    5.17  0.15 K243V  82.18651  247.77596  169.84069   12.98975  0.2561868  0.22595087   2.6696851  0 E2024-D99  7520 117 1804-2024 0.63 M-v 3Ek MPCLINUX   0000      (3) Juno               20240221
//  00004    3.25  0.15 K243V 223.65556  151.69316  103.70488    7.14391  0.0898971  0.27168892   2.3609571  0 E2024-DA5  7607 111 1821-2024 0.63 M-p 18k MPCLINUX   0000      (4) Vesta              20240221


  savedialog1.filename:='MPCORB, epoch '+Formatfloat('0000',year2)+'-'+Formatfloat('00',month2)+'-'+Formatfloat('00',day2);
//  savedialog1.initialdir:=documents_path;
  savedialog1.Filter := '*.dat files (*.dat)|*.dat';
  if savedialog1.execute then
  begin
    system.assign(f,savedialog1.filename);
    rewrite(f);//use a simple bassic text routine
    for i:=0 to length(asteroids)-1 do
    begin
      line:=format('%-7s',[asteroids[i].desn]);
      line:=line+format(' %5.2f',[asteroids[i].H]);
      line:=line+format(' %5.2f',[asteroids[i].G]);
      if frac(asteroids[i].dd)<>0 then
                     begin beep;exit;end;//fractions can not be stored in MPCORB.dat. Will give invalid results
      line:=line+' '+char(55+(asteroids[i].yy div 100))+copy(inttostr(asteroids[i].yy),3,2)+mpc[asteroids[i].mm]+mpc[round(asteroids[i].dd)];  //epoch. Weird MPC logic. Why two characters for year and one for the century?
      line:=line+format('%10.5f',[asteroids[i].M_anomaly]);
      line:=line+format('%11.5f',[asteroids[i].aop]); //Peri
      line:=line+format('%11.5f',[asteroids[i].ohm]);//Node
      line:=line+format('%11.5f',[asteroids[i].inc]); //Incl.
      line:=line+format('%11.7f',[asteroids[i].ecc]); //ecc

      line:=line+'  0.21412733'; //Not used by HNSKY, Mean daily motion (degrees per day) Use Ceres as dummy

      line:=line+format(' %11.7f',[(asteroids[i].sma)]);

      line:=line+'  0 E2024-C06  7335 124 2000-2024 0.65 M-v 30k __HNSKY_   0000 '; // not updated
      line:=line+format('%-27s',[asteroids[i].name]);
      line:=line+Formatfloat(' 0000',year2)+Formatfloat('00',month2)+Formatfloat('00',day2);
      writeln(f,line);

      //  Des'n     H     G   Epoch     M        Peri.      Node       Incl.       e            n           a        Reference #Obs #Opp    Arc    rms  Perts   Computer
      //
      //  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
      //  00001    3.34  0.15 K243V 102.95074   73.36090   80.25352   10.58760  0.0790273  0.21412733   2.7670775  0 E2024-C06  7335 124 1801-2023 0.65 M-v 30k MPCLINUX   0000      (1) Ceres              20230618
    end;
    system.close(f);
  end;
end;

//save all in a single write operation
procedure Save_asteroids(const aFileName:String; var aRecords:Tasteroid_array);
var
  vFile  : TFileStream;
  vTotal : cardinal;
begin
  vFile := TFileStream.Create(aFilename,fmCreate or fmOpenWrite);
  try
    vTotal := SizeOf(Tasteroid) * (High(aRecords)-Low(aRecords));
    vFile.Size := vTotal;
    vFile.Seek(0,0);
    vFile.Write(aRecords[Low(aRecords)], vTotal);
  finally
    vFile.Free;
  end;
end;

procedure Save_comets(const aFileName:String; var aRecords:Tcomet_array);
var
  vFile  : TFileStream;
  vTotal : cardinal;
begin
  vFile := TFileStream.Create(aFilename,fmCreate or fmOpenWrite);
  try
    vTotal := SizeOf(Tcomet) * (High(aRecords)-Low(aRecords));
    vFile.Size := vTotal;
    vFile.Seek(0,0);
    vFile.Write(aRecords[Low(aRecords)], vTotal);
  finally
    vFile.Free;
  end;
end;


procedure TSettings.num_integration1Click(Sender: TObject);
var i,nrasteroids           :integer;
begin
  if (IDNO= Application.MessageBox(pchar('Only required if you want to have accurate values for the past or future. Numerical integration of the asteroid database to a new epoch is CPU intensive and could take a lot of time!'+#10+
                                   'You can stop by the cancel button.'+#10+#10+
                                   'From epoch '+Formatfloat('0000',asteroids[0].yy)+'-'+Formatfloat('00',asteroids[0].mm)+' '+Formatfloat('00',asteroids[0].dd)+'to '+Formatfloat('0000',year2)+'-'+Formatfloat('00',month2)+'-'+Formatfloat('00',DAY2)+#10+
                                   'Duration estimate '+formatfloat('######0.0',length(asteroids)*abs((asteroids[0].yy+asteroids[0].dd/12)-(year2+month2/12))/2000000)+ ' hour'+#10+

                                   'Continue ?'),
                                   'Numerical integration', MB_ICONQUESTION + MB_YESNO)) then exit;

  settings.update_TAB.cursor:=crHourglass;//settings.cursor doesn't work
  Application.ProcessMessages;

  ProgressBar1.position:=0; //prevent runtime error if routine is called from editor


  {  Tasteroid =  record
                   desn    : string[7]; //fixed size for disk storage
                   name    : string[28];//fixed size for disk storage
                   yy,mm   : integer;//year month
                   dd, //day
                   e,  / ecc
                   a,
                   i,
                   ohm,
                   w,
                   M_anomaly,
                   H,
                   G : double
                 end;}


  numerical_int_running:=true;
  nrasteroids:=length(asteroids)-1;
  for i:=0 to nrasteroids do
  begin
    //  (NUMINT_ASTEROID(1983,09,23.0, {OLD EPOCH}
    //                   old                   new not so accurate. HNSKY is better using accurate planet positions
    //                   2.7657991,    {a}     2.7674385
    //                   0.0785650,    {e}     0.0765551
    //                  10.60646,      {i}     10.59999
    //                  80.05225,      {ohm}   80.67649
    //                  73.07274,      {w}     71.11469
    //                 174.19016,      {anomoly} 141.46349
    //                 1950.0,         {old equinox}  2000
    //                 1992,           {new epoch}
    //                 06,
    //                 27.000,


{   asteroids[i].yy:=1992;
    asteroids[i].mm:=06;
    asteroids[i].dd:=27;
    asteroids[i].a:=2.7657991;
    asteroids[i].e:=0.0785650;
    asteroids[i].i:=10.60646;
    asteroids[i].ohm:=80.05225;
    asteroids[i].w:=73.07274;
    asteroids[i].m_anomaly:=174.19016;

    asteroids[i].yy:=1983;
    asteroids[i].mm:=09;
    asteroids[i].dd:=23.000;
    oldeqn:=1950;
    year2:=1992;
    month2:=06;
    day2:=27;
    hour2:=0;}



    {calculates new  orbital elements  for  asteroids}
    NUMINT_ASTEROID(year2, month2, day2 {new epoch tonight, strictly local time but that doesn't matter since data is a few months good. Do not use hours since it is NOT stored in MPCORB.DAT}
       ,2000 {old eqn}, 2000 {new eqn},
       {var} asteroids[i].yy, asteroids[i].mm,asteroids[i].dd, asteroids[i].sma, asteroids[i].ecc,asteroids[i].inc,asteroids[i].ohm, asteroids[i].aop, asteroids[i].m_anomaly);

    if frac(i/100)=0 then
    begin
      settings.ProgressBar1.position:=round(100*i/nrasteroids);
      application.processmessages;
      if numerical_int_running=false then  //stopped by cancel button
      begin
         loadasteroid;//restore database
         settings.update_TAB.cursor:=crdefault;
         exit;//stopped by cancel button
      end;
    end;

  end;
  settings.ProgressBar1.position:=0;

  asteroidfile_age:=formatfloat('0000',asteroids[0].yy)+'-'+formatfloat('00',asteroids[0].mm)+ '-'+formatfloat('00',asteroids[0].dd);
  settings.asteroid_epoch1.caption:= asteroidfile_age;
 // invalidaterect(settings.handle,nil,true);  {refresh to show new dates}

  save_asteroids(documents_path+'hns_ast.ast', asteroids);
  settings.update_TAB.cursor:=crdefault;
end;


procedure check_de430_files(activated : boolean);
begin
  if ((activated=false) or (FileExists(de430_file))) then settings.DE430_file1.color:=cldefault else settings.DE430_file1.color:=clred;
  if ((activated=false) or (FileExists(de431_file))) then settings.DE431_file1.color:=cldefault else settings.DE431_file1.color:=clred;
end;


procedure TSettings.DE430_on1Change(Sender: TObject);
begin
  check_de430_files(de430_on1.checked);
end;


procedure TSettings.alpaca_radiobutton1Change(Sender: TObject);
var
   alp : boolean;
begin
  alp:=Alpaca_radiobutton1.checked;
  alpaca_groupBox1.enabled:=alp;
  if alp then
  begin
    telescope_interface:='C';
    INDI_groupBox1.enabled:=false;

    indi_client_on(false);
    switch_alpaca_client_onoff(true);
  end;
end;


procedure TSettings.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then CancelClick(nil);{close form, set form key preview on}
end;

procedure TSettings.no_telescope1Change(Sender: TObject);
begin
  if no_telescope1.checked then
  begin
    telescope_interface:=' ';

    alpaca_groupBox1.enabled:=false;
    switch_alpaca_client_onoff(false);

    INDI_groupBox1.enabled:=false;
    indi_client_on(false);
  end;
end;


procedure TSettings.screenupdate1Changing(Sender: TObject;  var AllowChange: Boolean);
begin
  if screenupdate1.position<=30 then screenupdate1.increment:=5
  else
  if screenupdate1.position<=60 then screenupdate1.increment:=10
  else
  if screenupdate1.position<=120 then screenupdate1.increment:=20
  else
  screenupdate1.increment:=60;
end;


procedure TSettings.vizier_server1Change(Sender: TObject);
begin
  vizier_server:=trim(vizier_server1.text);
end;

procedure TSettings.DE430_file1DblClick(Sender: TObject);
begin
  OpenDialog1.title:='Select *.430 or *.431 file';
  OpenDialog1.Filename:='*.4*';
  OpenDialog1.initialdir:=documents_path;
  OpenDialog1.Filter := 'Jet Propulsion Laboratory Development Ephemeris files|*.4*';
  if OpenDialog1.execute then
  begin
     if sender=DE430_file_select1 then
       DE430_file1.text:=OpenDialog1.filename
     else
     if sender=DE431_file_select1 then
       DE431_file1.text:=OpenDialog1.filename;
  end;
end;

procedure TSettings.show_plot_time1Click(Sender: TObject);
begin
  if show_plot_time1.checked then showplottime:=true else showplottime:=false;
end;

procedure TSettings.OKClick(Sender: TObject);
var  err      :integer;
begin
  numerical_int_running:=false;//stop any numerical integration
  err:=0;
  begin
    val_local(latitude2.text,reallatitude,err);
    if abs(reallatitude)>90 then err:=1;


    if err=0 then
    begin
      val_local(longitude2.text,longitude,err);
      if abs(longitude)>360 then err:=1;
      if err=0 then
      begin
        if (west2.checked)=false then longitude:=-longitude;

        time_zone_number(time_zone1.text, dst_auto, timezone);

        begin
          if (north2.checked) then northc:=1 else northc:=-1;
          if reallatitude<0 then northc:=-northc;
          reallatitude:=northc*abs(reallatitude);
          if dayl_saving1.checked then daylight_saving:=1 else daylight_saving:=0;
          if DeltaT_correction1.checked then
          begin
            Time_Reference:='UTC';
            settime.DeltaT_correction2.checked:=true;{time menu}
          end
            else
          begin
            Time_Reference:='TDT';
            settime.DeltaT_correction2.checked:=false;{time menu}
          end;

          if equinox_map1.ItemIndex=0 then equinox:=2000
          else
          if equinox_map1.ItemIndex=1 then equinox:=1 {mean}
          else
          if equinox_map1.ItemIndex=2 then equinox:=0 {apparent}
          else
          if equinox_map1.ItemIndex=3 then equinox:=9999
          else
          if equinox_map1.ItemIndex=4 then equinox:=1950;
          // Ascom numbering followed
          //  equOther	0	Custom or unknown equinox and/or reference frame.
          //	equLocalTopocentric	1	Local topocentric; this is the most common for amateur telescopes.
          //	equJ2000	2	J2000 equator/equinox, ICRS reference frame.
          //	equJ2050	3	J2050 equator/equinox, ICRS reference frame.
          //	equB1950	4	B1950 equinox, FK4 reference frame.
          if equinox_telescope2.ItemIndex=0 then equinox_telescope:=0 {follow ascom numberings}
          else
          if equinox_telescope2.ItemIndex=1 then equinox_telescope:=0
          else
          if equinox_telescope2.ItemIndex=2 then equinox_telescope:=2000
          else
          if equinox_telescope2.ItemIndex=3 then equinox_telescope:=2050
          else
          if equinox_telescope2.itemindex=4 then equinox_telescope:=1950;

          if parallax.checked then parallax2:=1 else parallax2:=0;
          if refraction.checked then apparent_horizon:=(- 34.5/60)*(pi/180) else apparent_horizon:=0;
          path_ucac4:=UCACpath1.text; if ((length(path_ucac4)>0) and (path_ucac4[length(path_ucac4)]<>PathDelim)) then path_ucac4:=path_ucac4+PathDelim;
          dss_mask:=dssmask1.text;
          de430_file:=DE430_file1.text;
          de431_file:=DE431_file1.text;

          internet_eso:=interneteso.text;
          internet_skyview:=internetskyview.text;
          internet_skyview_wide:=internetskyviewwide.text;
          internet_mast:=internetmast.text;

          internet_asteroid:=internetasteroid1.text;
          asteroids_maxnr:=max_nr_asteroids1.text;

          internet_comet:=internetcomet1.text;
          internet_simbad:=internetsimbad.text;
          internet_leda:=internetLeda1.text;
          internet_ned:=internetned.text;
          timestep:=screenupdate1.position;
        end;
      end;
    end;
  end;
  if err=0 {else continue till no error}
  then
  begin {leave}
    {do now none error relevant}
    val_local(telrad01.text,telrad[1],err);
    val_local(telrad02.text,telrad[2],err);
    val_local(telrad03.text,telrad[3],err);
    val_local(telrad04.text,telrad[4],err);
    val_local(telrad05.text,telrad[5],err);

    val_local(height1.text,frame_height,err);
    val_local(width1.text,frame_width,err);

    page_settings:=pagecontrol1.activepage.pageindex;
    if lang_combobox1.itemindex>=0 then {change}
    begin
      labelstring.free; {for non-english module}
      language_module:=lang_combobox1.text;
      labelstring := TmemIniFile.Create(lang_combobox1.text);{meminifile much faster then tinifile}
      language_mode:=1;
      load_main; {language module, here before errors are reported in following load databases}
      if language_mode<>0 then {no errors, continue load  other language modules}
      begin {otherlanguage modules}
        load_general;
        load_popup;
        load_popup_mainmenu;
        load_center;
        load_goto;
        load_object;
        load_time;
        load_animation;
        update_button_hints;{copy mainmenu hints to buttons}
      end;
    end;
    help_path:=ExpandFileName(help_path); {expand to full path for internet explorer}

    if mousewheelreverse1.checked then mouse_wheel_reverse:=1 else mouse_wheel_reverse:=0;
    if mooncoversstars1.checked then moon_covers_stars:=1 else moon_covers_stars:=0;
    if earthcoversstars1.checked then earth_covers_stars:=1 else earth_covers_stars:=0;
    if azimuth_degrees1.checked then azimuth_degrees:=1 else azimuth_degrees:=0;
    grs_offset:=grs_offset1.position;{jupiter grs}

    if DE430_on1.checked then de430_emphemeris:=1 else de430_emphemeris:=0;{use JPL emphmerides?}
    if de430_loaded then
    begin
      close_de_file; {close de430 filestream for case another file is selected}
      de430_loaded:=false;
    end;

    INDI_server_address:=indi_host_address1.text; {localhost}
    INDI_port:=indi_port1.text;{7624}
    INDI_telescope_name:=telescope_name_select1.text;

    server_address:=server_host_address_edit1.text;
    server_port:=server_port1.text;{7700}
    if  server_on<>server_checkbox1.Checked then switch_server_onoff(server_checkbox1.Checked);{start or stop server if changed}
    server_on:=server_checkbox1.Checked;{store setting}

    alpaca_address:=alpaca_adress1.text;{127.0.0.1}
    alpaca_port:=alpaca_port1.text;{11111}
    alpaca_telescope:=alpaca_telescope1.text;{0}

    trackingmethod:=trackingmethod1.itemindex;

    settings.close;
    mainwindow.setfocus;
    missedupdate:=2;{rewrite window}

    mainwindow.toolbar2.font.color:=colors[27];{repaint changed colors tool bar}
    mainwindow.statusbar1.font.color:=colors[25];

    getdatetime(actualtime,false); {recalculate with new data}
  end;
  if settings.EarlyFITS.checked=true then
                 Zoom_show_DSS:=1 else Zoom_show_DSS:=4;

  {$ifdef fpc}
  {$else} {delphi}
  {$endif}
end;

procedure TSettings.CancelClick(Sender: TObject);
begin
  {!! important set borderstyle of form at bsdialog. Then background is recovered by windows !!!}
  numerical_int_running:=false;//stop any numerical integration
  settings.close;
  mainwindow.setfocus;
end;
procedure showcolors;
begin
  with settings do
  begin
    colorpanel.color:=colors[0];
    col1.color:=colors[1];
    col33.color:=colors[33];
    col32.color:=colors[32];

    col2.color:=colors[2];
    col3.color:=colors[3];
    col4.color:=colors[4];

    col5.color:=colors[5];{faint deep}
    col5.font.color:=colors[8];{2015 faint deep font}

    col6.color:=colors[6];{medium deep}
    col6.font.color:=colors[9];{2015 medium deep font}

    medium_limit.position:=limit_deep_medium_color; {did not use associate while click on edit also resulted in an click event for updown resulting in a loop}


    col7.color:=colors[7];{bright deep}
    col7.font.color:=colors[10];{2015 bright deep font}
    bright_limit.position:=limit_deep_bright_color;

    col8.font.color:=colors[8];
    col9.font.color:=colors[9];
    col10.font.color:=colors[10];{bright deep font}

    col11.font.color:=colors[11];
    col12.color:=colors[12];{asteroids}
    col37.font.color:=colors[37];{asteroids text}
    col13.color:=colors[13];{comets}
    col38.font.color:=colors[38];{comets text}
    col14.font.color:=colors[14];{limb and moon orbits}
    col14line.font.color:=colors[14];{limb and moon orbits}
    col15.color:=colors[15];{uranus...}
    col36.font.color:=colors[36];
    col34.color:=colors[34];
    col35.font.color:=colors[35];

    col16.font.color:=colors[16];
    col17.font.color:=colors[17];
    col18.font.color:=colors[18];  moon.font.color:=colors[18];

    col19.font.color:=colors[19];
    col19line.font.color:=colors[19];
    col20.font.color:=colors[20];
    col20line.font.color:=colors[20];
    col21.font.color:=colors[21];

    col23.caption:='⮑';
    col23.font.color:=colors[23];

    col24.font.color:=colors[24];
    col25.font.color:=colors[25];
    mainwindow.statusbar1.font.color:=colors[25];

    col26.font.color:=colors[26]; gemini.font.color:=colors[26];

    col27.font.color:=colors[27];
    col28.font.color:=colors[28];
    col28line.font.color:=colors[28];
    col29.font.color:=colors[29]; {RA/DEC grid text color}

    col30.color:=colors[30];{dss}
    col30b.font.color:=colors[30];{dss}
    col31.color:=colors[31];{Horizon line}
    col31line.font.color:=colors[31];{Horizon line}
    col39.color:=colors[39]; {menu color}
    col39.font.color:=colors[27];

    col40.font.color:=colors[40];{mikyway line color}
    col40line.font.color:=colors[40];{mikyway line color}
    col41.color:=colors[41];{dss}
    col42.font.color:=colors[42];{found marker}
    col42_1.font.color:=colors[42];{found marker}

    mainwindow.toolbar2.font.color:=colors[27];
  end;

end;
procedure show_fonts;
var
  s:string;
begin
  with settings do
  begin
    CharsetToIdent(font_charset,s);
    label1.text:=s;

    font_setting.caption:=font_name;

    colorpanel.Font.name:=font_name;
    colorpanel.Font.charset:=font_charset;

    moon.font.name:=font_name;
    moon.font.charset:=font_charset;
    moon.font.style:=font_style;{2013}
    gemini.font.name:=font_name;
    gemini.font.charset:=font_charset;
    col27.font.name:=font_name;
    col27.font.charset:=font_charset;
    col25.font.name:=font_name;
    col25.font.charset:=font_charset;

    col29.font.name:=font_name;
    col29.font.charset:=font_charset;
    col26.font.name:=font_name;
    col26.font.charset:=font_charset;
    col28.font.name:=font_name;
    col28.font.charset:=font_charset;
    col20.font.name:=font_name;
    col20.font.charset:=font_charset;
    col19.font.name:=font_name;
    col19.font.charset:=font_charset;


    col40.font.name:=font_name; {milky way lines}
    col40.font.charset:=font_charset;

    col16.font.name:=font_name;
    col16.font.charset:=font_charset;
    col14.font.name:=font_name;
    col14.font.charset:=font_charset;
    col10.font.name:=font_name;
    col10.font.charset:=font_charset;
    col7.font.charset:=font_charset;{nieuw 2015}


    col9.font.name:=font_name;
    col9.font.charset:=font_charset;
    col6.font.charset:=font_charset;{nieuw 2015}


    col8.font.name:=font_name;
    col8.font.charset:=font_charset;
    col5.font.charset:=font_charset;

    col30b.font.name:=font_name;
    col30b.font.charset:=font_charset;
    col24.font.name:=font_name;
    col24.font.charset:=font_charset;
    col37.font.name:=font_name;
    col37.font.charset:=font_charset;
    col38.font.name:=font_name;
    col38.font.charset:=font_charset;
    col36.font.name:=font_name;
    col36.font.charset:=font_charset;
    col35.font.name:=font_name;
    col35.font.charset:=font_charset;
    col18.font.name:=font_name;
    col18.font.charset:=font_charset;
    col21.font.name:=font_name;
    col21.font.charset:=font_charset;

    infofontsize.position:=fontsize2;
    col27.font.size:=fontsize2;{RA}
    col27.font.charset:=font_charset;
    col25.font.size:=fontsize2;{20:36}
    col25.font.charset:=font_charset;

    moonfontsize.position:=fontsize1;
    moon.font.size:=fontsize1;
    moon.font.charset:=font_charset;

    geminifontsize.position:=fontsize3;
    gemini.font.size:=fontsize3;
    gemini.font.charset:=font_charset;


    col39.font.name:=font_name;
    col39.font.size:=fontsize2;{simulated menu}
    col39.font.charset:=font_charset;

    font_setting.font.name:=font_name;
    font_setting.font.charset:=font_charset;
  //  underline1.font.charset:=font_charset;

  end;

  mainwindow.toolbar2.font.name:=font_name;  {adapt font}
  mainwindow.toolbar2.font.charset:=font_charset;

  mainwindow.statusbar1.font.name:=font_name; {adapt font}
  mainwindow.statusbar1.font.charset:=font_charset;

end;

procedure TSettings.underline1Click(Sender: TObject);
begin
  if (fsunderline in font_style) then font_style:=font_style - [fsUnderline]  else font_style:=font_style + [fsUnderline];
  show_fonts;
//  underline1.Canvas.TextOut(5,5,'xxxxx_');
 // underline1.Canvas.font.style:=[fsunderline];
end;

procedure show_location;
var la,lo,x,y :real;

begin
  with settings do
  begin
    try
    lo:=strtofloat_local(longitude2.text);
    if east2.checked then lo:=-lo;

    lo:=fnmodulo(180-lo,360);{make range 0..360, fnmodulo for 253 entries instead -7}

//    y2:=(y+1)*(360*0.5)/(image1.height);
//    x2:=(x+1)*(720*0.5)/(image1.width);

    x:=(lo*image1.width/360);

//    shape1.left:=round(-4+2*lo);
    shape1.left:=round(x-shape1.width/2);

    la:=strtofloat_local(latitude2.text);
    if south2.checked then la:=-la;
    shape1.top :=round(-5+180-2*la);

    y:=((-la+90)*image1.height/180);

 //   shape1.top :=round(-5+180-2*la);
    shape1.top :=round(y-shape1.height/2);

    shape1.hint:=latitude2.text+' , '+longitude2.text;
    except
    end;
  end;
end;

procedure TSettings.showlocation(Sender: TObject);
begin
   show_location;
end;


procedure TSettings.longitude2Exit(Sender: TObject);
begin
   show_location;
end;


procedure TSettings.telescope_name_select1CloseUp(Sender: TObject);
begin
  indi_telescope_name:=telescope_name_select1.text;
  indi.telescope_name_select2.text:=indi_telescope_name;

  free_all_tabs;{remove all tabs and buttons in the bulk way}
  request_indi_properties;{ask server for an update and therefore start to rebuild}
end;


procedure TSettings.FormShow(Sender: TObject);
begin
  if language_mode<>0 then
  begin
     load_sett;{non english text, do it here to show translation mean_equinox of date}
     settings.DeltaT_correction1.Caption:=deltaT_correction;
     Label_frame1.hint:= mainwindow.Measuringframe1.hint;{popup hint, to rotate measuring frame}
  end;
  showcolors;

  screenupdate1.position:=timestep;
  telrad01.text:=floattostrF_local(telrad[1],0,3);
  telrad02.text:=floattostrF_local(telrad[2],0,3);
  telrad03.text:=floattostrF_local(telrad[3],0,3);
  telrad04.text:=floattostrF_local(telrad[4],0,3);
  telrad05.text:=floattostrF_local(telrad[5],0,3);

  if northc<0 then begin north2.checked:=false;south2.checked:=true;end
              else begin north2.checked:=true;south2.checked:=false;end;

  dayl_saving1.checked:=daylight_saving=1;

  if equinox=0 then equinox_map1.ItemIndex:=2 {app}
  else
  if equinox=1 then equinox_map1.ItemIndex:=1 {mean}
  else
  if equinox=9999 then equinox_map1.ItemIndex:=3  {galactic}
  else
  if equinox=1950 then equinox_map1.ItemIndex:=4 {1950}
  else
  equinox_map1.ItemIndex:=0; {2000}


  // Ascom numbering followed
  //    equOther	0	Custom or unknown equinox and/or reference frame.
  //	equLocalTopocentric	1	Local topocentric; this is the most common for amateur telescopes.
  //	equJ2000	2	J2000 equator/equinox, ICRS reference frame.
  //	equJ2050	3	J2050 equator/equinox, ICRS reference frame.
  //	equB1950	4	B1950 equinox, FK4 reference frame.


  if equinox_telescope=2000 then equinox_telescope2.ItemIndex:=2
  else
  if equinox_telescope=2050 then equinox_telescope2.ItemIndex:=3
  else
  if equinox_telescope=1950 then equinox_telescope2.ItemIndex:=4
  else
  equinox_telescope2.ItemIndex:=1; {mean equinox of date}

  parallax.checked:=parallax2<>0;
  refraction.checked:=apparent_horizon<>0;

  if longitude<0 then
    begin longitude2.text:=floattostrF_local(-longitude,0,3);west2.checked:=false;east2.checked:=true;end
    else
    begin longitude2.text:=floattostrF_local(longitude,0,3);west2.checked:=true;east2.checked:=false; end;


  latitude2.text:=floattostrF_local(abs(reallatitude),0,3);
  show_location;

  time_zone1.text:=time_zone_name(dst_auto,timezone);
  Settings.time_zone1Change(Sender);{update map}

  DeltaT_correction1.checked:=Time_Reference[1]='U';{UTC}

  UCACpath1.text:=path_ucac4;
  dssmask1.text:=dss_mask;
  DE430_file1.text:=de430_file;
  DE431_file1.text:=de431_file;
  check_de430_files(de430_emphemeris<>0); {check if the files exist}

  height1.text:=floattostrF_local(frame_height,3,1);
  width1.text:=floattostrF_local(frame_width,3,1);

  show_fonts;
  EarlyFITS.checked:=zoom_show_DSS<4;

  internetskyviewwide.text:=internet_skyview_wide;
  internetskyview.text:=internet_skyview;
  interneteso.text:=internet_eso;
  internetmast.text:=internet_mast;

  internetsimbad.text:=internet_simbad;
  internetLeda1.text:=internet_leda;
  internetned.text:=internet_ned;
  vizier_server1.text:=vizier_server;{online star database}


  lang_combobox1.items.add(language_module);{add language module}
  lang_combobox1.ItemIndex:=0;{show selected star database}

  internetasteroid1.text:=internet_asteroid;
  max_nr_asteroids1.text:=asteroids_maxnr;

  internetcomet1.text:=internet_comet;

  settings.cometfiledate1.caption:=cometfile_age;{show date of cometfile}
  settings.asteroid_epoch1.caption:=asteroidfile_age;{show date of cometfile}

  mousewheelreverse1.checked:=(mouse_wheel_reverse<>0);
  mooncoversstars1.checked:=(moon_covers_stars<>0);
  earthcoversstars1.checked:=(earth_covers_stars<>0);
  azimuth_degrees1.Checked:=azimuth_degrees<>0;
  DE430_on1.Checked:=de430_emphemeris<>0;
  grs_offset1.position:=grs_offset;

  documentspath1.caption:=ExpandFileName(documents_path); {show documents path}

  server_checkbox1.Checked:=server_on;{remote control}
  show_plot_time1.checked:=showplottime;
end;



procedure make_new_color(col:integer);
begin
//  if col=30 then settings.ColorDialog1.options:= [cdsolidcolor] else settings.ColorDialog1.options:= [cdFullOpen, cdAnyColor];  {for fits image only solid colors}
  settings.ColorDialog1.color:=colors[col];
  if settings.ColorDialog1.execute then
  begin
    colors[col]:= settings.ColorDialog1.color;

    if getrvalue(colors[30])<>0 then colors[30]:=rgb($FF,getgvalue(colors[30]),getbvalue(colors[30]) );  {allow only FF in RGB for FITS colors}
    if getgvalue(colors[30])<>0 then colors[30]:=rgb(getrvalue(colors[30]),$FF,getbvalue(colors[30]) );
    if getbvalue(colors[30])<>0 then colors[30]:=rgb(getrvalue(colors[30]),getgvalue(colors[30]),$FF );

    if getrvalue(colors[41])<>0 then colors[41]:=rgb($FF,getgvalue(colors[41]),getbvalue(colors[41]) );  {allow only FF in RGB for FITS colors}
    if getgvalue(colors[41])<>0 then colors[41]:=rgb(getrvalue(colors[41]),$FF,getbvalue(colors[41]) );
    if getbvalue(colors[41])<>0 then colors[41]:=rgb(getrvalue(colors[41]),getgvalue(colors[41]),$FF );


    { cdSolidColor Direct Windows to use the nearest solid color to the color chosen.}
   { cdAnyColor Allow the user to select non-solid colors (which may have to be approximated by dithering).}

    delete_penbrush;
    prepare_penbrush;
  end;
end;
procedure make_new_font_color(col:integer);
begin
  settings.ColorDialog1.color:=colors[col];
  if settings.ColorDialog1.execute then
  begin
    colors[col]:= settings.ColorDialog1.color;
  end;
end;



procedure TSettings.reset_to_defaultClick(Sender: TObject);
begin
  if messagebox(getfocus,pchar(sure_string),pchar(reset_to_default.caption),MB_YESNO+MB_ICONQUESTION)<>IDYES then exit;
  setdefaultcolors;
  delete_penbrush;
  prepare_penbrush;

  showcolors;
  missedupdate:=2; {rewrite window}
  paint_sky;
end;

procedure TSettings.inverse_colorsClick(Sender: TObject);
begin
 if application.messagebox(pchar(sure_string),
                        pchar(striphotkey(inverse_colors.caption)), { stripHotKey to remove automatic added "&"}
                        MB_YESNO+MB_ICONQUESTION)<>IDYES then exit;
  negative;
  showcolors;
  missedupdate:=2; {rewrite window}
  paint_sky;
end;

procedure TSettings.applysave1Click(Sender: TObject);
begin
  Settings.OKClick(Sender);
  mainwindow.Savesettings1Click(Sender);
end;

procedure TSettings.colorClick(Sender: TObject);

begin
  if sender=col7 then make_new_color(7);
  if sender=col10 then make_new_font_color(10);
  if sender=col6 then make_new_color(6);
  if sender=col9 then make_new_font_color(9);
  if sender=col5 then make_new_color(5);
  if sender=col8 then make_new_font_color(8);
  if sender=col11 then make_new_color(11);
  if sender=col17 then make_new_color(17);{const}
  if ((sender=col26) or (sender=gemini)) then  make_new_font_color(26);{const labels}
  if ((sender=col20) or (sender=col20line)) then  make_new_color(20);
  if ((sender=col19) or (sender=col19line)) then  make_new_color(19);
  if sender=col16 then  make_new_font_color(16);
  if sender=col12 then  make_new_color(12);{asteroids}
  if sender=col37 then  make_new_font_color(37);{asteroids}
  if sender=col13 then  make_new_color(13);{comets}
  if sender=col38 then  make_new_font_color(38);{comets}
  if sender=col15 then  make_new_color(15);
  if sender=col24 then  make_new_font_color(24);{star labels}
  if ((sender=col18){ or (sender=moon)}) then  make_new_font_color(18);{sun moon}
  if sender=col21 then  make_new_font_color(21);{mercury ... saturn}

  if sender=col23 then   make_new_color(23); {north east arrow}
  if sender=col1 then make_new_color(1);{Stars}

  if sender=col32 then  make_new_color(32);{inner planets}
  if sender=col33 then  make_new_color(33);{sun moon}
  if sender=col34 then  make_new_color(34);{moons}
  if sender=col35 then  make_new_font_color(35);{moons labels}
  if sender=col36 then  make_new_font_color(36);{moons labels}

  if sender=col2 then  make_new_color(2);{very faint stars}
  if sender=col3 then  make_new_color(3);{faint stars}
  if sender=col4 then  make_new_color(4);{medium stars}

  if ((sender=col14) or (sender=col14line)) then make_new_color(14);{dark limbs and moon orbits}

  if sender=col25 then make_new_font_color(25);{RA/DEC found color}
  if sender=col27 then make_new_font_color(27);{RA color}

  if ((sender=col28) or (sender=col28line)) then  make_new_color(28);{cross hair}
  if sender=col29 then make_new_font_color(29);{RA/DEC grid text color}

  if sender=colorpanel then  make_new_color(0);

  if ((sender=col30) or (sender=col30b)) then make_new_color(30);

  if ((sender=col31) or (sender=col31line)) then make_new_color(31);{Horizon line}
  if sender=col39 then make_new_color(39);{Menu background}
  if ((sender=col40) or (sender=col40line)) then make_new_color(40);{Milky Way}
  if sender=col41 then make_new_color(41);{DSS blue}

  if ((sender=col42) or (sender=col42_1)) then make_new_color(42);

  showcolors;
  missedupdate:=2;paint_sky; {rewrite window to showcolor and fonts}

end;

procedure TSettings.UCACpath1DblClick(Sender: TObject);
begin
  SelectDirectorydialog1.title:='Select UCAC4 directory';
  SelectDirectorydialog1.Filename:='u4index.unf';
  SelectDirectorydialog1.Filter := 'u4index.unf and Z001, Z002... files|u4index.unf';
  if SelectDirectorydialog1.execute then
  begin
     if sender=UCACpath1 then UCACpath1.text:=SelectDirectorydialog1.filename;
  end;
end;

procedure TSettings.dssmask1DblClick(Sender: TObject);
begin
  SelectDirectoryDialog1.title:='Select FITS directory';
  SelectDirectoryDialog1.Filename:='FITS directory';
  SelectDirectoryDialog1.initialdir:=documents_path;
  SelectDirectorydialog1.Filter :='Select main FITS directory|nofile';
  if SelectDirectoryDialog1.execute then
     dssmask1.text:=SelectDirectoryDialog1.filename+PathDelim+'*.fit*';
end;

procedure TSettings.FormActivate(Sender: TObject);
begin
  east3:=striphotkey(east2.Caption);{Remove ampersand sign uses for alt short keys}
  west3:=striphotkey(west2.Caption);
  south3:=striphotkey(south2.Caption);
  north3:=striphotkey(north2.Caption);

end;


procedure TSettings.font_settingClick(Sender: TObject);
begin

  FontDialog1.font.size:=fontsize1;{moon}
  FontDialog1.font.color:=colors[18];{moon}

  FontDialog1.font.name:=font_name;
  FontDialog1.font.style:=font_style;
  FontDialog1.font.charset:=font_charset;  {note Greek=161, Russian or Cyrillic =204}

  FontDialog1.Execute;

  colors[18]:=FontDialog1.font.color;{moon}
  fontsize1:=FontDialog1.font.size;{moon}

  fontsize2:=FontDialog1.font.size;
  font_name:=FontDialog1.font.name;

  font_style:=FontDialog1.font.style;
  if fsStrikeOut in font_style then font_style:=font_style-[fsStrikeOut];{extra protection}



  font_charset:=FontDialog1.font.charset; {select cyrillic for RussiaN}
  FontDialog1.font.charset:=font_charset;  {note Greek=161, Russian or Cyrillic =204}


  showcolors;
  show_fonts;
  missedupdate:=2; {rewrite window}
  paint_sky;
end;


procedure TSettings.fontsizeClick(Sender: TObject; Button: TUDBtnType);
begin
  if sender=infofontsize then
              begin fontsize2:=infofontsize.position;
                    col27.font.size:=fontsize2;{RA}
                    col25.font.size:=fontsize2;{20:36}
                    mainwindow.toolbar2.Font.size:=fontsize2;
                    mainwindow.statusbar1.font.size:=fontsize2;
                    col39.font.size:=fontsize2;{fake menu shown}
              end;
  if sender=geminifontsize then
              begin fontsize3:=geminifontsize.position;
                    gemini.font.size:=fontsize3;end;
  if sender=moonfontsize then
              begin fontsize1:=moonfontsize.position;
                    moon.font.size:=fontsize1; end;

  settings.col39.left:=settings.col31.left;
  settings.col39.top:=settings.col25.top;{link it to col29}
  settings.col39.height:=settings.col25.height;{autosize tlabel doesn't work}
  settings.col39.width :=settings.col25.width*3;{autosize tlabel doesn't work}

  application.processmessages;//essential for Darwin. Otherwise application crashes.
  missedupdate:=2;paint_sky; {rewrite window}

end;

procedure TSettings.FormCreate(Sender: TObject);
begin
  {$ifdef mswindows}
  {$else} {unix}
     Ascom_radiobutton1.visible:=false; //caption:= not_available; {not available in Linux}
     Ascom_radiobutton1.checked:=false;
     trackingmethod1.items.Delete(5);//moveaxis does not exist in Indi
     trackingmethod1.items.Delete(4);
     trackingmethod1.items.Delete(3);
  {$endif}


  PageControl1.ActivePage := PageControl1.Pages[page_settings];{set active page}
 {$ifdef fpc}
  Ascom_radiobutton1.checked:=(telescope_interface='A');
  Alpaca_radiobutton1.checked:=(telescope_interface='C');
  Alpaca_groupBox1.enabled   :=(telescope_interface='C');
  indi_radioButton1.checked :=(telescope_interface='I');
  INDI_groupBox1.enabled   :=(telescope_interface='I');
  no_telescope1.checked :=(telescope_interface=' ');


  if INDI_telescope_name<>'' then
  begin
    telescope_name_select1.items.add(INDI_telescope_name);
    telescope_name_select1.itemindex:=0;
  end;

  indi_host_address1.text:=INDI_server_address; {localhost}
  indi_port1.text:=INDI_port;{7624}

  server_host_address_edit1.text:=server_address;
  server_port1.text:=server_port;{7700}
  server_checkbox1.Checked:=server_on;

  alpaca_adress1.text:=alpaca_address;
  alpaca_port1.text:=alpaca_port;{11111}
  alpaca_telescope1.text:=alpaca_telescope;{0}

  trackingmethod1.itemindex:=trackingmethod;

 {$else} {delphi}
 {$endif}

end;

procedure TSettings.FormPaint(Sender: TObject);
begin
  settings.col39.left:=settings.col31.left;
  settings.col39.top:=settings.col25.top;{link it to col29}
  settings.col39.height:=settings.col25.height;{autosize tlabel doesn't work}
  settings.col39.width :=settings.col25.width*2;{autosize tlabel doesn't work}

 {$ifdef fpc}
  if indi_client_connected then connect_server_Button1.font.color:=cllime else
  connect_server_Button1.font.color:=clRed;

  if indi_telescope_connected then
  begin telescope_name_select1.color:=cllime;connect_telescope_button1.font.color:=cllime; end
    else begin telescope_name_select1.color:=clred;connect_telescope_button1.font.color:=clred; end;
 {$else} {delphi}
 {$endif}

end;

procedure TSettings.Colors_tabShow(Sender: TObject);
begin
   cancelbutton1.enabled:=false;{cancel does not work here}
end;

procedure TSettings.Settings_tabShow(Sender: TObject);
begin
   cancelbutton1.enabled:=true;{cancel does work here}
end;



procedure TSettings.internet_tabShow(Sender: TObject);
begin
   cancelbutton1.enabled:=true;{cancel does work here}
end;

procedure TSettings.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   x2,y2 : double;
begin
  y2:=(y)*(360*0.5)/(image1.height);
  x2:=(x)*(720*0.5)/(image1.width);

  if y>180 then Label_NS1.caption:=south3 else Label_NS1.caption:=north3;
  Label_la1.caption:=floattostrF_local(abs( 90 - y2),0,1);

  if x>360 then Label_EW1.caption:=east3 else Label_EW1.caption:=west3;
  Label_lo1.caption:=floattostrF_local(abs(180 - x2),0,1);

//  Label_la1.caption:=floattostrF_local(y,0,0);
 // Label_lo1.caption:=floattostrF_local(x,0,0);

end;

procedure TSettings.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   x2,y2 : double;
begin
  y2:=(y)*(360*0.5)/(image1.height);
  x2:=(x)*(720*0.5)/(image1.width);

  shape1.top:= y-round(shape1.height/2);
  shape1.left:=x-round(shape1.width/2);

  latitude2.text:=floattostrF_local(abs ( 90 -y2),0,1);
  longitude2.text:=floattostrF_local(abs(180 -x2),0,1);

  shape1.hint:=latitude2.text+' , '+longitude2.text;

  if y>180 then
  begin north2.checked:=false;south2.checked:=true;end
  else
  begin north2.checked:=true;south2.checked:=false;end;

  if x>360 then
  begin west2.checked:=false;east2.checked:=true;end
  else
  begin west2.checked:=true;east2.checked:=false; end;
end;

procedure TSettings.location_tabShow(Sender: TObject);
begin
  cancelbutton1.enabled:=true;{cancel does work here}
//  Settings.image1.width:=settings.location_tab.width;
end;

procedure TSettings.internet_linkClick(Sender: TObject);
begin
  if sender=eso_link then  open_link(eso_link.caption);
  if sender=skyview_link then  open_link(skyview_link.caption);
  if sender=mast_link then  open_link(mast_link.caption);
  if sender=simbad_link then  open_link(simbad_link.caption);
  if sender=leda_link then  open_link(leda_link.caption);
  if sender=ned_link then  open_link(ned_link.caption);
  if sender=hnsky_link then  open_link(hnsky_link.caption);
  if sender=help_settings then
                   case PageControl1.tabindex of 0: open_file_with_parameters(help_path,'#settings_tab1');
                                                 1: open_file_with_parameters(help_path,'#settings_tab2');
                                                 2: open_file_with_parameters(help_path,'#settings_tab3');
                                                 3: open_file_with_parameters(help_path,'#settings_tab4');
                                                 4: open_file_with_parameters(help_path,'#settings_tab5');
                                                 5: open_file_with_parameters(help_path,'#settings_tab6');
                                                 6: open_file_with_parameters(help_path,'#remote_host');
                                              end;
  if sender=DE430info then  open_file_with_parameters(help_path,'#jpl_de');;
end;


procedure TLabel.CMMouseEnter(var Msg: TMessage);
begin
  if settings=nil then exit;{required since indi??}

  if settings.pagecontrol1.activepage.pageindex=2 then exit; {don't do  this for settings, moon}
  if Font.Style=[fsUnderline] then Font.color:=clred; {for internetlinks}
end;

procedure TLabel.CMMouseLeave(var Msg: TMessage);
begin
  if settings=nil then exit; {required since indi??}

  if settings.PageControl1.activepage.pageindex=2 then exit; {don't do  this for settings, moon}
  if Font.Style=[fsUnderline] then Font.color:=clblue; {for internetlinks}
end;


procedure TSettings.time_zone1Change(Sender: TObject);
var
  autodst  :boolean;
  dst      : integer;
  time_zoneX : double;
begin
  time_zone_number(time_zone1.text, autodst, time_zoneX);
  if autodst then {known time zone}
  begin
    if daylichtsaving(timezone>-1 {europe},year2,month2,day2+hour2/24+min2/(24*60)) then dst:=1 else dst:=0;
    dayl_saving1.Checked:=dst<>0;
    dayl_saving1.enabled:=false;
  end
  else
  begin{unknown timezone}
    dayl_saving1.enabled:=true;
  end;
//   time_zone1.text:=time_zone_name(autodst, time_zoneX);{werkt niet in lazarus/fpc geeft een nieuw event en blank report result again}
  timezone_shape.left:=round((360-1+(time_zoneX)*360/12)*image1.width/720);
end;

procedure TSettings.filelist_comboboxDropDown(Sender: TObject);
var
  SearchRec: TSearchRec;
begin
  if (Sender is TComboBox) then
    with (Sender as TComboBox) do
  begin
    items.clear;
    items.add('');{add empthy to allow  none}
    if FindFirst(application_Path+'*.ini*', faAnyFile, SearchRec)=0 then
    begin
       {lang_combobox1.}  items.add(searchrec.name);
        while FindNext(SearchRec) = 0 do
       {lang_combobox1.} items.add(searchrec.name);
    end;
    FindClose(SearchRec);
  end;
end;
procedure TSettings.limitClick(Sender: TObject; Button: TUDBtnType);
begin
    if bright_limit.Position>medium_limit.Position then bright_limit.Position:=medium_limit.Position;{do no allow bright>medium}

    limit_deep_bright_color:=bright_limit.Position;
    limit_deep_medium_color:=medium_limit.Position;
    showcolors;
    missedupdate:=2;paint_sky; {rewrite window}

end;


function convert_comet_els(filename: string) : boolean;
var
  oldCursor : TCursor;
  code2,line,error2,counter    : integer;
  txt                  : string;
  s                    : TStringList;
  value,g              : double;
begin
//  oldCursor := Screen.Cursor;
//  Screen.Cursor := crHourglass;

  s := TStringList.Create;
  s.LoadFromFile(Filename);
  line:=0;
  counter:=0;

  setlength(comets,s.count);

  while line<s.count do
  begin
    //    CJ95O010  1997 03 30.7194  0.890521  0.994981  130.2213  282.3030   89.4662  20240304  -2.0  4.0  C/1995 O1 (Hale-Bopp)                                    MPEC 2022-S20
    txt:=S.Strings[line];

    if length(txt)>168 then
    begin
      val(copy(txt,15,4),comets[counter].yy,error2);//epoch year.
      if ((error2=0) and (comets[counter].yy>1900) and (comets[counter].yy<2200)) then {do only data and modern comets}
      begin
        comets[counter].mm:=strtoint(copy(txt,20,2));{epoch month}
        comets[counter].dd:=strtofloat(copy(txt,23,7));{epoch day}

        comets[counter].q:=strtofloat(copy(txt,31,9)); // Perihelion distance (AU)
        comets[counter].ecc:=strtofloat(copy(txt,41,9));// Orbital eccentricity
        comets[counter].aop:=strtofloat(copy(txt,51,9));// Argument of perihelion, J2000.0 (degrees)
        comets[counter].lan:=strtofloat(copy(txt,61,9));// Longitude of the ascending node, J2000.0 (degrees)
        comets[counter].inc:=strtofloat(copy(txt,71,9));// Onclination in degrees, J2000.0 (degrees)

        comets[counter].h:=strtofloat(copy(txt,91,5));  // Absolute magnitude, H
        comets[counter].g:=strtofloat(copy(txt,97,4));  // slope

        comets[counter].name:=copy(stringreplace(copy(txt,103,56),' ','',[rfreplaceall]),1,28);//max length 28
        comets[counter].reference:=stringreplace(copy(txt,160,9 ),' ','',[rfreplaceall]);//max length 9

        comets[counter].calc_magn:=0;// special, magnitude calculated within 0.25 day of the current time  for speed
        comets[counter].calc_jd:=0;  // julian day when cal_magn was calculated


        {Hale Bopp
          Q:= 0.890521; Perihelion distance q in AU;
          ECC:= 0.99492999999999998; Eccentricity e
          INC:= 88.987200000000001; Inclination i
          LAN:= 283.36720000000003;  Longitude of the ascending node
          AOP:= 130.62989999999999;  Argument of perihelion}
        inc(counter)
      end;//valid data
    end;//length >168
    inc(line);
  end;
  S.Free;
  setlength( comets,counter);

  save_comets(documents_path+'hns_cmt.cmt', comets);

//  Screen.Cursor := oldCursor;
  result:=counter>100;
end;



procedure TSettings.button_comet_update1Click(Sender: TObject);  {2013 update comet  database}
var
  success : boolean;

begin
//  oldCursor := Screen.Cursor;
//  Screen.Cursor := crHourglass;
  success:=false;

  if pos('CometEls',internetcomet1.text)<>0 then {https://minorplanetcenter.net/iau/MPCORB/CometEls.txt}
  begin
    if  DownloadFile(internetcomet1.text,documents_path+'CometEls.txt') then
    begin
      success:=convert_comet_els(documents_path+'CometEls.txt');{data is also loaded in cometstring}
      if success then cometfile_age:=DateTimeToStr(FileDateToDateTime(FileAge(documents_path+'hns_cmt.cmt')))
        else  cometfile_age:='CometEls.txt conversion problem';
     end
  end;


  if success=false then
  begin
    settings.cometfiledate1.font.color:=clred;
    settings.cometfiledate1.caption:=cometfile_age+',   '+error_string;{show date of cometfile}
  end
  else
  begin
    settings.cometfiledate1.font.color:=clgreen;
    settings.cometfiledate1.caption:=cometfile_age;{show date of cometfile}
  end;
  invalidaterect(settings.handle,nil,true);  {refresh to show new dates}
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

function convert_MPCORB(filename: string; nrlines: integer) : boolean;
var
  code2,line, counter,error2   : integer;
  txt                  : string;
  centuryA             : string[2];
  S                    : TStringList;
  value                : double;
begin
  S := TStringList.Create;
  S.LoadFromFile(Filename);
  line:=0;
  counter:=0;

  nrlines:=min(nrlines,S.count);
  setlength(asteroids,nrlines);

  while line<nrlines do
  begin

    txt:=S.Strings[line];

    if length(txt)>190 then
    begin
      //  Epoch (in packed form, .0 TT), see http://www.minorplanetcenter.net/iau/info/MPOrbitFormat.html}
      //   1996 Jan. 1    = J9611
      //   1996 Jan. 10   = J961A
      //   1996 Sept.30   = J969U
      //   1996 Oct. 1    = J96A1
      //   2001 Oct. 22   = K01AM

     str(Ord(txt[21])-55:2,centuryA); // 'A'=65

     {  Tasteroids : record
                      designation : string;
                      epoch,
                      e,
                      a,
                      i,
                      ohm,
                      w,
                      M_anomaly,
                      H,
                      G,
                      calc_magn : double
                    end;   }

      if ((centuryA='19') or (centuryA='20') or (centuryA='21')) then {do only data}
      begin
        asteroids[counter].desn:=trimRight(copy(txt,1,7)); //7

        val(copy(txt,8,12-8+1),value,error2);{ 8 -  12  f5.2   Absolute magnitude, H}
        if error2=0 then  asteroids[counter].H:=value else asteroids[counter].H:=23;//no data

        val(copy(txt,14,19-14+1),value,error2);{14 -  19  f5.2   Slope parameter, G}
        if error2=0 then  asteroids[counter].G:=value else asteroids[counter].G:=0.15;//no data

        asteroids[counter].yy:=strtoint(centuryA+txt[22]+txt[23]);{epoch year}

        code2:=Ord(txt[24]);
        if code2<65 then asteroids[counter].mm:=code2-48 {1..9} else asteroids[counter].mm:=code2-55; {A..Z}

        code2:=Ord(txt[25]);
        if code2<65 then asteroids[counter].dd:=code2-48 {1..9} else asteroids[counter].dd:=code2-55; {A..Z}

        asteroids[counter].M_anomaly:=strtofloat(copy(txt,27,35-27+1));   {27 -  35  f9.5   Mean anomaly at the epoch, in degrees}
        asteroids[counter].aop:=strtofloat(copy(txt,38,46-38+1));   {38 -  46  f9.5   Argument of perihelion, J2000.0 (degrees)}
        asteroids[counter].ohm:=strtofloat(copy(txt,49,57-49+1)); {49 -  57  f9.5   Longitude of the ascending node, J2000.0  (degrees)}
        asteroids[counter].inc:=strtofloat(copy(txt,60,68-60+1));   {60 -  68  f9.5   Inclination to the ecliptic, J2000.0 (degrees)}

        asteroids[counter].ecc:=strtofloat(copy(txt,71,79-71+1));   {71 -  79  f9.7   Orbital eccentricity}
        asteroids[counter].sma:=strtofloat(copy(txt,93,103-93+1));  {93 - 103  f11.7  Semimajor axis (AU)}

        asteroids[counter].name:=stringreplace(copy(txt,167,194-167+1),' ','',[rfreplaceall]);//max length 28

        asteroids[counter].calc_magn:=0;// special, magnitude calculated within 0.25 day of the current time  for speed
        asteroids[counter].calc_jd:=0;  // julian day when cal_magn was calculated
        inc(counter)
      end;//valid data
    end;//length >190
    //if  frac(counter/1000)=0 then edit2.caption:=Formatfloat('0', counter)+' asteroids';{show position but not to often otherwise slowdown}
    inc(line);
  end;
  S.Free;
  setlength( asteroids,counter);

  save_asteroids(documents_path+'hns_ast.ast', asteroids);
  result:=counter>100;
end;




function convert_mpcorb_diskfile(filen :string) : boolean;
var
  max_nr_asteroids,error2    : integer;
begin
  settings.update_TAB.cursor:=crHourglass;//settings.cursor doesn't work

  val(asteroids_maxnr,max_nr_asteroids,error2);;

  result:=convert_MPCORB(filen, max_nr_asteroids+44 {44 lines of text will be ignored});

  if result then
     asteroidfile_age:=formatfloat('0000',asteroids[0].yy)+'-'+formatfloat('00',asteroids[0].mm)+ '-'+formatfloat('00',asteroids[0].dd)
  else
     asteroidfile_age:='MPCORB.DAT conversion problem';

  settings.nr_asteroids_extracted1.text:='↓ '+ inttostr(length(asteroids)-1);

  settings.update_TAB.cursor:=crDefault;
end;


procedure TSettings.import_asteroids1Click(Sender: TObject);
var
   success: boolean;
begin

  OpenDialog1.title:='Select an MPCORB.dat file';
  OpenDialog1.Filename:='*.dat';
  OpenDialog1.initialdir:=documents_path;
  opendialog1.Filter := 'MPCORB, NEA(*.DAT*;*.txt)|*.dat;*.DAT;*.txt';
  if OpenDialog1.execute then
  begin
    settings.update_TAB.cursor:=crHourglass;//settings.cursor doesn't work
    success:=convert_mpcorb_diskfile(OpenDialog1.Filename);
    settings.update_TAB.cursor:=crDefault;//settings.cursor doesn't work
  end;
end;


procedure TSettings.button_asteroid_update1Click(Sender: TObject);
var
  success : boolean;
  oldCursor : TCursor;
begin
  oldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  success:=false;
  if pos('.DAT',uppercase(internetasteroid1.text))>0 then {capital .DAT}
  begin
    if DownloadFile(internetasteroid1.text,documents_path+'mpcorb_temp.dat') then
    begin
      asteroids_maxnr:=max_nr_asteroids1.text;{update now}

      success:=convert_mpcorb_diskfile(documents_path+'mpcorb_temp.dat');{data is also loaded}
      deletefile(documents_path+'mpcorb_temp.dat');
    end
  end;

  if success=false then
  begin
    settings.asteroid_epoch1.font.color:=clred;
    settings.asteroid_epoch1.caption:=asteroidfile_age+',   '+error_string;{show date of asteroid file}
  end
  else
  begin
    settings.asteroid_epoch1.font.color:=$008080;
    settings.asteroid_epoch1.caption:=asteroidfile_age;{show date of asteroid file}
  end;

  invalidaterect(settings.handle,nil,true);  {refresh to show new dates}

  Screen.Cursor:=oldCursor;
end;

end.


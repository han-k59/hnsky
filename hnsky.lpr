program hnsky;
{$mode objfpc}{$H+}
//{$DEFINE debug}     // do this here or you can define a -dDEBUG in Project Options/Other/Custom Options, i.e. in a build mode so you can set up a Debug with leakview and a Default build mode without it
uses
  {$IFDEF debug}
  SysUtils,classes,
  {$ENDIF}

  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces,  {lazurus}
  Forms,
  hns_main in 'hns_main.pas' {mainwindow},
  hns_Uset in 'hns_Uset.pas' {Settings},
  hns_Utim in 'hns_Utim.pas' {Settime},
  hns_Ugot in 'hns_Ugot.pas' {move_to},
  hns_Ucen in 'hns_Ucen.pas' {center_on},
  hns_Uobj in 'hns_Uobj.pas' {objectmenu},
  hns_uedi in 'hns_Uedi.pas' {edit2},
  hns_Udrk in 'hns_Udrk.pas' {darkform},
  hns_Usol in 'hns_Usol.pas' {planetform},
  hns_Upol in 'hns_Upol.pas' {Polarscope},
  hns_Uani in 'hns_Uani.pas' {animation},
  hns_Indi in 'hns_Indi.pas' {animation},
  hns_Uast in 'hns_Uast.pas',
  hns_Unon in 'hns_Unon.pas',
  hns_fast in 'hns_fast.pas',
  hns_Usno in 'hns_usno.pas',
  hns_U290 in 'hns_U290.pas',
  hns_unumint in 'hns_Unumint.pas';

begin
  (* Richtig toll wird es aber erst, wenn man das Package "Leakview" installiert, dann ist unter
  * Ansicht -> Leaks and Traces ein neuer Dialog verfügbar.
  *
  * Damit Heaptrace sauber arbeiten kann sollte
  * -gh = Einschalten Heaptrace
  * -gl = Zeilennummern
  * Aktiviert sein.
  *
  * Kommt in Leakview stets die Meldung "kann unit** nicht finden" dann kann es helfen im Reiter
  * Projekt -> Projekteinstellungen -> Compilereinstellungen -> Debuggen -> Debugging-Info-Typ auf "dwarf" um zu stellen.
  *)

 (*
  * Zeigt den Heaptrace Result dialog nur an, wenn auch Leaks da sind
  *)

  {$IFDEF DEBUG}
  GlobalSkipIfNoLeaks := True;
  // Assuming your build mode sets -dDEBUG in Project Options/Other when defining -gh
  // This avoids interference when running a production/default build without -gh

  // Set up -gh output for the Leakview package:
  if FileExists('heap.trc') then
    DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF DEBUG}

  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'HNSKY';
  Application.CreateForm(Tmainwindow, mainwindow);
  Application.CreateForm(TSettime, Settime);
  Application.CreateForm(Tmove_to, move_to);
  Application.CreateForm(Tcenter_on, center_on);
  Application.CreateForm(Tobjectmenu, objectmenu);
  Application.CreateForm(Tform_animation, form_animation);
  Application.Run;
end.

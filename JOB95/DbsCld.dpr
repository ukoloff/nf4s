program DbsCld;

uses
  Forms,
  PrnTest in 'PrnTest.pas' {Form1},
  SirDBS in '..\DBS\SirDBS.pas',
  SirMath in '..\DBS\SirMath.pas',
  WrapDBS in 'WrapDBS.pas',
  ViewCld in 'ViewCld.pas' {CldForm},
  About in 'About.pas' {AboutDialog},
  CLD in 'CLD.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Просмотр DBS и CLD файлов';
  Application.CreateForm(TCldForm, CldForm);
  Application.Run;
end.

program MakeJob;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Files in 'Files.pas' {FilesForm},
  Job in 'Job.pas' {JobForm},
  View in 'View.pas' {ViewForm},
  SirReg in '..\COMMON\Sirreg.pas',
  DbfNil in 'DbfNil.pas',
  Dbf in 'Dbf.pas' {DbForm},
  DbPropD in 'DbPropD.pas' {DbProp},
  DirProp in 'DirProp.pas' {DbDirProp},
  SirDBS in '..\DBS\SirDBS.pas',
  SirMath in '..\DBS\SirMath.pas',
  WrapDBS in 'WrapDBS.pas',
  About in 'About.pas' {AboutDialog},
  Props in 'Props.pas' {PropDlg},
  Kod in 'Kod.pas' {KodDlg},
  Struc in 'Struc.pas',
  SetUp in 'SetUp.pas' {SetUpDlg},
  JbProp in 'JbProp.pas' {JobProp},
  Nesting in 'Nesting.pas',
  Layouts in 'Layouts.pas',
  DrawDbs in 'DrawDbs.pas',
  LProps in 'LProps.pas' {LEdit},
  DbsProps in 'DbsProps.pas' {PropsDlg},
  ExecWait in 'ExecWait.pas',
  KapDll in 'KapDll.pas',
  TxtFrm in 'TxtFrm.pas' {TextForm};

{$R *.RES}

begin
  Application.Title := 'Генератор заданий';
  CheckDisplayDepth;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TJobForm, JobForm);
  Application.Run;
end.

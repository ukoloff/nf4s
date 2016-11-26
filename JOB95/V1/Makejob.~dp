Program MakeJob;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  JobFrm in 'JobFrm.pas' {JobForm},
  viewfrm in 'viewfrm.pas' {ViewForm},
  FilesFrm in 'FilesFrm.pas' {FilesForm},
  SirReg in '..\Common\Sirreg.pas',
  savdlg in 'savdlg.pas' {SaveDlg},
  NewForm in 'NewForm.pas' {KodDlg},
  About in 'About.pas' {AboutDialog},
  CntDlg in 'CntDlg.pas' {CountDialog},
  SirDBS in '..\DBS\SirDBS.pas',
  SirMath in '..\DBS\Sirmath.pas',
  WrapDBS in 'WrapDBS.pas';

{$R *.RES}

begin  
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TJobForm, JobForm);
  Application.CreateForm(TViewForm, ViewForm);
  Application.CreateForm(TFilesForm, FilesForm);
  Application.Run;
end.

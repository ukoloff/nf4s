program PM;

uses
  Forms,
  Mats in 'Mats.pas' {MatFrm},
  Data in 'Data.pas' {DataModule1: TDataModule},
  Main in 'Main.pas' {MainFrm},
  SirReg in '\DELPHI\COMMON\Sirreg.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Pac Man';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TMatFrm, MatFrm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

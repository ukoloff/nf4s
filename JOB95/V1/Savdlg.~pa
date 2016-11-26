unit SavDlg;

interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TSaveDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OkBtn: TBitBtn;
    Dir: TLabel;
    FileName: TEdit;
    GroupBox1: TGroupBox;
    pLST: TCheckBox;
    pKOL: TCheckBox;
    pJOB: TCheckBox;
    pDBS: TCheckBox;
    GroupBox2: TGroupBox;
    pTrum: TCheckBox;
    pQuiet: TCheckBox;
    p1: TCheckBox;
    pDistance: TEdit;
    Label1: TLabel;
    SaveDialog: TSaveDialog;
    procedure Browse(Sender: TObject);
    procedure FileNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Procedure SetPathName(Const S: String);
    Function GetPathName: String;
  public

    Function NewFileName: Boolean;
    Property PathName: String Read GetPathName Write SetPathName;
  end;

var
  SaveDlg: TSaveDlg;

implementation

uses SirReg;

{$R *.DFM}

Procedure TSaveDlg.SetPathName(Const S: String);
Var
  fPathName: String;
Begin
  fPathName:=ChangeFileExt(S, '');
  Dir.Caption:=ExtractFilePath(fPathName);
  FileName.Text:=ExtractFileName(fPathName);
  SaveDialog.FileName:=fPathName;
End;

Function TSaveDlg.GetPathName: String;
Begin
  Result:=Dir.Caption+FileName.Text
End;

Function TSaveDlg.NewFileName: Boolean;
Begin
  Result:=SaveDialog.Execute;
  If Result Then
    PathName:=SaveDialog.FileName;
End;

procedure TSaveDlg.Browse(Sender: TObject);
begin
  NewFileName;
end;

procedure TSaveDlg.FileNameChange(Sender: TObject);
begin
  OkBtn.Enabled:=(FileName.Text<>'')And
    (pLST.Checked Or pKOL.Checked Or pJOB.Checked
     Or pDBS.Checked);
end;

procedure TSaveDlg.FormCreate(Sender: TObject);
begin
  SirRegistry.ReadDialog(Self);
end;

procedure TSaveDlg.FormDestroy(Sender: TObject);
begin
  SirRegistry.WriteDialog(Self);
end;

end.

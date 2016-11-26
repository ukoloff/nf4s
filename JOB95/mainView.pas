unit mainView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls,
  WrapDbs;

type
  TViewForm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    dlgOpen: TOpenDialog;
    Status: TStatusBar;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N10Click(Sender: TObject);
    procedure ViewPaint(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure SetMode(Sender: TObject);
    procedure MyHint(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    D: TRDBS;

    Function Associated: Boolean;
    Procedure Associate;
    Procedure Open(Const FName: String);
  public
    View: TDbsView;
    Procedure Load(FileName: String);
//    Procedure LoadFromStream(FileName: String; S: TStream);
  end;

var
  ViewForm: TViewForm;

implementation uses
  Registry,
  abView, DbsProps;

{$R *.DFM}

Const
  regType: String='CAD/CAM.Sirius.DBS';

procedure TViewForm.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  Application.HelpFile:=ChangeFileExt(ParamStr(0), '.HLP');
  D.Init;
  D.R.Empty:=True;
  View:=TDbsView.Create(Self);
  View.Parent:=Self;
  View.OnPaint:=ViewPaint;

  If ParamCount>0 Then Open(ParamStr(1));
  Application.OnHint:=MyHint;
end;

procedure TViewForm.N5Click(Sender: TObject);
begin
  Close
end;

procedure TViewForm.N3Click(Sender: TObject);
begin
  If dlgOpen.Execute Then
    Open(dlgOpen.FileName);
end;

procedure TViewForm.N6Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TViewForm.N7Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TViewForm.N8Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.HelpCommand(Help_Quit, 0);
end;

procedure TViewForm.N10Click(Sender: TObject);
begin
  AboutDialog:=TAboutDialog.Create(Nil);
  AboutDialog.Show//Modal;
end;

Function TViewForm.Associated: Boolean;
Var
  R: TRegistry;
Begin
  R:=TRegistry.Create;
  R.RootKey:=hkey_Classes_Root;
  Result:=R.OpenKey('.dbs', False) And
    (R.ReadString('')=regType) And
     R.OpenKey('\'+regType+'\shell\open\command', False) And
     (Pos('"'+ParamStr(0)+'" ', R.ReadString(''))=1);
  R.Free;
End;

Procedure TViewForm.Associate;
Var
  R: TRegistry;
Begin
  R:=TRegistry.Create;
  R.RootKey:=hkey_Classes_Root;
  R.OpenKey('.dbs', True);
  R.WriteString('', regType);
  R.WriteString('Content Type', 'application/octet-stream');
  R.OpenKey('\'+regType, True);
  R.WriteString('', 'Двоичный файл геометрии');
  R.OpenKey('shell\open\command', True);
  R.WriteString('', '"'+ParamStr(0)+'" "%1"');
  R.Free;
End;

Procedure TViewForm.Open(Const FName: String);
Begin
  Load(FName);
  Status.SimpleText:=FName;
  Application.Title:=ExtractFileName(FName)+' - '+Caption;
End;

procedure TViewForm.ViewPaint(Sender: TObject);
begin
  If D.R.Empty Then
    View.DrawCross
  Else
    View.DrawDbs(D);
end;

Procedure TViewForm.Load(FileName: String);
Begin
  If(Self=Nil)Or(FileName='')Then Exit;
//  D.R.Empty:=True;
//  View.Invalidate;
//  Application.MessageBox('*', '+', 0);
  D.LoadByName(FileName);
//  Info.Caption:=D.SizeStr;
  View.Invalidate;
  View.SetPort(D.R);
//  Caption:=FileName;
End;

procedure TViewForm.N14Click(Sender: TObject);
begin
  View.Invalidate;
  View.SetPort(D.R);
end;

procedure TViewForm.N17Click(Sender: TObject);
begin
  TMenuItem(Sender).Items[Ord(View.MouseMode)].Checked:=True;
end;

procedure TViewForm.SetMode(Sender: TObject);
begin
  View.MouseMode:=TMouseMode(TMenuItem(Sender).Tag);
  View.UpdateCursor;
end;


procedure TViewForm.MyHint(Sender: TObject);
begin
  Status.SimpleText:=Application.Hint;
end;

procedure TViewForm.N11Click(Sender: TObject);
begin
  If D.R.Empty Then Exit;
  If PropsDlg=Nil Then
    PropsDlg:=TPropsDlg.Create(Nil);
  PropsDlg.Display(D);
end;

procedure TViewForm.FormActivate(Sender: TObject);
begin
  If Not Associated And
    (Application.MessageBox('Файлы с расширением .DBS не связаны'^M+
                            'с этой программой. Связать ?',
                            PChar(Application.Title),
                            mb_IconQuestion+mb_YesNo)=idYes)Then
    Associate;
end;

end.

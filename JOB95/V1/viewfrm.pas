Unit ViewFrm;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, WrapDBS;

type
  TViewForm = class(TForm)
    Info: TLabel;
    MainMenu1: TMainMenu;
    MenuSingle: TMenuItem;
    procedure MenuSingleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ViewPaint(Sender: TObject);
  private
    D: TRDBS;

    fSingle: Boolean;
    Procedure SetSingle(S: Boolean);
  public
    View: TDbsView;
    
    Property Single: Boolean Read fSingle Write SetSingle;
    Procedure Load(FileName: String);
  end;

Var
  ViewForm: TViewForm;

Implementation

{$R *.DFM}

Procedure TViewForm.SetSingle(S: Boolean);
Begin
  If S=fSingle Then
    Exit;
  fSingle:=S;
  MenuSingle.Checked:=S;
End;

procedure TViewForm.MenuSingleClick(Sender: TObject);
begin
  Single:=Not Single;
end;

procedure TViewForm.FormCreate(Sender: TObject);
begin
  D.Init;
  D.R.Empty:=True;
  View:=TDbsView.Create(Self);
  View.Parent:=Self;
  View.OnPaint:=ViewPaint;
end;

Procedure TViewForm.Load(FileName: String);
Begin
  View.Invalidate;
  D.Load(FileName);
  Info.Caption:=D.SizeStr;
  View.SetPort(D.R);
  Caption:=FileName;
End;

procedure TViewForm.ViewPaint(Sender: TObject);
begin
  If D.R.Empty Then
    View.DrawCross
  Else
    View.DrawDbs(D);
end;

end.

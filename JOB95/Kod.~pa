unit Kod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, Spin,
  WrapDBS, SirDbs, SirMath, SirReg, Menus;

type
  TKodDlg = class(TForm)
    ViewPanel: TPanel;
    pName: TEdit;
    Kind: TComboBox;
    pKind: TNotebook;
    Label1: TLabel;
    pW: TEdit;
    Label2: TLabel;
    pH: TEdit;
    pType: TRadioGroup;
    Label3: TLabel;
    pBevel: TEdit;
    Label4: TLabel;
    pR: TEdit;
    Label6: TLabel;
    pInner: TEdit;
    Label5: TLabel;
    pOuter: TEdit;
    Label9: TLabel;
    psR: TEdit;
    Label10: TLabel;
    psH: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    psInner: TEdit;
    psOuter: TEdit;
    Label13: TLabel;
    psAngle: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Info: TLabel;
    pL: TEdit;
    UpDown1: TUpDown;
    pN: TEdit;
    pTH: TEdit;
    pLeft: TEdit;
    pRight: TEdit;
    OkBtn: TButton;
    ViewMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure pTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pNameChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure KindChange(Sender: TObject);
    procedure NewData(Sender: TObject);
    procedure MyPaint(Sender: TObject);
    procedure vMode(Sender: TObject);
    procedure ViewMenuPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    Params: TParamList;
    Valid: Boolean;

    Procedure Recalc;
    Procedure NewRect(W, H: Float);
    Procedure NewBevel(W, H, B: Float; Corners: Byte);
    Procedure NewCirc(R: Float);
    Procedure NewSegm(R, H: Float);
    Procedure NewSect(R1, R2, A: Float);
    Procedure NewTri(L, R, H: Float);
    Procedure NewPoly(N: Integer; A: Float);

    procedure MyData(Sender: TObject);
  public
    Dbs: TDbs;
    View: TDbsView;

    Function Execute: Boolean;
  end;

Function KodDlg: TKodDlg;

Implementation

{$R *.DFM}

var
  FKodDlg: TKodDlg;

Function KodDlg: TKodDlg;
Begin
  If FKodDlg=Nil Then
    FKodDlg:=TKodDlg.Create(Nil);
  Result:=FKodDlg;
End;

Function TKodDlg.Execute: Boolean;
Begin
  ActiveControl:=Nil;
  Result:=ShowModal=mrOk;
End;

Procedure TKodDlg.NewRect(W, H: Float);
Var
  O: TOrig;
  C: TComplex;
Begin
  O:=TOrig.Create(Dbs.Origs);
  C:=cx_0; O.AddPoint(C);
  C.Im:=H; O.AddPoint(C);
  C.Re:=W; O.AddPoint(C);
  C.Im:=0; O.AddPoint(C);
End;

Procedure TKodDlg.NewBevel(W, H, B: Float; Corners: Byte);
Var
  O: TOrig;
  X: TComplex;
 Procedure Corn;
 Const
   K: Single=0.414213;
 Begin
   O.AddPoint(X);
   Case Corners Of
    2: O.SetK(K);
    3: O.SetK(-K);
   End{Case};
 End;
Begin
  O:=TOrig.Create(Dbs.Origs);
  X.Assign(0, B);    O.AddPoint(X);
  X.Im:=H-B;         Corn;
  X.Assign(B, H);    O.AddPoint(X);
  X.Re:=W-B;         Corn;
  X.Assign(W, H-B);  O.AddPoint(X);
  X.Im:=B;           Corn;
  X.Assign(W-B, 0);  O.AddPoint(X);
  X.Re:=B;           Corn;
End;

Procedure TKodDlg.NewCirc(R: Float);
Var
  O: TOrig;
  C: TComplex;
Begin
  O:=TOrig.Create(Dbs.Origs);
  C.Assign(0, R); O.AddPoint(C); O.SetK(1);
  C.Conj; O.AddPoint(C);         O.SetK(1);
End;

Procedure TKodDlg.NewSegm(R, H: Float);
Var
  O: TOrig;
  C: TComplex;
Begin
  R:=2*R-H;
  O:=TOrig.Create(Dbs.Origs);
  C.Assign(Sqrt(R*H), 0); O.AddPoint(C);
  C.Negate; O.AddPoint(C);  O.SetK(Sqrt(H/R));
End;

Procedure TKodDlg.NewSect(R1, R2, A: Float);
Var
  O: TOrig;
  X, Y: TComplex;
Begin
  A:=(Pi/720)*A;
  X.ExpIx(A*2); X.MulI; Y:=X;
  X.Expand(R1); Y.Expand(R2);
  A:=Sin(A)/Cos(A);
  O:=TOrig.Create(Dbs.Origs);
  O.AddPoint(Y); O.AddPoint(X); O.SetK(A);
  X.Re:=-X.Re; Y.Re:=-Y.Re;
  O.AddPoint(X); O.AddPoint(Y); O.SetK(-A);
End;

Procedure TKodDlg.NewTri(L, R, H: Float);
Var
  O: TOrig;
  X: TComplex;
Begin
  O:=TOrig.Create(Dbs.Origs);
  X.Assign(R, 0); O.AddPoint(X);
  X.Re:=-L;       O.AddPoint(X);
  X.Assign(0, H); O.AddPoint(X);
End;

Procedure TKodDlg.NewPoly(N: Integer; A: Float);
Var
  O: TOrig;
  X, Y, Z: TComplex;
Begin
  O:=TOrig.Create(Dbs.Origs);
  X:=cx_0; Z.Assign(A, 0);
  Y.RootN_1(N); Y.Conj;
  While N>0 Do
   Begin
    O.AddPoint(X);
    X.Sub(Z);
    Z.Mul(Y);
    Dec(N);
   End;
End;

procedure TKodDlg.pTypeClick(Sender: TObject);
begin
  pBevel.Enabled:=pType.ItemIndex<>0;
  NewData(Nil);
end;

procedure TKodDlg.FormCreate(Sender: TObject);
begin
  Dbs.Init;
  View:=TDbsView.Create(Self);
  View.Parent:=ViewPanel;
  View.OnPaint:=MyPaint;
  View.PopupMenu:=ViewMenu;
  Params:=TParamList.Create('');
  Params.OnData:=MyData;
  Params.Init(Self);
  Params.Load('Kod');
  Params.SetData(Self);
//  SirRegistry.ReadDialog(Self);
//  (TViewer.Create(Self)).Parent:=ViewPanel;
  Kind.ItemIndex:=pKind.PageIndex;
  KindChange(Nil);
  Recalc;
end;

procedure TKodDlg.pNameChange(Sender: TObject);
begin
  OkBtn.Enabled:=Valid
   And(pName.Text<>'')
   And(Pos('.', pName.Text)=0)
   And(Pos('\', pName.Text)=0)
   And(Pos('/', pName.Text)=0)
end;

procedure TKodDlg.FormDestroy(Sender: TObject);
begin
//  SirRegistry.WriteDialog(Self);
  Params.GetData(Self);
  Params.Store;
end;

procedure TKodDlg.KindChange(Sender: TObject);
begin
  pKind.PageIndex:=Kind.ItemIndex;
  Recalc;
end;

procedure TKodDlg.NewData(Sender: TObject);
begin
  Recalc;
end;

Procedure TKodDlg.Recalc;
Var
  R: TRectan;
Begin
  Dbs.Clear;
  Try
    Case Kind.ItemIndex Of
     0: If pType.ItemIndex=0 Then
          NewRect(StrToFloat(pW.Text), StrToFloat(pH.Text))
        Else
          NewBevel(StrToFloat(pW.Text), StrToFloat(pH.Text),
                   StrToFloat(pBevel.Text), pType.ItemIndex);
     1: NewCirc(StrToFloat(pR.Text));
     2: Begin
         NewCirc(StrToFloat(pOuter.Text));
         NewCirc(StrToFloat(pInner.Text));
        End;
     3: NewSegm(StrToFloat(psR.Text), StrToFloat(psH.Text));
     4: NewSect(StrToFloat(psInner.Text), StrToFloat(psOuter.Text),
                StrToFloat(psAngle.Text));
     5:  NewTri(StrToFloat(pLeft.Text), StrToFloat(pRight.Text),
                StrToFloat(pTH.Text));
     6: NewPoly(StrToInt(pN.Text), StrToFloat(pL.Text));
    End{Case};
//    Dbs.Complete;
//    TPart(Dbs.Parts.Items[0]).AsString:=UpperCase(pName.Text);
//    Dbs.Renumerate(0);
    Dbs.Reorganize(pName.Text);
    R:=Dbs.Bounds;
    If R.Empty Then Abort;
    View.SetPort(R);
    R.Max.Sub(R.Min);
    Info.Caption:=Format('%0.0nx%0.0n mm', [R.Max.Re, R.Max.Im]);
    Valid:=True;
  Except
    Valid:=False;
    Dbs.Clear;
    Info.Caption:='* * *';
  End;
  View.Invalidate;
  pNameChange(Nil)
End;

procedure TKodDlg.MyPaint(Sender: TObject);
begin
  If Valid Then
    View.DrawDbs(Dbs)
  Else
    View.DrawCross;
end;

procedure TKodDlg.MyData(Sender: TObject);
begin
  Params.StdData(Sender);
  If Sender Is TNotebook Then
    If Params.Writing Then
      TNotebook(Sender).PageIndex:=Params.Obj[Sender].AsInteger
    Else
      Params.Obj[Sender].AsInteger:=TNotebook(Sender).PageIndex
  Else If Sender Is TRadioGroup Then
    If Params.Writing Then
      TRadioGroup(Sender).ItemIndex:=Params.Obj[Sender].AsInteger
    Else
      Params.Obj[Sender].AsInteger:=TRadioGroup(Sender).ItemIndex
end;

procedure TKodDlg.vMode(Sender: TObject);
begin
  View.MouseMode:=TMouseMode(TMenuItem(Sender).MenuIndex-2);
  View.UpdateCursor;
end;

procedure TKodDlg.ViewMenuPopup(Sender: TObject);
begin
  TPopupMenu(Sender).Items.Items[2+Ord(View.MouseMode)].Checked:=True;
end;

procedure TKodDlg.N1Click(Sender: TObject);
begin
  If Valid Then View.SetPort(Dbs.Bounds);
  View.Invalidate;
end;

end.

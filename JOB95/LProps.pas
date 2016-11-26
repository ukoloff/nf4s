unit LProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TLEdit = class(TForm)
    N: TEdit;
    X: TLabel;
    K: THotKey;
    L: TEdit;
    H: TEdit;
    B: TButton;
    cbStart: TCheckBox;
  Private
    Procedure SetLayout(Const X: String);
    Function GetLayout: String;
    Procedure SetIsStart(Const X: Boolean);
    Function GetIsStart: Boolean;
  Public
    Property Layout: String Read GetLayout Write SetLayout;
    Property IsStart: Boolean Read GetIsStart Write SetIsStart;
    Procedure New;
    Function Execute: Boolean;
  end;

Function LEdit: TLEdit;

implementation

uses Main;

{$R *.DFM}

Var
  X: TLEdit;

Function LEdit: TLEdit;
Begin
  If X=Nil Then X:=TLEdit.Create(Nil);
  Result:=X;
End;

Procedure TLEdit.SetIsStart(Const X: Boolean);
Begin
  cbStart.Checked:=X;
  cbStart.Enabled:=Not X;
End;

Function TLEdit.GetIsStart: Boolean;
Begin
  Result:=cbStart.Checked;
End;


Procedure TLEdit.SetLayout(Const X: String);
Var
  Z: TStringList;
Begin
  Z:=TStringList.Create;
  Z.CommaText:=X;
  L.Text:='';
  If Z.Count>0 Then L.Text:=Z[0];
  N.Text:='';
  If Z.Count>1 Then N.Text:=Z[1];
  K.HotKey:=0;
  If Z.Count>2 Then K.HotKey:=StrToIntDef(Z[2], 0);
  H.Text:='';
  If Z.Count>3 Then H.Text:=Z[3];
  Z.Free;
End;

Function TLEdit.GetLayout: String;
Var
  Z: TStringList;
Begin
  Z:=TStringList.Create;
  Z.Add(L.Text);
  Z.Add(N.Text);
  Z.Add(IntToStr(K.HotKey));
  If H.Text<>'' Then Z.Add(H.Text);
  Result:=Z.CommaText;
  Z.Free;
End;

Procedure TLEdit.New;
Const
  Ls: Array[1..5]Of Char='FAJVT';
Var
  i: Integer;
  F: TForm;
  S: String;
  WA, B: TRect;
begin
  SystemParametersInfo(spi_GetWorkArea, 0, @WA, 0);
  Inc(WA.Top, MainForm.Height);
  Dec(WA.Bottom, WA.Top); Dec(WA.Right, WA.Left);
  S:='';
  For i:=Screen.FormCount-1 DownTo 0 Do
   Begin
    F:=Screen.Forms[i];
    If Not F.Visible Or(F.Tag=0)Then Continue;
    If S<>'' Then S:=S+';';
    S:=S+Ls[F.Tag];
    B:=F.BoundsRect;
    B.Left:=Round((B.Left-WA.Left)*100/WA.Right);
    If B.Left>0 Then S:=S+IntToStr(B.Left);
    B.Top:=Round((B.Top-WA.Top)*100/WA.Bottom);
    S:=S+',';
    If B.Top>0 Then S:=S+IntToStr(B.Top);
    B.Right:=Round((B.Right-WA.Left)*100/WA.Right);
    S:=S+',';
    If B.Right<100 Then S:=S+IntToStr(B.Right);
    B.Bottom:=Round((B.Bottom-WA.Top)*100/WA.Bottom);
    If B.Bottom<100 Then S:=S+','+IntToStr(B.Bottom);
    While S[Length(S)]=',' Do SetLength(S, Length(S)-1);
   End;
  N.Text:='����� ���������';
  L.Text:=S;
  H.Text:='';
  K.HotKey:=0;
//  For i:=Ord('a')To Ord('z')Do
//    If(L.IndexOfObject(Pointer(i))<0)And
//      (L.IndexOfObject(Pointer(UpCase(Chr(i))))<0) Then Break;
End;

Function TLEdit.Execute: Boolean;
Begin
  ActiveControl:=Nil;
  Result:=ShowModal=id_Ok;
End;

end.

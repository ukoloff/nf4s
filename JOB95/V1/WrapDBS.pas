unit WrapDBS;

Interface uses
  SirMath, SirDBS,
  Classes, Controls;

Type
  TDbsView=Class(TCustomControl)
    Constructor Create(AOwner: TComponent); override;

    Procedure SetPort(Const R: TRectan);
    Procedure DrawCopy(Copy: TCopy);
    Procedure DrawDBS(Const DBS: TDBS);

    Procedure DrawCross;

    Property Canvas;
  Private
    FOnPaint: TNotifyEvent;
    ViewPort: TViewPort;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    Procedure DrawRibbon;
  Published
    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
  End;

  TRDBS=Object(TDBS)
    R: TRectan;

    Procedure Load(FName: String);
    Function Size: TComplex;
    Function SizeStr: String;
  End;


Implementation uses
  Windows,
  SysUtils,
  StdCtrls, Graphics;

{TDBS}
Procedure TRDBS.Load(FName: String);
Var
  S: TFileStream;
Begin
  Clear;
  S:=TFileStream.Create(FName, fmOpenRead);
  Inherited Load(S);
  S.Free;
  R:=Bounds;
End;

Function TRDBS.Size: TComplex;
Begin
  Result:=R.Max;
  Result.Sub(R.Min);
End;

Function TRDBS.SizeStr: String;
Var
  Q: TComplex;
Begin
  If R.Empty Then
    SizeStr:='* * *'
  Else
   Begin
    Q:=Size;
    SizeStr:=FormatFloat('#,', Q.Re)+' x '+
             FormatFloat('#,', Q.Im);
   End
End;

{TDbsView}
Constructor TDbsView.Create(AOwner: TComponent);
Begin
  Inherited;
  Align:=alClient;
End;

procedure TDbsView.CreateParams(var Params: TCreateParams);
Begin
  Inherited;
  Inc(Params.ExStyle, ws_ex_ClientEdge);
End;

Procedure TDbsView.SetPort(Const R: TRectan);
Var
  i: SirMath.TRect;
Begin
  i.W:=ClientRect;
  i.O.Grow(-1, -1);
  ViewPort.Init(i, R);
End;

Procedure TDbsView.DrawCopy(Copy: TCopy);
Var
  N: TSpanIterator;
  A: TArcher;
  First: Boolean;
Begin
  N.Init(Copy);
  First:=True;
  While N.Advance Do
   Begin
    If N.Flags And nfArc<>0 Then
      A.Init(N.vA, N.vB, N.K, ViewPort)
    Else
      A.InitLine(N.vA, N.vB, ViewPort);
    If First Then
     Begin
      A.First;
      Canvas.MoveTo(A.X, A.Y);
     End;
    First:=False;
    Repeat
      A.Next;
      Canvas.LineTo(A.X, A.Y);
    Until A.Done;
   End;
End;

Procedure TDbsView.DrawDBS(Const DBS: SirDBS.TDBS);
Var
  i: Integer;
Begin
  For i:=Dbs.Copies.Count-1 DownTo 0 Do
    DrawCopy(TCopy(Dbs.Copies.Items[i]));
End;

Procedure TDbsView.DrawCross;
Begin
  With Canvas Do
   Begin
    Pen.Color:=cl3DLight;
    MoveTo(0, 1); LineTo(ClientWidth, ClientHeight+1);
    MoveTo(0, ClientHeight+1); LineTo(ClientWidth, 1);
    Pen.Color:=cl3DDkShadow;
    MoveTo(0, -1); LineTo(ClientWidth, ClientHeight-1);
    MoveTo(0, ClientHeight-1); LineTo(ClientWidth, -1);
    Pen.Color:=clBlack;
   End;
End;

procedure TDbsView.Paint;
Begin
  Inherited;
  If Assigned(FOnPaint)Then
    FOnPaint(Self);
End;

Var
  Ribbon: SirMath.TRect;

procedure TDbsView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  If Button=mbLeft Then
   Begin
    Ribbon.A.X:=X;
    Ribbon.A.Y:=Y;
    Ribbon.B:=Ribbon.A;
   End;
End;

procedure TDbsView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  If Button<>mbLeft Then Exit;
  DrawRibbon;
  If (Abs(Ribbon.A.X-Ribbon.B.X)<2)Or(Abs(Ribbon.A.Y-Ribbon.B.Y)<2)Then Exit;
  SetPort(ViewPort.I2FRect(Ribbon));
  Invalidate;
End;

procedure TDbsView.MouseMove(Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  If Not MouseCapture Then Exit;
  DrawRibbon;
  Ribbon.B.X:=X;
  Ribbon.B.Y:=Y;
  DrawRibbon;
End;

Procedure TDbsView.DrawRibbon;
Var
  P: SirMath.TRect;
Begin
  If Ribbon.A.X>Ribbon.B.X Then
   Begin
    P.A.X:=Ribbon.B.X;
    P.B.X:=Ribbon.A.X;
   End
  Else
   Begin
    P.A.X:=Ribbon.A.X;
    P.B.X:=Ribbon.B.X;
   End;
  If Ribbon.A.Y>Ribbon.B.Y Then
   Begin
    P.A.Y:=Ribbon.B.Y;
    P.B.Y:=Ribbon.A.Y;
   End
  Else
   Begin
    P.A.Y:=Ribbon.A.Y;
    P.B.Y:=Ribbon.B.Y;
   End;
  Canvas.DrawFocusRect(P.W);
End;

end.

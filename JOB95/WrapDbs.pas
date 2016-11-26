unit WrapDBS;

Interface uses
  SirMath, SirDBS,
  Classes, Controls;

Type
  TMouseMode=(mmZoom, mmDrag, mmMeter);
  TDbsView=Class(TCustomControl)
    Constructor Create(AOwner: TComponent); override;

    Procedure SetPort(Const R: TRectan);
    Procedure DrawCopy(Copy: TCopy);
    Procedure DrawDBS(Const DBS: TDBS);

    Procedure DrawCross;

    Property Canvas;
  Private
    FOnPaint: TNotifyEvent;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    Procedure DrawRibbon;
    Procedure DrawBoxRibbon;
    Procedure DrawLineRibbon;
    Function i2Str(Const T: TPoint): String;
  Public
    Bounds: TRectan;
    ViewPort: TViewPort;
    
    MouseMode: TMouseMode;

    Procedure UpdateCursor;
    Procedure MeterHint;
  Published
    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
    Property PopupMenu;
  End;

// Класс, который при запуске нити вызывает метод произвольного объекта
  TSafeThread=Class(TThread) 
    OnExecute: TNotifyEvent;
    Procedure Sync(LocalProc: Pointer); Register;
  Private
    _EBP, _Proc: Pointer;
    Procedure Action; Register;
    Procedure Execute; Override;
  End;

// Класс, который в качестве своего метода вызывает локальную процедуру
  TLocalObject=Object
    Procedure Init(Proc: Pointer); Register;
    Procedure Action(Const X: TComplex); Register;
  Private
    _EBP, _Proc: Pointer;
  End;


  TRDBS=Object(TDBS)
    R: TRectan;

    Procedure LoadByName(FName: String);
    Procedure LoadFrom(S: TStream);
    Function Size: TComplex;
    Function SizeStr: String;

    Procedure MoveTo(Const Pole: TComplex);
    Procedure Rotate90;
  End;


Implementation uses
  Windows,
  SysUtils,
  StdCtrls, Graphics;

{$O+,W-}  {Иначе стек настраивает по-другому...}
Procedure TSafeThread.Action;
Begin
  If Terminated Then Abort;
  Asm
    Push [EAX]._EBP   {Parent's stack frame}
    Call [EAX]._Proc
    Pop  ECX        {Restore stack frame}
  End;
End;

Procedure TSafeThread.Sync(LocalProc: Pointer);
Begin
  Asm
    Mov  EAX._EBP, EBP
  End;
  _Proc:=LocalProc;
  If Terminated Then Abort;
  Synchronize(Action);
End;

Procedure TSafeThread.Execute;
Begin
  If Assigned(OnExecute) Then
    Try
      OnExecute(Self)
    Except // No errors
    End;
End;

{TLocalObject}
Procedure TLocalObject.Init(Proc: Pointer); Assembler;
Asm
  Mov [EAX]._EBP, EBP
  Mov [EAX]._Proc, EDX
End;

Procedure TLocalObject.Action(Const X: TComplex); Assembler;
Asm
  Push [EAX]._EBP
//  Push EDX
  XCHG EAX, EDX
  Call [EDX]._Proc
  Pop  ECX
End;

{TDBS}
Procedure TRDBS.LoadByName(FName: String);
Var
  S: TFileStream;
Begin
  S:=TFileStream.Create(FName, fmOpenRead);
  Try
    LoadFrom(S);
  Finally
    S.Free
  End;
End;

Procedure TRDBS.LoadFrom(S: TStream);
Begin
  Clear;
  Load(S);
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

Procedure TRDBS.MoveTo(Const Pole: TComplex);
Var
  D: TComplex;
Begin
  D:=Pole; D.Sub(R.Min);
  Shift(D);
  R.Shift(D)
End;

Procedure TRDBS.Rotate90;
Var
  i: Integer;
  X: TComplex;
Begin
  For i:=Copies.Count-1 DownTo 0 Do
    TCopy(Copies.Items[i]).Geo.MulI;
  X:=R.Min;
  R.MulI;
  MoveTo(X);
End;

{TDbsView}
Constructor TDbsView.Create(AOwner: TComponent);
Begin
  Inherited;
  Align:=alClient;
  UpdateCursor;
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
  Canvas.Pen.Color:=clWindowText;
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
  RibbonActive: Boolean;
  Ribbon: SirMath.TRect;

procedure TDbsView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  If Button=mbLeft Then
   Begin
    Ribbon.A.X:=X;
    Ribbon.A.Y:=Y;
    Ribbon.B:=Ribbon.A;
    RibbonActive:=True;
   End;
End;

procedure TDbsView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  If Not RibbonActive Or(Button<>mbLeft)Then Exit;
  RibbonActive:=False;
  DrawRibbon;
  If MouseMode<>mmZoom Then Exit;
  If (Abs(Ribbon.A.X-Ribbon.B.X)<2)Or(Abs(Ribbon.A.Y-Ribbon.B.Y)<2)Then Exit;
  SetPort(ViewPort.I2FRect(Ribbon));
  Invalidate;
End;

Function TDbsView.i2Str(Const T: SirMath.TPoint): String;
Var
  R: TComplex;
Begin
  Try
    R:=ViewPort.I2F(T);
    Result:=Format('(%.0n; %.0n)', [R.Re, R.Im]);
  Except
    Result:='';
  End;
End;

procedure TDbsView.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  DD: SirMath.TPoint;
Begin
  Inherited;
  DD.X:=X; DD.Y:=Y;
  Hint:=i2Str(DD);
  If Not RibbonActive Then Exit;
  DrawRibbon;
  Ribbon.B.X:=X;
  Ribbon.B.Y:=Y;
  DrawRibbon;
  If MouseMode=mmMeter Then
    MeterHint;
  If MouseMode<>mmDrag Then Exit;
  TPointObj(DD):=TPointObj(Ribbon.B); DD.O.Sub(TPointObj(Ribbon.A));
  ViewPort.Move(DD);
  Ribbon.A:=Ribbon.B;
  Hint:='Движение';
  Invalidate;
End;

Procedure TDbsView.DrawRibbon;
Begin
  Case MouseMode Of
    mmZoom: DrawBoxRibbon;
    mmMeter: DrawLineRibbon;
  End{Case};
End;

Procedure TDbsView.DrawLineRibbon;
Var
  M: TPenMode;
Begin
  M:=Canvas.Pen.Mode;
  Canvas.Pen.Mode:=pmNot;
  Canvas.MoveTo(Ribbon.A.X, Ribbon.A.Y);
  Canvas.LineTo(Ribbon.B.X, Ribbon.B.Y);
  Canvas.Pen.Mode:=M;
End;

Procedure TDbsView.DrawBoxRibbon;
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

Procedure TDbsView.UpdateCursor;
Begin
  Case MouseMode Of
    mmZoom: Cursor:=crArrow;
    mmDrag: Cursor:=crHandPoint;
    mmMeter: Cursor:=crCross;
  End{Case};
End;

Procedure TDbsView.MeterHint;
Var
  A, B: TComplex;
Begin
  A:=ViewPort.I2F(Ribbon.A);
  B:=ViewPort.I2F(Ribbon.B);
  B.Sub(A);
  Hint:=Format('%s: (%.0n; %.0n)=%.0n@%.0n', [Hint, B.Re, B.Im, B.Abs, B.Arg*180/Pi]);
End;

end.

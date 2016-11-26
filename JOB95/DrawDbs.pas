Unit DrawDbs;

Interface uses
  Classes, Controls,
  SirMath, SirDbs;

Type
  TDbsView=Class(TCustomControl)
  Private
    FOnPaint: TNotifyEvent;
    ViewPort: TViewPort;
    procedure CreateParams(var Params: TCreateParams); override;
  Public
    Rectan: TRectan;

    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
    Property PopupMenu;

    Constructor Create(aParent: TWinControl);

    Procedure DrawCopy(Copy: TCopy);
    Procedure DrawDBS(Const DBS: TDBS);
    Procedure DrawCross;
    Procedure SetRectan(Const R: TRectan);
    Function ViewRect: TRect;
  End;

Implementation uses
  Windows, Graphics;

{TDbsView}
Constructor TDbsView.Create(aParent: TWinControl);
Begin
  Inherited Create(aParent.Owner);
  Parent:=aParent;
  Align:=alClient;
End;

procedure TDbsView.CreateParams(var Params: TCreateParams);
Begin
  Inherited;
  Inc(Params.ExStyle, ws_ex_ClientEdge);
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

Procedure TDbsView.DrawDBS(Const DBS: TDBS);
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
   End;
End;

Procedure TDbsView.SetRectan(Const R: TRectan);
Begin
  ViewPort.Init(ViewRect, R);
  Rectan:=R;
  Invalidate;
End;

Function TDbsView.ViewRect: SirMath.TRect;
Begin
  Result.W:=ClientRect;
  Result.O.Grow(-1, -1);
End;

End.

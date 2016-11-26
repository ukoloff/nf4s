Unit View;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus,
  SirMath, SirDbs, WrapDBS, KapDll;

type
  TViewForm = class(TForm)
    Info: TLabel;
    MainMenu1: TMainMenu;
    MenuSingle: TMenuItem;
    N2: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    mR: TPopupMenu;
    mM: TMenuItem;
    procedure MenuSingleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ViewPaint(Sender: TObject);
    procedure ZoomToFit(Sender: TObject);
    procedure ThreadDone(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure dMode(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure mPopupPopup(Sender: TObject);
    procedure mMClick(Sender: TObject);
    procedure Motion(Sender: TObject);
    procedure UpTo(Sender: TObject);
    procedure mRPopup(Sender: TObject);
  private
    Bounds: TRectan;
    Thread: TThread;
    FJob: Integer;
    fKapral: PKapral;
    URL: String;

    Procedure SetThread(aThread: TThread);
    Procedure DrawDbs(Const D: TRDbs; Thread: TObject);
    Procedure DrawFile(Thread: TObject);
    Procedure DrawJob(Thread: TObject);
    Procedure DrawKapral(Thread: TObject);
    Procedure ClearKapral;
  public
    View: TDbsView;
    Procedure ViewIt(FileName: String);
    Procedure StartJobDisplay;
    Procedure StartKapralDisplay(P: PKapral);
    Procedure Zoom(Factor: Float);
  end;

Function ViewForm: TViewForm;

Implementation uses
  SirReg, Job, Struc, Nesting, Main, TxtFrm;

{$R *.DFM}

Var
  FViewForm: TViewForm;

Function ViewForm: TViewForm;
Begin
  If FViewForm=Nil Then
    FViewForm:=TViewForm.Create(Nil);
  Result:=FViewForm
End;

Procedure TViewForm.DrawDbs(Const D: TRDbs; Thread: TObject);
Var
  i: Integer;
  T: TSafeThread Absolute Thread;
 Procedure Bnd;
 Begin
  If Bounds.Empty Then
    View.SetPort(D.R);
  Bounds.Union(D.R);
  Info.Caption:=Format('%.0n x %.0n', [Bounds.Size.Re, Bounds.Size.Im]);
 End;
 Procedure aCopy;
 Begin
   View.DrawCopy(TCopy(D.Copies.Items[i]));
 End;
Begin
  T.Sync(@Bnd);
  For i:=D.Copies.Count-1 DownTo 0 Do
    T.Sync(@aCopy);
End;

{$O-}
Procedure TViewForm.DrawFile(Thread: TObject);
Var
  D: TRDBS;
  S: TStream;
  T: TSafeThread Absolute Thread;
 Procedure GetData;
 Var
   I: TJobItem;
 Begin
   I:=TJobItem.Create(Nil);
   I.AsLst:=URL;
   S:=I.GetStream;
   I.Free;
   If S=Nil Then
    Begin
     Fjob:=0;
     URL:='';
     Abort;
    End;
 End;
Begin
  T.Sync(@GetData);
  D.Init;
  Try
   D.LoadFrom(S);
   S.Free; S:=Nil;
   DrawDbs(D, T);
  Finally
   D.Done;
   S.Free;
  End;
End;

Procedure TViewForm.DrawJob(Thread: TObject);
Var
  T: TSafeThread Absolute Thread;
  I: TIterator;
  O: TLocalObject;
  N: TNester;
  D: TRDbs;
  St: TStream;
  Cnt: Integer;
 Procedure GetList;
 Begin
   I.Init(JobForm);
   If Not I.Next Then
    Begin
     FJob:=0;
     View.Invalidate;
     Abort;
    End;
   St:=I.GetStream;
 End;
 Procedure Load;
 Begin
   D.LoadFrom(St);
   St.Free; St:=Nil;
 End;
 Procedure Next;
 Begin
   If Not I.Next Then Abort;
   St:=I.GetStream;
   Cnt:=I.Count;
 End;
 Procedure MoveTo(Const Pos: TComplex);
 Var
   R: TComplex;
 Begin
   R:=Pos; R.Sub(D.R.Min);
   D.R.Shift(R);
   D.Shift(R);
 End;
 Procedure Place(Const X: TComplex); Register;
 Begin
   MoveTo(X);
   DrawDbs(D, Thread);
 End;
Begin
  St:=Nil; N:=Nil; D.Init;
  Try
    T.Sync(@GetList);
    Load;
    DrawDbs(D, Thread);
    N:=TNester.Create(D.R);
    N.Offset:=Params.Param['Distance'].AsInteger;
//    N.Margin:=1;
    O.Init(@Place);
    N.OnPlace:=O.Action;
    Repeat
      T.Sync(@Next);
      Load;
      MoveTo(cx_0);
//      Place(cx_0);
      N.Tile(D.R.Max, Cnt);
    Until False;
  Finally
    D.Done;
    N.Free;
    St.Free;
  End;
End;

procedure TViewForm.MenuSingleClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
begin
  M.Checked:=Not M.Checked;
end;

procedure TViewForm.FormCreate(Sender: TObject);
begin
//  D.Init;
//  D.R.Empty:=True;
  View:=TDbsView.Create(Self);
  View.Parent:=Self;
  View.OnPaint:=ViewPaint;
  View.PopupMenu:=mR
end;

Procedure TViewForm.ViewIt(FileName: String);
Begin
  TextForm.ViewIt(FileName);
  If FileName='' Then
   Begin
    View.Invalidate;
    URL:='';
    FJob:=0; Exit;
   End;
  If FileName=URL Then Exit;
  FJob:=1;
  SetThread(Nil);
  Bounds.Empty:=True;
  URL:=FileName;
  View.Invalidate;
End;

procedure TViewForm.ViewPaint(Sender: TObject);
Var
  T: TSafeThread;
begin
  If FJob=0 Then
   Begin
    View.DrawCross;
    Exit;
   End;
//  If fJob<>3 Then ClearKapral; 
  T:=TSafeThread.Create(True);
  T.FreeOnTerminate:=True;
  T.OnTerminate:=ThreadDone;
  Case fJob Of
   1: T.OnExecute:=DrawFile;
   2: T.OnExecute:=DrawJob;
   3: T.OnExecute:=DrawKapral
  End{Case};
  SetThread(T);
  T.Resume;
end;

procedure TViewForm.ZoomToFit(Sender: TObject);
begin
  If FJob=0 Then Exit;
  View.Invalidate;
  View.SetPort(Bounds);
end;

procedure TViewForm.ThreadDone(Sender: TObject);
begin
  If Thread=Sender Then Thread:=Nil
end;

Procedure TViewForm.SetThread(aThread: TThread);
Begin
  If Thread<>Nil Then Thread.Terminate;
  Thread:=aThread;
End;

procedure TViewForm.N2Click(Sender: TObject);
begin
  TMenuItem(Sender).Items[Ord(View.MouseMode)].Checked:=True;
end;

procedure TViewForm.dMode(Sender: TObject);
begin
  View.MouseMode:=TMouseMode(TMenuItem(Sender).Tag);
  View.UpdateCursor;
end;

Procedure TViewForm.StartJobDisplay;
Begin
  SetThread(Nil);
  URL:='';
  FJob:=2;
  Bounds.Empty:=True;
  View.Invalidate;
End;

procedure TViewForm.FormHide(Sender: TObject);
begin
  SetThread(Nil);   //Don't continue drawing
end;

Procedure TViewForm.Zoom(Factor: Float);
Var
  W: TRectan;
Begin
  If FJob=0 Then Exit;
  W:=View.ViewPort.I2FRect(TRect(View.ClientRect));
  W.Expand(Factor);
  W.Intersect(Bounds);
  View.SetPort(W);
  View.Invalidate;
End;

procedure TViewForm.mPopupPopup(Sender: TObject);
begin
  TPopupMenu(Sender).Items[Ord(View.MouseMode)].Checked:=True;
end;

procedure TViewForm.mMClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  For i:=M.Count-1 DownTo 0 Do
    If M[i].Tag=0 Then M[i].Enabled:=FJob>0;
end;

procedure TViewForm.Motion(Sender: TObject);
Var
  P: TPoint;
  N: Integer;
begin
  N:=TMenuItem(Sender).Tag;
//  Caption:=IntToStr(N);
  If N>3 Then
   Begin
    P.X:=View.ClientWidth Div 10;
    P.Y:=0;
    If(N And 3)<2 Then P.X:=P.X*9;
    If Not Odd(N) Then P.X:=-P.X;
   End
  Else
   Begin
    P.Y:=View.ClientHeight Div 10;
    P.X:=0;
    If(N And 3)<2 Then P.Y:=P.Y*9;
    If Not Odd(N) Then P.Y:=-P.Y;
   End;
  View.ViewPort.Move(P);
  View.Invalidate;
end;

procedure TViewForm.UpTo(Sender: TObject);
Var
  R: SirMath.TRect;
begin
  R.W:=View.ClientRect;
  R.O.Grow(-1, -1);
  View.ViewPort.Collate(R, Bounds, TMenuItem(Sender).Tag);
  View.Invalidate;
end;

procedure TViewForm.mRPopup(Sender: TObject);
begin
  FillPopup(mR, mM);
end;

Procedure TViewForm.ClearKapral;
Begin
  If fKapral=Nil Then Exit;
  fKapral.Done;
  Dispose(fKapral);
  fKapral:=Nil;
End;

Procedure TViewForm.StartKapralDisplay(P: PKapral);
Begin
  ClearKapral;
  fKapral:=P;
  SetThread(Nil);
  URL:='';
  fJob:=3;
  Bounds:=fKapral.Bounds;
  View.Invalidate;
End;

Procedure TViewForm.DrawKapral(Thread: TObject);
Var
  T: TSafeThread Absolute Thread;
  i, j, n: Integer;
  P: TComplex;
  R: PKapralResult;
Begin
  P:=cx_0;
//  For i:=0 To fKapral.Lists.Count-1 Do
  With TKapralDetail(fKapral.Lists.Items[0])Do
    For i:=Count-1 DownTo 0 Do
     Begin
      Dbs.MoveTo(cx_0); //P);
      DrawDbs(Dbs, T);
//      P.Add(Dbs.Size);
     End;
  For i:=0 To fKapral.Details.Count-1 Do
    With TKapralDetail(fKapral.Details.Items[i])Do
      Try
        n:=0;
        For j:=Count-1 DownTo 0 Do
         Begin
          R:=Results[j];
          P.Assign(R.X, R.Y);
          Dbs.MoveTo(P);
          If Odd(R.Rotated Xor n) Then
           Begin
            Inc(n);
            Dbs.Rotate90;
           End;
          DrawDbs(Dbs, T);
         End;
      Finally
        For n:=((4-n) And 3) DownTo 1 Do
          Dbs.Rotate90; //�� ���������� ������ n ��� - ���������� �� �����
      End;
End;

End.


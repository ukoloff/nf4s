unit PrnTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    dSetup: TPrinterSetupDialog;
    bSetup: TButton;
    bPrint: TButton;
    bOpen: TButton;
    dOpen: TOpenDialog;
    procedure bSetupClick(Sender: TObject);
    procedure bPrintClick(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation uses
  Printers, SirDBS, SirMath;

{$R *.DFM}

Function GCD(X, Y: Integer): Integer;
Begin
  If X<Y Then
   Begin
    Result:=X; X:=Y; Y:=Result;
   End;
  While Y>0 Do
   Begin
    Result:=X Mod Y;
    X:=Y; Y:=Result;
   End;
  Result:=X;
End;

Procedure XXX(Var X: TSize);
Var
  C: Integer;
Begin
  C:=GCD(Abs(X.cx), Abs(X.cy));
  X.cx:=Abs(X.cx) Div C;
  X.cy:=Abs(X.cy) Div C;
End;

Function Aspect(DC: THandle): TSize;
Var
  T: TSize;
Begin
  SetMapMode(DC, mm_Isotropic);
  GetViewportExtEx(DC, Result);
  GetWindowExtEx(DC, T);
  SetMapMode(DC, mm_Text);
  XXX(Result);
  XXX(T);
  Result.cx:=Result.cx*T.cx;
  Result.cy:=Result.cy*T.cy;
  XXX(Result);
End;

procedure TForm1.bSetupClick(Sender: TObject);
begin
  dSetup.Execute;
end;
{$O-}
procedure TForm1.bPrintClick(Sender: TObject);
Var
  D: TDbs;
  S: TFileStream;
  P: TRect;
  VP: TViewPort;
  i: Integer;
  SI: TSpanIterator;
  Ar: TArcher;
  First: Boolean;
  SZ: TSize;
begin
{  S:=TFileStream.Create(dOpen.FileName, fmOpenRead);
  D.Init;
  D.Load(S);
  S.Free; {}
  P.O.Assign(1, 1, Printer.PageWidth-1, Printer.PageHeight-1);
//  VP.Init(P, D.Bounds);
  Printer.Title:='Проба печати из под Delphi';
  Printer.BeginDoc;
//  SetMapMode(Printer.Canvas.Handle, mm_HiMetric);
  SZ:=Aspect(Printer.Canvas.Handle);
  Printer.Abort;
  Exit;
  With Printer.Canvas.Pen Do
   Begin
    Color:=clBlack;
    Mode:=pmCopy;
    Style:=psSolid;
    Width:=1;
   End;
//  SetMapMode(Printer.Canvas.Handle, mm_Text);
  For i:=D.Copies.Count-1 DownTo 0 Do
   Begin
//    Caption:=IntToStr(Canvas.Pen.Width);//:=1000;
    Canvas.Pen.Width:=100;
    SI.Init(TCopy(D.Copies.Items[i]));
    First:=True;
    While SI.Advance Do
     Begin
      If SI.Flags And nfArc<>0 Then
        Ar.Init(SI.vA, SI.vB, SI.K, VP)
      Else
        Ar.InitLine(SI.vA, SI.vB, VP);
      If First Then
       Begin
        Ar.First;
        Printer.Canvas.MoveTo(Ar.X, Ar.Y);
       End;
      First:=False;
      Repeat
        Ar.Next;
        Printer.Canvas.LineTo(Ar.X, Ar.Y);
      Until Ar.Done;
     End;
   End;
  Printer.EndDoc;
end;

procedure TForm1.bOpenClick(Sender: TObject);
begin
  bPrint.Enabled:=dOpen.Execute;
end;

end.

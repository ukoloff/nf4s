unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    MainMenu1: TMainMenu;
    Directory1: TMenuItem;
    Exit1: TMenuItem;
    Test1: TMenuItem;
    Repaint1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Directory1Click(Sender: TObject);
    procedure Test1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Repaint1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Implementation uses
  SirDBS, SirMath, Unit2;

{$R *.DFM}

Var
  D: TDBS;

procedure TForm1.Button2Click(Sender: TObject);
Var
  S: TStream;
begin
  Caption:=Form2.FileListBox1.FileName;
  S:=TFileStream.Create(Caption, fmOpenRead);
  D.Clear;
  D.Load(S);
  S.Free;
  PaintBox1.Invalidate;
end;

procedure SpeedTest;
Const
  N=100;
Var
  S: TStream;
  M: TMemoryStream;
  i: Integer;
  A: TDateTime;
begin
  S:=TFileStream.Create('D:\Work\Eq\DBS\Worota.DBS', fmOpenRead);
  M:=TMemoryStream.Create;
  M.CopyFrom(S, 0);
  S.Free;
  A:=Now;
  For i:=1 To N Do
   Begin
    D.Clear;
    M.Seek(0, soFromBeginning);
    D.Load(M);
   End;
  A:=(Now-A)/N*24*60*60;
  Application.MessageBox(PChar(Format('%0.4f sec', [A])), 'Load time', 0);

  M.Free;

  A:=Now;
  For i:=1 To N Do
    D.Bounds;
  A:=(Now-A)/N*24*60*60;
  Application.MessageBox(PChar(Format('%0.4f sec', [A])), 'CalcBounds time', 0);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
Var
  I: TRect;
  V: TViewPort;
  N: TSpanIterator;
  Ar: TArcher;
  j: Integer;
  First: Boolean;
begin
  I.W:=PaintBox1.ClientRect;
  I.O.Grow(-1, -1);
  V.Init(I, D.Bounds);
  For j:=D.Copies.Count-1 DownTo 0 Do
   Begin
    N.Init(TCopy(D.Copies.Items[j]));
    First:=True;
    While N.Advance Do
     Begin
      If N.Flags And nfArc<>0 Then
        Ar.Init(N.vA, N.vB, N.K, V)
      Else
        Ar.InitLine(N.vA, N.vB, V);
      If First Then
       Begin
        Ar.First;
        PaintBox1.Canvas.MoveTo(Ar.X, Ar.Y);
       End;
      First:=False;
      Repeat
        Ar.Next;
        PaintBox1.Canvas.LineTo(Ar.X, Ar.Y);
//        PaintBox1.Canvas.TextOut(Ar.X, Ar.Y, '*');
//        PaintBox1.Canvas.MoveTo(Ar.X, Ar.Y);
      Until Ar.Done;
     End;
   End;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  D.Init;
//  PaintBox1.Canvas.Pen.Color:=clPurple;
end;


procedure TForm1.FormShow(Sender: TObject);
begin
  Form2.Show
end;

procedure TForm1.Directory1Click(Sender: TObject);
begin
  Form2.Show
end;

procedure TForm1.Test1Click(Sender: TObject);
begin
  SpeedTest
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.Repaint1Click(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;

end.

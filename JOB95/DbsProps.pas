unit DbsProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  WrapDbs;

type
  TPropsDlg = class(TForm)
    Button1: TButton;
    S: TEdit;
    Label1: TLabel;
    P: TEdit;
    Label2: TLabel;
    R: TEdit;
    Label3: TLabel;
    Q: TEdit;
    Label4: TLabel;
    cCnt: TEdit;
    Dsq: TEdit;
    Label5: TLabel;

    Procedure Display(Const D: TRDbs);
    Procedure DisplayFromStream(S: TStream);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PropsDlg: TPropsDlg;

implementation uses
  SirMath, SirDbs;

{$R *.DFM}

Procedure TPropsDlg.Display(Const D: TRDbs);
Var
  i: Integer;
  SS, PP, MaxS, SumS: Float;
  C: TCopy;
Begin
  cCnt.Text:=IntToStr(D.Copies.Count);
  Dsq.Text:=D.Description;
  MaxS:=0; SumS:=0;
  For i:=D.Parts.Count-1 DownTo 0 Do
   Begin
    PP:=Abs(TPart(D.Parts.Items[i]).Area);
    If MaxS<PP Then MaxS:=PP;
    SumS:=SumS+PP;
   End;
  SumS:=SumS-MaxS;
  SS:=0; PP:=0;
  For i:=D.Copies.Count-1 DownTo 0 Do
   Begin
    C:=TCopy(D.Copies.Items[i]);
    SS:=SS+C.Area;
    PP:=PP+C.Perimeter;
   End;
  S.Text:=Format('%0.3n', [SS*1E-4]);
  P.Text:=FloatToStrF(PP*1E-2, ffNumber, 18, 3);
  R.Text:=Format('%0.0n x %0.0n', [D.R.Max.Re-D.R.Min.Re, D.R.Max.Im-D.R.Min.Im]);
  Q.Text:='';
  If SumS>0 Then
    Q.Text:=Format('%0.0n%%', [SumS/MaxS*100]);
  ShowModal;
End;

Procedure TPropsDlg.DisplayFromStream(S: TStream);
Var
  D: TRDbs;
Begin
  D.Init;
  Try
    D.Load(S);
    D.R:=D.Bounds;
    Display(D);
  Finally
    D.Done;
    S.Free;
  End;
End;

end.

program DbsCreate;

uses
  Windows, SysUtils, Classes,
  SirMath in '..\DBS\SirMath.pas',
  SirDBS in '..\DBS\SirDBS.pas';

{$R *.RES}

Const
  Formats='CROSS;RECT;TRIANGLE;CIRCLE;RING;POLYGON;SEGMENT';
  Vars='W;H;L;R;RI;N;A';

Var
  OutName, DbsDesq: String;
  Format: Integer;
  Params: TStringList;

Procedure Help;
Begin
  MessageBox(0,
   'Usage: DbsCreate TextFile'^M'See DbsCreate.txt', 'Help & Usage',
    mb_IconInformation);
  Halt(1);
End;

Procedure SetParam(Name: String; Value: Float);
Var
  i: Integer;
  P: ^Float;
Begin
  i:=Params.IndexOf(Name);
  If i<0 Then
    i:=Params.Add(Name);
  P:=Pointer(Params.Objects[i]);
  If P<>Nil Then P^:=Value
  Else
   Begin
    New(P);
    P^:=Value;
    Params.Objects[i]:=Pointer(P)
   End;
End;

Function GetParam(Name: String): Float;
Var
  i: Integer;
  P: ^Float;
Begin
  Result:=0;
  i:=Params.IndexOf(Name);
  If i<0 Then
    Exit;
  P:=Pointer(Params.Objects[i]);
  If P<>Nil Then Result:=P^
End;

Function CheckFormat(S: String): Integer;
Var
  i, j, n, MaxMatch: Integer;
Begin
  Result:=0; n:=0; MaxMatch:=0;
  i:=0;
  Repeat
    j:=0;
    Inc(i); Inc(n);
    While(j<Length(S))
         And(j+i<=Length(Formats))And(Formats[i+j]<>';')
         And(S[j+1]=Formats[i+j]) Do
      Inc(j);
    If j>MaxMatch Then
     Begin {Новое длиннейшее совпадение}
      MaxMatch:=j;
      Result:=n;
     End
    Else If j=MaxMatch Then
      Result:=0; {Ещё одно совпадение той же длины - вообще не совпадение}
    Repeat
      Inc(i);
      If i>=Length(Formats) Then Exit;
    Until Formats[i]=';';
  Until False;
End;

Function CheckParam(S: String): Boolean;
Var
  i: Integer;
  X: String;
Begin
  Result:=True;
  If(Length(S)=4)And(S[3]='.')And(Pos(S[1], 'LU')>0)And(Pos(S[2], 'LR')>0)
    And(Pos(S[4], 'HRW')>0) Then
    Exit;
  X:=Vars;
  Repeat
   i:=Pos(';', X);
   If i<=0 Then i:=1+Length(X);
   If Copy(X, 1, i-1)=S Then
     Exit;
   Delete(X, 1, i);
  Until Length(X)=0;
  Result:=False;
End;

Function Str2Float(S: String): Float;
Var
  i: Integer;
Begin
  Val(S, Result, i);
  If i>0 Then
    Val(Copy(S, 1, i-1), Result, i);
  If i>0 Then Result:=0;
End;

Procedure ParseCmdLine;
Var
  S, P: String;
  i: Integer;
Begin
  If ParamCount<>1 Then Help;
  Params:=TStringList.Create;
  OutName:=ParamStr(1);
  If Not FileExists(OutName) Then
    Halt(2);
  Assign(Input, OutName);
  While Not EOF Do
   Begin
    ReadLN(S);
    S:=Trim(S);
    i:=Pos(';', S);
    If i>0 Then
      Delete(S, i, Length(S));
    S:=Trim(S);
    i:=Pos('=', S);
    If i<=0 Then Continue;
    P:=UpperCase(Trim(Copy(S, 1, i-1)));
    Delete(S, 1, i);
    S:=Trim(S);
    If P='FORMAT' Then Format:=CheckFormat(UpperCase(S))
    Else If P='FILE' Then OutName:=S
    Else If P='DESCRIPTION' Then DbsDesq:=S
    Else If CheckParam(P) Then
      SetParam(P, Str2Float(S));
   End;
  Close(Input);
  If Format=0 Then Help;
End;

Var
  O: TOrig;
  P: TComplex;

Procedure Add;
Begin
  O.AddPoint(P);
End;

Procedure AddQ;
Begin
  Add;
  O.SetK(0.414213);
End;

Procedure AddR;
Begin
  Add;
  O.SetK(-0.414213);
End;

Procedure AnyCircle(R: Float);
Begin
  P.Assign(R, 0);   Add; O.SetK(1);
  P.Negate;         Add; O.SetK(1);
End;

Procedure Circle;
Begin
  AnyCircle(GetParam('R'));
End;

Procedure Triangle;
Begin
  P.Assign(-GetParam('L'), 0); Add;
  P.Re:=GetParam('R');         Add;
  P.Assign(0, GetParam('H'));  Add;
End;

Procedure Cross;
Var
  W, H, X, R: Float;
Begin
  W:=GetParam('W');
  H:=GetParam('H');
//-------------------------------------[LL]
  X:=GetParam('LL.W');
  R:=GetParam('LL.R');
  P.Assign(0, GetParam('LL.H'));
  If(X<>0)And(P.Im<>0) Then
   Begin
                                   Add;
  P.Re:=X-R;                       AddQ;
  P.Assign(X, P.Im-R);             Add;
  P.Im:=0;                         Add;
   End
  Else
   Begin
     P.Im:=R;                      AddR;
     P.Assign(R, 0);               Add;
   End;
//-------------------------------------[LR]
  X:=GetParam('LR.H');
  R:=GetParam('LR.R');
  P.Re:=W-GetParam('LR.W');
  if(P.Re<>W)And(X<>0)Then
   Begin
                                   Add;
  P.Im:=X-R;                       AddQ;
  P.Assign(P.Re+R, X);             Add;
  P.Re:=W;                         Add;
   End
  Else
   Begin
    P.Re:=W-R;                     AddR;
    P.Assign(W, R);                Add;
   End;
//-------------------------------------[UR]
  X:=GetParam('UR.W');
  R:=GetParam('UR.R');
  P.Im:=H-GetParam('UR.H');
  if(X<>0)And(P.Im<>H) Then
   Begin
                                   Add;
  P.Re:=W-X+R;                     AddQ;
  P.Assign(W-X, P.Im+R);           Add;
  P.Im:=H;                         Add;
   End
  Else
   Begin
    P.Im:=H-R;                     AddR;
    P.Assign(W-R, H);              Add;
   End;
//-------------------------------------[UL]
  X:=GetParam('UL.H');
  R:=GetParam('UL.R');
  P.Re:=GetParam('UL.W');
  if(X<>0)And(P.Re<>0)Then
   Begin
                                   Add;
  P.Im:=H-X+R;                     AddQ;
  P.Assign(P.Re-R, H-X);           Add;
  P.Re:=0;                         Add;
   End
  Else
   Begin
    P.Re:=R;                       AddR;
    P.Assign(0, H-R);              Add;
   End;
End;

Procedure Rect;
Var
  W, H: Float;
Begin
  W:=GetParam('W');
  H:=GetParam('H');
  P.Assign(0, GetParam('LL.H'));   Add;
  P.Assign(GetParam('LL.W'), 0);   Add;
  P.Re:=W-GetParam('LR.W');        Add;
  P.Assign(W, GetParam('LR.H'));   Add;
  P.Im:=H-GetParam('UR.H');        Add;
  P.Assign(W-GetParam('UR.W'), H); Add;
  P.Re:=GetParam('UL.W');          Add;
  P.Assign(0, H-GetParam('UL.H')); Add;
End;

Procedure Polygon;
Var
  N: Integer;
  Q: TComplex;
Begin
  N:=Round(GetParam('N'));
  If N<3 Then N:=3;
  P.Assign(0, GetParam('R'));
  If P.Im=0 Then
    P.Im:=GetParam('A')/2/Sin(Pi/N);
  Q.RootN_1(N);
  Repeat
    Add;
    P.Mul(Q);
    Dec(N);
  Until N=0;
End;

Procedure Segment;
Var
  R, H: Float;
Begin
  H:=Abs(GetParam('H'));
  R:=Abs(2*GetParam('R')-H);
  If R<1E-2 Then
    R:=1E-2;
  P.Assign(Sqrt(R*H), 0); Add;
  P.Negate; Add;
  O.SetK(Sqrt(H/R));
End;

Procedure DropShortSpans;
Var
  P, N, X: PSpan;
Begin
  P:=O.Nodes;
  If P=Nil Then Exit;
  X:=Nil;
  Repeat
   N:=P;
   P:=P.B.Dst;
   If(N<>P)And(N.Perimeter<1E-2)Then
    Begin
     P.A:=N.A;
     P.A.Dst:=P;
     Dispose(N.B);
     Dispose(N);
    End
   Else If X=Nil Then
     X:=N; {Этот спан станет первым спаном}
  Until X=P;
  O.Nodes:=X;
End;

Procedure Generate;
Var
  D: TDbs;
  S: TFileStream;
 Procedure newOrig;
 Begin
   O:=TOrig.Create(D.Origs);
 End;
Begin
  D.Init;
  newOrig;
  Case Format Of
   1: Cross;
   2: Rect;
   3: Triangle;
   4: Circle;
   5: Begin Circle; newOrig; AnyCircle(GetParam('RI')); End;
   6: Polygon;
   7: Segment;
  End{Case};
  DropShortSpans;
  D.Reorganize(ChangeFileExt(ExtractFileName(OutName), ''));
  S:=TFileStream.Create(OutName, fmCreate);
  D.Description:=DbsDesq;
  D.Save(S);
  S.Free;
  D.Done;
End;

Begin
  ParseCmdLine;
  Generate;
End.

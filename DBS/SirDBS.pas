Unit SirDBS;
Interface uses
  Classes,
  SirMath;

Const
  nfArc= $01;                 { Ребро является дугой }
  nfMark=$80;                 { Отметка, что ребро обработано }
  nfBadA=$01;                 { Вершина A не входит }
  nfBadB=$02;                 { Вершина B не входит }

Type
  PSpan=^TSpan;
  PVertex=^TVertex;
  TSpan=Object
  Private
    Function GetArcK: TComplex;
    Procedure SetArcK(anArcK: TComplex);
    Function GetAt(Pos: Float): TComplex;
  Public
    A, B: PVertex;
    K: Float;
    Flags: Byte;    { nfXXX }

    Procedure Free;

    Function Center: TComplex;
    Function Radius: Float;
    Function Bounds: TRectan;

    Property ArcK: TComplex Read GetArcK Write SetArcK;
    Property At[Pos: Float]: TComplex Read GetAt; Default;

    Function Area:Float;
    Function Perimeter: Float;
    Function ViewAngle(Const ViewPoint: TComplex): Float;
  End;

  TVertex=Object(TComplex)
    Src, Dst: PSpan;
  End;

  TIndex=Class(TCollectionItem)
  public
    No: Integer;                   {Номер записи}
  End;

  TOrig=Class(TIndex)
  public
    Nodes: PSpan;

    Destructor Destroy; Override;
    Procedure AddPoint(Const X: TComplex);
    Procedure SetK(aK: Float);
    Procedure LastPoint(Const X: TComplex);
    Procedure BreakMe;
  End;

  TCopy=Class(TIndex)
  public
    Original: Word;
    Group: Integer;
    Revers: Integer;
    Geo: TGeo;
    Nodes: PSpan;   {Не владеет им: ссылка на оригинальные спаны}

    Function Valid: Boolean;
    Function Closed: Boolean;
    Function Reversed: Boolean;
    Function Count: Integer;

    Function Bounds: TRectan;
    Function Area:Float;
    Function Perimeter: Float;
    Function ViewAngle(Const ViewPoint: TComplex): Float;
    Function Contains(Const Point: TComplex): Boolean;
    Function IsInside(Another: TCopy): Boolean;

    Procedure StoreData(S: TStream);
    Procedure Store(S: TStream);
  End;

  TSpanIterator=Object(TSpan)
    vA, vB: TVertex;

    Procedure Init(aCopy: TCopy);
    Function Advance: Boolean;
  Private
    Chain: TCopy;
    Span: PSpan;
    Reverse, Mirror: Boolean;
  End;

  TPart=Class(TIndex)
  Private
    Name: Array[1..8]Of Char;
    Circuits: TList;

    Function GetCircuit(No: Integer): TCopy;
    Procedure SetGroupNo;
    Procedure SetString(S: String);
    Function GetString: String;
  Public

    Property AsString: String Read GetString Write SetString;
    Property Circuit[Idx: Integer]: TCopy Read GetCircuit; Default;

    Constructor Create(Collection: TCollection); Override;
    Destructor Destroy; Override;

    Function Count: Integer;
    Procedure Store(S: TStream);

    Function Area:Float;
    Function Perimeter: Float;
  End;

  PDBS=^TDBS;
  TDBS=Object
  Private
    Function GetPart(No: Integer): TPart;
    Procedure SaveDescription(S: TStream);
  Public
    Origs,
    Copies,
    Parts: TCollection;
    Description: String;

    Procedure Init;
    Procedure Done;
    Procedure Clear;

    Procedure Load(S: TStream);
    Function LoadRecord(S: TStream): Boolean;
    Procedure _Save(S: TStream);
    Procedure End_Save(S: TStream);
    Procedure Save(S: TStream);

    Function Area:Float;
    Function Perimeter: Float;
    Function Bounds: TRectan;
    Procedure Shift(Const Disp: TComplex);

    Procedure Complete;
    Function Renumerate(From: Integer): Integer;
    Function CopyRenumerate(From: Integer): Integer;

    Procedure Reorganize(PartName: String);
  End;

  PSpanContainer=^TSpanContainer;
  TSpanContainer=Object
    Span: TCopy;
    AbsS: Float;
    Children: TList;
    PartName: String;

    Procedure Init(Orig: TOrig);
    Procedure Free;

    Procedure InsertChild(P: PSpanContainer);
    Procedure Insert(P: PSpanContainer);

    Procedure FillFrom(Var D: TDbs);
    Procedure PutInto(Var D: TDbs);
  End;

  TEasterEgg=Object {Используется для управления записями $1971 в DBS}
    Stream: TStream;

    Function Available: Boolean;
  End;

Implementation uses
  SysUtils;

Type
  TRec0=Object
    RecLen: Word;
    _0: Record End;
  End;

  TRecDBS=Object(TRec0)
    Mystery1: Word;
    RecLen1: Word;
    Mystery2: Word;
    Kind: Word;
    Zero: Word;
    _Rec: Record End;

    Procedure PreWrite;
  End;

  TRec1=Object(TRecDBS)          {Геометрия контура 1-исходного/2-копия}
    Num:     Word; {Номер контура}
    Zero1:   Word;
    SubType: Word; {Подтип записи}
    Zero2:   Word;
    Text:    Word; {Признак наличия текста}
    Zero3:   Word;
    Auto:    Word; {Автопоследовательность}
    Zero4:   Word;
    Group:   Word; {Номер группы}
    Zero5:   Word;
    Orig:    Word; {Номер контура оригинальной кривой}
    Zero6:   Word;
    Revers:  SmallInt; {Признак реверсирования}
    Zero7:   Word;

    Geo: TGeo;

    _1:    Record End;
  End;

  TRec8=Object(TRecDBS)          {Связка контуров в деталь}
    N: Word;  {Ссылка к записи 26}
    Zero1: Word;
  End;

  TRec26=Object(TRecDBS)         {Запись о детали}
    N: Word;   {Ссылка к записи 8}
    Zero1: Word;
    Id: Array[1..8]Of Char;  {Идентификатор детали}

    Procedure SwapName;
  End;

  TRec27=Object(TRecDBS)        {Площадь и периметр}
    N: Word;   {Ссылка к записям 8 и 26}
    Zero1: Word;

    S, P: Single;
  End;

  TRecStas=Object(TRecDBS)
   DataSize,
   SubKind: Word;
  End;

  TpRec1=Object
    X, Y, Z: Single;
  Private
    Procedure SetComplex(A: TComplex);
    Function GetComplex: TComplex;
  Public
    Property AsComplex: TComplex Read GetComplex Write SetComplex;
  End;

  TpRec8=Record
    N: Word;    {Номер контура, входящего в деталь}
    Zero: Word;
  End;


{TRecDBS}
Procedure TRecDBS.PreWrite;
Var
  R1: TRec1 Absolute Self;
Begin
  RecLen1:=RecLen;
  Mystery1:=R1.Num;
End;

{TRec26}
Procedure TRec26.SwapName;
Var
  i: Byte;
  P: ^Word;
Begin
  For i:=1 To (1+High(Id)-Low(Id))Div 2 Do
   Begin
    P:=@Id[i*2-1];
    P^:=Swap(P^);
   End;
  For I:=Low(Id) To High(Id) Do
    Id[I]:=UpCase(Id[I]);
End;

{TpRec1}
Procedure TpRec1.SetComplex(A: TComplex);
Begin
  X:=A.Re; Y:=A.Im; Z:=0
End;

Function TpRec1.GetComplex: TComplex;
Begin
  Result.Assign(X, Y);
End;

{TSpan}
Procedure TSpan.Free;
Begin
  If A<>Nil Then
   Begin
    If A^.Src<>Nil Then A^.Src^.B:=Nil;
    Dispose(A)
   End;
  If B<>Nil Then
   Begin
    If B^.Dst<>Nil Then B^.Dst^.A:=Nil;
    Dispose(B)
   End;
  Dispose(@Self);
End;

Function TSpan.Center: TComplex;
Var
  P: TComplex;
Begin
  P:=A^; Result:=P;
  Result.Add(B^); Result.Contract(2);
  P.Sub(B^); P.Expand((1/K-K)/4); P.MulI;
  Result.Add(P);
End;

Function TSpan.Radius: Float;
Begin
  Result:=A^.Dist(B^)*(1+Sqr(K))/4/K;
End;

Function TSpan.GetArcK: TComplex;
Begin
  Result.Assign(1-Sqr(K), 2*K);
  Result.Contract(1+Sqr(K));
End;

Procedure TSpan.SetArcK(anArcK: TComplex);
Begin
  K:=anArcK.Im/(anArcK.Abs+anArcK.Re);
End;

Function TSpan.GetAt(Pos: Float): TComplex;
Var
  T, KX: TComplex;
Begin
  Result:=A^;
  Result.Expand(1-Pos);
  T:=B^;
  If Flags And nfArc<>0 Then
   Begin {Дуга; считаем параметрическое представление}
    KX:=ArcK;
    KX.Expand(Pos);
    T.Mul(KX);
    Result.Add(T);
    KX.Re:=KX.Re+1-Pos;
    Result.Divide(KX);
   End
  Else
   Begin {Отрезок}
    T.Expand(Pos);
    Result.Add(T);
   End;
End;

Function TSpan.Bounds: TRectan;
Var
  D, VA, VB: TComplex;
  XY: Byte;
Begin
  Result.Min:=A^;
  Result.Max:=Result.Min;
  Result.Catch(B^);
  If Flags And nfArc=0 Then Exit;
  D:=B^; D.Sub(A^);
  VA:=ArcK; VB:=VA; VB.Im:=-VB.Im;
  VA.Mul(D); VB.Mul(D);
  XY:=0;
  If D.Re>0 Then
   Begin
    If VA.Re<0 Then Inc(XY, $01);
    If VB.Re<0 Then Inc(XY, $02);
   End
  Else
   Begin
    If VA.Re>0 Then Inc(XY, $02);
    If VB.Re>0 Then Inc(XY, $01);
   End;
  If D.Im>0 Then
   Begin
    If VA.Im<0 Then Inc(XY, $10);
    If VB.Im<0 Then Inc(XY, $20);
   End
  Else
   Begin
    If VA.Im>0 Then Inc(XY, $20);
    If VB.Im>0 Then Inc(XY, $10);
   End;
  If XY=0 Then Exit;
  D:=Center;
  VA.Re:=Abs(Radius);
  If XY And $01<>0 Then Result.Min.Re:=D.Re-VA.Re;
  If XY And $02<>0 Then Result.Max.Re:=D.Re+VA.Re;
  If XY And $10<>0 Then Result.Min.Im:=D.Im-VA.Re;
  If XY And $20<>0 Then Result.Max.Im:=D.Im+VA.Re;
End;

Function TSpan.Area:Float;
Begin
  Result:=B^.cXc(A^)/2;
  If Flags And nfArc<>0 Then
    Result:=(ArcTan(K)*Sqr(1+Sqr(K))-(1-Sqr(K))*K)/Sqr(K)/8*Sqr(A^.Dist(B^))
           +Result;
End;

Function TSpan.Perimeter: Float;
Begin
  Result:=A^.Dist(B^);
  If Flags And nfArc<>0 Then
    Result:=(ArcTan(K)/K)*(1+Sqr(K))*Result;
End;

Function TSpan.ViewAngle(Const ViewPoint: TComplex): Float;
{Угол (в радианах), под которым спан виден из точки}
Var
  X, Y: TComplex;
  Res: Float Absolute Y;
Begin
  X:=ViewPoint; X.Sub(B^);
  Y:=ViewPoint; Y.Sub(A^); Y.Conj;
  X.Mul(Y);
  Res:=X.Arg;
  If Flags And nfArc<>0 Then
    If X.Im>0 Then
     Begin
      If X.Im<K*(X.Abs-X.Re) Then
        Res:=Res-2*Pi
     End
    Else If X.Im>K*(X.Abs-X.Re) Then
      Res:=Res+2*Pi;
  Result:=Res;
End;

{TSpanIterator}
Procedure TSpanIterator.Init(aCopy: TCopy);
Begin {}
  FillChar(Self, SizeOf(Self), 0);
  Chain:=aCopy;
  Reverse:=aCopy.Reversed;
  Mirror:=aCopy.Geo.Det<0;
  Span:=aCopy.Nodes;
  If Span<>Nil Then
   If Reverse Then
    Begin
     If Span^.A.Src=Nil Then
     While Span^.B^.Dst<>Nil Do
       Span:=Span^.B^.Dst;
     vB:=Span^.B^;
    End
   Else
     vB:=Span^.A^;
  Chain.Geo.OnTo(vB);
End;

Function TSpanIterator.Advance: Boolean;
Begin
  Result:=Span<>Nil;
  If Not Result Then Exit;
  PSpan(@Self)^:=Span^;
  If(Mirror XOR Reverse)And(Flags And nfArc<>0)Then
    K:=-K;
  vA:=vB;
  If Reverse Then
   Begin
    vB:=A^;
    Span:=vB.Src;
   End
  Else
   Begin
    vB:=B^;
    Span:=vB.Dst;
   End;
  If Chain.Closed And(Chain.Nodes=Span)Then Span:=Nil;
  Chain.Geo.OnTo(vB);
  A:=@vA; B:=@vB; vA.Dst:=@Self; vB.Src:=@Self;
End;

{TOrig}
Destructor TOrig.Destroy;
Var
  P, Q: PSpan;
Begin
  If Nodes<>Nil Then
   Begin
    P:=Nodes;
    If P^.A^.Src<>Nil Then
     Begin
      P^.A^.Dst:=Nil;
      P^.A:=Nil;
     End;
    Repeat
     Q:=P;
     P:=P^.B^.Dst;
     Q.Free;
    Until P=Nil;
   End;
  Inherited;
End;

Procedure TOrig.AddPoint(Const X: TComplex);
Var
  S: PSpan;
  V: PVertex;
Begin
  New(S); S^.Flags:=0;
  New(V); PComplex(V)^:=X;
  S^.A:=V; V^.Dst:=S;
  If Nodes=Nil Then
    Nodes:=S
  Else
   Begin
    V^.Src:=Nodes^.A^.Src;
    V^.Src^.B:=V;
   End;
  S^.B:=Nodes^.A;
  Nodes^.A^.Src:=S;
End;

Procedure TOrig.SetK(aK: Float);
Begin
  With PSpan(Nodes^.A.Src)^ Do
   Begin
    Flags:=nfArc;
    K:=aK;
   End;
End;

Procedure TOrig.LastPoint(Const X: TComplex);
Var
  V: PVertex;
Begin
  New(V); PComplex(V)^:=X;
  V^.Dst:=Nil;
  V^.Src:=Nodes^.A^.Src;
  V^.Src^.B:=V;
  Nodes^.A^.Src:=Nil;
End;

Procedure TOrig.BreakMe;
Var
  S: PSpan;
Begin
  S:=Nodes.A.Src;
  If S=Nil Then Exit;
  S.A.Dst:=Nil; S.B.Src:=Nil;
  S.A:=Nil; S.B:=Nil; S.Free;
End;

{TCopy}
Function TCopy.Valid: Boolean;
Begin
  Result:=(@Self<>Nil)And(Nodes<>Nil);
End;

Function TCopy.Closed: Boolean;
Begin
  Result:=Valid And(Nodes^.A^.Src<>Nil)
End;

Function TCopy.Reversed: Boolean;
Begin
  Case Revers Of
    0,1: Result:=False;
  Else
    Result:=True
  End{Case};
End;

Function TCopy.Count: Integer;
Var
  P: PSpan;
Begin
  Result:=0;
  P:=Nodes;
  While P<>Nil Do
   Begin
    Inc(Result);
    P:=P^.B^.Dst;
    If P=Nodes Then Exit;
   End;
End;

Function TCopy.Area:Float;
Var
  P: PSpan;
Begin
  Result:=0;
  If Not Closed Then Exit;
  P:=Nodes;
  Repeat
    Result:=Result+P^.Area;
    P:=P^.B^.Dst;
  Until P=Nodes;
  Result:=Result*Geo.Det;
  If Reversed Then
    Result:=-Result;
End;

Function TCopy.Perimeter: Float;
Var
  P: PSpan;
Begin
  Result:=0;
  If Not Valid Then Exit;
  P:=Nodes;
  Repeat
    Result:=Result+P^.Perimeter;
    P:=P^.B^.Dst;
  Until(P=Nil)Or(P=Nodes);
  Result:=Result*Sqrt(Abs(Geo.Det));
End;

Function TCopy.Bounds: TRectan;
Var
  N: TSpanIterator;
Begin
  Result.Empty:=True;
  N.Init(Self);
  While N.Advance Do
    Result.Union(N.Bounds);
End;

Function TCopy.ViewAngle(Const ViewPoint: TComplex): Float;
Var
  N: TSpanIterator;
Begin
  Result:=0;
  N.Init(Self);
  While N.Advance Do
    Result:=Result+(N.ViewAngle(ViewPoint));
End;

Function TCopy.Contains(Const Point: TComplex): Boolean;
Begin
  Result:=Closed And(Abs(ViewAngle(Point))>Pi);
End;

Function TCopy.IsInside(Another: TCopy): Boolean;
Begin
  Result:=Valid And Another.Contains(Nodes.A^);
End;

Procedure TCopy.StoreData(S: TStream);
Var
  R1: TpRec1;
  N: PSpan;
Begin
  N:=Nodes;
  Repeat
    R1.AsComplex:=N^.A^;
    R1.Z:=0;
    If N^.Flags And nfArc<>0 Then
      R1.Z:=-N^.K;
    S.WriteBuffer(R1, SizeOf(R1));
    If(N^.B^.Dst=Nil)Or(N^.B^.Dst=Nodes)Then
     Begin
      R1.AsComplex:=N^.B^;
      Break
     End;
    N:=N^.B^.Dst;
  Until False;
  S.WriteBuffer(R1, SizeOf(R1));
End;

Procedure TCopy.Store(S: TStream);
Var
  R: TRec1;
Begin
  If Not Valid Then Exit;
  FillChar(R, SizeOf(R), 0);
  R.RecLen:=(SizeOf(R)-4)Div 4;
  R.Kind:=2;
  If No=Original Then
   Begin
    Inc(R.RecLen, (Count+1)*(SizeOf(TpRec1)Div 4));
    R.Kind:=1;
   End;
  R.Num:=No;
  R.SubType:=1;
  R.Orig:=Original;
  R.Group:=Group;
  R.Revers:=Revers;
  R.Geo:=Geo;
  R.PreWrite;
  S.WriteBuffer(R, SizeOf(R));
  If R.Kind=1 Then
    StoreData(S);
End;

{TPart}
Constructor TPart.Create(Collection: TCollection);
Begin
  Inherited;
  Circuits:=TList.Create;
End;

Destructor TPart.Destroy;
Begin
  Circuits.Free;
  Inherited
End;

Procedure TPart.SetString(S: String);
Var
  i: Integer;
Begin
  FillChar(Name, SizeOf(Name), ' ');
  i:=Length(S);
  If i>SizeOf(Name) Then i:=SizeOf(Name);
  Move(S[1], Name, i);
End;

Function TPart.GetString: String;
Begin
  SetLength(Result, SizeOf(Name));
  Move(Name, Result, SizeOf(Name));
  Result:=Trim(Result);
End;

Function TPart.GetCircuit(No: Integer): TCopy;
Begin
  Result:=Circuits[No]
End;

Function TPart.Count: Integer;
Begin
  Result:=Circuits.Count
End;

Procedure TPart.Store(S: TStream);
Var
  R26: TRec26;
  R8:  TRec8 Absolute R26;
  R27: TRec27 Absolute R26;
  i: Integer;
Begin
  FillChar(R26, SizeOf(R26), 0);
  R26.RecLen:=(SizeOf(R26)-4)Div 4;
  R26.Kind:=26;
  R26.N:=No;
  Move(Name, R26.ID, SizeOf(R26.ID));
  R26.SwapName;
  R26.Prewrite;
  S.Write(R26, SizeOf(R26));
  R27.RecLen:=(SizeOf(R27)-4)Div 4;
  R27.Kind:=27;
  R27.S:=Area*1E-4;
  R27.P:=Perimeter*1E-2;
  R27.Prewrite;
  S.Write(R27, SizeOf(R27));
  R8.RecLen:=(SizeOf(R8)-4)Div 4+Count;
  R8.Kind:=8;
  R8.Prewrite;
  S.Write(R8, SizeOf(R8));
  For i:=0 To Count-1 Do
    S.WriteBuffer(Self[i].No, 4);
End;

Procedure TPart.SetGroupNo;
Var
  i: Integer;
Begin
  For i:=Count-1 DownTo 1 Do
    Self[i].Group:=No;
  Self[0].Group:=-No;
End;

Function TPart.Area:Float;
Var
  i: Integer;
Begin
  Result:=0;
  For i:=Count-1 DownTo 0 Do
    Result:=Result+Self[i].Area
End;

Function TPart.Perimeter: Float;
Var
  i: Integer;
Begin
  Result:=0;
  For i:=Count-1 DownTo 0 Do
    Result:=Result+Self[i].Perimeter
End;

{TSpanContainer}
Procedure TSpanContainer.Init(Orig: TOrig);
Begin
  Span:=TCopy.Create(Nil);
  Span.Geo.Init;
  If Orig<>Nil Then
   Begin
    Span.Nodes:=Orig.Nodes;
    AbsS:=Abs(Span.Area);
   End;
  Children:=TList.Create;
End;

Procedure TSpanContainer.Free;
Var
  i: Integer;
Begin
  If @Self=Nil Then Exit;
  Span.Free;
  For i:=Children.Count-1 DownTo 0 Do
    PSpanContainer(Children[i]).Free;
  Children.Free;
  Dispose(@Self);
End;

Procedure TSpanContainer.InsertChild(P: PSpanContainer);
Var
  i: Integer;
Begin
  i:=0;
  While(i<Children.Count)And(P.AbsS<=PSpanContainer(Children[i]).AbsS)Do
    Inc(i);
  Children.Insert(i, P);
End;

Procedure TSpanContainer.Insert(P: PSpanContainer);
Var
  i: Integer;
  This, X: PSpanContainer;
Begin
  This:=@Self;
  i:=Children.Count;
  While i>0 Do
   Begin
    Dec(i);
    X:=This.Children[i];
    If X.Span.IsInside(P.Span) Then
     Begin
      This.Children.Delete(i);
      P.InsertChild(X);
     End
    Else If P.Span.IsInside(X.Span) Then
     Begin
      This:=X;
      i:=This.Children.Count;
     End;
   End;
  This.InsertChild(P);
End;

Procedure TSpanContainer.FillFrom(Var D: TDbs);
Var
  i: Integer;
  P: PSpanContainer;
Begin
  For i:=D.Origs.Count-1 DownTo 0 Do
   Begin
    New(P);
    P.Init(TOrig(D.Origs.Items[i]));
    Insert(P);
   End;
End;

Procedure TSpanContainer.PutInto(Var D: TDbs);
 Procedure Put(X: PSpanContainer; P: TPart; Level: Integer);
 Var
   i: Integer;
 Begin
   If Length(X.PartName)>0 Then
    Begin // Создаём новую деталь
     P:=TPart.Create(D.Parts);
     P.AsString:=UpperCase(X.PartName);
     Level:=0;
    End;
   If X.Span.Valid Then
    Begin // Укладываем контур
     If P<>Nil Then
       P.Circuits.Add(X.Span);
     If Odd(Level)<>(X.Span.Area<0) Then
       X.Span.Revers:=2;
     Inc(Level);
     X.Span.Collection:=D.Copies;
     X.Span:=Nil; // Всё, мы им не владеем, он - в коллекции
    End;
   // Укладываем детей :)
   For i:=X.Children.Count-1 DownTo 0 Do
     Put(X.Children[i], P, Level);
 End;
Begin
  Put(@Self, Nil, 0);
End;

{TDBS}
Procedure TDBS.Init;
Begin
  Inherited;
  FillChar(Self, SizeOf(Self), 0);
  Origs:=TCollection.Create(TOrig);
  Copies:=TCollection.Create(TCopy);
  Parts:=TCollection.Create(TPart);
//  Description:='';
End;

Procedure TDBS.Clear;
Begin
  Parts.Clear;
  Copies.Clear;
  Origs.Clear;
  Description:='';
End;

Procedure TDBS.Done;
Begin
  Clear;
  Parts.Free;
  Copies.Free;
  Origs.Free;
End;

Function TDBS.LoadRecord(S: TStream): Boolean;
Var
  R1: TRec1;
  R0: TRec0 Absolute R1;
  R: TRecDBS Absolute R1;
 Procedure Load1;
 Var
   i, N: Integer;
   O: TOrig;
   XYZ, XYZ0: TpRec1;
 Begin
   O:=TOrig.Create(Origs);
   O.No:=R1.Orig;
   N:=(R1.RecLen*4-(SizeOf(R1)-8))Div SizeOf(XYZ)-1; {Кол-во спанов}
   If N>=0 Then
     For i:=N DownTo 0 Do
      Begin
       S.ReadBuffer(XYZ, SizeOf(XYZ));
       If i=N Then XYZ0:=XYZ;
       If i>0 Then
        Begin
         O.AddPoint(XYZ.AsComplex);
         If Abs(XYZ.Z)>1E-4 Then
           O.SetK(-XYZ.Z);
        End
       Else If(XYZ.X<>XYZ0.X)Or(XYZ.Y<>XYZ0.Y) Then
         O.LastPoint(XYZ.AsComplex)
       Else
      End;
   For i:=Copies.Count-1 DownTo 0 Do
     With TCopy(Copies.Items[i])Do
       If(Nodes=Nil)And(Original=O.No) Then
         Nodes:=O.Nodes;
 End;
 Procedure Load2;
 Var
   C: TCopy;
   i: Integer;
 Begin
   S.ReadBuffer(R._Rec, SizeOf(R1)-SizeOf(R));
   If R1.SubType<>1 Then
    Begin
     S.Seek(R1.RecLen*4-(SizeOf(R1)-4), soFromCurrent);
     Exit;
    End;
   C:=TCopy.Create(Copies);
   C.No:=R1.Num;
   C.Original:=R1.Orig;
   C.Group:=R1.Group;
   C.Revers:=R1.Revers;
   C.Geo:=R1.Geo;
   If R1.Kind=1 Then
     Load1
   Else For i:=Origs.Count-1 DownTo 0 Do
     With TOrig(Origs.Items[i]) Do
     If No=C.Original Then
      Begin
       C.Nodes:=Nodes;
       Break;
      End;
 End;
 Procedure Load8;
 Var
   R: TRec8 Absolute R0;
   X: TpRec8;
   P: TPart;
   i: Integer;
 Begin
   S.ReadBuffer(R._Rec, SizeOf(R)-SizeOf(TRecDbs));
   P:=GetPart(R.N);
   For i:=(R.RecLen*4-(SizeOf(R)-4))Div SizeOf(TpRec8) DownTo 1 Do
    Begin
     S.ReadBuffer(X, SizeOf(X));
     P.Circuits.Add(Pointer(X.N));
    End;
 End;
 Procedure Load26;
 Var
   R: TRec26 Absolute R0;
   P: TPart;
 Begin
   S.ReadBuffer(R._Rec, SizeOf(R)-SizeOf(TRecDbs));
   R.SwapName;
   P:=GetPart(R.N);
   Move(R.Id, P.Name, SizeOf(P.Name));
 End;
 Procedure Load28;
 Begin
   SetLength(Description ,R.RecLen*4-SizeOf(R)+4);
   S.Read(Description[1], Length(Description));
   Description:=Trim(Description);
 End;
Begin
  S.ReadBuffer(R0, SizeOf(R0));
  Result:=R0.RecLen<>Word(-1);
  If Not Result Then Exit;
  S.ReadBuffer(R._0, SizeOf(R)-SizeOf(R0));
  Case R.Kind Of
   1,2:Load2;
   8:Load8;
   26:Load26;
   28:Load28;
  Else
    S.Seek(R.RecLen*4-(SizeOf(R)-4), soFromCurrent);
  End{Case}
End;

Procedure TDBS.Load(S: TStream);
Var
  i, j, k, n: Integer;
  P: TPart;
Begin
  While LoadRecord(S) Do;

  For i:=Parts.Count-1 DownTo 0 Do
   Begin
    P:=TPart(Parts.Items[i]);
    For j:=P.Count-1 DownTo 0 Do
     Begin
      n:=Integer(P[j]);
      P.Circuits[j]:=Nil;
      For k:=Copies.Count-1 DownTo 0 Do
        If TCopy(Copies.Items[k]).No=n Then
         Begin
          P.Circuits[j]:=Copies.Items[k];
          Break;
         End;
     End;
    P.Circuits.Pack;
   End;
End;

Function TDBS.Area:Float;
Var
  i: Integer;
Begin
  Result:=0;
  For i:=Copies.Count-1 DownTo 0 Do
    Result:=Result+TCopy(Copies.Items[i]).Area
End;

Function TDBS.Perimeter: Float;
Var
  i: Integer;
Begin
  Result:=0;
  For i:=Copies.Count-1 DownTo 0 Do
    Result:=Result+TCopy(Copies.Items[i]).Perimeter
End;

Function TDBS.Bounds: TRectan;
Var
  i: Integer;
Begin
  Result.Empty:=True;
  For i:=Copies.Count-1 DownTo 0 Do
    Result.Union(TCopy(Copies.Items[i]).Bounds);
End;

Procedure TDBS.Complete;
Var
  i: Integer;
  P: TPart;
  C: TCopy;
Begin
  P:=TPart.Create(Parts);
  For i:=0 To Origs.Count-1 Do
   Begin
    C:=TCopy.Create(Copies);
    P.Circuits.Add(C);
    C.Nodes:=TOrig(Origs.Items[i]).Nodes;
    C.Geo.Init;
    C.Revers:=Byte(i>0);
   End;
End;

Function TDBS.CopyRenumerate(From: Integer): Integer;
Var
  i: Integer;
Begin
  For i:=0 To Copies.Count-1 Do
   Begin
    Inc(From);
    TCopy(Copies.Items[i]).No:=From;
   End;
  For i:=0 To Parts.Count-1 Do
   Begin
    Inc(From);
    TPart(Parts.Items[i]).No:=From;
   End;
  Result:=From;
End;

Function TDBS.Renumerate(From: Integer): Integer;
Var
  i, j: Integer;
  L :TList;
Begin
  L:=TList.Create;
  For i:=0 To Copies.Count-1 Do
    L.Add(Copies.Items[i]);
  While L.Count>0 Do
   Begin
    Inc(From);
    TCopy(L.First).Original:=From;
    TCopy(L.First).No:=From;
    j:=1;
    While j<L.Count Do
      If TCopy(L[j]).Nodes=TCopy(L.First).Nodes Then
       Begin
        Inc(From);
        TCopy(L[j]).No:=From;
        TCopy(L[j]).Original:=TCopy(L.First).Original;
        L.Delete(j);
       End
      Else
        Inc(j);
    L.Delete(0);
   End;
  L.Free; 
  For i:=0 To Parts.Count-1 Do
   Begin
    Inc(From);
    TPart(Parts.Items[i]).No:=From;
   End;
  Result:=From;
End;

Function TDBS.GetPart(No: Integer): TPart;
Var
  i: Integer;
Begin
  For i:=Parts.Count-1 DownTo 0 Do
    If TPart(Parts.Items[i]).No=No Then
     Begin
      Result:=TPart(Parts.Items[i]);
      Exit
     End;
  Result:=TPart.Create(Parts);
  Result.No:=No
End;

Procedure TDBS.SaveDescription(S: TStream);
Var
  X: String;
  R: TRecDbs;
Begin
  If Length(Description)<=0 Then Exit;
  FillChar(R, SizeOf(R), 0);
  X:=Description;
  While Length(X) Mod 4<>0 Do
    X:=X+' ';
  R.RecLen:=(SizeOf(R)+Length(X))Div 4-1;
  R.Kind:=28;
  R.PreWrite;
  S.Write(R, SizeOf(R));
  S.Write(X[1], Length(X));
End;

Procedure TDBS._Save(S: TStream);
Var
  i: Integer;
Begin
  SaveDescription(S);
  For i:=Parts.Count-1 DownTo 0 Do
    TPart(Parts.Items[i]).SetGroupNo;
  For i:=0 To Copies.Count-1 Do
    TCopy(Copies.Items[i]).Store(S);
  For i:=0 To Parts.Count-1 Do
    TPart(Parts.Items[i]).Store(S);
End;

Procedure TDBS.End_Save(S: TStream);
Const
  EOF: Integer=-1;
Begin
  S.WriteBuffer(EOF, SizeOf(EOF)); 
End;

Procedure TDBS.Save(S: TStream);
Begin
  _Save(S);
  End_Save(S);
End;

Procedure TDBS.Shift(Const Disp: TComplex);
Var
  i: Integer;
Begin
  For i:=Copies.Count-1 DownTo 0 Do
    TCopy(Copies.Items[i]).Geo.Add(Disp);
End;

Procedure TDBS.Reorganize(PartName: String);
Var
  P: PSpanContainer;
Begin
  New(P);
  P.Init(Nil); P.PartName:=PartName;
  P.FillFrom(Self);
  P.PutInto(Self);
  P.Free;
  Renumerate(0);
End;

{TEasterEgg}
Function TEasterEgg.Available: Boolean;
Var
  R: TRecStas;
  Start: Integer;
Begin
  Result:=False;
  Start:=Stream.Position;
  Try
  Stream.Read(R, SizeOf(R.RecLen));
  If R.RecLen=$FFFF Then Exit;
  Stream.Read(R._0, SizeOf(TRecDBS)-SizeOf(R.RecLen));
  If R.Kind<>$1971 Then Exit;
  Stream.Read(R._Rec, SizeOf(R)-SizeOf(TRecDBS));
  If(R.DataSize<>0)Or(R.SubKind<>Ord('?'))Then Exit;
  Result:=True;
  Finally
   Stream.Position:=Start;
  End;
End;

End.

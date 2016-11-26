{$A-,B-,D+,E+,F-,G-,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+}
Unit SirMath;

Interface uses
  Windows;

Const
  vpSwapXY=$01;
  vpMirrorX=$02;
  vpMirrorY=$04;
  vpLeft=$10;
  vpRight=$20;
  vpTop=$40;
  vpBottom=$80;
//Комбинированные константы
  vpCCW=vpSwapXY+vpMirrorX;     //90 градусов против часовой стрелки
  vpCW=vpSwapXY+vpMirrorY;      //90 градусов по часовой стрелке
  vpRotate=vpMirrorX+vpMirrorY; //180 градусов
Type
  Float=Extended;

  PComplex=^TComplex;
  TComplex=Object
    Re,Im : Float;

    Procedure SetTo(Const R:Float);
    Procedure Assign(Const R,I:Float);
    Procedure Polar(Const Ro,Fi:Float);
    Function Equal(Const X: TComplex):Boolean;
    Function Dist(Const X: TComplex): Float;

    Procedure Conj;   {Y->-Y}
    Procedure Negate; {X->-X, Y->-Y}
    Procedure MulI;
    Procedure DivI;

    Procedure Add(Const C:TComplex);
    Procedure Sub(Const C:TComplex);
    Procedure Mul(Const C:TComplex);
    Procedure Divide(Const C:TComplex);

    Function cXc(Const C: TComplex): Float;
    Function cVc(Const C: TComplex): Float;

    Procedure Expand(Const By:Float);
    Procedure Contract(Const By:Float);
    Procedure Invert;

    Function  SqrAbs:Float;
    Function  Abs:Float;
    Function  Arg:Float;

    Procedure Sqrt;
    Procedure Power(Const Pow: TComplex);
    Procedure RootN(N:Word);
    Procedure RootN_1(N:Word);

    Procedure Exp;
    Procedure ExpI;
    Procedure ExpIX(Const X:Float);
    Procedure Ln;

    Procedure Sin;    Procedure Cos;    Procedure TG;
    Procedure ArcSin; Procedure ArcCos; Procedure ArcTG;
    Procedure Sh;     Procedure Ch;     Procedure Th;
    Procedure ArSh;   Procedure ArCh;   Procedure ArTh;

    Class Function Temp(R, I: Float): TComplex;
  End;

  PRectan=^TRectan;
  TRectan=Object
  Private
    Function GetEmpty: Boolean;
    Procedure SetEmpty(Value: Boolean);
    Procedure SetOrigin(Const Org: TComplex);
    Procedure SetSize(Const Sz: TComplex);
    Function GetSize: TComplex;
  Public
    Min, Max: TComplex;

    Property Empty: Boolean Read GetEmpty Write SetEmpty;
    Property Origin: TComplex Read Min Write SetOrigin;
    Property Size: TComplex Read GetSize Write SetSize;

    Class Function Temp(Const aMin, aMax: TComplex): TRectan;
    Procedure Assign(Const aMin, aMax: TComplex);
    Procedure Catch(Const C: TComplex);
    Procedure Union(Const R: TRectan);
    Procedure Intersect(Const R: TRectan);
    Procedure Expand(Factor: Float);
    Procedure Shift(Const Delta: TComplex);
    Procedure MulI;

    Function OnPoint(Const P: TComplex): Boolean;
    Function OnRect(Const R: TRectan): Boolean;
    Function OnCircle(Const C: TComplex; R: Float): Boolean;
    Function HitsRect(Const R: TRectan): Boolean;
    Function HitsCircle(Const C: TComplex; R: Float): Boolean;
  End;

  TPointObj=Object
    X, Y: Integer;

    Class Function Temp(aX, aY: Integer): TPointObj;
    Procedure Assign(aX, aY: Integer);
    Procedure Add(A: TPointObj);
    Procedure Sub(A: TPointObj);
  End;

  TPoint=Record
  Case Integer Of
   0:(O: TPointObj);
   1:(W: Windows.TPoint);
   2:(X, Y: Integer);
   3:(AsVector: Array[0..1]Of Integer);
  End;

  TRectObj=Object
  Private
    Function GetEmpty: Boolean;
    Procedure SetEmpty(Value: Boolean);
  Public
    A, B: TPoint;

    Property Empty: Boolean Read GetEmpty Write SetEmpty;

    Class Function Temp(Left, Top, Right, Bottom: Integer): TRectObj;
    Procedure Assign(Left, Top, Right, Bottom: Integer);
    Procedure Move(X, Y: Integer);
    Procedure Grow(X, Y: Integer);
    Procedure Union(Const R: TRectObj);
    Procedure Intersect(Const R: TRectObj);
    Procedure Catch(Const P: TPoint);
    Function Contains(Const P: TPoint): Boolean;
  End;

  TRect=Record
  Case Integer Of
   0:(O: TRectObj);
   1:(W: Windows.TRect);
   2:(A, B: TPoint);
   3:(Left, Top, Right, Bottom: Integer);
  End;

  TGeo=Object
    Cos1, Sin1, Cos2, Sin2, X0, Y0: Single;

    Procedure Init;
    Function Reversed: TGeo;
    Procedure OnTo(Var X: TComplex);
    Procedure GotFrom(Var X: TComplex);
    Procedure Expand(Factor: Float);
    Function Det: Float;
    Function Aspect: Float;  {-1<=Aspect<=1}

    Procedure Add(Const Disp: TComplex);
    Procedure MulI;
  End;

  TViewPort=Object
  Private
    Factor, Delta: TComplex;
  Public
    Flags: Integer;  { vpXXX }
    Procedure Init(Const winI: TRect; Const winR: TRectan);

    Function F2I(Const X: TComplex): TPoint;
    Function I2F(Const X: TPoint): TComplex;
    Function F2IRect(Const X: TRectan): TRect;
    Function I2FRect(Const X: TRect): TRectan;

    Procedure Collate(Const winI: TRect; Const winR: TRectan; Mode: Integer);
    Procedure Move(Const Step: TPoint);
  End;

  TArcher=Object(TPointObj)
    Procedure InitLine(Const A, B: TComplex;
                       Const aViewPort: TViewPort);
    Procedure Init(Const A, B: TComplex; Tan4: Float;
                   Const aViewPort: TViewPort);
    Procedure Init3(Const A, Thru, B: TComplex;
                    Const aViewPort: TViewPort);
    Procedure First;
    Procedure Next;
    Function Done: Boolean;
  Private
    ViewPort: ^TViewPort;
    i, N: Integer;
    Mid, Dif: TComplex;
    T2, T4: Float;
  End;

Const
  cx_0:TComplex=(Re:0; Im:0);
Const
  cx_1:TComplex=(Re:1; Im:0);
Const
  cx_i:TComplex=(Re:0; Im:1);

Implementation

{TComplex}
Class Function TComplex.Temp(R, I: Float): TComplex;
Begin
  Result.Assign(R, I);
End;

Procedure TComplex.SetTo(Const R:Float);
Begin
  Re:=R;
  Im:=0;
End;

Procedure TComplex.Assign(Const R,I:Float);
Begin
  Re:=R;
  Im:=I;
End;

Procedure TComplex.Polar(Const Ro,Fi:Float);
Begin
  ExpIX(Fi);
  Expand(Ro);
End;

Function TComplex.Equal(Const X: TComplex):Boolean;
Begin
  Result:=(Re=X.Re)And(Im=X.Im)
End;

Procedure TComplex.Conj;
Begin
  Im:=-Im;
End;

Procedure TComplex.Negate;
Begin
  Re:=-Re;
  Im:=-Im;
End;

Procedure TComplex.MulI;
Var
  R:Float;
Begin
  R:=Re; Re:=-Im; Im:=R;
End;

Procedure TComplex.DivI;
Var
  R:Float;
Begin
  R:=-Re; Re:=Im; Im:=R;
End;

Procedure TComplex.Expand(Const By:Float);
Begin
  Re:=Re*By; Im:=Im*By;
End;

Procedure TComplex.Contract(Const By:Float);
Begin
  Re:=Re/By; Im:=Im/By;
End;

Procedure TComplex.Add(Const C:TComplex);
Begin
  Re:=Re+C.Re;
  Im:=Im+C.Im;
End;

Procedure TComplex.Sub(Const C:TComplex);
Begin
  Re:=Re-C.Re;
  Im:=Im-C.Im;
End;

Procedure TComplex.Mul(Const C:TComplex);
Begin
  Assign(Re*C.Re-Im*C.Im, Re*C.Im+Im*C.Re);
End;

Procedure TComplex.Divide(Const C:TComplex);
Var
  X:TComplex;
Begin
  X:=C;
  X.Invert;
  Mul(X);
End;

Function TComplex.cXc(Const C: TComplex): Float;
Begin { "Векторное" произведение }
  cXc:=Re*C.Im-C.Re*Im;
End;

Function TComplex.cVc(Const C: TComplex): Float;
Begin { "Скалярное" произведение }
  cVc:=Re*C.Re+Im*C.Im
End;

Procedure TComplex.Invert;
Begin
  Conj;
  Contract(SqrAbs)
End;

Function TComplex.SqrAbs:Float;
Begin
  SqrAbs:=Sqr(Re)+Sqr(Im)
End;

Function TComplex.Abs:Float;
Begin
  Abs:=System.Sqrt(Sqr(Re)+Sqr(Im))
End;

Function TComplex.Dist(Const X: TComplex): Float;
Begin
  Dist:=System.Sqrt(Sqr(Re-X.Re)+Sqr(Im-X.Im));
End;

Function TComplex.Arg:Float;
Var
  R:Float;
Begin
  If System.Abs(Re)>System.Abs(Im) Then
   Begin
    R:= ArcTan(Im/Re);
    If Re<0 Then
      If Im>0 Then
        Arg:= R+Pi
      Else
        Arg:= R-Pi
    Else
      Arg:=R
   End
  Else If System.Abs(Im)=0 Then
    Arg:=0
  Else
   Begin
    R:= - ArcTan(Re/Im);
    If Im>0 Then
      Arg:= R+Pi/2
    Else
      Arg:= R-Pi/2
   End;
End;

Procedure TComplex.Sqrt;
Var
  X:TComplex;
Begin
  Contract(2);
  X.Re:=Abs;
  X.Assign(System.Sqrt(X.Re+Re), System.Sqrt(X.Re-Re));
  If Im<0 Then
    X.Conj;
  Self:=X;
End;

Procedure TComplex.Power(Const Pow:TComplex);
Begin
  Ln;
  Mul(Pow);
  Exp;
End;

Procedure TComplex.RootN(N:Word);
Begin
  Ln;
  Contract(N);
  Exp;
End;

Procedure TComplex.RootN_1(N:Word);
Begin
  ExpIX(2*Pi/N);
End;

Procedure TComplex.ExpIX(Const X:Float);
Begin
  Assign(System.Cos(X), System.Sin(X))
End;

Procedure TComplex.Exp;
Var
  E:Float;
Begin
  E:=System.Exp(Re);
  Re:=E*System.Cos(Im);
  Im:=E*System.Sin(Im);
End;

Procedure TComplex.ExpI;
Begin
  MulI;
  Exp;
End;

Procedure TComplex.Ln;
Begin
  Assign(System.Ln(SqrAbs)/2,Arg)
End;

Procedure TComplex.Sin;
Begin
  Re:=Re-Pi/2;
  Cos
End;

Procedure TComplex.Cos;
Begin
  MulI;
  Ch;
End;

Procedure TComplex.Tg;
Begin
  Expand(2);
  ExpI;
  Re:=Re+1;
  Invert;
  Expand(2);
  Re:=Re-1;
  MulI;
End;

Procedure TComplex.ArcSin;
Begin
  ArcCos;
  Negate;
  Re:=Re+Pi/2
End;

Procedure TComplex.ArcCos;
Begin
  ArCh;
  DivI;
End;

Procedure TComplex.ArcTg;
Begin
  DivI;
  Re:=Re+1;
  Invert;
  Expand(2);
  Re:=Re-1;
  Ln;
  DivI;
  Contract(2);
End;

Procedure TComplex.Sh;
Var
  X:TComplex;
Begin
  Exp;
  X:=Self;
  X.Invert;
  Sub(X);
  Contract(2);
End;

Procedure TComplex.Ch;
Var
  X:TComplex;
Begin
  Exp;
  X:=Self;
  X.Invert;
  Add(X);
  Contract(2);
End;

Procedure TComplex.Th;
Begin
  Expand(2);
  Exp;
  Re:=Re+1;
  Invert;
  Expand(2);
  Re:=Re-1;
  Negate;
End;

Procedure TComplex.ArSh;
Var
  X:TComplex;
Begin { LN(X+Sqrt(X^2+1) }
  X:=Self;
  X.Mul(X);
  X.Re:=X.Re+1;
  X.Sqrt;
  Add(X);  (*** Hint: sh(pi i -x)=sh(x) ***)
  Ln
End;

Procedure TComplex.ArCh;
Var
  X:TComplex;
Begin { LN(X+Sqrt(X^2-1) }
  X:=Self;
  X.Mul(X);
  X.Re:=X.Re-1;
  X.Sqrt;
  Add(X);  (*** Hint: ch(X)=ch(-X) ***)
  Ln
End;

Procedure TComplex.ArTh;
Begin {0.5 Ln((1+X)/(1-X))}
  Negate;
  Re:=Re+1;
  Invert;
  Expand(2);
  Re:=Re-1;
  Ln;
  Contract(2);
End;

{TRectan}
Class Function TRectan.Temp(Const aMin, aMax: TComplex): TRectan;
Begin
  Result.Assign(aMin, aMax);
End;

Procedure TRectan.Assign(Const aMin, aMax: TComplex);
Begin
  Min:=aMin; Max:=aMax;
End;

Procedure TRectan.SetOrigin(Const Org: TComplex);
Begin
  Max.Add(Org); Max.Sub(Min);
  Min:=Org;
End;

Procedure TRectan.SetSize(Const Sz: TComplex);
Begin
  Min.Add(Max); Min.Sub(Sz);
  Min.Contract(2);
  Max:=Sz; Max.Add(Min);
End;

Function TRectan.GetSize: TComplex;
Begin
  Result:=Max; Result.Sub(Min);
End;

Procedure TRectan.Shift(Const Delta: TComplex);
Begin
  Min.Add(Delta);
  Max.Add(Delta);
End;

Function TRectan.GetEmpty: Boolean;
Begin
  Result:=(Min.Re>Max.Re)Or(Min.Im>Max.Im)
End;

Procedure TRectan.SetEmpty(Value: Boolean);
Var
  i: Float;
Begin
  If Not Value Then
   Begin
    If Min.Re>Max.Re Then
     Begin
      i:=Min.Re; Min.Re:=Max.Re; Max.Re:=i;
     End;
    If Min.Im>Max.Im Then
     Begin
      i:=Min.Im; Min.Im:=Max.Im; Max.Im:=i;
     End;
   End
  Else
   Begin
    Min.Assign(1,1);
    Max:=cx_0;
   End;
End;

Procedure TRectan.Catch(Const C: TComplex);
Begin
  If Empty Then
   Begin
    Min:=C;
    Max:=C
   End
  Else
   Begin
    If Min.Re>C.Re Then
      Min.Re:=C.Re;
    If Min.Im>C.Im Then
      Min.Im:=C.Im;
    If Max.Re<C.Re Then
      Max.Re:=C.Re;
    If Max.Im<C.Im Then
      Max.Im:=C.Im;
   End
End;

Procedure TRectan.Union(Const R: TRectan);
Begin
  If R.Empty Then
    Exit;
  If Empty Then
    Self:=R
  Else
   Begin
    If Min.Re>R.Min.Re Then Min.Re:=R.Min.Re;
    If Min.Im>R.Min.Im Then Min.Im:=R.Min.Im;
    If Max.Re<R.Max.Re Then Max.Re:=R.Max.Re;
    If Max.Im<R.Max.Im Then Max.Im:=R.Max.Im;
   End;
End;

Procedure TRectan.Intersect(Const R: TRectan);
Begin
  If Min.Re<R.Min.Re Then
    Min.Re:=R.Min.Re;
  If Min.Im<R.Min.Im Then
    Min.Im:=R.Min.Im;
  If Max.Re>R.Max.Re Then
    Max.Re:=R.Max.Re;
  If Max.Im>R.Max.Im Then
    Max.Im:=R.Max.Im;
End;

Procedure TRectan.Expand(Factor: Float);
Var
  S: TComplex;
Begin
  S:=Size;
  S.Expand(Factor);
  Size:=S;
End;

Function TRectan.OnPoint(Const P: TComplex): Boolean;
Begin
  OnPoint:=(P.Re<=Max.Re)And(P.Re>=Min.Re)
        And(P.Im<=Max.Im)And(P.Im>=Min.Im);
End;

Function TRectan.OnCircle(Const C: TComplex; R: Float): Boolean;
Begin
  OnCircle:=(C.Re+R<=Max.Re)And(C.Re-R>=Min.Re)
         And(C.Im+R<=Max.Im)And(C.Im-R>=Min.Im);
End;

Function TRectan.OnRect(Const R: TRectan): Boolean;
Begin
  OnRect:= R.Empty Or
    (Max.Re>=R.Max.Re)And(Max.Im>=R.Max.Im)And
    (Min.Re<=R.Min.Re)And(Min.Im<=R.Min.Im)
End;

Function TRectan.HitsRect(Const R: TRectan): Boolean;
Begin
  HitsRect:=False;
  If Empty Or R.Empty Then
    Exit;
  If(Min.Re<R.Max.Re)And(Min.Im<R.Max.Im)And
    (R.Min.Re<Max.Re)And(R.Min.Im<Max.Im)Then
    HitsRect:=True;
End;

Function TRectan.HitsCircle(Const C: TComplex; R: Float): Boolean;
Var
  D: TComplex;
Begin
  HitsCircle:=True;
  If OnPoint(C)Then
    Exit;
  D:=Min; D.Add(Max); D.Contract(2); D.Sub(C);
  D.Re:=Abs(D.Re)-(Max.Re-Min.Re)/2;
  D.Im:=Abs(D.Im)-(Max.Im-Min.Im)/2;
  If D.Re<0 Then
    HitsCircle:=D.Im<=R
  Else If D.Im<0 Then
    HitsCircle:=D.Re<=R
  Else
    HitsCircle:=D.SqrAbs<=Sqr(R)
End;

Procedure TRectan.MulI;
Var
  X: TComplex;
Begin
  X:=Max;
  X.MulI;
  Min.MulI; Max:=Min; Catch(X);
End;

{TPointObj}
Class Function TPointObj.Temp(aX, aY: Integer): TPointObj;
Begin
  Result.Assign(aX, aY);
End;

Procedure TPointObj.Assign(aX, aY: Integer);
Begin
  X:=aX; Y:=aY;
End;

Procedure TPointObj.Add(A: TPointObj);
Begin
  Inc(X, A.X);
  Inc(Y, A.Y);
End;

Procedure TPointObj.Sub(A: TPointObj);
Begin
  Dec(X, A.X);
  Dec(Y, A.Y);
End;

{TRectObj}
Class Function TRectObj.Temp(Left, Top, Right, Bottom: Integer): TRectObj;
Begin
  Result.Assign(Left, Top, Right, Bottom);
End;

Procedure TRectObj.Assign(Left, Top, Right, Bottom: Integer);
Begin
  A.X:=Left; A.Y:=Top; B.X:=Right; B.Y:=Bottom;
End;

Function TRectObj.GetEmpty: Boolean;
Begin
  GetEmpty:=(B.X<=A.X)Or(B.Y<=A.Y)
End;

Procedure TRectObj.SetEmpty(Value: Boolean);
Var
  i: Integer;
Begin
  If Value Then
   Begin
    If A.X>B.X Then
     Begin
      i:=A.X; A.X:=B.X; B.X:=i
     End;
    If A.Y>B.Y Then
     Begin
      i:=A.Y; A.Y:=B.Y; B.Y:=i
     End;
   End
  Else
    Assign(1, 1, 0, 0);
End;

Procedure TRectObj.Move(X, Y: Integer);
Begin
  Inc(A.X, X); Inc(A.Y, Y);
  Inc(B.X, X); Inc(B.Y, Y);
End;

Procedure TRectObj.Grow(X, Y: Integer);
Begin
  Dec(A.X, X); Dec(A.Y, Y);
  Inc(B.X, X); Inc(B.Y, Y);
End;

Procedure TRectObj.Union(Const R: TRectObj);
Begin
  If Empty Then
    Self:=R
  Else If Not R.Empty Then
   Begin
    If A.X>R.A.X Then A.X:=R.A.X;
    If A.Y>R.A.Y Then A.Y:=R.A.Y;
    If B.X<R.B.X Then B.X:=R.B.X;
    If B.Y<R.B.Y Then B.Y:=R.B.Y;
   End
End;

Procedure TRectObj.Intersect(Const R: TRectObj);
Begin
  If A.X<R.A.X Then A.X:=R.A.X;
  If A.Y<R.A.Y Then A.Y:=R.A.Y;
  If B.X>R.B.X Then B.X:=R.B.X;
  If B.Y>R.B.Y Then B.Y:=R.B.Y;
End;

Function TRectObj.Contains(Const P: TPoint): Boolean;
Begin
  Contains:=(P.X>=A.X)And(P.X<B.X)And(P.Y>=A.Y)And(P.Y<B.Y)
End;

Procedure TRectObj.Catch(Const P: TPoint);
Begin
  If A.X>P.X Then A.X:=P.X;
  If B.X<=P.X Then B.X:=P.X+1;
  If A.Y>P.Y Then A.Y:=P.X;
  If B.Y<=P.Y Then B.Y:=P.Y+1;
End;

{TGeo}
Procedure TGeo.Init;
Begin
  FillChar(Self, SizeOf(Self), 0);
  Cos1:=1; Sin2:=1;
End;

Procedure TGeo.OnTo(Var X: TComplex);
{Образ точки при преобразовании}
Begin
  X.Assign(X.Re*Cos1 + X.Im*Cos2 + X0,
           X.Re*Sin1 + X.Im*Sin2 + Y0)
End;

Procedure TGeo.GotFrom(Var X: TComplex);
{Прообраз точки}
Begin
  Reversed.OnTo(X);
End;

Function TGeo.Reversed: TGeo;
Var
  V: TComplex;
Begin
  V.Re:=Det;
  Result.Cos1:=Sin2/V.Re;
  Result.Cos2:=-Cos2/V.Re;
  Result.Sin1:=-Sin1/V.Re;
  Result.Sin2:=Cos1/V.Re;
  Result.X0:=0; Result.Y0:=0;
  V.Re:=-X0;  V.Im:=-Y0;
  Result.OnTo(V);
  Result.Add(V);
End;

Procedure TGeo.Expand(Factor: Float);
Begin
  Sin1:=Sin1*Factor;
  Cos1:=Cos1*Factor;
  Sin2:=Sin2*Factor;
  Cos2:=Cos2*Factor;
End;

Function TGeo.Det: Float;
Begin
  Det:=Cos1*Sin2-Cos2*Sin1
End;

Procedure TGeo.Add(Const Disp: TComplex);
Begin
  X0:=X0+Disp.Re;
  Y0:=Y0+Disp.Im;
End;

Procedure TGeo.MulI;
Var
  T: TGeo;
Begin
  T:=Self;
  Cos1:=-T.Sin1;
  Cos2:=-T.Sin2;
  Sin1:= T.Cos1;
  Sin2:= T.Cos2;
  X0  :=-T.Y0;
  Y0  := T.X0;
End;


Function TGeo.Aspect: Float;  {-1<=Aspect<=1}
{Условный коэффициент искажения:
  Точный поворот (с растяжением) +1
  Точная осевая симметрия (с растяжением) -1
  Вырожденное преобразование 0
}
Begin
  Aspect:=2*Det/(Sqr(Cos1)+Sqr(Cos2)+Sqr(Sin1)+Sqr(Sin2))
End;

{TViewPort}
Procedure TViewPort.Init(Const winI: TRect; Const winR: TRectan);
Var
  W: TRect;
  Sz: TPoint;
  L, LL: TComplex;
Begin
  W:=winI;
  If Flags And vpMirrorX<>0 Then
   Begin
    Sz.X:=W.Left; W.Left:=W.Right; W.Right:=Sz.X;
   End;
  If Flags And vpMirrorY=0 Then
   Begin
    Sz.X:=W.Top; W.Top:=W.Bottom; W.Bottom:=Sz.X;
   End;
  If Flags And vpSwapXY<>0 Then
   Begin
    Sz.X:=W.Left; W.Left:=W.Top; W.Top:=Sz.X;
    Sz.X:=W.Right; W.Right:=W.Bottom; W.Bottom:=Sz.X;
   End;
  Sz:=W.B; Sz.O.Sub(W.A.O);
  If Sz.X=0 Then Sz.X:=1;
  If Sz.Y=0 Then Sz.Y:=1;
  L:=winR.Max; L.Sub(winR.Min);
  L.Re:=L.Re/Sz.X; LL.Re:=Abs(L.Re);
  L.Im:=L.Im/Sz.Y; LL.Im:=Abs(L.Im);
  If LL.Re<LL.Im Then LL.Re:=LL.Im;
  LL.Re:=1/LL.Re;
  If L.Re<0 Then Factor.Re:=-LL.Re Else Factor.Re:=LL.Re;
  If L.Im<0 Then Factor.Im:=-LL.Re Else Factor.Im:=LL.Re;
  Delta.Re:=(winR.Max.Re+winR.Min.Re-(W.Left+W.Right)/Factor.Re)/2;
  Delta.Im:=(winR.Max.Im+winR.Min.Im-(W.Top+W.Bottom)/Factor.Im)/2;
End;

Function TViewPort.F2I(Const X: TComplex): TPoint;
Begin
  Result.AsVector[Flags And vpSwapXY]:=Round((X.Re-Delta.Re)*Factor.Re);
  Result.AsVector[(Not Flags)And vpSwapXY]:=Round((X.Im-Delta.Im)*Factor.Im);
End;

Function TViewPort.I2F(Const X: TPoint): TComplex;
Begin
  Result.Re:=X.AsVector[Flags And vpSwapXY]/Factor.Re+Delta.Re;
  Result.Im:=X.AsVector[(Not Flags)And vpSwapXY]/Factor.Im+Delta.Im;
End;

Function TViewPort.F2IRect(Const X: TRectan): TRect;
Begin
  Result.A:=F2I(X.Min);
  Result.B:=Result.A;
  Result.O.Catch(F2I(X.Max));
End;

Function TViewPort.I2FRect(Const X: TRect): TRectan;
Begin
  Result.Min:=I2F(X.A);
  Result.Max:=Result.Min;
  Result.Catch(I2F(X.B));
End;

Procedure TViewPort.Move(Const Step: TPoint);
Begin
  Delta.Re:=Delta.Re-Step.AsVector[Flags And vpSwapXY]/Factor.Re;
  Delta.Im:=Delta.Im-Step.AsVector[(Not Flags)And vpSwapXY]/Factor.Im;
End;

Procedure TViewPort.Collate(Const winI: TRect; Const winR: TRectan; Mode: Integer);
{  ??01  |<----
   ??10  ---->|
   01??  ^
   10??  V
}
Begin
  If Mode And 1<>0 Then
    Delta.Re:=winR.Min.Re-winI.Left/Factor.Re;
  If Mode And 2<>0 Then
    Delta.Re:=winR.Max.Re-winI.Right/Factor.Re;
  If Mode And 4<>0 Then
    Delta.Im:=winR.Max.Im-winI.Top/Factor.Im;
  If Mode And 8<>0 Then
    Delta.Im:=winR.Min.Im-winI.Bottom/Factor.Im;
End;

{TArcher}
Procedure TArcher.InitLine(Const A, B: TComplex;
                           Const aViewPort: TViewPort);
Begin
  ViewPort:=@aViewPort;
  Mid:=B; Mid.Add(A); Mid.Contract(2);
  Dif:=B; Dif.Sub(Mid);
  i:=0; N:=0;
End;

Procedure TArcher.Init(Const A, B: TComplex; Tan4: Float;
                       Const aViewPort: TViewPort);
Var
  Acc: Float;
Begin
  InitLine(A, B, aViewPort);
  Acc:=aViewPort.Factor.Abs*Dif.Abs;
  If Acc*Abs(Tan4)>1 Then
   Begin
    T2:=Sqrt(1+Sqr(Tan4));
    T4:=Tan4;
    N:=1+Trunc(Sqrt(4*Acc*(1+Sqr(Tan4))/Abs(Tan4)-4)*(T2-1)/Abs(Tan4));
    i:=2-N;
   End;
End;

Procedure TArcher.Init3(Const A, Thru, B: TComplex;
                        Const aViewPort: TViewPort);
Var
  P, Q: TComplex;
Begin
  P:=Thru; P.Sub(A);
  Q:=B; Q.Sub(Thru); Q.Conj;
  P.Mul(Q);
  Init(A, B, P.Im/(P.Abs+P.Re), aViewPort);
End;

Procedure TArcher.First;
Var
  R: TComplex;
  P: TPoint Absolute Self;
Begin
  R:=Mid; R.Sub(Dif);
  P:=ViewPort^.F2I(R);
End;

Procedure TArcher.Next;
Var
  P: TPoint Absolute Self;
  C1, C2: TComplex;
Begin
  If i>=N Then
    C1:=Dif
  Else
   Begin
    C1.Re:=i/N;
    C1.Assign(C1.Re/(T2-(T2-1)*Abs(C1.Re)), T4);
    C2.Assign(1, C1.Re*C1.Im);
    C1.Divide(C2);
    C1.Mul(Dif);
   End;
  C1.Add(Mid);
  P:=ViewPort^.F2I(C1);
  Inc(i, 2)
End;

Function TArcher.Done: Boolean;
Begin
  Done:=i>N;
End;

End.



unit KapDll;
// Интерфейс к библиотеке прямоугольного раскроя Kap.DLL
interface uses
  Windows, Classes,
  SirMath, SirDbs, WrapDbs, Struc;

Type
  PKapralResult=^TKapralResult;
  TKapralResult=Record
    X, Y, W, H: Integer;
    ListNo, DetailNo, Rotated: Short;
  End;

  TGetPosition=Function(No: Integer; Var Result: TKapralResult): Integer; StdCall;
  TSetParameters=Procedure(nPar, Kol: Integer); StdCall;
  TAddRectangle=Procedure(IsList, Count, W, H: Integer); StdCall;
  TKapralMain=Procedure; StdCall;

  TKapralDetail=Class(TCollectionItem)
  Public
    Results: TList; // of TKapralResult
    Dbs: TRDbs;
    Count: Integer;

    Constructor Create(J: TJobItem);
    Destructor Destroy; Override;

    Procedure Add(Const Res: TKapralResult);
    Function W: Integer;
    Function H: Integer;
    Function Bounds(Const Res: TKapralResult): TRectan;
  End;

  PKapral=^TKapral;
  TKapral=Object
    Distance: Float;
    Lists, Details: TCollection;

    Procedure Init;
    Procedure Done;

    Procedure Add(J: TJobItem);
    Procedure ResetListCount;
    Function Bounds: TRectan;
  End;

  TKapralThread=Class(TSafeThread)
    Constructor Create;
    Destructor Destroy; Override;

    Procedure StartWith(Var Kap: TKapral);
    Procedure SetParams(nPar, Kol: Integer);
    Procedure Execute; Override;
  Private
    hLib: THandle;
    GetPosition: TGetPosition;
    SetParameters: TSetParameters;
    AddRectangle: TAddRectangle;
    KapralMain: TKapralMain;
    K: ^TKapral;
  End;

Implementation uses
  SysUtils;

{TKaptThread}
Constructor TKapralThread.Create;
Begin
  Inherited Create(True); // Suspended
  FreeOnTerminate:=True;
  hLib:=LoadLibrary(PChar(ExtractFileDir(ParamStr(0))+'\kap.dll'));
  If hLib=0 Then
    Raise Exception.Create('Не могу подключить библиотеку Kap.DLL!');
  KapralMain:=GetProcAddress(hLib, 'Kapral');
  GetPosition:=GetProcAddress(hLib, 'GetPosition');
  SetParameters:=GetProcAddress(hLib, 'SetParameters');
  AddRectangle:=GetProcAddress(hLib, 'AddRectangle');
  If(@KapralMain=Nil)Or(@GetPosition=Nil)Or(@SetParameters=Nil)
     Or(@AddRectangle=Nil) Then
   Raise Exception.Create('Неверный формат библиотеки Kap.DLL!');
End;

Destructor TKapralThread.Destroy;
Begin
  FreeLibrary(hLib);
  Inherited;
End;

Procedure TKapralThread.SetParams(nPar, Kol: Integer);
Begin
  SetParameters(nPar, Kol);
End;

Procedure TKapralThread.Execute;
Var
  i, n: Integer;
  R: TKapralResult;
  D: TKapralDetail;
  Dist: Integer;
 Procedure Done;
 Begin
   OnExecute(TObject(K));
 End;
Begin
//SetParameters(2, 3);
  Dist:=Round(K.Distance);
  For i:=0 To K.Lists.Count-1 Do
   With TKapralDetail(K.Lists.Items[i]) Do
    Begin
     Dbs.R.Max.Re:=Dbs.R.Max.Re-Dist;
     Dbs.R.Max.Im:=Dbs.R.Max.Im-Dist;
     AddRectangle(1, Count, W, H);
    End;
  For i:=0 To K.Details.Count-1 Do
   With TKapralDetail(K.Details.Items[i]) Do
    AddRectangle(0, Count, W+Dist, H+Dist);
  KapralMain;
  i:=0; n:=0;
  While GetPosition(i, R)>0 Do
   Begin
    Repeat
     D:=TKapralDetail(K.Details.Items[n]);
     If D.Count=0 Then Break;   // Деталь с о счетиком 0 ???
     If(D.Results=Nil)Or(D.Results.Count<D.Count)Then Break;
     Inc(n);
    Until False;
    Inc(R.X, Dist); Inc(R.Y, Dist);
    D.Add(R);
    Inc(i);
   End;
  If Assigned(OnExecute) Then
    Sync(@Done);
End;

Procedure TKapralThread.StartWith(Var Kap: TKapral);
Begin
  K:=@Kap;
  Resume;
End;

{TKapralDetail}
Constructor TKapralDetail.Create(J: TJobItem);
Var
  S: TStream;
Begin
  Inherited Create(Nil);
  Dbs.Init;
  S:=J.GetStream;
  Dbs.Load(S);
  S.Free;
  Count:=J.Count;
  Dbs.R:=Dbs.Bounds;
End;

Destructor TKapralDetail.Destroy;
Begin
  Dbs.Done;
  If Results<>Nil Then
    While Results.Count>0 Do
     Begin
      Dispose(PKapralResult(Results[0]));
      Results.Delete(0);
     End;
  Results.Free;
  Inherited;
End;

Procedure TKapralDetail.Add(Const Res: TKapralResult);
Var
  P: PKapralResult;
Begin
  New(P);
  P^:=Res;
  If Results=Nil Then
    Results:=TList.Create;
  Results.Add(P)
End;

Function TKapralDetail.W: Integer;
Begin
  Result:=Round(Abs(Dbs.R.Max.Re-Dbs.R.Min.Re))
End;

Function TKapralDetail.H: Integer;
Begin
  Result:=Round(Abs(Dbs.R.Max.Im-Dbs.R.Min.Im))
End;

Function TKapralDetail.Bounds(Const Res: TKapralResult): TRectan;
Var
  T: Float;
Begin
  Result.Max:=Dbs.Size;
  If Res.Rotated<>0 Then
   Begin
    T:=Result.Max.Re;
    Result.Max.Re:=Result.Max.Im;
    Result.Max.Im:=T;
   End;
  Result.Min.Assign(Res.X, Res.Y);
  Result.Max.Add(Result.Min); 
End;

{TKapral}
Procedure TKapral.Init;
Begin
  Lists:=TCollection.Create(TKapralDetail);
  Details:=TCollection.Create(TKapralDetail);
  Distance:=0;
End;

Procedure TKapral.Done;
Begin
  Lists.Free;
  Details.Free;
End;

Procedure TKapral.Add(J: TJobItem);
Var
  C: TCollection;
Begin
  C:=Details;
  If J.IsList Then
    C:=Lists;
  TKapralDetail.Create(J).Collection:=C;
End;

Procedure TKapral.ResetListCount;
Begin
  If Lists.Count>0 Then
    TKapralDetail(Lists.Items[0]).Count:=1;
End;

Function TKapral.Bounds: TRectan;
Var
  i, j: Integer;
Begin
  Result.Min:=cx_0;
  Result.Max:=cx_0;
// Рассчитаем границы всех листов
  For i:=Lists.Count-1 DownTo 0 Do
    With TKapralDetail(Lists.Items[i]) Do
     Begin
      Result.Max.Re:=Result.Max.Re+Dbs.R.Size.Re*Count;
      If Dbs.R.Size.Im>Result.Max.Im Then
        Result.Max.Im:=Dbs.R.Size.Im;
     End;
// Учтем границы всех деталей
  For i:=Details.Count-1 DownTo 0 Do
    With TKapralDetail(Details.Items[i]) Do
      For j:=Results.Count-1 DownTo 0 Do
        Result.Union(Bounds(PKapralResult(Results[j])^));
End;

end.

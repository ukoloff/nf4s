unit Nesting;

Interface uses
  Classes,
  SirMath, SirDBS;

Type
  TPlaceEvent=Procedure(Const Position: TComplex) Of Object;

  TNester=Class(TCollection)
  Protected
    FOnPlace: TPlaceEvent;
    Procedure Place(Const Position: TComplex); Virtual;
  Public
    Margin,
    Offset: Float;

    Property OnPlace: TPlaceEvent Read FOnPlace Write FOnPlace;

    Constructor Create(Const List: TRectan);

    Procedure Tile(Const Size: TComplex; TileCount: Integer);
  End;

  TDbsSaver=Class(TNester)
  Protected
    No: Integer;
    S: TStream;
    Dbs: PDbs;
    pLast: TComplex;
    Copy: Boolean;

    Procedure Place(Const Position: TComplex); Override;
  Public

    Constructor Create(Const List: TDbs; Stream: TStream);
    Destructor Destroy; Override;

    Procedure Tile(Const aDbs: TDbs; TileCount: Integer);
  End;

Implementation

Type
  TCorner=Class(TCollectionItem)
  Public
    P: TComplex;
  End;


{TNester}
Constructor TNester.Create(Const List: TRectan);
Begin
  Inherited Create(TCorner);
  Margin:=List.Max.Re;
  TCorner.Create(Self).P:=List.Min;
End;

Procedure TNester.Place(Const Position: TComplex);
Begin
  If Assigned(FOnPlace)Then
    FOnPlace(Position);
End;

Procedure TNester.Tile(Const Size: TComplex; TileCount: Integer);
Var
  i, j, n, m: Integer;
  Pos, Q, sSize, sPos: TComplex;
Begin
  sSize:=Size;
  sSize.Re:=sSize.Re+Offset;
  sSize.Im:=sSize.Im+Offset;
  While TileCount>0 Do
   Begin
    i:=0;
    Repeat
      Pos:=TCorner(Items[i]).P;
      j:=i;
      While j<Count Do
       Begin
        Q:=TCorner(Items[j]).P;
        If Q.Im>Pos.Im+sSize.Im Then
          Break;
        If Q.Re>Pos.Re Then
          Pos.Re:=Q.Re
        Else If((Q.Im-Pos.Im)*2<sSize.Im)And(Q.Re+sSize.Re<Pos.Re)Then
         Begin
          j:=i;
          Inc(i);
          Break;
         End;
        If(j+1<Count)And(Pos.Re+sSize.Re>Margin-Offset)Then
         Begin
          i:=j+1;
          Break;
         End;
        Inc(j);
       End;
      If j<i Then
        Continue;
      m:=Trunc((Margin-Offset-Pos.Re)/sSize.Re);
      If m=0 Then
        m:=1;
      If m>TileCount Then
        m:=TileCount;
      Dec(TileCount, m);
      For n:=m-1 DownTo 0 Do
       Begin
        sPos:=Pos;
        sPos.Re:=sPos.Re+Offset;
        sPos.Im:=sPos.Im+Offset;
        Place(sPos);
        Pos.Re:=Pos.Re+sSize.Re;
       End;
      Q.Assign(TCorner(Items[j-1]).P.Re, Pos.Im+sSize.Im);
      While j>i+1 Do
       Begin
        Dec(j);
        Items[j].Free;
       End;
      TCorner(Items[i]).P.Re:=Pos.Re{+sSize.Re};
      With TCorner.Create(Self)Do
       Begin
        P:=Q;
        Index:=i+1;
       End;
      Break;
    Until False;
   End;
End;

{TDbsSaver}
Constructor TDbsSaver.Create(Const List: TDbs; Stream: TStream);
Begin
  Inherited Create(List.Bounds);
  No:=List.Renumerate(No);
  S:=Stream;
  List._Save(S);
  
  List.Done;
End;

Procedure TDbsSaver.Place(Const Position: TComplex);
Var
  Disp: TComplex;
Begin
  Inherited;
  If Copy Then
    No:=Dbs.CopyRenumerate(No)
  Else
    No:=Dbs.Renumerate(No);
  Copy:=True;
  Disp:=Position; Disp.Sub(pLast);
  pLast:=Position;
  Dbs.Shift(Disp);
  Dbs._Save(S);
End;

Procedure TDbsSaver.Tile(Const aDbs: TDbs; TileCount: Integer);
Var
  R: TRectan;
Begin
  If TileCount<=0 Then Exit;
  R:=aDbs.Bounds;
  R.Max.Sub(R.Min);
  Copy:=False;
  Dbs:=@aDbs;
  pLast:=R.Min;
  Inherited Tile(R.Max, TileCount);

  aDbs.Done;
End;

Destructor TDbsSaver.Destroy;
Begin
  Inherited;
  Dbs.End_Save(S);
  S.Free;
End;

end.

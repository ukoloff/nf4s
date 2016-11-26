Unit Dxf;
Interface uses
  SirMath, SirDbs;

Procedure ImportDxf(Var F: Text; Var Result: TDbs);
Procedure ExportDxf(Var F: Text; Var D: TDbs);

Implementation uses
  SysUtils;

Type
  TDxfImport=Object
    F: ^Text;
    GroupNo: Integer;
    GroupName: String;

    Procedure ReadGroup;
    Function GetFloat: Float;
    Function GetInt: Integer;
    Function ReadPolyLine(LW: Boolean): TOrig;
    Function ReadCircle: TOrig;
  End;

{TDxfImport}
Procedure TDxfImport.ReadGroup;
Var
  S: String;
  i, j: Integer;
Begin
  GroupNo:=0;
  GroupName:='EOF';
  If EOF(F^) Then Exit;
  ReadLN(F^, S);
  If EOF(F^) Then Exit;
  ReadLN(F^, GroupName);
  GroupName:=Trim(GroupName);
  Val(Trim(S), i, j);
  If j=0 Then
    GroupNo:=i;
End;

Function TDxfImport.GetFloat: Float;
Var
  i: Integer;
Begin
  Val(GroupName, Result, i);
  If i<>0 Then Result:=0;
End;

Function TDxfImport.GetInt: Integer;
Var
  i: Integer;
Begin
  Val(GroupName, Result, i);
  If i<>0 Then Result:=0;
End;

Function TDxfImport.ReadPolyLine(LW: Boolean): TOrig;
Var
  N, G71: Integer;
  Pt: TComplex;
Begin
  N:=0; G71:=0;
  Result:=TOrig.Create(Nil);
  Repeat
    ReadGroup;
    Case GroupNo Of
      0: If UpperCase(GroupName)<>'VERTEX' Then Break Else Continue;
     10:
      Begin
       Inc(N);
       If N+Byte(LW)<2 Then Continue; {Skip 1st point}
       Pt.Assign(GetFloat, 0);
       Result.AddPoint(Pt);
      End;
     20: If Result.Nodes<>Nil Then Result.Nodes.A.Src.A.Im:=GetFloat;
     42: If Result.Nodes<>Nil Then Result.SetK(-GetFloat);
     70: If Result.Nodes=Nil Then G71:=GetInt;
    End{Case}
  Until False;
  If (G71 And 1)=0 Then
    Result.BreakMe;
End;

Function TDxfImport.ReadCircle: TOrig;
Var
  R: Float;
  C: TComplex;
Begin
  R:=0;
  Repeat
    ReadGroup;
    Case GroupNo Of
      0: Break;
     10: C.Re:=GetFloat;
     20: C.Im:=GetFloat;
     40: R:=GetFloat;
    End{Case}
  Until False;
  Result:=TOrig.Create(Nil);
  C.Re:=C.Re-R;
  Result.AddPoint(C);
  Result.SetK(1);
  C.Re:=C.Re+2*R;
  Result.AddPoint(C);
  Result.SetK(1);
End;

Procedure ImportDxf(Var F: Text; Var Result: TDbs);
Var
  X: TDxfImport;
  O: TOrig;
  State: Integer;
Begin
  X.F:=@F;
  State:=0; O:=Nil;
  Result.Init;
  Repeat
    If O=Nil Then
      X.ReadGroup
    Else
     Begin {Add Original+Copy}
      O.Collection:=Result.Origs;
      O:=Nil;
     End;
    Case X.GroupNo Of
     0:
      Begin
       X.GroupName:=UpperCase(X.GroupName);
       If X.GroupName='EOF' Then Break
       Else If X.GroupName='ENDSEC' Then State:=0
       Else If X.GroupName='SECTION' Then
        Begin
         If State=0 Then State:=1
        End
       Else If State=3 Then
         If X.GroupName='CIRCLE' Then O:=X.ReadCircle
         Else If X.GroupName='POLYLINE' Then O:=X.ReadPolyLine(False)
         Else If X.GroupName='LWPOLYLINE' Then O:=X.ReadPolyLine(True);
      End;
     2: If State=1 Then If UpperCase(X.GroupName)='ENTITIES' Then
          State:=3
        Else
          State:=4;
    End{Case};
  Until False;
//  Result.Complete;
End;

Procedure ExportDxf(Var F: Text; Var D: TDbs);
Var
  i: Integer;
  C: TCopy;
  N: TSpanIterator;
Begin
  WriteLN(F, '  0'#13#10+
             'SECTION'#13#10+
             '  2'#13#10+
             'ENTITIES');
  For i:=0 To D.Copies.Count-1 Do
   Begin
    C:=TCopy(D.Copies.Items[i]);
    If Not C.Valid Then Exit;
    WriteLN(F, '  0'#13#10+
               'POLYLINE'#13#10+
               ' 10'#13#10+
               '0.0'#13#10+
               ' 20'#13#10+
               '0.0'#13#10+
               ' 30'#13#10+
               '0.0'#13#10+
               '  8'#13#10+
               '0'#13#10+
               ' 66'#13#10+
               '1');
    If C.Closed Then WriteLN(F, ' 70'#13#10'1');
    N.Init(C);
    While N.Advance Do
     Begin
      WriteLN(F, '  0'#13#10+
                 'VERTEX'#13#10+
                 ' 10'#13#10,
                 N.vA.Re:0:3, #13#10+
                 ' 20'#13#10,
                 N.vA.Im:0:3);
      If N.Flags And nfArc<>0 Then WriteLN(F, ' 42'#13#10, -N.k:0:3);
      WriteLN(F, '  8'#13#10+
                 '0');
     End;
    If Not C.Closed Then
     WriteLN(F, '  0'#13#10+
                'VERTEX'#13#10+
                ' 10'#13#10,
                N.vB.Re:0:3, #13#10+
                ' 20'#13#10,
                N.vB.Im:0:3);
    WriteLN(F, '  0'#13#10+
               'SEQEND');
   End;
  WriteLN(F, '  0'#13#10+
             'ENDSEC'#13#10+
             '  0'#13#10+
             'EOF');
End;

end.

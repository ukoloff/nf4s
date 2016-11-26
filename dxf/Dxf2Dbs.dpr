program Dxf2Dbs;

uses
  SysUtils,
  Classes,
  Dxf in 'Dxf.pas',
  SirMath in '..\DBS\SirMath.pas',
  SirDBS in '..\DBS\SirDBS.pas';

{$R *.RES}

Const
  fmtDbs=0;
  fmtDxf=1;

Var
  SrcName, TgtName, DetName, LongDetName: String;
  OptO, OptC, TgtFmt: ShortInt;
Const
  Gap: Float=1E-3;

Procedure Help;
Begin
  WriteLN('Dxf2Dbs. Dxf<=>Dbs converter. Stas Ukolov <stas@ekb.ru>, 2000');
  WriteLN('Usage: Dxf2Dbs [Options] FileName[.ext] [FileName.[ext]]');
  WriteLN('Options: /Ox - Actions on existing result-file');
  WriteLN('           /O, /O+ - Overwrite');
  WriteLN('           /O- - Don''t touch (cancel operation)');
  WriteLN('           /O? - Ask user (default)');
  WriteLN('         /Tx - set target format (if .ext ommited)');
  WriteLN('          /T, /TX - .DXF');
  WriteLN('          /TB - .DBS (default)');
  WriteLN('         /D[=]<Name> - set detail name. Implies /TB');
  WriteLN('         /N[=]<Name> - set long detail name (record 28). Implies /TB');
  WriteLN('         /Cx - closing');
  WriteLN('          /C, /C- - never close');
  WriteLN('          /C+ - Close if gap is less then 0.001mm (default)');
  WriteLN('          /C[=]<distance> - Close if gap is less then <distance>, mm');
  Halt(1);
End;

Procedure ParseCmdLine;
Const
  Exts: Array[fmtDbs..fmtDxf]Of String[4]=('.DBS', '.DXF');
Var
  i, Args: Integer;
  S: String;
  C: Char;
Begin
  Args:=0;
  For i:=1 To ParamCount Do
   Begin
    S:=ParamStr(i);
    Case S[1] Of
     '/', '-':
      Begin
       Delete(S, 1, 1);
       If Length(S)<1 Then Help;
       C:=UpCase(S[1]);
       Delete(S, 1, 1);
       Case C Of
        'O':
         Begin
          If Length(S)>1 Then Help;
          OptO:=+1;
          If Length(S)>0 Then
           Case S[1] Of
            '+':;
            '-': OptO:=-1;
            '?': OptO:=0;
           Else
            Help;
           End{Case}
         End;
        'D':
         Begin
          If(Length(S)>1)And(S[1]='=') Then Delete(S, 1, 1);
          DetName:=S;
          TgtFmt:=fmtDbs;
         End;
        'N':
         Begin
          If(Length(S)>1)And(S[1]='=') Then Delete(S, 1, 1);
          LongDetName:=S;
          TgtFmt:=fmtDbs;
         End;
        'T':
          Case Length(S) Of
           0: TgtFmt:=fmtDxf;
           1:
            Case UpCase(S[1]) Of
             'X': TgtFmt:=fmtDxf;
             'B': TgtFmt:=fmtDbs;
            Else
              Help
            End{Case};
          Else
            Help
          End{Case};
        'C':
          If(Length(S)=0)Or(S='-')Then OptC:=1
          Else If S='+' Then OptC:=0
          Else
           Begin
            OptC:=0;
            If S[1]='=' Then Delete(S, 1, 1);
            Try
              Gap:=StrToFloat(S);
            Except On EConvertError Do;
            End;
           End{'C'};
       Else
         Help
       End{Case};
      End;
    Else
     Inc(Args);
     Case Args Of
      1:
       Begin
        SrcName:=S;
        TgtName:=ChangeFileExt(S, '');
        If UpperCase(ExtractFileExt(S))='.DBS' Then TgtFmt:=fmtDxf;
       End;
      2:
       Begin
        TgtName:=S;
        S:=UpperCase(ExtractFileExt(S));
        If S='.DBS' Then TgtFmt:=fmtDbs
        Else If S='.DXF' Then TgtFmt:=fmtDxf;
       End;
     Else
       Help
     End{Case};
    End{Case};
   End;
  If(Args=0)Then Help;
  If ExtractFileExt(TgtName)='' Then
    TgtName:=ChangeFileExt(TgtName, Exts[TgtFmt]);
  If ExtractFileExt(SrcName)='' Then
    SrcName:=ChangeFileExt(SrcName, Exts[1-TgtFmt]);
  If DetName='' Then
    DetName:=ChangeFileExt(ExtractFileName(TgtName), '');

  If Not FileExists(SrcName) Then
   Begin
    WriteLN('File "', SrcName, '" doesn''t exist!');
    Halt(2);
   End;
  If FileExists(TgtName) Then
   Case OptO Of
    -1:
     Begin
      WriteLN('File "', TgtName, '" exists!');
      Halt(3);
     End;
    0:
     Begin
      Write('File "', TgtName, '" exists. Overwrite [y/N]?');
      ReadLN(S);
      If(Length(S)=0)Or(UpCase(S[1])<>'Y')Then Halt(3);
     End;
   End{Case};
End;

Procedure CloseCircuits(Var D: TDbs);
Var
  i: Integer;
  C: TOrig;
  V: PVertex;
Begin
  For i:=D.Origs.Count-1 DownTo 0 Do
   Begin
    C:=TOrig(D.Origs.Items[i]);
    If(C.Nodes=Nil)Or(C.Nodes.A.Src<>Nil)Then Continue;
    V:=C.Nodes.B;
    While V.Dst<>Nil Do
      V:=V.Dst.B;
    If V.Dist(C.Nodes.A^)>Gap Then Continue;
    V.Src.B:=C.Nodes.A;
    C.Nodes.A.Src:=V.Src;
    Dispose(V);
   End;
End;

Procedure ConvertDxf;
Var
  F: TextFile;
  D: TDbs;
  S: TFileStream;
begin
  AssignFile(F, SrcName);
  Reset(F);
  ImportDxf(F, D);
  CloseFile(F);
  D.Description:=LongDetName;
  If OptC=0 Then
    CloseCircuits(D);
  D.Reorganize(DetName);
//  D.Renumerate(0);
  S:=TFileStream.Create(TgtName, fmCreate);
  D.Save(S);
  S.Free;
  D.Done;
  WriteLN('Done!');
End;

Procedure ConvertDbs;
Var
  S: TFileStream;
  F: TextFile;
  D: TDbs;
Begin
  S:=TFileStream.Create(SrcName, fmOpenRead);
  D.Init;
  D.Load(S);
  S.Free;
  AssignFile(F, TgtName); Rewrite(F);
  ExportDxf(F, D);
  CloseFile(F);
  D.Done;
End;

begin
  ParseCmdLine;
  If TgtFmt=fmtDbs Then
    ConvertDxf
  Else
    ConvertDbs;
end.

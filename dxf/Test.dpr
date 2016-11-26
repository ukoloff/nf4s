program Test;

uses
  SysUtils,
  Classes,
  Dxf in 'Dxf.pas',
  SirMath in '..\DBS\SirMath.pas',
  SirDBS in '..\DBS\SirDBS.pas';

{$R *.RES}

Var
  DxfName, DbsName, DetName: String;
  OptO: ShortInt;

Procedure Help;
Begin
  WriteLN('Usage: Dxf2Dbs [Options] FileName[.DXF] [FileName.[DBS]]');
  WriteLN('Options: /Ox - Actions on existing DBS-file');
  WriteLN('           /O, /O+ - Overwrite');
  WriteLN('           /O- - Don''t touch (cancel operation)');
  WriteLN('           /O? - Ask user (default)');
  WriteLN('         /D[=]<Name> - set detail name');
  Halt(1);
End;

Procedure ParseCmdLine;
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
         End;
       End{Case};
      End;
    Else
     Inc(Args);
     Case Args Of
      1: Begin DxfName:=S; DbsName:=ChangeFileExt(S, ''); End;
      2: DbsName:=S;
     Else
       Help
     End{Case};
    End{Case};
   End;
  If Args=0 Then Help;
  If ExtractFileExt(DbsName)='' Then DbsName:=ChangeFileExt(DbsName, '.DBS');
  If ExtractFileExt(DxfName)='' Then DxfName:=ChangeFileExt(DxfName, '.DXF');
  If DetName='' Then DetName:=ChangeFileExt(ExtractFileName(DbsName), '');

  If Not FileExists(DxfName) Then
   Begin
    WriteLN('File "', DxfName, '" doesn''t exist!');
    Halt(2);
   End;
  If FileExists(DbsName) Then
   Case OptO Of
    -1:
     Begin
      WriteLN('File "', DbsName, '" exists!');
      Halt(3);
     End;
    0:
     Begin
      Write('File "', DbsName, '" exists. Overwrite [y/N]?');
      ReadLN(S);
      If(Length(S)=0)Or(UpCase(S[1])<>'Y')Then Halt(3);
     End;
   End{Case};
End;

Procedure Main;
Var
  F: TextFile;
  D: TDbs;
  S: TFileStream;
begin
  ParseCmdLine;
  AssignFile(F, ParamStr(1));
  Reset(F);
  D:=ImportDxf(F);
  CloseFile(F);
  D.Reorganize(ChangeFileExt(ExtractFileName(ParamStr(1)), ''));
  D.Renumerate(0);
  S:=TFileStream.Create(ChangeFileExt(ParamStr(1), '.dbs'), fmCreate);
  D.Save(S);
  S.Free;
  D.Done;
End;

begin
  Main
end.

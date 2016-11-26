program DbsFilter;

uses
  Windows, SysUtils,
  Classes,
  SirMath in '..\DBS\SirMath.pas',
  SirDBS in '..\DBS\SirDBS.pas';

{$R *.RES}

Var
  InName: String;

Procedure Help;
Begin
  MessageBox(0,
   'Usage: DbsFilter File[.Dbs] TextFile', 'Help & Usage',
    mb_IconInformation);
  Halt(1);
End;

Procedure ParseCmdLine;
Begin
  If ParamCount<>2 Then Help;
  InName:=ParamStr(1);
  If ExtractFileExt(InName)='' Then
    InName:=ChangeFileExt(InName, '.DBS');
  If Not FileExists(InName) Then
    Halt(2);
End;

Procedure DoIt;
Var
  S: TFileStream;
  D: TDbs;
  R: TRectan;
Begin
  S:=TFileStream.Create(InName, fmOpenRead);
  D.Init;
  D.Load(S);
  S.Free;
  R:=D.Bounds;

  Assign(Output, ParamStr(2)); Rewrite(Output);
  WriteLN('S= ', D.Area*1E-4:0:3);
  WriteLN('P= ', D.Perimeter*1E-2:0:3);
  WriteLN('X= ', R.Max.Re-R.Min.Re:0:1);
  WriteLN('Y= ', R.Max.Im-R.Min.Im:0:1);
  CloseFile(Output);
End;

begin
  ParseCmdLine;
  DoIt;
end.

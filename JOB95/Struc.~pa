unit Struc;

Interface uses
  Classes, Controls;

Const
  sfLst=$01;
  sfKol=$02;
  sfJob=$04;
  sfDbs=$08;

  sfTrum=$01;
  sfQuiet=$02;
  sf1=$04;

Type
  TJobItem=Class(TCollectionItem)
  Private
    FPath: String;
    FArcNo: Integer;

    Procedure SetPath(S: String);
    Procedure SetAsLst(S: String);
    Function GetAsLst: String;
    Procedure SetAsKol(S: String);
    Function GetAsKol: String;
  Public
    Count: Integer;
    List: Boolean;

    Property Path: String Read FPath Write SetPath;
    Property AsLst: String Read GetAsLst Write SetAsLst;
    Property AsKol: String Read GetAsKol Write SetAsKol;

    Procedure AppendExt;
    Function Validate(Lst: String): Boolean;

    Function IsList: Boolean;
    Function InDb: Boolean;
    Property ArcNo: Integer Read FArcNo;

    Function GetStream: TStream;
    Procedure RemoveFile;
  End;

Var
  DragItem: TJobItem;

Function DroppedItems(Drop: Integer): TCollection;
Function PastedItems: TCollection;

Implementation uses
{$IfnDef DisableDB}
  Dbf,
{$EndIf}
  SysUtils, Clipbrd, ShellApi;

{TJobItem}
Function TJobItem.IsList: Boolean;
Begin
  IsList:=List Or(Index=0);
End;

Procedure TJobItem.SetPath(S: String);
Begin
  FPath:=Trim(S);
  If FArcNo=0 Then
    FPath:=ExpandFileName(FPath);
//  If ExtractFileExt(FPath)='' Then FPath:=FPath+'.DBS';
End;

Function TJobItem.GetAsLst: String;
Begin
  Result:=Path;
  If FArcNo>0 Then
    Result:=IntToStr(FArcNo)+'>'+Result;
  If Count<>1 Then
    Result:=IntToStr(Count)+'*'+Result;
  If List Then
    Result:='='+Result;
End;

Procedure TJobItem.SetAsLst(S: String);
Var
  i: Integer;
Begin
  S:=Trim(S);
  List:=(Length(S)>0)And(S[1]='=');
  If List Then
   Begin
    Delete(S, 1, 1);
    S:=Trim(S);
   End;
  Count:=1;
  i:=Pos('*', S);
  If i>0 Then
   Begin
    Count:=StrToInt(Trim(Copy(S, 1, i-1)));
    Delete(S, 1, i);
   End;
  S:=Trim(S);
  FArcNo:=0;
  i:=Pos('>', S);
  If i>0 Then
   Begin {Вырежем номер в архиве}
    FArcNo:=StrToInt(Copy(S, 1, i-1));
    Delete(S, 1, i);
   End;
  Path:=Trim(S);
End;

Function TJobItem.GetAsKol: String;
Begin
  Result:=ChangeFileExt(Path, '');
  If Pos(' ', Result)>0 Then
    Result:='"'+Result+'"';
  If FArcNo>0 Then
    Result:=IntToStr(FArcNo)+'>'+Result;
  Result:=Result+' '+IntToStr(Count);
  Result:=Result+' '+Chr(Ord('1')-Integer(IsList));
End;

Procedure TJobItem.SetAsKol(S: String);
 Function GetWord: String;
 Var
   i: Integer;
 Begin
   S:=Trim(S);
   If(Length(S)>0)And(S[1]='"')Then
    Begin
     Delete(S, 1, 1);
     i:=Pos('"', S);
    End
   Else
     i:=Pos(' ', S);
   If i<=0 Then i:=1+Length(S);
   Result:=Trim(Copy(S, 1, i-1));
   Delete(S, 1, i);
 End;
Var
  i: Integer;
Begin
  FPath:=GetWord;
  FArcNo:=0;
  i:=Pos('>', FPath);
  If i>0 Then
   Begin
    FArcNo:=StrToInt(Trim(Copy(Path, 1, i-1)));
    Delete(FPath, 1, i);
   End;
  Path:=FPath;
  AppendExt;
  Count:=StrToInt(GetWord);
  If StrToIntDef(GetWord, 1)=0 Then
    List:=True;
End;

Function TJobItem.InDb: Boolean;
Begin
  Result:=FArcNo>0;
End;

Function TJobItem.GetStream: TStream;
Begin
  Result:=Nil;
Try
  If InDb Then
  {$IfnDef DisableDB}
    Result:=DbForm.GetData(fArcNo)
  {$EndIf}
  Else
    Result:=TFileStream.Create(Path, fmOpenRead);
Except
End;
End;

Procedure TJobItem.RemoveFile;
Begin
  If InDb Then
  {$IfnDef DisableDB}
    DbForm.RemoveFile(fArcNo)
  {$EndIf}
  Else
    DeleteFile(Path);
End;

Procedure TJobItem.AppendExt;
Begin
  If(Length(Path)>0)And(ExtractFileExt(Path)='') Then
    Path:=Path+'.DBS';
End;

Function TJobItem.Validate(Lst: String): Boolean;
Begin
  Result:=False;
  Try
    AsLst:=Lst;
  Except
    Exit
  End;
  If UpperCase(ExtractFileExt(Path))<>'.DBS' Then Exit;
  If Not InDb And Not FileExists(Path) Then Exit;
  Result:=True;
End;

Function DroppedItems(Drop: Integer): TCollection;
Var
  S: String;
  JI: TJobItem;
  No: Integer;
Begin
  JI:=Nil;
  Result:=TCollection.Create(TJobItem);
  No:=DragQueryFile(Drop, -1, Nil, 0);
  Repeat
    Dec(No);
    SetLength(S, 1+DragQueryFile(Drop, No, Nil, 0));
    DragQueryFile(Drop, No, PChar(S), Length(S));
    If JI=Nil Then JI:=TJobItem.Create(Result);
    If JI.Validate(S) Then JI:=Nil;
  Until No<=0;
  JI.Free;
  DragFinish(Drop);
End;

Function PastedItems: TCollection;
Var
  S, X: String;
  JI: TJobItem;
  i: Integer;
Begin
  Result:=TCollection.Create(TJobItem);
  S:=Clipboard.AsText;
  JI:=Nil;
  While S<>'' Do
   Begin
    i:=Pos(#13, S);
    If i=0 Then i:=1+Length(S);
    X:=Trim(Copy(S, 1, i-1));
    System.Delete(S, 1, i);
    If JI=Nil Then JI:=TJobItem.Create(Result);
    If JI.Validate(X) Then JI:=Nil;
   End;
  JI.Free;
End;


end.


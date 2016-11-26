unit Layouts;

Interface uses
  Menus, Classes;

Var
  fLayout: TStringList;

Procedure DefaultLayout;
Procedure MakeSubMenu(M: TMenuItem);
Function LayoutString(No: Integer): String;
Function DefaultLayoutString: String;
Procedure SaveLayouts;
Procedure LoadLayouts;

Implementation uses
  SysUtils,
  SirReg;

Function LayoutString(No: Integer): String;
Var
  X: TStringList;
Begin
  X:=TStringList.Create;
  X.CommaText:=fLayout[No];
  Result:=X[0];
  X.Free;
End;

Function DefaultLayoutString: String;
Var
  i: Integer;
Begin
  For i:=fLayout.Count-1 DownTo 0 Do
    If Char(fLayout.Objects[i])>='a' Then
      Result:=LayoutString(i);
End;

Procedure DefaultLayout;
Begin
  fLayout:=TStringList.Create;
  fLayout.AddObject('"V38,50;J38,,,50;F,,38",&Файлы', Pointer('A'));
  fLayout.AddObject('"J38,,,50;T,50,38;F,,38,50;V38,50", "+Текст"', Pointer('e'));
  fLayout.AddObject('"V38,50;J38,,,50;A,,38",&Архив', Pointer('B'));
  fLayout.AddObject('"V38,50;J38,,,50;A,50,38;F,,38,50","Файлы &и архив"', Pointer('C'));
  fLayout.Add('');
  fLayout.AddObject('"V38;A,,38", "&Ведение архива"', Pointer('D'));
End;

Procedure MakeSubMenu(M: TMenuItem);
Var
  i: Integer;
  N: TMenuItem;
  X: TStringList;
Begin
  While M.Count>0 Do
    M[0].Free;
  X:=TStringList.Create;
  For i:=fLayout.Count-1 DownTo 0 Do
   Begin
    N:=TMenuItem.Create(Nil);
    M.Insert(0, N);
    If fLayout.Objects[i]=Nil Then
     Begin
      N.Caption:='-';
      Continue;
     End;
    N.Tag:=i;
    N.OnClick:=M.OnClick;
    X.CommaText:=fLayout[i];
    N.Caption:=X[1];
    If Char(fLayout.Objects[i])>='a' Then
      N.Default:=True;
    If X.Count>2 Then N.ShortCut:=StrToIntDef(X[2], 0);
    If X.Count>3 Then N.Hint:=X[3];
   End;
End;

Procedure SaveLayouts;
Var
  S: String;
  i: Integer;
Begin
  SirRegistry.OpenKey('Layouts', True);
  S:='';
  For i:=fLayout.Count-1 DownTo 0 Do
   Begin
    If fLayout.Objects[i]=Nil Then S:=' '+S
    Else
     Begin
      S:=Char(fLayout.Objects[i])+S;
      SirRegistry.WriteString(UpCase(S[1]), fLayout[i]);
     End;
   End;
  SirRegistry.WriteString('', S);
  SirRegistry.UpLevel;
End;

Procedure LoadLayouts;
Var
  S, N: String;
  i: Integer;
Begin
  If Not SirRegistry.OpenKey('Layouts', False) Then Exit;
  S:=SirRegistry.ReadString('');
  If S='' Then Exit;
  fLayout.Clear;
  For i:=Length(S) DownTo 1 Do
   Begin
    N:='';
    If S[i]<>' ' Then
      fLayout.InsertObject(0, SirRegistry.ReadString(UpCase(S[i])), Pointer(S[i]))
    Else
      fLayout.Insert(0, '');
   End;
  SirRegistry.UpLevel;
End;

end.

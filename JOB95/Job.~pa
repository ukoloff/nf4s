unit Job;

interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, Struc, SirMath, SirDbs{, ImgList};

type
  TJobForm = class(TForm)
    List: TListView;
    Hdr: THeaderControl;
    BoxImg: TImageList;
    MainMenu1: TMainMenu;
    mM: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    SaveDlg: TSaveDialog;
    N2: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PosImg: TImageList;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    mR: TPopupMenu;
    N1: TMenuItem;
    AutoNest1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    procedure HdrResize(Sender: TObject);
    procedure HdrSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure ListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Folder(Sender: TObject);
    procedure mMClick(Sender: TObject);
    procedure DoDel(Sender: TObject);
    procedure ToHome(Sender: TObject);
    procedure ToEnd(Sender: TObject);
    procedure DoMove(Sender: TObject);
    procedure DoReset(Sender: TObject);
    procedure IncCount(Sender: TObject);
    procedure Props(Sender: TObject);
    procedure ListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormActivate(Sender: TObject);
    procedure ListStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure DoCopy(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure mRPopup(Sender: TObject);
    procedure AutoNest1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure EndAutoNest(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    Modified: Boolean;
    Items: TCollection;

    Procedure DragRepos;
    Procedure wmDropFiles(Var Msg: TwmDropFiles); Message wm_DropFiles;
    Procedure AddItems(NewItems: TCollection);

    Procedure SetItem(I: TJobItem);
    Procedure MoveTo(Pos: Integer);

    Function CheckOutputName(Ext: String): String;
    Function JobItem: TJobItem;
    Procedure GetDbs(Var D: TDbs);

    Function SaveFlags: Integer;
    Procedure Report(FileName: String);

    Procedure SaveAsLst;
    Procedure SaveAsKol;
    Procedure SaveAsJob;
    Procedure SaveAsDbs;
    Procedure SaveDbsThruKapral;
    Procedure SaveDbsThruExt(Mode: Integer);
    Function DbsName(No: Integer): String;
    Procedure LoadLst(S: String);
    Procedure LoadKol(S: String);
    Procedure LoadJob(N: String);

    Procedure KapralNested(Kap: TObject);
    Procedure KapralNestedForSave(Kap: TObject);
  public
    Procedure AddItem(anItem: String);
    Function CheckSave: Boolean;

    Procedure Clear;
    Procedure Load(S: String);
    Procedure Save;
  end;

  TIterator=Object
    Procedure Init(F: TJobForm);
    Function Next: Boolean;
    Function GetStream: TStream;
    Function Count: Integer;
    Function Item: TJobItem;
    Function Area: Float;
  Private
    Start, This: Integer;
    Items: TCollection;
  End;

Var
  JobForm: TJobForm;

Implementation uses
  FileCtrl, DbGrids, ShellApi, Clipbrd,
  SirReg, Files,
{$IfnDef DisableDB}
  Dbf,
{$EndIf}
  Main, JbProp, Nesting, View, ExecWait, KapDll;

{$R *.DFM}

Const
  cmdLineStabel=' 0 2 0 1';

Procedure WriteAutoNestConfig;
Var
  F: Text;
Begin
  Assign(F, 'autonest.cfg'); Rewrite(F);
  WriteLN(F, ' CBS=1');
  WriteLN(F, ' ROT=', Params.Param['anRot'].AsInteger);
  WriteLN(F, ' MIRR=', Params.Param['anMirror'].AsInteger);
  WriteLN(F, ' RANGE=', Params.Param['Distance'].AsString);
  WriteLN(F, ' VARIANT=', Params.Param['anQuan'].AsString);
  WriteLN(F, ' RANGEL=', Params.Param['anLDist'].AsString);
  Close(F);
End;

Function GetExeFile(Mode: Integer): String;
Const
  ExeFiles: Array[0..1]Of String=('auto2000.exe', 'WinStab.exe');
Begin
  Result:=ExtractFileDir(ParamStr(0))+'\'+ExeFiles[Mode];
  If Mode=0 Then
    WriteAutoNestConfig;
End;

Procedure SetKapralParameters(T: TKapralThread);
Begin
  T.SetParams(Params.Param['kNum'].AsInteger,
    Params.Param['kKol'].AsInteger);
End;

{TIterator}
Procedure TIterator.Init(F: TJobForm);
Begin
  Items:=F.Items;
  Start:=0;
  If F.List.ItemFocused<>Nil Then
    Start:=F.List.ItemFocused.Index;
  This:=-1;
End;

Function TIterator.Next: Boolean;
Begin
  If This>=0 Then
   Begin
    Inc(This);
    Result:=(This<Items.Count)And Not TJobItem(Items.Items[This]).IsList;
    Exit;
   End;
  This:=Start;
  While(This>=0) And Not TJobItem(Items.Items[This]).IsList Do Dec(This);
  Result:=This>=0;
End;

Function TIterator.Count: Integer;
Begin
  Result:=0;
  If(This<0)Or(This>=Items.Count)Then Exit;
  Result:=TJobItem(Items.Items[This]).Count;
End;

Function TIterator.GetStream: TStream;
Var
  X: TJobItem;
Begin
  Result:=Nil;
  If(This<0)Or(This>=Items.Count)Then Exit;
  X:=TJobItem(Items.Items[This]);
  Result:=X.GetStream;
//  TFileStream.Create(X.Path, fmOpenRead);
End;

Function TIterator.Area: Float;
Var
  S: TStream;
  D: TDbs;
Begin
  Result:=0;
  D.Init;
  S:=GetStream;
  Try
    D.Load(S);
    Result:=D.Area;
  Finally
    S.Free;
    D.Done;
  End;
End;


Function TIterator.Item: TJobItem;
Begin
  Result:=Nil;
  If(This<0)Or(This>=Items.Count)Then Exit;
  Result:=TJobItem(Items.Items[This])
End;

Function TJobForm.SaveFlags: Integer;
Begin
  Result:=Params.Param['SaveMode'].AsInteger;
End;

procedure TJobForm.HdrResize(Sender: TObject);
Var
  i: Integer;
begin
  Hdr.Sections[2].Width:=Hdr.Width-List.Width+List.ClientWidth-
                         Hdr.Sections[0].Width-Hdr.Sections[1].Width;
  For i:=2 DownTo 0 Do
    List.Columns[i].Width:=Hdr.Sections[i].Width;
end;

procedure TJobForm.HdrSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  HdrResize(Nil);
end;

procedure TJobForm.ListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=DragItem<>Nil
end;

Procedure TJobForm.AddItem(anItem: String);
Var
  J: TJobItem;
Begin
  anItem:=Trim(anItem);
  If Length(anItem)=0 Then Exit;
  J:=TJobItem.Create(Items);
  J.AsLst:=anItem;
  List.Items.Add;
  SetItem(J);
  Modified:=True
End;

Function TJobForm.CheckSave: Boolean;
Begin
  CheckSave:=True;
  If Not Modified Then Exit;
  Case Application.MessageBox('Задание изменено. Сохранить?',
    PChar(Application.Title), mb_IconQuestion+mb_YesNoCancel) Of
   idYes: {DoSave};
   idNo:;
  Else
    CheckSave:=False;
  End{Case}
End;

Procedure TJobForm.Clear;
Begin
  Items.Clear;
  List.Items.Clear;
  SaveDlg.FileName:='';
  Modified:=False;
End;

Procedure TJobForm.Save;
Var
  SaveAs, NestMode: Integer;
Begin
  If Items.Count=0 Then Exit;
  If(Length(SaveDlg.FileName)=0)And Not SaveDlg.Execute Then
    Exit;

  SaveAs:=Params.Param['Output'].AsInteger;
  NestMode:=Params.Param['NestMode'].AsInteger;
  If SaveAs And sfLst<>0 Then
    SaveAsLst;
  If(SaveAs And sfKol<>0)Or
    ((SaveAs And sfDbs<>0)And(NestMode>=2)) Then
    SaveAsKol;
  If SaveAs And sfJob<>0 Then
    SaveAsJob;
  If SaveAs And sfDbs<>0 Then
   Case NestMode Of
    0: SaveAsDbs;
    1: SaveDbsThruKapral;
    2, 3: SaveDbsThruExt(NestMode-2);
   End{Case};
End;

procedure TJobForm.FormCreate(Sender: TObject);
begin
  Items:=TCollection.Create(TJobItem);
  SaveDlg.InitialDir:=GetCurrentDir;
  DragAcceptFiles(Handle, True);
end;

procedure TJobForm.FormDestroy(Sender: TObject);
begin
  Items.Free
end;

procedure TJobForm.ListDragDrop(Sender, Source: TObject; X, Y: Integer);
Var
  N: Integer;
begin
  If Source=Sender Then
   Begin
    DragRepos;
    Exit
   End;
  If DragItem=Nil Then Exit;
  N:=Items.Count;
  If List.DropTarget<>Nil Then
    N:=List.DropTarget.Index+1;
//  Items.Add(DragItem);
  DragItem.Collection:=Items;
  DragItem.Index:=N;
  List.Items.Insert(N);
  SetItem(DragItem);
  DragItem:=Nil;
end;

Procedure TJobForm.DragRepos;
Var
  i: Integer;
Begin
  If List.DropTarget=Nil Then
    i:=List.Items.Count
  Else
    i:=List.DropTarget.Index;
  MoveTo(i);
End;

Procedure TJobForm.SetItem(I: TJobItem);
Begin
  With List.Items[I.Index]Do
   Begin
    Caption:=ChangeFileExt(ExtractFileName(I.Path), '');
    ImageIndex:=Integer(I.InDb)+1;
    StateIndex:=Integer(I.IsList)-1;
    While SubItems.Count<2 Do
      SubItems.Add('');
    SubItems[0]:=IntToStr(I.Count);
    SubItems[1]:=ExtractFileDir(I.Path);
   End;
End;

procedure TJobForm.Folder(Sender: TObject);
begin
  If List.Selected=Nil Then Exit;
  With JobItem Do
    If InDb Then
  {$IfnDef DisableDB}
      DbForm.GotoFile(ArcNo)//**********************)FArcNo)
  {$EndIf}
    Else
      FilesForm.GotoFile(Path);
end;

procedure TJobForm.mMClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  For i:=M.Count-1 DownTo 0 Do
    If M[i].Tag=2 Then M[i].Enabled:=Clipboard.HasFormat(cf_Text)
    Else M[i].Enabled:=List.Selected<>Nil
end;

procedure TJobForm.DoDel(Sender: TObject);
begin
  If(List.Selected=Nil)Or
    (Application.MessageBox('Удалить пункт из задания?',
      'Подтвердите', mb_IconQuestion+mb_YesNo)<>idYes)Then Exit;
  JobItem.Free;
  List.Selected.Free;
  If Items.Count>0 Then
    SetItem(TJobItem(Items.Items[0]));
  Modified:=True
end;

Procedure TJobForm.MoveTo(Pos: Integer);
Var
  X: TJobItem;
  i: Integer;
Begin
  If Pos<0 Then Pos:=0;
  If Pos>=Items.Count Then
    Pos:=Items.Count-1;
  If(List.Selected=Nil)Or(List.Selected.Index=Pos)Then Exit;
  X:=JobItem;
  List.Selected.Free;
  X.Index:=Pos;
  List.Items.Insert(Pos);
  SetItem(X);
  If Items.Count>0 Then
    SetItem(TJobItem(Items.Items[0]));
  With List.Items[Pos] Do
   Begin
    Focused:=True;
    Selected:=True;
   End;
  For i:=Items.Count-1 DownTo 0 Do
    SetItem(TJobItem(Items.Items[i]));
  Modified:=True;
End;

procedure TJobForm.ToHome(Sender: TObject);
begin
  MoveTo(0);
end;

procedure TJobForm.ToEnd(Sender: TObject);
begin
  MoveTo(Items.Count);
end;

procedure TJobForm.DoMove(Sender: TObject);
begin
//  If List.Selected<>Nil Then
    MoveTo(List.Selected.Index+TMenuItem(Sender).Tag);
end;

Function TJobForm.CheckOutputName(Ext: String): String;
Begin
  Result:=ChangeFileExt(SaveDlg.FileName, Ext);
  If FileExists(Result) Then
    If Application.MessageBox(PChar('Файл "'+Result+'" существует. Перезаписать?'),
      'Сохранение', mb_IconQuestion+mb_YesNo)<>idYes Then
      Abort;
End;

Procedure TJobForm.Report(FileName: String);
Begin
  If SaveFlags And sfQuiet=0 Then
    Application.MessageBox(PChar('Создан файл "'+FileName+'"!'),
      PChar(Application.Title), mb_IconInformation);
End;

Procedure TJobForm.SaveAsLst;
Var
  S: String;
  F: TextFile;
  i: Integer;
Begin
  S:=CheckOutputName('.Lst');
  AssignFile(F, S); Rewrite(F);
  For i:=0 To Items.Count-1 Do
    WriteLN(F, TJobItem(Items.Items[i]).AsLst);
  CloseFile(F);
  Report(S);
  Modified:=False;
End;

Procedure TJobForm.SaveAsKol;
Var
  S: String;
  F: TextFile;
  i: Integer;
Begin
  S:=CheckOutputName('.Kol');
  AssignFile(F, S); Rewrite(F);
  For i:=0 To Items.Count-1 Do
    WriteLN(F, TJobItem(Items.Items[i]).AsKol);
  CloseFile(F);
  Report(S);
  Modified:=False;
End;

Function TJobForm.DbsName(No: Integer): String;
Var
  S2: String[2];
Begin
   Result:=ChangeFileExt(ExtractFileName(SaveDlg.FileName), '');
   If(No<>1)Or(SaveFlags And sf1=0)Then
    Begin
     If Length(Result)>5 Then
       SetLength(Result, 5);
     Str(No, S2);
     While Length(S2)<2 Do
       S2:='0'+S2;
     Result:=Result+'_'+S2;
    End;
End;

Procedure TJobForm.SaveAsJob;
Var
  S: String;
  F: TextFile;
  i, ListNo: Integer;
  HasArc: Boolean;
 Function Name2: String;
 Begin
   Result:=IntToStr(ListNo);
   While Length(Result)<2 Do
     Result:='0'+Result;
 End;
 Procedure EndList;
 Begin
   If SaveFlags And sfTrum<>0 Then
     WriteLN(F, 'ACC/9100'#13#10+
                'LOAD/'#13#10+
                'ACC/9102'#13#10+
                'LOAD/'#13#10+
                'ACC/9104'#13#10+
                'LOAD/'#13#10+
                'ACC/9106'#13#10+
                'LOAD/');
   WriteLN(F, 'ACC/', AnsiUpperCase(DbsName(ListNo)));
   WriteLN(F,
    'CUR CEN DRA/0'#13#10+
    'UNSAVE/-999 -999'#13#10+
    'SAVE'#13#10+
    'EMPTY/-9999'#13#10+
    'LOAD CUR CEN DRA/0'#13#10+
    'UNSAVE/-999 -999');
   If Params.Param['Distance'].AsString<>'' Then
   WriteLN(F, 'ALLOW/', Params.Param['Distance'].AsString);
   WriteLN(F,
    'NEST/1'#13#10+
    'EOF/EOF');
   CloseFile(F);
   Report(S);
 End;
 Procedure StartList;
 Begin
   If ListNo>0 Then
     EndList;
   Inc(ListNo);
   If ListNo=1 Then
     S:=CheckOutputName('.J01')
   Else
    Begin
     SetLength(S, Length(S)-2);
     S:=S+Name2;
    End;
   AssignFile(F, S); Rewrite(F);
 End;
Begin
  HasArc:=False;
  ListNo:=0;
  For i:=0 To Items.Count-1 Do
    With TJobItem(Items.Items[i]) Do
     Begin
      If IsList Then
        StartList;
      If InDb Then
        HasArc:=True;
      WriteLN(F, 'ACC/', ChangeFileExt(Path, ''));
      Write(F, 'LOAD/'); If Not IsList Then Write(F, '0'); WriteLN(F);
      If Count>1 Then
        WriteLN(F, 'QUAN/:', UpperCase(ChangeFileExt(ExtractFileName(Path), '')),
          ', ', Count-1);
     End;
  EndList;
  If HasArc Then
    Application.MessageBox('Файлы из архива геометрии помещены в задание.'^M+
     'Полученный файл не будет считан никакой программой...',
     'Имейте в виду', mb_IconInformation);
  Modified:=False;
End;

Procedure TJobForm.SaveAsDbs;
Var
  N: TDbsSaver;
  i, No: Integer;
  D: TDbs;
  S: TFileStream;
Begin
  N:=Nil; No:=0;
  For i:=0 To Items.Count-1 Do
    With TJobItem(Items.Items[i]) Do
     Begin
      Self.List.Selected:=Self.List.Items[Index];
      GetDbs(D);
      If IsList Then
       Begin
        If i>0 Then
          N.Free;
        Inc(No);
        S:=TFileStream.Create(ExtractFilePath(SaveDlg.FileName)+
             DbsName(No)+'.DBS', fmCreate);
        N:=TDbsSaver.Create(D, S);
        N.Offset:=Params.Param['Distance'].AsInteger;
       End
      Else
        N.Tile(D, Count);
     End;
   N.Free;
End;

Function TJobForm.JobItem: TJobItem;
Begin
  Result:=Nil;
  If List.Selected=Nil Then Exit;
  Result:=TJobItem(Items.Items[List.Selected.Index]);
End;

procedure TJobForm.DoReset(Sender: TObject);
begin
  JobItem.Count:=1;
  SetItem(JobItem);
end;

procedure TJobForm.IncCount(Sender: TObject);
begin
  JobItem.Count:=JobItem.Count+TMenuItem(Sender).Tag;
  If JobItem.Count<=0 Then
    JobItem.Count:=1;
  SetItem(JobItem);
end;

procedure TJobForm.Props(Sender: TObject);
begin
  If JobItem=Nil Then Exit;
  If JobProp=Nil Then
    JobProp:=TJobProp.Create(Nil);
  JobProp.Execute(JobItem);
  SetItem(JobItem);
end;

Procedure TJobForm.Load(S: String);
Var
  E: String;
Begin
  If Not CheckSave Then Abort;
  Clear;
  E:=UpperCase(ExtractFileExt(S));
  Try
    If E='.LST' Then
      LoadLst(S)
    Else If E='.KOL' Then
      LoadKol(S)
    Else If E='.J01' Then
      LoadJob(S)
    Else
      Raise Exception.CreateFmt('Неизвестный тип файла "%s" !', [E]);
  Except
    Clear;
    Raise
  End;
  Modified:=False;
  SaveDlg.FileName:=ExpandFileName(S);
  Modified:=False;
End;

Procedure TJobForm.LoadLst(S: String);
Var
  F: TextFile;
Begin
  AssignFile(F, S);
  Reset(F);
  While Not EOF(F) Do
   Begin
    ReadLN(F, S);
    AddItem(S);
   End;
  CloseFile(F);
End;

Procedure TJobForm.LoadKol(S: String);
Var
  F: TextFile;
  J: TJobItem;
Begin
  AssignFile(F, S);
  Reset(F);
  While Not EOF(F) Do
   Begin
    ReadLN(F, S);
    S:=Trim(S);
    If Length(S)=0 Then Continue;
    J:=TJobItem.Create(Items);
    J.AsKol:=S;
    List.Items.Add;
    SetItem(J);
   End;
  CloseFile(F);
End;

Function IsAlpha(C: Char): Boolean;
Begin
  Result:=False;
  Case C Of
   'A'..'Z',
   'a'..'z': Result:=True
  End;
End;

Function IsDelim(C: Char): Boolean;
Begin
  Result:=False;
  Case C Of
   ' ', '/': Result:=True
  End;
End;

Procedure TJobForm.LoadJob(N: String);
Var
  F: TextFile;
  i, Cnt, ListN: Integer;
  S, LastName: String;
  S3: String[3];
  Added, ListWas: Boolean;
 Function JobItem: TJobItem;
 Begin
   Result:=TJobItem(Items.Items[Items.Count-1]);
 End;
Begin
  ListN:=0;
  Repeat
    Inc(ListN);
    Str(ListN:2, S3);
    If S3[1]=' ' Then S3[1]:='0';
    N:=ChangeFileExt(N, '.J'+S3);
    If Not FileExists(N) Then Exit;
    AssignFile(F, N); Reset(F);
    LastName:=''; Added:=False; ListWas:=False; Cnt:=1;
Try
    While Not EOF(F)Do
     Begin
      ReadLN(F, S);
      S:=Trim(S);
      If Length(S)<4 Then Continue;
      S3:=S; S3:=AnsiUpperCase(S3);
      If S3='ACC' Then i:=0
      Else If S3='LOA' Then i:=1
      Else If S3='QUA' Then i:=2
      Else Continue;
      System.Delete(S, 1, 3);
      While(Length(S)>0)And IsAlpha(S[1])Do
        System.Delete(S, 1, 1);
      While(Length(S)>0)And IsDelim(S[1])Do
        System.Delete(S, 1, 1);
      Case i Of
       0:{ACC} Begin LastName:=S; Cnt:=1; Added:=False End;
       1:{LOAD}
        Begin
         If((Length(S)=0)Or(S[1]<>'0'))And ListWas {Загрузка листа}
           Or(Length(LastName)=0)Then
           Continue;
         AddItem(LastName);
         JobItem.AppendExt;
         JobItem.Count:=Cnt;
         JobItem.List:=Not ListWas;
         SetItem(JobItem);
         ListWas:=True;
         Added:=True;
        End;
      Else {2: QUAN}  // Quan/:PARTID, N
        System.Delete(S, 1, Pos(',', S));
        S:=Trim(S);
        Val(S, Cnt, i);
        Case i Of
         0:;
         1: Cnt:=0;
        Else
          SetLength(S, i-1);
          Val(S, Cnt, i);
        End{Case};
        Inc(Cnt);
        If Added Then
         Begin
          JobItem.Count:=Cnt;
          SetItem(JobItem);
         End;
      End{Case}
     End;
Finally
    CloseFile(F);
End
  Until False;
End;

Procedure TJobForm.GetDbs(Var D: TDbs);
Var
  S: TStream;
Begin
  D.Init;
  S:=JobItem.GetStream;
  Try
    D.Load(S);
  Finally
    S.Free;
  End;
End;

procedure TJobForm.ListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  If Active Then FormActivate(Self);
end;

procedure TJobForm.FormActivate(Sender: TObject);
begin
  If Items.Count<=0 Then Exit;
  ViewForm.StartJobDisplay;
end;

procedure TJobForm.ListStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  DragItem:=JobItem;
end;

procedure TJobForm.ListEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  DragItem:=Nil;
end;

Procedure TJobForm.wmDropFiles(Var Msg: TwmDropFiles);
Begin
  AddItems(DroppedItems(Msg.Drop));
End;

procedure TJobForm.DoCopy(Sender: TObject);
begin
  If List.Selected=Nil Then Exit;
  Clipboard.AsText:=JobItem.AsLst;
  If TMenuItem(Sender).Tag<>0 Then Exit;
  JobItem.Free;
  List.Selected.Free;
end;

procedure TJobForm.N10Click(Sender: TObject);
Begin
  AddItems(PastedItems);
End;

Procedure TJobForm.AddItems(NewItems: TCollection);
Var
  i: Integer;
  J: TJobItem;
begin
  If List.Selected=Nil Then i:=Items.Count
  Else i:=List.Selected.Index+1;
  While NewItems.Count>0 Do
   Begin
    J:=TJobItem(NewItems.Items[0]);
    J.Collection:=Items;
    J.Index:=i;
    List.Items.Insert(i);
    SetItem(J);
    Inc(i);
   End;
  NewItems.Free;
end;

procedure TJobForm.mRPopup(Sender: TObject);
begin
  FillPopup(mR, mM);
end;

procedure TJobForm.AutoNest1Click(Sender: TObject);
Var
  MI: TMenuItem Absolute Sender;
  JI: TIterator;
  F: TextFile;
  X: TShellExecuteInfo;
  sExe, sCmd, aTempPath: String;
begin // Вызов программ AutoNest и Stabel
  JI.Init(JobForm);
  If Not JI.Next Then Exit;
  aTempPath:=TempPath;
  ChDir(aTempPath);
  AssignFile(F, '$mj.kol'); Rewrite(F);
  Repeat
    WriteLN(F, JI.Item.AsKol);
  Until Not JI.Next;
  CloseFile(F);
  DeleteFile('$mj_01.dbs');

  FillChar(X, SizeOf(X), 0);
  X.cbSize:=SizeOf(X);
  X.fMask:=see_Mask_NoCloseProcess;
  X.Wnd:=Application.Handle;
  sExe:=GetExeFile(MI.Tag);
  X.lpFile:=PChar(sExe);
  sCmd:=aTempPath+'$mj.kol';
  If MI.Tag=1 Then sCmd:=sCmd+' '+Params.Param['Distance'].AsString;//+cmdLineStabel;
  X.lpParameters:=PChar(sCmd);
  X.nShow:=sw_Show;

  If Not ShellExecuteEx(@X) Then Exit;
  TWaitThread.Create(X.hProcess).OnTerminate:=EndAutoNest;
end;

procedure TJobForm.EndAutoNest(Sender: TObject);
Var
  T: TWaitThread Absolute Sender;
begin
(*
  If T.ExitStatus<>0 Then
   Begin
    Application.MessageBox('Программа фигурного раскроя завершила работу с ошибкой',
      PChar(Application.Title), mb_IconStop);
    Exit;
   End;
*)
//  ChDir(TempPath);
  ViewForm.ViewIt(TempPath+'$mj_01.dbs');
  ViewForm.Show;
end;

procedure TJobForm.N11Click(Sender: TObject);
Var
  JI: TIterator;
  K: PKapral;
  Th: TKapralThread;
begin // Вызов библиотеки раскроя Капрал
  JI.Init(JobForm);
  If Not JI.Next Then Exit;
  Th:=TKapralThread.Create;
  SetKapralParameters(Th);
  New(K);
  K.Init;
  K.Distance:=Params.Param['Distance'].AsInteger;
  Th.OnExecute:=KapralNested;
  K.Add(JI.Item);
  While JI.Next Do
    K.Add(JI.Item);
  K.ResetListCount;
  Th.StartWith(K^);
//  Th.WaitFor;
end;

Procedure TJobForm.KapralNested(Kap: TObject);
Var
  K: PKapral Absolute Kap;
Begin
  ViewForm.StartKapralDisplay(K);
  ViewForm.Show;
End;

Procedure TJobForm.SaveDbsThruKapral;
Var
  i: Integer;
  K: PKapral;
  Th: TKapralThread;
Begin
  Th:=TKapralThread.Create;
  SetKapralParameters(Th);
  New(K);
  K.Init;
  K.Distance:=Params.Param['Distance'].AsInteger;
  Th.OnExecute:=KapralNestedForSave;
  For i:=0 To Items.Count-1 Do
    K.Add(TJobItem(Items.Items[i]));
  Th.StartWith(K^);
End;


Procedure TJobForm.SaveDbsThruExt(Mode: Integer);
Var
  sExe, sCmd: String;
Begin
  ChDir(ExtractFileDir(SaveDlg.FileName));
  sExe:=GetExeFile(Mode);
  sCmd:=ChangeFileExt({ExtractFileName}(SaveDlg.FileName), '.kol');
  If Mode=1 Then sCmd:=sCmd+' '+Params.Param['Distance'].AsString;//+cmdLineStabel;
  ShellExecute(Application.Handle, Nil, PChar(sExe), PChar(sCmd), Nil, sw_Show);
End;

Procedure TJobForm.KapralNestedForSave(Kap: TObject);
Var
  K: PKapral Absolute Kap;
  S: TFileStream;
  i, j, m, n, nList, nRot, No: Integer;
  R: PKapralResult;
  Anchor, X: TComplex;
  DetailPut: Boolean;
Begin
  Anchor:=cx_0;
  nList:=-1;
  For i:=0 To K.Lists.Count-1 Do
   For m:=TKapralDetail(K.Lists.Items[i]).Count-1 DownTo 0 Do
   Begin
    Inc(nList);
    S:=TFileStream.Create(ExtractFilePath(SaveDlg.FileName)+
      DbsName(nList+1)+'.DBS', fmCreate);
    With TKapralDetail(K.Lists.Items[i]) Do
     Begin
      Dbs.MoveTo(Anchor);
      Anchor.Re:=Dbs.R.Max.Re;
      No:=Dbs.Renumerate(0);
      Dbs._Save(S);
     End;
    For j:=K.Details.Count-1 DownTo 0 Do
     With TKapralDetail(K.Details.Items[j]) Do
      Begin
       DetailPut:=False; nRot:=0;
       For n:=Results.Count-1 DownTo 0 Do
        Begin
         R:=Results[n];
         If R.ListNo<>nList Then Continue; //Выводим детали только этого листа
         If DetailPut Then
           No:=Dbs.CopyRenumerate(No)
         Else
           No:=Dbs.Renumerate(No);
         DetailPut:=True;
         X.Assign(R.X, R.Y);
         Dbs.MoveTo(X);
         If Odd(R.Rotated Xor nRot)Then
          Begin
           Inc(nRot);
           Dbs.Rotate90;
          End;
         Dbs._Save(S);
        End;
       For nRot:=((4-nRot) And 3) DownTo 1 Do
         Dbs.Rotate90; //Мы поверниули деталь nRot раз - возвращаем на место
      End;
    PDbs(Nil).End_Save(S);  
    S.Free;
   End;
End;

procedure TJobForm.N14Click(Sender: TObject);
Var
  JI: TIterator;
  SL, SD: Float;
begin
  JI.Init(JobForm);
  If Not JI.Next Then Exit;
  SL:=JI.Area; SD:=0;
  While JI.Next Do
    SD:=SD+JI.Area*JI.Count;
  Application.MessageBox(PChar(Format(
   'Площадь листа=%.3n кв. дм'^M+
   'Площадь деталей=%.3n кв. дм'^M+
   'Коэффициент раскроя=%.0f%%', [SL*1E-4, SD*1E-4, SD/SL*100])),
   PChar(Application.Title) , mb_IconInformation);
end;

procedure TJobForm.N1Click(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  For i:=M.Count-1 DownTo 0 Do
    M[i].Enabled:=Items.Count>0;
end;

end.

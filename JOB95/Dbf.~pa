unit Dbf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Menus, Grids, DBGrids, ComCtrls, ExtCtrls, StdCtrls, RxHook;

type
  TDbForm = class(TForm)
    tbFiles: TTable;
    MainMenu1: TMainMenu;
    mT: TMenuItem;
    dsFiles: TDataSource;
    Data: TDBGrid;
    Split: TSplitter;
    Tree: TTreeView;
    mD: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    tbDir: TTable;
    dsDir: TDataSource;
    tb2: TTable;
    N2: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Path: TLabel;
    tbFilesNo: TAutoIncField;
    tbFilesName: TStringField;
    tbFilesDir: TIntegerField;
    tbFilesInfo: TMemoField;
    tb2No: TAutoIncField;
    tb2Data: TBlobField;
    tb2Name: TStringField;
    tb2Dir: TIntegerField;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    tbFilescDate: TDateTimeField;
    tbFilesmDate: TDateTimeField;
    N19: TMenuItem;
    N20: TMenuItem;
    tbFilesData: TBlobField;
    N3: TMenuItem;
    mR: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure MsMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DataDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SplitMoved(Sender: TObject);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure DataDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dsFilesDataChange(Sender: TObject; Field: TField);
    procedure pFile(Sender: TObject);
    procedure DelFile(Sender: TObject);
    procedure NewDir(Sender: TObject);
    procedure DelTree(Sender: TObject);
    procedure pTree(Sender: TObject);
    procedure DataKeyPress(Sender: TObject; var Key: Char);
    procedure DataDblClick(Sender: TObject);
    procedure Del(Sender: TObject);
    procedure Ins(Sender: TObject);
    procedure Props(Sender: TObject);
    procedure TreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure DoCut(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DataStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure DataEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TreeStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure MsDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoPaste(Sender: TObject);
    procedure NewFile(Sender: TObject);
    procedure mDClick(Sender: TObject);
    procedure mRPopup(Sender: TObject);
    procedure mTClick(Sender: TObject);
  private
    Procedure wmDropFiles(Var Msg: TwmDropFiles); Message wm_DropFiles;
    Procedure RefreshNode(Node: TTreeNode; ForceChildren: Boolean);
    Procedure ShowDir(No: Integer);
    Function MakeURL: String;

    Procedure InsertGeo(Name: String; Geo: TStream);
  public
    Function GetPath(ItemNo: Integer): String;
    Function GetData(ItemNo: Integer): TStream;

    Procedure AddItem;
    Procedure GotoFile(No: Integer);
    Procedure RemoveFile(No: Integer);
  end;

Function DbForm: TDbForm;

Procedure AddAlias;

Implementation uses
  BDE,
  FileCtrl, Clipbrd, ShellApi,
  Struc, SirReg, View, DbPropD, DirProp, Job, Kod;

{$R *.DFM}

var
  FDbForm: TDbForm;

Function DbForm: TDbForm;
Begin
  Result:=FDbForm;
  If FDbForm=Nil Then
    Try
      Screen.Cursor:=crHourGlass;
      Application.Hint:='Подключаю библиотеки управления базами данных...';
      AddAlias;
      Application.Hint:='Загружаю базы данных...';
//    Status.Update;
      FDbForm:=TDbForm.Create(Nil);
    Finally
      Screen.Cursor:=crDefault;
      Application.Hint:='';
      Result:=FDbForm;
    End;
End;

Procedure AddAlias;
Var
  S: String;
Begin
  S:=SirRegistry.Global[gnGeoBase];
  If S='' Then
   Begin
    Application.MessageBox('Путь к базе данных не задан'^M+
      'Выполните команду Вид->Настройка|GeoDet', PChar(Application.Title),
      mb_IconStop);
    SysUtils.Abort;
   End;
  Sessions.OpenSession('');
  DbiAddAlias(Nil, 'GEODET', Nil, PChar('PATH:'+S), False);
End;

Type
  TG=Class(TDbGrid)
//  Public
//    Property OnMouseDown;
  End;

Function TDbForm.GetPath(ItemNo: Integer): String;
Begin
  Result:='';
  If Not tb2.FindKey([ItemNo]) Then Exit;
  Result:=tb2Name.AsString+'.DBS';
  ItemNo:=tb2Dir.AsInteger;
  tbDir.IndexName:='';
  If tbDir.State=dsBrowse Then
    While tbDir.FindKey([ItemNo]) Do
     Begin
      Result:=tbDir.FieldByName('Name').AsString+'\'+Result;
      ItemNo:=tbDir.FieldByName('Parent').AsInteger;
     End;
End;

Function TDbForm.GetData(ItemNo: Integer): TStream;
Begin
  Result:=Nil;
  If Not tb2.FindKey([ItemNo]) Then Exit;
  Result:=TMemoryStream.Create;
  tb2Data.SaveToStream(Result);
  Result.Position:=0;
End;

procedure TDbForm.FormCreate(Sender: TObject);
begin
  TG(Data).OnMouseMove:=MsMove;
//  TG(Data).OnMouseDown:=MsDown;
  SplitMoved(Nil);
  Tree.Items.Add(Nil, '').Data:=Pointer(tbDir.FieldByName('No').AsInteger);
  RefreshNode(Tree.Items.GetFirstNode, False);
  Tree.Items.GetFirstNode.Selected:=True;
  DragAcceptFiles(Handle, True);
end;

procedure TDbForm.MsMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  If(ssLeft In Shift)And(TWinControl(Sender).Focused)Then
    TControl(Sender).BeginDrag(False);
end;

procedure TDbForm.DataDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=(Source<>Sender)And(DragItem<>Nil);
end;

procedure TDbForm.SplitMoved(Sender: TObject);
begin
  Data.Columns[0].Width:=Data.ClientWidth;
end;

procedure TDbForm.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
Var
  i, j, s: TTreeNode;
begin
  i:=Tree.DropTarget;
  If i=Nil Then
    Exit;
  If Source=Data Then
   Begin {Data}
    tbFiles.Edit;
    tbFilesDir.AsInteger:=Integer(i.Data);
    tbFiles.Post;
   End;
  If Source=Sender Then
   Begin {Перемещаем поддерево}
    s:=Tree.Selected;
    j:=i;
    While j<>Nil Do
     Begin //Нельзя переместить каталог в свой подкаталог
      If j=s Then Exit;
      j:=j.Parent;
     End;
    j:=Tree.Selected.Parent;
    tbDir.IndexName:='';
    tbDir.FindKey([Integer(s.Data)]);
    tbDir.Edit;
    tbDir.FieldByName('Parent').AsInteger:=Integer(i.Data);
    tbDir.Post;
    RefreshNode(j, False);
    RefreshNode(i, True);
    i.Expand(False);
   End;
  i.Selected:=True;
  If(Source<>Data)And(DragItem<>Nil)Then
    DataDragDrop(Nil, Nil, 0, 0)
end;

procedure TDbForm.TreeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=(Source=Sender)Or(DragItem<>Nil);
end;

procedure TDbForm.TreeChange(Sender: TObject; Node: TTreeNode);
Var
  N: Integer;
  S: String;
begin
  N:=Integer(Node.Data);
  tbFiles.SetRange([N], [N]);
  While Node<>Nil Do
   Begin
    S:=Node.Text+'\'+S;
    Node:=Node.Parent;
   End;
  Path.Caption:=S;
end;

Procedure TDbForm.RefreshNode(Node: TTreeNode; ForceChildren: Boolean);
Var
  i, N: Integer;
  L: TList;
Begin
  tbDir.IndexName:='';
  N:=Integer(Node.Data);
  If Not tbDir.FindKey([N]) Then
   Begin
    Node.Free;
    Exit
   End;
  Node.Text:=tbDir.FieldByName('Name').AsString;
  tbDir.IndexName:='iName';
  tbDir.SetRange([N], [N]);
  Node.HasChildren:=tbDir.RecordCount>0;
  If Not (Node.HasChildren And ForceChildren Or Node.Expanded)Then
    Exit;
// Walking thru children...
  tbDir.First;
  L:=TList.Create;
  For i:=Node.Count-1 DownTo 0 Do
    L.Add(Node[i]);
  While Not tbDir.EOF Do
   Begin
    N:=tbDir.FieldByName('No').AsInteger;
    For i:=L.Count-1 DownTo 0 Do
     Begin
      If Integer(TTreeNode(L[i]).Data)<>N Then Continue;
      L.Delete(i);
      N:=-1;
      Break;
     End;
    If N>0 Then
      Node.Owner.AddChild(Node, '').Data:=Pointer(N);
    tbDir.Next;
   End;
  For i:=L.Count-1 DownTo 0 Do
    TTreeNode(L[i]).Free;
  L.Free;
  For i:=Node.Count-1 DownTo 0 Do
    RefreshNode(Node[i], False);
End;

procedure TDbForm.DataDragDrop(Sender, Source: TObject; X, Y: Integer);
Var
  D: TStream;
begin
  If DragItem=Nil Then Exit;
  D:=DragItem.GetStream;
  If D=Nil Then Exit;
  InsertGeo(ChangeFileExt(ExtractFileName(DragItem.Path), ''), D);
end;

procedure TDbForm.dsFilesDataChange(Sender: TObject; Field: TField);
begin
  SplitMoved(Nil);
  If Active Then
    ViewForm.ViewIt(MakeURL);
end;

procedure TDbForm.pFile(Sender: TObject);
begin
  If tbFiles.RecordCount<=0 Then Exit;
  If DbProp=Nil Then
    DbProp:=TDbProp.Create(Nil);
  DbProp.ActiveControl:=Nil;
  DbProp.ShowModal;
end;

procedure TDbForm.DelFile(Sender: TObject);
begin
  If(tbFiles.RecordCount>0)And
    (Application.MessageBox(PChar('Удалить деталь "'+
    tbFilesName.AsString+'" из архива?'),
    PChar(Caption), mb_IconQuestion+mb_OkCancel)=idOk)Then
  tbFiles.Delete
end;

procedure TDbForm.NewDir(Sender: TObject);
Var
  No: Integer;
begin
  tbDir.CancelRange;
  tbDir.Insert;
  tbDir.FieldByName('Parent').AsInteger:=Integer(Tree.Selected.Data);
  tbDir.FieldByName('cDate').AsDateTime:=Now;
  If Not EditDbDir Then Exit;
  No:=tbDir.FieldByName('No').AsInteger;
  RefreshNode(Tree.Selected, True);
  ShowDir(No);
end;

procedure TDbForm.DelTree(Sender: TObject);
Var
  N: TTreeNode;
  No: Integer;
begin
  If tbFiles.RecordCount>0 Then
   Begin
    If Application.MessageBox('Удалить все детали из этого каталога?',
      'Подтвердите', mb_IconQuestion+mb_YesNo+mb_DefButton2)<>idYes Then
      Exit;
    While tbFiles.RecordCount>0 Do
      tbFiles.Delete;
   End;
  N:=Tree.Selected;
  If N.HasChildren Then
   Begin
    Application.MessageBox('Не могу удалить каталог, имеющий подкаталоги!',
       PChar(Application.Title), mb_IconStop);
    Exit
   End;
  No:=Integer(N.Data);
  N:=N.Parent;
  If N=Nil Then
   Begin
    Application.MessageBox('Не могу удалить корневой каталог!',
       PChar(Application.Title), mb_IconStop);
    Exit
   End;
  tbDir.IndexName:='';
  If Not tbDir.FindKey([No])Then Exit;
  tbDir.Delete;
  N.Selected:=True;
  RefreshNode(N, True);
end;

procedure TDbForm.pTree(Sender: TObject);
Var
  N: Integer;
begin
  tbDir.CancelRange;
  tbDir.IndexName:='';
  N:=Integer(Tree.Selected.Data);
  If Not tbDir.FindKey([N]) Then Exit;
  If EditDbDir Then
    RefreshNode(Tree.Selected, False);
  TreeChange(Nil, Tree.Selected);
end;

Procedure TDbForm.AddItem;
Begin
  If tbFiles.RecordCount>0 Then
    JobForm.AddItem(MakeURL);
End;

procedure TDbForm.DataKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then
    AddItem;
end;

Procedure TDbForm.GotoFile(No: Integer);
Begin
  If Not tb2.FindKey([No]) Then SysUtils.Abort;
  ShowDir(tb2Dir.AsInteger);
  tbFiles.GotoCurrent(tb2);
  Show;
  Data.SetFocus;
End;

Procedure TDbForm.RemoveFile(No: Integer);
Begin
  If Not tb2.FindKey([No]) Then SysUtils.Abort;
  tb2.Delete;
  tbFiles.Refresh;
End;


procedure TDbForm.DataDblClick(Sender: TObject);
begin
  AddItem;
end;

Function Select(Owner: TTreeNode; No: Integer): TTreeNode;
Var
  i: Integer;
Begin
  For i:=Owner.Count-1 DownTo 0 Do
   Begin
    Result:=Owner[i];
    If Integer(Result.Data)=No Then
      Exit;
   End;
  SysUtils.Abort;
End;

Procedure TDbForm.ShowDir(No: Integer);
 Function Find(No: Integer): TTreeNode;
 Begin
   If No=Integer(Tree.Items[0].Data) Then
    Begin
     Result:=Tree.Items[0];
     Exit;
    End;
   If Not tbDir.FindKey([No]) Then SysUtils.Abort; {Не нашел}
   Result:=Find(tbDir.FieldByName('Parent').AsInteger);
   Result.Expand(False);
   Result:=Select(Result, No);
 End;
Begin
  tbDir.IndexName:='';
  Find(No).Selected:=True;
End;

procedure TDbForm.Del(Sender: TObject);
begin
  If Tree.Focused Then
    DelTree(Nil)
  Else
    DelFile(Nil)
end;

procedure TDbForm.Ins(Sender: TObject);
begin
  If Tree.Focused Then
    NewDir(Nil)
  Else
    NewFile(Nil)
end;

procedure TDbForm.Props(Sender: TObject);
begin
  If Tree.Focused Then
    pTree(Nil)
  Else
    pFile(Nil)
end;

procedure TDbForm.TreeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  RefreshNode(Node, True);
end;

procedure TDbForm.DoCut(Sender: TObject);
Var
  N: TMenuItem Absolute Sender;
  S: String;
begin
  S:='';
  If TMenuItem(Sender).Tag=0 Then
    S:='0*';
  Clipboard.AsText:=S+MakeURL;
end;

Function TDbForm.MakeURL: String;
Begin
  Result:='';
  If tbFiles.RecordCount>0 Then
    Result:=tbFilesNo.AsString+'>'+GetPath(tbFilesNo.AsInteger);
End;

procedure TDbForm.N20Click(Sender: TObject);
begin
  RefreshNode(Tree.Items.GetFirstNode, False);
  Data.Refresh;
end;

procedure TDbForm.FormActivate(Sender: TObject);
begin
  dsFilesDataChange(Nil, Nil);
end;

procedure TDbForm.DataStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  If tbFiles.RecordCount=0 Then SysUtils.Abort;
  DragItem:=TJobItem.Create(Nil);
  DragItem.AsLst:=MakeURL;
end;

procedure TDbForm.DataEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  DragItem.Free;
  DragItem:=Nil;
end;

procedure TDbForm.TreeStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  If Tree.Selected=Tree.Items.GetFirstNode Then
    SysUtils.Abort;
end;

procedure TDbForm.MsDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    TControl(Sender).BeginDrag(False);
end;

Procedure TDbForm.wmDropFiles(Var Msg: TwmDropFiles);
Begin
  DragFinish(Msg.Drop);
End;

procedure TDbForm.DoPaste(Sender: TObject);
Var
  C: TCollection;
begin
  C:=PastedItems;
  While C.Count>0 Do
   Begin
    DragItem:=TJobItem(C.Items[0]);
    DataDragDrop(Nil, Nil, 0, 0);
    If DragItem.Count=0 Then DragItem.RemoveFile;
    DragItem.Free;
    DragItem:=Nil;
   End;
  C.Free;
end;

Procedure TDbForm.InsertGeo(Name: String; Geo: TStream);
Begin
  tbFiles.Insert;
  tbFilesName.AsString:=Name;
  tbFilesDir.AsInteger:=Integer(Tree.Selected.Data);
//    tbDir.FieldByName('No').AsInteger;
  tbFilescDate.AsDateTime:=Now;
  tbFilesmDate.AsDateTime:=Now;
  tbFilesData.LoadFromStream(Geo);
  tbFiles.Post;
  Geo.Free;
End;

procedure TDbForm.NewFile(Sender: TObject);
Var
  S: TMemoryStream;
begin
  If Not KodDlg.Execute Then Exit;
  S:=TMemoryStream.Create;
  S.Position:=0;
  KodDlg.Dbs.Save(S);
  InsertGeo(KodDlg.pName.Text, S);
end;

procedure TDbForm.mDClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  For i:=M.Count-1 DownTo 0 Do
    If M[i].Tag=2 Then M[i].Enabled:=Clipboard.HasFormat(cf_Text)
    Else M[i].Enabled:=tbFiles.RecordCount>0;
end;

procedure TDbForm.mRPopup(Sender: TObject);
Var
  P: TPopupMenu Absolute Sender;
begin
  If P.PopupComponent=Tree Then
    FillPopup(P, mT)
  Else
    FillPopup(P, mD);
end;

procedure TDbForm.mTClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
begin
  M[1].Enabled:=Tree.Selected.AbsoluteIndex>0;
end;

{$IfDef DisableDB}
Initialization
  MessageBox(0, 'Кто-то использует архив геометрии', 'Ищите лучше!', 0);
  {$Error}
{$EndIf}
end.

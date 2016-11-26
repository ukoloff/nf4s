unit SetUp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Db, DBTables, ExtCtrls;

type
  TSetUpDlg = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OkBtn: TButton;
    FirstTab: TTabSheet;
    pSaveMode: TGroupBox;
    cb1: TCheckBox;
    pOutput: TGroupBox;
    GeoBase: TEdit;
    GeoDet: TEdit;
    CreateBtn: TButton;
    dDet: TOpenDialog;
    dBase: TOpenDialog;
    tDet: TTable;
    tDir: TTable;
    tDetNo: TAutoIncField;
    tDetName: TStringField;
    tDetDir: TIntegerField;
    tDetInfo: TMemoField;
    tDetData: TBlobField;
    tDirNo: TAutoIncField;
    tDirName: TStringField;
    tDirParent: TIntegerField;
    tDirInfo: TMemoField;
    tDetmDate: TDateTimeField;
    tDetcDate: TDateTimeField;
    tDircDate: TDateTimeField;
    tDirmDate: TDateTimeField;
    lList: TListView;
    ImageList1: TImageList;
    lUp: TButton;
    lDn: TButton;
    lDel: TButton;
    lEdit: TButton;
    pConfirm: TGroupBox;
    pBtnText: TCheckBox;
    pNestMode: TComboBox;
    Label1: TLabel;
    TabSheet3: TTabSheet;
    lNesters: TListBox;
    Nesters: TNotebook;
    pkNum: TEdit;
    Label3: TLabel;
    pkKol: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    panQuan: TEdit;
    panMirror: TCheckBox;
    panRot: TRadioGroup;
    pDistance: TEdit;
    Label7: TLabel;
    panLDist: TEdit;
    Label2: TLabel;
    procedure GetDos(Sender: TObject);
    procedure BrGeoDet(Sender: TObject);
    procedure BrGeoBase(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
    procedure lUpClick(Sender: TObject);
    procedure lDnClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure lEditClick(Sender: TObject);
    procedure lDoDel(Sender: TObject);
    procedure lListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lSep(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lNestersClick(Sender: TObject);
  private
    L: TStringList;

    Procedure BuildItem(No: Integer);
    procedure BuildList;
    Procedure lMove(iFrom, iTo: Integer);
    procedure Transfer(Sender: TObject);
  public
    Procedure Execute;
  end;

var
  SetUpDlg: TSetUpDlg;

implementation uses
  SirReg, Main, Layouts, LProps;

{$R *.DFM}

Procedure TSetUpDlg.Execute;
Begin
  ActiveControl:=Nil;
  GeoDet.Text:=SirRegistry.Global[gnGeoDet];
  GeoBase.Text:=SirRegistry.Global[gnGeoBase];
  Params.OnData:=Transfer;
  Params.SetData(Self);
  L:=TStringList.Create;
  L.Assign(fLayout);
  BuildList;
  If ShowModal=mrOk Then
   Begin
    fLayout.Free;
    fLayout:=L;
    L:=Nil;
    SirRegistry.Global[gnGeoDet]:=GeoDet.Text;
    SirRegistry.Global[gnGeoBase]:=GeoBase.Text;
    Params.GetData(Self);
   End;
  lList.Items.Clear;
  L.Free;
End;

procedure TSetUpDlg.GetDos(Sender: TObject);
begin
  GeoDet.Text:=DosGeoDet;
end;

procedure TSetUpDlg.BrGeoDet(Sender: TObject);
begin
  dDet.InitialDir:=GeoDet.Text;
  If dDet.Execute Then
    GeoDet.Text:=ExtractFileDir(dDet.FileName);
end;

procedure TSetUpDlg.BrGeoBase(Sender: TObject);
begin
  dBase.InitialDir:=GeoBase.Text;
  If dBase.Execute Then
    GeoBase.Text:=ExtractFileDir(dBase.FileName);

end;

procedure TSetUpDlg.CreateBtnClick(Sender: TObject);
 Procedure Check(T: TTable);
 Var
   S: String;
 Begin
   S:=T.DataBaseName;
   If(Length(S)<>0)And(S[Length(S)]<>'\')And(S[Length(S)]<>'/')Then
     S:=S+'\';
   S:=S+T.TableName;
   If FileExists(S) Then
    Begin
     Application.MessageBox(PChar('���� "'+S+'" ����������!'),
       PChar(Application.Title),
       mb_IconStop);
     Abort;
    End;
   T.CreateTable;
   T.AddIndex('', 'No', [ixPrimary]);
 End;
begin
  tDet.DataBaseName:=GeoBase.Text;
  tDir.DataBaseName:=GeoBase.Text;
  Try
    Check(tDet);
    tDet.AddIndex('iName', 'Dir;Name', [ixCaseInsensitive]);
    Check(tDir);
    tDir.AddIndex('iName', 'Parent;Name', [ixCaseInsensitive]);
    tDir.AddIndex('iDate', 'Parent;mDate', [ixCaseInsensitive]);
    tDir.Open;
    tDir.Insert;
    tDirName.AsString:='GeoBase';
    tDirmDate.AsDateTime:=Now;
    tDircDate.AsDateTime:=Now;
    tDir.Post;
  Finally
    tDet.Close;
    tDir.Close;
  End;
end;

procedure TSetUpDlg.Transfer(Sender: TObject);
begin
  Params.StdData(Sender);
  If Sender=panRot Then
    If Params.Writing Then
      panRot.ItemIndex:=Params.Obj[Sender].AsInteger
    Else
      Params.Obj[Sender].AsInteger:=panRot.ItemIndex
  Else
    Params.CheckBoxGroup(Sender);
  If Sender is TCustomCheckBox Then
    If Params.Writing Then
      TCheckBox(Sender).Checked:=Params.Obj[Sender].AsBoolean
    Else
      Params.Obj[Sender].AsBoolean:=TCheckBox(Sender).Checked;
  If Sender=pBtnText Then
    If Params.Writing Then
      pBtnText.Checked:=Params.Obj[Sender].AsBoolean
    Else
      Params.Obj[Sender].AsBoolean:=pBtnText.Checked;
  If Sender=pNestMode Then
    If Params.Writing Then
      pNestMode.ItemIndex:=Params.Obj[Sender].AsInteger
    Else
      Params.Obj[Sender].AsInteger:=pNestMode.ItemIndex;
(***************************************************
  If Sender=pStart Then
    If Params.Writing Then
      pStart.ItemIndex:=Params.Obj[Sender].AsInteger
    Else
      Params.Obj[Sender].AsInteger:=pStart.ItemIndex;
***************************************************)
end;

Procedure TSetUpDlg.BuildItem(No: Integer);
Var
  X: TStringList;
  LL: TListItem;
Begin
  LL:=lList.Items.Insert(No);
  If L.Objects[No]=Nil Then
   Begin
    LL.Caption:='�����������';
    LL.ImageIndex:=1;
    Exit
   End;
  X:=TStringList.Create;
  X.CommaText:=L[No];
  LL.Caption:=X[1];
  X.Free;
  If Char(L.Objects[No])>='a' Then LL.ImageIndex:=2;
End;

procedure TSetUpDlg.BuildList;
Var
  i: Integer;
begin
  lList.Items.Clear;
  For i:=0 To L.Count-1 Do
    BuildItem(i);
  If L.Count>0 Then
    lList.Items[0].Focused:=True;
end;

Procedure TSetUpDlg.lMove(iFrom, iTo: Integer);
Begin
  If iFrom=iTo Then Exit;
  lList.ItemFocused:=Nil;
  lList.Selected:=Nil;
  L.Move(iFrom, iTo);
  lList.Items[iFrom].Free;
  BuildItem(iTo);
  lList.Items[iTo].Focused:=True;
End;

procedure TSetUpDlg.lUpClick(Sender: TObject);
begin
  If(lList.ItemFocused<>Nil)And(lList.ItemFocused.Index>0)Then
    lMove(lList.ItemFocused.Index, lList.ItemFocused.Index-1);
end;

procedure TSetUpDlg.lDnClick(Sender: TObject);
begin
  If(lList.ItemFocused<>Nil)And(lList.ItemFocused.Index<lList.Items.Count-1)Then
    lMove(lList.ItemFocused.Index, lList.ItemFocused.Index+1);
end;

procedure TSetUpDlg.Button4Click(Sender: TObject);
Var
  i: Integer;
begin
  LProps.LEdit.New;
  If Not LProps.LEdit.Execute Then Exit;
  For i:=Ord('a')To Ord('z')Do
    If(L.IndexOfObject(Pointer(i))<0)And
      (L.IndexOfObject(Pointer(UpCase(Chr(i))))<0) Then Break;
  L.AddObject(LProps.LEdit.Layout, Pointer(UpCase(Chr(i))));
  BuildItem(lList.Items.Count);
  lList.Items[lList.Items.Count-1].Focused:=True;
end;

procedure TSetUpDlg.lEditClick(Sender: TObject);
Var
  i, j: Integer;
begin
  If lList.ItemFocused=Nil Then Exit;
  i:=lList.ItemFocused.Index;
  If L.Objects[i]=Nil Then Exit;
  LProps.LEdit.Layout:=L[i];
  LProps.LEdit.IsStart:=Char(L.Objects[i])>='a';
  If Not LProps.LEdit.Execute Then Exit;
  L[i]:=LProps.LEdit.Layout;
  If LProps.LEdit.IsStart Then
   Begin
    L.Objects[i]:=Pointer(Ord(UpCase(Char(L.Objects[i])))+
      (Ord('a')-Ord('A')));
    For j:=L.Count-1 DownTo 0 Do
      If(i<>j)And(L.Objects[j]<>Nil)Then
        L.Objects[j]:=Pointer(UpCase(Char(L.Objects[j])));
   End;
  BuildList;
  lList.Items[i].Focused:=True;
end;

procedure TSetUpDlg.lDoDel(Sender: TObject);
Var
  i: Integer;
begin
  If lList.ItemFocused=Nil Then Exit;
  i:=lList.ItemFocused.Index;
  lList.ItemFocused.Free;
  L.Delete(i);
  If i>=lList.Items.Count Then Dec(i);
  If i>0 Then lList.Items[i].Selected:=True;
end;

procedure TSetUpDlg.lListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=Source=Sender
end;

procedure TSetUpDlg.lListDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  If(lList.ItemFocused<>Nil)And(lList.DropTarget<>Nil)Then
    lMove(lList.ItemFocused.Index, lList.DropTarget.Index);
end;

procedure TSetUpDlg.lSep(Sender: TObject);
Var
  i: Integer;
begin
  i:=lList.Items.Count;
  If lList.ItemFocused<>Nil Then
    i:=lList.ItemFocused.Index+1;
  L.Insert(i, '');
  BuildItem(i);
  lList.Items[i].Focused:=True;
//  lList.SetFocus;
end;

procedure TSetUpDlg.FormCreate(Sender: TObject);
begin
  FirstTab.PageControl.ActivePage:=FirstTab;
  lNesters.ItemIndex:=0;
  lNestersClick(Nil);
end;

procedure TSetUpDlg.lNestersClick(Sender: TObject);
begin
  Nesters.ActivePage:=Nesters.Pages[lNesters.ItemIndex];
end;

end.

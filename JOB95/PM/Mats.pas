unit Mats;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids, DBGrids, DB, DBTables, Menus;

type
  TMatFrm = class(TForm)
    Groups: TTreeView;
    Grp: TTable;
    dsGrp: TDataSource;
    DBGrid1: TDBGrid;
    Mtr: TTable;
    dsMtr: TDataSource;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    GrpNo: TAutoIncField;
    GrpParent: TIntegerField;
    GrpName: TStringField;
    GrpS: TTable;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    MainMenu1: TMainMenu;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure GroupsEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupsEnter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure GroupsExit(Sender: TObject);
    procedure GrpAfterInsert(DataSet: TDataSet);
    procedure GroupsChange(Sender: TObject; Node: TTreeNode);
    procedure N2Click(Sender: TObject);
    procedure GroupsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure GrpAfterEdit(DataSet: TDataSet);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    FBrowse: Integer;

    Procedure Browse(PNo: Integer);
    Procedure Expand(Node: TTreeNode);
    Procedure EditNode;
    Procedure FindGroup(Node: TTreeNode);
  public
    Procedure Refresh;
  end;

var
  MatFrm: TMatFrm;

implementation uses
  CommCtrl,
  Main;

{$R *.DFM}

Var
  FUpdating: Boolean;

procedure TMatFrm.GroupsEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  FUpdating:=True;
  Try
    Grp.Edit;
    GrpName.AsString:=S;
    Grp.Post;
  Finally
    FUpdating:=False;
  End;
end;

procedure TMatFrm.FormResize(Sender: TObject);
begin
  Groups.Width:=ClientWidth Div 2;
end;

Procedure TMatFrm.Browse(PNo: Integer);
Begin
  FBrowse:=PNo;
  Grp.SetRange([PNo], [PNo]);
End;

procedure TMatFrm.FormCreate(Sender: TObject);
begin
  FormResize(Nil);
  Browse(0);
  Expand(Nil);
end;

procedure TMatFrm.GroupsEnter(Sender: TObject);
begin
  MainFrm.Navigator.DataSource:=dsGrp;
end;

procedure TMatFrm.DBGrid1Enter(Sender: TObject);
begin
  MainFrm.Navigator.DataSource:=dsMtr;
end;

procedure TMatFrm.GroupsExit(Sender: TObject);
begin
  MainFrm.Navigator.DataSource:=Nil;
end;

procedure TMatFrm.GrpAfterInsert(DataSet: TDataSet);
begin
  GrpName.AsString:='����� ������';
  GrpParent.AsInteger:=FBrowse;
  Grp.Post;
  EditNode;
end;

procedure TMatFrm.GroupsChange(Sender: TObject; Node: TTreeNode);
begin
  FindGroup(Node);
  Browse(GrpS.FieldByName('Parent').AsInteger);
  Grp.GotoCurrent(GrpS);
end;

procedure TMatFrm.N2Click(Sender: TObject);
begin
  Browse(GrpNo.AsInteger);
  Grp.Insert;
end;

Procedure TMatFrm.FindGroup(Node: TTreeNode);
Begin
  GrpS.IndexName:='';
  GrpS.FindKey([Integer(Node.Data)]);
End;

Procedure TMatFrm.Expand(Node: TTreeNode);
Var
  i: Integer;
Begin
  i:=0;
  If Node<>Nil Then
   Begin
    If Node.Count>0 Then Exit;
    i:=Integer(Node.Data);
   End;
  GrpS.IndexName:='iDir';
  GrpS.SetRange([i], [i]);
  GrpS.Last;
  While Not GrpS.BOF Do
   Begin
    With Groups.Items.AddChildFirst(Node,
      GrpS.FieldByName('Name').AsString) Do
     Begin
      Data:=Pointer(GrpS.FieldByName('No').AsInteger);
      SelectedIndex:=1;
      HasChildren:=True;
     End;
    GrpS.Prior;
   End;
  If(Node<>Nil)And(Node.Count=0)Then
    Node.HasChildren:=False;
End;

procedure TMatFrm.GroupsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  Expand(Node);
end;

Procedure TMatFrm.Refresh;
Begin
// !!!
// !!! �������� ������ �����
// !!!
  Mtr.Refresh;
End;

procedure TMatFrm.GrpAfterEdit(DataSet: TDataSet);
begin
  If FUpdating Then Exit;
  Grp.Cancel;
  EditNode;
end;

Procedure TMatFrm.EditNode;
Begin
  Groups.SetFocus;
  If Groups.Selected<>Nil Then
//    Groups.Perform(TVM_EditLabel, 0, Groups.Selected.Handle);
    TreeView_EditLabel(Groups.Handle, Groups.Selected.ItemId);
End;

procedure TMatFrm.N1Click(Sender: TObject);
begin
  EditNode
end;

procedure TMatFrm.N4Click(Sender: TObject);
begin
  Groups.FullExpand;
end;

procedure TMatFrm.N5Click(Sender: TObject);
begin
  Groups.FullCollapse;
end;

end.

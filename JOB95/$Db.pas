unit Db;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Menus, Grids, DBGrids, ComCtrls, ExtCtrls;

type
  TDbForm = class(TForm)
    Table1: TTable;
    MainMenu1: TMainMenu;
    Two1: TMenuItem;
    A1: TMenuItem;
    b1: TMenuItem;
    DataSource1: TDataSource;
    Data: TDBGrid;
    Split: TSplitter;
    Tree: TTreeView;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MsMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DataDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SplitMoved(Sender: TObject);
    procedure TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Two1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
  private
    FW: Integer;
  public
    { Public declarations }
  end;

var
  DbForm: TDbForm;

implementation

{$R *.DFM}

Type
  TG=Class(TDbGrid)
  Public
    Property OnMouseDown;
  End;

procedure TDbForm.FormCreate(Sender: TObject);
begin
  TG(Data).OnMouseMove:=MsMove;
  SplitMoved(Nil);
  Tree.FullExpand;
  Tree.FullCollapse;
end;

procedure TDbForm.MsMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If ssLeft In Shift Then
    TControl(Sender).BeginDrag(False);
end;

procedure TDbForm.DataDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=True//Sender=Source
end;


procedure TDbForm.SplitMoved(Sender: TObject);
begin
  Data.Columns[0].Width:=Data.ClientWidth;
end;

procedure TDbForm.TreeDragDrop(Sender, Source: TObject; X, Y: Integer);
Var
  i: TTreeNode;
begin
  i:=Tree.DropTarget;
  If i<>Nil Then
    i.Selected:=True
end;

procedure TDbForm.TreeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=True//TTreeView(Sender).DropTarget<>Nil
end;

procedure TDbForm.Two1Click(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  M[0].Checked:=Tree.Visible;
  For i:=M.Count-1 DownTo 1 Do
    M[i].Enabled:=M[0].Checked;
end;

procedure TDbForm.A1Click(Sender: TObject);
begin
  If Tree.Visible Then
   Begin
    Tree.Visible:=False;
    Split.Visible:=False;
    FW:=Data.Width;
    Data.Align:=alClient;
   End
  Else
   Begin
    Data.Align:=alRight;
    Data.Width:=FW;
    Split.Left:=-1;
    Split.Visible:=True;
    Tree.Visible:=True;
   End;
  SplitMoved(Nil);
end;

end.

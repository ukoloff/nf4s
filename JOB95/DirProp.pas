unit DirProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Mask, Db, DBTables;

type
  TDbDirProp = class(TForm)
    eName: TDBEdit;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    OkBtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  end;

var
  DbDirProp: TDbDirProp;

Function EditDbDir: Boolean;

implementation uses
  Dbf;

{$R *.DFM}

Function EditDbDir: Boolean;
Begin
  If DbDirProp=Nil Then
    DbDirProp:=TDbDirProp.Create(Nil);
  DbDirProp.ActiveControl:=Nil;  
  Result:=DbDirProp.ShowModal=idOk;
End;

procedure TDbDirProp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  eName.DataSource.DataSet.Cancel;
end;

procedure TDbDirProp.OkBtnClick(Sender: TObject);
begin
  eName.DataSource.DataSet.FieldByName('mDate').AsDateTime:=Now;
  eName.DataSource.DataSet.Post;
  ModalResult:=idOk;
end;

end.

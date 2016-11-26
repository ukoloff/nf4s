unit DbPropD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Mask;

type
  TDbProp = class(TForm)
    DBEdit1: TDBEdit;
    Memo: TDBMemo;
    OkBtn: TButton;
    DBEdit2: TDBEdit;
    procedure OkBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DbProp: TDbProp;

implementation

uses Dbf;

{$R *.DFM}

procedure TDbProp.OkBtnClick(Sender: TObject);
begin
  DbForm.tbFilesmDate.AsDateTime:=Now;
  Memo.DataSource.DataSet.Post;
  Close
end;

procedure TDbProp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Memo.DataSource.DataSet.Cancel
end;

end.

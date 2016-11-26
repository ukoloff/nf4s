unit JbProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Struc, StdCtrls, ComCtrls;

type
  TJobProp = class(TForm)
    OkBtn: TButton;
    tCnt: TEdit;
    Cnt: TUpDown;
    cbList: TCheckBox;
    Label1: TLabel;
    Path: TEdit;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure Execute(J: TJobItem);
  end;

var
  JobProp: TJobProp;

implementation

{$R *.DFM}
Procedure TJobProp.Execute(J: TJobItem);
Begin
  If J=Nil Then Exit;
  ActiveControl:=Nil;
  Path.Text:=J.Path;
  Cnt.Position:=J.Count;
  cbList.Checked:=J.List;
  If ShowModal<>mrOk Then Exit;
  J.Count:=Cnt.Position;
  J.List:=cbList.Checked;
End;

procedure TJobProp.FormActivate(Sender: TObject);
begin
  tCnt.SelectAll;
end;

end.

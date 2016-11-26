unit CntDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons;

type
  TCountDialog = class(TForm)
    Count: TSpinEdit;
    List: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Directory: TLabel;
    Name: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CountDialog: TCountDialog;

implementation

{$R *.DFM}

procedure TCountDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#27 Then
    Close;
end;

end.

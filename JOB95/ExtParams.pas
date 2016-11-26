unit ExtParams;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TExtPrmDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Notebook1: TNotebook;
    CapLabel: TLabel;
  private
    { Private declarations }
  public
    Procedure Execute(Idx: Integer; Capt: String);
  end;

var
  ExtPrmDlg: TExtPrmDlg;

implementation

{$R *.DFM}

Procedure TExtPrmDlg.Execute(Idx: Integer; Capt: String);
Begin
  CapLabel.Caption:=Capt;
  ShowModal;
End;

end.

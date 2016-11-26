unit crackfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    eIn: TEdit;
    eOut: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure eInChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Implementation uses
  ClipBrd,
  ReForm;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
end;

procedure TForm1.eInChange(Sender: TObject);
begin
  eOut.Text:=CalcRegInfo(eIn.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Clipboard.AsText:=eOut.Text;
end;

end.

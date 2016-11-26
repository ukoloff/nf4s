unit About;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TAboutDialog = class(TForm)
    Img: TImage;
    Btn: TButton;
    eMail: TLabel;
    WWW: TLabel;
    P: TPanel;
    ProgName: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure P3Resize(Sender: TObject);
    procedure eMailClick(Sender: TObject);
    procedure WWWClick(Sender: TObject);
    procedure PResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDialog: TAboutDialog;

Implementation uses
  ShellApi;

{$R *.DFM}

procedure TAboutDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Close
end;

procedure TAboutDialog.FormResize(Sender: TObject);
begin
  Img.Width:=Img.Height*Img.Picture.Width Div Img.Picture.Height
end;

procedure TAboutDialog.FormCreate(Sender: TObject);
begin
  Btn.Align:=alTop;
  eMail.Font.Style:=[fsUnderline];
  WWW.Font.Style:=[fsUnderline];
  ProgName.Caption:=Application.Title;
end;

procedure TAboutDialog.FormDeactivate(Sender: TObject);
begin
  Close
end;

procedure TAboutDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TAboutDialog.P3Resize(Sender: TObject);
Var
  P: TPanel Absolute Sender;
  i: Integer;
begin
  For i:=P.ControlCount-1 DownTo 0 Do
    With P.Controls[i] Do
     Begin
      Left:=0; Width:=P.ClientWidth;
      Top:=(P.ClientHeight*(2*i+1)Div P.ControlCount - Height)Div 2;
     End;
end;

procedure TAboutDialog.eMailClick(Sender: TObject);
begin
  ShellExecute(0, Nil,
    PChar('mailto:Sirius%20Team%20<'+TLabel(Sender).Caption+'>?subject=MakeJob%2095'),
    Nil, Nil, sw_Show);
end;

procedure TAboutDialog.WWWClick(Sender: TObject);
begin
  ShellExecute(0, Nil, PChar(TLabel(Sender).Caption), Nil, Nil, sw_Show);

end;

procedure TAboutDialog.PResize(Sender: TObject);
begin
  P.ClientHeight:=Btn.Height+2*P.BorderWidth
end;

end.

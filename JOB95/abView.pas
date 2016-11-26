unit abView;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TAboutDialog = class(TForm)
    Img: TImage;
    Panel2: TPanel;
    TopL: TLabel;
    Btn: TButton;
    WWW: TLabel;
    eMail: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure P2Resize(Sender: TObject);
    procedure P3Resize(Sender: TObject);
    procedure eMailClick(Sender: TObject);
    procedure WWWClick(Sender: TObject);
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


procedure TAboutDialog.P2Resize(Sender: TObject);
begin
  Btn.Parent.Height:=Btn.Height+2*Btn.Top;
end;

procedure TAboutDialog.P3Resize(Sender: TObject);
Var
  P: TPanel Absolute Sender;
  i: Integer;
begin
  For i:=P.ControlCount-1 DownTo 0 Do
    P.Controls[i].Height:=(P.ClientHeight-TopL.Top*2)Div P.ControlCount;
end;


procedure TAboutDialog.eMailClick(Sender: TObject);
begin
  ShellExecute(0, Nil,
    PChar('mailto:Sirius%20Team%20<'+TLabel(Sender).Caption+'>?subject=Dbs%20View%2095'),
    Nil, Nil, sw_Show);
end;


procedure TAboutDialog.WWWClick(Sender: TObject);
begin
  ShellExecute(0, Nil,
    PChar(TLabel(Sender).Caption),
    Nil, Nil, sw_Show);
end;

end.

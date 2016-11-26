unit ViewCld;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SpeedBar, Menus,
  WrapDbs, ComCtrls;

type
  TCldForm = class(TForm)
    MainMenu1: TMainMenu;
    SpeedBar1: TSpeedBar;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    dSetup: TPrinterSetupDialog;
    Status: TStatusBar;
    ImageList1: TImageList;
    SpeedbarSection1: TSpeedbarSection;
    SpeedItem1: TSpeedItem;
    SpeedItem2: TSpeedItem;
    dOpen: TOpenDialog;
    procedure DoClose(Sender: TObject);
    procedure DoSetup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MyHint(Sender: TObject);
    procedure ViewPaint(Sender: TObject);
    procedure DoOpen(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
  private
    { Private declarations }
  public
    View: TDbsView;
  end;

var
  CldForm: TCldForm;

implementation

uses About;

{$R *.DFM}

procedure TCldForm.DoClose(Sender: TObject);
begin
  Close
end;

procedure TCldForm.DoSetup(Sender: TObject);
begin
  dSetup.Execute
end;

procedure TCldForm.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  Application.HelpFile:=ChangeFileExt(ParamStr(0), '.HLP');
  Application.OnHint:=MyHint;
  View:=TDbsView.Create(Self);
  View.Parent:=Self;
  View.OnPaint:=ViewPaint;
  dOpen.InitialDir:=GetCurrentDir;
//  View.PopupMenu:=mR
end;

procedure TCldForm.MyHint(Sender: TObject);
begin
  Status.SimpleText:=Application.Hint
end;

procedure TCldForm.ViewPaint(Sender: TObject);
begin
  TDbsView(Sender).DrawCross
end;

procedure TCldForm.DoOpen(Sender: TObject);
begin
  dOpen.Execute;
end;

procedure TCldForm.N15Click(Sender: TObject);
begin
  AboutDialog:=TAboutDialog.Create(Nil);
  AboutDialog.Show//Modal;
end;

procedure TCldForm.N11Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TCldForm.N12Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TCldForm.N13Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

end.

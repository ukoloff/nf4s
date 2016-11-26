unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, DBCtrls;

type
  TMainFrm = class(TForm)
    MainMenu1: TMainMenu;
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
    Navigator: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N10Click(Sender: TObject);
  private
    Procedure wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo); Message wm_GetMinMaxInfo;
    Procedure wmNCHitTest(Var M: TwmNCHitTest); Message wm_NCHitTest;
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation uses
  BDE,
  SirReg, Mats;

{$R *.DFM}

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=Navigator.Height;
  SirRegistry:=TSirReg.Create('PM');
  DbiAddAlias(Nil, 'PacMan', Nil,
    PChar('PATH:'+SirRegistry.ReadString('PATH')),
    False);
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  SirRegistry.Free;
end;

procedure TMainFrm.N2Click(Sender: TObject);
begin
  Close
end;

procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=Application.MessageBox('Завершить работу программы ?',
    PChar(Application.Title), mb_IconQuestion+mb_YesNo)=idYes;
end;

procedure TMainFrm.N10Click(Sender: TObject);
begin
  MatFrm.Show;
end;

Procedure TMainFrm.wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo);
Begin
  Inherited;
  If SirRegistry=Nil Then Exit;
  M.MinMaxInfo^.ptMinTrackSize.Y:=Height;
  M.MinMaxInfo^.ptMaxTrackSize.Y:=Height;
End;

Procedure TMainFrm.wmNCHitTest(Var M: TwmNCHitTest);
Begin
  Inherited;
  Case M.Result Of
    htTop, htBottom: M.Result:=htCaption;
    htTopLeft, htBottomLeft: M.Result:=htLeft;
    htTopRight, htBottomRight: M.Result:=htRight;
  End{Case}
End;

end.

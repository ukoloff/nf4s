unit Main;

Interface uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ToolWin, ComCtrls, StdCtrls,
  SirReg, ExtCtrls, SpeedBar{, ImgList};

type
  TMainForm = class(TForm)
    mMain: TMainMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    Status: TLabel;
    N7: TMenuItem;
    N9: TMenuItem;
    N16: TMenuItem;
    iList: TImageList;
    OpenDlg: TOpenDialog;
    N4: TMenuItem;
    mMRU: TMenuItem;
    Tools: TSpeedBar;
    SpeedbarSection1: TSpeedbarSection;
    SpeedbarSection2: TSpeedbarSection;
    SpeedbarSection3: TSpeedbarSection;
    SpeedbarSection4: TSpeedbarSection;
    SpeedbarSection5: TSpeedbarSection;
    SpeedbarSection6: TSpeedbarSection;
    N1: TMenuItem;
    N15: TMenuItem;
    menuX: TMenuItem;
    N5: TMenuItem;
    SpeedItem1: TSpeedItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MyHint(Sender: TObject);
    procedure DoClose(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoHelp(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure DoHelpUsage(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure DoNew(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure ActiveForm(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FilesKod(Sender: TObject);
    procedure ViewFit(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DoSetup(Sender: TObject);
    procedure EscClick(Sender: TObject);
    procedure DoOpen(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure DoSave(Sender: TObject);
    procedure Folder(Sender: TObject);
    procedure MruClick(Sender: TObject);
    procedure DbAdd(Sender: TObject);
    procedure fDel(Sender: TObject);
    procedure jDel(Sender: TObject);
    procedure jProps(Sender: TObject);
    procedure aProps(Sender: TObject);
    procedure ZoomIn(Sender: TObject);
    procedure ZoomOut(Sender: TObject);
    procedure AddFile(Sender: TObject);
    procedure menuXClick(Sender: TObject);
    procedure DoReg(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    LastWnd: TForm;
    BtnSize: TSize;

    Procedure wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo); Message wm_GetMinMaxInfo;
    Procedure wmNCHitTest(Var M: TwmNCHitTest); Message wm_NCHitTest;
    Procedure SetCaptions;
    Procedure SetToolBar(aTag: Integer);
    Procedure RepositionToolbar;
  public
    Hist: THistory;

    Procedure Open(S: String);
    Procedure LayOut(Const S: String);
  end;

var
  MainForm: TMainForm;
  Params: TParamList;

Procedure CheckDisplayDepth;

Implementation uses
  ShellApi,
  Files, Job, View,
{$IfDef DisableDB}
  DbfNil,
{$Else}
  Dbf,
{$EndIf}
  SirMath,
  About, SetUp, Layouts, TxtFrm;

{$R *.DFM}

Function IsRegistered: Integer; stdcall; External {$L Reg\SirReg.OBJ};

Procedure CheckRegistration;
Begin
//  If RegInfoValid Then Exit;
  If IsRegistered<>0 Then Exit;
  Application.MessageBox(
    'Эта команда не работает в незарегистрированной версии программы...',
    'Требуется регистрация',
    mb_IconStop);
  Abort; 
End;

Procedure CheckDisplayDepth;
Var
  h: HDC;
  i: Integer;
begin
  h:=GetDC(0);
  i:=GetDeviceCaps(h, BitsPixel)*GetDeviceCaps(h, Planes);
  ReleaseDC(0, h);
  If i>4 Then Exit;
  Application.MessageBox('Программа не может работать'^M
                        +'в 16-цветном режиме экрана!',
    PChar(Application.Title), mb_IconStop);
  Halt;  
End;

Procedure TMainForm.RepositionToolbar;
Var
  i, j, X: Integer;
Begin
  Tools.Height:=Tools.BtnHeight+2*Tools.BtnOffsetVert;
  X:=0;
  For i:=0 To Tools.SectionCount-1 Do
   Begin
    For j:=0 To Tools.Sections[i].Count-1 Do
      With Tools.Items(i, j) Do
        If Visible Then
         Begin
          If j=0 Then Inc(X, Tools.BtnOffsetHorz);
          Left:=X;
          Top:=Tools.BtnOffsetVert;
          Inc(X, Tools.BtnWidth);
         End;
   End;
  Height:=0;
End;

Procedure TMainForm.SetCaptions;
Var
  i, j: Integer;
  DC: HDC;
  Sz, Sz1: TSize;
  Value: Boolean;
Begin
  Value:=Params[1].AsBoolean;
  If Value Then
   Begin
    DC:=GetDC(0);
    SelectObject(DC, Tools.Font.Handle);
   End;
  Sz.cx:=0; Sz.cy:=0;
  For i:=Tools.SectionCount-1 DownTo 0 Do
    For j:=Tools.Sections[i].Count-1 DownTo 0 Do
      With Tools.Items(i, j) Do
        If Value Then
         Begin
          BtnCaption:=Caption;
          GetTextExtentPoint32(DC, PChar(Caption), Length(Caption), Sz1);
          If Sz1.cx>Sz.cx Then Sz.cx:=Sz1.cx;
          If Sz1.cy>Sz.cy Then Sz.cy:=Sz1.cy;
         End
        Else
          BtnCaption:='';
  If Value Then
    ReleaseDC(0, DC);
  Tools.BtnWidth:=Sz.cx+BtnSize.cx;
  Tools.BtnHeight:=Sz.cy+BtnSize.cy;
  RepositionToolbar;
End;

Procedure TMainForm.SetToolBar(aTag: Integer);
Var
  i, j: Integer;
  Vis: Boolean;
Begin
  For i:=Tools.SectionCount-1 DownTo 0 Do
   Begin
    Vis:=(Tools.Sections[i].Tag=0)Or(i=aTag);
    For j:=Tools.Sections[i].Count-1 DownTo 0 Do
      Tools.Items(i,j).Visible:=Vis;
   End;
  RepositionToolbar;
End;

Procedure TMainForm.wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo);
Begin
  Inherited;
  If(Tools=Nil)Or(Status=Nil)Then Exit;
  M.MinMaxInfo^.ptMinTrackSize.Y:=Height-ClientHeight+Tools.Height+Status.Height;
  M.MinMaxInfo^.ptMaxTrackSize.Y:=M.MinMaxInfo^.ptMinTrackSize.Y;
End;

Procedure TMainForm.wmNCHitTest(Var M: TwmNCHitTest);
Begin
  Inherited;
  Case M.Result Of
    htTop, htBottom: M.Result:=htCaption;
    htTopLeft, htBottomLeft: M.Result:=htLeft;
    htTopRight, htBottomRight: M.Result:=htRight;
  End{Case}
End;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  Application.HelpFile:=ChangeFileExt(ParamStr(0), '.HLP');
  BtnSize.cx:=Tools.BtnWidth;
  BtnSize.cy:=Tools.BtnHeight;
  SetToolBar(0);
  Screen.OnActiveFormChange:=ActiveForm;
  SirRegistry:=TSirReg.Create('Make Job');

//  RegInfo:=SirRegistry.ReadString('Reg');

  Hist:=THistory.Create('MRU');
  Hist.OnClick:=MruClick;
  Hist.Menu:=mMRU;

  Params:=TParamList.Create('.Start;.BtnText;Hints=1;'+
    'Output=1;Distance=5;.SaveMode;.Confirm=3;'+
//параметры алгоритмов раскроя - будут удалены
    '.NestMode;anLDist=5.0;anQuan=1.0;.anRot;anMirror=1;'+
    'kNum=3;kKol=2'
    );
  Params.Load('');
//***********************************************
//  Tools.ShowCaptions:=Params[1].AsBoolean; //SirRegistry.ReadBool('BtnText');
//  Application.ShowHint:=Params[2].AsBoolean; //Not SirRegistry.ReadBool('Hints');
  SetCaptions;
  
  Application.OnHint:=MyHint;
//  Left:=0; Top:=0; Width:=Screen.Width;
//  Realign;
  OpenDlg.InitialDir:=GetCurrentDir;

  DefaultLayout;
  LoadLayouts;
  MakeSubMenu(menuX);
end;

procedure TMainForm.MyHint(Sender: TObject);
begin
  Status.Caption:=Application.Hint;
  Status.Update;
end;

//Function IsRegistered: Integer; stdcall; External {$L SirReg};

procedure TMainForm.DoClose(Sender: TObject);
begin
//  IsRegistered;
  Close;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=JobForm.CheckSave
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  i: Integer;
begin
  Application.HelpCommand(Help_Quit, 0);
//****************************************  
//  Params[1].AsBoolean:=Tools.ShowCaptions;
  Params[2].AsBoolean:=Application.ShowHint;
//  SirRegistry.WriteBool('BtnText', Tools.ShowCaptions);
//  SirRegistry.WriteBool('Hints', Not Application.ShowHint);
  For i:=Screen.FormCount-1 DownTo 0 Do
    If Screen.Forms[i]<>Self Then
      Screen.Forms[i].Free;
  Params.Store;
  Hist.Free;
  SaveLayouts;
//  SirRegistry.WriteString('Reg', RegInfo);
  SirRegistry.Free;
end;

procedure TMainForm.DoHelp(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TMainForm.N5Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TMainForm.DoHelpUsage(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
  FilesForm.Show;
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
  JobForm.Show
end;

procedure TMainForm.N2Click(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i, j: Integer;
begin
  M[0].Enabled:=Screen.FormCount>2;
  M[1].Enabled:=M[0].Enabled;
  For i:=Screen.FormCount-1 DownTo 0 Do
    If Screen.Forms[i].Tag>0 Then
      For j:=M.Count-1 DownTo 0 Do
        If M[j].Tag=Screen.Forms[i].Tag Then
          M[j].Checked:=Screen.Forms[i].Visible
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
  ViewForm.Show
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
{$IfDef DisableDB}
  TMenuItem(Sender).Enabled:=False;
{$EndIf}
  DbForm.Show
end;

procedure TMainForm.DoNew(Sender: TObject);
begin
  If JobForm.CheckSave Then
    JobForm.Clear;
end;

procedure TMainForm.N28Click(Sender: TObject);
begin
//*********************************************
//  Tools.ShowCaptions:=Not Tools.ShowCaptions;
//  Height:=1;
end;

procedure TMainForm.N29Click(Sender: TObject);
begin
  Application.ShowHint:=Not Application.ShowHint
end;

procedure TMainForm.N8Click(Sender: TObject);
begin
  AboutDialog:=TAboutDialog.Create(Nil);
  AboutDialog.Show//Modal;
//  AboutDialog.Free;
end;

procedure TMainForm.ActiveForm(Sender: TObject);
Var
  T: Integer;
begin
  If Screen.ActiveForm=Nil Then Exit;
  T:=Screen.ActiveForm.Tag;
  If T<>0 Then
   Begin
    SetToolBar(T);
    LastWnd:=Screen.ActiveForm;
   End
  Else If(LastWnd=Nil)Or Not LastWnd.Visible Then
    SetToolBar(0);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  Height:=0
end;

procedure TMainForm.FilesKod(Sender: TObject);
begin
  FilesForm.DoKod(Nil)
end;

procedure TMainForm.ViewFit(Sender: TObject);
begin
  ViewForm.ZoomToFit(Nil)
end;

procedure TMainForm.N15Click(Sender: TObject);
Var
  i: Integer;
  F: TForm;
begin
  For i:=0 To Screen.FormCount-1 Do
   Begin
    F:=Screen.Forms[i];
    If(F.Tag<>0)And(F<>LastWnd)And(F.Visible)Then
     Begin
      F.BringToFront;
      Exit;
     End;
   End;
end;

procedure TMainForm.N10Click(Sender: TObject);
Var
  i: Integer;
  F: TForm;
begin
  For i:=Screen.FormCount-1 DownTo 0 Do
   Begin
    F:=Screen.Forms[i];
    If(F.Tag<>0)And(F<>LastWnd)And(F.Visible)Then
     Begin
      F.BringToFront;
      Exit;
     End;
   End;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  OnActivate:=Nil;
//  LayOutN(Params[0].AsInteger);
  LayOut(DefaultLayoutString);
//  StdLayout(Nil);
//  ArcMgr(Nil)
end;

procedure TMainForm.DoSetup(Sender: TObject);
begin
  If SetUpDlg=Nil Then
    SetUpDlg:=TSetUpDlg.Create(Nil);
  SetUpDlg.Execute;
  MakeSubMenu(menuX);
  SetCaptions;
end;

procedure TMainForm.EscClick(Sender: TObject);
begin
  If(LastWnd<>Nil)And(LastWnd.Visible) Then
    LastWnd.Show
end;

procedure TMainForm.DoOpen(Sender: TObject);
begin
//  OpenDlg.InitialDir:='';
  If OpenDlg.Execute Then
    Open(OpenDlg.FileName);
  OpenDlg.InitialDir:='';
end;

procedure TMainForm.N13Click(Sender: TObject);
begin
  CheckRegistration;
  JobForm.SaveDlg.FileName:='';
  JobForm.Save
end;

procedure TMainForm.DoSave(Sender: TObject);
begin
  CheckRegistration;
  JobForm.Save
end;

procedure TMainForm.Folder(Sender: TObject);
begin
  JobForm.Folder(Nil)
end;

procedure TMainForm.MruClick(Sender: TObject);
begin
  Open(PString(Sender)^);
end;

Procedure TMainForm.Open(S: String);
Begin
  JobForm.Load(S);
  Hist.AddPath(S);
End;

procedure TMainForm.DbAdd(Sender: TObject);
begin
{$IfnDef DisableDB}
  DbForm.AddItem;
{$EndIf}
end;

procedure TMainForm.fDel(Sender: TObject);
begin
  FilesForm.DelFile(Nil);
end;

procedure TMainForm.jDel(Sender: TObject);
begin
  JobForm.DoDel(Nil);
end;

procedure TMainForm.jProps(Sender: TObject);
begin
  JobForm.Props(Nil);
end;

procedure TMainForm.aProps(Sender: TObject);
begin
{$IfnDef DisableDB}
  DbForm.Props(Nil)
{$EndIf}
end;

procedure TMainForm.ZoomIn(Sender: TObject);
begin
  ViewForm.Zoom(0.5);
end;

procedure TMainForm.ZoomOut(Sender: TObject);
begin
  ViewForm.Zoom(2);
end;

Procedure TMainForm.LayOut(Const S: String);
Var
  N, X: String;
  i: Integer;
  F: TForm;
  RR, WA: TRect;
  ARR: Array[0..3]Of Integer Absolute RR;
  C, State: Char;
Begin
// First, place main form
  SystemParametersInfo(spi_GetWorkArea, 0, @WA.w, 0);
  BoundsRect:=WA.w;
  Inc(WA.Top, Height);
// Now WA is place for children
  Dec(WA.Bottom, WA.Top); Dec(WA.Right, WA.Left);

  N:=S;
  While Length(N)>0 Do
   Begin
    i:=Pos(';', N);
    if i<=0 Then i:=1+Length(N);
    X:=Trim(Copy(N, 1, i-1));
    System.Delete(N, 1, i);
    If Length(X)<1 Then Continue;
    Case UpCase(X[1]) Of
     'F': F:=FilesForm;
     'A': F:=DbForm;    
     'J': F:=JobForm;
     'V': F:=ViewForm;
     'T': F:=TextForm;
    Else
      Continue
    End{Case};
    System.Delete(X, 1, 1);
    RR.O.Assign(0,0,100,100);
    i:=Low(Arr); State:=#0;
    While Length(X)>0 Do
     Begin
      C:=X[1];
      System.Delete(X, 1, 1);
      Case C Of
       '0'..'9':
        Begin
         If State<>#1 Then Arr[i]:=0;
         Arr[i]:=Arr[i]*10+Ord(C)-Ord('0');
         State:=#1;
        End;
       ',':
        Begin
         If State<>#2 Then Inc(i);
         State:=#0;
        End;
      Else
        If State<>#1 Then Continue;
        State:=#2;
        Inc(i);
      End{Case};
      If i>High(Arr) Then Break;
     End;

     RR.Top:=WA.Top+WA.Bottom*RR.Top Div 100;
     RR.Bottom:=WA.Top+WA.Bottom*RR.Bottom Div 100;
     RR.Left:=WA.Left+WA.Right*RR.Left Div 100;
     RR.Right:=WA.Left+WA.Right*RR.Right Div 100;
     F.BoundsRect:=RR.W;
     F.Show;
   End;
End;

procedure TMainForm.AddFile(Sender: TObject);
begin
  FilesForm.FilesAdd(Nil);
end;

procedure TMainForm.menuXClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
begin
  If M.Tag<0 Then Exit;
  LayOut(LayoutString(M.Tag))
end;

procedure TMainForm.DoReg(Sender: TObject);
Var
  X: TShellExecuteInfo;
begin
  FillChar(X, SizeOf(X), 0);
  X.cbSize:=SizeOf(X);
//  X.fMask:=
  X.Wnd:=Application.Handle;
  X.lpFile:=PChar(ExtractFileDir(ParamStr(0))+'\Register.EXE');
  X.nShow:=sw_Show;
  ShellExecuteEx(@X);
//  WinExec(PChar(ExtractFileDir(ParamStr(0))+'\Register.EXE'), sw_Show);
//  ShellExecute(Application.Handle, Nil,
//    PChar(ExtractFileDir(ParamStr(0))+'\Register.EXE'),
//    Nil, Nil, sw_Show);
//  If RegForm=Nil Then
//    RegForm:=TRegForm.Create(Nil);
//  RegForm.Execute;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  TextForm.Show;
end;

end.


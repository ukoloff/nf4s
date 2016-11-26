Unit MainFrm;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Menus, ExtCtrls, StdCtrls, ComCtrls;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    ToolBar: TPanel;
    OpenDialog: TOpenDialog;
    FilesItem: TMenuItem;
    JobItem: TMenuItem;
    ViewItem: TMenuItem;
    UpDown1: TUpDown;
    HintLabel: TLabel;
    tbFiles: TPanel;
    tbJob: TPanel;
    tbView: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure DoQuit(Sender: TObject);
    procedure WindowMenu(Sender: TObject);
    procedure JobItemClick(Sender: TObject);
    procedure Standard(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NewJob(Sender: TObject);
    procedure Save(Sender: TObject);
    procedure SaveAs(Sender: TObject);
    procedure Open(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N13Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure JobProperty(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Layout(Sender: TObject);
  private
    fLastWindow: Byte;

    Function GetForm(i: Integer): TForm;
    Function GetPanel(i: Integer): TPanel;
    Procedure SetLastWindow(i: Byte);

    procedure MyHint(Sender: TObject);
    Procedure wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo); Message wm_GetMinMaxInfo;
    Procedure wmNCHitTest(Var M: TwmNCHitTest); Message wm_NCHitTest;
    procedure ActivateChild(Sender: TObject);
    procedure CloseChild(Sender: TObject; var Action: TCloseAction);
  public
    Property LastWindow: Byte Read fLastWindow Write SetLastWindow;
    Property Form[Index: Integer]: TForm Read GetForm;
    Property Panel[Index: Integer]: TPanel Read GetPanel;
  end;

var
  MainForm: TMainForm;

Implementation uses
  JobFrm, viewfrm, FilesFrm,
  SirReg, About;

{$R *.DFM}

Function TMainForm.GetForm(i: Integer): TForm;
Begin
  Case i Of
    1: Result:=FilesForm;
    2: Result:=JobForm;
    3: Result:=ViewForm;
  Else
    Result:=Nil
  End{Case};
End;

Function TMainForm.GetPanel(i: Integer): TPanel;
Begin
  Case i Of
    1: Result:=tbFiles;
    2: Result:=tbJob;
    3: Result:=tbView;
  Else
    Result:=Nil
  End{Case};
End;

Procedure TMainForm.SetLastWindow(i: Byte);
Var
  j: Integer;
Begin
  fLastWindow:=i;
  For j:=1 To 3 Do
    Panel[j].Visible:=i=j;
End;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ClientHeight:=ToolBar.Height;
  Application.OnHint:=MyHint;
  Application.Title:=Caption;
  SirRegistry:=TSirReg.Create('Make Job');
  OpenDialog.InitialDir:=GetCurrentDir;
end;

Procedure TMainForm.wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo);
Begin
  Inherited;
  If JobForm=Nil Then Exit;
  M.MinMaxInfo^.ptMinTrackSize.Y:=Height;
  M.MinMaxInfo^.ptMaxTrackSize.Y:=Height;
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

procedure TMainForm.DoQuit(Sender: TObject);
begin
  Close
end;

procedure TMainForm.MyHint(Sender: TObject);
begin
  HintLabel.Caption:=Application.Hint;
end;

procedure TMainForm.WindowMenu(Sender: TObject);
begin
  FilesItem.Checked:=FilesForm.Visible;
  JobItem.Checked:=JobForm.Visible;
  ViewItem.Checked:=ViewForm.Visible;
end;

procedure TMainForm.JobItemClick(Sender: TObject);
begin
  Form[TMenuItem(Sender).Tag].Show
end;

procedure TMainForm.Standard(Sender: TObject);
Var
  i: Integer;
begin
  i:=LastWindow;
  Top:=0;
  Left:=0;
  Width:=Screen.Width;
  FilesForm.SetBounds(0, Height, Width Div 3, Screen.Height Div 3);
  JobForm.SetBounds(FilesForm.Width, Height, Width-FilesForm.Width, FilesForm.Height);
  ViewForm.SetBounds(0, FilesForm.Top+FilesForm.Height,
                     Width, FilesForm.Height);
  FilesForm.Show;
  JobForm.Show;
  ViewForm.Show;
  If i>0 Then
    Form[i].Show
  Else
    Show;
end;

procedure TMainForm.FormShow(Sender: TObject);
Var
  i: Integer;
begin
   Standard(Nil);
   For i:=1 To 3 Do
    Begin
     Form[i].Tag:=i;
     Form[i].OnActivate:=ActivateChild;
     Form[i].OnClose:=CloseChild;
    End;
end;

procedure TMainForm.NewJob(Sender: TObject);
begin
  If Not JobForm.CanNew Then
    Exit;
  JobForm.Job.Items.Clear;
  JobForm.PathName:='';  
end;

procedure TMainForm.Save(Sender: TObject);
begin
  JobForm.Save;
end;

procedure TMainForm.SaveAs(Sender: TObject);
begin
  JobForm.DoSave(True);
end;

procedure TMainForm.Open(Sender: TObject);
begin
  OpenDialog.FileName:=JobForm.PathName;
  If Not OpenDialog.Execute Then
    Exit;
  JobForm.Load(OpenDialog.FileName);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=JobForm.CanNew
end;

procedure TMainForm.N13Click(Sender: TObject);
Var
  T: Integer;
begin
  T:=LastWindow;
  Repeat
    If TMenuItem(Sender).Tag=-1 Then
     Begin
      Dec(T);
      If T<=0 Then
        T:=3;
     End
    Else
     Begin
      Inc(T);
      If T>3 Then
        T:=1;
     End;
    If T=LastWindow Then
      Exit;
    With Form[T] Do
      If Visible Then
       Begin
        BringToFront;
        Exit
       End;
  Until False;
end;

procedure TMainForm.ActivateChild(Sender: TObject);
Begin
  LastWindow:=TForm(Sender).Tag;
End;

procedure TMainForm.CloseChild(Sender: TObject; var Action: TCloseAction);
Begin
  LastWindow:=0;
End;

procedure TMainForm.SpeedButton7Click(Sender: TObject);
begin
  JobForm.Delete(Nil);
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  FilesForm.AddToJob(Nil);
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  FilesForm.NewGeometry(Nil);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  FilesForm.Delete(Nil);
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  AboutDialog:=TAboutDialog.Create(Nil);
  AboutDialog.ShowModal;
  AboutDialog.Free;
end;

procedure TMainForm.JobProperty(Sender: TObject);
begin
  JobForm.Count(Nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SirRegistry.Free;
end;

procedure TMainForm.Layout(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  R: TRect;
begin
  Form[3-M.Tag].Close;
  R:=Rect(0, 0, Screen.Width, Screen.Height Div 2);
  Left:=0; Top:=0; Width:=R.Right;
  Inc(R.Top, Height); Inc(R.Left, R.Right Div 3);
  ViewForm.SetBounds(R.Left, R.Top, R.Right-R.Left, R.Bottom);
  ViewForm.Show;
  With Form[M.Tag] Do
   Begin
    SetBounds(0, R.Top, R.Left, R.Bottom);
    Show;
   End;
end;

end.




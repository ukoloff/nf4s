unit FilesFrm;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Menus, ExtCtrls;

type
  TFilesForm = class(TForm)
    Files: TFileListBox;
    Label1: TLabel;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    Panel1: TPanel;
    Drives: TDriveComboBox;
    Directories: TDirectoryListBox;
    procedure FilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DragOverDir(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DirectoriesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Delete(Sender: TObject);
    procedure AddToJob(Sender: TObject);
    procedure Info(Sender: TObject);
    procedure NewGeometry(Sender: TObject);
    procedure FilesKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FilesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FilesForm: TFilesForm;

Implementation uses
  ClipBrd,
  viewfrm, SirReg, JobFrm, NewForm;

{$R *.DFM}

procedure TFilesForm.FilesClick(Sender: TObject);
begin
  ViewForm.Load(Files.FileName);
end;

procedure TFilesForm.FormCreate(Sender: TObject);
begin
  FilesForm.Directories.Directory:=SirRegistry.ReadString('Directory');
  Drives.Align:=alBottom;
end;

procedure TFilesForm.DragOverDir(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=Source=JobForm.Job
end;

procedure TFilesForm.DirectoriesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  Directories.Directory:=JobForm.Job.Selected.SubItems[1]
end;

procedure TFilesForm.Delete(Sender: TObject);
begin
  ActiveControl:=Files;
  If(Files.FileName<>'')And
    (Application.MessageBox('Удалить файл с диска?',
       'Подтвердите', mb_IconQuestion+mb_YesNo)=idYes)Then
   Begin
    DeleteFile(Files.FileName);
    Files.Update;
   End;
end;

procedure TFilesForm.AddToJob(Sender: TObject);
begin
  JobForm.AddDbs(Files.FileName);
end;

procedure TFilesForm.Info(Sender: TObject);
begin
  If Files.FileName='' Then
    Exit;
end;

procedure TFilesForm.NewGeometry(Sender: TObject);
begin
  If KodDlg=Nil Then
    KodDlg:=TKodDlg.Create(Nil);
  KodDlg.ActiveControl:=Nil;
  KodDlg.ShowModal;
end;

procedure TFilesForm.FilesKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then
    AddToJob(Nil);
end;

procedure TFilesForm.FormResize(Sender: TObject);
begin
  Files.Width:=ClientWidth Div 2;
end;

procedure TFilesForm.FilesStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  If Files.FileName='' Then Abort
end;

procedure TFilesForm.FormDestroy(Sender: TObject);
begin
  SirRegistry.WriteString('Directory', Directories.Directory);
  If KodDlg<>Nil Then
    KodDlg.Free;
end;

procedure TFilesForm.N1Click(Sender: TObject);
Var
  i: Integer;
begin
  With TMenuItem(Sender) Do
    For i:=Count-2 DownTo 0 Do
      Items[i].Enabled:=Files.FileName<>'';
end;

procedure TFilesForm.N8Click(Sender: TObject);
begin
  Clipboard.AsText:=Files.FileName;
end;

end.

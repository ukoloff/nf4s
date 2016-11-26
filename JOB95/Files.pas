unit Files;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, Menus,
  SirReg, RxNotify;

type
  TFilesForm = class(TForm)
    Hdr: TLabel;
    Files: TFileListBox;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Dirs: TDirectoryListBox;
    Drives: TDriveComboBox;
    MainMenu1: TMainMenu;
    mM: TMenuItem;
    N5: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    mDirs: TMenuItem;
    GEODET1: TMenuItem;
    Monitor: TRxFolderMonitor;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    mR: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FilesChange(Sender: TObject);
    procedure DoKod(Sender: TObject);
    procedure FilesKeyPress(Sender: TObject; var Key: Char);
    procedure FilesAdd(Sender: TObject);
    procedure DelFile(Sender: TObject);
    procedure DirsChange(Sender: TObject);
    procedure OldDir(Sender: TObject);
    procedure GEODET1Click(Sender: TObject);
    procedure MonitorChange(Sender: TObject);
    procedure DoCut(Sender: TObject);
    procedure FilesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FilesEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FilesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FilesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DoPaste(Sender: TObject);
    procedure mMClick(Sender: TObject);
    procedure mRPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    Procedure wmDropFiles(Var Msg: TwmDropFiles); Message wm_DropFiles;
  public
    Hist: THistory;

    Procedure GotoFile(S: String);
    Procedure Reread;
  end;

Function FilesForm: TFilesForm;

Implementation uses
  ShellApi, Clipbrd,
  Struc, View, Kod, Job, Main, DbsProps, TxtFrm;

{$R *.DFM}

var
  FFilesForm: TFilesForm;

Function FilesForm: TFilesForm;
Begin
  If FFilesForm=Nil Then
    FFilesForm:=TFilesForm.Create(Nil);
  Result:=FFilesForm;
End;

procedure TFilesForm.FormCreate(Sender: TObject);
begin
  Drives.Align:=alBottom;
//  Dirs.Directory:=SirRegistry.ReadString('Dir');
  Hist:=THistory.Create('Dirs');
  Hist.OnClick:=OldDir;
  Hist.Menu:=mDirs;
  If Hist.Count>0 Then
    Dirs.Directory:=Hist[0];
  Monitor.FolderName:=Dirs.Directory;
  Monitor.Active:=True;
  DragAcceptFiles(Handle, True);
end;

procedure TFilesForm.FormDestroy(Sender: TObject);
begin
  Hist.Free;
//  SirRegistry.WriteString('Dir', Dirs.Directory);
end;

procedure TFilesForm.FilesChange(Sender: TObject);
begin
  If Active Then
    ViewForm.ViewIt(Files.FileName);
end;

procedure TFilesForm.DoKod(Sender: TObject);
Var
  S: TFileStream;
begin
  If Not KodDlg.Execute Then Exit;
  S:=TFileStream.Create(Dirs.Directory+'\'+KodDlg.pName.Text+'.DBS', fmCreate);
  Try
    KodDlg.Dbs.Save(S);
  Finally
    S.Free;
//    Files.Update;
    Try
//      Files.FileName:=KodDlg.pName.Text+'.DBS';
    Except
    End;
  End;  
end;

procedure TFilesForm.FilesKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then
    FilesAdd(Nil);
end;

procedure TFilesForm.FilesAdd(Sender: TObject);
begin
  JobForm.AddItem(Files.FileName);
end;

Procedure TFilesForm.GotoFile(S: String);
Begin
  Dirs.Directory:=ExtractFileDir(S);
(*
  S:=ExtractFileName(S);
  For i:=1 To Length(S) Do
    Files.Perform(wm_Char, Integer(S[i]), 0);
*)
  Try
    Files.FileName:=S;
  Except
  End;
  Show;
  Files.SetFocus;
End;

{
Function shFileOperation(Var X: TShFileOpStruct): Integer;
  stdcall; external 'Shell32.dll' Name 'SHFileOperation';
{}
procedure TFilesForm.DelFile(Sender: TObject);
Var
  X: TShFileOpStruct;
  N: String;
  i: Integer;
begin
  N:=Files.FileName;
//  N:='D:\Work\Eq\DBS\vaza.dbs';
  If(N='')Then Exit;
  FillChar(X, SizeOf(X), 0);
  X.Wnd:=Application.Handle;
  X.wFunc:=fo_Delete;
  N:=N+#0;       {����� - �� ����, �� ����� �������� �� ������!!!}
  X.pFrom:=@N[1];//PChar(N);
  i:=Params[6].AsInteger;
  If i And 1=0 Then
    X.fFlags:=fof_NoConfirmation;
  If i And 2<>0 Then
    Inc(X.fFlags, fof_AllowUndo);

  ShFileOperation(X);
{
    (Application.MessageBox(PChar('������� ���� "'+Files.FileName
    +'"?'), PChar(Application.Title),
    mb_IconQuestion+mb_YesNo)<>idYes)Then Exit;
  DeleteFile(Files.FileName);
}
end;

procedure TFilesForm.DirsChange(Sender: TObject);
begin
  If Files.Items.Count>0 Then
    Hist.AddPath(Dirs.Directory)
  Else
    Hist.AddPath('');
  Monitor.Active:=False;
  Monitor.FolderName:=Dirs.Directory;
  Monitor.Active:=True;
end;

procedure TFilesForm.OldDir(Sender: TObject);
begin
  Dirs.Directory:=PString(Sender)^;
end;

procedure TFilesForm.GEODET1Click(Sender: TObject);
Var
  S: String;
begin
  S:=SirRegistry.Global[gnGeoDet];
  If S='' Then
    S:=DosGeoDet;
  If S<>'' Then
    Dirs.Directory:=S;
end;

Procedure TFilesForm.Reread;
Var
  Na: String;
  No: Integer;
Begin
  Monitor.Active:=False;
  Na:=ExtractFileName(Files.FileName);
  No:=Files.ItemIndex;
  Files.Update;
  Try
    Files.FileName:=Na;
  Except
    If No>=Files.Items.Count Then
      No:=Files.Items.Count-1;
    If No>=0 Then
     Try
      Files.ItemIndex:=No
     Except
     End;
  End;
  Monitor.Active:=True;
End;

procedure TFilesForm.MonitorChange(Sender: TObject);
begin
  Reread
end;

procedure TFilesForm.DoCut(Sender: TObject);
Var
  S: String;
begin
  S:='';
  If TMenuItem(Sender).Tag=0 Then S:='0*';
  Clipboard.AsText:=S+Files.FileName;
end;

procedure TFilesForm.FilesStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  If Files.FileName='' Then Abort;
  DragItem:=TJobItem.Create(Nil);
  DragItem.AsLst:=Files.FileName;
end;

procedure TFilesForm.FilesEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  DragItem.Free;
  DragItem:=Nil;
end;

procedure TFilesForm.FilesDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=(Sender<>Source)And(DragItem<>Nil);
end;

procedure TFilesForm.FilesDragDrop(Sender, Source: TObject; X, Y: Integer);
Var
  F: String;
  SI: TStream;
  SO: TFileStream;
begin
  If DragItem=Nil Then Exit;
  SI:=DragItem.GetStream;
  If SI=Nil Then Exit;
  F:=Files.Directory;
  If F[Length(F)]<>'\' Then F:=F+'\';
  F:=F+ExtractFileName(DragItem.Path);
  If FileExists(F)And
    (Application.MessageBox(PChar('���� "'+F+'" ����������.'^M+
       '����������?'), '�����������', mb_IconQuestion+mb_YesNo)<>idYes)Then
   Begin
    SI.Free;
    Exit;
   End;
  SO:=TFileStream.Create(F, fmCreate);
  SO.CopyFrom(SI, 0);
  SO.Free;
  SI.Free;
end;

Procedure TFilesForm.wmDropFiles(Var Msg: TwmDropFiles);
Begin
  DragFinish(Msg.Drop);
End;

procedure TFilesForm.DoPaste(Sender: TObject);
Var
  C: TCollection;
begin
  C:=PastedItems;
  While C.Count>0 Do
   Begin
    DragItem:=TJobItem(C.Items[0]);
    FilesDragDrop(Nil, Nil, 0, 0);
    If DragItem.Count=0 Then DragItem.RemoveFile;
    DragItem.Free;
    DragItem:=Nil;
   End;
  C.Free;
end;

procedure TFilesForm.mMClick(Sender: TObject);
Var
  M: TMenuItem Absolute Sender;
  i: Integer;
begin
  For i:=M.Count-1 DownTo 0 Do
    Case M[i].Tag Of
     0,1:M[i].Enabled:=Files.FileName<>'';
     2:M[i].Enabled:=Clipboard.HasFormat(cf_Text);
    End{Case}; 
end;

procedure TFilesForm.mRPopup(Sender: TObject);
begin
  FillPopup(mR, mM);
end;

procedure TFilesForm.N1Click(Sender: TObject);
begin
  If Files.FileName='' Then Exit;
  If PropsDlg=Nil Then
    PropsDlg:=TPropsDlg.Create(Nil);
  PropsDlg.DisplayFromStream(
    TFileStream.Create(Files.FileName, fmOpenRead));
end;

end.

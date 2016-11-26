unit JobFrm;

Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus;

type
  TJobForm = class(TForm)
    Job: TListView;
    Path: TLabel;
    PopupMenu: TPopupMenu;
    pmList: TMenuItem;
    MainMenu: TMainMenu;
    MenuItem: TMenuItem;
    N3: TMenuItem;
    N11: TMenuItem;
    LocalPaste: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure JobDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PopupMenuPopup(Sender: TObject);
    procedure JobMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetDir(Sender: TObject);
    procedure Delete(Sender: TObject);
    procedure JobDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Repos(Sender: TObject);
    procedure Count(Sender: TObject);
    procedure pmListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Procedure SetPathName(Const S: String);
    Function GetPathName: String;

    procedure ParseCmdLine;
    Procedure AddListItem(Const S: String);

    Procedure LoadKOL;
    Procedure LoadLST;
    Procedure LoadJOB;
    Procedure SaveKOL;
    Procedure SaveLST;
    Procedure SaveJOB;
    Procedure SaveDBS;

    Procedure wmDropFiles(Var M: TwmDropFiles); Message wm_DropFiles;
  public
    Modified: Boolean;

    Property PathName: String Read GetPathName Write SetPathName;

    Procedure AddDbs(Const FileName: String);
    Procedure MoveTo(NewPos: Integer);
    Procedure UpdateJobCaptions;
    Function CanNew: Boolean;
    Procedure DoSave(SaveAs: Boolean);
    Procedure Save;
    Procedure Load(Const Name: String);
  end;

var
  JobForm: TJobForm;

Implementation uses
  ClipBrd, ShellApi,
  FilesFrm, savdlg, CntDlg;

{$R *.DFM}

procedure TJobForm.FormResize(Sender: TObject);
begin
  Job.Columns[2].Width:=Job.ClientWidth
                       -Job.Columns[0].Width
                       -Job.Columns[1].Width;
end;

procedure TJobForm.JobDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=(Source=Job)Or(Source=FilesForm.Files);
end;

Procedure TJobForm.AddDbs(Const FileName: String);
Var
  i: Integer;
Begin
  If FileName='' Then
    Exit;
  i:=Job.Items.Count;
  If Job.Selected<>Nil Then
    i:=Job.Selected.Index+1;
  With Job.Items.Insert(i) Do
   Begin
    Caption:=ChangeFileExt(ExtractFileName(FileName), '');
    ImageIndex:=1;
    SubItems.Add('');
    SubItems.Add(ExtractFilePath(ExpandFileName(FileName)));
    Selected:=True;
   End;
  UpdateJobCaptions;
End;

Procedure TJobForm.UpdateJobCaptions;
Var
  i: Integer;
Begin
  Modified:=Job.Items.Count>0;
  For i:=Job.Items.Count-1 DownTo 0 Do
    If(i=0)Or(Job.Items[i].StateIndex=0)Then
      Job.Items[i].SubItems[0]:='Лист'
    Else
      Job.Items[i].SubItems[0]:=IntToStr(Job.Items[i].ImageIndex);
  FormResize(Nil);
  If Job.Selected<>Nil Then
    Job.Selected.MakeVisible(False);
End;

procedure TJobForm.PopupMenuPopup(Sender: TObject);
begin
  If Job.Selected=Nil Then
    Abort;
  pmList.Checked:=True;
  If Job.Selected.Index=0 Then
   Begin
    pmList.Checked:=True;
    pmList.Enabled:=False;
   End
  Else
   Begin
    pmList.Checked:=Job.Selected.StateIndex=0;
    pmList.Enabled:=True;
   End;
  LocalPaste.Enabled:=Clipboard.HasFormat(cf_Text);
end;

Function TJobForm.CanNew: Boolean;
Begin
  If Modified Then
    Case Application.MessageBox('Сохранить текущее задание?', 'Подтвердите',
      mb_IconQuestion+mb_YesNoCancel)Of
     idYes: Save;
     idNo: Modified:=False;
    End;
  Result:=Not Modified;
End;

Procedure TJobForm.Save;
Begin
  DoSave(PathName='');
End;

Procedure TJobForm.DoSave(SaveAs: Boolean);
Begin
  If Job.Items.Count=0 Then
   Begin
    Modified:=False;
    Exit;
   End;
  If SaveDlg=Nil Then
    SaveDlg:=TSaveDlg.Create(Nil);
  SaveDlg.PathName:=PathName;
  SaveDlg.ActiveControl:=Nil;
  If SaveAs Then
    If Not SaveDlg.NewFileName Then
      Exit
    Else
      PathName:=SaveDlg.PathName;
  If SaveDlg.ShowModal<>mrOk Then
    Exit;
  PathName:=SaveDlg.PathName;
  If SaveDlg.pLST.Checked Then SaveLST;
  If SaveDlg.pKOL.Checked Then SaveKOL;
  If SaveDlg.pJOB.Checked Then SaveJOB;
  If SaveDlg.pDBS.Checked Then SaveDBS;
  Modified:=False;
End;

Procedure TJobForm.SaveKOL;
Const
  S: String[1]='"';
Var
  F: TextFile;
  i: Integer;
Begin
  AssignFile(F, PathName+'.KOL');
  Rewrite(F);
Try
  For i:=0 To Job.Items.Count-1 Do
    With Job.Items[i] Do
     Begin
      Boolean(S[0]):=(Pos(' ', Caption)>0)Or(Pos(' ', SubItems[1])>0);
      Write(F, S, SubItems[1], Caption, S, ' ', ImageIndex);
      If SubItems[0][1]>'9' Then
        Write(F, ' 1');  {Признак листа}
      WriteLN(F);
     End;
Finally
  CloseFile(F);
End
End;

Procedure TJobForm.SaveLST;
Var
  F: TextFile;
  i: Integer;
Begin
  AssignFile(F, PathName+'.LST');
  Rewrite(F);
Try
  For i:=0 To Job.Items.Count-1 Do
    With Job.Items[i] Do
     Begin
      If SubItems[0][1]>'9' Then
        Write(F, '=');  {Признак листа}
      If ImageIndex>1 Then
        Write(F, ImageIndex, '*');
      WriteLN(F, SubItems[1], Caption, ' ');
     End;
Finally
  CloseFile(F);
End
End;

Procedure TJobForm.SaveJOB{(Dist: Float)};
Type
  String2=String[2];
Var
  i, ListN: Integer;
  F: TextFile;
  isList: Boolean;
 Function List2: String2;
 Begin
   Str(ListN:2, Result);
   If Result[1]=' ' Then
     Result[1]:='0';
 End;
 Procedure EndList;
 Var
   N: String[8];
 Begin
   If SaveDlg.pTrum.Checked Then
     WriteLN(F, 'ACC/9100'#13#10+
                'LOAD/'#13#10+
                'ACC/9102'#13#10+
                'LOAD/'#13#10+
                'ACC/9104'#13#10+
                'LOAD/'#13#10+
                'ACC/9106'#13#10+
                'LOAD/');
   N:=ExtractFileName(PathName);
   If(ListN=1)And SaveDlg.p1.Checked Then
    Begin
     If N[0]>#5 Then
       N[0]:=#5;
     N:=N+List2;
    End;
   WriteLN(F, 'ACC/', AnsiUpperCase(N));
   WriteLN(F,
    'CUR CEN DRA/0'#13#10+
    'UNSAVE/-999 -999'#13#10+
    'SAVE'#13#10+
    'EMPTY/-9999'#13#10+
    'LOAD CUR CEN DRA/0'#13#10+
    'UNSAVE/-999 -999');
    If SaveDlg.pDistance.Text<>'' Then
   WriteLN(F, 'ALLOW/', SaveDlg.pDistance.Text);
   WriteLN(F,
    'NEST/1'#13#10+
    'EOF/EOF');
   CloseFile(F);
 End;
Begin
  ListN:=0;
  For i:=0 To Job.Items.Count-1 Do
    With Job.Items[i]Do
     Begin
      isList:=(ListN=0)Or(SubItems[0][1]>'9');
      If isList Then
       Begin
        If ListN>0 Then
          EndList;
        Inc(ListN);
        AssignFile(F, PathName+'.J'+List2);
        Rewrite(F);
       End;
      WriteLN(F, 'ACC/', SubItems[1], Caption);
      Write(F, 'LOAD/'); If Not isList Then Write(F, '0'); WriteLN(F);
      If ImageIndex>1 Then
        WriteLN(F, 'QUAN/:', ImageIndex-1);
     End;
  EndList;
End;

Procedure TJobForm.SaveDBS{(Dist: Float)};
Begin
  Application.MessageBox('Не реализовано (пока)!', 'Сохранить DBS',
    mb_IconInformation+mb_Ok);
End;

procedure TJobForm.JobMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  i: TListItem;
begin
  i:=Job.GetItemAt(1, Y);
  If i<>Nil Then
   Begin
    i.Focused:=True;
    Job.Selected:=i;
    {If Button=mbLeft Then
      Job.BeginDrag(False);}
   End;
end;

procedure TJobForm.SetDir(Sender: TObject);
begin
  FilesForm.Directories.Directory:=Job.Selected.SubItems[1]
end;

procedure TJobForm.Delete(Sender: TObject);
begin
  If(Job.Selected<>Nil)And(Application.MessageBox( 'Удалить этот пункт задания?',
    'Подтвердите', mb_IconQuestion+mb_YesNo)=idYes)Then
   Begin
    Job.Selected.Delete;
    UpdateJobCaptions;
   End;
end;

Procedure TJobForm.MoveTo(NewPos: Integer);
Begin
  If(NewPos<0)Or(Job.Selected=Nil)Or(Job.Selected.Index=NewPos)Then
    Exit;
  If NewPos>Job.Selected.Index Then
    Inc(NewPos);
  With Job.Items.Insert(NewPos) Do
   Begin
    Assign(Job.Selected);
    Job.Selected.Delete;
    Selected:=True
   End;
  UpdateJobCaptions;
End;

procedure TJobForm.JobDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  If Source=FilesForm.Files Then
   Begin
    Job.Selected:=Job.DropTarget;
    AddDbs(FilesForm.Files.FileName);
   End
  Else If Job.DropTarget<>Nil Then
    MoveTo(Job.DropTarget.Index);
end;

procedure TJobForm.Repos(Sender: TObject);
Var
  i: Integer;
begin
  If Job.Selected=Nil Then
    Exit;
  Case TMenuItem(Sender).Tag Of
   -2: i:=0;
   +2: i:=Job.Items.Count;
  Else
    i:=Job.Selected.Index+TMenuItem(Sender).Tag;
  End{Case};
  MoveTo(i);
end;

procedure TJobForm.Count(Sender: TObject);
begin
  If Job.Selected=Nil Then
    Exit;
  If CountDialog=Nil Then
    CountDialog:=TCountDialog.Create(Nil);
  CountDialog.ActiveControl:=CountDialog.Count;
  CountDialog.Name.Caption:=Job.Selected.Caption;
  CountDialog.Directory.Caption:=Job.Selected.SubItems[1];
  CountDialog.Count.Value:=Job.Selected.ImageIndex;
  CountDialog.List.Checked:=Job.Selected.StateIndex=0;
  Case CountDialog.ShowModal Of
   mrCancel: Exit;
   mrNo: Begin Delete(Nil); Exit End;
   mrAll:
    With Job.Items.Insert(Job.Selected.Index+1) Do
    Begin
     Assign(Job.Selected);
     ImageIndex:=ImageIndex-CountDialog.Count.Value;
     If ImageIndex<=0 Then
       ImageIndex:=1;
    End;
  End{Case};
  Job.Selected.ImageIndex:=CountDialog.Count.Value;
  Job.Selected.StateIndex:=Integer(CountDialog.List.Checked)-1;
  UpdateJobCaptions;
end;

procedure TJobForm.pmListClick(Sender: TObject);
begin
  Job.Selected.StateIndex:=-1-Job.Selected.StateIndex;
  UpdateJobCaptions;
end;

Procedure TJobForm.Load(Const Name: String);
Var
  Ext: String;
  i: Integer;
Begin
  Ext:=UpperCase(ExtractFileExt(Name));
  If Ext='.LST' Then i:=0
  Else If Ext='.KOL' Then i:=1
  Else If Ext='.J01' Then i:=2
  Else
    Raise Exception.Create(
      'Неизвестное расширение "'+Ext+'" для файла задания!');
  If Not JobForm.CanNew Then
    Exit;
  JobForm.Job.Items.Clear;
  PathName:=ExpandFileName(Name);
Try
  Case i Of
    1: LoadKOL;
    2: LoadJOB;
  Else
    LoadLST
  End{Case};
  If Job.Items.Count>1 Then
    Job.Items[0].Selected:=True;
  UpdateJobCaptions;  
  Modified:=False;
Except
  Application.MessageBox('Ошибка загрузки', '', mb_IconError+mb_Ok);
  Job.Items.Clear;
  PathName:='';
End
End;

Procedure TJobForm.LoadKOL;
Var
  F: TextFile;
  S, W: String;
 Procedure TrimWord;
 Var
   i: Integer;
   C: Char;
 Begin
   W:='';
   S:=Trim(S);
   If S=W Then
     Exit;
   C:=' ';
   If S[1]='"' Then
    Begin
     C:='"';
     System.Delete(S, 1, 1);
    End;
   i:=Pos(C, S);
   If i=0 Then
     i:=1+Length(S);
   W:=Copy(S, 1, i-1);
   System.Delete(S, 1, i);
 End;
Begin
  AssignFile(F, PathName+'.KOL');
  Reset(F);
Try
  While Not EOF(F) Do
   Begin
    ReadLN(F, S);
    TrimWord;
    If W='' Then
      Continue;
    AddDbs(W);
    With Job.Selected Do
     Begin
      TrimWord;
      ImageIndex:=StrToIntDef(W, 1);
      TrimWord;
      If(W<>'')And(StrToIntDef(W, 1)<>0)Then
        StateIndex:=0;
     End
   End;
Finally
  CloseFile(F)
End
End;

Procedure TJobForm.AddListItem(Const S: String);
Var
  N: String;
  isList: Boolean;
  i, Count: Integer;
Begin
  N:=Trim(S);
  If N='' Then
    Exit;
  isList:=N[1]='=';
  If isList Then
   Begin
    System.Delete(N, 1, 1);
    N:=Trim(N);
   End;
  Count:=1;
  i:=Pos('*', N);
  If i>1 Then
    Try
      Count:=StrToInt(Trim(Copy(N, 1, i-1)));
      System.Delete(N, 1, i);
    Except
    End{Try};
  If N='' Then
    Exit;
  AddDbs(N);
  With Job.Selected Do
   Begin
    StateIndex:=Byte(isList)-1;
    ImageIndex:=Count;
   End
End;

Procedure TJobForm.LoadLST;
Var
  F: TextFile;
  S: String;
Begin
  AssignFile(F, PathName+'.LST');
  Reset(F);
Try
  While Not EOF(F) Do
   Begin
    ReadLN(F, S);
    AddListItem(S);
   End;
Finally
  CloseFile(F)
End
End;

Function IsAlpha(C: Char): Boolean;
Begin
  Result:=False;
  Case C Of
   'A'..'Z',
   'a'..'z': Result:=True
  End;
End;

Function IsDelim(C: Char): Boolean;
Begin
  Result:=False;
  Case C Of
   ' ', '/': Result:=True
  End;
End;

Procedure TJobForm.LoadJOB;
Var
  F: TextFile;
  i, Cnt, ListN: Integer;
  S, LastName: String;
  S3: String[3];
  Added, ListWas: Boolean;
Begin
  ListN:=0;
  Repeat
    Inc(ListN);
    Str(ListN:2, S3);
    If S3[1]=' ' Then S3[1]:='0';
    AssignFile(F, PathName+'.J'+S3);
{$I-}Reset(F);{SI+}
    If IoResult<>0 Then Exit;
    LastName:=''; Added:=False; ListWas:=False; Cnt:=1;
Try
    While Not EOF(F)Do
     Begin
      ReadLN(F, S);
      S:=Trim(S);
      If Length(S)<4 Then Continue;
      S3:=S; S3:=AnsiUpperCase(S3);
      If S3='ACC' Then i:=0
      Else If S3='LOA' Then i:=1
      Else If S3='QUA' Then i:=2
      Else Continue;
      System.Delete(S, 1, 3);
      While(Length(S)>0)And IsAlpha(S[1])Do
        System.Delete(S, 1, 1);
      While(Length(S)>0)And IsDelim(S[1])Do
        System.Delete(S, 1, 1);
      Case i Of
       0:{ACC} Begin LastName:=S; Cnt:=1; Added:=False End;
       1:{LOAD}
        Begin
         If((Length(S)=0)Or(S[1]<>'0'))And ListWas {Загрузка листа}
           Or(Length(LastName)=0)Then
           Continue;
         AddDbs(LastName);
         Job.Selected.ImageIndex:=Cnt;
         If Not ListWas Then
           Job.Selected.StateIndex:=0;
         ListWas:=True;
         Added:=True;  
        End;
      Else {2: QUAN}
        If(Length(S)>0)And(S[1]=':')Then
         Begin
          System.Delete(S, 1, 1);
          S:=Trim(S);
         End;
        Val(S, Cnt, i);
        Case i Of
         0:;
         1: Cnt:=0;
        Else
          SetLength(S, i-1);
          Val(S, Cnt, i);
        End{Case};
        Inc(Cnt);
        If Added Then
          Job.Selected.ImageIndex:=Cnt;
      End{Case}
     End;
Finally
    CloseFile(F);
End
  Until False;
End;

Procedure TJobForm.SetPathName(Const S: String);
Begin
  Path.Caption:=ChangeFileExt(S, '');
End;

Function TJobForm.GetPathName: String;
Begin
  Result:=Path.Caption;
End;

Procedure TJobForm.ParseCmdLine;
Var
  i: Integer;
  F: TextFile;
  S: String;
Begin
  For i:=1 To ParamCount Do
   Begin
    S:=ParamStr(i);
    If S[1]='@' Then
     Begin
      System.Delete(S, 1, 1);
      If ExtractFileExt(S)='' Then
        S:=S+'.LST';
      AssignFile(F, S);
      {$I+}
      Reset(F);
      Try
        While Not EOF(F)Do
         Begin
          ReadLN(F, S);
          AddListItem(S)
         End;
      Finally
        CloseFile(F);
      End
     End
    Else
      AddListItem(S);
   End;
  If Job.Items.Count>0 Then
    Job.Items[0].Selected:=True;
  UpdateJobCaptions;   
End;

procedure TJobForm.FormCreate(Sender: TObject);
begin
  Case ParamCount Of
   0:{Без командной строки};
   1:
    Try
      Load(ParamStr(1))
    Except
      ParseCmdLine {Неверное расширение}
    End;
  Else
    ParseCmdLine;
  End{Case};
end;

procedure TJobForm.PasteClick(Sender: TObject);
Var
  S, Item: String;
  i: Integer;
begin
  S:=Clipboard.AsText;
  While S<>'' Do
   Begin
    S:=Trim(S);
    i:=Pos(#13, S);
    If i=0 Then i:=1+Length(S);
    Item:=Copy(S, 1, i-1);
    System.Delete(S, 1, i);
    If UpperCase(ExtractFileExt(Item))='.DBS' Then
      AddListItem(Item);
   End;
  UpdateJobCaptions;
end;

procedure TJobForm.MenuItemClick(Sender: TObject);
Var
  i: Integer;
begin
  With Sender As TMenuItem Do
    For i:=Count-1 DownTo 0 Do
      With Items[i] Do
        If Tag=-1 Then
          Enabled:=Clipboard.HasFormat(cf_Text)
        Else
          Enabled:=Job.Selected<>Nil;
end;

procedure TJobForm.CopyClick(Sender: TObject);
Var
  S: String;
begin
  S:='';
  If Job.Selected.StateIndex=0 Then
    S:='=';
  If Job.Selected.ImageIndex<>1 Then
    S:=S+IntToStr(Job.Selected.ImageIndex)+'*';
  Clipboard.AsText:=S+Job.Selected.SubItems[1]+Job.Selected.Caption+'.DBS';
  If TMenuItem(Sender).Tag>0 Then
   Begin
    Job.Selected.Delete;
    UpdateJobCaptions;
   End;
end;

procedure TJobForm.FormShow(Sender: TObject);
begin
  DragAcceptFiles({Job.}Handle, True);
end;

Procedure TJobForm.wmDropFiles(Var M: TwmDropFiles);
Var
  Cnt, i: Integer;
  Buf: Array[0..255]Of Char;
  S: String;
Begin
  Cnt:=DragQueryFile(M.Drop, -1, Nil, 0)-1;
  For i:=0 To Cnt Do
   Begin
    DragQueryFile(M.Drop, i, Buf, SizeOf(Buf)-1);
    S:=Buf;
    If UpperCase(ExtractFileExt(S))='.DBS' Then
      AddDbs(S);
   End;
  DragFinish(M.Drop);
  M.Result:=0;
End;

procedure TJobForm.FormDestroy(Sender: TObject);
begin
  If SaveDlg<>Nil Then
    SaveDlg.Free
end;

end.


unit ReForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TRegForm = class(TForm)
    eIn: TEdit;
    Label1: TLabel;
    eOut: TEdit;
    Label2: TLabel;
    bReg: TButton;
    procedure bCopyClick(Sender: TObject);
    procedure bRegClick(Sender: TObject);
    procedure bCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bMailClick(Sender: TObject);
    procedure bWWWClick(Sender: TObject);
    procedure bPasteClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure Execute;
  end;

var
  RegForm: TRegForm;

Var
  RegInfo: String;

Function RegInfoValid: Boolean;
Function CalcRegInfo(Code: String): String;

Implementation uses
  ClipBrd, ShellApi, Registry;

{$R *.DFM}

Function Encrypt(N: Integer): String;
Var
  D: Record
    A, B: Cardinal;
    C: Char;
  End;
Begin
  D.B:= Random(MaxInt);
  D.A:=N XOR D.B;
  Result:='';
  While(D.A<>0)Or(D.B<>0)Do
   Begin
    Asm
     XOR EDX, EDX
     Mov EAX, D.A
     Mov ECX, 26
     Div ECX
     Mov D.A, EAX
     Mov EAX, D.B
     Div ECX
     Mov D.B, EAX
     Add DL, 'A'
     Mov D.C, DL
    End;
    Result:=D.C+Result;
   End;
End;

Function Decrypt(N: String): Integer;
Var
  D: Record
    A, B: Cardinal;
    C: Char;
  End;
Begin
  D.A:=0; D.B:=0;
  While Length(N)>0 Do
   Begin
    D.C:=UpCase(N[1]);
    Delete(N, 1, 1);
    Asm
     Mov ECX, 26
     Mov EAX, D.A
     Mul ECX
     Mov D.A, EAX
     Mov EAX, D.B
     Mul ECX
     Mov CL, D.C
     Sub CL, 'A'
     Add EAX, ECX
     AdC D.A, EDX
     Mov D.B, EAX
    End;
   End;
  Result:=D.A Xor D.B;
End;

Function GetKey: Integer;
Var
  F: TWin32FindData;
  hFind: THandle;
  Tm: TFileTime;
Begin
  Result:=0;
  hFind:=FindFirstFile(PChar(ExtractFileDir(ParamStr(0))+'\*.*'), F);
  While FindNextFile(hFind, F) Do
   Begin
    If(F.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY=0)Or
      (String(F.cFileName)<>'..') Then
      Continue;
    FileTimeToLocalFileTime(F.ftCreationTime, Tm);
    FileTimeToDosDateTime(Tm, LongRec(Result).Hi, LongRec(Result).Lo);
   End;
  Windows.FindClose(hFind);
End;

Function _RegInfoValid(S: String): Boolean;
Begin
  Result:=Decrypt(S)-$08071971=GetKey;
End;

Function RegInfoValid: Boolean;
Begin
  Result:=_RegInfoValid(RegInfo)
End;

Function CalcRegInfo(Code: String): String;
Begin
  Result:=Encrypt(Decrypt(Code)+$08071971)
End;

Procedure TRegForm.Execute;
Var
  S: String;
Begin
  eIn.Text:=Encrypt(GetKey);
  eOut.Clear;
//  eOut.Text:=CalcRegInfo(eIn.Text);
  ActiveControl:=Nil;
  If ShowModal<>id_Ok Then Exit;
  S:=RegInfo;
  RegInfo:=eOut.Text;
  If RegInfoValid Then
    Application.MessageBox(
    'Регистрация прошла успешно.'^M^M'Спасибо за поддержку продукта!',
    PChar(Application.Title), 0)
  Else
    RegInfo:=S;
End;

procedure TRegForm.bCopyClick(Sender: TObject);
begin
  Clipboard.AsText:=eIn.Text;
end;

procedure TRegForm.bRegClick(Sender: TObject);
Var
  R: TRegistry;
begin
  If _RegInfoValid(eOut.Text) Then
   Begin
    R:=TRegistry.Create;
    R.RootKey:=hkey_Local_Machine;
    R.OpenKey('Software\Sirius', True);
    R.WriteString('Reg', eOut.Text);
    R.Free;
    Application.MessageBox(
      'Регистрация прошла успешно.'^M^M'Спасибо за поддержку продукта!',
      PChar(Application.Title), 0);
//    RegInfo:=eOut.Text;
   End;
  Close
end;

procedure TRegForm.bCanClick(Sender: TObject);
begin
  Close
end;

procedure TRegForm.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  eIn.Text:=Encrypt(GetKey);
end;

procedure TRegForm.bMailClick(Sender: TObject);
begin
  ShellExecute(0, Nil, PChar('mailto:'+
    'Sirius%20team<sirius@ekb.ru>?'+
    'subject=Register%20#'+
    eIn.Text), Nil, Nil, sw_Show);
end;

procedure TRegForm.bWWWClick(Sender: TObject);
begin
  ShellExecute(0, Nil, PChar('http://ekb.ru/sirius/reg?HWC='+
    eIn.Text), Nil, Nil, sw_Show);

end;

procedure TRegForm.bPasteClick(Sender: TObject);
begin
  eOut.Text:=Clipboard.AsText;
end;

Initialization
  Randomize;
End.


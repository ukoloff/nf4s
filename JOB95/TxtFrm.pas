unit TxtFrm;
Interface uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Tabs;

type
  TTextForm = class(TForm)
    Exts: TTabSet;
    Txt: TMemo;
    procedure ExtsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    aFile, DefExt: String;
  public
    Procedure ViewIt(FileName: String);
  end;

Function TextForm: TTextForm;

Implementation

Const
  TextExts: Array[1..4] Of String[3]=
('kol', 'cbs', 'trc', 'txt');
  ExtPfx='<';


{$R *.DFM}
var
  FTextForm: TTextForm;

Function CutNumber(S: String): String;
Begin
  Result:=S;
  While(Length(Result)>0)
    And(Result[Length(Result)]>='0')
    And(Result[Length(Result)]<='9')Do
   Delete(Result, Length(Result), 1);
  If(Length(Result)>0)
    And(Length(Result)<Length(S))
    And(Result[Length(Result)]='_') Then
   Delete(Result, Length(Result), 1)
  Else
    Result:='';
End;

Function TextForm: TTextForm;
Begin
  If FTextForm=Nil Then
    FTextForm:=TTextForm.Create(Nil);
  Result:=FTextForm;
End;

{TTextForm}
Procedure TTextForm.ViewIt(FileName: String);
Var
  i: Integer;
 Procedure Populate(Path: String; Pfx: String);
 Var
   S: TSearchRec;
   X: String;
   i: Integer;
 Begin
   If Path='' Then Exit;
   If 0=FindFirst(Path+'.*', faArchive, S)Then
     Repeat
      X:=ExtractFileExt(S.Name);
      Delete(X, 1, 1);
      X:=LowerCase(X);
      For i:=Low(TextExts)To High(TextExts) Do
        If TextExts[i]=X Then
         Begin
          Exts.Tabs.Add(Pfx+X);
          Break;
         End;
     Until 0<>FindNext(S);
   FindClose(S);
 End;
Begin
  Txt.Lines.Clear;
  Exts.Tabs.Clear;
  aFile:=ChangeFileExt(FileName, '');
  Populate(aFile, '');
  Populate(CutNumber(aFile), ExtPfx);
  i:=Exts.Tabs.IndexOf(DefExt);
  If i>=0 Then
    Exts.TabIndex:=i
  Else If Exts.Tabs.Count>0 Then
    Exts.TabIndex:=0;
End;

procedure TTextForm.ExtsChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
Var
  S: String;
begin
  DefExt:=Exts.Tabs[NewTab];
  Txt.Lines.Clear;
  S:=aFile+'.'+DefExt;
  If Copy(DefExt, 1, 1)=ExtPfx Then
    S:=CutNumber(aFile)+'.'+Copy(DefExt, 2 , Length(DefExt));
  Txt.Lines.LoadFromFile(S);
end;

end.

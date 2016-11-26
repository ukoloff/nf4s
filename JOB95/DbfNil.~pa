unit DbfNil;

Interface uses
  Forms;

Type
  TDbForm=TForm;

Function DbForm: TDbForm;
Procedure AddAlias;

Implementation uses
  SysUtils;

Var
  Used: Boolean;

Function DbForm: TDbForm;
Begin
  If Not Used Then
    Application.MessageBox('Архив геометрии не работает'^M+
      'в этой версии Генератора Заданий!', PChar(Application.Title), 0);
  Used:=True;
  Abort;
End;

Procedure AddAlias;
Begin
End;

end.


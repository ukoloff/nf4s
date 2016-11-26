unit SzForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSizedForm = class(TForm)
  private
    { Private declarations }
  public
    LockVertical: Boolean;

    Procedure wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo); Message wm_GetMinMaxInfo;
    Procedure wmNCHitTest(Var M: TwmNCHitTest); Message wm_NCHitTest;
  end;

var
  SizedForm: TSizedForm;

implementation

{$R *.DFM}

Procedure TSizedForm.wmGetMinMaxInfo(Var M: TwmGetMinMaxInfo);
Begin
  Inherited;
  If csReadingState In ControlState Then
    Exit;
  If LockVertical Then
   Begin
    M.MinMaxInfo^.ptMinTrackSize.Y:=Height;
    M.MinMaxInfo^.ptMaxTrackSize.Y:=Height;
   End
  Else
   Begin
    M.MinMaxInfo^.ptMinTrackSize.X:=Width;
    M.MinMaxInfo^.ptMaxTrackSize.X:=Width;
   End;
End;

Procedure TSizedForm.wmNCHitTest(Var M: TwmNCHitTest);
Begin
  Inherited;
  If LockVertical Then
    Case M.Result Of
      htTop, htBottom: M.Result:=htCaption;
      htTopLeft, htBottomLeft: M.Result:=htLeft;
      htTopRight, htBottomRight: M.Result:=htRight;
    End{Case}
  Else
    Case M.Result Of
      htLeft, htRight: M.Result:=htCaption;
      htTopLeft, htTopRight: M.Result:=htTop;
      htBottomLeft, htBottomRight: M.Result:=htBottom;
    End{Case};
End;

end.



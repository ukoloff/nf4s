unit ExecWait;

interface uses
  Windows, Classes;

Type
  TWaitThread=Class(TThread)
    ExitStatus: Integer;

    Constructor Create(Process: THandle);
    Procedure Execute; Override;
  Private
    hProcess: THandle;
  End;

Function TempPath: String;

Implementation

Function TempPath: String;
Begin
  SetLength(Result, GetTempPath(0, Nil)-1);
  GetTempPath(Length(Result), PChar(Result));
End;

{TWaitThread}
Constructor TWaitThread.Create(Process: THandle);
Begin
  Inherited Create(False);
  hProcess:=Process;
  FreeOnTerminate:=True;
End;

Procedure TWaitThread.Execute;
Begin
  WaitForSingleObject(hProcess, INFINITE);
  GetExitCodeProcess(hProcess, ExitStatus);
End;

end.


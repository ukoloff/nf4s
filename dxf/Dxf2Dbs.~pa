unit Dxf2Dbs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    dOpen: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Implementation uses
  Dxf, SirDBS;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
Var
  F: TextFile;
  D: TDbs;
  S: TFileStream;
begin
  If Not dOpen.Execute Then Exit;
  AssignFile(F, dOpen.FileName);
  Reset(F);
  D:=ImportDxf(F);
  CloseFile(F);
  D.Renumerate(0);
  S:=TFileStream.Create(ChangeFileExt(dOpen.FileName, '.dbs'), fmCreate);
  D.Save(S);
  S.Free;
  D.Done; 
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dOpen.InitialDir:=ExtractFileDir(ParamStr(0))+'\data';
end;

end.

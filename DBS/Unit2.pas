unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FileCtrl, StdCtrls;

type
  TForm2 = class(TForm)
    DriveComboBox1: TDriveComboBox;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm2.FormCreate(Sender: TObject);
begin
  DriveComboBox1.Align:=alBottom;
  FormResize(Nil);
  DirectoryListBox1.Directory:='D:\Work\Eq\DBS';     
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  DirectoryListBox1.Width:=ClientWidth Div 2;
end;

procedure TForm2.FileListBox1Click(Sender: TObject);
begin
  Form1.Button2Click(Nil);
end;

end.

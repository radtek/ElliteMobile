unit u_main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmMain = class(TForm)
    LblNome: TLabel;
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  var
    FUser: string;
  public
    { Public declarations }
    property User: String read FUser write FUser;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

uses u_login;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmLogin.Logout;
  FrmLogin.Show;
end;

procedure TFrmMain.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  LblNome.Text := User;
end;

end.

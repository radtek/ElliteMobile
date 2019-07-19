unit u_login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects;

type
  TFrmLogin = class(TForm)
    BtnExit: TButton;
    BtnGetImei: TButton;
    BtnGuid: TButton;
    Edit1: TEdit;
    TxtPassword: TEdit;
    LblUser: TLabel;
    LblPassword: TLabel;
    BtnLogin: TButton;
    Image1: TImage;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnGetImeiClick(Sender: TObject);
    procedure BtnGuidClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FIMEI, FGUID: String;
  public
    { Public declarations }
    property IMEI: String read FIMEI write FIMEI;
    property GUID: String read FGUID write FGUID;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

procedure TFrmLogin.BtnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmLogin.BtnGetImeiClick(Sender: TObject);
begin
  ShowMessage(IMEI);
end;

procedure TFrmLogin.BtnGuidClick(Sender: TObject);
begin
  ShowMessage(GUID);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.

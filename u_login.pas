unit u_login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.JSON, REST.Types, IOUtils, REST.JSON,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts,
  u_database, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.ImageList, FMX.ImgList;

type
  TFrmLogin = class(TForm)
    BtnGetImei: TButton;
    BtnGuid: TButton;
    TxtUser: TEdit;
    TxtPassword: TEdit;
    LblUser: TLabel;
    LblPassword: TLabel;
    img_logo: TImage;
    LayoutClient: TLayout;
    LayoutHeader: TLayout;
    LayoutBody: TLayout;
    LayoutForm: TLayout;
    LayoutBtn: TLayout;
    LblRegister: TLabel;
    BtnExit: TSpeedButton;
    BtnLogin: TSpeedButton;
    ImageListButton: TImageList;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnGetImeiClick(Sender: TObject);
    procedure BtnGuidClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure BtnLoginClick(Sender: TObject);
    procedure TxtUserExit(Sender: TObject);
    procedure TxtPasswordKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure TxtUserKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FIMEI, FGUID, FCompany, FCompanyLogo: String;
  public
    { Public declarations }
    property IMEI: String read FIMEI write FIMEI;
    property GUID: String read FGUID write FGUID;
    property Company: String read FCompany write FCompany;
    property CompanyLogo: String read FCompanyLogo write FCompanyLogo;
    procedure Logout;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses u_register, u_main;
{$R *.LgXhdpiPh.fmx ANDROID}

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

procedure TFrmLogin.Logout;
begin
  dm.request.Params.Clear;
  TxtUser.Text := '';
  TxtPassword.Text := '';
end;

procedure TFrmLogin.TxtPasswordKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if ((Key = VKRETURN) or (Key = VKTab)) and (TxtPassword.Text <> '') then
    BtnLoginClick(Sender);
end;

procedure TFrmLogin.TxtUserExit(Sender: TObject);
begin
  TxtUser.Text := LowerCase(TxtUser.Text);
  TxtPassword.SetFocus;
end;

procedure TFrmLogin.TxtUserKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if ((Key = VKRETURN) or (Key = VKTAB)) and (TxtUser.Text <> '') then
  begin
    TxtPassword.SetFocus;
  end;
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
var
  JSON, person: TJSONObject;
  F: TextFile;
  file_string: string;
begin
  JSON := TJSONObject.Create;
  JSON.AddPair(TJSONPair.Create('username', TxtUser.Text));
  JSON.AddPair(TJSONPair.Create('password', TxtPassword.Text));
  dm.request.ClearBody;
  dm.request.Params.Clear;

  // ShowMessage(DM.Client.BaseURL);
  dm.request.Resource := 'login/';
  dm.request.Method := rmPOST;
  dm.request.AddBody(JSON);
  dm.request.Execute;
  if dm.response.StatusCode = 200 then
  begin
    JSON := dm.response.JsonValue as TJSONObject;
    dm.request.Params.AddHeader('Authorization',
      'Token ' + JSON.GetValue('token').Value);
    dm.request.Params.ParameterByName('Authorization').Options :=
      [poDoNotEncode];
    FrmMain.User := JSON.GetValue('full_name').Value;
    FrmMain.Show;
    FrmLogin.Hide;
  end;
end;

procedure TFrmLogin.FormActivate(Sender: TObject);
begin
  TxtUser.SetFocus;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TFrmLogin.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  LblRegister.Text := 'Software registrado para : ' + FrmRegister.Company;
end;

end.

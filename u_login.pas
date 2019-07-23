unit u_login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.JSON, REST.Types, IOUtils, REST.JSON,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts,
  u_database;

type
  TFrmLogin = class(TForm)
    BtnExit: TButton;
    BtnGetImei: TButton;
    BtnGuid: TButton;
    TxtUser: TEdit;
    TxtPassword: TEdit;
    LblUser: TLabel;
    LblPassword: TLabel;
    BtnLogin: TButton;
    img_logo: TImage;
    LayoutClient: TLayout;
    LayoutHeader: TLayout;
    LayoutBody: TLayout;
    LayoutForm: TLayout;
    LayoutBtn: TLayout;
    LblRegister: TLabel;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnGetImeiClick(Sender: TObject);
    procedure BtnGuidClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure BtnLoginClick(Sender: TObject);
    procedure TxtUserExit(Sender: TObject);
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

procedure TFrmLogin.TxtUserExit(Sender: TObject);
begin
  TxtUser.Text := LowerCase(TxtUser.Text);
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
  dm.request.Resource := 'login/';
  dm.request.Method := rmPOST;
  dm.request.AddBody(JSON);
  dm.request.Execute;
  if dm.response.StatusCode = 200 then
  begin
    JSON := dm.response.JsonValue as TJSONObject;
    dm.request.Params.AddItem('Authorization', 'Token ' + JSON.GetValue('token')
      .Value, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);;
    FrmMain.User := JSON.GetValue('full_name').Value;
    FrmMain.Show;
    FrmLogin.Hide;
    dm.request.Method := rmGET;
    dm.request.Resource := 'person/1/';
    file_string := TFile.ReadAllText('data.json');
    person := TJSONObject.Create();
    person := TJSONObject.ParseJSONValue(file_string) as TJSONObject;
    dm.request.AddBody(person.ToString);
    dm.request.Execute;
    ShowMessage(dm.response.JSONText);
  end;
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

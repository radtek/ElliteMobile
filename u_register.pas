unit u_register;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.JSON,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, u_database,
  u_login;

type
  TFrmRegister = class(TForm)
    btn_register: TButton;
    txt_cpf: TEdit;
    lbl_cpf: TLabel;
    lbl_senha: TLabel;
    txt_password: TEdit;
    img_logo: TImage;
    procedure btn_registerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure txt_cpfExit(Sender: TObject);
  private
    FCPF, FPassword, FCompany, FKey, FHost, FPath, FIMEI, FGUID: String;
    FValidDate: TDate;
    FDataJson: TJSONObject;
    property Cpf: String read FCPF write FCPF;
    property Password: String read FPassword write FPassword;
    property Path: String read FPath write FPath;
    property DataJson: TJSONObject read FDataJson write FDataJson;
    property IMEI: String read FIMEI write FIMEI;
    property GUID: String read FGUID write FGUID;
    procedure WriteFile;
    function SendData(JSON: TJSONObject): boolean;
    procedure CreateJson;
    procedure ReadFile;
    procedure GetDeviceImei;
    procedure GetUuid;
    function FormatarCPFCNPJ(const Doc: String): String;
  published
    property Company: String read FCompany write FCompany;
    property Host: String read FHost write FHost;
    property ValidDate: TDate read FValidDate write FValidDate;
    property Key: String read FKey write FKey;
  public
    { Public declarations }
  end;

var
  FrmRegister: TFrmRegister;

implementation

{$IFDEF MSWINDOWS}

uses
  ComObj, ActiveX;
{$ENDIF}
{$IFDEF IOS}

uses
  iOSapi.UIKit, iOSapi.Foundation, Macapi.Helpers;
{$ENDIF}
{$IFDEF ANDROID}

uses
  Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Telephony, Androidapi.JNI.Provider, Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes, Androidapi.JNI.Os, Androidapi.JNI.App;
{$ENDIF}
{$R *.fmx}
{$IFDEF ANDROID}

procedure TFrmRegister.GetDeviceImei;
var
  obj: JObject;
  tm: JTelephonyManager;
begin
  obj := SharedActivityContext.getSystemService
    (TJContext.JavaClass.TELEPHONY_SERVICE);
  if obj <> nil then
  begin
    tm := TJTelephonyManager.Wrap((obj as ILocalObject).GetObjectID);
    if tm <> nil then
      IMEI := JStringToString(tm.getDeviceId);
  end;
  if IMEI = '' then
    IMEI := JStringToString(TJSettings_Secure.JavaClass.getString
      (SharedActivity.getContentResolver,
      TJSettings_Secure.JavaClass.ANDROID_ID));

end;
{$ENDIF}
{$IFDEF IOS}

procedure TFrmRegister.GetDeviceImei;
var
  Device: UIDevice;
begin
  Device := TUIDevice.Wrap(TUIDevice.OCClass.currentDevice);
  lbOSName.Text := Format('OS Name: %s', [NSStrToStr(Device.systemName)]);
  lbOSVersion.Text := Format('OS Version: %s',
    [NSStrToStr(Device.systemVersion)]);
  lbDeviceType.Text := Format('Device Type: %s', [NSStrToStr(Device.model)]);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}

procedure TFrmRegister.GetDeviceImei;
const
  WbemUser = '';
  WbemPassword = '';
  WbemComputer = 'localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2',
    WbemUser, WbemPassword);
  FWbemObjectSet := FWMIService.ExecQuery('SELECT SerialNumber FROM Win32_BIOS',
    'WQL', wbemFlagForwardOnly);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
  if oEnum.Next(1, FWbemObject, iValue) = 0 then
    IMEI := String(FWbemObject.SerialNumber);
  // String
end;
{$ENDIF}

procedure TFrmRegister.GetUuid;
var
  Uid: TGuid;
  Result: HResult;
begin
  Result := CreateGuid(Uid);
  if Result = S_OK then
    GUID := GuidToString(Uid);
end;

procedure TFrmRegister.FormCreate(Sender: TObject);
begin
  Self.DataJson := TJSONObject.Create();
{$IFDEF MSWINDOWS}
  Path := 'ellite.key';
{$ELSE}
  Path := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetHomePath,
    'ellite.key');
{$ENDIF}
  Self.GetDeviceImei;
  Self.GetUuid;
end;

procedure TFrmRegister.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if FileExists(Path) then
  begin
    FrmLogin.GUID := GUID;
    FrmLogin.IMEI := IMEI;
    FrmLogin.Show;
    FrmRegister.Hide;
  end;

end;

procedure TFrmRegister.btn_registerClick(Sender: TObject);
var
  JSON: TJSONObject;
begin
  Self.Cpf := txt_cpf.Text;
  Self.Password := txt_password.Text;
  JSON := TJSONObject.Create;
  JSON.AddPair(TJSONPair.Create('cpf', Self.Cpf));
  JSON.AddPair(TJSONPair.Create('senha', Self.Password));
  DM.request.ClearBody;
  DM.request.Params.Clear;
  if Self.SendData(JSON) then
  begin
    Self.CreateJson;
    Self.WriteFile;
    
    
  end;
end;

procedure TFrmRegister.WriteFile;
var
  F: TextFile;
begin
  AssignFile(F, Path);
  try
    Rewrite(F);
    Writeln(F, Self.DataJson.ToString);
  finally
    CloseFile(F);
  end;

end;

function TFrmRegister.SendData(JSON: TJSONObject): boolean;
var
  json_object: TJSONObject;
begin
  DM.request.AddBody(JSON);
  DM.request.Execute;
  if DM.response.StatusCode = 200 then
  begin
    json_object := DM.response.JSONValue as TJSONObject;
    Self.Company := json_object.GetValue('company').Value;
    Self.Host := json_object.GetValue('server_ip').Value;
    Self.Key := json_object.GetValue('key').Value;
    Self.ValidDate := StrToDate(json_object.GetValue('valid_date').Value);
    Result := True;
  end
  else
  begin
    ShowMessage('CPF/CNPJ e/ou senha inválidos !');
    Result := False;
  end;
end;

procedure TFrmRegister.txt_cpfExit(Sender: TObject);
begin
  txt_cpf.Text := Self.FormatarCPFCNPJ(txt_cpf.Text)
end;

function TFrmRegister.FormatarCPFCNPJ(const Doc: String): String;
begin
  if (Length(Doc) = 11) then
  begin
    Result := Copy(Doc, 1, 3) + '.' + Copy(Doc, 4, 3) + '.' + Copy(Doc, 7, 3) +
      '-' + Copy(Doc, 10, 2);
  end;
  if (Length(Doc) = 14) then
  begin
    Result := Copy(Doc, 1, 2) + '.' + Copy(Doc, 3, 3) + '.' + Copy(Doc, 6, 3) +
      '/' + Copy(Doc, 9, 4) + '-' + Copy(Doc, 13, 2);
  end;
end;

procedure TFrmRegister.CreateJson;
begin
  Self.DataJson.AddPair(TJSONPair.Create('host', Self.Host));
  Self.DataJson.AddPair(TJSONPair.Create('key', Self.Key));
  Self.DataJson.AddPair(TJSONPair.Create('company', Self.Company));
  Self.DataJson.AddPair(TJSONPair.Create('valid_date',
    DateToStr(Self.ValidDate)));
end;

procedure TFrmRegister.ReadFile;
var
  F: TextFile;
  file_string: string;
  file_value: TJSONObject;
begin
  AssignFile(F, Path);
  try
    Reset(F);
    while not Eof(F) do
    begin
      ReadLn(F, file_string);
      file_value := TJSONObject.Create();
      file_value := TJSONObject.ParseJSONValue(file_string) as TJSONObject;
      Self.Company := file_value.GetValue('company').Value;
      Self.ValidDate := StrToDate(file_value.GetValue('valid_date').Value);
      Self.Host := file_value.GetValue('server_ip').Value;
      Self.Key := file_value.GetValue('key').Value;
    end;
  finally
    CloseFile(F);
  end;

end;

end.

unit u_register;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.JSON,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, u_database;

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
  private
    FCPF: String;
    FPassword: String;
    FCompany: String;
    FHost: String;
    FValidDate: TDate;
    FKey: String;
    FDataJson: TJSONObject;
    property Cpf: String read FCPF write FCPF;
    property Password: String read FPassword write FPassword;
    property DataJson: TJSONObject read FDataJson write FDataJson;
    procedure WriteFile;
    procedure SendData(JSON: TJSONObject);
    procedure CreateJson;
    procedure ReadFile;
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

{$R *.fmx}

procedure TFrmRegister.btn_registerClick(Sender: TObject);
var
  JSON: TJSONObject;
begin
  Self.Cpf := txt_cpf.Text;
  Self.Password := txt_password.Text;
  JSON := TJSONObject.Create;
  JSON.AddPair(TJSONPair.Create('cpf', Self.Cpf));
  JSON.AddPair(TJSONPair.Create('senha', Self.Password));
  Self.SendData(JSON);
  Self.CreateJson;
  Self.WriteFile;
end;

procedure TFrmRegister.FormCreate(Sender: TObject);
begin
  Self.DataJson := TJSONObject.Create();
end;

procedure TFrmRegister.WriteFile;
var
  F: TextFile;
begin
  AssignFile(F, 'Data.key');
  try
    Rewrite(F);
    WriteLn(F, Self.DataJson.ToString);
  finally
    CloseFile(F);
    ShowMessage('Sistema registrado com sucesso !');
  end;

end;

procedure TFrmRegister.SendData(JSON: TJSONObject);
var
  json_object: TJSONObject;
begin
  DM.request.AddBody(JSON);
  DM.request.Execute;
  ShowMessage(DM.response.JSONText);
  json_object := DM.response.JSONValue as TJSONObject;
  Self.Company := json_object.GetValue('company').Value;
  Self.Host := json_object.GetValue('server_ip').Value;
  Self.Key := json_object.GetValue('key').Value;
  Self.ValidDate := StrToDate(json_object.GetValue('valid_date').Value);
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
  AssignFile(F, 'Data.key');
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

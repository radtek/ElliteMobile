unit u_register_client;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.JSON, REST.Types,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts,
  System.ImageList, FMX.ImgList;

type
  TFrmClient = class(TForm)
    EditNome: TEdit;
    EditEmail: TEdit;
    EditCPF: TEdit;
    EditLogradouro: TEdit;
    EditCity: TEdit;
    EditFone: TEdit;
    CameraCodigo: TCameraComponent;
    LayoutForm: TLayout;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    LabelFone: TLabel;
    LabelCity: TLabel;
    LabelLogradouro: TLabel;
    LabelCPF: TLabel;
    LabelName: TLabel;
    LabelEmail: TLabel;
    EditLogradouroNr: TEdit;
    LabelLogradouroNr: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    ButtonAdd: TSpeedButton;
    ImageListToolbar: TImageList;
    ButtonDel: TSpeedButton;
    ButtonSave: TSpeedButton;
    ButtonSearch: TSpeedButton;
    LabelCEP: TLabel;
    EditCEP: TEdit;
    LabelState: TLabel;
    EditState: TEdit;
    Layout4: TLayout;
    EditIBGE: TEdit;
    LabelDistrict: TLabel;
    EditDistrict: TEdit;
    procedure EditCEPExit(Sender: TObject);
    procedure EditCPFExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmClient: TFrmClient;

implementation

{$R *.fmx}

uses u_database;

procedure TFrmClient.EditCEPExit(Sender: TObject);
var
  CEP, BASEURL: string;
  JSON: TJSONObject;
begin
  CEP := EditCEP.Text;
  if CEP.Length >= 8 then
  begin
    EditCEP.Text := Copy(CEP, 1, 5) + '-' + Copy(CEP, 6, 8);
    BASEURL := DM.Client.BASEURL;
    DM.Client.BASEURL := 'https://viacep.com.br/ws/';
    DM.request.Method := rmGET;
    DM.request.Resource := CEP + '/json/';
    DM.request.Execute;
    if DM.Response.StatusCode = 200 then
    begin
      JSON := DM.Response.JSONValue as TJSONObject;
      EditLogradouro.Text := JSON.GetValue('logradouro').Value;
      EditCity.Text := JSON.GetValue('localidade').Value;
      EditState.Text := JSON.GetValue('uf').Value;
      EditIBGE.Text := JSON.GetValue('ibge').Value;
      EditDistrict.Text := JSON.GetValue('bairro').Value;
      EditLogradouroNr.SetFocus;
    end
    else
    begin
      ShowMessage(DM.Response.JSONText);
    end;
  end;

end;

procedure TFrmClient.EditCPFExit(Sender: TObject);
var
  CPF, BASEURL: string;
  JSON, resposta: TJSONObject;
  pessoa: TJSONValue;
  checked: boolean;

begin
  CPF := EditCPF.Text;
  checked := False;
  if (CPF.Length >= 11) and not checked then
  begin
    pessoa := TJSONObject.Create;
    BASEURL := DM.Client.BASEURL;
    DM.Client.BASEURL := 'https://ws.hubdodesenvolvedor.com.br/v2/cpf/';
    DM.request.Resource := '?cpf=' + CPF + '&data=' + '04/05/1988' +
      '&token=61439255kTVbzGMAuS110926712';
    DM.request.Execute;
    // ShowMessage(DM.Response.JSONText);
    JSON := DM.Response.JSONValue as TJSONObject;
    resposta := JSON.GetValue('result') as TJSONObject;
    // ShowMessage(resposta.ToString);
    checked := True;
    EditNome.SetFocus;
    EditCPF.Text := resposta.GetValue('numero_de_cpf').Value;
    EditNome.Text := resposta.GetValue('nome_da_pf').Value;
  end;
end;

end.

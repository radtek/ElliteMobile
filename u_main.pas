unit u_main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.JSON,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects;

type
  TFrmRegister = class(TForm)
    btn_register: TButton;
    txt_cpf: TEdit;
    lbl_cpf: TLabel;
    lbl_senha: TLabel;
    txt_password: TEdit;
    img_logo: TImage;
    procedure btn_registerClick(Sender: TObject);
    procedure WriteFile(data: TJSONObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRegister: TFrmRegister;

implementation

{$R *.fmx}

procedure TFrmRegister.btn_registerClick(Sender: TObject);
var
  mensagem: string;
  data: TJSONObject;
begin
  mensagem := txt_cpf.Text;
  data := TJSONObject.Create();
  data.AddPair(TJSONPair.Create('cpf', txt_cpf.Text));
  data.AddPair(TJSONPair.Create('senha', txt_password.Text));
  Self.WriteFile(data);
end;

procedure TFrmRegister.WriteFile(data: TJSONObject);
var
  F: TextFile;
begin
  AssignFile(F, 'Data.key');
  try
    Rewrite(F);
    WriteLn(F, data.ToString);
  finally
    CloseFile(F);
    ShowMessage('Sistema registrado com sucesso !');
  end;

end;

end.

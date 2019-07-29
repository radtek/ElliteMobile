program ElliteApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  u_database in 'u_database.pas' {DM: TDataModule},
  u_register in 'u_register.pas' {FrmRegister},
  u_login in 'u_login.pas' {FrmLogin},
  u_main in 'u_main.pas' {FrmMain},
  Env in 'Env.pas',
  u_register_client in 'u_register_client.pas' {FrmClient},
  Utils in 'Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmRegister, FrmRegister);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmClient, FrmClient);
  Application.Run;
end.

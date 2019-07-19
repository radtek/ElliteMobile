program ElliteApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  u_database in 'u_database.pas' {DM: TDataModule},
  u_register in 'u_register.pas' {FrmRegister},
  u_login in 'u_login.pas' {FrmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmRegister, FrmRegister);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.

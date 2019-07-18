program Blu;

uses
  System.StartUpCopy,
  FMX.Forms,
  u_register in 'u_register.pas' {FrmRegister},
  u_database in 'u_database.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmRegister, FrmRegister);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

program Blu;

uses
  System.StartUpCopy,
  FMX.Forms,
  u_main in 'u_main.pas' {FrmRegister},
  u_database in 'u_database.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmRegister, FrmRegister);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

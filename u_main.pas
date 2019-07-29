unit u_main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus, System.ImageList,
  FMX.ImgList, FMX.Ani, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmMain = class(TForm)
    MenuMain: TMenuBar;
    MenuRegister: TMenuItem;
    MenuRepport: TMenuItem;
    MenuConfig: TMenuItem;
    MenuRegisterClient: TMenuItem;
    MenuRegisterProduct: TMenuItem;
    MenuRepportRegister: TMenuItem;
    MenuRepportSales: TMenuItem;
    MenuOptions: TMenuItem;
    MenuPDV: TMenuItem;
    MenuRepportRegisterClient: TMenuItem;
    MenuRepportRegisterProduct: TMenuItem;
    ToolBar1: TToolBar;
    ButtonClient: TSpeedButton;
    ImageList1: TImageList;
    StyleBookMain: TStyleBook;
    FloatAnimation1: TFloatAnimation;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonClientClick(Sender: TObject);
  private
    { Private declarations }
  var
    FUser: string;
  public
    { Public declarations }
    property User: String read FUser write FUser;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

uses u_login, u_register_client;

procedure TFrmMain.ButtonClientClick(Sender: TObject);
begin
  FrmClient.Show;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmLogin.Logout;
  FrmLogin.Show;

end;

end.

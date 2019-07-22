unit u_database;

interface

uses
  System.SysUtils, System.Classes, REST.Types, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter;

type
  TDM = class(TDataModule)
    client: TRESTClient;
    request: TRESTRequest;
    response: TRESTResponse;
    dataadapter: TRESTResponseDataSetAdapter;
    memtable: TFDMemTable;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.

object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 449
  Width = 639
  object client: TRESTClient
    Params = <>
    Left = 48
    Top = 64
  end
  object request: TRESTRequest
    Client = client
    Method = rmPOST
    Params = <>
    Resource = 'register/'
    Response = response
    SynchronizedEvents = False
    Left = 96
    Top = 112
  end
  object response: TRESTResponse
    Left = 48
    Top = 112
  end
  object dataadapter: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Left = 232
    Top = 216
  end
  object memtable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 104
    Top = 312
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://192.168.1.100:8080/api/v1/person/'
    ContentType = 'application/json'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 416
    Top = 128
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'Authorization'
        Options = [poDoNotEncode]
        Value = 'Token c0cf0159a588b4fd919d77aecb9d159d9316d888'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 480
    Top = 80
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 464
    Top = 184
  end
end

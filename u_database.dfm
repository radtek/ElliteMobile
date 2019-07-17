object DM: TDM
  OldCreateOrder = False
  Height = 449
  Width = 639
  object client: TRESTClient
    BaseURL = 'https://ellitedev.herokuapp.com/api/v1/'
    Params = <>
    Left = 48
    Top = 64
  end
  object request: TRESTRequest
    Client = client
    Params = <>
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
end

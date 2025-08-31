object BackendDelphiConnection: TBackendDelphiConnection
  OldCreateOrder = False
  Height = 255
  Width = 160
  object Connection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Shopping_Pooled')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 56
    Top = 24
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 56
    Top = 80
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 56
    Top = 136
  end
end

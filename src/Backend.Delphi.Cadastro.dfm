inherited BackendDelphiCadastro: TBackendDelphiCadastro
  OldCreateOrder = True
  Width = 255
  inherited Connection: TFDConnection
    Top = 40
  end
  inherited FDPhysPgDriverLink: TFDPhysPgDriverLink
    Top = 96
  end
  inherited FDGUIxWaitCursor: TFDGUIxWaitCursor
    Top = 152
  end
  object qryPesquisa: TFDQuery
    Connection = Connection
    Left = 160
    Top = 96
  end
  object qryCadastro: TFDQuery
    Connection = Connection
    Left = 160
    Top = 152
  end
  object qryRecordCount: TFDQuery
    Connection = Connection
    Left = 160
    Top = 40
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
end

object DataModule1: TDataModule1
  OnCreate = DataModuleCreate
  Height = 144
  Width = 269
  object FDQuery1: TFDQuery
    Left = 160
    Top = 40
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\MyRepository\ports-and-adapter-delphi\bd\dados.sdb'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 48
    Top = 16
  end
end

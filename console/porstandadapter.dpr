program porstandadapter;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  Data.DB,
  System.SysUtils,
  DataSet.Serialize,
  connection in 'connection.pas' {DataModule1: TDataModule};

begin
  THorse
  .Use(Jhonson)
  .Post('/checking', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    lConnection.FDQuery1.SQl.Clear;
    lConnection.FDQuery1.SQL.Add('select * from parcked_car');
    lConnection.FDQuery1.Open;
    Writeln(lConnection.FDQuery1.ToJSONObject.ToString);
    Writeln(req.Body);
  end);

  THorse
  .Use(Jhonson)
  .Get('/checking', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    lConnection.FDQuery1.SQl.Clear;
    lConnection.FDQuery1.SQL.Add('select * from parcked_car');
    lConnection.FDQuery1.Open;
    Res.Send<TJSONObject>(lConnection.FDQuery1.ToJSONObject);
  end);

  THorse.Listen(9000);
end.
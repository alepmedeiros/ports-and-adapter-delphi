program porstandadapter;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  Data.DB,
  System.SysUtils,
  System.DateUtils,
  DataSet.Serialize,
  connection in 'connection.pas' {DataModule1: TDataModule};

var
  App: THorse;

begin
  App:= THorse.Create;
  App
  .Use(Jhonson);

  App
  .Post('/checking', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
    lBody: TJSONObject;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    try
      lBody := TJSONObject.ParseJSONValue(Req.Body) as TJsonObject;

      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('insert into parcked_car (plate, checkin_date) values (?, ?)');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('checkinDate');
      lConnection.FDQuery1.ExecSQL;

      Res.Status(200);
    finally
      lConnection.DisposeOf;
    end;
  end);

  // retorna os carros estacionados
  App
  .Get('/parked_cars', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
    lBody: TJSONObject;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    try
      lBody := TJSONObject.ParseJSONValue(Req.Body) as TJsonObject;

      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('select * from parked_cars where checkout_date is null');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.ExecSQL;

      Res.Status(200);
    finally
      lConnection.DisposeOf;
    end;
  end);

  // ao executar esse procedimento eu passo o valor da data e hora da saida do carro
  App
  .Post('/checkout', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
    lBody: TJSONObject;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    try
      lBody := TJSONObject.ParseJSONValue(Req.Body) as TJsonObject;

      lConnection.FDQuery1.Close;
      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('select * from parcked_car where plate = ? and checkout is null limit 1');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.Open();

      var chekingDate: TDateTime := lConnection.FDQuery1.FieldByName('checkin_date').AsDateTime;
      var checkoutDate: TDateTime := ISO8601ToDate(lBody.GetValue<String>('checkoutDate'));

      Writeln(chekingDate);
      Writeln(checkoutDate);

      lConnection.FDQuery1.Close;
      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate=?');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.ExecSQL;

      Res.Status(200);
    finally
      lConnection.DisposeOf;
    end;
  end);

  App.Listen(9000);
end.

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
  connection in 'connection.pas' {DataModule1: TDataModule},
  portsandadapter.checking in 'portsandadapter.checking.pas',
  portsandadapter.checkout in 'portsandadapter.checkout.pas',
  portsandadapter.getparkedcars in 'portsandadapter.getparkedcars.pas',
  portsandadapter.input in 'portsandadapter.input.pas';

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

//      lConnection.FDQuery1.SQl.Clear;
//      lConnection.FDQuery1.SQL.Add('insert into parcked_car (plate, checking_date) values (?, ?)');
//      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
//      lConnection.FDQuery1.Params[1].Value := ISO8601ToDate(lBody.GetValue<String>('checkinDate'));
//      lConnection.FDQuery1.ExecSQL;

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
      lConnection.FDQuery1.SQL.Add('select * from parcked_car where checkout_date is null');
      lConnection.FDQuery1.open;

      Res.Send<TJSONArray>(lConnection.FDQuery1.ToJSONArray);
    finally
      lConnection.DisposeOf;
    end;
  end);

  // ao executar esse procedimento eu passo o valor da data e hora da saida do carro
  App
  .Post('/checkout', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lConnection: connection.TDataModule1;
  begin
    lConnection:= connection.TDataModule1.Create(nil);
    try
      var lBody: TJSONObject := TJSONObject.ParseJSONValue(Req.Body) as TJsonObject;

      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('select * from parcked_car where plate = ? and checkout_date is null limit 1');
      lConnection.FDQuery1.Params[0].Value := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.Open();

      var chekingDate: TDateTime := lConnection.FDQuery1.FieldByName('checking_date').AsDateTime;
      var checkoutDate: TDateTime := ISO8601ToDate(lBody.GetValue<String>('checkoutDate'));

      var diff: Integer := HourOf(checkoutDate.GetTime - chekingDate.GetTime);

      var price: Currency := (diff * 10);

      lConnection.FDQuery1.Close;
      lConnection.FDQuery1.SQl.Clear;
      lConnection.FDQuery1.SQL.Add('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate = :plate');
      lConnection.FDQuery1.ParamByName('plate').AsString := lBody.GetValue<String>('plate');
      lConnection.FDQuery1.ExecSQL;

      Res.Send<TJSONObject>(TJSONObject.Create
                              .AddPair('price',TJSONNumber.Create(price))
                              .AddPair('diff', TJSONNumber.Create(diff)));
    finally
      lConnection.DisposeOf;
    end;
  end);

  App.Listen(9000);
end.

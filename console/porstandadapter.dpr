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
  begin
    // observe que mudamos toda uma estrutura de uma forma muito melhor
    var checkin: TCheckin := TCheckin.New;
    checkin.Execute(TInput.New.ToObject(Req.Body));
    Res.Status(200);
  end);

  // retorna os carros estacionados
  App
  .Get('/parked_cars', procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    // olha como a possibilidade de usar variaveis inline ajuda na hora de trabalhar,
    // e observe como o nosso codigo ficou bem melhor e de facil aplicabilidade
    var parkedCars := TGetParkedCars.New.Execute;
    Res.Send<TJsonArray>(parkedCars);
  end);

  // ao executar esse procedimento eu passo o valor da data e hora da saida do carro
  App
  .Post('/checkout', procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    // observe o quanto de mudança foi feita, e o quanto para dentro da aplicação
    // estamos?
    var ticket := TCheckout.New
      .Execute(TInput.New.ToObject(Req.Body));

    Res.Send<TJSONObject>(ticket.ToJSON);
  end);

  App.Listen(9000);
end.

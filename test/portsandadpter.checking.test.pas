unit portsandadpter.checking.test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON,
  portsandadapter.checking,
  portsandadapter.input,
  portsandadapter.getparkedcars,
  portsandadapter.checkout,
  GBJSON.Interfaces,
  portsandadapter.parkedcar,
  portsandadapter.parkedcardatabaserepository,
  portsandadapter.parkedcarrepository, portsandadapter.parkedcarmemoryrepository,
  connection;

type

  [TestFixture]
  TAPITest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [test]
    procedure DeveFazerUmCheckin;
  end;

implementation

{ TAPITest }

procedure TAPITest.DeveFazerUmCheckin;
begin
    // agora iremos criar as chamadas para o repository, onde passamos a dependecia
    // via inversão

    //aqui passamos a connection para usarmos a inversão de dependencia

  var lConnection := TDataModule1.New;
  var parkedCar := TParkedCarRepository.New(lConnection);
// neste momento alteramos para memoria, para que não tenhamos a dependencia de
// persistencia no banco de dados
//  var parkedCar := TParkedCarMemoryRepository.New;

  var
    lCheckin: TCheckin := TCheckin.New(parkedCar);

  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  var
    lInput: TInput := TGBJSONDefault.Serializer<TInput>.JsonStringToObject
      ('{"plate": "AAA-9999", "checkindate": "2023-05-03T10:00Z"}');

  lCheckin.execute(lInput);

  var
    getparkedcars: TGetParkedCars := TGetParkedCars.New(parkedCar);

  var
    parkedCars: TJSONArray := getparkedcars.execute();

  Assert.AreEqual(1, parkedCars.Size);

  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  var
    inputCheckout: TInput := TGBJSONDefault.Serializer<TInput>.
      JsonStringToObject
      ('{"plate": "AAA-9999", "checkoutdate": "2023-05-03T12:00Z"}');

  var
    checkout: TCheckout := TCheckout.New(parkedCar);

  var
    ticket: TOutPut := checkout.execute(inputCheckout);
  Assert.AreEqual(2, ticket.Period);
  Assert.AreEqual<Currency>(20, ticket.Price);

  lConnection.Close;
end;

procedure TAPITest.Setup;
begin

end;

procedure TAPITest.TearDown;
begin

end;

end.

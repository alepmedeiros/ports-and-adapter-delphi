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
  GBJSON.Interfaces;

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
  var
    lCheckin: TCheckin := TCheckin.New;

  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  var
    lInput: TInput := TGBJSONDefault.Serializer<TInput>.JsonStringToObject
      ('{"plate": "AAA-9999", "checkindate": "2023-05-03T10:00Z"}');

  lCheckin.execute(lInput);

  var
    getparkedcars: TGetParkedCars := TGetParkedCars.New;

  var
    parkedCars: TJSONArray := getparkedcars.execute();

  Assert.AreEqual(1, parkedCars.Size);

  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  var
    inputCheckout: TInput := TGBJSONDefault.Serializer<TInput>.
      JsonStringToObject('{"plate": "AAA-9999", "checkoutdate": "2023-05-03T12:00Z"}');

  var
    checkout: TCheckout := TCheckout.New;

  var
    ticket: TOutPut := checkout.execute(inputCheckout);
  Assert.AreEqual(2, ticket.Period);
  Assert.AreEqual<Currency>(20, ticket.Price);
end;

procedure TAPITest.Setup;
begin

end;

procedure TAPITest.TearDown;
begin

end;

end.
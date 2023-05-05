unit portsandadpter.checkout.test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.DateUtils,
  portsandadapter.parkedcar;

type
  [TestFixture]
  TAPITest = class
  public
    [test]
    procedure DeveFazerUmCheckout;
  end;

implementation

{ TAPITest }

procedure TAPITest.DeveFazerUmCheckout;
begin
  var parkedCar := TParkedCar.New('AAA-9999', ISO8601ToDate('2023-05-04T11:00Z'));
  parkedCar.Checkout(ISO8601ToDate('2023-05-04T13:00Z'));
  Assert.AreEqual<Currency>(20, parkedCar.Price);
  Assert.AreEqual<Currency>(2, parkedCar.Diff);
end;

end.

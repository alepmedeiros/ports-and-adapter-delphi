unit portsandadpter.test;

interface

uses
  DUnitX.TestFramework,
  RESTRequest4D;

type
  [TestFixture]
  TAPITest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure DeveTestaraAPI;
  end;

implementation

procedure TAPITest.DeveTestaraAPI;
begin
  TRequest.New.BaseURL('http://localhost:9000')
    .Accept('application/json')
    .Resource('/checking')
    .AddBody('{"plate": "AAA-0099" }')
    .Post;
end;

procedure TAPITest.Setup;
begin
end;

procedure TAPITest.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TAPITest);

end.

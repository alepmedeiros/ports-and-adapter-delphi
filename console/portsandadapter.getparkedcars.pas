unit portsandadapter.getparkedcars;

interface

uses
  System.JSON,
  DataSet.Serialize,
  portsandadapter.input, connection, portsandadapter.parkedcarrepository,
  portsandadapter.parkedcar;

// estou infrigindo todas as regras de criar testes de bob martin

type
  TGetParkedCars = class
  private
//    FDados: TDataModule1;
    FParked: iParkedCarRepository;

    constructor Create(Parked: iParkedCarRepository);
    destructor Destroy; override;
  public
    class function New(Parked: iParkedCarRepository): TGetParkedCars;
    function Execute: TJSONArray;
  end;

implementation

{ TGetParkedCars }

constructor TGetParkedCars.Create(Parked: iParkedCarRepository);
begin
//  FDados:= TDataModule1.Create(nil);
  FParked := Parked;
end;

destructor TGetParkedCars.Destroy;
begin
//  FDados.DisposeOf;
  inherited;
end;

function TGetParkedCars.Execute: TJSONArray;
begin
  var parkedCars := FParked.List;
  Result := TParkedCar.New.ToArray(parkedCars);
end;

class function TGetParkedCars.New(Parked: iParkedCarRepository): TGetParkedCars;
begin
  result := Self.Create(Parked);
end;

end.

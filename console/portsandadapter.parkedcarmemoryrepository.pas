unit portsandadapter.parkedcarmemoryrepository;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  portsandadapter.parkedcarrepository,
  portsandadapter.parkedcar,
  System.Generics.Collections;

type
  TParkedCarMemoryRepository = class(TInterfacedObject, iParkedCarRepository)
  private
    FParkedCars: TObjectList<TParkedCar>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iParkedCarRepository;
    procedure Save(parkedcar: TParkedCar);
    procedure Update(parkedcar: TParkedCar);
    function List: TObjectList<TParkedCar>;
    function Get(plate: String): TParkedCar;
  end;

implementation

{ TMyClass }

constructor TParkedCarMemoryRepository.Create;
begin
  FParkedCars:= TObjectList<TParkedCar>.Create;
end;

destructor TParkedCarMemoryRepository.Destroy;
begin
  FParkedCars.Free;
  inherited;
end;

function TParkedCarMemoryRepository.Get(plate: String): TParkedCar;
begin
  for Result in FParkedCars do
    if Result.Plate.Equals(plate) then
      Break;
end;

function TParkedCarMemoryRepository.List: TObjectList<TParkedCar>;
var
  lParkedCars: TParkedCar;
begin
  Result := TObjectList<TParkedCar>.Create;

  for lParkedCars in FParkedCars do
  begin
    if YearOf(lParkedCars.CheckoutDate) < 1900 then
      Result.Add(lParkedCars);
  end;
end;

class function TParkedCarMemoryRepository.New: iParkedCarRepository;
begin
  Result := Self.Create;
end;

procedure TParkedCarMemoryRepository.Save(parkedcar: TParkedCar);
begin
  FParkedCars.Add(parkedcar);
end;

procedure TParkedCarMemoryRepository.Update(parkedcar: TParkedCar);
begin
  var lparkedCar := Self.Get(parkedcar.Plate);
  lparkedCar.CheckoutDate := parkedcar.CheckoutDate;
end;

end.

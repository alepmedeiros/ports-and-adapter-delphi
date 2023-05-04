unit portsandadapter.checking;

interface

uses
  connection,
  System.Classes,
  System.DateUtils,
  portsandadapter.input,
  portsandadapter.parkedcarrepository,
  portsandadapter.parkedcar;

type
  TCheckin = class
  private
//    FDados: TDataModule1;
  // essa questão lembra um pouco clean archtecture, pois ele preve que vc isole as
  // camadas e que vc seja independente de tecnologia
    FParkedCar: iParkedCarRepository;

    constructor Create(ParkedCar: iParkedCarRepository);
    destructor Destroy; override;
  public
    class function New(ParkedCar: iParkedCarRepository): TCheckin;
    procedure Execute(Input: TInput);
  end;

implementation

{ TCheckin }

constructor TCheckin.Create(ParkedCar: iParkedCarRepository);
begin
//  FDados := TDataModule1.Create(nil);
  FParkedCar := ParkedCar;
end;

destructor TCheckin.Destroy;
begin
//  FDados.Free;
  inherited;
end;

// neste ponto eu estabeleci uma especie de contrato que recebe dados de uma
// forma um pouco mais formal
procedure TCheckin.Execute(Input: TInput);
begin
  FParkedCar.Save(TParkedCar.New(Input.Plate, ISO8601ToDate(Input.CheckinDate)));
end;

class function TCheckin.New(ParkedCar: iParkedCarRepository): TCheckin;
begin
  Result := Self.Create(ParkedCar);
end;

end.

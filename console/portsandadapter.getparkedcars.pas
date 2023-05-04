unit portsandadapter.getparkedcars;

interface

uses
  System.JSON,
  DataSet.Serialize,
  portsandadapter.input, connection;

// estou infrigindo todas as regras de criar testes de bob martin

type
  TGetParkedCars = class
  private
    FDados: TDataModule1;

    constructor Create;
    destructor Destroy; override;
  public
    class function New: TGetParkedCars;
    function Execute: TJSONArray;
  end;

implementation

{ TGetParkedCars }

constructor TGetParkedCars.Create;
begin
  FDados:= TDataModule1.Create(nil);
end;

destructor TGetParkedCars.Destroy;
begin
  FDados.DisposeOf;
  inherited;
end;

function TGetParkedCars.Execute: TJSONArray;
begin
   FDados.FDQuery1.SQl.Clear;
   FDados.FDQuery1.SQL.Add('select * from parcked_car where checkout_date is null');
   FDados.FDQuery1.open;

   Result := FDados.FDQuery1.ToJSONArray;
end;

class function TGetParkedCars.New: TGetParkedCars;
begin
  result := Self.Create;
end;

end.

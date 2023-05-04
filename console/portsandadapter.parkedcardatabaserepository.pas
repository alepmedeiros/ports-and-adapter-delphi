unit portsandadapter.parkedcardatabaserepository;

interface

uses
  portsandadapter.parkedcarrepository,
  System.Generics.Collections,
  portsandadapter.parkedcar, connection;

type
  TParkedCarRepository = class(TInterfacedObject, iParkedCarRepository)
  private
    FDados:TDataModule1;
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

constructor TParkedCarRepository.Create;
begin
  FDados:=TDataModule1.Create(nil);
end;

destructor TParkedCarRepository.Destroy;
begin
  FDados.Free;
  inherited;
end;

function TParkedCarRepository.Get(plate: String): TParkedCar;
begin
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('select * from parcked_car where plate = :plate and checkout_date is null limit 1');
  FDados.FDQuery1.ParamByName('plate').AsString := plate;
  FDados.FDQuery1.Open();

  Result := TParkedCar.New(FDados.FDQuery1.FieldByName('plate').AsString,
    FDados.FDQuery1.FieldByName('checking_date').AsDateTime);
end;

function TParkedCarRepository.List: TObjectList<TParkedCar>;
var
  I: Integer;
begin
  Result := TObjectList<TParkedCar>.Create;

  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQL.Add('select * from parcked_car where checkout_date is null');
  FDados.FDQuery1.open;

  for I := 0 to Pred(FDados.FDQuery1.RecordCount) do
    Result.Add(TParkedCar.New(FDados.FDQuery1.FieldByName('plate').AsString,
                              FDados.FDQuery1.FieldByName('checking_date').AsDateTime));

end;

class function TParkedCarRepository.New: iParkedCarRepository;
begin
  Result := Self.Create;
end;

procedure TParkedCarRepository.Save(parkedcar: TParkedCar);
begin
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('insert into parcked_car (plate, checking_date) values (?, ?)');
  FDados.FDQuery1.Params[0].Value := parkedcar.Plate;
  FDados.FDQuery1.Params[1].Value := parkedcar.CheckinDate;
  FDados.FDQuery1.ExecSQL;
end;

procedure TParkedCarRepository.Update(parkedcar: TParkedCar);
begin
  FDados.FDQuery1.Close;
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate = :plate');
  FDados.FDQuery1.ParamByName('plate').AsString :=
    parkedcar.Plate;
  FDados.FDQuery1.ExecSQL;
end;

end.

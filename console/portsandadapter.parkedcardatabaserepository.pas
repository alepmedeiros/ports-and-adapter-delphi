unit portsandadapter.parkedcardatabaserepository;

interface

uses
  System.Variants,
  portsandadapter.parkedcarrepository,
  System.Generics.Collections,
  portsandadapter.parkedcar,
  connection,
  portsandadapter.connection;

  // aqui iremos trabalhar com a interface de conexao que criamos

type
  TParkedCarRepository = class(TInterfacedObject, iParkedCarRepository)
  private
    FConnection: iConnection;
  public
    // neste ponto a classe não sabe quem é, estou de novo invertendo a dependencia
    // um outro nivel, num nivel mais externo entre as camadas da clean arch
    constructor Create(Connection: iConnection);
    destructor Destroy; override;
    class function New(Connection: iConnection): iParkedCarRepository;
    procedure Save(parkedcar: TParkedCar);
    procedure Update(parkedcar: TParkedCar);
    function List: TObjectList<TParkedCar>;
    function Get(plate: String): TParkedCar;
  end;

implementation

{ TMyClass }

constructor TParkedCarRepository.Create(Connection: iConnection);
begin
  FConnection:= Connection;
end;

destructor TParkedCarRepository.Destroy;
begin

  inherited;
end;

function TParkedCarRepository.Get(plate: String): TParkedCar;
begin
  var lLista := FConnection.One('select * from parcked_car where plate = ? and checkout_date is null',[plate]);

  Result := TParkedCar.New(lLista['plate'], lLista['checking_date']);

//  FDados.FDQuery1.SQl.Clear;
//  FDados.FDQuery1.SQl.Add
//    ('select * from parcked_car where plate = :plate and checkout_date is null limit 1');
//  FDados.FDQuery1.ParamByName('plate').AsString := plate;
//  FDados.FDQuery1.Open();
//
//  Result := TParkedCar.New(FDados.FDQuery1.FieldByName('plate').AsString,
//    FDados.FDQuery1.FieldByName('checking_date').AsDateTime);
end;

function TParkedCarRepository.List: TObjectList<TParkedCar>;
begin
  Result := TObjectList<TParkedCar>.Create;
  var SQL: Variant := 'select * from parcked_car where checkout_date is null';

  var lLista := FConnection.Query(SQL,[]);

  var I: Integer;
  for I:= 0 to Pred(lLista.RecordCount) do
    Result.Add(TParkedCar.New(lLista.FieldByName('plate').AsString,
      lLista.FieldByName('checking_date').AsDateTime));
//  FDados.FDQuery1.SQl.Clear;
//  FDados.FDQuery1.SQL.Add('select * from parcked_car where checkout_date is null');
//  FDados.FDQuery1.open;
//
//  for I := 0 to Pred(FDados.FDQuery1.RecordCount) do
//    Result.Add(TParkedCar.New(FDados.FDQuery1.FieldByName('plate').AsString,
//                              FDados.FDQuery1.FieldByName('checking_date').AsDateTime));

end;

class function TParkedCarRepository.New(Connection: iConnection): iParkedCarRepository;
begin
  Result := Self.Create(Connection);
end;

procedure TParkedCarRepository.Save(parkedcar: TParkedCar);
begin
  FConnection.Query('insert into parcked_car (plate, checking_date) values (?, ?)',
  [parkedcar.Plate, parkedcar.CheckinDate]);

//  FDados.FDQuery1.SQl.Clear;
//  FDados.FDQuery1.SQl.Add
//    ('insert into parcked_car (plate, checking_date) values (?, ?)');
//  FDados.FDQuery1.Params[0].Value := parkedcar.Plate;
//  FDados.FDQuery1.Params[1].Value := parkedcar.CheckinDate;
//  FDados.FDQuery1.ExecSQL;
end;

procedure TParkedCarRepository.Update(parkedcar: TParkedCar);
begin
  FConnection.Query('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate = ?',
    [parkedcar.Plate]);

//  FDados.FDQuery1.Close;
//  FDados.FDQuery1.SQl.Clear;
//  FDados.FDQuery1.SQl.Add
//    ('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate = :plate');
//  FDados.FDQuery1.ParamByName('plate').AsString :=
//    parkedcar.Plate;
//  FDados.FDQuery1.ExecSQL;
end;

end.

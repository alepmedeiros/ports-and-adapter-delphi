unit portsandadapter.checkout;

interface

uses
  System.DateUtils,
  portsandadapter.input,
  connection;

type
  TCheckout = class
  private
    FDados: TDataModule1;

    constructor Create;
    destructor Destroy; override;
  public
    class function New: TCheckout;
    function Execute(input: TInput): TOutput;
  end;

implementation

{ TCheckout }

constructor TCheckout.Create;
begin
  FDados := TDataModule1.Create(nil);
end;

destructor TCheckout.Destroy;
begin
  FDados.Free;
  inherited;
end;

function TCheckout.Execute(input: TInput): TOutput;
begin
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('select * from parcked_car where plate = ? and checkout_date is null limit 1');
  FDados.FDQuery1.Params[0].Value := input.Plate;
  FDados.FDQuery1.Open();

  var
    chekingDate: TDateTime := FDados.FDQuery1.FieldByName('checking_date')
      .AsDateTime;
  var
    checkoutDate: TDateTime :=
      ISO8601ToDate(input.CheckoutDate);

  var
    diff: Integer := HourOf(checkoutDate.GetTime - chekingDate.GetTime);

  var
    price: Currency := (diff * 10);

  FDados.FDQuery1.Close;
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('UPDATE parcked_car SET checkout_date=current_timestamp WHERE plate = :plate');
  FDados.FDQuery1.ParamByName('plate').AsString :=
    input.Plate;
  FDados.FDQuery1.ExecSQL;

  var lOutPut: TOutput := TOutput.New;


  lOutPut.Price := price;
  lOutPut.Period := diff;

  Result := lOutPut;
end;

class function TCheckout.New: TCheckout;
begin
  Result := Self.Create;
end;

end.

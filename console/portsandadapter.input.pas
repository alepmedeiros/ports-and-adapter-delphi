unit portsandadapter.input;

interface

type
  TOutput = class
  private
    FPrice: Currency;
    FPeriod: Integer;
  public
    property Price: Currency read FPrice write FPrice;
    property Period: Integer read FPeriod write FPeriod;

    class function New: TOutput;
  end;

  TInput = class
  private
    FPlate: String;
    FCheckinDate: String;
    FCheckoutDate: String;
  public
    property Plate: String read FPlate write FPlate;
    property CheckinDate: String read FCheckinDate write FCheckinDate;
    property CheckoutDate: String read FCheckoutDate write FCheckoutDate;

    class function New: TInput;
  end;

implementation


class function TInput.New: TInput;
begin
  Result := Self.Create;
end;


class function TOutput.New: TOutput;
begin
  Result := Self.Create;
end;

end.

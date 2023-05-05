unit portsandadapter.parkedcar;

interface

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  System.Generics.Collections,
  GBJSON.Interfaces;

type
  TParkedCar = class
  private
    FPlate: String;
    FCheckinDate: TDateTime;
    FCheckoutDate: TDateTime;
    FPrice: Currency;
    FDiff: Integer;

    constructor Create(aPlate: String; aCheckinDate: TDateTime); overload;
    constructor Create(aPlate: String; aCheckinDate: TDateTime; aCheckoutDate: TDateTime); overload;
  public
    property Plate: String read FPlate write FPlate;
    property CheckinDate: TDateTime read FCheckinDate write FCheckinDate;
    property CheckoutDate: TDateTime read FCheckoutDate write FCheckoutDate;
    property Price: Currency read FPrice write FPrice;
    property Diff: Integer read FDiff write FDiff;

    class function New: TParkedCar; overload;
    class function New(aPlate: String; aCheckinDate: TDateTime): TParkedCar; overload;
    class function New(aPlate: String; aCheckinDate: TDateTime; aCheckoutDate: TDateTime): TParkedCar; overload;
    procedure Checkout(aCheckoutDate: TDateTime);
  end;

  TParkedCarHelper = class helper for TParkedCar
    function ToJSON: TJSONObject;
    function ToArray(Value: TObjectList<TParkedCar>): TJSONArray;
    function ToList(Value: TJSONArray): TObjectList<TParkedCar>;
    function ToObject(Value: String): TParkedCar;
  end;

implementation

{ TParkedCar }

constructor TParkedCar.Create(aPlate: String; aCheckinDate: TDateTime);
begin
  FPlate := aPlate;
  FCheckinDate := aCheckinDate;
end;

procedure TParkedCar.Checkout(aCheckoutDate: TDateTime);
begin
  FDiff := HourOf(aCheckoutDate.GetTime - Self.CheckinDate.GetTime);
  Fprice := (diff * 10);
end;

constructor TParkedCar.Create(aPlate: String; aCheckinDate, aCheckoutDate: TDateTime);
begin
  FPlate := aPlate;
  FCheckinDate := aCheckinDate;
  FCheckoutDate := aCheckoutDate;
end;

class function TParkedCar.New: TParkedCar;
begin
  Result := Self.Create;
end;

class function TParkedCar.New(aPlate: String; aCheckinDate,
  aCheckoutDate: TDateTime): TParkedCar;
begin
  Result := Self.Create(aPlate, aCheckinDate, aCheckoutDate)
end;

class function TParkedCar.New(aPlate: String; aCheckinDate: TDateTime): TParkedCar;
begin
  Result := Self.Create(aPlate,aCheckinDate);
end;

{ TParkedCarHelper }

function TParkedCarHelper.ToArray(Value: TObjectList<TParkedCar>): TJSONArray;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TParkedCar>.ListToJSONArray(Value);
end;

function TParkedCarHelper.ToJSON: TJSONObject;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TParkedCar>.ObjectToJsonObject(Self);
end;

function TParkedCarHelper.ToList(Value: TJSONArray): TObjectList<TParkedCar>;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TParkedCar>.JsonArrayToList(Value);
end;

function TParkedCarHelper.ToObject(Value: String): TParkedCar;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TParkedCar>.JsonStringToObject(Value);
end;

end.

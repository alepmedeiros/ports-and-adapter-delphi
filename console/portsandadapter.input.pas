unit portsandadapter.input;

interface

uses
  System.JSON,
  System.Generics.Collections,
  GBJSON.Interfaces;

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

  TInputHelper = class helper for TInput
    function ToJSON: TJSONObject;
    function ToArray(Value: TObjectList<TInput>): TJSONArray;
    function ToList(Value: TJSONArray): TObjectList<TInput>;
    function ToObject(Value: String): TInput;
  end;

  TOutputHelper = class helper for TOutput
    function ToJSON: TJSONObject;
    function ToArray(Value: TObjectList<TOutput>): TJSONArray;
    function ToList(Value: TJSONArray): TObjectList<TOutput>;
    function ToObject(Value: String): TOutput;
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

{ TInputHelper }

function TInputHelper.ToArray(Value: TObjectList<TInput>): TJSONArray;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TInput>.ListToJSONArray(Value);
end;

function TInputHelper.ToJSON: TJSONObject;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TInput>.ObjectToJsonObject(Self);
end;

function TInputHelper.ToList(Value: TJSONArray): TObjectList<TInput>;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TInput>.JsonArrayToList(Value);
end;

function TInputHelper.ToObject(Value: String): TInput;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TInput>.JsonStringToObject(Value);
end;

{ TOutputHelper }

function TOutputHelper.ToArray(Value: TObjectList<TOutput>): TJSONArray;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TOutput>.ListToJSONArray(Value);
end;

function TOutputHelper.ToJSON: TJSONObject;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Deserializer<TOutput>.ObjectToJsonObject(Self);
end;

function TOutputHelper.ToList(Value: TJSONArray): TObjectList<TOutput>;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TOutput>.JsonArrayToList(Value);
end;

function TOutputHelper.ToObject(Value: String): TOutput;
begin
  TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
  Result := TGBJSONDefault.Serializer<TOutput>.JsonStringToObject(Value);
end;

end.

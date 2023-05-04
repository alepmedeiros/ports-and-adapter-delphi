unit portsandadapter.checkout;

interface

uses
  System.DateUtils,
  portsandadapter.input,
  connection, portsandadapter.parkedcarrepository;

// do jeito que escrevemos o usecase aqui do checkout, eu tenho um hy lavel model,
// eu tenho conceitos de negocio independentes, dependendo de low lavel model,
// que seriam query, banco de dados, questões de sistemas operacional, de rede e arquivo
// então como é que eu inverto a dependencia aqui

type
  TCheckout = class
  private
//    FDados: TDataModule1;
    FParkedCarRepository: iParkedCarRepository;

    constructor Create(parkedCarRepository: iParkedCarRepository);
    destructor Destroy; override;
  public
    class function New(parkedCarRepository: iParkedCarRepository): TCheckout;
    function Execute(input: TInput): TOutput;
  end;

implementation

{ TCheckout }

constructor TCheckout.Create(parkedCarRepository: iParkedCarRepository);
begin
  // esse código está comentado porque a partir desse momento ele está fora
//  FDados := TDataModule1.Create(nil);
  FParkedCarRepository := parkedCarRepository;
end;

destructor TCheckout.Destroy;
begin
//  FDados.Free;
  inherited;
end;

function TCheckout.Execute(input: TInput): TOutput;
begin
  // vamos trabalhar com a inversão, e fazer um paralelo desse codigo

  // estou somente pesquisando nesse momento
  var parkedCar := FParkedCarRepository.Get(input.Plate);

//  var
//    chekingDate: TDateTime := FDados.FDQuery1.FieldByName('checking_date')
//      .AsDateTime;

  var
    chekingDate: TDateTime := parkedCar.CheckinDate;

  var
    checkoutDate: TDateTime :=
      ISO8601ToDate(input.CheckoutDate);

  var
    diff: Integer := HourOf(checkoutDate.GetTime - chekingDate.GetTime);

  var
    price: Currency := (diff * 10);


  // após toda essa regrinha, eu tenho
  FParkedCarRepository.Update(parkedCar);

  var lOutPut: TOutput := TOutput.New;


  lOutPut.Price := price;
  lOutPut.Period := diff;

  Result := lOutPut;
end;

class function TCheckout.New(parkedCarRepository: iParkedCarRepository): TCheckout;
begin
  Result := Self.Create(parkedCarRepository);
end;

end.

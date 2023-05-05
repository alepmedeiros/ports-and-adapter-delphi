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


// agora eu pego o checkout e passo o checkoutdate para que a entidade faça o trabalho da validação
  parkedCar.Checkout(ISO8601ToDate(input.CheckoutDate));

  // após toda essa regrinha, eu tenho
  FParkedCarRepository.Update(parkedCar);

  var lOutPut: TOutput := TOutput.New;

  lOutPut.Price := parkedCar.Price;
  lOutPut.Period := parkedCar.diff;

  Result := lOutPut;
end;

class function TCheckout.New(parkedCarRepository: iParkedCarRepository): TCheckout;
begin
  Result := Self.Create(parkedCarRepository);
end;

end.

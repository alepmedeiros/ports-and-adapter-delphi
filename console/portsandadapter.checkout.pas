unit portsandadapter.checkout;

interface

uses
  System.DateUtils,
  portsandadapter.input,
  connection, portsandadapter.parkedcarrepository;

// do jeito que escrevemos o usecase aqui do checkout, eu tenho um hy lavel model,
// eu tenho conceitos de negocio independentes, dependendo de low lavel model,
// que seriam query, banco de dados, quest�es de sistemas operacional, de rede e arquivo
// ent�o como � que eu inverto a dependencia aqui

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
  // esse c�digo est� comentado porque a partir desse momento ele est� fora
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
  // vamos trabalhar com a invers�o, e fazer um paralelo desse codigo

  // estou somente pesquisando nesse momento
  var parkedCar := FParkedCarRepository.Get(input.Plate);

//  var
//    chekingDate: TDateTime := FDados.FDQuery1.FieldByName('checking_date')
//      .AsDateTime;


// agora eu pego o checkout e passo o checkoutdate para que a entidade fa�a o trabalho da valida��o
  parkedCar.Checkout(ISO8601ToDate(input.CheckoutDate));

  // ap�s toda essa regrinha, eu tenho
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

unit portsandadpter.test;

interface

uses
  DUnitX.TestFramework,
  RESTRequest4D,
  System.SysUtils;

type
  [TestFixture]
  TAPITest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    // neste primeiro teste não é testar a api
    // Deve executar o checkin de um carro
    procedure DeveExecutarCheckinCarro;

    [Test]
    // Deve ventificar o carro estacionado
    procedure DeveVerificarCarroEstacionado;

    [Test]
    // após entrar com o carro, veirifcar os carro, eu tenho que retirar o carro
    procedure RetirarCarroEstacionado;
  end;

implementation

// temos que entender a aplicabilidade do pattern AAA
// Arrange, Act and Assert
// esse ponto do teste que ele esteja estrutura de uma forma, ou seja
// dado um cenario, quando algo acontecer, eu verifico alguma coisa, conhecido como
// Given When Then
// Eu preciso ter todas essas caracteristicas no teste
// Preparo o cenário, executo alguma coisa, e verifico se aquela coisa que executei aconteceu


// neste primeiro teste não é testar a api
// Deve executar o checkin de um carro
// se eu tenho um teste de integração, e não tenho outro entrepoint para essa aplicação
// trazendo agora coisas de ports and adapter, eu não tenho outro driver para essa aplicação
// só me resta fazer pela api.
procedure TAPITest.DeveExecutarCheckinCarro;
begin
  var checking: Integer :=
  TRequest.New.BaseURL('http://localhost:9000')
    .Accept('application/json')
    .Resource('/checking')
    .AddBody('{"plate": "AAA-0099" }')
    .Post.StatusCode;

  Assert.AreEqual(200, checking);
end;

procedure TAPITest.DeveVerificarCarroEstacionado;
begin
  var parkedcars : String :=
  TRequest.New.BaseURL('http://localhost:9000')
    .Accept('application/json')
    .Resource('/parked_cars')
    .Get.Content;

  Assert.AreEqual<Boolean>(True,(parkedcars.length >= 1));
  // após testar seria interessando deletar

  // seguindo o padrão de TDD eu recebi 404 é justamente a quebra da espectativa, lembra que tem as 3 leis do TDD
  // você não deve escrever mais testes do que o suficiente para detectar uma falha
  // você não deve implementar mais do que o suficiente para fazer esse teste passar
  // isso faz com que você fique preso e que te faz progredir, é comum você escrever um monte de teste
  // de uma vez só, não faz sentido, você passa um de cada vez, passe somente um.
  // após isso eu irei escrever o código para que possa passar esse teste, e depois eu reinicio o ciclo
end;


procedure TAPITest.RetirarCarroEstacionado;
begin
  var checkout: Integer :=
  TRequest.New.BaseURL('http://localhost:9000')
    .Accept('application/json')
    .Resource('/checkout')
    .AddBody('{"plate": "AAA-0099" }')
    .Post.StatusCode;

  Assert.AreEqual(200, checkout);
end;

// o teste de que seguir o padrão chamado:
// FIRST

// Fast - Rodar rapido
// Independent - tem que ser independente
// Repeatable - tem que ser repetivel
// Self-Validating
// Timely
procedure TAPITest.Setup;
begin
end;

procedure TAPITest.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TAPITest);

end.

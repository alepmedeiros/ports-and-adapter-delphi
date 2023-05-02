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
    // neste primeiro teste n�o � testar a api
    // Deve executar o checkin de um carro
    procedure DeveExecutarCheckinCarro;

    [Test]
    // Deve ventificar o carro estacionado
    procedure DeveVerificarCarroEstacionado;

    [Test]
    // ap�s entrar com o carro, veirifcar os carro, eu tenho que retirar o carro
    procedure RetirarCarroEstacionado;
  end;

implementation

// temos que entender a aplicabilidade do pattern AAA
// Arrange, Act and Assert
// esse ponto do teste que ele esteja estrutura de uma forma, ou seja
// dado um cenario, quando algo acontecer, eu verifico alguma coisa, conhecido como
// Given When Then
// Eu preciso ter todas essas caracteristicas no teste
// Preparo o cen�rio, executo alguma coisa, e verifico se aquela coisa que executei aconteceu


// neste primeiro teste n�o � testar a api
// Deve executar o checkin de um carro
// se eu tenho um teste de integra��o, e n�o tenho outro entrepoint para essa aplica��o
// trazendo agora coisas de ports and adapter, eu n�o tenho outro driver para essa aplica��o
// s� me resta fazer pela api.
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
  // ap�s testar seria interessando deletar

  // seguindo o padr�o de TDD eu recebi 404 � justamente a quebra da espectativa, lembra que tem as 3 leis do TDD
  // voc� n�o deve escrever mais testes do que o suficiente para detectar uma falha
  // voc� n�o deve implementar mais do que o suficiente para fazer esse teste passar
  // isso faz com que voc� fique preso e que te faz progredir, � comum voc� escrever um monte de teste
  // de uma vez s�, n�o faz sentido, voc� passa um de cada vez, passe somente um.
  // ap�s isso eu irei escrever o c�digo para que possa passar esse teste, e depois eu reinicio o ciclo
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

// o teste de que seguir o padr�o chamado:
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

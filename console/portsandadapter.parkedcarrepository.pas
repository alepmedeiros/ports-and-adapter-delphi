unit portsandadapter.parkedcarrepository;

interface

uses
  System.Generics.Collections, portsandadapter.parkedcar;

// vamos dar um nome de repositorio, mas n�o necess�riamente estamos trabalhando com DDD


// agora vem um conceito que � de ports and adapter, mas tamb�m � do SOLID
// que � o dependece invertion principle, � o D do SOLID
type
  iParkedCarRepository = interface
    procedure Save(parkedCar: TParkedCar);
    procedure Update(parkedCar: TParkedCar);
    function List: TObjectList<TParkedCar>;
    function Get(plate: String): TParkedCar;
  end;

implementation

end.

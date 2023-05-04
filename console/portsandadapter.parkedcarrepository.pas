unit portsandadapter.parkedcarrepository;

interface

uses
  System.Generics.Collections, portsandadapter.parkedcar;

// vamos dar um nome de repositorio, mas não necessáriamente estamos trabalhando com DDD


// agora vem um conceito que é de ports and adapter, mas também é do SOLID
// que é o dependece invertion principle, é o D do SOLID
type
  iParkedCarRepository = interface
    procedure Save(parkedCar: TParkedCar);
    procedure Update(parkedCar: TParkedCar);
    function List: TObjectList<TParkedCar>;
    function Get(plate: String): TParkedCar;
  end;

implementation

end.

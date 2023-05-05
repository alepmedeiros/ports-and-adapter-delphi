unit portsandadapter.connection;

interface

uses
  Data.DB,
  System.Generics.Collections;

type
  iConnection  = interface
    procedure Query(const Statements: string; const Params: array of Variant); overload;
    function Query(const Statements: Variant; const Params: array of Variant): TDataSet; overload;
    function One(const Statements: string; const Params: array of Variant): TDictionary<String, Variant>;
    procedure Close;
  end;

implementation

end.

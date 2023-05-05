unit connection;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.ConsoleUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  portsandadapter.connection;

type
  // coloco a interface no datamodule, pois ele já esta com ocoplamento para
  // as operações do banco de dados
  TDataModule1 = class(TDataModule, iConnection)
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure PreencheLista(var Lista: TDictionary<String, Variant>);
  public
    class function New: iConnection;
    procedure Query(const Statements: string; const Params: array of Variant); overload;
    function Query(const Statements: Variant; const Params: array of Variant): TDataSet; overload;
    function One(const Statements: string; const Params: array of Variant): TDictionary<String, Variant>;
    procedure Close;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

procedure TDataModule1.Close;
begin
  FDConnection1.Connected := False;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Create(Self);
  FDConnection1.Params.DriverID := 'SQLite';
  FDConnection1.Params.Database := 'D:\MyRepository\ports-and-adapter-delphi\bd\dados.sdb';
  FDConnection1.LoginPrompt := False;
  FDConnection1.Connected := True;
  FDQuery1.Create(self);
  FDQuery1.Connection := FDConnection1;
end;

class function TDataModule1.New: iConnection;
begin
  Result := Self.Create(nil);
end;

function TDataModule1.One(const Statements: string; const Params: array of Variant): TDictionary<String, Variant>;
var
  I: Integer;
  F: Integer;
begin
  if not FDConnection1.Connected then
    FDConnection1.Connected := True;

  Result := TDictionary<String, Variant>.Create;

  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add(Statements);

  for I := Low(Params) to High(Params) do
  begin
    FDQuery1.Params.Add;
    FDQuery1.Params[I].Value := Params[I];
  end;

  FDQuery1.Open();

  PreencheLista(Result);
end;

procedure TDataModule1.PreencheLista(var Lista: TDictionary<String, Variant>);
var
  I: Integer;
  F: Integer;
begin
  for I := 0 to Pred(FDQuery1.RecordCount) do
  begin
    for F := 0 to Pred(FDQuery1.FieldCount) do
      Lista.Add(FDQuery1.Fields[F].FieldName,
        FDQuery1.Fields[F].AsVariant);
  end;
end;

function TDataModule1.Query(const Statements: Variant;
  const Params: array of Variant): TDataSet;
var
  I: Integer;
begin
  if not FDConnection1.Connected then
    FDConnection1.Connected := True;

  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add(VarToStr(Statements));

  for I := Low(Params) to High(Params) do
  begin
    FDQuery1.Params.Add;
    FDQuery1.Params[I].Value := Params[I];
  end;

  FDQuery1.Open();

  Result := FDQuery1;
end;

procedure TDataModule1.Query(const Statements: string; const Params: array of Variant);
var
  I: Integer;
begin
  if not FDConnection1.Connected then
    FDConnection1.Connected := True;

  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add(Statements);

  for I := Low(Params) to High(Params) do
  begin
    FDQuery1.Params.Add;
    FDQuery1.Params[I].Value := Params[I];
  end;

  FDQuery1.ExecSQL;
end;

end.

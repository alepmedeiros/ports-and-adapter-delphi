unit portsandadapter.checking;

interface

uses
  connection,
  System.Classes,
  System.DateUtils, portsandadapter.input;

type
  TCheckin = class
  private
    FDados: TDataModule1;

    constructor Create;
    destructor Destroy; override;
  public
    class function New: TCheckin;
    procedure Execute(Input: TInput);
  end;

implementation

{ TCheckin }

constructor TCheckin.Create;
begin
  FDados := TDataModule1.Create(nil);
end;

destructor TCheckin.Destroy;
begin
  FDados.Free;
  inherited;
end;

// neste ponto eu estabeleci uma especie de contrato que recebe dados de uma
// forma um pouco mais formal
procedure TCheckin.Execute(Input: TInput);
begin
  FDados.FDQuery1.SQl.Clear;
  FDados.FDQuery1.SQl.Add
    ('insert into parcked_car (plate, checking_date) values (?, ?)');
  FDados.FDQuery1.Params[0].Value := Input.Plate;
  FDados.FDQuery1.Params[1].Value := ISO8601ToDate(Input.CheckinDate);
  FDados.FDQuery1.ExecSQL;
end;

class function TCheckin.New: TCheckin;
begin
  Result := Self.Create;
end;

end.

unit Backend.Delphi.Generics.Controller;

interface

uses
  System.JSON,
  System.SysUtils,
  Horse,
  DataSet.Serialize,
  Data.DB;

type
  IGenericController<T: class, constructor> = interface
    ['{1AB6EA29-0A6B-4528-9F2C-6F4878FEC96E}']
    procedure Registry(const AResource: string);
  end;

  TGenericController<T: class, constructor> = class(TInterfacedObject,
    IGenericController<T>)
  private const
    NOT_FOUND = 'Registro não encontrado!';
  private
    procedure DoListAll(Req: THorseRequest; Res: THorseResponse);
    procedure DoGetById(Req: THorseRequest; Res: THorseResponse);
    procedure DoAppend(Req: THorseRequest; Res: THorseResponse);
    procedure DoUpdate(Req: THorseRequest; Res: THorseResponse);
    procedure DoDelete(Req: THorseRequest; Res: THorseResponse);
    procedure Registry(const AResource: string);
  public
    class function New: IGenericController<T>;
  end;

implementation

uses Backend.Delphi.Cadastro;

procedure TGenericController<T>.DoAppend(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.Append(Req.Body<TJSONObject>) then
      Res.Status(THTTPStatus.Created).Send<TJSONObject>(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoDelete(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end; 
end;

procedure TGenericController<T>.DoGetById(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    Res.Send<TJSONObject>(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoListAll(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    var LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair('data', LService.ListAll(Req.Query.Dictionary)
      .ToJSONArray());
    LJSONObject.AddPair('record', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send<TJSONObject>(LJSONObject);
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoUpdate(Req: THorseRequest;
  Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);

    if LService.Update(Req.Body<TJSONObject>) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

class function TGenericController<T>.New: IGenericController<T>;
begin
  Result := TGenericController<T>.Create;
end;

procedure TGenericController<T>.Registry(const AResource: string);
begin
  var LResource := AResource + '/:id'; 
  THorse.Get(AResource, DoListAll);
  THorse.Get(LResource, DoGetById);
  THorse.Post(AResource, DoAppend);
  THorse.Put(LResource, DoUpdate);
  THorse.Delete(LResource, DoDelete);
end;

end.

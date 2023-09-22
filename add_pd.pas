unit add_pd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, ZDataset, JLabeledIntegerEdit, JLabeledFloatEdit,
  JLabeledDateEdit, rubros, DB;

type

  { Tf_addp }

  Tf_addp = class(TForm)
    b_nr: TBitBtn;
    b_save: TBitBtn;
    drub: TDataSource;
    fec: TJLabeledDateEdit;
    lst_rub: TDBLookupComboBox;
    Label1: TLabel;
    pc: TJLabeledFloatEdit;
    ex: TLabeledEdit;
    pv1: TJLabeledFloatEdit;
    pv2: TJLabeledFloatEdit;
    pv3: TJLabeledFloatEdit;
    idp: TJLabeledIntegerEdit;
    Shape1: TShape;
    Shape2: TShape;
    stk: TJLabeledIntegerEdit;
    pdnom: TLabeledEdit;
    cb: TLabeledEdit;
    qrub: TZQuery;
    qexe: TZQuery;
    idr: TJLabeledIntegerEdit;
    procedure b_nrClick(Sender: TObject);
    procedure b_saveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lst_rubSelect(Sender: TObject);
  private
    procedure ctrl_vacios();

  public
    procedure nvo_pd();
    procedure carga_rub();

  end;

var
  f_addp: Tf_addp;
  OK: char;

implementation

uses
  prods, main;

{$R *.lfm}

{ Tf_addp }

procedure Tf_addp.FormActivate(Sender: TObject);
begin
  fec.Value:= date();
  carga_rub();
  cb.SetFocus;
  OK:= 'N';
  // Esto ocurre cuando estamos editando
  if idr.Value <> 0 then lst_rub.KeyValue:= idr.Value;
end;

procedure Tf_addp.lst_rubSelect(Sender: TObject);
begin
  idr.Value:= lst_rub.KeyValue;
end;

procedure Tf_addp.ctrl_vacios();
begin
  if (idr.Value = 0) or (lst_rub.Text = '') then
  begin
    showmessage('Debe seleccionar un RUBRO');
    lst_rub.SetFocus;
  end else begin
    if pdnom.Text = '' then
    begin
      showmessage('Debe indicar un NOMBRE de Producto');
      pdnom.SetFocus;
    end else begin
      if pv1.Value = 0 then
      begin
        showmessage('Debe indicar al menos un Precio de Venta (1)');
        pv1.SetFocus;
      end else OK:= 'S';
    end;
  end;
end;

procedure Tf_addp.nvo_pd;
begin
  // El mejor metodo real cuando se eliminan filas de una tabla!
  qexe.Close;
  qexe.SQL.Text:= 'SELECT * FROM sqlite_sequence WHERE name=''PRODUCTOS''';
  qexe.Open;
  if qexe.FieldByName('seq').IsNull then idp.Value:= 1 // <-- FIX Null
  else idp.Value:= qexe.FieldByName('seq').Value + 1;
end;

procedure Tf_addp.carga_rub();
begin
  qrub.Close;
  qrub.SQL.Text:= 'SELECT * FROM RUBROS ORDER BY rnom ASC';
  qrub.Open;
end;

procedure Tf_addp.b_saveClick(Sender: TObject);
var
  msje: string;
begin
  ctrl_vacios();
  if OK = 'S' then
  begin
    // guardo el producto
    qexe.Close;
    if self.Caption = 'AGREGANDO NUEVO PRODUCTO' then
    begin           // NUEVO
      qexe.SQL.Text:= 'INSERT INTO PRODUCTOS(id_rub,cbar,pdnom,pc,pv1,pv2,pv3,stock,fec,extra) '+
      'VALUES(:IR,:CB,:PN,:PC,:V1,:V2,:V3,:STK,:FE,:EX)';
      msje:= 'Nuevo Producto Cargado Correctamente!';
    end else begin  // MODIFICA
      qexe.SQL.Text:= 'UPDATE PRODUCTOS SET id_rub=:IR,cbar=:CB,pdnom=:PN,pc=:PC,pv1=:V1,'+
      'pv2=:V2,pv3=:V3,stock=:STK,fec=:FE,extra=:EX WHERE id_pd=:IP';
      qexe.ParamByName('IP').AsInteger:= idp.Value;
      msje:= 'Producto Modificado Correctamente!';
    end;
    // Parámetros
    qexe.ParamByName('IR').AsInteger:= idr.Value;
    qexe.ParamByName('CB').AsString:= trim(cb.Text);
    qexe.ParamByName('PN').AsString:= trim(uppercase(pdnom.Text));
    qexe.ParamByName('PC').AsFloat:= pc.Value;
    qexe.ParamByName('V1').AsFloat:= pv1.Value;
    qexe.ParamByName('V2').AsFloat:= pv2.Value;
    qexe.ParamByName('V3').AsFloat:= pv3.Value;
    qexe.ParamByName('STK').AsInteger:= stk.Value;
    qexe.ParamByName('FE').AsDate:= fec.Value;
    qexe.ParamByName('PN').AsString:= trim(ex.Text);
    qexe.ExecSQL;
    showmessage(msje);
    // Ok Recargamos listado
    f_prod.lista_p();
    f_prod.qlista.Locate('id_pd',idp.Value,[]);
    close();
  end;
end;

procedure Tf_addp.b_nrClick(Sender: TObject);
begin
  f_rub:= Tf_rub.Create(Self);
  f_rub.ShowModal;
  carga_rub(); // recarga
end;

end.


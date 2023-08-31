unit add_cl;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ZDataset, JLabeledIntegerEdit, JLabeledDateEdit;

type

  { Tf_addc }

  Tf_addc = class(TForm)
    b_save: TBitBtn;
    cn: TLabeledEdit;
    cuit: TEdit;
    dir: TLabeledEdit;
    em: TLabeledEdit;
    fec: TJLabeledDateEdit;
    idc: TJLabeledIntegerEdit;
    Label1: TLabel;
    qexe: TZQuery;
    rs: TLabeledEdit;
    Shape1: TShape;
    tel: TLabeledEdit;
    procedure b_saveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure ctrl_vacios();

  public
    procedure nvo_clien();

  end;

var
  f_addc: Tf_addc;
  ok: char;

implementation

uses
  cliens, main;

{$R *.lfm}

{ Tf_addc }

procedure Tf_addc.FormActivate(Sender: TObject);
begin
  fec.Value:= date();
  ok:= 'N';
end;

procedure Tf_addc.nvo_clien();
begin
  // El mejor metodo real cuando se eliminan filas de una tabla!
  qexe.Close;
  qexe.SQL.Text:= 'SELECT * FROM sqlite_sequence WHERE name=''CLIENTES''';
  qexe.Open;
  if qexe.FieldByName('seq').IsNull then idc.Value:= 1 // <-- FIX Null
  else idc.Value:= qexe.FieldByName('seq').Value + 1;
end;

procedure Tf_addc.b_saveClick(Sender: TObject);
var
  ncli, msje: string;
begin
  ctrl_vacios();
  if ok = 'S' then
  begin
    ncli:= trim(uppercase(cn.Text));
    qexe.Close;
    if self.Caption = 'Modificando Datos Cliente' then // Nuevo?
    begin
      qexe.SQL.Text:= 'UPDATE CLIENTES SET razon=:RZ,cuit=:CU,cnom=:CN,dire=:DI,'+
      'tel=:TE,mail=:EM,fec=:FE WHERE id_cl=:IC';
      qexe.ParamByName('IC').AsInteger:= idc.Value;
      msje:= 'Cliente Modificado Correctamente!';
    end else begin
      qexe.SQL.Text:= 'INSERT INTO CLIENTES(cnom,razon,cuit,dire,tel,mail,fec) '+
      'VALUES(:CN,:RZ,:CU,:DI,:TE,:EM,:FE)';
      msje:= 'Nuevo Cliente cargado Correctamente!';
    end;
    // Parametros --------------
    qexe.ParamByName('CN').AsString:= uppercase(trim(cn.Text));
    qexe.ParamByName('RZ').AsString:= trim(rs.Text);
    qexe.ParamByName('CU').AsString:= trim(cuit.Text);
    qexe.ParamByName('DI').AsString:= trim(dir.Text);
    qexe.ParamByName('TE').AsString:= trim(tel.Text);
    qexe.ParamByName('EM').AsString:= trim(em.Text);
    qexe.ParamByName('FE').AsDate:= fec.Value;
    qexe.ExecSQL;
    // OK
    showmessage(msje);
    // Recarga Lista
    if self.Caption <> 'Creando Nuevo Cliente' then
    begin
      f_cli.lista_c();
      f_cli.qlista.Locate('cnom',ncli,[]);
    end else begin
      f_main.carga_cli();
      f_main.lst_cli.KeyValue:= idc.Value;
    end;
    close();
  end;
end;

procedure Tf_addc.ctrl_vacios();
begin
  if cn.Text = '' then
  begin
    showmessage('Debe indicare un Nombre de Cliente/Contacto');
    cn.SetFocus;
  end else begin
    if tel.Text = '' then
    begin
      showmessage('Debe indicar un TELEFONO de contacto');
      tel.SetFocus;
    end else begin
      if fec.Value = 0 then
      begin
        showmessage('Debe indicar una FECHA de creación/modificación');
        fec.SetFocus;
      end else OK:= 'S';
    end;
  end;
end;

end.


 unit cliens;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, ZDataset, JLabeledIntegerEdit, JLabeledDateEdit, add_cl;

type

  { Tf_cli }

  Tf_cli = class(TForm)
    b_del: TBitBtn;
    b_imp: TBitBtn;
    b_mod: TBitBtn;
    b_nvo: TBitBtn;
    dlista: TDataSource;
    Label3: TLabel;
    lista: TDBGrid;
    pcan: TLabel;
    qexe: TZQuery;
    qlista: TZQuery;
    xnom: TLabeledEdit;
    procedure b_delClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_nvoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure listaSelectEditor(Sender: TObject; Column: TColumn);
    procedure xnomChange(Sender: TObject);
  private

  public
    procedure lista_c();

  end;

var
  f_cli: Tf_cli;

implementation

uses
  main;

{$R *.lfm}

{ Tf_cli }

procedure Tf_cli.FormActivate(Sender: TObject);
begin
  lista_c();
end;

procedure Tf_cli.listaSelectEditor(Sender: TObject; Column: TColumn);
begin
  if not qlista.IsEmpty and (self.Caption <> 'Viendo Clientes') then
  begin
    b_mod.Enabled:= true; b_del.Enabled:= true; b_imp.Enabled:= true;
  end else begin
    b_mod.Enabled:= false; b_del.Enabled:= false; b_imp.Enabled:= false;
  end;
end;

procedure Tf_cli.xnomChange(Sender: TObject);
begin
  lista_c();
end;

procedure Tf_cli.b_modClick(Sender: TObject);
begin
  if not qlista.IsEmpty then
  begin
    f_addc:= Tf_addc.Create(Self);
    f_addc.Caption:= 'Modificando Datos Cliente';
    // cargamos datos
    f_addc.idc.Value:= qlista.FieldByName('id_cl').Value;
    f_addc.rs.Text:= qlista.FieldByName('razon').Text;
    f_addc.cuit.Text:= qlista.FieldByName('cuit').Text;
    f_addc.cn.Text:= qlista.FieldByName('cnom').Text;
    f_addc.dir.Text:= qlista.FieldByName('dire').Text;
    f_addc.tel.Text:= qlista.FieldByName('tel').Text;
    f_addc.em.Text:= qlista.FieldByName('mail').Text;
    f_addc.fec.Value:= qlista.FieldByName('fec').Value;
    f_addc.ShowModal;
  end;
end;

procedure Tf_cli.b_nvoClick(Sender: TObject);
begin
  if b_nvo.Caption = 'Nuevo' then
  begin
    f_addc:= Tf_addc.Create(Self);
    f_addc.Caption:= 'Agregando Nuevo Cliente';
    f_addc.nvo_clien();
    f_addc.ShowModal;
  end else begin
    // Selecciona en el combo del main
    f_main.lst_cli.KeyValue:= qlista.FieldByName('id_cl').Value;
    close();
  end;
end;

procedure Tf_cli.b_delClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!', 'Está seguro que desea ELIMINAR el Cliente:'+#13+#13+
  '- '+qlista.FieldByName('razon').Text+#13+'- '+qlista.FieldByName('cnom').Text+#13+#13+
  '[Este proceso es Irreversible]', mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Elimina
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM clientes WHERE id_cl=:IC';
    qexe.ParamByName('IC').AsInteger:= qlista.FieldByName('id_cl').Value;
    qexe.ExecSQL;
    lista_c();
  end;
end;

procedure Tf_cli.lista_c();
var
  fpal: string;
begin
  qlista.Close;
  if (xnom.Text <> '') then // con filtro de palabras
  begin
    fpal:= uppercase(trim(xnom.Text)); // Re-escribo la sentencia SQL
    qlista.SQL.Text:= 'SELECT * FROM CLIENTES WHERE cnom LIKE :PAL ORDER BY cnom ASC';
    qlista.ParamByName('PAL').AsString:= '%'+fpal+'%';
  end else
    qlista.SQL.Text:= 'SELECT * FROM CLIENTES ORDER BY cnom ASC';
  qlista.Open;
  pcan.Caption:= inttostr(qlista.RecordCount);
end;

end.


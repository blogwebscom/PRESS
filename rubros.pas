unit rubros;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, Buttons,
  StdCtrls, ExtCtrls, ZDataset;

type

  { Tf_rub }

  Tf_rub = class(TForm)
    b_del: TBitBtn;
    b_mod: TBitBtn;
    b_nvo: TBitBtn;
    b_save: TBitBtn;
    lista: TDBGrid;
    dlista: TDataSource;
    Label3: TLabel;
    rnom: TLabeledEdit;
    pcan: TLabel;
    qlista: TZQuery;
    qexe: TZQuery;
    procedure b_delClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_nvoClick(Sender: TObject);
    procedure b_saveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure listaCellClick(Column: TColumn);
  private
    procedure carga_rub();

  public

  end;

var
  f_rub: Tf_rub;
  oper: char;

implementation

{$R *.lfm}

{ Tf_rub }

procedure Tf_rub.FormActivate(Sender: TObject);
begin
  carga_rub();
end;

procedure Tf_rub.listaCellClick(Column: TColumn);
begin
  if not qlista.IsEmpty then
  begin
    rnom.Text:= qlista.FieldByName('rnom').Text;
    rnom.Enabled:= false;
    b_mod.Enabled:= true;
    b_del.Enabled:= true;
  end;
end;

procedure Tf_rub.carga_rub();
begin
  qlista.Close;
  qlista.SQL.Text:= 'SELECT * FROM RUBROS ORDER BY rnom ASC';
  qlista.Open;
  pcan.Caption:= inttostr(qlista.RecordCount);
end;

procedure Tf_rub.b_nvoClick(Sender: TObject);
begin
  rnom.Enabled:= true;
  rnom.Text:= '';
  oper:= 'N';
  // Hab.
  lista.Enabled:= false;
  b_nvo.Enabled:= false;
  b_mod.Enabled:= false;
  b_del.Enabled:= false;
  b_save.Enabled:= true;
  rnom.SetFocus
end;

procedure Tf_rub.b_modClick(Sender: TObject);
begin
  rnom.Enabled:= true;
  oper:= 'M';
  // Hab.
  lista.Enabled:= false;
  b_nvo.Enabled:= false;
  b_mod.Enabled:= false;
  b_del.Enabled:= false;
  b_save.Enabled:= true;
  rnom.SetFocus;
end;

procedure Tf_rub.b_saveClick(Sender: TObject);
var
  nrub: string;
begin
  nrub:= trim(uppercase(rnom.Text));
  qexe.Close;
  if oper = 'N' then
    qexe.SQL.Text:= 'INSERT INTO RUBROS(rnom) VALUES(:NR)'
  else begin
    qexe.SQL.Text:= 'UPDATE RUBROS SET rnom=:NR WHERE id_rub=:IR';
    qexe.ParamByName('IR').AsInteger:= qlista.FieldByName('id_rub').Value;
  end;
  // Parametros --------------
  qexe.ParamByName('NR').AsString:= nrub;
  qexe.ExecSQL;
  carga_rub();
  qlista.Locate('rnom',nrub,[]);
  // Hab. Limpia
  rnom.Text:= ''; rnom.Enabled:= false;
  // Hab.
  lista.Enabled:= true;
  b_nvo.Enabled:= true;
  b_save.Enabled:= false;
  b_nvo.SetFocus;
end;

procedure Tf_rub.b_delClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!', 'Está seguro que desea ELIMINAR el Rubro:'+#13+#13+
  '- '+qlista.FieldByName('rnom').Text+#13+#13+'[Este proceso es Irreversible]',
  mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Elimina
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM rubros WHERE id_rub=:IR';
    qexe.ParamByName('IR').AsInteger:= qlista.FieldByName('id_rub').Value;
    qexe.ExecSQL;
    carga_rub();
    rnom.Text:= ''; // Limpia
  end;
end;

end.


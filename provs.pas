unit provs;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, Buttons,
  StdCtrls, ExtCtrls, LR_Class, LR_DBSet, ZDataset;

type

  { Tf_prov }

  Tf_prov = class(TForm)
    b_del: TBitBtn;
    b_imp: TBitBtn;
    b_mod: TBitBtn;
    b_nvo: TBitBtn;
    b_save: TBitBtn;
    dlista: TDataSource;
    drepo: TfrDBDataSet;
    Label1: TLabel;
    Label3: TLabel;
    lista: TDBGrid;
    pcan: TLabel;
    dir: TLabeledEdit;
    em: TLabeledEdit;
    extra: TLabeledEdit;
    repo: TfrReport;
    web: TLabeledEdit;
    qexe: TZQuery;
    qlista: TZQuery;
    pvn: TLabeledEdit;
    Shape1: TShape;
    Shape2: TShape;
    tel: TLabeledEdit;
    procedure b_delClick(Sender: TObject);
    procedure b_impClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_nvoClick(Sender: TObject);
    procedure b_saveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure repoGetValue(const ParName: String; var ParValue: Variant);
  private
    procedure lista_pv();

  public

  end;

var
  f_prov: Tf_prov;
  oper: char;

implementation

uses
  main;

{$R *.lfm}

{ Tf_prov }

procedure Tf_prov.FormActivate(Sender: TObject);
begin
  lista_pv();
  b_nvo.SetFocus;
end;

procedure Tf_prov.b_nvoClick(Sender: TObject);
begin
  oper:= 'N';
  // Limpia
  pvn.Text:= ''; tel.Text:= ''; dir.Text:= '';
  em.Text:= ''; web.Text:= ''; extra.Text:= '';
  // Hab.
  pvn.Enabled:= true; tel.Enabled:= true; dir.Enabled:= true;
  em.Enabled:= true; web.Enabled:= true; lista.Enabled:= false;
  b_nvo.Enabled:= false; b_mod.Enabled:= false; b_del.Enabled:= false;
  b_save.Enabled:= true; b_imp.Enabled:= false; extra.Enabled:= true;
  pvn.SetFocus;
end;

procedure Tf_prov.b_modClick(Sender: TObject);
begin
  oper:= 'M';
  // Carga datos
  pvn.Text:= qlista.FieldByName('pvnom').Text; tel.Text:= qlista.FieldByName('tel').Text;
  dir.Text:= qlista.FieldByName('dire').Text; em.Text:= qlista.FieldByName('email').Text;
  web.Text:= qlista.FieldByName('web').Text; extra.Text:= qlista.FieldByName('extra').Text;
  // Hab.
  pvn.Enabled:= true; tel.Enabled:= true; dir.Enabled:= true;
  em.Enabled:= true; web.Enabled:= true;  lista.Enabled:= false;
  b_nvo.Enabled:= false; b_mod.Enabled:= false; b_del.Enabled:= false;
  b_save.Enabled:= true; b_imp.Enabled:= false; extra.Enabled:= true;
  pvn.SetFocus;
end;

procedure Tf_prov.b_saveClick(Sender: TObject);
var
  nprov, msje: string; // localiza por nombre? extra: datos extra
begin
  if pvn.Text <> '' then
  begin
    nprov:= trim(uppercase(pvn.Text));
    qexe.Close;
    if oper = 'N' then
    begin
      qexe.SQL.Text:= 'INSERT INTO PROVEEDORES(pvnom,dire,tel,email,web,extra) '+
      'VALUES(:PN,:DI,:TE,:EM,:WE,:PE)';
      msje:= 'Nuevo Proveedor Cargado Correctamente!';
    end else begin
      qexe.SQL.Text:= 'UPDATE PROVEEDORES SET pvnom=:PN,dire=:DI,tel=:TE,email=:EM,'+
      'web=:WE,extra=:PE WHERE id_pv=:IP';
      qexe.ParamByName('IP').AsInteger:= qlista.FieldByName('id_pv').Value;
      msje:= 'Proveedor Modificado Correctamente!';
    end;
    // Parametros --------------
    qexe.ParamByName('PN').AsString:= nprov;
    qexe.ParamByName('DI').AsString:= trim(uppercase(dir.Text));
    qexe.ParamByName('TE').AsString:= trim(uppercase(tel.Text));
    qexe.ParamByName('EM').AsString:= trim(lowercase(em.Text));
    qexe.ParamByName('WE').AsString:= trim(lowercase(web.Text));
    qexe.ParamByName('PE').AsString:= trim(extra.Text);
    qexe.ExecSQL;
    lista_pv();
    qlista.Locate('pvnom',nprov,[]);
    showmessage(msje);
    // Limpia
    pvn.Text:= ''; tel.Text:= ''; dir.Text:= '';
    em.Text:= ''; web.Text:= ''; extra.Text:= '';
    // Hab.
    pvn.Enabled:= false; tel.Enabled:= false; dir.Enabled:= false;
    em.Enabled:= false; web.Enabled:= false; lista.Enabled:= true;
    b_nvo.Enabled:= true; b_save.Enabled:= false; extra.Enabled:= false;
    b_nvo.SetFocus;
  end else
    showmessage('El nombre del Proveedor no puede estar Vacio!');
end;

procedure Tf_prov.b_delClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!', 'Está seguro que desea ELIMINAR el Proveedor:'+#13+#13+
  '- '+qlista.FieldByName('pvnom').Text+#13+#13+'[Este proceso es Irreversible]',
  mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Elimina
    qexe.Active:= false;
    qexe.SQL.Text:= 'DELETE FROM PROEVEDORES WHERE id_pv=:IP';
    qexe.ParamByName('IP').AsInteger:= qlista.FieldByName('id_pv').Value;
    qexe.ExecSQL;
    lista_pv();
    // Limpia
    pvn.Text:= ''; tel.Text:= ''; dir.Text:= '';
    em.Text:= ''; web.Text:= ''; extra.Text:= '';
  end;
end;

procedure Tf_prov.b_impClick(Sender: TObject);
begin
  repo.LoadFromFile(ExtractFilePath(Application.EXEName)+'inf\iprovees.lrf'); // plural
  if repo.PrepareReport then
  begin
    case QuestionDlg('Reporte', 'Seleccione una opción:', mtConfirmation,
    [mrYes, 'Directo', mrNo, 'Vista Previa','IsDefault'], '') of
      mrYes: repo.PrintPreparedReport('',0);
      mrNo: repo.ShowReport;
    end;
  end else
    showmessage('Error Generando el Reporte!');
end;

procedure Tf_prov.repoGetValue(const ParName: String; var ParValue: Variant);
begin
  {Variables para Informes}
  if parname = 'EN' then parvalue:= f_main.enom;
  if parname = 'ED' then parvalue:= f_main.edire;
  if parname = 'ET' then parvalue:= f_main.etel;
  if parname = 'EM' then parvalue:= f_main.email;
  if parname = 'EW' then parvalue:= f_main.eweb;
  if parname = 'EI' then parvalue:= f_main.einfo;
  if parname = 'EL' then parvalue:= f_main.elogo;
end;

procedure Tf_prov.lista_pv();
begin
  qlista.Close;
  qlista.SQL.Text:= 'SELECT * FROM PROVEEDORES ORDER BY pvnom ASC';
  qlista.Open;
  pcan.Caption:= inttostr(qlista.RecordCount);
  // Hab.
  if not qlista.IsEmpty then
  begin
    b_mod.Enabled:= true; b_del.Enabled:= true; b_imp.Enabled:= true;
  end else begin
    b_mod.Enabled:= false; b_del.Enabled:= false; b_imp.Enabled:= false;
  end;
end;

end.


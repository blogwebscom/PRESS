unit prods;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, Buttons, DBGrids,
  StdCtrls, ExtCtrls, DBCtrls, ZDataset, JLabeledIntegerEdit, add_pd, LR_Class,
  LR_DBSet, LCLType;

type

  { Tf_prod }

  Tf_prod = class(TForm)
    b_bp: TBitBtn;
    b_del: TBitBtn;
    b_imp: TBitBtn;
    b_mod: TBitBtn;
    b_nvo: TBitBtn;
    drepo: TfrDBDataSet;
    drubros: TDataSource;
    lst_ord: TComboBox;
    lst_rub: TDBLookupComboBox;
    idp: TJLabeledIntegerEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    repo: TfrReport;
    Shape1: TShape;
    xnom: TLabeledEdit;
    dlista: TDataSource;
    lista: TDBGrid;
    pcan: TLabel;
    qlista: TZQuery;
    qrub: TZQuery;
    qexe: TZQuery;
    procedure b_bpClick(Sender: TObject);
    procedure b_delClick(Sender: TObject);
    procedure b_impClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_nvoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure idpEnter(Sender: TObject);
    procedure idpKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lst_ordSelect(Sender: TObject);
    procedure lst_rubSelect(Sender: TObject);
    procedure repoGetValue(const ParName: String; var ParValue: Variant);
    procedure xnomChange(Sender: TObject);
  private

  public
    procedure lista_p();
    procedure carga_rub();

  end;

var
  f_prod: Tf_prod;
  ord: string; // filtro x palabras

implementation

uses
  main;

{$R *.lfm}

{ Tf_prod }

procedure Tf_prod.FormActivate(Sender: TObject);
begin
  lista_p();
  carga_rub();
end;

procedure Tf_prod.idpEnter(Sender: TObject);
begin
  idp.SelectAll;
end;

procedure Tf_prod.idpKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
begin
  if Key = VK_RETURN then b_bp.SetFocus;
end;

procedure Tf_prod.lst_ordSelect(Sender: TObject);
begin
  lista_p();
end;

procedure Tf_prod.lst_rubSelect(Sender: TObject);
begin
  lista_p();
end;

procedure Tf_prod.xnomChange(Sender: TObject);
begin
  lista_p();
end;

procedure Tf_prod.b_nvoClick(Sender: TObject);
begin
  f_addp:= Tf_addp.Create(Self);
  f_addp.Caption:= 'AGREGANDO NUEVO PRODUCTO';
  f_addp.nvo_pd();
  f_addp.ShowModal;
end;

procedure Tf_prod.b_modClick(Sender: TObject);
begin
  if not qlista.IsEmpty then
  begin
    f_addp:= Tf_addp.Create(Self);
    f_addp.Caption:= 'MODIFICANDO PRODUCTO';
    // cargamos datos
    f_addp.idp.Value:= qlista.FieldByName('id_pd').Value;
    f_addp.cb.Text:= qlista.FieldByName('cbar').Text;
    f_addp.carga_rub(); // cargo antes
    f_addp.idr.Value:= qlista.FieldByName('id_rub').Value;
    f_addp.lst_rub.KeyValue:= qlista.FieldByName('id_rub').Value;
    f_addp.pdnom.Text:= qlista.FieldByName('pdnom').Text;
    f_addp.pc.Value:= qlista.FieldByName('pc').Value;
    f_addp.pv1.Value:= qlista.FieldByName('pv1').Value;
    f_addp.pv2.Value:= qlista.FieldByName('pv2').Value;
    f_addp.pv3.Value:= qlista.FieldByName('pv3').Value;
    f_addp.stk.Value:= qlista.FieldByName('stock').Value;
    f_addp.fec.Value:= qlista.FieldByName('fec').Value;
    f_addp.ShowModal;
  end;
end;

procedure Tf_prod.lista_p();
var
  fpal: string;
begin
  // orden
  case lst_ord.Text of
   'FECHA ASC': ord:= 'p.fec ASC';
   'FECHA DESC': ord:= 'p.fec DESC';
   'NOMBRE ASC': ord:= 'p.pdnom ASC';
   'NOMBRE DESC': ord:= 'p.pdnom DESC';
   'COD. ASC': ord:= 'p.id_pd ASC';
   'COD. DESC': ord:= 'p.id_pd DESC';
  end;
  // sentencia compleja con todos los filtros --------------------
  qlista.Close;
  if (xnom.Text <> '') then // con filtro de palabras
  begin
    fpal:= uppercase(trim(xnom.Text)); // Re-escribo la sentencia SQL
    qlista.SQL.Text:= 'SELECT p.*,r.* FROM PRODUCTOS p '+
    'INNER JOIN RUBROS r ON p.id_rub=r.id_rub ';
    if lst_rub.Text = '' then
      qlista.SQL.AddText('WHERE p.pdnom LIKE :PAL ORDER BY '+ord)
    else begin
      qlista.SQL.AddText('WHERE p.pdnom LIKE :PAL AND p.id_rub=:IR ORDER BY '+ord);
      qlista.ParamByName('IR').AsInteger:= lst_rub.KeyValue;
    end;
    qlista.ParamByName('PAL').AsString:= '%'+fpal+'%';
    // sin filtro de palabras  -------------------------------
  end else begin
    qlista.SQL.Text:= 'SELECT p.*,r.* FROM PRODUCTOS p '+
    'INNER JOIN RUBROS r ON p.id_rub=r.id_rub ';
    if lst_rub.Text <> '' then
    begin
      qlista.SQL.AddText('WHERE p.id_rub=:IR ORDER BY '+ord);
      qlista.ParamByName('IR').AsInteger:= lst_rub.KeyValue;
    end else
      qlista.SQL.AddText('ORDER BY '+ord);
    // --------------------------------------------------------
  end;
  //showmessage(qlista.SQL.Text);
  qlista.Open;
  pcan.Caption:= inttostr(qlista.RecordCount);
  // habilitaciones
  if not qlista.IsEmpty then
  begin
    b_mod.Enabled:= true; b_del.Enabled:= true; b_imp.Enabled:= true;
  end;
end;

procedure Tf_prod.b_delClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!', 'Está seguro que desea ELIMINAR el Producto:'+#13+#13+
  '- '+qlista.FieldByName('pdnom').Text+#13+#13+
  '[Este proceso es Irreversible]', mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // Elimina
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM productos WHERE id_pd=:IP';
    qexe.ParamByName('IP').AsInteger:= qlista.FieldByName('id_pd').Value;
    qexe.ExecSQL;
    lista_p();
  end;
end;

procedure Tf_prod.b_impClick(Sender: TObject);
begin
  repo.LoadFromFile(ExtractFilePath(Application.EXEName)+'inf\iprodus.lrf'); // plural
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

procedure Tf_prod.repoGetValue(const ParName: String; var ParValue: Variant);
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

procedure Tf_prod.b_bpClick(Sender: TObject);
begin
  if not qlista.IsEmpty then
    qlista.Locate('id_pd',idp.Value,[])
  else showmessage('No se puede localizar, la lista está vacia!');
end;

procedure Tf_prod.carga_rub();
begin
  qrub.Close;
  qrub.SQL.Text:= 'SELECT * FROM RUBROS ORDER BY rnom ASC';
  qrub.Open;
end;

end.


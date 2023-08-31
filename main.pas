unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  DBGrids, Buttons, DBCtrls, StdCtrls, JLabeledIntegerEdit, JLabeledFloatEdit,
  JLabeledDateEdit, ZDataset, ZConnection, prods, provs, cliens, rubros, add_pd,
  add_cl, sis, busca_pres, UniqueInstance, Grids, LCLType, Translations;

type

  { Tf_main }

  Tf_main = class(TForm)
    b_quita: TBitBtn;
    b_lp: TBitBtn;
    b_nc: TBitBtn;
    b_nvo: TBitBtn;
    b_mod: TBitBtn;
    b_del: TBitBtn;
    b_loc: TBitBtn;
    b_save: TBitBtn;
    b_imp: TBitBtn;
    b_bp: TBitBtn;
    b_add: TBitBtn;
    b_np: TBitBtn;
    b_bc: TBitBtn;
    stk: TJLabeledIntegerEdit;
    Label10: TLabel;
    lpv: TComboBox;
    Shape3: TShape;
    tm_sis: TMenuItem;
    pes: TComboBox;
    cv: TLabel;
    cp: TLabel;
    dtemp: TDataSource;
    dprods: TDataSource;
    dclien: TDataSource;
    dprovs: TDataSource;
    img_24: TImageList;
    img_32: TImageList;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lst_pv: TDBLookupComboBox;
    tp: TJLabeledFloatEdit;
    qtemp: TZQuery;
    tm_npre: TMenuItem;
    tm_bpre: TMenuItem;
    pde: TJLabeledFloatEdit;
    pfin: TJLabeledFloatEdit;
    pco: TJLabeledFloatEdit;
    qprovs: TZQuery;
    Shape2: TShape;
    pto: TJLabeledFloatEdit;
    idpres: TJLabeledIntegerEdit;
    fec: TJLabeledDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cc: TLabel;
    tm_cli: TMenuItem;
    tm_rub: TMenuItem;
    pcan: TLabel;
    lst_prod: TDBLookupComboBox;
    Label1: TLabel;
    lst_cli: TDBLookupComboBox;
    idp: TJLabeledIntegerEdit;
    cbar: TLabeledEdit;
    can: TJLabeledIntegerEdit;
    dlista: TDataSource;
    lista: TDBGrid;
    tm_pres: TMenuItem;
    tm_q: TMenuItem;
    tm_prov: TMenuItem;
    tm_prod: TMenuItem;
    mp: TMenuItem;
    qprods: TZQuery;
    Separator1: TMenuItem;
    Shape1: TShape;
    sub: TJLabeledFloatEdit;
    pve: TJLabeledFloatEdit;
    topmenu: TMainMenu;
    qlista: TZQuery;
    conex: TZConnection;
    qclien: TZQuery;
    UniqueInstance1: TUniqueInstance;
    qexe: TZQuery;
    procedure b_addClick(Sender: TObject);
    procedure b_bcClick(Sender: TObject);
    procedure b_bpClick(Sender: TObject);
    procedure b_delClick(Sender: TObject);
    procedure b_locClick(Sender: TObject);
    procedure b_lpClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_ncClick(Sender: TObject);
    procedure b_npClick(Sender: TObject);
    procedure b_nvoClick(Sender: TObject);
    procedure b_quitaClick(Sender: TObject);
    procedure b_saveClick(Sender: TObject);
    procedure canExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure idpClick(Sender: TObject);
    procedure idpEnter(Sender: TObject);
    procedure idpKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure idpresEnter(Sender: TObject);
    procedure idpresKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure listaPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
    procedure lpvSelect(Sender: TObject);
    procedure lst_prodSelect(Sender: TObject);
    procedure tm_bpreClick(Sender: TObject);
    procedure tm_cliClick(Sender: TObject);
    procedure tm_npreClick(Sender: TObject);
    procedure tm_prodClick(Sender: TObject);
    procedure tm_provClick(Sender: TObject);
    procedure tm_rubClick(Sender: TObject);
    procedure pdeExit(Sender: TObject);
    procedure pveExit(Sender: TObject);
    procedure tm_sisClick(Sender: TObject);
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; const Parameters: array of String);
  private
    procedure Traduccion_es();

  public
    procedure carga_cli();
    procedure carga_pd();
    procedure carga_pv();
    procedure nvo_pres();
    procedure carga_lista();
    procedure vacia_temp();
    procedure limpia();
    procedure add_prod();
    procedure loc_pres();
    // -------------------------> se pueden crear procesos para HAB y DESHAB componenetes!

  end;

var
  f_main: Tf_main;
  dup, OP: char;

implementation

{$R *.lfm}

{ Tf_main }

procedure Tf_main.FormActivate(Sender: TObject);
begin
  { Conexion base de datos local }
  conex.HostName:= '';
  conex.Database:= ExtractFilePath(Application.EXEName)+'db\press.db';
  conex.LibLocation:= ExtractFilePath(Application.EXEName)+'db\sqlite3.dll'; // solo 64 bits
  try
    conex.Connect;
  except
    showmessage('Error! No se pudo conectar con la Base de Datos!'+#13
    +'El sistema se cerrará, contacte con el soporte técnico.'+#13
    +'Dacom Sistema - Email: dacom.tuc@gmail.com');
    close();
  end;
  if conex.Connected then
  begin
    {Configuraciones}
    DefaultFormatSettings.DecimalSeparator:= ',';
    DefaultFormatSettings.ThousandSeparator:= '.';
    // Variables
    dup:= 'N';
    {Carga de Datos // Aquí no en el inicio, solo pruebas}
    {carga_cli(); carga_pd(); carga_pv();}
    b_nvo.SetFocus;
  end;
end;

procedure Tf_main.FormCreate(Sender: TObject);
begin
  Traduccion_es();
end;

procedure Tf_main.Traduccion_es();
begin
  TranslateUnitResourceStrings('LclStrConsts','es/lclstrconsts.es.po');
  TranslateUnitResourceStrings('lr_const','es/lr_const.es.po');
  TranslateUnitResourceStrings('printer4lazstrconst','es/printer4lazstrconst.es.po');
  TranslateUnitResourceStrings('jinputconsts','es/jinputconsts.es.po');
end;

procedure Tf_main.idpClick(Sender: TObject);
begin
  idp.SelectAll;
end;

procedure Tf_main.idpEnter(Sender: TObject);
begin
  idp.SelectAll;
end;

procedure Tf_main.idpKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
begin
  if Key = VK_RETURN then b_bp.SetFocus;
end;

procedure Tf_main.idpresKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
begin
  if Key = VK_RETURN then b_lp.SetFocus;
end;

procedure Tf_main.idpresEnter(Sender: TObject);
begin
  idpres.SelectAll;
end;

procedure Tf_main.listaPrepareCanvas(sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  if ([gdSelected, gdFocused] * AState <> []) then
  begin
    if dup = 'N' then
    begin
      lista.Canvas.Brush.Color := $00FFF9EA;
      lista.Canvas.Font.Color := clBlack;
    end else begin
      lista.Canvas.Brush.Color := $003535FF; // cambio el color cuando hay duplicado
      lista.Canvas.Font.Color := clWhite;
    end;
  end else begin
    lista.Canvas.Brush.Color := clWhite;
    lista.Canvas.Font.Color := clBlack;
  end;
end;

procedure Tf_main.lst_prodSelect(Sender: TObject);
begin
  // CARGAMOS datos del prod. seleccionado --------
  if lst_prod.Text <> '' then
  begin
    qexe.Close;
    qexe.SQL.Text:= 'SELECT * FROM PRODUCTOS WHERE id_pd=:IP';
    qexe.ParamByName('IP').AsInteger:= lst_prod.KeyValue;
    qexe.Open;
    // -------
    idp.Value:= qexe.FieldByName('id_pd').Value;
    cbar.Text:= qexe.FieldByName('cbar').Text;
    //lst_prod.KeyValue:= qexe.FieldByName('id_pd').Value;
    pco.Value:= qexe.FieldByName('pc').Value;
    if lpv.Text = '$ VENTA 1' then pve.Value:= qexe.FieldByName('pv1').Value
    else
      if lpv.Text = '$ VENTA 2' then pve.Value:= qexe.FieldByName('pv2').Value
      else pve.Value:= qexe.FieldByName('pv3').Value;
    lpv.Enabled:= true;
    pfin.Value:= pve.Value;
  end;
end;

procedure Tf_main.tm_prodClick(Sender: TObject);
begin
  f_prod:= Tf_prod.Create(Self);
  f_prod.ShowModal;
end;

procedure Tf_main.b_bcClick(Sender: TObject);
begin
  // Busca Cliente
  f_cli:= Tf_cli.Create(Self);
  f_cli.Caption:= 'Viendo Clientes';
  f_cli.b_nvo.Caption:= 'Seleccionar';
  f_cli.b_mod.Enabled:= false;
  f_cli.b_del.Enabled:= false;
  f_cli.b_imp.Enabled:= false;
  f_cli.ShowModal
end;

procedure Tf_main.b_addClick(Sender: TObject);
begin
  // vacios/obligatorios!
  if idp.Value <> 0 then
  begin
    if lst_pv.Text <> '' then
    begin
      if can.Value > 0 then
      begin
        // Control de Stock máximo
        if can.Value > stk.Value then
        begin
          MessageDlg('ATENCION!','La Cantidad que intenta cargar supera el Stock Actual!',mtError,[mbOk],0);
          can.SetFocus;
        end else begin
          // Control que el producto no este cargado antes!
          qexe.Close;
          qexe.SQL.Text:= 'SELECT id_pd FROM PTEMP WHERE id_pd=:IP';
          qexe.ParamByName('IP').AsInteger:= idp.Value;
          qexe.Open;
          if qexe.IsEmpty then
          begin
            dup:= 'N';
            // OK, cargamos.
            add_prod();
            carga_lista();
            limpia();
          end else begin
            dup:= 'S';
            qtemp.Locate('id_pd',idp.Value,[]);
            // Pregunta ?
            if MessageDlg('ATENCION!!','El Producto que intenta ingresar ya se encuentra cargado.'+#13+#13+
            '- '+lst_prod.Text+#13+#13+'Desea cargarlo de forma diferenciada?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
            begin
              // Actualizamos los valores del mismo producto
              add_prod();
              dup:= 'N';
              carga_lista();
              qtemp.Locate('id_pd',idp.Value,[]);
              limpia();
            end;
          end;
          // Continuamos? ....
          if MessageDlg('Continuamos?...','Desea cargar otro Producto a este Presupuesto?',
          mtConfirmation,[mbYes, mbNo],0) = mrYes then idp.SetFocus
          else b_save.SetFocus;
          // FINAL
        end;
      end else begin
        MessageDlg('ATENCION!','La Cantidad NO puede ser Cero!',mtError,[mbOk],0);
        can.SetFocus;
      end;
    end else begin
      MessageDlg('ATENCION!','Debe seleccionar un Proveedor del Producto!',mtError,[mbOk],0);
      lst_pv.SetFocus;
    end;
  end else begin
    MessageDlg('ATENCION!','Selecione un Producto para Agregar!',mtError,[mbOk],0);
    idp.SetFocus;
  end;
end;

procedure Tf_main.add_prod();
begin
  qexe.Close;
  qexe.SQL.Text:= 'INSERT INTO PTEMP(id_pres,id_pd,pdnom,pvnom,pc,can,pv,sub,desc,total) '+
  'VALUES(:IP,:ID,:PDN,:PVN,:PC,:CAN,:PV,:SUB,:DS,:TO)';
  qexe.ParamByName('IP').AsInteger:= idpres.Value;
  qexe.ParamByName('ID').AsInteger:= idp.Value;
  qexe.ParamByName('PDN').AsString:= lst_prod.Text;
  qexe.ParamByName('PVN').AsString:= lst_pv.Text;
  qexe.ParamByName('PC').AsFloat:= pco.Value;
  qexe.ParamByName('CAN').AsInteger:= can.Value;
  qexe.ParamByName('PV').AsFloat:= pfin.Value;
  qexe.ParamByName('SUB').AsFloat:= sub.Value;
  qexe.ParamByName('DS').AsFloat:= pde.Value;
  qexe.ParamByName('TO').AsFloat:= pto.Value;
  qexe.ExecSQL;
end;

procedure Tf_main.loc_pres();
begin
  vacia_temp();
  // showmessage('Cod. '+inttostr(idpres.Value));
  qlista.Close;
  qlista.SQL.Text:= 'SELECT p.*,d.* FROM presupuestos AS p '+
  'INNER JOIN presdetalle AS d ON p.id_pres=d.id_pres '+
  'WHERE p.id_pres=:IP';
  qlista.ParamByName('IP').AsInteger:= idpres.Value;
  qlista.Open;
  if not qlista.IsEmpty then
  begin
    // Datos del Presup ------------------------------------
    fec.Value:= qlista.FieldByName('fec').Value;
    lst_cli.Text:= qlista.FieldByName('ncli').Text;
    pes.Text:= qlista.FieldByName('estado').Text;
    tp.Value:= qlista.FieldByName('monto').Value;
    // Carga Detalle en -------------- Tabla TEMPORAL
    while not qlista.EOF do
    begin
      qexe.Close;
      qexe.SQL.Text:= 'INSERT INTO PTEMP(id_pres,id_pd,pdnom,pvnom,pc,can,pv,sub,desc,total) '+
      'VALUES(:IP,:ID,:PDN,:PVN,:PC,:CAN,:PV,:SUB,:DS,:TO)';
      qexe.ParamByName('IP').AsInteger:= idpres.Value;
      qexe.ParamByName('ID').AsInteger:= qlista.FieldByName('id_pd').Value;
      qexe.ParamByName('PDN').AsString:= qlista.FieldByName('pdnom').Value;
      qexe.ParamByName('PVN').AsString:= qlista.FieldByName('pvnom').Value;
      qexe.ParamByName('PC').AsFloat:= qlista.FieldByName('pc').Value;
      qexe.ParamByName('CAN').AsInteger:= qlista.FieldByName('can').Value;
      qexe.ParamByName('PV').AsFloat:= qlista.FieldByName('pv').Value;
      qexe.ParamByName('SUB').AsFloat:= qlista.FieldByName('sub').Value;
      qexe.ParamByName('DS').AsFloat:= qlista.FieldByName('desc').Value;
      qexe.ParamByName('TO').AsFloat:= qlista.FieldByName('total').Value;
      qexe.ExecSQL;
     qlista.Next;
    end;
    // cargamos datos en Temp
    carga_lista();
    // habilitaciones
    b_mod.Enabled:= true; b_del.Enabled:= true;
    b_imp.Enabled:= true;
  end else begin
    showmessage('No se encontró Ningún Presupuesto con el Código ingresado!'+#13+
    '-> Cod: '+inttostr(idpres.Value));
  end;
end;

procedure Tf_main.b_lpClick(Sender: TObject);
begin
  loc_pres();
end;

procedure Tf_main.tm_bpreClick(Sender: TObject);
begin
  f_bpre:= Tf_bpre.Create(Self);
  f_bpre.ShowModal;
  if not idpres.Value <> 0 then loc_pres()
  else showmessage('Ha ocurrido un error con la búsqueda!');
end;

procedure Tf_main.carga_lista();
begin
  qtemp.Close;
  qtemp.SQL.Text:= 'SELECT *,(SELECT SUM(total) FROM PTEMP) AS top FROM ptemp ORDER BY pdnom ASC';
  qtemp.Open;
  pcan.Caption:= inttostr(qtemp.RecordCount);
  tp.Value:= qtemp.FieldByName('top').Value;
end;

procedure Tf_main.b_bpClick(Sender: TObject);
begin
  // busca producto por cod. interno
  if idp.Value <> 0 then
  begin
    qexe.Close;
    qexe.SQL.Text:= 'SELECT * FROM PRODUCTOS WHERE id_pd=:IP';
    qexe.ParamByName('IP').AsInteger:= idp.Value;
    qexe.Open;
    if not qexe.IsEmpty then
    begin
      cbar.Text:= qexe.FieldByName('cbar').Text;
      lst_prod.KeyValue:= qexe.FieldByName('id_pd').Value;
      pco.Value:= qexe.FieldByName('pc').Value;
      if lpv.Text = '$ VENTA 1' then pve.Value:= qexe.FieldByName('pv1').Value
      else
        if lpv.Text = '$ VENTA 2' then pve.Value:= qexe.FieldByName('pv2').Value
        else pve.Value:= qexe.FieldByName('pv3').Value;
      // STOCK!
      stk.Value:= qexe.FieldByName('stock').Value;
      // ----- Habilitaciones
      lpv.Enabled:= true;
      pfin.Value:= pve.Value;
      lst_pv.SetFocus;
      //pfin.SetFocus;
      // ------------------------------------------------
    end else begin
      lpv.Enabled:= false;
      showmessage('No se encontró Ningún Producto con el Código ingresado!'+#13+
      '-> Cod: '+inttostr(idp.Value));
      limpia();
    end;
  end;
end;

procedure Tf_main.b_delClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!', 'Está seguro que desea ELIMINAR el Presupuesto:'+#13+#13+
  '[Nº '+inttostr(idpres.Value)+'] - Este proceso es Irreversible!',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    // Elimina Presupuesto
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM presupuestos WHERE id_pres=:IP';
    qexe.ParamByName('IP').AsInteger:= idpres.Value;
    qexe.ExecSQL;
    // Elimina DETALLE
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM presdetalle WHERE id_pres=:IP';
    qexe.ParamByName('IP').AsInteger:= idpres.Value;
    qexe.ExecSQL;
    // Restaura STOCK de Productos
    if MessageDlg('ATENCION!!', 'Desea Restaurar el Stock de Productos?'+#13+
    '[Los productos cargados en este presupuesto vuelven al inventario]',mtConfirmation,[mbYes, mbNo],0) = mrYes then
    begin
      qtemp.First;
      while not qtemp.EOF do
      begin
        showmessage('Producto: '+#13+qtemp.FieldByName('pdnom').Text+#13+
        'Cantidad a restaurar -> '+inttostr(qtemp.FieldByName('can').Value));
        qexe.Close;
        qexe.SQL.Text:= 'UPDATE productos SET stock=stock+:RES WHERE id_pd=:IP';
        qexe.ParamByName('IP').AsInteger:= qtemp.FieldByName('id_pd').Value;
        qexe.ParamByName('RES').AsInteger:= qtemp.FieldByName('can').Value;
        qexe.ExecSQL;
       qtemp.Next;
      end;
    end;
    showmessage('OK, Presupuesto Eliminado Correctamente!');
    // limpieza
    idpres.Value:= 0; fec.Value:= 0; lst_cli.Text:= '';
    vacia_temp();
    b_mod.Enabled:= false; b_del.Enabled:= false;
    b_imp.Enabled:= false;
  end;
end;

procedure Tf_main.b_locClick(Sender: TObject);
begin
  idpres.Enabled:= true;
  idpres.ReadOnly:= false;
  b_lp.Enabled:= true;
  MessageDlg('ATENCION!','Indique el COD. INTERNO del Presupuesto,'+#13+
  'Y luego presione la Lupa para Buscar.',mtinformation,[mbOk],0);
  idpres.SetFocus;
end;

procedure Tf_main.lpvSelect(Sender: TObject);
begin
  case lpv.Text of
   '$ VENTA 1': begin
     pve.Value:= qexe.FieldByName('pv1').Value;
     pfin.Value:= 0;
     pfin.SetFocus;
   end;
   '$ VENTA 2': begin
     pve.Value:= qexe.FieldByName('pv2').Value;
     pfin.Value:= 0;
     pfin.SetFocus;
   end;
   '$ VENTA 3': begin
     pve.Value:= qexe.FieldByName('pv3').Value;
     pfin.Value:= 0;
     pfin.SetFocus;
   end;
  end;
end;

procedure Tf_main.b_ncClick(Sender: TObject);
begin
  // Nuevo Cliente
  f_addc:= Tf_addc.Create(Self);
  f_addc.Caption:= 'Creando Nuevo Cliente';
  f_addc.nvo_clien();
  f_addc.ShowModal;
end;

procedure Tf_main.b_npClick(Sender: TObject);
begin
  f_addp:= Tf_addp.Create(Self);
  f_addp.ShowModal;
end;

procedure Tf_main.b_nvoClick(Sender: TObject);
begin
  // Habilitaciones
  idpres.Enabled:= true; stk.Enabled:= true;
  fec.Enabled:= true; fec.Button.Enabled:= true;
  lst_cli.Enabled:= true; lpv.Enabled:= true;
  b_bc.Enabled:= true; b_nc.Enabled:= true;
  idp.Enabled:= true; b_bp.Enabled:= true;
  cbar.Enabled:= true; lst_prod.Enabled:= true;
  pco.Enabled:= true; b_lp.Enabled:= false;
  pve.Enabled:= true; pfin.Enabled:= true; can.Enabled:= true;
  sub.Enabled:= true; pde.Enabled:= true; pto.Enabled:= true;
  lst_pv.Enabled:= true; pes.Enabled:= true;
  b_add.Enabled:= true; b_loc.Enabled:= false;
  b_np.Enabled:= true; b_nvo.Enabled:= false; b_mod.Enabled:= false;
  b_save.Enabled:= true; b_del.Enabled:= false; b_imp.Enabled:= false;
  // Carga combos y demas datos --------------------------------------
  vacia_temp();
  carga_cli();
  carga_pd();
  carga_pv();
  nvo_pres();
  fec.Value:= date();
  OP:= 'N';
  lst_cli.SetFocus;
end;

procedure Tf_main.b_quitaClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!', 'Está seguro que desea QUITAR el producto:'+#13+#13+
  '- '+qtemp.FieldByName('pdnom').Text,mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM ptemp WHERE id_pd=:IP';
    qexe.ParamByName('IP').AsInteger:= qtemp.FieldByName('id_pd').Value;
    qexe.ExecSQL;
    // recarga...
    carga_lista();
  end;
end;

procedure Tf_main.b_modClick(Sender: TObject);
begin
   // Habilitaciones
  idpres.Enabled:= false; stk.Enabled:= true;
  fec.Enabled:= true; fec.Button.Enabled:= true;
  lst_cli.Enabled:= true; lpv.Enabled:= true;
  b_bc.Enabled:= true; b_nc.Enabled:= true;
  idp.Enabled:= true; b_bp.Enabled:= true;
  cbar.Enabled:= true; lst_prod.Enabled:= true;
  pco.Enabled:= true; b_lp.Enabled:= false;
  pve.Enabled:= true; pfin.Enabled:= true; can.Enabled:= true;
  sub.Enabled:= true; pde.Enabled:= true; pto.Enabled:= true;
  lst_pv.Enabled:= true; pes.Enabled:= true;
  b_add.Enabled:= true; b_quita.Enabled:= true;
  b_np.Enabled:= true; b_nvo.Enabled:= false; b_mod.Enabled:= false;
  b_save.Enabled:= true; b_del.Enabled:= false; b_imp.Enabled:= false;
  // Carga combos y demas datos --------------------------------------
  if qclien.IsEmpty then carga_cli();
  if qprods.IsEmpty then carga_pd();
  if qprovs.IsEmpty then carga_pv();
  OP:= 'E';
  showmessage('Edite los Datos y Luego Guarde los cambios');
end;

procedure Tf_main.b_saveClick(Sender: TObject);
var
  msje: string;
begin
  // Control Vacios?
  {---------------------------------------------Guarda el Presupuesto}
  qexe.Close;
  if OP = 'N' then // Nuevo Presupuesto
  begin
    qexe.SQL.Text:= 'INSERT INTO PRESUPUESTOS(fec,ncli,monto,estado) VALUES(:FE,:NC,:MO,:ES)';
    msje:= 'Nuevo Presupuesto Nº '+inttostr(idpres.Value)+' Guardado Correctamente!';
  end else begin   // Modifica Presupuesto
    qexe.SQL.Text:= 'UPDATE PRESUPUESTOS SET fec=:FE,ncli=:NC,monto=:MO,estado=:ES '+
    'WHERE id_pres=:IP';
    qexe.ParamByName('IP').AsInteger:= idpres.Value;
    msje:= 'Presupuesto Nº '+inttostr(idpres.Value)+' Modificado Correctamente!';
  end;
  // Parametros
  qexe.ParamByName('FE').AsDate:= fec.Value;
  qexe.ParamByName('NC').AsString:= lst_cli.Text;
  qexe.ParamByName('MO').AsFloat:= tp.Value;
  qexe.ParamByName('ES').AsString:= pes.Text;
  qexe.ExecSQL;
  {---------------------------------------------Guarda el DETALLE}
  qexe.Close;
  if OP = 'E' then // Modificando Presp. el detalle se borra y se vuelve a cargar
  begin
    qexe.SQL.Text:= 'DELETE FROM PRESDETALLE WHERE id_pres=:ID';
    qexe.ParamByName('IP').AsInteger:= idpres.Value;
    qexe.ExecSQL;
  end;
  // Insertamos lista de productos
  qtemp.First;
  while not qtemp.EOF do
  begin
    qexe.Close;
    qexe.SQL.Text:= 'INSERT INTO PRESDETALLE(id_pres,id_pd,pdnom,pvnom,pc,can,pv,sub,desc,total) '+
    'VALUES(:ID,:IP,:PN,:PR,:PC,:CA,:PV,:SB,:DE,:TO)';
    // Parametros
    qexe.ParamByName('ID').AsInteger:= qtemp.FieldByName('id_pres').Value;
    qexe.ParamByName('IP').AsString:= qtemp.FieldByName('id_pd').Value;
    qexe.ParamByName('PN').AsString:= qtemp.FieldByName('pdnom').Text;
    qexe.ParamByName('PR').AsString:= qtemp.FieldByName('pvnom').Text;
    qexe.ParamByName('PC').AsFloat:= qtemp.FieldByName('pc').Value;
    qexe.ParamByName('CA').AsInteger:= qtemp.FieldByName('can').Value;
    qexe.ParamByName('PV').AsFloat:= qtemp.FieldByName('pv').Value;
    qexe.ParamByName('SB').AsFloat:= qtemp.FieldByName('sub').Value;
    qexe.ParamByName('DE').AsFloat:= qtemp.FieldByName('desc').Value;
    qexe.ParamByName('TO').AsFloat:= qtemp.FieldByName('total').Value;
    qexe.ExecSQL;
    if OP = 'E' then // Modificando Presp. el stock regresa
    begin
      qexe.Close;
      qexe.SQL.Text:= 'UPDATE productos SET stock=stock+:RES WHERE id_pd=:IP';
      qexe.ParamByName('IP').AsInteger:= qtemp.FieldByName('id_pd').Value;
      qexe.ParamByName('RES').AsInteger:= qtemp.FieldByName('can').Value;
      qexe.ExecSQL;
    end;
    // Restamos el Stock de producto
    qexe.Close;
    qexe.SQL.Text:= 'UPDATE PRODUCTOS SET stock=stock-:RES WHERE id_pd=:IP';
    qexe.ParamByName('IP').AsString:= qtemp.FieldByName('id_pd').Value;
    qexe.ParamByName('RES').AsInteger:= qtemp.FieldByName('can').Value;
    qexe.ExecSQL;
    // ...
    qtemp.Next;
  end;
  // OK
  showmessage(msje);
  // Des-Habilitaciones -----
  idpres.Enabled:= false; stk.Enabled:= false;
  fec.Enabled:= false; fec.Button.Enabled:= false;
  lst_cli.Enabled:= false; b_bc.Enabled:= false; b_nc.Enabled:= false;
  idp.Enabled:= false; b_bp.Enabled:= false; b_quita.Enabled:= false;
  cbar.Enabled:= false; lst_prod.Enabled:= false;
  lpv.Enabled:= false; pco.Enabled:= false;
  pve.Enabled:= false; pfin.Enabled:= false; can.Enabled:= false;
  sub.Enabled:= false; pde.Enabled:= false; pto.Enabled:= false;
  lst_pv.Enabled:= false; pes.Enabled:= false;
  b_add.Enabled:= false; b_np.Enabled:= false; b_loc.Enabled:= true;
  b_nvo.Enabled:= true; b_mod.Enabled:= true; b_del.Enabled:= true;
  b_save.Enabled:= false; b_imp.Enabled:= true;
end;

procedure Tf_main.canExit(Sender: TObject);
begin
  sub.Value:= 0;
  sub.Value:= pfin.Value * can.CurrentValue;
end;

procedure Tf_main.pdeExit(Sender: TObject);
begin
  pto.Value:= sub.Value - (sub.Value*(pde.CurrentValue/100));
end;

procedure Tf_main.pveExit(Sender: TObject);
begin
  pfin.Value:= pve.CurrentValue;
end;

procedure Tf_main.tm_sisClick(Sender: TObject);
begin
  f_sis:= Tf_sis.Create(Self);
  f_sis.ShowModal;
end;

procedure Tf_main.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; const Parameters: array of String);
begin
  ShowMessage('El programa ya se encuentra en ejecución!');
  BringToFront;
  FormStyle:= fsSystemStayOnTop;
  FormStyle:= fsNormal;
end;

procedure Tf_main.tm_npreClick(Sender: TObject);
begin
  // habilitaciones
  idpres.Enabled:= true; stk.Enabled:= true;
  fec.Enabled:= true; fec.Button.Enabled:= true;
  lst_cli.Enabled:= true; lpv.Enabled:= true;
  b_bc.Enabled:= true; b_nc.Enabled:= true;
  idp.Enabled:= true; b_bp.Enabled:= true;
  cbar.Enabled:= true; lst_prod.Enabled:= true;
  pco.Enabled:= true;
  pve.Enabled:= true; pfin.Enabled:= true; can.Enabled:= true;
  sub.Enabled:= true; pde.Enabled:= true; pto.Enabled:= true;
  lst_pv.Enabled:= true; pes.Enabled:= true; b_add.Enabled:= true;
  b_np.Enabled:= true; b_nvo.Enabled:= false; b_mod.Enabled:= false;
  b_save.Enabled:= true; b_del.Enabled:= false; b_imp.Enabled:= false;
  // Carga combos y demas datos --------------------------------------
  vacia_temp();
  carga_cli();
  carga_pd();
  carga_pv();
  nvo_pres();
  fec.Value:= date();
  OP:= 'N';
  lst_cli.SetFocus;
end;

procedure Tf_main.tm_provClick(Sender: TObject);
begin
  f_prov:= Tf_prov.Create(Self);
  f_prov.ShowModal;
end;

procedure Tf_main.tm_rubClick(Sender: TObject);
begin
  f_rub:= Tf_rub.Create(Self);
  f_rub.ShowModal;
end;

procedure Tf_main.carga_cli();
begin
  qclien.Close;
  qclien.SQL.Text:= 'SELECT * FROM CLIENTES ORDER BY cnom ASC';
  qclien.Open;
  cc.Caption:= inttostr(qclien.RecordCount);
end;

procedure Tf_main.carga_pd();
begin
  qprods.Close;
  qprods.SQL.Text:= 'SELECT * FROM PRODUCTOS ORDER BY pdnom ASC';
  qprods.Open;
  cp.Caption:= inttostr(qprods.RecordCount);
end;

procedure Tf_main.carga_pv();
begin
  qprovs.Close;
  qprovs.SQL.Text:= 'SELECT * FROM PROVEEDORES ORDER BY pvnom ASC';
  qprovs.Open;
  cv.Caption:= inttostr(qprovs.RecordCount);
end;

procedure Tf_main.nvo_pres();
begin
  // El mejor metodo real cuando se eliminan filas de una tabla!
  qexe.Close;
  qexe.SQL.Text:= 'SELECT * FROM sqlite_sequence WHERE name=''PRESUPUESTOS''';
  qexe.Open;
  if qexe.FieldByName('seq').IsNull then idpres.Value:= 1 // <-- FIX Null
  else idpres.Value:= qexe.FieldByName('seq').Value + 1;
end;

procedure Tf_main.vacia_temp();
begin
  qtemp.Close;
  qtemp.SQL.Text:= 'DELETE FROM PTEMP';
  qtemp.ExecSQL;
end;

procedure Tf_main.limpia(); // Este se usa para cuando se estan cargando productos
begin
  idp.Value:= 0; cbar.Text:= ''; lst_prod.Text:= ''; pco.Value:= 0;
  pve.Value:= 0; pfin.Value:= 0; can.Value:= 0; sub.Value:= 0;
  pde.Value:= 0; pto.Value:= 0; lst_pv.Text:= ''; stk.Value:= 0;
  idp.SetFocus;
end;

procedure Tf_main.tm_cliClick(Sender: TObject);
begin
  f_cli:= Tf_cli.Create(Self);
  f_cli.ShowModal;
end;

end.


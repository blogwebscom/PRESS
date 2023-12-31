unit sis;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ExtDlgs, Buttons, ZDataset, sqlite3backup;

type

  { Tf_sis }

  Tf_sis = class(TForm)
    bkok: TLabel;
    b_bk: TButton;
    b_mod: TBitBtn;
    b_re: TButton;
    b_save: TBitBtn;
    b_va: TButton;
    b_vat: TButton;
    ck_pd: TCheckBox;
    ck_cl: TCheckBox;
    ck_pv: TCheckBox;
    ck_ru: TCheckBox;
    ea: TLabeledEdit;
    ed: TLabeledEdit;
    em: TLabeledEdit;
    en: TLabeledEdit;
    ep: TLabeledEdit;
    et: TLabeledEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    locimg: TOpenPictureDialog;
    qexe1: TZQuery;
    reok: TLabel;
    Shape6: TShape;
    Shape7: TShape;
    tcl: TLabel;
    tpv: TLabel;
    tru: TLabel;
    vok: TLabel;
    SelBK: TOpenDialog;
    Shape4: TShape;
    Shape5: TShape;
    sqll3: TSQLite3Connection;
    qexe: TZQuery;
    tpd: TLabel;
    procedure b_bkClick(Sender: TObject);
    procedure b_modClick(Sender: TObject);
    procedure b_reClick(Sender: TObject);
    procedure b_saveClick(Sender: TObject);
    procedure b_vaClick(Sender: TObject);
    procedure b_vatClick(Sender: TObject);
  private

  public

  end;

var
  f_sis: Tf_sis;

implementation

uses
  main;

{$R *.lfm}

{ Tf_sis }

procedure Tf_sis.b_bkClick(Sender: TObject);
var
  BKFolder: string;
  bk: TSQLite3Backup;
begin
  {Configuración y Conexion con la DB actual}
  BKFolder:= ExtractFileDir(Application.ExeName)+'\db\';
  sqll3.DatabaseName:= BKFolder+'press.db';
  sqll3.Open;
  if sqll3.Connected then
  begin
    bk:= TSQLite3Backup.Create;
    try
      bk.Backup(sqll3,BKFolder+'BK_'+FormatDateTime('yyyyMMDD_HHmm',Now)+'.db', False);
      MessageDlg('Aviso','Copia de Seguridad creada correctamente!',mtInformation,[mbOK],0);
      bkok.Caption:= 'OK';
    finally
      bk.Free;
    end;
  end else
    MessageDlg('ATENCION!','ERROR: No se pudo realizar el respaldo...'+#13+
    'Contacte con el soporte técnico:'+#13+
    'Webscom Sistemas - Email: webscom.ar@gmail.com',mtError,[mbOK],0);
end;

procedure Tf_sis.b_modClick(Sender: TObject);
var
  i: byte;
begin
  {Habilita}
  for i:= 1 to  ComponentCount - 1 do
  if Components[i] is TLabeledEdit then
  begin
    TLabeledEdit(Components[i]).Enabled:= true;
    TLabeledEdit(Components[i]).Font.Color:= clBlack;
  end;
  // ----
  b_mod.Enabled:= false;
  b_save.Enabled:= true;
  en.SetFocus;
end;

procedure Tf_sis.b_reClick(Sender: TObject);
var
  BKFolder, fileBK: string;
  re: TSQLite3Backup;
begin
  BKFolder:= ExtractFileDir(Application.ExeName)+'\db\';
  sqll3.DatabaseName:= BKFolder+'press.db'; // conecta con la base de datos nativa
  sqll3.Open;
  if sqll3.Connected then
  begin
    {Selección de Archivo de respaldo}
    selBK.InitialDir:= BKFolder;
    if selBK.Execute then
      fileBK:= selBK.FileName;
    if fileBK <> '' then  // No Vacio
    begin
      re:= TSQLite3Backup.Create;
      re.Restore(fileBK,sqll3,true);
      f_main.conex.Reconnect;
      MessageDlg('ATENCION','OK! Restauracion Finalizada!',mtInformation,[mbOK],0);
      reok.Caption:= 'OK';
    end;
  end;
end;

procedure Tf_sis.b_saveClick(Sender: TObject);
var
  i: byte;
begin
  qexe.Close;
  qexe.SQL.Text:= 'UPDATE SISTEMA SET enom=:NO, edire=:DI, etel=:TE,'+
  'email=:EM, eweb=:WE, einfo=:IN, elogo=:LO WHERE id_sys=1';
  qexe.ParamByName('NO').AsString:= trim(en.Text);
  qexe.ParamByName('DI').AsString:= trim(ed.Text);
  qexe.ParamByName('TE').AsString:= trim(et.Text);
  qexe.ParamByName('EM').AsString:= trim(em.Text);
  qexe.ParamByName('WE').AsString:= trim(ep.Text);
  qexe.ParamByName('LO').AsString:= 'sin_logo';
  qexe.ParamByName('IN').AsString:= trim(ea.Text);
  qexe.ExecSQL;
  // Recargamos en main
  f_main.datos_inf();
  showmessage('OK, lo Datos fueron modificados con éxito.');
  {Deshabilitaciones}
  for i:= 1 to  ComponentCount - 1 do
  if Components[i] is TLabeledEdit then
  begin
    TLabeledEdit(Components[i]).Enabled:= false;
    TLabeledEdit(Components[i]).Font.Color:= clBlue;
  end;
  // ----
  b_mod.Enabled:= true;
  b_save.Enabled:= false;
end;

procedure Tf_sis.b_vaClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!','Está seguro que desea VACIAR la Tabla?'+#13#13+
  'Este proceso es irreversible!',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // PRESUPUESTOS
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM PRESUPUESTOS';
    qexe.ExecSQL;
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''PRESUPUESTOS''';
    qexe.ExecSQL;
    // PRESUPUESTOS
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM PRESDETALLE';
    qexe.ExecSQL;
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''PRESDETALLE''';
    qexe.ExecSQL;
    vok.Caption:= 'OK';
  end;
end;

procedure Tf_sis.b_vatClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!','Está seguro que desea VACIAR las tablas seleccionadas?'+#13#13+
  'Este proceso afecta a todo el sistema y es irreversible!',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // PRODUCTOS
    if ck_pd.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM PRODUCTOS';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''PRODUCTOS''';
      qexe.ExecSQL;
      tpd.Caption:= 'OK';
    end;
    // CLIENTES
    if ck_cl.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM CLIENTES';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''CLIENTES''';
      qexe.ExecSQL;
      tcl.Caption:= 'OK';
    end;
    // PROVEEDORES
    if ck_pv.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM PROVEEDORES';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''PROVEEDORES''';
      qexe.ExecSQL;
      tpv.Caption:= 'OK';
    end;
    // RUBROS
    if ck_ru.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM RUBROS';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''RUBROS''';
      qexe.ExecSQL;
      tru.Caption:= 'OK';
    end;
  end;
end;

end.


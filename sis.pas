unit sis;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset, sqlite3backup;

type

  { Tf_sis }

  Tf_sis = class(TForm)
    bkok: TLabel;
    b_bk: TButton;
    b_re: TButton;
    b_va: TButton;
    b_vat: TButton;
    ck_pd: TCheckBox;
    ck_cl: TCheckBox;
    ck_pv: TCheckBox;
    ck_ru: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    procedure b_reClick(Sender: TObject);
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

procedure Tf_sis.b_vaClick(Sender: TObject);
begin
  //*Pregunta de Seguridad?
  if MessageDlg('ATENCION!!','Está seguro que desea VACIAR la Tabla?'+#13#13+
  'Este proceso es irreversible!',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    // PRESUPUESTOS
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM presupuestos';
    qexe.ExecSQL;
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''presupuestos''';
    qexe.ExecSQL;
    // PRESUPUESTOS
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM presdetalle';
    qexe.ExecSQL;
    qexe.Close;
    qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''presdetalle''';
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
      qexe.SQL.Text:= 'DELETE FROM productos';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''productos''';
      qexe.ExecSQL;
      tpd.Caption:= 'OK';
    end;
    // CLIENTES
    if ck_cl.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM clientes';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''clientes''';
      qexe.ExecSQL;
      tcl.Caption:= 'OK';
    end;
    // PROVEEDORES
    if ck_pv.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM proveedores';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''proveedores''';
      qexe.ExecSQL;
      tpv.Caption:= 'OK';
    end;
    // RUBROS
    if ck_ru.Checked then
    begin
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM rubros';
      qexe.ExecSQL;
      qexe.Close;
      qexe.SQL.Text:= 'DELETE FROM SQLITE_SEQUENCE WHERE name=''rubros''';
      qexe.ExecSQL;
      tru.Caption:= 'OK';
    end;
  end;
end;

end.


unit sis;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, sqlite3backup;

type

  { Tf_sis }

  Tf_sis = class(TForm)
    bkok: TLabel;
    b_bk: TButton;
    b_re: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    reok: TLabel;
    SelBK: TOpenDialog;
    Shape4: TShape;
    sqll3: TSQLite3Connection;
    procedure b_bkClick(Sender: TObject);
    procedure b_reClick(Sender: TObject);
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
    end;
  end;
end;

end.


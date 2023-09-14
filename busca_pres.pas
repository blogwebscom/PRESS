unit busca_pres;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  Buttons, DBCtrls, ExtCtrls, ZDataset, JLabeledDateEdit;

type

  { Tf_bpre }

  Tf_bpre = class(TForm)
    b_loc: TBitBtn;
    b_all: TBitBtn;
    dclien: TDataSource;
    dlista: TDataSource;
    fd: TJLabeledDateEdit;
    fh: TJLabeledDateEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lista: TDBGrid;
    lst_cli: TDBLookupComboBox;
    pcan: TLabel;
    qclien: TZQuery;
    qexe: TZQuery;
    qlista: TZQuery;
    Shape1: TShape;
    procedure b_allClick(Sender: TObject);
    procedure b_locClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure listaDblClick(Sender: TObject);
  private

  public

  end;

var
  f_bpre: Tf_bpre;

implementation

uses
  main;

{$R *.lfm}

{ Tf_bpre }

procedure Tf_bpre.FormActivate(Sender: TObject);
begin
  // Carga Clientes
  qclien.Close;
  qclien.SQL.Text:= 'SELECT * FROM CLIENTES ORDER BY cnom ASC';
  qclien.Open;
end;

procedure Tf_bpre.listaDblClick(Sender: TObject);
begin
  if not qlista.IsEmpty then
  begin
    // Cargamos los datos en el main
    f_main.idpres.Value:= qlista.FieldByName('id_pres').Value;
    close();
  end;
end;

procedure Tf_bpre.b_locClick(Sender: TObject);
begin
  // Control de Vacios?
  if fd.Value <> 0 then
  begin
    if fh.Value <> 0 then
    begin
      //
      qlista.Close;
      qlista.SQL.Text:= 'SELECT * FROM presupuestos';
      if lst_cli.Text <> '' then
      begin
        qlista.SQL.Add('WHERE fec BETWEEN :FD AND :FH AND ncli=:NC ORDER BY fec DESC'); // con cliente
        qlista.ParamByName('NC').AsString:= trim(lst_cli.Text);
      end else qlista.SQL.Add('WHERE fec BETWEEN :FD AND :FH ORDER BY fec DESC');       // sin cliente
      qlista.ParamByName('FD').AsDate:= fd.Value;
      qlista.ParamByName('FH').AsDate:= fh.Value;
      qlista.Open;
      pcan.Caption:= inttostr(qlista.RecordCount);
    end else
      showmessage('Debe indicar la Fecha de Final de la búsqueda!');
  end else
    showmessage('Debe indicar la Fecha de Inicio de la búsqueda!');
end;

procedure Tf_bpre.b_allClick(Sender: TObject);
begin
  qlista.Close;
  qlista.SQL.Text:= 'SELECT * FROM presupuestos ORDER BY fec DESC';
  qlista.Open;
end;

end.


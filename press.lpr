program press;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, prods, provs, zcomponent, cliens, add_pd, rubros, add_cl, sis,
  busca_pres
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='PRESS - Sistema para Presupuestos';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_prod, f_prod);
  Application.CreateForm(Tf_prov, f_prov);
  Application.CreateForm(Tf_cli, f_cli);
  Application.CreateForm(Tf_addp, f_addp);
  Application.CreateForm(Tf_rub, f_rub);
  Application.CreateForm(Tf_addc, f_addc);
  Application.CreateForm(Tf_sis, f_sis);
  Application.CreateForm(Tf_bpre, f_bpre);
  Application.Run;
end.


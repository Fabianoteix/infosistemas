program cadastroCliente;

uses
  Vcl.Forms,
  U_cadcli in 'U_cadcli.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

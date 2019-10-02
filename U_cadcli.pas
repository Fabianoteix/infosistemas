unit U_cadcli;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, System.JSON, idHTTP, IdSSLOpenSSL,
  Data.DB, Datasnap.DBClient, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, IniFiles, IdComponent, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdMessage, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,  IdSMTP,  IdIOHandler,
  IdIOHandlerSocket,  IdIOHandlerStack, IdSSL, IdAttachmentFile, IdText;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    BtSair: TButton;
    BtEnviar: TButton;
    DSCliente: TClientDataSet;
    DataSource1: TDataSource;
    DSClienteNome: TStringField;
    DSClientecpf: TStringField;
    DSClientefone: TStringField;
    DSClienteemail: TStringField;
    DSClientecep: TStringField;
    DSClientelogradouro: TStringField;
    DSClientenumero: TStringField;
    DSClientecomplemento: TStringField;
    DSClientebairro: TStringField;
    DSClientecidade: TStringField;
    DSClienteestado: TStringField;
    DSClientepais: TStringField;
    EditNome: TEdit;
    EditIdentidade: TEdit;
    EditCpf: TEdit;
    EditTelefone: TEdit;
    EditEmail: TEdit;
    EditCEP: TEdit;
    EditLogradouro: TEdit;
    EditNumero: TEdit;
    EditComplemento: TEdit;
    EditBairro: TEdit;
    EditCidade: TEdit;
    EditEstado: TEdit;
    EditPais: TEdit;
    DSClienteidentidade: TStringField;

    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure EditCEPExit(Sender: TObject);
    procedure EditCEPKeyPress(Sender: TObject; var Key: Char);
    procedure BtEnviarClick(Sender: TObject);
    procedure EditTelefoneExit(Sender: TObject);
    procedure EditCpfExit(Sender: TObject);
    procedure BtSairClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetCEP(CEP:string);
    procedure CarregaCep(JSON: TJSONObject);
    procedure LimpaCampos;
    Procedure GravaBanco;
    Procedure GeraXML;
    function ValidaCampos: Boolean;
    function EnviarEmail(const AAssunto, ADestino, AAnexo: String; ACorpo: TStrings): Boolean;
    function FormataFone(Fone: String): string;
    function FormataCPF(CPF: string): string;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}


// Verifica se o campo cep  está preenchido e consulta o CEP

procedure TForm3.EditCEPExit(Sender: TObject);
begin
if Length(EditCEP.Text) <> 8 then
begin
  showmessage('Formato invalido, favor utilizar somente números');
  EditCEP.SetFocus;
  exit;
end;

if EditCEP.Text <> '' then
    GetCEP(editCep.Text)
    else
    begin
    EditCEP.TextHint := 'Campo Obrigatório'

    end;

end;

//restinge o CEP para endadar somente numeros
procedure TForm3.EditCEPKeyPress(Sender: TObject; var Key: Char);
begin
if Key <> #8 then begin
if not (CharInSet(Key,['0'..'9',#8])) then
         Key := #0;
      end;
end;

//formata o Campo CPF
procedure TForm3.EditCpfExit(Sender: TObject);
begin
EditCpf.Text := FormataCPF(EditCpf.Text);
end;

//Formata campo Telefone
procedure TForm3.EditTelefoneExit(Sender: TObject);
begin
EditTelefone.Text := Formatafone(EditTelefone.Text);
end;

//Na costrução do FORM limpa todos os edits
procedure TForm3.FormCreate(Sender: TObject);
begin
    LimpaCampos;
end;

//utiliza a Tecla enter para passar para o proximo edit
procedure TForm3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then begin
    Key := #0;
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

//Consulta Webservice viacep.com.br eretorna um json
procedure TForm3.GetCEP(CEP: string);
var
   HTTP: TIdHTTP;
   IDSSLHandler : TIdSSLIOHandlerSocketOpenSSL;
   Resposta: TStringStream;
   CepJonObj: TJSONObject;
begin
   try
      HTTP := TIdHTTP.Create;
      IDSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
      HTTP.IOHandler := IDSSLHandler;
      Resposta := TStringStream.Create('');

      HTTP.Get('https://viacep.com.br/ws/' + CEP + '/json', Resposta);
      if (HTTP.ResponseCode = 200) and (not((Resposta.DataString) = '{'#$A'  "erro": true'#$A'}')) then
      begin
          CepJonObj :=   TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( (Resposta.DataString)), 0) as TJSONObject;
          CarregaCep(CepJonObj);
      end
      else

        begin
          showMessage('CEP não encontrado ou inválido ');
          editCEP.SetFocus;
           exit;
         end

   finally
      FreeAndNil(HTTP);
      FreeAndNil(IDSSLHandler);

   end;
end;

//botão de sair da aplicação
procedure TForm3.BtSairClick(Sender: TObject);
begin
Form3.Close;
end;


procedure TForm3.BtEnviarClick(Sender: TObject);
var
msg : Tstrings;
sAttachment : string;
//constante para o envio do email

const
sEmail  = 'fabiano.d14@yahoo.com';
sTitulo = 'Cadastro de Cliente';


begin
//Verifica se todos os campos estão preenchidos
if Not (ValidaCampos()) then
begin
  // grava o registro em memoria atravez do TClienteDataSet
  GravaBanco;
  // Gera um arquivo xml grava no diretorio do aplicativo
  Geraxml;
  // Gera corpo do email
  sAttachment := ExtractFileDir(Application.ExeName) + '\temp.xml';
  msg := TStringList.Create;
  msg.Add('Prezados,<br>');
  msg.Add('<br>Em anexo XML contendo os dados do cadastrais do cliente:<br>');
  msg.Add('<br>Nome:'+EditNome.Text );
  msg.Add('<br>CPF: '+EditCpf.text);
  msg.Add('<br>Telefon: '+EditTelefone.text);
  msg.Add('<br>Obrigado');

  // envia o email e exclui o arquivo xml do diretorio
 if EnviarEmail(sTitulo, sEmail, sAttachment , msg)
  then
  begin
        ShowMessage('Enviado com sucesso!');
        LimpaCampos;
        EditNome.SetFocus;
  end
  else ShowMessage('Não foi possível enviar o e-mail!');
        deletefile(ExtractFileDir(Application.ExeName) + '\temp.xml');

end;
end;

// Carrega os dados do Json para os edit
procedure TForm3.CarregaCep(JSON: TJSONObject);
begin
   EditLogradouro.Text := JSON.Get('logradouro').JsonValue.Value;
   EditCidade.Text  := JSON.Get('localidade').JsonValue.Value;
   EditBairro.Text   := JSON.Get('bairro').JsonValue.Value;
   EditEstado.Text  := JSON.Get('uf').JsonValue.Value;
   EditComplemento.text :=JSON.Get('complemento').JsonValue.Value;

end;

 // limpa todos os campos
procedure TForm3.LimpaCampos;
begin
   EditNome.Text  := '';
   EditIdentidade.Text := '';
   EditCpf.Text   :='';
   EditTelefone.Text :='';
   EditEmail.Text := '';
   EditCEP.Text       := '';
   EditLogradouro.Text  := '';
   EditNumero.Text :='';
   EditComplemento.Text :='';
   EditBairro.Text    := '';
   EditCidade.Text   := '';
   EditEstado.Text   := '';
   EditPais.Text :='';


end;

// Grava os dados na memoria
Procedure TForm3.GravaBanco;
begin
  DSCliente.Insert;
  DSClienteNome.Value := AnsiString(EditNome.Text);
  DSClienteIdentidade.Value := AnsiString(EditIdentidade.Text);
  DSClientecpf.Value := AnsiString(EditCPF.Text);
  DSClientefone.Value := AnsiString(EditTelefone.Text);
  DSClienteEmail.Value := AnsiString(EditEmail.Text);
  DSClienteCEP.Value := AnsiString(EditCep.Text);
  DSClienteLogradouro.Value := AnsiString(EditLogradouro.Text);
  DSClienteNumero.Value := AnsiString(EditNumero.Text);
  DSClienteComplemento.Value := AnsiString(EditComplemento.Text);
  DSClienteBairro.Value := AnsiString(EditBairro.Text);
  DSClienteCidade.Value := AnsiString(EditCidade.Text);
  DSClienteEstado.Value := AnsiString(EditEstado.Text);
  DSClientePais.Value := AnsiString(EditPais.Text);
  DSCliente.Post;
end;

//Gera o arquivo XML
Procedure TForm3.geraXML;
var
XMLDocument1 : TXMLDocument;
Cliente : IXMLNode;

begin
  XMLDocument1 :=  TXMLDocument.Create(nil);

  XMLDocument1.Active := true;
  XMLDocument1.Version := '1.0';
  XMLDocument1.Encoding := 'UTF-8';
  Cliente := XMLDocument1.AddChild('Cliente');
  Cliente.AddChild('Nome').text := EditNome.Text;
  Cliente.AddChild('Identidade').Text := EditIdentidade.Text;
  Cliente.AddChild('CPF').Text := EditCPF.Text;
  Cliente.AddChild('Telefone').Text := EditTelefone.Text;
  Cliente.AddChild('Email').Text := EditEmail.Text;
  Cliente.AddChild('CEP').Text :=  EditCep.Text;
  Cliente.AddChild('Logradouro').Text := EditLogradouro.Text;
  Cliente.AddChild('Numero').Text :=  EditNumero.Text;
  Cliente.AddChild('Complemento').Text :=  Editcomplemento.Text;
  Cliente.AddChild('Bairro').Text := EditBairro.Text;
  Cliente.AddChild('Cidade').Text  := EditCidade.Text;
  Cliente.AddChild('Estado').Text  := EditEstado.Text;
  Cliente.AddChild('Pais').Text  := EditPais.Text;
  XMLDocument1.SaveToFile(ExtractFileDir(Application.ExeName) + '\temp.xml');
  XMLDocument1.Active := false;


end;

//Função para enviar émail utilizando a o servidor yahoo os parametros estao no arquivo config.ini
//na pasta do executavel. esta rotina utiliza duas dll que tambem se encontra na pasta junto com o
//aplicativo
function Tform3.EnviarEmail(const AAssunto, ADestino, AAnexo: String; ACorpo: TStrings): Boolean;
var
  IniFile              : TIniFile;
  sFrom                : String;
  sBccList             : String;
  sHost                : String;
  iPort                : Integer;
  sUserName            : String;
  sPassword            : String;
  idMsg                : TIdMessage;
  IdText               : TIdText;
  idSMTP               : TIdSMTP;
  IdSSLIOHandlerSocket : TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    try
      iPort :=0;

      //Criação e leitura do arquivo INI com as configurações
      IniFile                          := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
      sFrom                            := IniFile.ReadString('Email' , 'From'     , sFrom);
      sBccList                         := IniFile.ReadString('Email' , 'BccList'  , sBccList);
      sHost                            := IniFile.ReadString('Email' , 'Host'     , sHost);
      iPort                            := IniFile.ReadInteger('Email', 'Port'     , iPort);
      sUserName                        := IniFile.ReadString('Email' , 'UserName' , sUserName);
      sPassword                        := IniFile.ReadString('Email' , 'Password' , sPassword);

      //Configura os parâmetros necessários para SSL
      IdSSLIOHandlerSocket                   := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      IdSSLIOHandlerSocket.SSLOptions.Mode  := sslmClient;

      //Variável referente a mensagem
      idMsg                            := TIdMessage.Create(Self);
      idMsg.CharSet                    := 'utf-8';
      idMsg.Encoding                   := meMIME;
      idMsg.From.Address               := sFrom;
      idMsg.Priority                   := mpNormal;
      idMsg.Subject                    := AAssunto;

      //Add Destinatário(s)
      idMsg.Recipients.Add;
      idMsg.Recipients.EMailAddresses := ADestino;

      //Variável do texto
      idText := TIdText.Create(idMsg.MessageParts);
      idText.Body.Add(ACorpo.Text);
      idText.ContentType := 'text/html; text/plain; charset=iso-8859-1';

      //Prepara o Servidor
      IdSMTP                           := TIdSMTP.Create(Self);
      IdSMTP.IOHandler                 := IdSSLIOHandlerSocket;
      IdSMTP.UseTLS                    := utUseImplicitTLS;
      IdSMTP.Host                      := sHost;
      IdSMTP.AuthType                  := satDefault;
      IdSMTP.Port                      := iPort;
      IdSMTP.Username                  := sUserName;
      IdSMTP.Password                  := sPassword;


      //Conecta e Autentica
      IdSMTP.Connect;
      IdSMTP.Authenticate;

      if AAnexo <> EmptyStr then
              if FileExists(AAnexo) then
              TIdAttachmentFile.Create(idMsg.MessageParts, AAnexo);


      //Se a conexão foi bem sucedida, envia a mensagem
      if IdSMTP.Connected then
      begin
        try
          IdSMTP.Send(idMsg);
        except on E:Exception do
          begin
            ShowMessage('Erro ao tentar enviar: ' + E.Message);
          end;
        end;
      end;

      // desconecta do servidor SMTP
      if IdSMTP.Connected then
        IdSMTP.Disconnect;

      Result := True;
    finally
  //    IniFile.Free;
      FreeAndNil(IniFile);
      UnLoadOpenSSLLibrary;
      FreeAndNil(idMsg);
      FreeAndNil(IdSSLIOHandlerSocket);
      FreeAndNil(idSMTP);
    end;
  except on e:Exception do
    begin
      Result := False;
    end;
  end;
end;



//valida todos os edits caso não tenha sido preenchido
function TForm3.ValidaCampos: Boolean;
var
  I: Integer;
begin
Result := false;
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I].ClassType = TEdit then
    if TEdit(Components[I]).Text = '' then
    begin
      Result := true;
      TEdit(Components[I]).TextHint := 'Campo Obrigatório';
      Exit;
    end;
  end;
end;

//Formata Telefone de acordo com o tamanho digitado
function Tform3.FormataFone(Fone: String): string;
VAR I : Integer;
    ddd, prefix, tel : String;
begin
if ((Length(Fone) < 10) or (Length(Fone) > 11)) then
    Begin
      showMessage('Formato do Telefone invalido');
      EditTelefone.SetFocus;
      exit;
    End;

  ddd := '';
  prefix := '';
  tel := '';

  //pega o ddd formatado
  ddd := '(';
  for i := 1 to 2 do
    begin
      ddd := ddd+fone[i];
      //Inc(i);
    end;
  ddd := ddd + ')';

  //prefixo de 5 dígitos
  if Length(Fone) = 11 then
    begin
      for i := 3 to length(Fone)-5 do
        begin
          prefix := prefix + Fone[i]
          //Inc(i);
        end;
      prefix := prefix + '-';
    end;

  //prefixo de 4 digitos
  if Length(Fone) = 10 then
    begin
      for i := 3 to length(Fone)-4 do
        begin
          prefix := prefix + Fone[i]
          //Inc(i);
        end;
      prefix := prefix + '-';
    end;

  //telefone
  for i := length(Fone)-3 to length(Fone) do
    tel := tel + Fone[i];

  //junta tudo
  Result := ddd + prefix + tel;
end;

//Formata CPF
function TForm3.FormataCPF(CPF: string): string;
begin
 if (CPF = '') then
 Begin
   ShowMessage('Campo Obrigatório');
   EditCpf.SetFocus;
   exit;
 End;

 if Length(CPF) <> 11 then
 begin
 showMessage('Formato do Telefone invalido');
      EditTelefone.SetFocus;
      EditCpf.SetFocus;
      exit;
 end;



  Result := Copy(CPF,1,3)+'.'+Copy(CPF,4,3)+'.'+Copy(CPF,7,3)+'-'+Copy(CPF,10,2);

end;
end.

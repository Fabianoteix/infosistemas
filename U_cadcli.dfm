object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 524
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object Label2: TLabel
    Left = 24
    Top = 51
    Width = 56
    Height = 13
    Caption = 'Identidade:'
  end
  object Label3: TLabel
    Left = 24
    Top = 78
    Width = 23
    Height = 13
    Caption = 'CPF:'
  end
  object Label4: TLabel
    Left = 24
    Top = 105
    Width = 46
    Height = 13
    Caption = 'Telefone:'
  end
  object Label5: TLabel
    Left = 24
    Top = 132
    Width = 28
    Height = 13
    Caption = 'Email:'
  end
  object EditNome: TEdit
    Tag = 1
    Left = 86
    Top = 24
    Width = 283
    Height = 21
    TabOrder = 0
  end
  object EditIdentidade: TEdit
    Tag = 1
    Left = 86
    Top = 48
    Width = 107
    Height = 21
    TabOrder = 1
  end
  object EditCpf: TEdit
    Tag = 1
    Left = 86
    Top = 75
    Width = 107
    Height = 21
    TabOrder = 2
    OnExit = EditCpfExit
  end
  object EditTelefone: TEdit
    Tag = 1
    Left = 86
    Top = 102
    Width = 147
    Height = 21
    TabOrder = 3
    OnExit = EditTelefoneExit
  end
  object EditEmail: TEdit
    Tag = 1
    Left = 86
    Top = 129
    Width = 283
    Height = 21
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 175
    Width = 417
    Height = 266
    Caption = 'Endere'#231'o'
    TabOrder = 5
    object Label6: TLabel
      Left = 12
      Top = 25
      Width = 23
      Height = 13
      Caption = 'CEP:'
    end
    object Label7: TLabel
      Left = 8
      Top = 52
      Width = 59
      Height = 13
      Caption = 'Logradouro:'
    end
    object Label8: TLabel
      Left = 8
      Top = 79
      Width = 41
      Height = 13
      Caption = 'N'#250'mero:'
    end
    object Label9: TLabel
      Left = 8
      Top = 106
      Width = 69
      Height = 13
      Caption = 'Complemento:'
    end
    object Label10: TLabel
      Left = 8
      Top = 133
      Width = 32
      Height = 13
      Caption = 'Bairro:'
    end
    object Label11: TLabel
      Left = 8
      Top = 160
      Width = 37
      Height = 13
      Caption = 'Cidade:'
    end
    object Label12: TLabel
      Left = 8
      Top = 187
      Width = 37
      Height = 13
      Caption = 'Estado:'
    end
    object Label13: TLabel
      Left = 8
      Top = 213
      Width = 23
      Height = 13
      Caption = 'Pais:'
    end
    object EditCEP: TEdit
      Tag = 1
      Left = 81
      Top = 22
      Width = 88
      Height = 21
      TabOrder = 0
      OnExit = EditCEPExit
      OnKeyPress = EditCEPKeyPress
    end
    object EditLogradouro: TEdit
      Tag = 1
      Left = 81
      Top = 49
      Width = 264
      Height = 21
      TabOrder = 1
    end
    object EditNumero: TEdit
      Tag = 1
      Left = 81
      Top = 76
      Width = 96
      Height = 21
      TabOrder = 2
    end
    object EditComplemento: TEdit
      Left = 83
      Top = 103
      Width = 262
      Height = 21
      TabOrder = 3
    end
    object EditBairro: TEdit
      Tag = 1
      Left = 83
      Top = 130
      Width = 262
      Height = 21
      TabOrder = 4
    end
    object EditCidade: TEdit
      Tag = 1
      Left = 83
      Top = 157
      Width = 262
      Height = 21
      TabOrder = 5
    end
    object EditEstado: TEdit
      Tag = 1
      Left = 83
      Top = 184
      Width = 94
      Height = 21
      TabOrder = 6
    end
    object EditPais: TEdit
      Tag = 1
      Left = 83
      Top = 211
      Width = 262
      Height = 21
      TabOrder = 7
    end
  end
  object Button1: TButton
    Left = 32
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 447
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 7
    OnClick = Button2Click
  end
  object DSCliente: TClientDataSet
    PersistDataPacket.Data = {
      790100009619E0BD01000000180000000D0000000000030000007901044E6F6D
      6501004900000001000557494454480200020032000A6964656E746964616465
      0100490000000100055749445448020002000A00036370660100490000000100
      055749445448020002000E0004666F6E65010049000000010005574944544802
      0002000E0005656D61696C010049000000010005574944544802000200320003
      63657001004900000001000557494454480200020008000A6C6F677261646F75
      726F0100490000000100055749445448020002003200066E756D65726F010049
      0000000100055749445448020002000A000B636F6D706C656D656E746F010049
      00000001000557494454480200020032000662616972726F0100490000000100
      0557494454480200020032000663696461646501004900000001000557494454
      480200020032000665737461646F010049000000010005574944544802000200
      0200047061697301004900000001000557494454480200020032000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 368
    Top = 16
    object DSClienteNome: TStringField
      DisplayWidth = 28
      FieldName = 'Nome'
      Size = 50
    end
    object DSClienteidentidade: TStringField
      FieldName = 'identidade'
      Size = 10
    end
    object DSClientecpf: TStringField
      DisplayWidth = 14
      FieldName = 'cpf'
      Size = 14
    end
    object DSClientefone: TStringField
      DisplayWidth = 14
      FieldName = 'fone'
      Size = 14
    end
    object DSClienteemail: TStringField
      DisplayWidth = 50
      FieldName = 'email'
      Size = 50
    end
    object DSClientecep: TStringField
      DisplayWidth = 8
      FieldName = 'cep'
      Size = 8
    end
    object DSClientelogradouro: TStringField
      DisplayWidth = 50
      FieldName = 'logradouro'
      Size = 50
    end
    object DSClientenumero: TStringField
      DisplayWidth = 10
      FieldName = 'numero'
      Size = 10
    end
    object DSClientecomplemento: TStringField
      DisplayWidth = 50
      FieldName = 'complemento'
      Size = 50
    end
    object DSClientebairro: TStringField
      DisplayWidth = 50
      FieldName = 'bairro'
      Size = 50
    end
    object DSClientecidade: TStringField
      DisplayWidth = 50
      FieldName = 'cidade'
      Size = 50
    end
    object DSClienteestado: TStringField
      DisplayWidth = 5
      FieldName = 'estado'
      Size = 2
    end
    object DSClientepais: TStringField
      DisplayWidth = 50
      FieldName = 'pais'
      Size = 50
    end
  end
  object DataSource1: TDataSource
    DataSet = DSCliente
    Left = 416
    Top = 24
  end
end

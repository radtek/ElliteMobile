unit Utils;

interface

type
  TCrypt = class(TObject)
  private
    Hash: string;
  public
    constructor Create; overload;
    function EncryptStr(str: string): string;
    function DecryptStr(str: string): string;
  end;

  var
    Crypt: TCrypt;

implementation

uses
  uTPLb_CryptographicLibrary,
  uTPLb_Codec, System.SysUtils,
  uTPLb_Constants, System.Threading,
  System.Variants, System.Classes, Env;

constructor TCrypt.Create;
begin
  Hash := HashPass;
end;

function TCrypt.EncryptStr(str: string): string;
var
  Codec: TCodec;
  CryptographicLibrary: TCryptographicLibrary;
  s: string;
begin
  Codec := TCodec.Create(nil);
  CryptographicLibrary := TCryptographicLibrary.Create(nil);
  try
    Codec.CryptoLibrary := CryptographicLibrary;
    Codec.StreamCipherId := uTPLb_Constants.BlockCipher_ProgId;
    Codec.BlockCipherId := 'native.AES-256';
    Codec.ChainModeId := uTPLb_Constants.CBC_ProgId;
    Codec.Password := Hash;
    Codec.EncryptString(str, s, TEncoding.ASCII);
    result := s;
  finally
    Codec.Free;
    CryptographicLibrary.Free;
  end;
end;

function TCrypt.DecryptStr(str: string): string;
var
  Codec: TCodec;
  CryptographicLibrary: TCryptographicLibrary;
  s: string;
begin
  Codec := TCodec.Create(nil);
  CryptographicLibrary := TCryptographicLibrary.Create(nil);
  try
    Codec.CryptoLibrary := CryptographicLibrary;
    Codec.StreamCipherId := uTPLb_Constants.BlockCipher_ProgId;
    Codec.BlockCipherId := 'native.AES-256';
    Codec.ChainModeId := uTPLb_Constants.CBC_ProgId;
    Codec.Password := Hash;
    Codec.DecryptString(s, str, TEncoding.ASCII);
    result := s;
  finally
    Codec.Free;
    CryptographicLibrary.Free;
  end;
end;

initialization

Crypt := TCrypt.Create;

end.

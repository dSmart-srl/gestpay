require 'savon'

hash = {
  shop_login: 'GESPAY57135',
  uic_code: '242',
  amount: '100.50',
  shop_transaction_id: '123',
  language_id: '1',
  buyer_name: "Test Customer",
  buyer_email: "test@example.com",
}

client = Savon.client(wsdl: 'https://testecomm.sella.it/gestpay/GestPayWS/WsCryptDecrypt.asmx?wsdl')
response = client.call(:encrypt, message: hash)
string = response.body[:encrypt_response][:encrypt_result][:gest_pay_crypt_decrypt][:crypt_decrypt_string]

decrypt_response = client.call(:decrypt, message: {shop_login: 'GESPAY57135', crypted_string: string})
p decrypt_response.body

# language: pt
Funcionalidade: Revalidar token de autenticação

  @tokenValido
  Cenário: Revalidar token com sucesso
    Dado que eu possuo um token válido
    Quando eu envio uma requisição para revalidar o token
    Então o retorno deverá ser 200
    E a resposta deve conter um novo token revalidado

  @tokenInvalido
  Cenário: Revalidar token inválido
    Dado que eu possuo um token inválido
    Quando eu envio uma requisição de revalidação
    Então o retorno irá ser 401
    E a resposta deverá conter a mensagem "Token inválido"


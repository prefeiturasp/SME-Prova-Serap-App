# language: pt
Funcionalidade: Autenticação do usuário

  @loginValido
  Cenário: Realizar login com credenciais válidas
    Dado que eu envio credenciais válidas para o endpoint de autenticação
    Quando eu realizar a requisição de login
    Então o retorno será 200
    E a resposta terá um token válido

  @loginInvalido
  Cenário: Realizar login com senha inválida
    Dado que eu envio credenciais inválidas para o endpoint de autenticação
    Quando eu realizar a requisição de login inválido
    Então o retorno será 412
    E a resposta será a mensagem "Senha inválida"

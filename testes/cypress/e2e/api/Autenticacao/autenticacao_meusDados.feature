#language: pt

Funcionalidade: Consultar meus dados

Cenário: Consultar meus dados com token válido
  Dado que possuo um token de autenticação válido
  Quando envio uma requisição GET para o endpoint de meus dados
  Então devo receber o status 200
  E o corpo da resposta deve conter os dados do usuário

Cenário: Consultar meus dados com token inválido
  Dado que possuo um token inválido
  Quando envio uma requisição GET para o endpoint de meus dados
  Então devo receber o status 401

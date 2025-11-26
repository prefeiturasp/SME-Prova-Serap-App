# language: pt
Funcionalidade: Verificar conexão com o serviço de configurações
  Como um cliente da API
  Quero validar a resposta do endpoint de verificação de conexão
  Para garantir que o sistema retorne corretamente os códigos esperados

  Contexto:
    Dado que possuo um token de autenticação válido

  Cenário: Validar conexão existente com o endpoint de configurações
    Quando eu envio uma requisição HEAD para o endpoint de verificação de conexão
    Então o status da resposta deve ser 200
    E o corpo da resposta deve conter "true"

  Cenário: Validar resposta 404 quando o endpoint de conexão não existe
    Quando eu envio uma requisição HEAD para o endpoint inexistente de verificação de conexão
    Então o status da resposta deve ser 404

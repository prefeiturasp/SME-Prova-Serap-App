Feature: Registrar download
  Como um cliente da API
  Quero registrar um download
  Para validar o retorno do serviço

  Background:
    Given que possuo um token de autenticação válido

  Scenario: Registrar download com sucesso
    When eu envio a requisição de download
    Then o serviço deve retornar o código do registro

  Scenario: Registrar download com dados inválidos
    When eu envio a requisição de download inválida
    Then o serviço deve retornar erro de download

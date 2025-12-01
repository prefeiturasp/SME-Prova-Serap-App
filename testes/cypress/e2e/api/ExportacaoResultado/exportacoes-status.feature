Feature: Consultar status das exportações de resultados

  Background:
    Given que possuo um token de autenticação válido

  @consultar-exportacoes-status-valido
  Scenario: Consultar status com filtros válidos
    When envio uma requisição POST para consultar exportacoes-status com dados válidos
    Then o retorno deve ser 200
    And o corpo da resposta deve conter a estrutura esperada

  @consultar-exportacoes-status-invalido
  Scenario: Consultar status com filtros inválidos
    When envio uma requisição POST para consultar exportacoes-status com dados inválidos
    Then o retorno deve ser 422
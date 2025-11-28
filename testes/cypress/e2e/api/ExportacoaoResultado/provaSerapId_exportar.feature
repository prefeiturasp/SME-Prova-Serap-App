Feature: Exportar resultados da prova

  Background:
    Given que possuo um token de autenticação válido

  @exportar-id-valido-inexistente
  Scenario: Exportar prova com ID válido mas inexistente
    When envio uma requisição GET para exportar a prova "590"
    Then o retorno deve ser 409
    And a mensagem deve conter "não foi encontrada"

  @exportar-id-invalido
  Scenario: Exportar prova com ID inválido
    When envio uma requisição GET para exportar a prova "595j"
    Then o retorno deve ser 422

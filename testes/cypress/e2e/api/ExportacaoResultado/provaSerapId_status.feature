Feature: Consultar status da exportação de resultados
  Como cliente da API SERAp
  Quero consultar o status da exportação de uma prova
  Para validar o comportamento para IDs válidos e inválidos

  Background:
    Given que possuo um token de autenticação válido

  @status-id-invalido
  Scenario: Consultar status com ID inválido
    When envio uma requisição GET para consultar o status da prova "5955j"
    Then o retorno deverá retornar 422
    And a mensagem deve conter "is not valid"

  @status-id-valido
  Scenario: Consultar status com ID válido
    When envio uma requisição GET para consultar o status da prova "5955"
    Then o retorno deve ser 204

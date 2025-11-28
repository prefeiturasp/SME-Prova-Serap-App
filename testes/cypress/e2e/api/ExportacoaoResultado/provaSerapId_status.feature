Feature: Consultar status da exportação de resultados

  Background:
    Given que possuo um token de autenticação válido

# cria uma tag
# o @ é utilizado para marcar os cenários para execução seletiva
  @status-exportacao-existente
  Scenario: Consultar status de exportação existente
    When consulto o status da exportação da prova "595"
    Then o retorno deve ser 200 ou 204

  @status-exportacao-id-invalido
  Scenario: Consultar status com ID inválido
    When consulto o status da exportação da prova "595j"
    Then o retorno deve ser 422

Feature: Download de exportações de resultados

  Background:
    Given que possuo um token de autenticação válido

  @download-id-qualquer
  Scenario: Download com qualquer processoid
    Given que informo um processoid "100"
    When envio uma requisição GET para realizar o download
    Then o status code deve ser 500

  @download-id-inexistente
  Scenario: Download com processoid inexistente
    Given que informo um processoid "999999"
    When envio uma requisição GET para realizar o download
    Then o status code deve ser 500

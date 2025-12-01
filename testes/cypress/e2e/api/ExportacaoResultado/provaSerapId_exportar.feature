Feature: Exportar resultados da prova pelo ID
  Como cliente da API SERAp
  Quero exportar os resultados de uma prova pelo ID
  Para validar o comportamento do endpoint

  Background:
    Given que possuo um token de autenticação válido

  @exportar-prova-inexistente
  Scenario: Tentar exportar prova com ID válido porém inexistente
    When envio uma requisição GET para exportar a prova "590"
    Then o retorno deve ser 409
    And a mensagem deve conter "A prova informada não foi encontrada no serap estudantes"

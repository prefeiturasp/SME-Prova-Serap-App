Feature: Consultar arquivo de áudio da prova
  Como cliente da API SERAp
  Quero consultar o áudio de uma prova
  Para validar que os dados retornados estão corretos

  Background:
    Given que possuo um token de autenticação válido

  Scenario: Consultar arquivo de áudio existente
    When eu consulto o arquivo de áudio com o ID 9613010
    Then o status da resposta deve ser 200
    And o corpo da resposta deve conter o áudio com os dados esperados

  Scenario: Consultar arquivo de áudio inexistente
    When eu consulto o arquivo de áudio com o ID 96130100
    Then o status da resposta deve ser 409
    And o corpo da resposta deve conter a mensagem "O Arquivo não foi encontrado"

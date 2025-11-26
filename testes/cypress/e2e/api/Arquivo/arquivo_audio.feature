Feature: Consultar arquivo de áudio da prova
  Como cliente da API SERAp
  Quero consultar o áudio da prova
  Para validar que o arquivo está correto

  Background:
    Given que possuo um token de autenticação válido

  Scenario: Consultar arquivo de áudio existente da prova 591
    When eu consulto o arquivo de áudio com o ID 9613010
    Then o status da resposta deve ser 200
    And o corpo da resposta deve conter o áudio com os dados esperados

  Scenario: Consultar vídeo inexistente
    When eu consulto o vídeo com o ID 999999
    Then o status da resposta deve ser 409
    And o corpo da resposta deve conter a mensagem "O vídeo não foi encontrado"

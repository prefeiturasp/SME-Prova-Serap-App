Feature: Consultar vídeo por ID
  Como um cliente da API
  Quero consultar um vídeo pelo seu ID
  Para obter as informações cadastradas ou uma mensagem de erro adequada

  Background:
    Given que possuo um token de autenticação válido

  Scenario: Consultar vídeo existente
    When eu consulto o vídeo com o ID 123456
    Then o status da resposta deve ser 200
    And o corpo da resposta do vídeo deve conter os campos esperados

  Scenario: Consultar vídeo inexistente
    When eu consulto o vídeo com um ID inexistente
    Then o status da resposta deve ser 409
    And a resposta deve indicar que o vídeo não foi encontrado

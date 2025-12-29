Feature: Consultar provas

  Como um cliente da API
  Quero consultar o endpoint de provas
  Para obter a lista de provas cadastradas

  @provas-401
  Scenario: Consultar provas sem token
    When envio uma requisição GET para o endpoint provas sem token
    Then o status da resposta deve ser 401

  @provas-200
  Scenario: Consultar provas com token válido
    Given que possuo um token de autenticação válido
    When envio uma requisição GET para o endpoint provas com token
    Then o status da resposta deve ser 200

Feature: Consultar provas finalizadas

  Como um cliente da API
  Quero consultar as provas finalizadas
  Para obter informações das provas encerradas

  @provas-finalizadas-401
  Scenario: Consultar provas finalizadas sem token
    When envio uma requisição GET para o endpoint provas finalizadas sem token
    Then o status da resposta deve ser 401

  @provas-finalizadas-200
  Scenario: Consultar provas finalizadas com token válido
    Given que possuo um token de autenticação válido
    When envio uma requisição GET para o endpoint provas finalizadas com token
    Then o status da resposta deve ser 200

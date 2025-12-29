Feature: Consultar detalhes resumidos da prova

  Como um cliente da API
  Quero consultar os detalhes resumidos de uma prova
  Para obter informações resumidas da prova pelo ID

  @provas-detalhes-401
  Scenario: Consultar detalhes resumidos sem token
    When envio uma requisição GET para o endpoint detalhes resumidos da prova com id 590 sem token
    Then o status da resposta deve ser 401

  @provas-detalhes-token-invalido
  Scenario: Consultar detalhes resumidos com token inválido
    Given que possuo um token inválido
    When envio uma requisição GET para o endpoint detalhes resumidos da prova com id 590 com token inválido
    Then o status da resposta deve ser 401

  @provas-detalhes-200
  Scenario: Consultar detalhes resumidos com token válido
    Given que possuo um token de autenticação válido
    When envio uma requisição GET para o endpoint detalhes resumidos da prova com id 590 com token
    Then o status da resposta deve ser 200

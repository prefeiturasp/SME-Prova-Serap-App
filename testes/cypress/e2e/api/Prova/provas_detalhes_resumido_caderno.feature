Feature: Consultar detalhes resumidos da prova por caderno

  @provas-detalhes-caderno-401
  Scenario: Consultar detalhes resumidos da prova por caderno sem token
    When envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id 10 e caderno "10" sem token
    Then o status da resposta deve ser 401

  @provas-detalhes-caderno-token-invalido
  Scenario: Consultar detalhes resumidos da prova por caderno com token inválido
    When envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id 10 e caderno "10" com token inválido
    Then o status da resposta deve ser 401

  @provas-detalhes-caderno-200
  Scenario: Consultar detalhes resumidos da prova por caderno com token válido
    Given que possuo um token de autenticação válido
    When envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id 10 e caderno "10" com token
    Then o status da resposta poderá ser 200 ou 409


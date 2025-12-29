Feature: Consultar status do aluno na prova

  Como um cliente da API
  Quero consultar o status do aluno em uma prova
  Para verificar a situação do aluno na prova informada

  @provas-status-aluno-401
  Scenario: Consultar status do aluno sem token
    When envio uma requisição GET para o endpoint status do aluno da prova com id 590 sem token
    Then o status da resposta deve ser 401

  @provas-status-aluno-token-invalido
  Scenario: Consultar status do aluno com token inválido
    When envio uma requisição GET para o endpoint status do aluno da prova com id 590 com token inválido
    Then o status da resposta deve ser 401

  @provas-status-aluno-200
  Scenario: Consultar status do aluno com token válido
    Given que possuo um token de autenticação válido
    When envio uma requisição GET para o endpoint status do aluno da prova com id 590 com token
    Then o status da resposta deve ser 200

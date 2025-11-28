Feature: API - Existe conexão

  Scenario: Verifica se existe conexão
    Given que possuo um token de acesso valido
    When envio uma requisição GET para o endpoint de existe conexão
    Then retorna status 200 de confirmação

  Scenario: Não verifica conexão sem autenticação
    Given que não possuo um token de acesso valido
    When tento a requisição GET para o endpoint de existe conexão
    Then retorna o status 401 não permitindo verificar

    
Feature: API - Questão completa do ID da prova e legado

  Scenario: Retorna a questão completa com ID da prova e legado
    Given que possuo um token de acesso válido
    When envio uma requisição GET para questão com ID da prova
    And ID questão legado
    Then retorna status 200 com dados da questão completa

  Scenario: ID da prova inválido
    Given que possuo um token de acesso válido
    When envio uma requisição GET para questão com ID da prova inválido
    Then retorna status 204 que não contém prova com ID

  Scenario: ID da questão legado inválido
    Given que possuo um token de acesso válido
    When envio uma requisição GET com ID da questão legado inválido
    Then retorna status 204 que não contém questão com ID

  Scenario: ID da prova é obrigatório
    Given que possuo um token de acesso válido
    When envio uma requisição GET para questão sem ID da prova
    Then retorna status 404 que ID prova não foi enviado

  Scenario: ID da questão legado é obrigatório
    Given que possuo um token de acesso válido
    When envio uma requisição GET sem ID da questão legado
    Then retorna status 404 que ID da questão não foi enviado

  Scenario: Não retorna questão completa sem autenticação
    Given que não possuo um token de acesso válido
    When tento a requisição GET para a questão completa
    Then retorna o status 401 sem acesso aos dados legado da questão
Feature: API - Resumo de resultados do ID da prova

  Scenario: Retorna o resumo de resultados através do ID da prova
    Given que possuo um token de acesso válido
    When envio uma requisição GET com ID da prova
    Then retorna status 200 com resumo dos resultados

  Scenario: ID da prova inválido
    Given que possuo um token de acesso válido
    When envio uma requisição GET com ID inválido
    Then retorna status 409 sem resumo dos resultados

  Scenario: ID da prova é obrigatório
    Given que possuo um token de acesso válido
    When envio uma requisição GET sem o ID da prova
    Then retorna status 404 sem resumo dos resultados

  Scenario: Não retorna resumo de resultados sem autenticação
    Given que não possuo um token de acesso válido
    When tento a requisição GET de resumo de resultados
    Then retorna verifica o status 401 sem acesso aos resultados
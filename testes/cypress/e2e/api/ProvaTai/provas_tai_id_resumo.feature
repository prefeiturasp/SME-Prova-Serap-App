Feature: API - Resumo prova TAI

  Scenario: Retorna o resumo prova TAI
    Given que possuo um token de acesso válido
    When envio uma requisição GET de resumo prova TAI
    Then retorna status 200 

  Scenario: ID da prova TAI é obrigatório
    Given que possuo um token de acesso válido
    When envio uma requisição GET sem o ID da prova
    Then retorna status 404 

  Scenario: Não retorna resumo sem autenticação
    Given que não possuo um token de acesso valido
    When tento a requisição GET de resumo da prova TAI
    Then não verifica o status 401

    
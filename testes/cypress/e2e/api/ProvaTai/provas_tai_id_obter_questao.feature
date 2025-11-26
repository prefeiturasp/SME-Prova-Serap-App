Feature: API - Obter questão prova TAI

  Scenario: Retorna questão da prova TAI
    Given que possuo um token de acesso valido
    When envio uma requisição POST de obter questão
    Then retorna status 200 de sucesso

  Scenario: ID da prova TAI é obrigatório ao obter questão
    Given que possuo um token de acesso valido
    When envio uma requisição POST de obter questão sem o ID
    Then retorna status 404

  Scenario: Não obtem a questão sem autenticação
    Given que não possuo um token de acesso valido
    When tento a requisição POST de obter questão
    Then não retorna a questão com status 401

    
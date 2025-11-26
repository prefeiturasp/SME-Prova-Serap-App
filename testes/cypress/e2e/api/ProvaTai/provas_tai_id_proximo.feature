Feature: API - Próxima questão prova TAI

  Scenario: Próxima questão da prova TAI
    Given que possuo um token de acesso valido
    When envio uma requisição POST da próxima
    Then retorna status 200 de sucesso da questão

  Scenario: ID da prova TAI é obrigatório na próxima questão
    Given que possuo um token de acesso valido
    When envio uma requisição POST da próxima sem o ID
    Then retorna status 404 sem a questão

  Scenario: Não obtem a próxima questão sem autenticação
    Given que não possuo um token de acesso valido
    When tento a requisição POST da próxima
    Then não retorna a questão somente 401

    
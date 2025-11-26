Feature: API - Iniciar prova TAI

  Scenario: Inicia a prova TAI
    Given que possuo um token de acesso valido
    When envio uma requisição POST para iniciar a TAI
    Then retorna status 200 que a prova foi iniciada

  Scenario: ID da prova TAI é obrigatório para iniciar
    Given que possuo um token de acesso valido
    When envio uma requisição POST para iniciar sem o ID
    Then retorna status 404 sem iniciar a prova

  Scenario: Não inicia prova sem autenticação
    Given que não possuo um token de acesso valido
    When tento a requisição POST de iniciar prova
    Then a prova não é iniciada retornando o status 401

    
Feature: API - Meus dados

  Scenario: Retorna os dados do estudante autenticado
    Given que gerou um token de acesso válido
    When que realizo a busca no endpoint de meus dados
    Then retorna status 200 com as informações do estudante 

  Scenario: Não autenticar com senha inválida
    Given que não possuo um token de acesso válido
    When que tento a busca no endpoint de meus dados
    Then retorna status 401 sem as informações do estudante
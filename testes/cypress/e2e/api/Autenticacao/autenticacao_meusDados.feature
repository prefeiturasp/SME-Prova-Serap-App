Feature: Consultar dados do usuário autenticado

  Background:
    Given que possuo um token de autenticação válido

  @consultar-meus-dados-valido
  Scenario: Consultar meus dados com token válido
    When envio uma requisição GET para o endpoint de meus dados
    Then devo receber o status 200
    And o corpo da resposta deve conter os dados do usuário

  @consultar-meus-dados-invalido
  Scenario: Consultar meus dados com token inválido
    Given que possuo um token inválido
    When envio uma requisição GET para o endpoint de meus dados
    Then devo receber o status 401

Feature: API - Revalidar a autenticação

  Scenario: Revalidar a autenticação com sucesso
    Given que acesso o endpoint de autenticação
    When envio os dados de acesso
    Then retorna status 200 com o token válido

  Scenario: Token deve ser obrigatório
    Given que acesso o endpoint de autenticação
    When envio os dados sem o login
    Then retorna status 422 que acesso foi inválido

Feature: API - Autenticação

  Scenario: Realiza a autenticação com sucesso
    Given que acesso o endpoint de autenticação
    When envio os dados de acesso
    Then retorna status 200 com o token válido

  Scenario: Login deve ser obrigatório
    Given que acesso o endpoint de autenticação
    When envio os dados sem o login
    Then retorna status 422 que acesso foi inválido

  Scenario: Senha deve ser obrigatória
    Given que acesso o endpoint de autenticação
    When envio os dados sem a senha
    Then retorna status 422 que é necessário ser informada

  Scenario: Não autenticar com senha inválida
    Given que acesso o endpoint de autenticação
    When envio os dados com senha inválida
    Then retorna status 412 retorna a mensagem que está incorreta
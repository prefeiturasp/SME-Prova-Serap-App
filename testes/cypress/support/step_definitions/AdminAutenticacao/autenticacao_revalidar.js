import { Given, When, Then } from 'cypress-cucumber-preprocessor/steps'

// Revalidar a autenticação com sucesso
Given('que acesso o endpoint de autenticação', function () {  
})

When('envio os dados de acesso', function () {
  return cy.gerar_token().then((token) => {
    return cy.request({
      method: 'POST',
      url: Cypress.config('baseUrl') + `/api/v1/autenticacao/revalidar`,
      headers: {
        'accept': 'text/plain',
        'content-type': 'application/json',
      },
      body: {
        token: token
      },
      failOnStatusCode: false
    }).as('response')
  })
})

Then('retorna status 200 com o token válido', function () {
  cy.get('@response').then((response) => {
    expect([200]).to.include(response.status)
    expect(response.body).to.have.property('token')
    expect(response.body).to.have.property('dataHoraExpiracao')
    expect(response.body).to.have.property('ultimoLogin')
  })
})

// Token deve ser obrigatório
When('envio os dados sem o login', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao/revalidar`,
    headers: {
      'accept': 'text/plain',
      'content-type': 'application/json',
    },
    body: {
    "token":" "
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 422 que acesso foi inválido', function () {
  cy.get('@response').then((response) => {
    expect([422]).to.include(response.status)
    expect(response.body).to.have.property('mensagens')
    expect(response.body).to.have.property('existemErros')
  })
})


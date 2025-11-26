import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
  })
})

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').should('not.be.empty')
})

//
// WHEN – chamada GET usando o ID recebido no cenário
//
When('envio uma requisição GET para exportar a prova {string}', function (provaId) {
  return cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/exportacoes-resultados/${provaId}/exportar`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

//
// THEN – ID válido mas inexistente → 409
//
Then('o retorno deve ser 409', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(409)
  })
})

Then('a mensagem deve conter {string}', function (mensagem) {
  cy.get('@response').then((response) => {
    expect(response.body.mensagens[0]).to.include(mensagem)
  })
})

//
// THEN – ID inválido (formato inválido) → 422
//
Then('o retorno deve ser 422', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(422)
  })
})

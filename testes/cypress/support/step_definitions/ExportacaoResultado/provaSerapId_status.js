import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

// ----------------------
// GERA TOKEN
// ----------------------
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
  })
})

// ----------------------
// VALIDA TOKEN
// ----------------------
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').should('not.be.empty')
})

// ----------------------
// WHEN – CHAMADA GET
// ----------------------
When('envio uma requisição GET para consultar o status da prova {string}', (provaId) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/exportacoes-resultados/${provaId}/status`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

// ----------------------
// THEN – STATUS 422
// ----------------------
Then('o retorno deverá retornar 422', () => {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(422)
  })
})

// ----------------------
// THEN – STATUS 204
// ----------------------
Then('o retorno deve ser 204', () => {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(204)
  })
})

// ----------------------
// THEN – VALIDA MENSAGEM DE ERRO
// ----------------------
Then('a mensagem deve conter {string}', (mensagemEsperada) => {
  cy.get('@response').then((res) => {
    expect(res.body.mensagens, 'Campo mensagens não encontrado').to.exist
    expect(res.body.mensagens[0]).to.include(mensagemEsperada)
  })
})

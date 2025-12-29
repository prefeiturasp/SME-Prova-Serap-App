import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

const endpoint = '/api/v1/provas/finalizadas'

Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
  })
})

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn).to.exist
    token = tkn
  })
})

When('envio uma requisição GET para o endpoint provas finalizadas sem token', () => {
  cy.request({
    method: 'GET',
    url: endpoint,
    headers: {
      accept: 'text/plain'
    },
    failOnStatusCode: false
  }).then((res) => {
    cy.wrap(res).as('response')
  })
})

When('envio uma requisição GET para o endpoint provas finalizadas com token', () => {
  cy.request({
    method: 'GET',
    url: endpoint,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: 'text/plain'
    },
    failOnStatusCode: false
  }).then((res) => {
    cy.wrap(res).as('response')
  })
})

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((response) => {
    cy.log('Status retornado:', response.status)
    expect(response.status).to.eq(statusCode)
  })
})

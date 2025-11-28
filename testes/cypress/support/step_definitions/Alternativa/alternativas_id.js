import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

Before(() => {
  cy.gerar_token().then((token_valido) => {
    token = token_valido
  })
})

Given('que eu possuo o endpoint da API de alternativas', () => {
 cy.log('Endpoint da API de alternativas configurado.')
})


When('eu consulto a alternativa com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/alternativas/${id}`,
    headers: {
      Authorization: `Bearer ${token}`,
    },
    failOnStatusCode: false
  }).as('response')
})

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((response) => {
    cy.log('Status retornado:', response.status)
    cy.log('Corpo da resposta:', JSON.stringify(response.body))
    expect(response.status).to.eq(statusCode)
  })
})

Then('o corpo da resposta deve conter os campos esperados', () => {
  cy.get('@response').then((response) => {
    expect(response.body).to.have.property('id')
    expect(response.body).to.have.property('descricao')
    expect(response.body).to.have.property('ordem')
    expect(response.body).to.have.property('numeracao')
    expect(response.body).to.have.property('questaoId')
  })
})

When('tento consultar a alternativa existente sem autenticação com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/alternativas/${id}`,
    failOnStatusCode: false // evita quebra de teste com 401
  }).as('response')
})

Then('a resposta deve indicar que existem erros', () => {
  cy.get('@response').then((response) => {
    expect(response.status).to.be.oneOf([400, 404, 500])
    cy.log('Mensagem de erro retornada:', JSON.stringify(response.body))
  })
})
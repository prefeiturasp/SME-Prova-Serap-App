import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

Before(() => {
  cy.gerar_token().then((token_valido) => {
    token = token_valido
  })
})

Given('que possuo um token de acesso valido', function () {
  expect(token, 'valido').to.exist
})

// Verifica se existe conexão
When('envio uma requisição GET para o endpoint de existe conexão', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/existe-conexao-r`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 de confirmação', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(200)
  })
})

// Não verifica conexão sem autenticação
Given('que não possuo um token de acesso valido', () => {  
})

When('tento a requisição GET para o endpoint de existe conexão', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/existe-conexao-r`,
    headers: {
     accept: 'text/plain',
     Authorization: 'Bearer token_invalido'
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna o status 401 não permitindo verificar', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(401)
  })
})
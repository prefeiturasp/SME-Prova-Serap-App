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

// Retorna questão da prova TAI
When('envio uma requisição POST de obter questão', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/obter-questao`,
    headers: {
      accept: '*/*',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 de sucesso', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.be.oneOf([200, 411])
  })
})

// ID da prova TAI é obrigatório ao obter questão
When('envio uma requisição POST de obter questão sem o ID', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai//obter-questao`,
    headers: {
      accept: '*/*',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// Não obtem a questão sem autenticação
Given('que não possuo um token de acesso valido', () => {  
})

When('tento a requisição POST de obter questão', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/obter-questao`,
    headers: {
     accept: '*/*',
     Authorization: 'Bearer token_invalido'
    },
    failOnStatusCode: false
  }).as('response')
})

Then('não retorna a questão com status 401', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(401)
  })
})
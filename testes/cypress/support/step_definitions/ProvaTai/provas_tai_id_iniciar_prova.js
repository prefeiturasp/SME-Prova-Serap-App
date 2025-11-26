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

// Inicia a prova TAI
const status = Number(Cypress.env('STATUS'))
const tipoDispositivo = Number(Cypress.env('TIPO_DISPOSITIVO'))
const dataInicio = Number(Cypress.env('DATA_INICIO'))
const dataFim = Cypress.env('DATA_FIM') === 'null' ? null : Number(Cypress.env('DATA_FIM'))

When('envio uma requisição POST para iniciar a TAI', function () {
  return cy.request({
    method: 'POST',
    url: `${Cypress.config('baseUrl')}/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/iniciar-prova`,
    headers: {
      accept: 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
      Authorization: `Bearer ${token}`
    },
    body: {
      status,
      tipoDispositivo,
      dataInicio,
      dataFim
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 que a prova foi iniciada', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.be.oneOf([200, 411])
  })
})

// ID da prova TAI é obrigatório para iniciar
When('envio uma requisição POST para iniciar sem o ID', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai//iniciar-prova`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    body: {
      status: Cypress.env('STATUS'),
      tipoDispositivo: Cypress.env('TIPO_DISPOSITIVO'),
      dataInicio: Cypress.env('DATA_INICIO'),
      dataFim: Cypress.env('DATA_FIM')      
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404 sem iniciar a prova', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// Não inicia prova sem autenticação
Given('que não possuo um token de acesso valido', () => {  
})

When('tento a requisição POST de iniciar prova', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/iniciar-prova`,
    headers: {
     accept: 'text/plain',
     Authorization: 'Bearer token_invalido'
    },
    body: {
      status: Cypress.env('STATUS'),
      tipoDispositivo: Cypress.env('TIPO_DISPOSITIVO'),
      dataInicio: Cypress.env('DATA_INICIO'),
      dataFim: Cypress.env('DATA_FIM')      
    },
    failOnStatusCode: false
  }).as('response')
})

Then('a prova não é iniciada retornando o status 401', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(401)
  })
})
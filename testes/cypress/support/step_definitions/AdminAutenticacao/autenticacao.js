import { Given, When, Then } from 'cypress-cucumber-preprocessor/steps'

// Realiza a autenticação com sucesso
Given('que acesso o endpoint de autenticação', function () {  
})

When('envio os dados de acesso', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao`,
    headers: {
      accept: 'text/plain',
      'content-type': 'application/json',
    },
    body: {
      login: Cypress.env('ALUNO_RA'),
      senha: Cypress.env('DATA_NASC'),
      dispositivo: Cypress.env('DISPOSITIVO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 com o token válido', function () {
  cy.get('@response').then((response) => {
    expect([200]).to.include(response.status)
    expect(response.body).to.have.property('token')
    expect(response.body).to.have.property('dataHoraExpiracao')
    expect(response.body).to.have.property('ultimoLogin')
  })
})

// Login deve ser obrigatório
When('envio os dados sem o login', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao`,
    headers: {
      accept: 'text/plain',
      'content-type': 'application/json',
    },
    body: {
      login:" ",
      senha: Cypress.env('DATA_NASC'),
      dispositivo: Cypress.env('DISPOSITIVO')
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

// Senha deve ser obrigatória
When('envio os dados sem a senha', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao`,
    headers: {
      accept: 'text/plain',
      'content-type': 'application/json',
    },
    body: {
      login: Cypress.env('ALUNO_RA'),
      senha:"",
      dispositivo: Cypress.env('DISPOSITIVO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 422 que é necessário ser informada', function () {
  cy.get('@response').then((response) => {
    expect([422]).to.include(response.status)
    expect(response.body).to.have.property('mensagens')
    expect(response.body).to.have.property('existemErros')
    expect(response.body.mensagens).to.include("É necessário informar a senha.")
    expect(response.body.mensagens).to.include("A senha deve conter no mínimo 3 caracteres.")
    expect(response.body.existemErros).to.be.true
  })
})

// Não autenticar com senha inválida
When('envio os dados com senha inválida', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao`,
    headers: {
      accept: 'text/plain',
      'content-type': 'application/json',
    },
    body: {
      login: Cypress.env('ALUNO_RA'),
      senha: Cypress.env('DATA_NASC_INVALIDA'),
      dispositivo: Cypress.env('DISPOSITIVO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 412 retorna a mensagem que está incorreta', function () {
  cy.get('@response').then((response) => {
    expect([412]).to.include(response.status)
    expect(response.body).to.have.property('mensagens')
    expect(response.body).to.have.property('existemErros')
    expect(response.body.mensagens).to.include("Senha inválida")
    expect(response.body.existemErros).to.be.true
  })
})
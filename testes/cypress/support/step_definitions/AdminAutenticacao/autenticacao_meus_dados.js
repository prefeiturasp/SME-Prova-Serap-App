import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

Before(() => {
  cy.gerar_token().then((token_valido) => {
    token = token_valido
  })
})

// Retorna os dados do estudante autenticado
Given('que gerou um token de acesso válido', function () {  
})

When('que realizo a busca no endpoint de meus dados', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao/meus-dados`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },    
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 com as informações do estudante', function () {
  cy.get('@response').then((response) => {
    expect(response.body).to.have.property('alunoId')
    expect(response.body).to.have.property('dreAbreviacao')
    expect(response.body).to.have.property('escola')
    expect(response.body).to.have.property('turma')
    expect(response.body).to.have.property('nome')
    expect(response.body).to.have.property('ano')
    expect(response.body).to.have.property('tipoTurno')
    expect(response.body).to.have.property('tamanhoFonte')
    expect(response.body).to.have.property('modalidade')
    expect(response.body).to.have.property('familiaFonte')
    expect(response.body).to.have.property('inicioTurno')
    expect(response.body).to.have.property('fimTurno')
    expect(response.body).to.have.property('deficiencias').that.is.an('array')
  })
})

// Não autenticar com senha inválida
Given('que não possuo um token de acesso válido', () => {  
})

When('que tento a busca no endpoint de meus dados', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/autenticacao/meus-dados`,
    headers: {
      accept: 'text/plain',
      Authorization: 'Bearer token_invalido'
    },    
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 401 sem as informações do estudante', function () {
  cy.get('@response').then((response) => {
    expect([401]).to.include(response.status)    
  })
})
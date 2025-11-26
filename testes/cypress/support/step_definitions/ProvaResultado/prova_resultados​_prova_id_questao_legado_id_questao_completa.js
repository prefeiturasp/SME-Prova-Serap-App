import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

Before(() => {
  cy.gerar_token().then((token_valido) => {
    token = token_valido
  })
})

Given('que possuo um token de acesso válido', function () {
  expect(token, 'valido').to.exist
})

// Retorna a questão completa com ID da prova e legado
When('envio uma requisição GET para questão com ID da prova', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}/${Cypress.env('QUESTAO_LEGADO_ID')}/questao-completa`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('ID questão legado', function () {
})

Then('retorna status 200 com dados da questão completa', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(200)
    expect(response.body).to.have.property('questao')
    expect(response.body.questao).to.have.property('id').and.to.be.a('number')
    expect(response.body.questao).to.have.property('questaoLegadoId').and.to.be.a('number')
    expect(response.body.questao).to.have.property('titulo')
    expect(response.body.questao).to.have.property('descricao')
    expect(response.body.questao).to.have.property('ordem').and.to.be.a('number')
    expect(response.body.questao).to.have.property('tipo').and.to.be.a('number')
    expect(response.body.questao).to.have.property('quantidadeAlternativas').and.to.be.a('number')
    expect(response.body.questao).to.have.property('arquivos')
    expect(response.body.questao).to.have.property('audios')
    expect(response.body.questao).to.have.property('videos')
    expect(response.body.questao).to.have.property('alternativas')

    expect(response.body).to.have.property('ordemAlternativaCorreta').and.to.be.a('number')
    expect(response.body).to.have.property('ordemAlternativaResposta')
    expect(response.body).to.have.property('respostaConstruida')
  })
})

// ID da prova inválido
When('envio uma requisição GET para questão com ID da prova inválido', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID_INVALIDO')}/${Cypress.env('QUESTAO_LEGADO_ID')}/questao-completa`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 204 que não contém prova com ID', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(204)
  })
})

// ID da questão legado inválido
When('envio uma requisição GET com ID da questão legado inválido', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}/${Cypress.env('QUESTAO_LEGADO_ID_INVALIDO')}/questao-completa`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 204 que não contém questão com ID', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(204)
  })
})

// ID da prova é obrigatório
When('envio uma requisição GET para questão sem ID da prova', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados//${Cypress.env('QUESTAO_LEGADO_ID')}/questao-completa`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404 que ID prova não foi enviado', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// ID da questão legado é obrigatório
When('envio uma requisição GET sem ID da questão legado', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}//questao-completa`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404 que ID da questão não foi enviado', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// Não retorna questão completa sem autenticação
Given('que não possuo um token de acesso válido', () => {  
})

When('tento a requisição GET para a questão completa', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}/${Cypress.env('QUESTAO_LEGADO_ID')}/questao-completa`,
    headers: {
      accept: 'application/json',
      Authorization: 'Bearer token_invalido'
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna o status 401 sem acesso aos dados legado da questão', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(401)
  })
})
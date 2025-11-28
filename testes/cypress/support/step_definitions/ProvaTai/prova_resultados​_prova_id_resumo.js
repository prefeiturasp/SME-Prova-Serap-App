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

// Retorna o resumo de resultados através do ID da prova
When('envio uma requisição GET com ID da prova', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}/resumo`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 com resumo dos resultados', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(200)
    expect(response.body).to.have.property('proficiencia', 0)
    expect(response.body).to.have.property('resumos')
    expect(response.body.resumos).to.be.an('array').and.not.empty
    expect(response.body.resumos[0]).to.have.property('idQuestaoLegado')
    expect(response.body.resumos[0]).to.have.property('descricaoQuestao')
    expect(response.body.resumos[0]).to.have.property('ordemQuestao')
    expect(response.body.resumos[0]).to.have.property('tipoQuestao')
    expect(response.body.resumos[0]).to.have.property('alternativaAluno')
    expect(response.body.resumos[0]).to.have.property('alternativaCorreta')
    expect(response.body.resumos[0]).to.have.property('correta')
    expect(response.body.resumos[0]).to.have.property('respostaConstruidaRespondida')
  })
})

// ID da prova inválido
When('envio uma requisição GET com ID inválido', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID_INVALIDO')}/resumo`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 409 sem resumo dos resultados', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(409)
    expect(response.body).to.have.property('mensagens')
    expect(response.body.mensagens).to.include("Prova 999 não localizada para obter o resumo do resultado do aluno.")
    expect(response.body).to.have.property('existemErros', true)
  })
})

// ID da prova é obrigatório
When('envio uma requisição GET sem o ID da prova', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados//resumo`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404 sem resumo dos resultados', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// Não retorna resumo de resultados sem autenticação
Given('que não possuo um token de acesso válido', () => {  
})

When('tento a requisição GET de resumo de resultados', function () { 
  return cy.request({
    method: 'GET',
    url: Cypress.config('baseUrl') + `/api/v1/prova-resultados/${Cypress.env('PROVA_TAI_ID')}/resumo`,
    headers: {
      accept: 'application/json',
      Authorization: 'Bearer token_invalido'
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna verifica o status 401 sem acesso aos resultados', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(401)
  })
})
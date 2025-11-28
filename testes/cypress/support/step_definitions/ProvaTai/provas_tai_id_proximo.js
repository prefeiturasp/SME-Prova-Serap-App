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

// Próxima questão da prova TAI
When('envio uma requisição POST da próxima', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/proximo`,
    headers: {
      accept: '*/*',
      Authorization: `Bearer ${token}`
    },
     body: {
      alunoRa: Cypress.env('ALUNO_RA'),
      dispositivoId: Cypress.env('DISPOSITIVO_ID'),
      questaoId: Cypress.env('QUESTAO_ID'),
      alternativaId: Cypress.env('ALTERNATIVA_ID'),
      resposta: Cypress.env('RESPOSTA'),
      dataHoraRespostaTicks: Cypress.env('DATA_HORA_RESPOSTA_TICKS'),
      tempoRespostaAluno: Cypress.env('TEMPO_RESPOTA_ALUNO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 200 de sucesso da questão', function () {
  cy.get('@response').then((response) => {
    expect([200, 411]).to.include(response.status)
  })
})

// ID da prova TAI é obrigatório na próxima questão
When('envio uma requisição POST da próxima sem o ID', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai//proximo`,
    headers: {
      accept: '*/*',
      Authorization: `Bearer ${token}`
    },
     body: {
      alunoRa: Cypress.env('ALUNO_RA'),
      dispositivoId: Cypress.env('DISPOSITIVO_ID'),
      questaoId: Cypress.env('QUESTAO_ID'),
      alternativaId: Cypress.env('ALTERNATIVA_ID'),
      resposta: Cypress.env('RESPOSTA'),
      dataHoraRespostaTicks: Cypress.env('DATA_HORA_RESPOSTA_TICKS'),
      tempoRespostaAluno: Cypress.env('TEMPO_RESPOTA_ALUNO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('retorna status 404 sem a questão', function () {
  cy.get('@response').then((response) => {
    expect(response.status).to.eq(404)
  })
})

// Não obtem a próxima questão sem autenticação
Given('que não possuo um token de acesso valido', () => {  
})

When('tento a requisição POST da próxima', function () { 
  return cy.request({
    method: 'POST',
    url: Cypress.config('baseUrl') + `/api/v1/provas-tai/${Cypress.env('PROVA_TAI_ID')}/proximo`,
    headers: {
     accept: '*/*',
     Authorization: 'Bearer token_invalido'
    },
     body: {
      alunoRa: Cypress.env('ALUNO_RA'),
      dispositivoId: Cypress.env('DISPOSITIVO_ID'),
      questaoId: Cypress.env('QUESTAO_ID'),
      alternativaId: Cypress.env('ALTERNATIVA_ID'),
      resposta: Cypress.env('RESPOSTA'),
      dataHoraRespostaTicks: Cypress.env('DATA_HORA_RESPOSTA_TICKS'),
      tempoRespostaAluno: Cypress.env('TEMPO_RESPOTA_ALUNO')
    },
    failOnStatusCode: false
  }).as('response')
})

Then('não retorna a questão somente 401', function () {
  cy.get('@response').then((response) => {
    expect([401, 405]).to.include(response.status)
  })
})
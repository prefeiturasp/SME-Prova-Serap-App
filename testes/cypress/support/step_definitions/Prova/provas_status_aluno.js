import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

const endpoint = (provaId) => `/api/v1/provas/${provaId}/status-aluno`

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

When(
  'envio uma requisição GET para o endpoint status do aluno da prova com id {int} sem token',
  (provaId) => {
    cy.request({
      method: 'GET',
      url: endpoint(provaId),
      headers: {
        accept: 'text/plain',
      },
      failOnStatusCode: false,
    }).then((res) => {
      cy.wrap(res).as('response')
    })
  }
)

When(
  'envio uma requisição GET para o endpoint status do aluno da prova com id {int} com token inválido',
  (provaId) => {
    const tokenInvalido = 'token_invalido_123'

    cy.request({
      method: 'GET',
      url: endpoint(provaId),
      headers: {
        Authorization: `Bearer ${tokenInvalido}`,
        accept: 'text/plain',
      },
      failOnStatusCode: false,
    }).then((res) => {
      cy.wrap(res).as('response')
    })
  }
)

When(
  'envio uma requisição GET para o endpoint status do aluno da prova com id {int} com token',
  (provaId) => {
    cy.request({
      method: 'GET',
      url: endpoint(provaId),
      headers: {
        Authorization: `Bearer ${token}`,
        accept: 'text/plain',
      },
      failOnStatusCode: false,
    }).then((res) => {
      cy.wrap(res).as('response')
    })
  }
)

// ASSERT DE STATUS
// step específico para Provas – evita conflito com Alternativa

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((response) => {
    cy.log('Status retornado:', response.status)
    expect(response.status).to.eq(statusCode)
  })
})

import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

const endpoint = (id) => `/api/v1/provas/${id}/detalhes-resumido`

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

Given('que possuo um token inválido', () => {
  cy.wrap('token_invalido_123').as('tokenInvalido')
})

When(
  'envio uma requisição GET para o endpoint detalhes resumidos da prova com id {int} sem token',
  (id) => {
    cy.request({
      method: 'GET',
      url: endpoint(id),
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
  'envio uma requisição GET para o endpoint detalhes resumidos da prova com id {int} com token inválido',
  (id) => {
    const tokenInvalido = 'token_invalido_123'

    cy.request({
      method: 'GET',
      url: endpoint(id),
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
  'envio uma requisição GET para o endpoint detalhes resumidos da prova com id {int} com token',
  (id) => {
    cy.request({
      method: 'GET',
      url: endpoint(id),
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

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((response) => {
    cy.log('Status retornado:', response.status)
    expect(response.status).to.eq(statusCode)
  })
})

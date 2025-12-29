import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token

const endpoint = (id, caderno) =>
  `/api/v1/provas/${id}/detalhes-resumido-caderno/${caderno}`

/**
 * 🔑 TOKEN VÁLIDO
 */
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

/**
 * ❌ SEM TOKEN
 */
When(
  'envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id {int} e caderno {string} sem token',
  (id, caderno) => {
    cy.request({
      method: 'GET',
      url: endpoint(id, caderno),
      headers: { accept: 'text/plain' },
      failOnStatusCode: false,
    }).then((res) => {
      cy.wrap(res).as('response')
    })
  }
)

/**
 * ❌ TOKEN INVÁLIDO (criado LOCALMENTE — nunca falha)
 */
When(
  'envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id {int} e caderno {string} com token inválido',
  (id, caderno) => {
    const tokenInvalido = 'token_invalido_123'

    cy.request({
      method: 'GET',
      url: endpoint(id, caderno),
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

/**
 * ✅ TOKEN VÁLIDO
 */
When(
  'envio uma requisição GET para o endpoint detalhes resumidos da prova por caderno com id {int} e caderno {string} com token',
  (id, caderno) => {
    cy.request({
      method: 'GET',
      url: endpoint(id, caderno),
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

/**
 * ✅ ASSERT
 */
Then('o status da resposta poderá ser 200 ou 409', () => {
  cy.get('@response').then((response) => {
    expect([200, 409]).to.include(response.status)
  })
})


import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token


Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
  })
})

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').should('not.be.empty')
})

// WHEN – chamada GET usando o ID recebido no cenário
When('envio uma requisição GET para exportar a prova {string}', function (provaId) {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/exportacoes-resultados/${provaId}/exportar`,
    headers: {
      accept: 'text/plain',
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).as('response')
})


// THEN – STATUS 409 (ID válido porém inexistente)
Then('o retorno deve ser 409', function () {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(409)
  })
})


// THEN – VALIDA A MENSAGEM
Then('a mensagem deve conter {string}', function (mensagemEsperada) {
  cy.get('@response').then((res) => {
    expect(res.body.mensagens, 'Campo mensagens não encontrado').to.exist
    expect(res.body.mensagens[0]).to.include(mensagemEsperada)
  })
})

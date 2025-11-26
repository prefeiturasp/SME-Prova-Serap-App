import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

const baseUrl = 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/exportacoes-resultados'

// Gera token antes dos cenários
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
    cy.log('Token gerado com sucesso!')
  })
})

// Confirma token carregado
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').should('not.be.empty')
})

// Chamada GET para o serviço de status
When('consulto o status da exportação da prova {string}', (provaId) => {
  cy.request({
    method: 'GET',
    url: `${baseUrl}/${provaId}/status`,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'text/plain'
    },
    failOnStatusCode: false // Permite capturar respostas de erro
  }).then((res) => {
    response = res
    cy.wrap(response).as('response')
  })
})

// Valida retorno 200 ou 204 para ID existente
Then('o retorno deve ser 200 ou 204', () => {
  cy.get('@response').then((res) => {
    expect([200, 204]).to.include(res.status)
  })
})

// Valida retorno 422 para ID inválido
Then('o retorno deve ser 422', () => {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(422)
  })
})

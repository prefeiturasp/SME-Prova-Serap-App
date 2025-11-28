import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

const url = 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/exportacoes-resultados/exportacoes-status'

// ----- TOKEN -----
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
  })
})

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').should('not.be.empty')
})

When('envio uma requisição POST para consultar exportacoes-status com dados válidos', () => {

  const body = {
    "dataInicio": "2025-11-26T14:32:30.025Z",
    "dataFim": "2025-11-26T14:32:30.025Z",
    "provaSerapId": 0,
    "descricaoProva": "string",
    "quantidadeRegistros": 0,
    "numeroPagina": 0
  }

  cy.request({
    method: 'POST',
    url,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: '*/*',
      'Content-Type': 'application/json'
    },
    body,
    failOnStatusCode: false
  }).then((resp) => {
    response = resp
  })
})

Then('o retorno deve ser 200', () => {
  expect(response.status).to.eq(200)
})

Then('o corpo da resposta deve conter a estrutura esperada', () => {
  expect(response.body).to.have.property('items')
  expect(response.body).to.have.property('totalPaginas')
  expect(response.body).to.have.property('totalRegistros')
})

When('envio uma requisição POST para consultar exportacoes-status com dados inválidos', () => {

  const invalidBody = {
    "dataInicio": "",
    "dataFim": "",
    "provaSerapId": "AAA",
    "descricaoProva": 123,
    "quantidadeRegistros": "xyz",
    "numeroPagina": -1
  }

  cy.request({
    method: 'POST',
    url,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: '*/*',
      'Content-Type': 'application/json'
    },
    body: invalidBody,
    failOnStatusCode: false
  }).then((resp) => {
    response = resp
  })
})

Then('o retorno deve ser 422', () => {
  expect(response.status).to.eq(422)
})



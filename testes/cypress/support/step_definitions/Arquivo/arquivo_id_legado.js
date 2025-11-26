import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

//Gera token antes de cada cenário
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
    cy.log('Token gerado com sucesso!')
  })
})

//Confirma que o token está definido
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist
    token = tkn
    cy.log('Token validado com sucesso')
  })
})

//Consulta o arquivo legado com ID específico
When('eu consulto o arquivo legado com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/arquivos/${id}/legado`,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json'
    },
    failOnStatusCode: false // permite capturar 4xx e 5xx
  }).then((res) => {
    cy.wrap(res).as('response')
    cy.log(`Consulta de arquivo legado - ID: ${id}`)
    cy.log('Status:', res.status)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

//Valida o status code
Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((response) => {
    cy.log('Status retornado:', response.status)
    expect(response.status).to.eq(statusCode)
  })
})

//Valida campos esperados (para cenário existente)
Then('o corpo da resposta deve conter os campos esperados', () => {
  cy.get('@response').then((response) => {
    const body = response.body
    expect(body).to.have.property('id')
    expect(body).to.have.property('legadoId')
    expect(body).to.have.property('caminho')
    expect(body).to.have.property('questaoId')
    cy.log('Campos validados com sucesso!')
  })
})

//Valida mensagem de erro (para cenário inexistente)
Then('a mensagem de erro deve ser {string}', (mensagemEsperada) => {
  cy.get('@response').then((response) => {
    const body = response.body
    expect(body).to.have.property('mensagens')
    expect(body.mensagens[0]).to.eq(mensagemEsperada)
    cy.log(`Mensagem de erro validada: ${mensagemEsperada}`)
  })
})

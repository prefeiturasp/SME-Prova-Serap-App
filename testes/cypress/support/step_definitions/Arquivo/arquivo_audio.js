import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
    cy.log('🔑 Token gerado com sucesso!')
  })
})

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist
    token = tkn
    cy.log('Token validado com sucesso')
  })
})

When('eu consulto o arquivo de áudio com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/arquivos/audio/${id}`,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: 'application/json'
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res
    cy.wrap(response).as('response')
    cy.log(`Consulta áudio ID ${id} - Status: ${res.status}`)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((res) => {
    expect(res.status, 'Status code incorreto').to.eq(statusCode)
  })
})

Then('o corpo da resposta deve conter o áudio com os dados esperados', () => {
  cy.get('@response').then((res) => {
    const body = res.body

    // campos esperados para áudio existente
    expect(body).to.have.property('id', 9613010)
    expect(body).to.have.property('legadoId').and.to.be.a('number')
    expect(body).to.have.property('questaoId').and.to.be.a('number')
    expect(body.caminho).to.contain('/Files/Audio/')

    cy.log('Áudio retornado corretamente!')
  })
})

Then('o corpo da resposta deve conter a mensagem {string}', (mensagemEsperada) => {
  cy.get('@response').then((res) => {
    const mensagens = res.body.mensagens

    // mensagens deve existir no cenário de erro
    expect(mensagens, 'Campo mensagens não encontrado').to.exist
    expect(mensagens).to.include(mensagemEsperada)

    cy.log(`Mensagem validada: ${mensagemEsperada}`)
  })
})

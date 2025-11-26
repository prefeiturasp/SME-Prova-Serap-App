import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

// Gera token antes de cada cenário
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
    cy.log('Token gerado com sucesso!')
  })
})

// Garante que o token foi obtido
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist
    token = tkn
    cy.log('Token validado com sucesso')
  })
})

// Consulta o arquivo existente da prova
When('eu consulto o arquivo com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/arquivos/${id}`,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: 'application/json'
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res
    cy.wrap(response).as('response')
    cy.log('Consulta de arquivo - Status:', res.status)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

// ✅ Novo When — consulta arquivo inexistente
When('eu consulto um arquivo inexistente com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/arquivos/${id}`,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: 'text/plain'
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res
    cy.wrap(response).as('response')
    cy.log('Consulta de arquivo inexistente - Status:', res.status)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

// Valida o status HTTP
Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((res) => {
    expect(res.status, 'Status code incorreto').to.eq(statusCode)
  })
})

// Valida o corpo com os dados esperados da prova
Then('o corpo da resposta deve conter o arquivo com os dados esperados', () => {
  cy.get('@response').then((res) => {
    const body = res.body
    expect(body).to.have.property('id', 10)
    expect(body).to.have.property('legadoId', 10)
    expect(body).to.have.property('questaoId', 0)
    expect(body.caminho).to.contain('https://serap.sme.prefeitura.sp.gov.br/Files/Alternativa/2021/5/')
    cy.log('Arquivo retornado com os dados corretos da prova')
  })
})

// Valida a mensagem de erro quando o arquivo não é encontrado
Then('o corpo da resposta deve conter a mensagem {string}', (mensagemEsperada) => {
  cy.get('@response').then((res) => {
    const body = res.body
    expect(body).to.have.property('mensagens')
    expect(body.mensagens).to.include(mensagemEsperada)
    expect(body).to.have.property('existemErros', true)
    cy.log(`Mensagem de erro validada: ${mensagemEsperada}`)
  })
})

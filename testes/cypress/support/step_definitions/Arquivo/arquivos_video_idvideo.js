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

//Garante que o token foi obtido
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist
    token = tkn
    cy.log('Token validado com sucesso')
  })
})

//Consulta vídeo existente
When('eu consulto o vídeo com o ID {int}', (idVideo) => {
  cy.get('@token').then((tkn) => {
    cy.request({
      method: 'GET',
      url: `${Cypress.config('baseUrl')}/api/v1/arquivos/video/${idVideo}`,
      headers: {
        Authorization: `Bearer ${tkn}`,
        Accept: 'application/json'
      },
      failOnStatusCode: false
    }).then((resp) => {
      cy.wrap(resp).as('response')
      cy.log('Consulta de vídeo existente - Status:', resp.status)
    })
  })
})

//Consulta vídeo inexistente
When('eu consulto o vídeo com um ID inexistente', () => {
  cy.get('@token').then((tkn) => {
    cy.request({
      method: 'GET',
      url: `${Cypress.config('baseUrl')}/api/v1/arquivos/video/123456777`, // ID inexistente
      headers: {
        Authorization: `Bearer ${tkn}`,
        Accept: 'application/json'
      },
      failOnStatusCode: false
    }).then((resp) => {
      cy.wrap(resp).as('response')
      cy.log('Consulta de vídeo inexistente - Status:', resp.status)
      cy.log('Corpo retornado:', JSON.stringify(resp.body))
    })
  })
})

//Valida status esperado
Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((resp) => {
    expect(resp.status).to.eq(statusCode)
  })
})

//Valida corpo do vídeo existente
Then('o corpo da resposta do vídeo deve conter os campos esperados', () => {
  cy.get('@response').then((resp) => {
    const body = resp.body
    expect(body).to.have.property('id')
    expect(body).to.have.property('caminho')
    expect(body).to.have.property('questaoId')
  })
})

//Valida resposta de erro
Then('a resposta deve indicar que o vídeo não foi encontrado', () => {
  cy.get('@response').then((resp) => {
    expect(resp.status).to.eq(409)
    expect(resp.body).to.have.property('mensagens')
    expect(resp.body.mensagens[0]).to.include('O vídeo não foi encontrado')
    expect(resp.body).to.have.property('existemErros', true)
  })
})

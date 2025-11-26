import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps'

let token
let response

//Gera token antes de cada cenário
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn
    cy.wrap(token).as('token')
    cy.log('🔑 Token gerado com sucesso!')
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

//Consulta o arquivo de áudio da prova
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
    cy.log('Consulta de áudio - Status:', res.status)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

//Valida o status HTTP
Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((res) => {
    expect(res.status, 'Status code incorreto').to.eq(statusCode)
  })
})

//Valida o corpo do áudio retornado
Then('o corpo da resposta deve conter o áudio com os dados esperados', () => {
  cy.get('@response').then((res) => {
    const body = res.body

    //Verifica campos e valores esperados
    expect(body).to.have.property('id', 9613010)
    expect(body).to.have.property('legadoId').and.to.be.a('number')
    expect(body).to.have.property('questaoId').and.to.be.a('number')
    expect(body.caminho).to.contain('https://serap.sme.prefeitura.sp.gov.br/Files/Audio/')
    
    cy.log('Áudio retornado corretamente para a prova 591 e questão 24035631')
  })
})

//Consulta o vídeo pelo ID
When('eu consulto o vídeo com o ID {int}', (id) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}/api/v1/videos/${id}`,
    headers: {
      Authorization: `Bearer ${token}`,
      accept: 'application/json'
    },
    failOnStatusCode: false // permite validar status diferentes de 2xx
  }).then((res) => {
    response = res
    cy.wrap(response).as('response')
    cy.log(`Consulta de vídeo com ID ${id} - Status: ${res.status}`)
    cy.log('Corpo da resposta:', JSON.stringify(res.body))
  })
})

//Valida a mensagem de erro no corpo da resposta
Then('o corpo da resposta deve conter a mensagem {string}', (mensagemEsperada) => {
  cy.get('@response').then((res) => {
    const mensagens = res.body.mensagens
    expect(mensagens, 'Campo mensagens não encontrado').to.exist
    expect(mensagens).to.include(mensagemEsperada)
    cy.log(`Mensagem de erro validada: ${mensagemEsperada}`)
  })
})

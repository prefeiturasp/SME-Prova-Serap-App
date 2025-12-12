import { Given, When, Then } from 'cypress-cucumber-preprocessor/steps'

let token
let response

const url = 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/autenticacao/meus-dados'

Given('que possuo um token de autenticação válido', () => {
  cy.gerar_token().then((tkn) => {
    token = tkn
  })
})

Given('que possuo um token inválido', () => {
  token = '123456789-token-falso'
})

When('envio uma requisição GET para o endpoint de meus dados', () => {
  cy.request({
    method: 'GET',
    url: url,
    failOnStatusCode: false, // permite validar 401 sem quebrar
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'text/plain'
    }
  }).then((res) => {
    response = res
  })
})


Then('devo receber o status 200', () => {
  expect(response.status).to.eq(200)
})

Then('devo receber o status 401', () => {
  expect(response.status).to.eq(401)
})

Then('o corpo da resposta deve conter os dados do usuário', () => {
  expect(response.body).to.have.property('alunoId')
  expect(response.body).to.have.property('nome')
  expect(response.body).to.have.property('login')
})

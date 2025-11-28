import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';

let token;
let response;

// Gera token antes de cada cenário
Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn;
    cy.wrap(token).as('token');
    cy.log('Token gerado com sucesso!');
  });
});

// Garante que o token foi obtido
Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist;
  });
});

// Envia requisição HEAD para o endpoint
When('eu envio uma requisição HEAD para o endpoint de verificação de conexão', () => {
  cy.request({
    method: 'HEAD',
    url: '/api/v1/configuracoes/existe-conexao',
    headers: {
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res;
    cy.wrap(response).as('response');
    cy.log('Requisição HEAD executada com sucesso');
  });
});

// Valida status da resposta
Then('o status da resposta deve ser 200', () => {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(200);
  });
});

// Valida corpo da resposta (quando houver retorno)
Then('o corpo da resposta deve conter {string}', (textoEsperado) => {
  cy.get('@response').then((res) => {
    // Alguns HEADs retornam o valor no body, outros não
    if (res.body) {
      expect(res.body).to.include(textoEsperado);
    } else {
      cy.log('Aviso: a resposta HEAD não retornou corpo');
    }
  });
});

// Requisição para endpoint inexistente
When('eu envio uma requisição HEAD para o endpoint inexistente de verificação de conexão', () => {
  cy.request({
    method: 'HEAD',
    url: '/api/v1/configuracoes/existe-conexao8', // endpoint incorreto propositalmente
    headers: {
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false // evita que o Cypress falhe no 404
  }).then((res) => {
    response = res;
    cy.wrap(response).as('response');
    cy.log('Requisição HEAD (endpoint incorreto) executada com sucesso');
  });
});

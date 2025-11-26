import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';
let token;
let response;

Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn;
    cy.wrap(token).as('token');
    cy.log('Token foi gerado comm sucesso');
  });
});

Given('possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido corretamente').to.exist;
    token = tkn;
    cy.log('Token validado');
  });
});

When('eu faço uma requisição GET para {string}', (rota) => {
  cy.request({
    method: 'GET',
    url: `${Cypress.config('baseUrl')}${rota}`,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json'
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res;
    cy.wrap(res).as('response');
    cy.log('Status:', res.status);
    cy.log('Corpo da resposta:', JSON.stringify(res.body));
  });
});

Then('o status da resposta deve ser {int}', (statusCode) => {
  cy.get('@response').then((res) => {
    expect(res.status).to.eq(statusCode);
  });
});

Then('o corpo da resposta deve conter os campos {string} e {string}', (campo1, campo2) => {
  cy.get('@response').then((res) => {
    const body = res.body;
    expect(body).to.have.property(campo1);
    expect(body).to.have.property(campo2);

    // validações de tipo
    expect(body[campo1]).to.be.a('string');
    expect(body[campo2]).to.be.a('number');

    cy.log(`Campo ${campo1}:`, body[campo1]);
    cy.log(`Campo ${campo2}:`, body[campo2]);
  });
});
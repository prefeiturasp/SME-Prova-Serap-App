import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';

let token;
let response;

Before(() => {
  // Gera token antes de cada cenário
  cy.gerar_token().then((tkn) => {
    token = tkn;
    cy.wrap(token).as('token');
    cy.log('Token gerado com sucesso!');
  });
});

Given('que possuo um token de autenticação válido', () => {
  cy.get('@token').then((tkn) => {
    expect(tkn, 'Token deve estar definido').to.exist;
    token = tkn;
    cy.log('Token validado com sucesso');
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

Then('o corpo da resposta deve conter a lista de vídeos com os campos esperados', () => {
  cy.get('@response').then((res) => {
    const body = res.body;
    // verifica que veio um array com os objetos conforme dados do Postman
    expect(body).to.be.an('array').and.not.to.be.empty;

    body.forEach((video) => {
      expect(video).to.have.property('id').that.is.a('number');
      expect(video).to.have.property('descricao').that.is.a('string');
      expect(video).to.have.property('titulo').that.is.a('string');
      expect(video).to.have.property('ordem').that.is.a('number');
      expect(video).to.have.property('imagem').that.is.a('string');
      expect(video.imagem).to.match(/^https?:\/\/.+/);
    });

    cy.log('Todos os vídeos foram validados com sucesso!');
  });
});


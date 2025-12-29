import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';

let token;
let response;
let processoid;

const baseUrl =
  'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/exportacoes-resultados';

Before(() => {
  cy.gerar_token().then((tkn) => {
    token = tkn;
  });
});

// GIVEN
Given('que possuo um token de autenticação válido', () => {
  expect(token).to.exist;
});

Given('que informo um processoid {string}', (id) => {
  processoid = id;
});

// WHEN
When('envio uma requisição GET para realizar o download', () => {
  cy.request({
    method: 'GET',
    url: `${baseUrl}/${processoid}/download`,
    headers: {
      Authorization: `Bearer ${token}`
    },
    failOnStatusCode: false
  }).then((resp) => {
    response = resp;
  });
});

// THEN
Then('o status code deve ser 500', () => {
  expect(response.status).to.eq(500);
});

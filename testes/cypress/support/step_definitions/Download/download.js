import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';

let token;
let response;

// Gera token antes de cada cenário
Before(() => {
  cy.gerar_token().then((tokenValido) => {
    token = tokenValido;
  });
});

Given('que possuo um token de autenticação válido', () => {
  expect(token).to.not.be.undefined;
});

/* ===================================================
   CENÁRIO DE SUCESSO
=================================================== */

When('eu envio a requisição de download', () => {
  cy.request({
    method: 'POST',
    url: 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/downloads',
    headers: {
      Authorization: `Bearer ${token}`
    },
    body: {
      codigo: "5db6304c-60cb-410f-9616-4eede027da5f",
      alunoId: 0,
      provaId: 590,
      tipoDispositivo: 0,
      tipoResultado: null,
      modeloDispositivo: null,
      versao: "1",
      dataHora: "2025-11-14T13:49:19"
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res;
    cy.log("Resposta sucesso: " + JSON.stringify(res.body));
  });
});

Then('o serviço deve retornar o código do registro', () => {
  expect(response.status).to.eq(200);
  expect(response.body).to.exist;
  expect(response.body).to.be.a('string');
  expect(response.body.length).to.be.greaterThan(0);
});

/* ===================================================
   CENÁRIO DE FALHA
=================================================== */

When('eu envio a requisição de download inválida', () => {
  cy.request({
    method: 'POST',
    url: 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br/api/v1/downloads',
    headers: {
      Authorization: `Bearer ${token}`
    },
    body: {
      codigo: "",       // inválido
      alunoId: null,    // inválido
      provaId: -1,      // inválido
      tipoDispositivo: 0,
      tipoResultado: null,
      modeloDispositivo: null,
      versao: "1",
      dataHora: "2025-11-14T13:49:19"
    },
    failOnStatusCode: false
  }).then((res) => {
    response = res;
    cy.log("Resposta erro: " + JSON.stringify(res.body));
  });
});

Then('o serviço deve retornar erro de download', () => {
  expect(response.status).to.be.oneOf([400, 422, 500]); 
  expect(response.body).to.exist;
});

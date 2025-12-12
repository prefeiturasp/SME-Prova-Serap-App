import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

let token;
let response;

// -------------------------------
// Cenário: Token válido
// -------------------------------
Given("que eu possuo um token válido", () => {
  cy.gerar_token().then((tkn) => {
    token = tkn;
  });
});

When("eu envio uma requisição para revalidar o token", () => {
  cy.request({
    method: "POST",
    url: "/api/v1/autenticacao/revalidar",
    headers: {
      "Content-Type": "application/json"
    },
    body: {
      token: token
    }
  }).then((resp) => {
    response = resp;
  });
});

Then("o retorno deverá ser 200", () => {
  expect(response.status).to.eq(200);
});

Then("a resposta deve conter um novo token revalidado", () => {
  expect(response.body.token).to.exist;
  expect(response.body.token).to.not.be.empty;
});

// -------------------------------
// Cenário: Token inválido
// -------------------------------
Given("que eu possuo um token inválido", () => {
  token = "token_invalido_123";
});

When("eu envio uma requisição de revalidação", () => {
  cy.request({
    method: "POST",
    url: "/api/v1/autenticacao/revalidar",
    headers: {
      "Content-Type": "application/json"
    },
    body: {
      token: token
    },
    failOnStatusCode: false
  }).then((resp) => {
    response = resp;
  });
});

Then("o retorno irá ser 401", () => {
  expect(response.status).to.eq(401);
});

Then("a resposta deverá conter a mensagem {string}", (mensagemEsperada) => {
  expect(response.body.mensagens).to.include(mensagemEsperada);
  expect(response.body.existemErros).to.eq(true);
});

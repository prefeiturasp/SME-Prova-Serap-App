import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

let requestBody;
let response;

Given("que eu envio credenciais válidas para o endpoint de autenticação", () => {
  requestBody = {
    login: "8229804",
    senha: "18122010",
    dispositivo: "web"
  };
});

When("eu realizar a requisição de login", () => {
  cy.request({
    method: "POST",
    url: "/api/v1/autenticacao",
    body: requestBody,
    failOnStatusCode: false
  }).then((resp) => {
    response = resp;
  });
});

Then("o retorno será 200", () => {
  expect(response.status).to.eq(200);
});

Then("a resposta terá um token válido", () => {
  expect(response.body).to.have.property("token");
  expect(response.body.token).to.not.be.empty;
});

Given("que eu envio credenciais inválidas para o endpoint de autenticação", () => {
  requestBody = {
    login: "8229804",
    senha: "18122000", // senha incorreta
    dispositivo: "web"
  };
});

When("eu realizar a requisição de login inválido", () => {
  cy.request({
    method: "POST",
    url: "/api/v1/autenticacao",
    body: requestBody,
    failOnStatusCode: false
  }).then((resp) => {
    response = resp;
  });
});

Then("o retorno será 412", () => {
  expect(response.status).to.eq(412);
});

Then("a resposta será a mensagem {string}", (mensagemEsperada) => {
  expect(response.body.mensagens).to.include(mensagemEsperada);
  expect(response.body.existemErros).to.eq(true);
});

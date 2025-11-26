import { Given, When, Then, Before } from 'cypress-cucumber-preprocessor/steps';

let token;
let response;

Before(() => {
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

Then('todos os itens da resposta — exceto um — devem ter campo {string} válido, e **exatamente um** deve falhar', (campo) => {
  cy.get('@response').then((res) => {
    const body = res.body;
    expect(body).to.be.an('array').and.not.to.be.empty;

    let countFail = 0;
    body.forEach((item, index) => {
      expect(item).to.have.property(campo);
      const valor = item[campo];

      // critério de “válido”: deve combinar com regex de URL se for “imagem”
      if (campo === 'imagem') {
        if (!/^https?:\/\/.+/.test(valor)) {
          countFail++;
          cy.log(`Item #${index} falhou na validação de imagem: ${valor}`);
        } else {
          // válido
          cy.log(`Item #${index} passou na validação de imagem: ${valor}`);
        }
      } else {
        // outro campo — exemplo simples: verificar não vazio
        if (valor === null || valor === '' || valor === undefined) {
          countFail++;
          cy.log(`Item #${index} falhou na validação de ${campo}: ${valor}`);
        } else {
          cy.log(`Item #${index} passou na validação de ${campo}: ${valor}`);
        }
      }
    });

    expect(countFail, `Número de itens que falharam deve ser 1`).to.eq(1);
    cy.log(`Total de falhas encontradas: ${countFail}`);
  });
});

Then('um dos itens deve falhar a validação de {string}', (campo) => {
  // implementação
});

Cypress.Commands.add('gerar_token', () => {
  return cy.request({
    method: 'POST',
    url: `${Cypress.config('baseUrl')}/api/v1/autenticacao`,
    headers: {
      accept: 'application/json',
      'content-type': 'application/json'
    },
    body: {
      login: Cypress.env('ALUNO_RA'),
      senha: Cypress.env('DATA_NASC'),
      dispositivo: Cypress.env('DISPOSITIVO')
    },
    failOnStatusCode: false
  }).then((response) => {
    console.log('Resposta da API:', response.body)
    if (response.status !== 200) {
      throw new Error(`Authentication failed with status: ${response.status} - ${JSON.stringify(response.body)}`)
    }
    return response.body.token
  })
})
 
 
const { defineConfig } = require('cypress')
const allureWriter = require('@shelex/cypress-allure-plugin/writer')
const dotenv = require('dotenv')
const cucumber = require('cypress-cucumber-preprocessor').default
const postgreSQL = require('cypress-postgresql')
const pg = require('pg')

dotenv.config()

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
}

module.exports = defineConfig({
  e2e: {
    async setupNodeEvents(on, config) {
      allureWriter(on, config)
      on('file:preprocessor', cucumber())

      const pool = new pg.Pool(dbConfig)
      const tasks = postgreSQL.loadDBPlugin(pool)
      on('task', tasks)

      const envKeys = [
        'ALUNO_RA',
        'DATA_NASC',
        'DATA_NASC_INVALIDA',
        'DISPOSITIVO',
        'DISPOSITIVO_ID',
        'STATUS',
        'TIPO_DISPOSITIVO',
        'DATA_INICIO',
        'DATA_FIM',
        'PROVA_TAI_ID',
        'PROVA_TAI_ID_INVALIDO',
        'QUESTAO_ID',
        'QUESTAO_LEGADO_ID',
        'QUESTAO_LEGADO_ID_INVALIDO',
        'ALTERNATIVA_ID',
        'RESPOSTA',
        'DATA_HORA_RESPOSTA_TICKS',
        'TEMPO_RESPOSTA_ALUNO'
      ]

      const customVariable = Object.fromEntries(
        envKeys.map((key) => [key, process.env[key] ?? ''])
      )

      const enhancedConfig = {
        ...config,
        env: {
          ...config.env,
          ...customVariable,
        },
      }

      return enhancedConfig
    },

    baseUrl: 'https://hom-serap-estudante.sme.prefeitura.sp.gov.br',
    supportFile: 'cypress/support/e2e.js',
    viewportWidth: 1600,
    viewportHeight: 1050,
    video: false,
    retries: {
      runMode: 2,
      openMode: 0,
    },
    screenshotOnRunFailure: false,
    chromeWebSecurity: false,
    experimentalRunAllSpecs: true,
    failOnStatusCode: false,

    specPattern: [
      'cypress/e2e/**/*.feature'
    ],

    defaultCommandTimeout: 60000,
    requestTimeout: 60000,
    execTimeout: 60000,
    pageLoadTimeout: 60000,
    waitForAnimations: true,
    animationDistanceThreshold: 5,
  },
})
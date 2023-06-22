// ignore: camel_case_types
enum APP_PAGE {
  ERRO,
  SPLASH,
  LOGIN,
  LOGIN_ADM,
  BOAS_VINDAS,
  HOME,
  PROVA,
  CONTEXTO_PROVA,
  QUESTAO,
  RESUMO,
  REVISAO_QUESTAO,
  ADMIN_HOME,
  ADMIN_PROVA_CONTEXTO,
  ADMIN_PROVA_CADERNO,
  ADMIN_PROVA_RESUMO,
  ADMIN_PROVA_RESUMO_CADERNO,
  ADMIN_PROVA_QUESTAO,
  ADMIN_PROVA_QUESTAO_CADERNO,
  QUESTAO_RESPOSTA_RESUMO,
  QUESTAO_RESPOSTA_DETALHES,
  PROVA_TAI,
  PROVA_TAI_QUESTAO,
  PROVA_TAI_RESUMO,
}

extension AppPageExtension on APP_PAGE {
  String get toPath {
    switch (this) {
      case APP_PAGE.ERRO:
        return "/error";
      case APP_PAGE.SPLASH:
        return "/splash";
      case APP_PAGE.LOGIN:
        return "/login";
      case APP_PAGE.LOGIN_ADM:
        return "/login/admin/:codigo";
      case APP_PAGE.BOAS_VINDAS:
        return "/boasVindas";
      case APP_PAGE.HOME:
        return "/";
      case APP_PAGE.PROVA:
        return "/prova/:idProva";
      case APP_PAGE.CONTEXTO_PROVA:
        return "/prova/:idProva/contexto";
      case APP_PAGE.QUESTAO:
        return "/prova/:idProva/questao/:ordem";
      case APP_PAGE.RESUMO:
        return "/prova/:idProva/resumo";
      case APP_PAGE.REVISAO_QUESTAO:
        return "/prova/:idProva/revisao/:ordem";
      case APP_PAGE.ADMIN_HOME:
        return "/admin";
      case APP_PAGE.ADMIN_PROVA_CONTEXTO:
        return "/admin/prova/:idProva/contexto";
      case APP_PAGE.ADMIN_PROVA_CADERNO:
        return "/admin/prova/:idProva/caderno";
      case APP_PAGE.ADMIN_PROVA_RESUMO:
        return "/admin/prova/:idProva/resumo";
      case APP_PAGE.ADMIN_PROVA_RESUMO_CADERNO:
        return "/admin/prova/:idProva/caderno/:nomeCaderno/resumo";
      case APP_PAGE.ADMIN_PROVA_QUESTAO:
        return "/admin/prova/:idProva/questao/:ordem";
      case APP_PAGE.ADMIN_PROVA_QUESTAO_CADERNO:
        return "/admin/prova/:idProva/caderno/:nomeCaderno/questao/:ordem";
      case APP_PAGE.QUESTAO_RESPOSTA_RESUMO:
        return "/prova/resposta/:idProva/:nomeCaderno/resumo";
      case APP_PAGE.QUESTAO_RESPOSTA_DETALHES:
        return "/prova/resposta/:idProva/:nomeCaderno/:ordem/detalhes";
      case APP_PAGE.PROVA_TAI:
        return "/prova/tai/:idProva/carregar";
      case APP_PAGE.PROVA_TAI_QUESTAO:
        return "/prova/tai/:idProva/questao/:ordem";
      case APP_PAGE.PROVA_TAI_RESUMO:
        return "/prova/tai/:idProva/resumo";
    }
  }

  String get toTitle {
    switch (this) {
      case APP_PAGE.ERRO:
        return "Erro";
      case APP_PAGE.SPLASH:
        return "Carregando";
      case APP_PAGE.LOGIN:
        return "Login";
      case APP_PAGE.LOGIN_ADM:
        return "Login Administrador";
      case APP_PAGE.BOAS_VINDAS:
        return "Boas Vindas";
      case APP_PAGE.HOME:
        return "Listagem de Provas";
      case APP_PAGE.PROVA:
        return "Prova";
      case APP_PAGE.CONTEXTO_PROVA:
        return "Contexto da Prova";
      case APP_PAGE.QUESTAO:
        return "Questão";
      case APP_PAGE.RESUMO:
        return "Resumo";
      case APP_PAGE.REVISAO_QUESTAO:
        return "Revisão da questão";
      case APP_PAGE.ADMIN_HOME:
        return "Administrador - Listagem de Provas";
      case APP_PAGE.ADMIN_PROVA_CONTEXTO:
        return "Administrador - Contexto da Prova";
      case APP_PAGE.ADMIN_PROVA_CADERNO:
        return "Administrador - Seleção de Caderno";
      case APP_PAGE.ADMIN_PROVA_RESUMO:
        return "Administrador - Resumo da Prova";
      case APP_PAGE.ADMIN_PROVA_RESUMO_CADERNO:
        return "Administrador - Resumo da Prova";
      case APP_PAGE.ADMIN_PROVA_QUESTAO:
        return "Administrador - Questão da Prova";
      case APP_PAGE.ADMIN_PROVA_QUESTAO_CADERNO:
        return "Administrador - Questão da Prova";
      case APP_PAGE.QUESTAO_RESPOSTA_RESUMO:
        return "Resultado - Resumo";
      case APP_PAGE.QUESTAO_RESPOSTA_DETALHES:
        return "Resultado - Detalhes";
      case APP_PAGE.PROVA_TAI:
        return "Prova Tai";
      case APP_PAGE.PROVA_TAI_QUESTAO:
        return "Prova Tai - Questao";
      case APP_PAGE.PROVA_TAI_RESUMO:
        return "Prova Tai - Resumo";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.ERRO:
        return "ERRO";
      case APP_PAGE.SPLASH:
        return "SPLASH";
      case APP_PAGE.LOGIN:
        return "LOGIN";
      case APP_PAGE.LOGIN_ADM:
        return "LOGIN_ADM";
      case APP_PAGE.BOAS_VINDAS:
        return "BOAS_VINDAS";
      case APP_PAGE.HOME:
        return "HOME";
      case APP_PAGE.PROVA:
        return "PROVA";
      case APP_PAGE.CONTEXTO_PROVA:
        return "CONTEXTO_PROVA";
      case APP_PAGE.QUESTAO:
        return "QUESTAO";
      case APP_PAGE.RESUMO:
        return "RESUMO";
      case APP_PAGE.REVISAO_QUESTAO:
        return "REVISAO_QUESTAO";
      case APP_PAGE.ADMIN_HOME:
        return "ADMIN_HOME";
      case APP_PAGE.ADMIN_PROVA_CONTEXTO:
        return "ADMIN_PROVA_CONTEXTO";
      case APP_PAGE.ADMIN_PROVA_CADERNO:
        return "ADMIN_PROVA_CADERNO";
      case APP_PAGE.ADMIN_PROVA_RESUMO:
        return "ADMIN_PROVA_RESUMO";
      case APP_PAGE.ADMIN_PROVA_RESUMO_CADERNO:
        return "ADMIN_PROVA_RESUMO_CADERNO";
      case APP_PAGE.ADMIN_PROVA_QUESTAO:
        return "ADMIN_PROVA_QUESTAO";
      case APP_PAGE.ADMIN_PROVA_QUESTAO_CADERNO:
        return "ADMIN_PROVA_QUESTAO_CADERNO";
      case APP_PAGE.QUESTAO_RESPOSTA_RESUMO:
        return "QUESTAO_RESPOSTA_RESUMO";
      case APP_PAGE.QUESTAO_RESPOSTA_DETALHES:
        return "QUESTAO_RESPOSTA_DETALHES";
      case APP_PAGE.PROVA_TAI:
        return "PROVA_TAI";
      case APP_PAGE.PROVA_TAI_QUESTAO:
        return "PROVA_TAI_QUESTAO";
      case APP_PAGE.PROVA_TAI_RESUMO:
        return "PROVA_TAI_RESUMO";
    }
  }
}

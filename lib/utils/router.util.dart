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
        return "/login/admin/:login/:nome/:perfil/:chaveApi";
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
    }
  }
}

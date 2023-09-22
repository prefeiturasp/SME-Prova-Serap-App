// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i11;
import 'package:shared_preferences/shared_preferences.dart' as _i24;

import 'database/app.database.dart' as _i3;
import 'database/respostas.database.dart' as _i21;
import 'main.ioc.dart' as _i51;
import 'main.route.dart' as _i4;
import 'services/api.dart' as _i23;
import 'services/rest/admin.service.dart' as _i29;
import 'services/rest/alternativa.service.dart' as _i30;
import 'services/rest/arquivo.service.dart' as _i31;
import 'services/rest/auth.admin.service.dart' as _i32;
import 'services/rest/auth.service.dart' as _i33;
import 'services/rest/configuracao.service.dart' as _i7;
import 'services/rest/contexto_prova.service.dart' as _i8;
import 'services/rest/download.service.dart' as _i10;
import 'services/rest/log.service.dart' as _i12;
import 'services/rest/orientacao_inicial.service.dart' as _i13;
import 'services/rest/prova.service.dart' as _i15;
import 'services/rest/prova_resultado.service.dart' as _i14;
import 'services/rest/prova_tai.service.dart' as _i16;
import 'services/rest/questao.service.dart' as _i19;
import 'services/rest/questao_resposta.service.dart' as _i18;
import 'services/rest/usuario.service.dart' as _i25;
import 'services/rest/versao.service.dart' as _i27;
import 'stores/admin_prova_caderno.store.dart' as _i45;
import 'stores/admin_prova_contexto.store.dart' as _i28;
import 'stores/admin_prova_questao.store.dart' as _i46;
import 'stores/admin_prova_resumo.store.dart' as _i47;
import 'stores/apresentacao.store.dart' as _i5;
import 'stores/contexto_prova_view.store.dart' as _i9;
import 'stores/home.admin.store.dart' as _i34;
import 'stores/home.store.dart' as _i48;
import 'stores/home_provas_anteriores.store.dart' as _i35;
import 'stores/job.store.dart' as _i36;
import 'stores/login.store.dart' as _i49;
import 'stores/login_adm.store.dart' as _i37;
import 'stores/orientacao_inicial.store.dart' as _i50;
import 'stores/principal.store.dart' as _i38;
import 'stores/prova.view.store.dart' as _i17;
import 'stores/prova_resultado_resumo_view.store.dart' as _i39;
import 'stores/prova_tai.view.store.dart' as _i40;
import 'stores/questao.store.dart' as _i20;
import 'stores/questao_resultado_detalhes_view.store.dart' as _i41;
import 'stores/questao_revisao.store.dart' as _i42;
import 'stores/questao_tai_view.store.dart' as _i43;
import 'stores/resumo_tai_view.store.dart' as _i22;
import 'stores/tema.store.dart' as _i44;
import 'stores/usuario.store.dart' as _i26;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.AppDatabase>(_i3.AppDatabase());
    gh.singleton<_i4.AppRouter>(_i4.AppRouter());
    gh.lazySingleton<_i5.ApresentacaoStore>(() => _i5.ApresentacaoStore());
    gh.factory<_i6.ChopperClient>(() => registerModule.chopperClient);
    gh.factory<_i7.ConfiguracaoService>(
        () => _i7.ConfiguracaoService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i8.ContextoProvaService>(
        () => _i8.ContextoProvaService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i9.ContextoProvaViewStore>(
        () => _i9.ContextoProvaViewStore(gh<_i3.AppDatabase>()));
    gh.factory<_i10.DownloadService>(
        () => _i10.DownloadService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i11.InternetConnection>(
        () => registerModule.internetConnection);
    gh.factory<_i12.LogService>(
        () => _i12.LogService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i13.OrientacaoInicialService>(
        () => _i13.OrientacaoInicialService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i14.ProvaResultadoService>(
        () => _i14.ProvaResultadoService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i15.ProvaService>(
        () => _i15.ProvaService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i16.ProvaTaiService>(
        () => _i16.ProvaTaiService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i17.ProvaViewStore>(() => _i17.ProvaViewStore());
    gh.factory<_i18.QuestaoRespostaService>(
        () => _i18.QuestaoRespostaService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i19.QuestaoService>(
        () => _i19.QuestaoService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i20.QuestaoStore>(() => _i20.QuestaoStore());
    gh.singleton<_i21.RespostasDatabase>(_i21.RespostasDatabase());
    gh.lazySingleton<_i22.ResumoTaiViewStore>(() => _i22.ResumoTaiViewStore(
          gh<_i3.AppDatabase>(),
          gh<_i21.RespostasDatabase>(),
          gh<_i23.ProvaTaiService>(),
        ));
    await gh.factoryAsync<_i24.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i25.UsuarioService>(
        () => _i25.UsuarioService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i26.UsuarioStore>(
        () => _i26.UsuarioStore(gh<_i24.SharedPreferences>()));
    gh.factory<_i27.VersaoService>(
        () => _i27.VersaoService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i28.AdminProvaContextoViewStore>(() =>
        _i28.AdminProvaContextoViewStore(gh<_i23.ContextoProvaService>()));
    gh.factory<_i29.AdminService>(
        () => _i29.AdminService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i30.AlternativaService>(
        () => _i30.AlternativaService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i31.ArquivoService>(
        () => _i31.ArquivoService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i32.AutenticacaoAdminService>(
        () => _i32.AutenticacaoAdminService.create(gh<_i6.ChopperClient>()));
    gh.factory<_i33.AutenticacaoService>(
        () => _i33.AutenticacaoService.create(gh<_i6.ChopperClient>()));
    gh.lazySingleton<_i34.HomeAdminStore>(
        () => _i34.HomeAdminStore(gh<_i23.AdminService>()));
    gh.lazySingleton<_i35.HomeProvasAnterioresStore>(
        () => _i35.HomeProvasAnterioresStore(gh<_i23.ProvaService>()));
    gh.lazySingleton<_i36.JobStore>(() => _i36.JobStore(
          gh<_i3.AppDatabase>(),
          gh<_i21.RespostasDatabase>(),
        ));
    gh.lazySingleton<_i37.LoginAdmStore>(() => _i37.LoginAdmStore(
          gh<_i23.AutenticacaoAdminService>(),
          gh<_i26.UsuarioStore>(),
          gh<_i24.SharedPreferences>(),
        ));
    gh.lazySingleton<_i38.PrincipalStore>(() => _i38.PrincipalStore(
          gh<_i11.InternetConnection>(),
          gh<_i26.UsuarioStore>(),
          gh<_i23.DownloadService>(),
          gh<_i4.AppRouter>(),
          gh<_i24.SharedPreferences>(),
        ));
    gh.lazySingleton<_i39.ProvaResultadoResumoViewStore>(
        () => _i39.ProvaResultadoResumoViewStore(
              gh<_i3.AppDatabase>(),
              gh<_i21.RespostasDatabase>(),
              gh<_i23.ProvaResultadoService>(),
              gh<_i24.SharedPreferences>(),
            ));
    gh.lazySingleton<_i40.ProvaTaiViewStore>(() => _i40.ProvaTaiViewStore(
          gh<_i3.AppDatabase>(),
          gh<_i21.RespostasDatabase>(),
          gh<_i23.ProvaTaiService>(),
        ));
    gh.lazySingleton<_i41.QuestaoResultadoDetalhesViewStore>(
        () => _i41.QuestaoResultadoDetalhesViewStore(
              gh<_i3.AppDatabase>(),
              gh<_i21.RespostasDatabase>(),
              gh<_i24.SharedPreferences>(),
              gh<_i23.ProvaResultadoService>(),
            ));
    gh.lazySingleton<_i42.QuestaoRevisaoStore>(() => _i42.QuestaoRevisaoStore(
          gh<_i3.AppDatabase>(),
          gh<_i21.RespostasDatabase>(),
        ));
    gh.lazySingleton<_i43.QuestaoTaiViewStore>(() => _i43.QuestaoTaiViewStore(
          gh<_i3.AppDatabase>(),
          gh<_i21.RespostasDatabase>(),
          gh<_i23.ProvaTaiService>(),
          gh<_i38.PrincipalStore>(),
          gh<_i26.UsuarioStore>(),
        ));
    gh.lazySingleton<_i44.TemaStore>(
        () => _i44.TemaStore(gh<_i23.UsuarioService>()));
    gh.lazySingleton<_i45.AdminProvaCadernoViewStore>(
        () => _i45.AdminProvaCadernoViewStore(gh<_i23.AdminService>()));
    gh.lazySingleton<_i46.AdminProvaQuestaoViewStore>(
        () => _i46.AdminProvaQuestaoViewStore(
              gh<_i24.SharedPreferences>(),
              gh<_i23.AdminService>(),
              gh<_i23.AlternativaService>(),
              gh<_i23.ArquivoService>(),
              gh<_i23.QuestaoService>(),
            ));
    gh.lazySingleton<_i47.AdminProvaResumoViewStore>(
        () => _i47.AdminProvaResumoViewStore(
              gh<_i23.AdminService>(),
              gh<_i24.SharedPreferences>(),
            ));
    gh.lazySingleton<_i48.HomeStore>(() => _i48.HomeStore(
          gh<_i26.UsuarioStore>(),
          gh<_i38.PrincipalStore>(),
          gh<_i3.AppDatabase>(),
          gh<_i23.ProvaService>(),
        ));
    gh.lazySingleton<_i49.LoginStore>(() => _i49.LoginStore(
          gh<_i23.AutenticacaoService>(),
          gh<_i26.UsuarioStore>(),
          gh<_i38.PrincipalStore>(),
          gh<_i24.SharedPreferences>(),
        ));
    gh.lazySingleton<_i50.OrientacaoInicialStore>(
        () => _i50.OrientacaoInicialStore(
              gh<_i23.OrientacaoInicialService>(),
              gh<_i44.TemaStore>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i51.RegisterModule {}

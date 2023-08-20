// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i8;
import 'package:shared_preferences/shared_preferences.dart' as _i16;

import 'main.ioc.dart' as _i24;
import 'services/rest/admin.service.dart' as _i19;
import 'services/rest/alternativa.service.dart' as _i20;
import 'services/rest/arquivo.service.dart' as _i21;
import 'services/rest/auth.admin.service.dart' as _i22;
import 'services/rest/auth.service.dart' as _i23;
import 'services/rest/configuracao.service.dart' as _i5;
import 'services/rest/contexto_prova.service.dart' as _i6;
import 'services/rest/download.service.dart' as _i7;
import 'services/rest/log.service.dart' as _i9;
import 'services/rest/orientacao_inicial.service.dart' as _i10;
import 'services/rest/prova.service.dart' as _i12;
import 'services/rest/prova_resultado.service.dart' as _i11;
import 'services/rest/prova_tai.service.dart' as _i13;
import 'services/rest/questao.service.dart' as _i15;
import 'services/rest/questao_resposta.service.dart' as _i14;
import 'services/rest/usuario.service.dart' as _i17;
import 'services/rest/versao.service.dart' as _i18;
import 'stores/admin_prova_resumo.store.dart' as _i3;

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
    gh.factory<_i3.AdminProvaResumoViewStore>(
        () => _i3.AdminProvaResumoViewStore());
    gh.factory<_i4.ChopperClient>(() => registerModule.chopperClient);
    gh.factory<_i5.ConfiguracaoService>(
        () => _i5.ConfiguracaoService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i6.ContextoProvaService>(
        () => _i6.ContextoProvaService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i7.DownloadService>(
        () => _i7.DownloadService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i8.InternetConnection>(() => registerModule.internetConnection);
    gh.factory<_i9.LogService>(
        () => _i9.LogService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i10.OrientacaoInicialService>(
        () => _i10.OrientacaoInicialService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i11.ProvaResultadoService>(
        () => _i11.ProvaResultadoService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i12.ProvaService>(
        () => _i12.ProvaService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i13.ProvaTaiService>(
        () => _i13.ProvaTaiService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i14.QuestaoRespostaService>(
        () => _i14.QuestaoRespostaService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i15.QuestaoService>(
        () => _i15.QuestaoService.create(gh<_i4.ChopperClient>()));
    await gh.factoryAsync<_i16.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i17.UsuarioService>(
        () => _i17.UsuarioService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i18.VersaoService>(
        () => _i18.VersaoService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i19.AdminService>(
        () => _i19.AdminService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i20.AlternativaService>(
        () => _i20.AlternativaService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i21.ArquivoService>(
        () => _i21.ArquivoService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i22.AutenticacaoAdminService>(
        () => _i22.AutenticacaoAdminService.create(gh<_i4.ChopperClient>()));
    gh.factory<_i23.AutenticacaoService>(
        () => _i23.AutenticacaoService.create(gh<_i4.ChopperClient>()));
    return this;
  }
}

class _$RegisterModule extends _i24.RegisterModule {}

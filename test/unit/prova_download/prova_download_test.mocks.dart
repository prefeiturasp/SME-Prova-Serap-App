// Mocks generated by Mockito 5.3.0 from annotations
// in appserap/test/unit/prova_download/prova_download_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;

import 'package:appserap/dtos/prova.response.dto.dart' as _i11;
import 'package:appserap/dtos/prova_anterior.response.dto.dart' as _i15;
import 'package:appserap/dtos/prova_detalhes.response.dto.dart' as _i12;
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart' as _i13;
import 'package:appserap/dtos/questao.response.dto.dart' as _i16;
import 'package:appserap/dtos/questao_completa.response.dto.dart' as _i17;
import 'package:appserap/dtos/questao_detalhes_legado.response.dto.dart'
    as _i18;
import 'package:appserap/dtos/questao_resposta.response.dto.dart' as _i14;
import 'package:appserap/enums/deficiencia.enum.dart' as _i22;
import 'package:appserap/enums/fonte_tipo.enum.dart' as _i21;
import 'package:appserap/enums/modalidade.enum.dart' as _i20;
import 'package:appserap/services/api.dart' as _i3;
import 'package:appserap/services/rest/admin.service.dart' as _i6;
import 'package:appserap/services/rest/auth.admin.service.dart' as _i7;
import 'package:appserap/services/rest/download.service.dart' as _i5;
import 'package:appserap/services/rest/log.service.dart' as _i8;
import 'package:appserap/services/rest/usuario.service.dart' as _i4;
import 'package:appserap/stores/usuario.store.dart' as _i19;
import 'package:chopper/chopper.dart' as _i2;
import 'package:http/http.dart' as _i23;
import 'package:mobx/mobx.dart' as _i9;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeChopperClient_0 extends _i1.SmartFake implements _i2.ChopperClient {
  _FakeChopperClient_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeAutenticacaoService_1 extends _i1.SmartFake
    implements _i3.AutenticacaoService {
  _FakeAutenticacaoService_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeProvaService_2 extends _i1.SmartFake implements _i3.ProvaService {
  _FakeProvaService_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeQuestaoService_3 extends _i1.SmartFake
    implements _i3.QuestaoService {
  _FakeQuestaoService_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeAlternativaService_4 extends _i1.SmartFake
    implements _i3.AlternativaService {
  _FakeAlternativaService_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeArquivoService_5 extends _i1.SmartFake
    implements _i3.ArquivoService {
  _FakeArquivoService_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeVersaoService_6 extends _i1.SmartFake implements _i3.VersaoService {
  _FakeVersaoService_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeQuestaoRespostaService_7 extends _i1.SmartFake
    implements _i3.QuestaoRespostaService {
  _FakeQuestaoRespostaService_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeUsuarioService_8 extends _i1.SmartFake
    implements _i4.UsuarioService {
  _FakeUsuarioService_8(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeOrientacaoInicialService_9 extends _i1.SmartFake
    implements _i3.OrientacaoInicialService {
  _FakeOrientacaoInicialService_9(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeContextoProvaService_10 extends _i1.SmartFake
    implements _i3.ContextoProvaService {
  _FakeContextoProvaService_10(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeDownloadService_11 extends _i1.SmartFake
    implements _i5.DownloadService {
  _FakeDownloadService_11(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeAdminService_12 extends _i1.SmartFake implements _i6.AdminService {
  _FakeAdminService_12(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeAutenticacaoAdminService_13 extends _i1.SmartFake
    implements _i7.AutenticacaoAdminService {
  _FakeAutenticacaoAdminService_13(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeLogService_14 extends _i1.SmartFake implements _i8.LogService {
  _FakeLogService_14(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeType_15 extends _i1.SmartFake implements Type {
  _FakeType_15(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeResponse_16<BodyType> extends _i1.SmartFake
    implements _i2.Response<BodyType> {
  _FakeResponse_16(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeObservableList_17<T> extends _i1.SmartFake
    implements _i9.ObservableList<T> {
  _FakeObservableList_17(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeReactiveContext_18 extends _i1.SmartFake
    implements _i9.ReactiveContext {
  _FakeReactiveContext_18(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i3.ApiService {
  MockApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ChopperClient get chopper => (super.noSuchMethod(
          Invocation.getter(#chopper),
          returnValue: _FakeChopperClient_0(this, Invocation.getter(#chopper)))
      as _i2.ChopperClient);
  @override
  _i3.AutenticacaoService get auth =>
      (super.noSuchMethod(Invocation.getter(#auth),
              returnValue:
                  _FakeAutenticacaoService_1(this, Invocation.getter(#auth)))
          as _i3.AutenticacaoService);
  @override
  _i3.ProvaService get prova => (super.noSuchMethod(Invocation.getter(#prova),
          returnValue: _FakeProvaService_2(this, Invocation.getter(#prova)))
      as _i3.ProvaService);
  @override
  _i3.QuestaoService get questao => (super.noSuchMethod(
          Invocation.getter(#questao),
          returnValue: _FakeQuestaoService_3(this, Invocation.getter(#questao)))
      as _i3.QuestaoService);
  @override
  _i3.AlternativaService get alternativa => (super.noSuchMethod(
          Invocation.getter(#alternativa),
          returnValue:
              _FakeAlternativaService_4(this, Invocation.getter(#alternativa)))
      as _i3.AlternativaService);
  @override
  _i3.ArquivoService get arquivo => (super.noSuchMethod(
          Invocation.getter(#arquivo),
          returnValue: _FakeArquivoService_5(this, Invocation.getter(#arquivo)))
      as _i3.ArquivoService);
  @override
  _i3.VersaoService get versao => (super.noSuchMethod(
          Invocation.getter(#versao),
          returnValue: _FakeVersaoService_6(this, Invocation.getter(#versao)))
      as _i3.VersaoService);
  @override
  _i3.QuestaoRespostaService get questaoResposta =>
      (super.noSuchMethod(Invocation.getter(#questaoResposta),
              returnValue: _FakeQuestaoRespostaService_7(
                  this, Invocation.getter(#questaoResposta)))
          as _i3.QuestaoRespostaService);
  @override
  _i4.UsuarioService get usuario => (super.noSuchMethod(
          Invocation.getter(#usuario),
          returnValue: _FakeUsuarioService_8(this, Invocation.getter(#usuario)))
      as _i4.UsuarioService);
  @override
  _i3.OrientacaoInicialService get orientacoesIniciais =>
      (super.noSuchMethod(Invocation.getter(#orientacoesIniciais),
              returnValue: _FakeOrientacaoInicialService_9(
                  this, Invocation.getter(#orientacoesIniciais)))
          as _i3.OrientacaoInicialService);
  @override
  _i3.ContextoProvaService get contextoProva =>
      (super.noSuchMethod(Invocation.getter(#contextoProva),
              returnValue: _FakeContextoProvaService_10(
                  this, Invocation.getter(#contextoProva)))
          as _i3.ContextoProvaService);
  @override
  _i5.DownloadService get download =>
      (super.noSuchMethod(Invocation.getter(#download),
              returnValue:
                  _FakeDownloadService_11(this, Invocation.getter(#download)))
          as _i5.DownloadService);
  @override
  _i6.AdminService get admin => (super.noSuchMethod(Invocation.getter(#admin),
          returnValue: _FakeAdminService_12(this, Invocation.getter(#admin)))
      as _i6.AdminService);
  @override
  _i7.AutenticacaoAdminService get adminAuth =>
      (super.noSuchMethod(Invocation.getter(#adminAuth),
              returnValue: _FakeAutenticacaoAdminService_13(
                  this, Invocation.getter(#adminAuth)))
          as _i7.AutenticacaoAdminService);
  @override
  _i8.LogService get log => (super.noSuchMethod(Invocation.getter(#log),
          returnValue: _FakeLogService_14(this, Invocation.getter(#log)))
      as _i8.LogService);
}

/// A class which mocks [ProvaService].
///
/// See the documentation for Mockito's code generation for more information.
class MockProvaService extends _i1.Mock implements _i3.ProvaService {
  MockProvaService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ChopperClient get client => (super.noSuchMethod(
          Invocation.getter(#client),
          returnValue: _FakeChopperClient_0(this, Invocation.getter(#client)))
      as _i2.ChopperClient);
  @override
  set client(_i2.ChopperClient? _client) =>
      super.noSuchMethod(Invocation.setter(#client, _client),
          returnValueForMissingStub: null);
  @override
  Type get definitionType => (super.noSuchMethod(
          Invocation.getter(#definitionType),
          returnValue: _FakeType_15(this, Invocation.getter(#definitionType)))
      as Type);
  @override
  _i10.Future<_i2.Response<List<_i11.ProvaResponseDTO>>> getProvas() => (super
          .noSuchMethod(Invocation.method(#getProvas, []),
              returnValue:
                  _i10.Future<_i2.Response<List<_i11.ProvaResponseDTO>>>.value(
                      _FakeResponse_16<List<_i11.ProvaResponseDTO>>(
                          this, Invocation.method(#getProvas, []))))
      as _i10.Future<_i2.Response<List<_i11.ProvaResponseDTO>>>);
  @override
  _i10.Future<_i2.Response<_i12.ProvaDetalhesResponseDTO>> getResumoProva(
          {int? idProva}) =>
      (super.noSuchMethod(Invocation.method(#getResumoProva, [], {#idProva: idProva}),
              returnValue:
                  _i10.Future<_i2.Response<_i12.ProvaDetalhesResponseDTO>>.value(
                      _FakeResponse_16<_i12.ProvaDetalhesResponseDTO>(
                          this,
                          Invocation.method(
                              #getResumoProva, [], {#idProva: idProva}))))
          as _i10.Future<_i2.Response<_i12.ProvaDetalhesResponseDTO>>);
  @override
  _i10.Future<_i2.Response<_i13.ProvaDetalhesCadernoResponseDTO>> getResumoProvaCaderno(
          {int? idProva, String? caderno}) =>
      (super.noSuchMethod(Invocation.method(#getResumoProvaCaderno, [], {#idProva: idProva, #caderno: caderno}),
              returnValue:
                  _i10.Future<_i2.Response<_i13.ProvaDetalhesCadernoResponseDTO>>.value(
                      _FakeResponse_16<_i13.ProvaDetalhesCadernoResponseDTO>(
                          this,
                          Invocation.method(
                              #getResumoProvaCaderno, [], {#idProva: idProva, #caderno: caderno}))))
          as _i10.Future<_i2.Response<_i13.ProvaDetalhesCadernoResponseDTO>>);
  @override
  _i10.Future<_i2.Response<int>> getStatusProva({int? idProva}) => (super
      .noSuchMethod(Invocation.method(#getStatusProva, [], {#idProva: idProva}),
          returnValue: _i10.Future<_i2.Response<int>>.value(
              _FakeResponse_16<int>(
                  this,
                  Invocation.method(
                      #getStatusProva, [], {#idProva: idProva})))) as _i10
      .Future<_i2.Response<int>>);
  @override
  _i10.Future<_i2.Response<bool>> setStatusProva(
          {int? idProva,
          int? status,
          int? tipoDispositivo,
          int? dataInicio,
          int? dataFim}) =>
      (super.noSuchMethod(
          Invocation.method(#setStatusProva, [], {
            #idProva: idProva,
            #status: status,
            #tipoDispositivo: tipoDispositivo,
            #dataInicio: dataInicio,
            #dataFim: dataFim
          }),
          returnValue:
              _i10.Future<_i2.Response<bool>>.value(_FakeResponse_16<bool>(
                  this,
                  Invocation.method(#setStatusProva, [], {
                    #idProva: idProva,
                    #status: status,
                    #tipoDispositivo: tipoDispositivo,
                    #dataInicio: dataInicio,
                    #dataFim: dataFim
                  })))) as _i10.Future<_i2.Response<bool>>);
  @override
  _i10.Future<_i2.Response<List<_i14.QuestaoRespostaResponseDTO>>>
      getRespostasPorProvaId({int? idProva}) => (super.noSuchMethod(
          Invocation.method(#getRespostasPorProvaId, [], {#idProva: idProva}),
          returnValue:
              _i10.Future<_i2.Response<List<_i14.QuestaoRespostaResponseDTO>>>.value(
                  _FakeResponse_16<List<_i14.QuestaoRespostaResponseDTO>>(this,
                      Invocation.method(#getRespostasPorProvaId, [], {#idProva: idProva})))) as _i10
          .Future<_i2.Response<List<_i14.QuestaoRespostaResponseDTO>>>);
  @override
  _i10.Future<_i2.Response<List<_i15.ProvaAnteriorResponseDTO>>>
      getProvasAnteriores() => (super.noSuchMethod(
          Invocation.method(#getProvasAnteriores, []),
          returnValue:
              _i10.Future<_i2.Response<List<_i15.ProvaAnteriorResponseDTO>>>.value(
                  _FakeResponse_16<List<_i15.ProvaAnteriorResponseDTO>>(this,
                      Invocation.method(#getProvasAnteriores, [])))) as _i10
          .Future<_i2.Response<List<_i15.ProvaAnteriorResponseDTO>>>);
}

/// A class which mocks [QuestaoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuestaoService extends _i1.Mock implements _i3.QuestaoService {
  MockQuestaoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ChopperClient get client => (super.noSuchMethod(
          Invocation.getter(#client),
          returnValue: _FakeChopperClient_0(this, Invocation.getter(#client)))
      as _i2.ChopperClient);
  @override
  set client(_i2.ChopperClient? _client) =>
      super.noSuchMethod(Invocation.setter(#client, _client),
          returnValueForMissingStub: null);
  @override
  Type get definitionType => (super.noSuchMethod(
          Invocation.getter(#definitionType),
          returnValue: _FakeType_15(this, Invocation.getter(#definitionType)))
      as Type);
  @override
  _i10.Future<_i2.Response<_i16.QuestaoResponseDTO>> getQuestao({int? idQuestao}) =>
      (super.noSuchMethod(
          Invocation.method(#getQuestao, [], {#idQuestao: idQuestao}),
          returnValue: _i10.Future<_i2.Response<_i16.QuestaoResponseDTO>>.value(
              _FakeResponse_16<_i16.QuestaoResponseDTO>(
                  this,
                  Invocation.method(
                      #getQuestao, [], {#idQuestao: idQuestao})))) as _i10
          .Future<_i2.Response<_i16.QuestaoResponseDTO>>);
  @override
  _i10.Future<_i2.Response<List<_i17.QuestaoCompletaResponseDTO>>>
      getQuestaoCompleta({List<int>? ids}) => (super.noSuchMethod(
              Invocation.method(#getQuestaoCompleta, [], {#ids: ids}),
              returnValue:
                  _i10.Future<_i2.Response<List<_i17.QuestaoCompletaResponseDTO>>>.value(
                      _FakeResponse_16<List<_i17.QuestaoCompletaResponseDTO>>(
                          this,
                          Invocation.method(#getQuestaoCompleta, [], {#ids: ids}))))
          as _i10.Future<_i2.Response<List<_i17.QuestaoCompletaResponseDTO>>>);
  @override
  _i10.Future<_i2.Response<List<_i18.QuestaoDetalhesLegadoResponseDTO>>>
      getQuestaoCompletaLegado({List<int>? idsLegado}) => (super
          .noSuchMethod(Invocation.method(#getQuestaoCompletaLegado, [], {#idsLegado: idsLegado}),
              returnValue: _i10.Future<_i2.Response<List<_i18.QuestaoDetalhesLegadoResponseDTO>>>.value(
                  _FakeResponse_16<List<_i18.QuestaoDetalhesLegadoResponseDTO>>(
                      this,
                      Invocation.method(#getQuestaoCompletaLegado, [], {#idsLegado: idsLegado})))) as _i10
          .Future<_i2.Response<List<_i18.QuestaoDetalhesLegadoResponseDTO>>>);
}

/// A class which mocks [UsuarioStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockUsuarioStore extends _i1.Mock implements _i19.UsuarioStore {
  MockUsuarioStore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set token(String? _token) =>
      super.noSuchMethod(Invocation.setter(#token, _token),
          returnValueForMissingStub: null);
  @override
  set tokenDataHoraExpiracao(DateTime? _tokenDataHoraExpiracao) =>
      super.noSuchMethod(
          Invocation.setter(#tokenDataHoraExpiracao, _tokenDataHoraExpiracao),
          returnValueForMissingStub: null);
  @override
  set ultimoLogin(DateTime? _ultimoLogin) =>
      super.noSuchMethod(Invocation.setter(#ultimoLogin, _ultimoLogin),
          returnValueForMissingStub: null);
  @override
  set nome(String? _nome) => super.noSuchMethod(Invocation.setter(#nome, _nome),
      returnValueForMissingStub: null);
  @override
  set codigoEOL(String? _codigoEOL) =>
      super.noSuchMethod(Invocation.setter(#codigoEOL, _codigoEOL),
          returnValueForMissingStub: null);
  @override
  set ano(String? _ano) => super.noSuchMethod(Invocation.setter(#ano, _ano),
      returnValueForMissingStub: null);
  @override
  set tipoTurno(String? _tipoTurno) =>
      super.noSuchMethod(Invocation.setter(#tipoTurno, _tipoTurno),
          returnValueForMissingStub: null);
  @override
  set tamanhoFonte(double? _tamanhoFonte) =>
      super.noSuchMethod(Invocation.setter(#tamanhoFonte, _tamanhoFonte),
          returnValueForMissingStub: null);
  @override
  _i20.ModalidadeEnum get modalidade => (super.noSuchMethod(
      Invocation.getter(#modalidade),
      returnValue: _i20.ModalidadeEnum.NAO_CADASTRADO) as _i20.ModalidadeEnum);
  @override
  set modalidade(_i20.ModalidadeEnum? _modalidade) =>
      super.noSuchMethod(Invocation.setter(#modalidade, _modalidade),
          returnValueForMissingStub: null);
  @override
  int get inicioTurno =>
      (super.noSuchMethod(Invocation.getter(#inicioTurno), returnValue: 0)
          as int);
  @override
  set inicioTurno(int? _inicioTurno) =>
      super.noSuchMethod(Invocation.setter(#inicioTurno, _inicioTurno),
          returnValueForMissingStub: null);
  @override
  int get fimTurno =>
      (super.noSuchMethod(Invocation.getter(#fimTurno), returnValue: 0) as int);
  @override
  set fimTurno(int? _fimTurno) =>
      super.noSuchMethod(Invocation.setter(#fimTurno, _fimTurno),
          returnValueForMissingStub: null);
  @override
  set dreAbreviacao(String? _dreAbreviacao) =>
      super.noSuchMethod(Invocation.setter(#dreAbreviacao, _dreAbreviacao),
          returnValueForMissingStub: null);
  @override
  set escola(String? _escola) =>
      super.noSuchMethod(Invocation.setter(#escola, _escola),
          returnValueForMissingStub: null);
  @override
  set turma(String? _turma) =>
      super.noSuchMethod(Invocation.setter(#turma, _turma),
          returnValueForMissingStub: null);
  @override
  set familiaFonte(_i21.FonteTipoEnum? _familiaFonte) =>
      super.noSuchMethod(Invocation.setter(#familiaFonte, _familiaFonte),
          returnValueForMissingStub: null);
  @override
  _i9.ObservableList<_i22.DeficienciaEnum> get deficiencias =>
      (super.noSuchMethod(Invocation.getter(#deficiencias),
              returnValue: _FakeObservableList_17<_i22.DeficienciaEnum>(
                  this, Invocation.getter(#deficiencias)))
          as _i9.ObservableList<_i22.DeficienciaEnum>);
  @override
  set deficiencias(_i9.ObservableList<_i22.DeficienciaEnum>? _deficiencias) =>
      super.noSuchMethod(Invocation.setter(#deficiencias, _deficiencias),
          returnValueForMissingStub: null);
  @override
  bool get isRespondendoProva =>
      (super.noSuchMethod(Invocation.getter(#isRespondendoProva),
          returnValue: false) as bool);
  @override
  set isRespondendoProva(bool? _isRespondendoProva) => super.noSuchMethod(
      Invocation.setter(#isRespondendoProva, _isRespondendoProva),
      returnValueForMissingStub: null);
  @override
  bool get isAdmin =>
      (super.noSuchMethod(Invocation.getter(#isAdmin), returnValue: false)
          as bool);
  @override
  set isAdmin(bool? _isAdmin) =>
      super.noSuchMethod(Invocation.setter(#isAdmin, _isAdmin),
          returnValueForMissingStub: null);
  @override
  bool get isLogado =>
      (super.noSuchMethod(Invocation.getter(#isLogado), returnValue: false)
          as bool);
  @override
  _i9.ReactiveContext get context =>
      (super.noSuchMethod(Invocation.getter(#context),
              returnValue:
                  _FakeReactiveContext_18(this, Invocation.getter(#context)))
          as _i9.ReactiveContext);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  _i10.Future<void> carregarUsuario() =>
      (super.noSuchMethod(Invocation.method(#carregarUsuario, []),
              returnValue: _i10.Future<void>.value(),
              returnValueForMissingStub: _i10.Future<void>.value())
          as _i10.Future<void>);
  @override
  _i10.Future<void> atualizarDados(
          {String? nome,
          String? codigoEOL,
          String? token,
          String? ano,
          String? tipoTurno,
          DateTime? ultimoLogin,
          double? tamanhoFonte,
          _i21.FonteTipoEnum? familiaFonte,
          _i20.ModalidadeEnum? modalidade,
          int? inicioTurno,
          int? fimTurno,
          String? dreAbreviacao,
          String? escola,
          String? turma,
          List<_i22.DeficienciaEnum>? deficiencias}) =>
      (super.noSuchMethod(
              Invocation.method(#atualizarDados, [], {
                #nome: nome,
                #codigoEOL: codigoEOL,
                #token: token,
                #ano: ano,
                #tipoTurno: tipoTurno,
                #ultimoLogin: ultimoLogin,
                #tamanhoFonte: tamanhoFonte,
                #familiaFonte: familiaFonte,
                #modalidade: modalidade,
                #inicioTurno: inicioTurno,
                #fimTurno: fimTurno,
                #dreAbreviacao: dreAbreviacao,
                #escola: escola,
                #turma: turma,
                #deficiencias: deficiencias
              }),
              returnValue: _i10.Future<void>.value(),
              returnValueForMissingStub: _i10.Future<void>.value())
          as _i10.Future<void>);
  @override
  _i10.Future<void> atualizarDadosAdm(
          {String? nome, bool? isAdmin, String? codigoEOL, String? token}) =>
      (super.noSuchMethod(
              Invocation.method(#atualizarDadosAdm, [], {
                #nome: nome,
                #isAdmin: isAdmin,
                #codigoEOL: codigoEOL,
                #token: token
              }),
              returnValue: _i10.Future<void>.value(),
              returnValueForMissingStub: _i10.Future<void>.value())
          as _i10.Future<void>);
}

/// A class which mocks [DownloadService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDownloadService extends _i1.Mock implements _i5.DownloadService {
  MockDownloadService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ChopperClient get client => (super.noSuchMethod(
          Invocation.getter(#client),
          returnValue: _FakeChopperClient_0(this, Invocation.getter(#client)))
      as _i2.ChopperClient);
  @override
  set client(_i2.ChopperClient? _client) =>
      super.noSuchMethod(Invocation.setter(#client, _client),
          returnValueForMissingStub: null);
  @override
  Type get definitionType => (super.noSuchMethod(
          Invocation.getter(#definitionType),
          returnValue: _FakeType_15(this, Invocation.getter(#definitionType)))
      as Type);
  @override
  _i10.Future<_i2.Response<String>> informarDownloadConcluido(
          {int? provaId,
          int? tipoDispositivo,
          String? dispositivoId,
          String? modeloDispositivo,
          String? versao,
          String? dataHora}) =>
      (super.noSuchMethod(
          Invocation.method(#informarDownloadConcluido, [], {
            #provaId: provaId,
            #tipoDispositivo: tipoDispositivo,
            #dispositivoId: dispositivoId,
            #modeloDispositivo: modeloDispositivo,
            #versao: versao,
            #dataHora: dataHora
          }),
          returnValue:
              _i10.Future<_i2.Response<String>>.value(_FakeResponse_16<String>(
                  this,
                  Invocation.method(#informarDownloadConcluido, [], {
                    #provaId: provaId,
                    #tipoDispositivo: tipoDispositivo,
                    #dispositivoId: dispositivoId,
                    #modeloDispositivo: modeloDispositivo,
                    #versao: versao,
                    #dataHora: dataHora
                  })))) as _i10.Future<_i2.Response<String>>);
  @override
  _i10.Future<_i2.Response<void>> removerDownloads(
          {String? chaveAPI, List<String>? ids}) =>
      (super.noSuchMethod(Invocation.method(#removerDownloads, [], {#chaveAPI: chaveAPI, #ids: ids}),
          returnValue: _i10.Future<_i2.Response<void>>.value(
              _FakeResponse_16<void>(
                  this,
                  Invocation.method(#removerDownloads, [], {
                    #chaveAPI: chaveAPI,
                    #ids: ids
                  })))) as _i10.Future<_i2.Response<void>>);
}

/// A class which mocks [BaseResponse].
///
/// See the documentation for Mockito's code generation for more information.
class MockBaseResponse extends _i1.Mock implements _i23.BaseResponse {
  MockBaseResponse() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get statusCode =>
      (super.noSuchMethod(Invocation.getter(#statusCode), returnValue: 0)
          as int);
  @override
  Map<String, String> get headers =>
      (super.noSuchMethod(Invocation.getter(#headers),
          returnValue: <String, String>{}) as Map<String, String>);
  @override
  bool get isRedirect =>
      (super.noSuchMethod(Invocation.getter(#isRedirect), returnValue: false)
          as bool);
  @override
  bool get persistentConnection =>
      (super.noSuchMethod(Invocation.getter(#persistentConnection),
          returnValue: false) as bool);
}

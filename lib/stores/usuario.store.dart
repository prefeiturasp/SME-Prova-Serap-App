import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

@LazySingleton()
class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  final SharedPreferences _sharedPreferences;

  @observable
  String? token;

  @observable
  DateTime? tokenDataHoraExpiracao;

  @observable
  DateTime? ultimoLogin;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;

  @observable
  String? tipoTurno;

  @observable
  double? tamanhoFonte = 16;

  @observable
  ModalidadeEnum modalidade = ModalidadeEnum.NAO_CADASTRADO;

  @observable
  int inicioTurno = 7;

  @observable
  int fimTurno = 17;

  @observable
  String? dreAbreviacao;

  @observable
  String? escola;

  @observable
  String? turma;

  @observable
  FonteTipoEnum? familiaFonte = FonteTipoEnum.POPPINS;

  @observable
  ObservableList<DeficienciaEnum> deficiencias = ObservableList<DeficienciaEnum>();

  @observable
  bool isRespondendoProva = false;

  @observable
  bool isAdmin = false;

  @computed
  bool get isLogado => codigoEOL != null;

  _UsuarioStoreBase(this._sharedPreferences) {
    carregarUsuario();
  }

  @action
  void dispose() {
    if (ano != null && ano!.isNotEmpty) {
      desinscreverTurmaFirebase(ano!);
    }

    nome = null;
    token = null;
    codigoEOL = null;
    ano = null;
    dreAbreviacao = null;
    escola = null;
    turma = null;
    deficiencias = ObservableList<DeficienciaEnum>();

    tamanhoFonte = 16;
    familiaFonte = FonteTipoEnum.POPPINS;
    isAdmin = false;
  }

  @action
  Future<void> carregarUsuario() async {
    nome = _sharedPreferences.getString("serapUsuarioNome");
    token = _sharedPreferences.getString("serapUsuarioToken");
    codigoEOL = _sharedPreferences.getString("serapUsuarioCodigoEOL");
    ano = _sharedPreferences.getString("serapUsuarioAno");
    tipoTurno = _sharedPreferences.getString("serapUsuarioTipoTurno");

    if (_sharedPreferences.containsKey("serapUsuarioDreAbreviacao")) {
      dreAbreviacao = _sharedPreferences.getString("serapUsuarioDreAbreviacao");
    }
    if (_sharedPreferences.containsKey("serapUsuarioEscola")) {
      escola = _sharedPreferences.getString("serapUsuarioEscola");
    }
    if (_sharedPreferences.containsKey("serapUsuarioTurma")) {
      turma = _sharedPreferences.getString("serapUsuarioTurma");
    }

    if (_sharedPreferences.containsKey("serapUsuarioDeficiencia")) {
      deficiencias = ObservableList.of(
          _sharedPreferences.getStringList("serapUsuarioDeficiencia")!.map((e) => DeficienciaEnum.values[int.parse(e)]).toList());
    }

    if (_sharedPreferences.getInt("serapUsuarioInicioTurno") != null) {
      inicioTurno = _sharedPreferences.getInt("serapUsuarioInicioTurno")!;
    }

    if (_sharedPreferences.getInt("serapUsuarioFimTurno") != null) {
      fimTurno = _sharedPreferences.getInt("serapUsuarioFimTurno")!;
    }

    if (_sharedPreferences.getInt("serapUsuarioModalidade") != null) {
      modalidade = ModalidadeEnum.values[_sharedPreferences.getInt('serapUsuarioModalidade')!];
    }

    await _sharedPreferences.setInt('serapUsuarioInicioTurno', inicioTurno);
    await _sharedPreferences.setInt('serapUsuarioFimTurno', fimTurno);

    if (_sharedPreferences.getString("ultimoLogin") != null) {
      ultimoLogin = DateTime.tryParse(_sharedPreferences.getString("ultimoLogin")!);
    }

    if (_sharedPreferences.containsKey('familiaFonte')) {
      familiaFonte = FonteTipoEnum.values[_sharedPreferences.getInt("familiaFonte")!];
    }

    if (_sharedPreferences.containsKey('tamanhoFonte')) {
      tamanhoFonte = _sharedPreferences.getDouble("tamanhoFonte")!;
    }

    if (_sharedPreferences.containsKey('serapIsAdmin')) {
      isAdmin = _sharedPreferences.getBool("serapIsAdmin")!;
    }
  }

  @action
  Future<void> atualizarDados({
    required String nome,
    String? codigoEOL,
    String? token,
    required String ano,
    required String tipoTurno,
    DateTime? ultimoLogin,
    required double tamanhoFonte,
    required FonteTipoEnum familiaFonte,
    required ModalidadeEnum modalidade,
    required int inicioTurno,
    required int fimTurno,
    required String dreAbreviacao,
    required String escola,
    required String turma,
    required List<DeficienciaEnum> deficiencias,
  }) async {
    this.nome = nome;
    this.ano = ano;
    this.tipoTurno = tipoTurno;
    this.ultimoLogin = ultimoLogin;
    this.tamanhoFonte = tamanhoFonte;
    this.familiaFonte = familiaFonte;
    this.modalidade = modalidade;
    this.inicioTurno = inicioTurno;
    this.fimTurno = fimTurno;

    this.dreAbreviacao = dreAbreviacao;
    this.escola = escola;
    this.turma = turma;

    await _sharedPreferences.setString('serapUsuarioNome', nome);

    if (token != null && token.isNotEmpty) {
      this.token = token;
      await _sharedPreferences.setString('serapUsuarioToken', token);
    }

    if (codigoEOL != null && codigoEOL.isNotEmpty) {
      this.codigoEOL = codigoEOL;
      await _sharedPreferences.setString('serapUsuarioCodigoEOL', codigoEOL);
    }

    await _sharedPreferences.setString('serapUsuarioAno', ano);
    await _sharedPreferences.setString('serapUsuarioTipoTurno', tipoTurno);

    await _sharedPreferences.setInt('serapUsuarioModalidade', modalidade.index);
    await _sharedPreferences.setInt('serapUsuarioInicioTurno', inicioTurno);
    await _sharedPreferences.setInt('serapUsuarioFimTurno', fimTurno);

    await _sharedPreferences.setString('serapUsuarioDreAbreviacao', dreAbreviacao);
    await _sharedPreferences.setString('serapUsuarioEscola', escola);
    await _sharedPreferences.setString('serapUsuarioTurma', turma);

    if (this.ultimoLogin != null) {
      await _sharedPreferences.setString('ultimoLogin', ultimoLogin.toString());
    }

    await _sharedPreferences.setDouble('tamanhoFonte', tamanhoFonte);
    await _sharedPreferences.setInt('familiaFonte', familiaFonte.index);

    this.deficiencias = ObservableList.of(deficiencias);
    await _sharedPreferences.setStringList('serapUsuarioDeficiencia', deficiencias.map((e) => e.index.toString()).toList());
  }

  @action
  Future<void> atualizarDadosAdm({
    required String nome,
    required bool isAdmin,
    String? codigoEOL,
    String? token,
  }) async {
    this.nome = nome;
    this.codigoEOL = codigoEOL;
    this.token = token;

    await _sharedPreferences.setString('serapUsuarioNome', nome);
    await _sharedPreferences.setBool('serapIsAdmin', isAdmin);

    if (codigoEOL != null && codigoEOL.isNotEmpty) {
      this.codigoEOL = codigoEOL;
      await _sharedPreferences.setString('serapUsuarioCodigoEOL', codigoEOL);
      await setUserIdentifier(codigoEOL);
    }

    if (token != null && token.isNotEmpty) {
      this.token = token;
      await _sharedPreferences.setString('serapUsuarioToken', token);
    }
  }
}

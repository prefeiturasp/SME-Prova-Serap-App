import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
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
    SharedPreferences prefs = GetIt.I.get();
    nome = prefs.getString("serapUsuarioNome");
    token = prefs.getString("serapUsuarioToken");
    codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    ano = prefs.getString("serapUsuarioAno");
    tipoTurno = prefs.getString("serapUsuarioTipoTurno");

    if (prefs.containsKey("serapUsuarioDreAbreviacao")) {
      dreAbreviacao = prefs.getString("serapUsuarioDreAbreviacao");
    }
    if (prefs.containsKey("serapUsuarioEscola")) {
      escola = prefs.getString("serapUsuarioEscola");
    }
    if (prefs.containsKey("serapUsuarioTurma")) {
      turma = prefs.getString("serapUsuarioTurma");
    }

    if (prefs.containsKey("serapUsuarioDeficiencia")) {
      deficiencias = ObservableList.of(
          prefs.getStringList("serapUsuarioDeficiencia")!.map((e) => DeficienciaEnum.values[int.parse(e)]).toList());
    }

    if (prefs.getInt("serapUsuarioInicioTurno") != null) {
      inicioTurno = prefs.getInt("serapUsuarioInicioTurno")!;
    }

    if (prefs.getInt("serapUsuarioFimTurno") != null) {
      fimTurno = prefs.getInt("serapUsuarioInicioTurno")!;
    }

    if (prefs.getInt("serapUsuarioModalidade") != null) {
      modalidade = ModalidadeEnum.values[prefs.getInt('serapUsuarioModalidade')!];
    }

    await prefs.setInt('serapUsuarioInicioTurno', inicioTurno);
    await prefs.setInt('serapUsuarioFimTurno', fimTurno);

    if (prefs.getString("ultimoLogin") != null) {
      ultimoLogin = DateTime.tryParse(prefs.getString("ultimoLogin")!);
    }

    if (prefs.containsKey('familiaFonte')) {
      familiaFonte = FonteTipoEnum.values[prefs.getInt("familiaFonte")!];
    }

    if (prefs.containsKey('tamanhoFonte')) {
      tamanhoFonte = prefs.getDouble("tamanhoFonte")!;
    }

    if (ano != null && ano!.isNotEmpty) {
      await inscreverTurmaFirebase(ano!);
    }
  }

  @action
  atualizarDados({
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

    SharedPreferences prefs = GetIt.I.get();
    await prefs.setString('serapUsuarioNome', nome);

    if (token != null && token.isNotEmpty) {
      this.token = token;
      await prefs.setString('serapUsuarioToken', token);
    }

    if (codigoEOL != null && codigoEOL.isNotEmpty) {
      this.codigoEOL = codigoEOL;
      await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    }

    await prefs.setString('serapUsuarioAno', ano);
    await prefs.setString('serapUsuarioTipoTurno', tipoTurno);

    await prefs.setInt('serapUsuarioModalidade', modalidade.index);
    await prefs.setInt('serapUsuarioInicioTurno', inicioTurno);
    await prefs.setInt('serapUsuarioFimTurno', fimTurno);

    await prefs.setString('serapUsuarioDreAbreviacao', dreAbreviacao);
    await prefs.setString('serapUsuarioEscola', escola);
    await prefs.setString('serapUsuarioTurma', turma);

    if (this.ultimoLogin != null) {
      await prefs.setString('ultimoLogin', ultimoLogin.toString());
    }

    await prefs.setDouble('tamanhoFonte', tamanhoFonte);
    await prefs.setInt('familiaFonte', familiaFonte.index);

    this.deficiencias = ObservableList.of(deficiencias);
    await prefs.setStringList('serapUsuarioDeficiencia', deficiencias.map((e) => e.index.toString()).toList());

    await inscreverTurmaFirebase(ano);
  }

  @action
  Future<void> atualizarDadosAdm({
    required String nome,
    String? codigoEOL,
    String? token,
  }) async {
    this.nome = nome;
    this.codigoEOL = codigoEOL;
    this.token = token;

    SharedPreferences prefs = GetIt.I.get();
    await prefs.setString('serapUsuarioNome', nome);

    if (codigoEOL != null && codigoEOL.isNotEmpty) {
      this.codigoEOL = codigoEOL;
      await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    }

    if (token != null && token.isNotEmpty) {
      this.token = token;
      await prefs.setString('serapUsuarioToken', token);
    }
  }
}

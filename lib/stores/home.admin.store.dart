import 'package:appserap/dtos/admin_prova.response.dto.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'home.admin.store.g.dart';

class HomeAdminStore = _HomeAdminStoreBase with _$HomeAdminStore;

abstract class _HomeAdminStoreBase with Store, Loggable, Disposable {
  List<ReactionDisposer> _disposers = [];

  @observable
  bool carregando = false;

  @observable
  String codigoIniciarProva = "";

  @observable
  String? codigoSerap = "";

  @observable
  String? desricao = "";

  @observable
  ModalidadeEnum? modalidade;

  @observable
  String? ano;

  @observable
  ObservableList<AdminProvaResponseDTO> provas = ObservableList<AdminProvaResponseDTO>();

  int pagina = 1;
  int totalPaginas = 0;
  int totalRegistros = 0;

  @action
  carregarProvas({bool? refresh}) async {
    if (carregando) {
      return;
    }

    carregando = true;

    await retry(
      () async {
        if (refresh != null && refresh) {
          pagina = 1;
        }

        var provasResponse = await ServiceLocator.get<ApiService>().admin.getProvas(
              numeroPagina: pagina,
              descricao: desricao,
              ano: ano,
              modalidade: modalidade?.codigo,
              provaLegadoId: codigoSerap != null ? int.tryParse(codigoSerap!) : null,
            );

        if (provasResponse.isSuccessful) {
          var provas = provasResponse.body!;

          totalPaginas = provas.totalPaginas;
          totalRegistros = provas.totalRegistros;

          if (refresh != null && refresh == true) {
            this.provas.clear();
          } else {
            pagina++;
          }
          this.provas.addAll(provas.items);
        }
      },
      onRetry: (e) {
        fine('Tentativa de carregamento lista de provas - ${e.toString()}');
      },
    );

    carregando = false;
  }

  @action
  filtrar() async {
    provas.clear();
    pagina = 1;
    await carregarProvas();
  }

  @action
  limparFiltros() {
    desricao = "";
    ano = "";
    modalidade = null;
    codigoSerap = null;
  }

  @override
  onDispose() {
    for (var disposer in _disposers) {
      disposer();
    }
    pagina = 1;
    provas.clear();
    limparFiltros();
  }
}

import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'orientacao_inicial.store.g.dart';

class OrientacaoInicialStore = _OrientacaoInicialStoreBase with _$OrientacaoInicialStore;

abstract class _OrientacaoInicialStoreBase with Store, Loggable {
  final _orientacaoService = GetIt.I.get<ApiService>().orientacoesIniciais;

  @observable
  ObservableList<ApresentacaoModelWidget> listaPaginasOrientacoes = <ApresentacaoModelWidget>[].asObservable();

  @action
  Future<void> popularListaDeOrientacoes() async {
    try {
      var responseOrientacoes = await _orientacaoService.getOrientacoesIniciais();

      if (responseOrientacoes.isSuccessful) {
        var body = responseOrientacoes.body;

        body!.sort((dica1, dica2) => dica1.ordem!.compareTo(dica2.ordem!));

        for (var dica in body) {
          bool mostrarHtml = ((dica.imagem == null || dica.imagem!.isEmpty) && (dica.titulo == null || dica.titulo!.isEmpty));

          if (mostrarHtml) {
            listaPaginasOrientacoes.add(
              ApresentacaoModelWidget(
                titulo: '',
                descricao: '',
                imagem: SizedBox(),
                corpoPersonalizado: Html(
                  data: dica.descricao,
                  style: {
                    '*': Style.fromTextStyle(
                      TextStyle(
                        fontFamily: ServiceLocator.get<TemaStore>()
                            .fonteDoTexto
                            .nomeFonte,
                        fontSize: ServiceLocator.get<TemaStore>().size(16),
                      ),
                    )
                  },
                ),
                ehHTML: true,
              ),
            );
          } else {
            String urlImagem = dica.imagem!;

            listaPaginasOrientacoes.add(
              ApresentacaoModelWidget(
                titulo: dica.titulo,
                descricao: dica.descricao,
                imagem: Center(
                  child: Image.network(
                    urlImagem,
                    height: 250.0,
                  ),
                ),
                corpoPersonalizado: SizedBox(),
              ),
            );
          }
        }
      }
    } catch (e) {
      severe(e);
    }
  }

  Future<Response<List<OrientacaoInicialResponseDTO>>> getOrientacoesIniciais() async {
    return await _orientacaoService.getOrientacoesIniciais();
  }

  void dispose() {
    listaPaginasOrientacoes = <ApresentacaoModelWidget>[].asObservable();
  }
}

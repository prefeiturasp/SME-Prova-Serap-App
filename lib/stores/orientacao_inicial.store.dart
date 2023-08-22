import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:chopper/chopper.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'orientacao_inicial.store.g.dart';

@LazySingleton()
class OrientacaoInicialStore = _OrientacaoInicialStoreBase with _$OrientacaoInicialStore;

abstract class _OrientacaoInicialStoreBase with Store, Loggable {
  final OrientacaoInicialService _orientacaoService;
  final TemaStore _temaStore;

  @observable
  ObservableList<ApresentacaoModelWidget> listaPaginasOrientacoes = <ApresentacaoModelWidget>[].asObservable();

  _OrientacaoInicialStoreBase(
    this._orientacaoService,
    this._temaStore,
  );

  @action
  Future<void> popularListaDeOrientacoes() async {
    try {
      var responseOrientacoes = await _orientacaoService.getOrientacoesIniciais();

      if (responseOrientacoes.isSuccessful) {
        var body = responseOrientacoes.body;

        body!.sort((dica1, dica2) => dica1.ordem!.compareTo(dica2.ordem!));

        for (var dica in body) {
          bool mostrarHtml =
              ((dica.imagem == null || dica.imagem!.isEmpty) && (dica.titulo == null || dica.titulo!.isEmpty));

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
                        fontFamily: _temaStore.fonteDoTexto.nomeFonte,
                        fontSize: _temaStore.size(16),
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
    } catch (e, stack) {
      await recordError(e, stack);
    }
  }

  Future<Response<List<OrientacaoInicialResponseDTO>>> getOrientacoesIniciais() async {
    return await _orientacaoService.getOrientacoesIniciais();
  }

  @disposeMethod
  void dispose() {
    listaPaginasOrientacoes = <ApresentacaoModelWidget>[].asObservable();
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobx/mobx.dart';
import 'package:photo_view/photo_view.dart';

part 'orientacao_inicial.store.g.dart';

class OrientacaoInicialStore = _OrientacaoInicialStoreBase with _$OrientacaoInicialStore;

abstract class _OrientacaoInicialStoreBase with Store, Loggable {
  final usuario = GetIt.I.get<UsuarioStore>();
  final _orientacaoService = GetIt.I.get<ApiService>().orientacoesIniciais;

  @observable
  int pagina = 0;

  @observable
  ObservableList<PageViewModel> listaPaginasOrientacoes = <PageViewModel>[].asObservable();

  @action
  Future<void> popularListaDeOrientacoes() async {
    try {
      var responseOrientacoes = await _orientacaoService.getOrientacoesIniciais();

      if (responseOrientacoes.isSuccessful) {
        var body = responseOrientacoes.body;

        body!.sort((dica1, dica2) => dica1.ordem!.compareTo(dica2.ordem!));

        for (var dica in body) {
          if (dica.imagem == null && dica.titulo == null) {
            listaPaginasOrientacoes.add(
              PageViewModel(
                title: '',
                bodyWidget: Html(
                  data: dica.descricao,
                ),
                decoration: PageDecoration(
                  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
                  bodyTextStyle: TextStyle(fontSize: 19.0),
                  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.zero,
                ),
              ),
            );
          } else {
            //String base64Imagem = base64Encode(dica.imagem!.codeUnits);
            String urlImagem = dica.imagem!;
            print(urlImagem);
            //Uint8List imagem = base64.decode(base64Imagem.split(',').last);

            listaPaginasOrientacoes.add(
              PageViewModel(
                title: dica.titulo,
                body: dica.descricao,
                image: Center(
                  child: Image.network(
                    urlImagem,
                    height: 175.0,
                  ),
                ),
                decoration: PageDecoration(
                  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
                  bodyTextStyle: TextStyle(fontSize: 19.0),
                  descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.zero,
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      severe(e);
    }
  }

  void dispose() {
    pagina = 0;
    listaPaginasOrientacoes = <PageViewModel>[].asObservable();
  }
}
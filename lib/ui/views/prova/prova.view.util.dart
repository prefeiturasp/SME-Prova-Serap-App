import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:flutter/material.dart';

abstract class ProvaViewUtil {
  buildTratamentoImagem(ProvaStore provaStore, List<Arquivo> imagens, Questao questao, List<Alternativa> alternativas) {
    if (imagens.isNotEmpty) {
      return Center(
        child: InkWell(
          onTap: () {
            var usuarioStore = ServiceLocator.get<UsuarioStore>();

            var html = _criarHTML(provaStore, imagens, questao, alternativas);

            if (html.isNotEmpty) {
              if (provaStore.ultimaAtualizacaoLogImagem == null ||
                  DateTime.now().difference(provaStore.ultimaAtualizacaoLogImagem!).inSeconds > 15) {
                ServiceLocator.get<ApiService>().log.logarNecessidadeDeUsoDaUrl(
                      chaveAPI: AppConfigReader.getChaveApi(),
                      prova: provaStore.id.toString(),
                      aluno: usuarioStore.codigoEOL!,
                      escola: usuarioStore.escola!,
                      html: html,
                    );

                provaStore.ultimaAtualizacaoLogImagem = DateTime.now();
              }
            }

            if (provaStore.tratamentoImagem == TratamentoImagemEnum.BASE64) {
              provaStore.tratamentoImagem = TratamentoImagemEnum.URL;
            } else {
              provaStore.tratamentoImagem = TratamentoImagemEnum.BASE64;
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.refresh, size: 14),
              Texto(" Caso não consiga visualizar a(s) imagem(s), clique aqui"),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  String _criarHTML(ProvaStore provaStore, List<Arquivo> imagens, Questao questao, List<Alternativa> alternativas) {
    String html = "";

    if (questao.titulo != null) {
      if (questao.titulo!.contains(RegExp(r'#\d+#'))) {
        html += tratarArquivos(questao.titulo, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem);

        html += "<br><br>";
      }
    }

    if (questao.descricao.contains(RegExp(r'#\d+#'))) {
      html += tratarArquivos(questao.descricao, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem);

      html += "<br><br>";
    }

    for (var alternativa in alternativas) {
      if (alternativa.descricao.contains(RegExp(r'#\d+#'))) {
        html += tratarArquivos(alternativa.descricao, imagens, EnumTipoImagem.ALTERNATIVA, provaStore.tratamentoImagem);

        html += "<br><br>";
      }
    }

    return html;
  }

  String tratarArquivos(
    String? texto,
    List<Arquivo> arquivos,
    EnumTipoImagem tipoImagem,
    TratamentoImagemEnum tratamentoImagem,
  ) {
    if (texto == null) {
      return "";
    }

    if (tipoImagem == EnumTipoImagem.QUESTAO) {
      texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
        return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
      });
    }

    for (var arquivo in arquivos) {
      switch (tratamentoImagem) {
        case TratamentoImagemEnum.BASE64:
          var obterTipo = arquivo.caminho.split(".");
          texto = texto!.replaceAll(
            "#${arquivo.legadoId}#",
            "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}",
          );
          break;
        case TratamentoImagemEnum.URL:
          texto = texto!.replaceAll(
            "#${arquivo.legadoId}#",
            arquivo.caminho,
          );
          break;
      }
    }

    texto = texto!.replaceAll("#0#", AssetsUtil.notfound);

    return texto;
  }
}

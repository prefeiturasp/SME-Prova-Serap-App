import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/prova/prova.view.util.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class QuestaoAdminWidget extends StatelessWidget with ProvaViewUtil {
  final TemaStore temaStore = ServiceLocator.get<TemaStore>();
  final controller = HtmlEditorController();

  final QuestaoResponseDTO questao;
  final List<ArquivoResponseDTO> imagens;
  final List<AlternativaResponseDTO> alternativas;

  QuestaoAdminWidget({
    Key? key,
    required this.questao,
    required this.imagens,
    required this.alternativas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Observer(builder: (_) {
          return renderizarHtml(
            context,
            questao.titulo,
            imagens.map((e) => e.toArquivoModel()).toList(),
            EnumTipoImagem.QUESTAO,
            TratamentoImagemEnum.URL,
          );
        }),
        SizedBox(height: 8),
        Observer(builder: (_) {
          return renderizarHtml(
            context,
            questao.descricao,
            imagens.map((e) => e.toArquivoModel()).toList(),
            EnumTipoImagem.QUESTAO,
            TratamentoImagemEnum.URL,
          );
        }),
        SizedBox(height: 16),
        _buildResposta(),
      ],
    );
  }

  Widget _buildResposta() {
    switch (questao.tipo) {
      case EnumTipoQuestao.MULTIPLA_ESCOLHA:
        return _buildAlternativas();
      case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
        return _buildRespostaConstruida();

      default:
        return SizedBox.shrink();
    }
  }

  _buildRespostaConstruida() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Texto(
              "Resposta Construida",
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _buildAlternativas() {
    alternativas.sort((a, b) => a.ordem.compareTo(b.ordem));
    return ListTileTheme.merge(
      horizontalTitleGap: 0,
      child: Column(
        children: alternativas
            .map((e) => _buildAlternativa(
                  e.id,
                  e.numeracao,
                  e.descricao,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAlternativa(int idAlternativa, String numeracao, String descricao) {
    return Observer(
      builder: (_) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.34),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: ListTile(
            dense: true,
            title: Row(
              children: [
                Text(
                  "$numeracao ",
                  style: TemaUtil.temaTextoNumeracao.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Expanded(
                  child: Observer(builder: (context) {
                    return renderizarHtml(
                      context,
                      descricao,
                      imagens.map((e) => e.toArquivoModel()).toList(),
                      EnumTipoImagem.ALTERNATIVA,
                      TratamentoImagemEnum.URL,
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

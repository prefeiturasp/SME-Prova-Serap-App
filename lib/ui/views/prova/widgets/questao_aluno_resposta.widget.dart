import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/prova/prova.view.util.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class QuestaoAlunoRespostaWidget extends StatelessWidget with Loggable, ProvaViewUtil {
  final TemaStore temaStore = sl<TemaStore>();
  final HtmlEditorController controller;

  final Questao questao;
  final List<Arquivo> imagens;
  final List<Alternativa> alternativas;
  final int? ordemAlternativaCorreta;
  final int? ordemAlternativaResposta;
  final String? respostaConstruida;

  QuestaoAlunoRespostaWidget({
    Key? key,
    required this.controller,
    required this.questao,
    required this.imagens,
    required this.alternativas,
    required this.ordemAlternativaCorreta,
    required this.ordemAlternativaResposta,
    required this.respostaConstruida,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Observer(builder: (_) {
          return renderizarHtml(
            context,
            questao.titulo,
            imagens,
            EnumTipoImagem.QUESTAO,
            TratamentoImagemEnum.URL,
          );
        }),
        SizedBox(height: 8),
        Observer(builder: (_) {
          return renderizarHtml(
            context,
            questao.descricao,
            imagens,
            EnumTipoImagem.QUESTAO,
            TratamentoImagemEnum.URL,
          );
        }),
        SizedBox(height: 16),
        _buildResposta(questao),
      ],
    );
  }

  Widget _buildResposta(Questao questao) {
    switch (questao.tipo) {
      case EnumTipoQuestao.MULTIPLA_ESCOLHA:
        return _buildAlternativas(questao);
      case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
        return _buildRespostaConstruida(questao);

      default:
        return SizedBox.shrink();
    }
  }

  _buildRespostaConstruida(Questao questao) {
    return Column(
      children: [
        //
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Observer(builder: (_) {
              return HtmlEditor(
                controller: controller,
                callbacks: Callbacks(
                  onInit: () {
                    controller.execCommand('fontName', argument: temaStore.fonteDoTexto.nomeFonte);
                    controller.setText(respostaConstruida ?? "");
                    controller.disable();
                  },
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.belowEditor,
                  defaultToolbarButtons: [
                    FontButtons(
                      subscript: false,
                      superscript: false,
                      strikethrough: false,
                    ),
                    ParagraphButtons(
                      lineHeight: false,
                      caseConverter: false,
                      decreaseIndent: true,
                      increaseIndent: true,
                      textDirection: false,
                      alignRight: false,
                    ),
                    ListButtons(
                      listStyles: false,
                    ),
                  ],
                ),
                htmlEditorOptions: HtmlEditorOptions(
                  autoAdjustHeight: false,
                  hint: "Digite sua resposta aqui...",
                ),
                otherOptions: OtherOptions(
                  height: 400,
                ),
              );
            }),
          ),
        ),
        //
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: double.infinity,
          child: Texto(
            'Caracteres digitados: ${respostaConstruida?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').length}',
            textAlign: TextAlign.end,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  _buildAlternativas(Questao questao) {
    alternativas.sort((a, b) => a.ordem.compareTo(b.ordem));
    return ListTileTheme.merge(
      horizontalTitleGap: 0,
      child: Column(
        children: alternativas
            .map((e) => _buildAlternativa(
                  e.id,
                  e.numeracao,
                  questao,
                  e.descricao,
                  e.ordem,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAlternativa(
    int idAlternativa,
    String numeracao,
    Questao questao,
    String descricao,
    int ordem,
  ) {
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
          child: RadioListTile<int>(
            contentPadding: EdgeInsets.all(0),
            toggleable: true,
            dense: true,
            value: idAlternativa,
            groupValue: ordemAlternativaResposta == ordem ? idAlternativa : null,
            onChanged: (value) async {},
            title: Row(
              children: [
                _buildResultadoIcone(ordemAlternativaCorreta == ordem),
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
                      imagens,
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

  _buildResultadoIcone(bool acerto) {
    if (acerto) {
      return Icon(
        Icons.check,
        color: TemaUtil.verde01,
      );
    }

    return Icon(
      Icons.close,
      color: TemaUtil.vermelhoErro,
    );
  }
}

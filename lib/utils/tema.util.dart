import 'package:flutter/material.dart';

abstract class TemaUtil {
  //! CORES
  static const corDeFundo = Color(0xFFFFF8F3);
  static const appBar = Color(0xFF2F304E);
  static const laranja01 = Color(0xFFFF7755);
  static const laranja02 = Color(0xFFF2945B);
  static const laranja03 = Color(0xFFE99312);
  static const laranja04 = Color(0xFFF9A82F);
  static const vermelhoErro = Color(0xFFF92F57);
  static const branco = Colors.white;
  static const cinza = Colors.grey;
  static const preto = Colors.black;
  static const pretoSemFoco = Colors.black54;
  static const pretoSemFoco2 = Colors.black38;
  static const azul = Colors.blue;
  static const azulScroll = Color(0xff10A1C1);
  static const verde01 = Colors.green;
  static const verde02 = Color(0xff62C153);

  //* TEMA DE TEXTOS
  // static dynamic textoPrincipal(BuildContext context) {
  //   return GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
  // }

  //TEMA TEXTO PADRÃO
  static const temaTextoPadrao = TextStyle(
    color: TemaUtil.preto,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const temaTextoPadraoNegrito = TextStyle(
    color: TemaUtil.preto,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO ERRO
  static const temaTextoErro = TextStyle(
    color: TemaUtil.vermelhoErro,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const temaTextoErroNegrito = TextStyle(
    color: TemaUtil.vermelhoErro,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO BOTÃO
  static const temaTextoBotao = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  //TEMA TEXTO AGUARDANDO ENVIO
  static const temaTextoAguardandoEnvio = TextStyle(
    color: TemaUtil.laranja01,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO BEM VINDO
  static const temaTextoBemVindo = TextStyle(
    color: Colors.black87,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO BEM VINDO
  static const temaTextoHtmlPadrao = TextStyle(
    color: TemaUtil.preto,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  //TEMA TEXTO NUMERO QUESTÕES
  static const temaTextoNumeroQuestoes = TextStyle(
    color: TemaUtil.preto,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  //TEMA TEXTO NUMERO TOTAL QUESTÕES
  static const temaTextoNumeroQuestoesTotal = TextStyle(
    fontSize: 20,
    color: Colors.grey,
  );

  //TEMA TEXTO NUMERACAO
  static const temaTextoNumeracao = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  //TEMA TEXTO FECHAR IMAGEM
  static const temaTextoFecharImagem = TextStyle(
    fontSize: 18,
    color: TemaUtil.laranja02,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO INSERIR SENHA
  static const temaTextoInserirSenha = TextStyle(
    color: TemaUtil.preto,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  //TEMA QUESTAO SEM RESPOSTA
  static const temaTextoQuestaoSemResposta = TextStyle(
    color: TemaUtil.laranja03,
    fontSize: 14,
  );

  //TEMA TABELA RESUMO
  static const temaTextoTabelaResumo = TextStyle(
    fontSize: 14,
    color: TemaUtil.appBar,
  );

  //TEMA TEXTO APPBAR
  static const temaTextoAppBar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  //TEMA TEXTO BOTAO SECUNDARIO
  static const temaTextoBotaoSecundario = TextStyle(
    color: TemaUtil.pretoSemFoco,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  //TEMA TEXTO MENSAGEM DIALOG
  static const temaTextoMensagemDialog = TextStyle(
    color: Colors.black87,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  //TEMA TEXTO TEMPO DIALOG
  static const temaTextoTempoDialog = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.black87,
  );

  //TEMA TEXTO DURACAO DIALOG
  static const temaTextoDuracaoDialog = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  //TEMA TEXTO DURACAO DIALOG
  static const temaTextoMensagemCorpo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

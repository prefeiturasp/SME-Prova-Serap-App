import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/dtos/autenticacao_dados.response.dto.dart';
import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';

class UserFixture {
  final userEOL = "1234567";
  final userPassword = "1234";

  final autenticacaoDadosResponse = AutenticacaoDadosResponseDTO(
    "Nome do Aluno",
    "5",
    "3",
    16.0,
    FonteTipoEnum.POPPINS,
    ModalidadeEnum.FUNDAMENTAL,
    8,
    12,
    "DRE",
    "Escola",
    "Turma",
    [
      DeficienciaEnum.SURDEZ_LEVE_OU_MODERADA,
    ],
  );

  final autenticacaoResponse = AutenticacaoResponseDTO(
    token:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJTZXJhcCIsImlhdCI6MTYzNDgyNTk0NCwiZXhwIjoxNjY2MzYyMDI1LCJhdWQiOiJQcmVmZWl0dXJhIGRlIFNhbyBQYXVsbyIsInN1YiI6IiIsIlJBIjoiMTIzNDU2NyIsIkFOTyI6IjQiLCJUSVBPVFVSTk8iOiIzIn0.Cl2akri0NCmAWsIjlgUNGlfEDDCQs9LTKmYDH8S_CI4",
    dataHoraExpiracao: DateTime.parse("2022-10-21T14:20:25.6280482+00:00"),
  );

  final autenticacaoRevalidarResponse = AutenticacaoResponseDTO(
    token:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJTZXJhcCIsImlhdCI6MTYzNDgyNTk0NCwiZXhwIjoxNjY2MzgwNzIxLCJhdWQiOiJQcmVmZWl0dXJhIGRlIFNhbyBQYXVsbyIsInN1YiI6IiIsIlJBIjoiMTIzNDU2NyIsIkFOTyI6IjQiLCJUSVBPVFVSTk8iOiIzIn0.S8zXnA33Uezz3ah22B8ThAIxu57Wt_cs_TFevGFGFUo",
    dataHoraExpiracao: DateTime.parse("2022-10-21T19:32:01.6280482+00:00"),
  );
}

class UserJsonFixture {
  final autenticacaoResponseJson = """
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJTZXJhcCIsImlhdCI6MTYzNDgyNTk0NCwiZXhwIjoxNjY2MzYyMDI1LCJhdWQiOiJQcmVmZWl0dXJhIGRlIFNhbyBQYXVsbyIsInN1YiI6IiIsIlJBIjoiMTIzNDU2NyIsIkFOTyI6IjQiLCJUSVBPVFVSTk8iOiIzIn0.Cl2akri0NCmAWsIjlgUNGlfEDDCQs9LTKmYDH8S_CI4",
  "dataHoraExpiracao": "2022-10-21T14:20:25.6280482+00:00"
}
  """;

  final autenticacaoRevalidateResponseJson = """
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJTZXJhcCIsImlhdCI6MTYzNDgyNTk0NCwiZXhwIjoxNjY2MzgwNzIxLCJhdWQiOiJQcmVmZWl0dXJhIGRlIFNhbyBQYXVsbyIsInN1YiI6IiIsIlJBIjoiMTIzNDU2NyIsIkFOTyI6IjQiLCJUSVBPVFVSTk8iOiIzIn0.S8zXnA33Uezz3ah22B8ThAIxu57Wt_cs_TFevGFGFUo",
  "dataHoraExpiracao": "2022-10-21T19:32:01.572Z"
}
  """;

  final autenticacaoDadosResponseJson = """
{
  "dreAbreviacao": "DRE - JT",
  "escola": "Escola",
  "turma": "5B",
  "nome": "Nome do Aluno",
  "ano": "5",
  "tipoTurno": "3",
  "tamanhoFonte": 16,
  "modalidade": 5,
  "familiaFonte": 1,
  "inicioTurno": 12,
  "fimTurno": 19,
  "deficiencias": []
}
  """;
}

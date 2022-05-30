[![CI](https://github.com/prefeiturasp/SME-Prova-Serap-App/actions/workflows/main.yml/badge.svg)](https://github.com/prefeiturasp/SME-Prova-Serap-App/actions/workflows/main.yml)

# Instalação e Configuração

Para iniciar o desenvolvimento da aplicação primeiro você precisa ter o Flutter instalado.

`flutter pub get`

É preciso criar a pasta `config` na raiz do projeto e o arquivo `config/app_config.json` com o formato a seguir (lembre-se de trocar os valores de acordo com sua necessidade):

```json
{
    "environment": "DEV, PROD etc...",
    "sentryDsn": "Seu DSN do Sentry",
    "apiHost": "https://endereco.da.api/api/v1",
    "chaveApi": "Chave API",
    "debugSQL" : false,
    "levelLog" : "INFO"
}
```

A aplicação utiliza o recurso de generators do Flutter, logo precisamos rodar o build_runner para gerar os códigos necessários para o desenvolvimento.

`flutter pub run build_runner build --delete-conflicting-outputs`

flutter run -t lib/main.dart
flutter run -t lib/main.web.dart

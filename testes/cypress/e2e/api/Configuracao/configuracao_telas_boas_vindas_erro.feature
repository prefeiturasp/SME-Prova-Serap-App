Feature: Consultar lista de vídeos de boas-vindas  
  Como um cliente da API  
  Quero consultar a lista de vídeos de boas-vindas  
  Para verificar se as informações retornadas estão corretas  

  Background:  
    Given que possuo um token de autenticação válido  

  Scenario: Consulta bem sucedida da lista de vídeos de boas-vindas  
    When eu faço uma requisição GET para "/api/v1/configuracoes/telas-boas-vindas"  
    Then o status da resposta deve ser 200  
    And o corpo da resposta deve conter a lista de vídeos com os campos esperados  
    And um dos itens deve falhar a validação de "imagem"

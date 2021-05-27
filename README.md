# S3 Log Cat

Por padrão diversas soluções da AWS armazenam seus logs no S3 para posterior consulta ou guarda de evidências para investigação de incidentes ou entendimento de comportamento de um determinado serviço.

Este script é feito para automatizar a coleta de logs que são armazenados pela AWS no S3 e envia-la para o Graylog ou Elasticsearch pelo uso do Filebeat.

# Arquitetura

A ideia da automação é via coleta pelo uso de EC2 adicionando em uma cron que executa a cada minuto.

### Permissão da AWS

Foi criado uma conta para a coleta de dados do S3 com permissão de acesso aos buckets para que se possa baixar os logs.

# Requisitos
* aws cli
* credenciais aws com permissão no s3
* filebeat

# Modo de Funcionamento

Uma vez que os requisitos tenham sido atendidos, basta configurar o script com o bucket que deseja realizar a coleta.

Adicione o script na cron do sistema para que seja executado a cada minuto.

O script irá executar e baixar o arquivo de log para a pasta local. 

O filebeat que está configurado pelo arquivo de configuração para coletar a cada 30 segundos os arquivos do tipo log e enviam automaticamente para o servidor de destino.

A cada execução o script irá apagar o arquivo anterior e baixará um novo.

## Variáveis do Sript
Para o correto script é importante estabelecer dentro das variáveis do programa os itens:

* bucketName - Nome do bucket
* saveName - Subpasta do bucket para salvar o arquivo
* contaAWS - ID da conta da AWS que será executado

## Importante
Existe um comando chdir no script para mudar a execução do arquivo para o local onde serão salvos os logs.
Por padrão o script executa no contexto de /home/user. Se o diretório de execução não for mudado ele vai salvar os logs no /home/user e o filebeat não vai funcionar.


# Referências
* https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html
* https://docs.aws.amazon.com/cli/latest/reference/s3api/get-object.html
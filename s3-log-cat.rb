#!/usr/bin/ruby

# Inicia as variaveis globais
tempo = Time.now
month = ""
day = ""
hour = ""
bucketName = ""
saveName = ""
ultimoArquivo = ""
contaAWS = ""

# Muda o script para o diretório de destino por conta da cron que joga para /home/user
# Remover o comentário para definir o diretório que será salvo os arquivos
#Dir.chdir "/home/ubuntu/s3-log-cat/"

# Abre o arquivo contendo o ultimo arquivo baixado
# Essa ação serve para validação posterior para não baixar o mesmo arquivo novamente
if File.exist?("#{saveName}-lastfile.txt")
    ultimoArquivo = File.read("#{saveName}-lastfile.txt").chomp
else
    File.new("#{saveName}-lastfile.txt",  "w+")
    ultimoArquivo = File.read("#{saveName}-lastfile.txt").chomp
end

# Função que converte o tempo em string e adiciona um 0
def changeTime(tempo)
    if tempo < 10
        tempo = "0" + tempo.to_s
        return(tempo)
    else
        tempo = tempo.to_s
        return(tempo)
    end
end

# Cria as variaveis de tempo
month = changeTime(tempo.month)
day = changeTime(tempo.day)
hour = changeTime(tempo.hour)

# Pega o path. Precisa estar depois da validação do mês
bucketPath = "#{saveName}/AWSLogs/#{contaAWS}/elasticloadbalancing/us-east-1/#{tempo.year}/#{month}/#{day}/"

# Coleta a lista de arquivos que tem no bucket
awsList = `aws s3 ls #{bucketName}/#{bucketPath}`
awsList = awsList.split("\n")

# Pega a ultima linha do bucket e divide em campos data, hora, tamanho, nome do arquivo
ultimaLinhaDoBucket = awsList.last.split("\s")
nomeDoArquivo = ultimaLinhaDoBucket[3]

# Divide o tempo em hora, minuto e segundo
tempoLinhaDoBucket =  ultimaLinhaDoBucket[1].split(":")

# Valida se a ultima linha possui do bucket é a mesma do ultimo arquivo baixado
# Se for arquivo diferente baixa o objeto e descompacta
if nomeDoArquivo != ultimoArquivo
    `echo "#{nomeDoArquivo}" > #{saveName}-lastfile.txt`
    `rm #{saveName}.log`
    `aws s3api get-object --bucket #{bucketName} --key #{bucketPath}#{nomeDoArquivo} #{saveName}.log.gz`
    `gunzip #{saveName}.log.gz`
end
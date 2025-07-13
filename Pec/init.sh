#!/bin/sh

SERVER_SCRIPT="/opt/e-SUS/webserver/standalone.sh"

echo "Aguardando o PostgreSQL inicializar..."
until PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB -c '\q' 2>/dev/null; do
  echo "PostgreSQL indisponível - aguardando..."
  sleep 3
done

echo "PostgreSQL está pronto."

# 1. VERIFICA SE O E-SUS PRECISA SER INSTALADO
# Se o script do servidor não existir, executa o instalador.
if [ ! -f "$SERVER_SCRIPT" ]; then
  echo "e-SUS PEC não encontrado. Iniciando a instalação..."
  java -jar pec.jar -console \
    -url="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB" \
    -username=$POSTGRES_USER -password=$POSTGRES_PASSWORD -continue
  # É esperado que a instalação termine e o container reinicie.
  # Na próxima execução, o script continuará para o passo 2.
fi

# 2. SE JÁ ESTIVER INSTALADO, ATIVA O MODO TREINAMENTO E INICIA O SERVIDOR
if [ -f "$SERVER_SCRIPT" ]; then
    echo "e-SUS PEC já instalado. Verificando/Ativando modo de treinamento..."
    
    # Executa o comando SQL para garantir que o modo treinamento esteja ativo.
    # Isso é executado toda vez que o container inicia.
    PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB -c \
      "UPDATE tb_config_sistema SET ds_texto = null, ds_inteiro = 1 WHERE co_config_sistema = 'TREINAMENTO';"

    echo "Modo de treinamento configurado. Iniciando o servidor de aplicação..."
    
    # Define as opções do Java e inicia o servidor diretamente.
    export STANDALONE_OPTS="-server -Xms512m -Xmx4096m -Djboss.bind.address=0.0.0.0"
    sh /opt/e-SUS/webserver/standalone.sh
else
    echo "ERRO: Instalação parece ter falhado. O script do servidor ($SERVER_SCRIPT) não foi encontrado."
    # Mantém o container ativo para que possa inspecionar os logs.
    tail -f /dev/null
fi
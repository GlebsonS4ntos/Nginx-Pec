FROM nginx:alpine   

# Se quiser usar um arquivo local, utilizar dentro da pasta test dentro do diretório do Nginx (e comentar o git clone)
#COPY ./test/ /usr/share/nginx/js

ARG ESUS_IFRAME_GITHUB

RUN apk add --no-cache git curl

WORKDIR /usr/share/nginx/js

# Copia O Iframe
RUN git clone --depth=1 ${ESUS_IFRAME_GITHUB} temp && \
    cp -r temp/* . && \
    rm -rf temp

# Substitui a config padrão
COPY nginx.conf /etc/nginx/conf.d/default.conf
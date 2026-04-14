# ETAP 1 budowniczy
FROM scratch AS dev_stage

# Zmienna do przekazania w trakcie builda
ARG VERSION
ENV APP_VERSION=${VERSION}

# Wgranie systemu bazowego
ADD alpine-minirootfs-3.23.3-x86_64.tar /

# Uaktualnienie systemu oraz instalacja 
# niezbednych komponentow
RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs npm && \
    rm -rf /etc/apk/cache

# Tworzenie aplikacji react w kontenerze
RUN npx create-react-app apkalab5

# Ustawienie domyślnego katalogu 
WORKDIR /apkalab5

# Skopiowanie kodu źródłowego (co -> gdzie)
COPY App.js ./src/App.js

# Przypisanie
ENV REACT_APP_VERSION=${VERSION}

# Instalacja dependencies
RUN npm install
RUN npm run build

# ETAP 2 produkcyjny
FROM nginx:alpine AS production

# Instalacja curl do healthchecka
RUN apk add --update --no-cache curl && \
    rm -rf /etc/apk/cache

ARG VERSION

# Dodanie metadanych o aktualnej wersji obrazu i autora
LABEL org.opencontainers.image.authors="kacper"
LABEL org.opencontainers.image.version="$VERSION"

# Kopiowanie zbudowanej aplikacji z pierwszego etapu
COPY --from=dev_stage /apkalab5/build/. /var/www/html/

# Kopiowanie konfiguracji serwera HTTP dla srodowiska produkcyjnego
COPY default.conf /etc/nginx/conf.d/default.conf

# Deklaracja portu aplikacji w kontenerze
EXPOSE 80

# Monitorowanie dostepnosci serwera
HEALTHCHECK --interval=10s --timeout=1s \
    CMD curl -f http://localhost:80/ || exit 1

# Deklaracja sposobu uruchomienia serwera
ENTRYPOINT ["nginx","-g", "daemon off;"]
FROM forge-registry.iut-larochelle.fr/php-fpm-composer/iutlr-info-php8.2-fpm-composer2

USER root

#Change l'url pour utiliser 127.0.0.1 au lieu de database
ENV DATABASE_URL="mysql://udbsfapi:pdbsfapi@127.0.0.1:3306/dbsfapi?serverVersion=10.10.2-MariaDB&charset=utf8mb4"

#Copie la config php récupérée dans muzedex/build/muzedex_api/conf
COPY default.ini /usr/local/etc/php/conf.d/default.ini

COPY muzedex_api /app/muzedex_api
ARG VERSION
ARG BUILD_DATE

FROM php:$VERSION-cli-alpine as php-cli-xdebug

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/phpimages/dockerfile"

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions xdebug

WORKDIR /opt
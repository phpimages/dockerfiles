ARG VERSION
ARG BUILD_DATE
ARG OS

# Aliases for docker php cli images by OS
FROM php:$VERSION-cli-alpine as php-cli-alpine
FROM php:$VERSION-cli-bullseye as php-cli-bullseye


# @image ghcr.io/phpimages/php-cli-xdebug
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-$OS as php-cli-xdebug

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.url="https://github.com/phpimages"

LABEL org.opencontainers.image.authors="Adrien Chinour <github@chinour.fr>"
LABEL org.opencontainers.image.title="php-cli-xdebug"
LABEL org.opencontainers.image.description="PHP CLI image with xdebug."
LABEL org.opencontainers.image.base.name="ghcr.io/phpimages/php-cli-xdebug"
LABEL org.opencontainers.image.version=$VERSION-$OS

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions xdebug

WORKDIR /opt


# @image ghcr.io/phpimages/php-cli-allinclusive
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-$OS as php-cli-allinclusive

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.url="https://github.com/phpimages"

LABEL org.opencontainers.image.authors="Adrien Chinour <github@chinour.fr>"
LABEL org.opencontainers.image.title="php-cli-xdebug"
LABEL org.opencontainers.image.description="PHP CLI image with commonly used extensions."
LABEL org.opencontainers.image.base.name="ghcr.io/phpimages/php-cli-xdebug"
LABEL org.opencontainers.image.version=$VERSION-$OS

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions gd intl yaml redis apcu opcache mcrypt mysqli pgsql pdo_mysql pdo_pgsql xdebug

WORKDIR /opt

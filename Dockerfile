ARG VERSION
ARG BUILD_DATE
ARG OS

# @description base image for alpine versions.
FROM php:$VERSION-cli-alpine AS php-cli-alpine

RUN apk add --no-cache git


# @description base image for debian versions.
FROM php:$VERSION-cli-bullseye AS php-cli-bullseye

RUN apt-get update && apt-get install -y git


# @image ghcr.io/phpimages/php-cli-xdebug
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-$OS AS php-cli-xdebug

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
RUN install-php-extensions zip xdebug

WORKDIR /opt


# @image ghcr.io/phpimages/php-cli-allinclusive
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-$OS AS php-cli-allinclusive

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
RUN install-php-extensions gd intl yaml redis apcu opcache mcrypt mysqli pgsql pdo_mysql pdo_pgsql xdebug zip

WORKDIR /opt


# @image ghcr.io/phpimages/phpstan
# @author Adrien Chinour <github@chinour.fr>
FROM php-cli-xdebug AS phpstan

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.source="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/phpimages/dockerfile"
LABEL org.opencontainers.image.url="https://github.com/phpimages"

LABEL org.opencontainers.image.authors="Adrien Chinour <github@chinour.fr>"
LABEL org.opencontainers.image.title="phpstan"
LABEL org.opencontainers.image.description="PHP CLI image with phpstan available."
LABEL org.opencontainers.image.base.name="ghcr.io/phpimages/phpstan"
LABEL org.opencontainers.image.version=$VERSION-$OS

RUN composer global require phpstan/phpstan

ENTRYPOINT ["/root/.composer/vendor/bin/phpstan", "analyse", "src", "tests", "--memory-limit=-1"]

WORKDIR /opt

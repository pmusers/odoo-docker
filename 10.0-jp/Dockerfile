FROM debian:jessie
LABEL maintainer="Odoo S.A. <info@odoo.com>"

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            dirmngr \
            node-less \
            python-gevent \
            python-ldap \
            python-pip \
            python-qrcode \
            python-renderpm \
            python-support \
            python-vobject \
            python-watchdog \
            unzip \
        && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.jessie_amd64.deb \
        && echo '4d104ff338dc2d2083457b3b1e9baab8ddf14202 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install psycogreen==1.0

# install backports fonts-noto-cjk for serif
RUN set -x; \
        echo 'deb http://deb.debian.org/debian jessie-backports main' > etc/apt/sources.list.d/backports.list \
        && apt-get update \
        && apt-get -t jessie-backports install -y fonts-noto-cjk \
        && fc-cache -fv \
        && rm -rf /var/lib/apt/lists/*

# Install Noto Serif CJK JP and Noto Sans CJK JP Fonts
RUN cd /tmp && \
  mkdir noto && \
  curl -O -L https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip && \
  unzip NotoSerifCJKjp-hinted.zip -d ./noto && \
  curl -O -L https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
  unzip -f NotoSansCJKjp-hinted.zip -d ./noto && \
  mkdir -p /usr/share/fonts/opentype/noto && \
  cp ./noto/*.otf /usr/share/fonts/opentype/noto/ && \
  chmod 644 /usr/share/fonts/opentype/noto/*.otf && \
  fc-cache -fv && \
  rm -rf NotoSerifCJKjp-hinted.zip NotoSansCJKjp-hinted.zip ./noto

# install latest postgresql-client
RUN set -x; \
        echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' > etc/apt/sources.list.d/pgdg.list \
        && export GNUPGHOME="$(mktemp -d)" \
        && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
        && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
        && gpg --armor --export "${repokey}" | apt-key add - \
        && rm -rf "$GNUPGHOME" \
        && apt-get update  \
        && apt-get install -y postgresql-client \
        && rm -rf /var/lib/apt/lists/*

# Install Odoo
ENV ODOO_VERSION 10.0
ARG ODOO_RELEASE=20190221
ARG ODOO_SHA=771dc42025f06e3cc0054a53961b81ba8a289f09
RUN set -x; \
        curl -o odoo.deb -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo/odoo.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]

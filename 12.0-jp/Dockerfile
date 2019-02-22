FROM pmusers/odoo:12.0-20181225

# Set default user when running the container
USER root

# install backports fonts-noto-cjk for serif
RUN set -x; \
        echo 'deb http://deb.debian.org/debian stretch-backports main' > etc/apt/sources.list.d/backports.list \
        && apt-get update \
        && apt-get -t stretch-backports install -y fonts-noto-cjk \
        && fc-cache -fv \
        && rm -rf /var/lib/apt/lists/*

# Install unzip
RUN set -x; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  unzip

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

# Set default user when running the container
USER odoo

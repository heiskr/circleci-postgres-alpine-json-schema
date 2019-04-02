FROM postgres:11-alpine

# https://github.com/circleci/circleci-images/blob/staging/postgres/resources/Dockerfile-basic.template

ENV POSTGRES_DB=circle_test

# This is performance optimization tweak to make DB faster
RUN if [ -e /usr/local/share/postgresql/postgresql.conf.sample ]; then \
        postgresfile=/usr/local/share/postgresql/postgresql.conf.sample; \
    else \
        postgresfile=/usr/share/postgresql/postgresql.conf.sample; \
    fi && \
    echo fsync=off >> $postgresfile &&\
    echo synchronous_commit=off >> $postgresfile &&\
    echo full_page_writes=off >> $postgresfile &&\
    echo bgwriter_lru_maxpages=0 >> $postgresfile

RUN apk add postgresql-contrib
RUN apk add git
RUN apk add make
RUN rm -rf postgres-json-schema && \
  git clone https://github.com/gavinwahl/postgres-json-schema.git && \
  cd postgres-json-schema && \
  make install

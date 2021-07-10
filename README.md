# suap-dv

Ambiente de desenvolvimento SUAP baseado em Docker

## Requisitos

docker - v20.10.7
docker-composer - v1.29.2
git
make

## Targets disponiveis para o make

init: executa um git clone do repositorio suap para dentro da pasta src e cria arquivos de configuração para o bash

start: inicializa o containers sql, dba e app

stop: paraliza os containers sql, dba e app

ssh: acessa via ssh ao container "app"

## Configurações

Antes de usar o ambiente é necessario que se crie dois arquivos de configuração:

* .env-dba - configuração do phppgadmin
* .env-lda - configuração do openldap
* .env-red - configuração do redis
* .env-sql - configuração do postgres

### .env-dba

```
DATABASE_HOST=sql
ALLOW_EMPTY_PASSWORD=yes
```

### .env-lda

```
LDAP_ADMIN_USERNAME=admin
LDAP_ADMIN_PASSWORD=admin
LDAP_USERS=user1
LDAP_PASSWORDS=user1
```

### .env-red

```
ALLOW_EMPTY_PASSWORD=yes
```

### .env-sql

```
POSTGRESQL_POSTGRES_PASSWORD=postgres
POSTGRESQL_USERNAME=suap
POSTGRESQL_PASSWORD=suap
```

# suap-dv

Ambiente de desenvolvido SUAP baseado em Docker

## Targets disponiveis para o make

start: inicializa o containers sql, dba e app

stop: paraliza os containers sql, dba e app

clone: executa um git clone do repositorio suap para dentro da pasta src

shell: acessa via ssh ao container "app"

## Configurações

Antes de usar o ambiente é necessario que se crie dois arquivos de configuração:

* .env-sql - configuração do postgres
* .env-dba - configuração do pgadmin

### .env-sql

```
POSTGRES_HOST=sql
POSTGRES_PASSWORD=postgres
```

### .env-dba

```
PGADMIN_DEFAULT_EMAIL="suap@ifmt.edu.br"
PGADMIN_DEFAULT_PASSWORD="suap"
```

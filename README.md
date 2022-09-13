# SUAP-DE

Ambiente de desenvolvimento SUAP baseado em Docker

## Requisitos

| Ferramenta      | Versão    | Ambiente      |
|-----------------|-----------|---------------|
| docker          | v20.10.18 | linux/windows |
| docker-compose  | v2.6.1    | linux/windows |
| git             | v2.25.1   | linux/windows |
| make            | v4.2.1    | linux/windows |
| sshpass         | v1.06     | linux         |

## Inicialização

#### Atenção! É necessario que se tenha criadas as chaves de acesso ao repositorio GIT, antes de executar qualquer um dos comandos abaixo

A primeira tarefa a fazer é baixar o projeto via:

```bash
git clone git@gitlab.ifmt.edu.br:csn/suap-pc.git
```

Logo após, execute a inicialização:

```bash
make init
```

Este processo irá baixar todos as pastas necessárias para a habilitação do ambiente.

As pastas a serem criadas são: <b>cron</b>, <b>safe</b>, <b>suap</b>.

Manteha sempre a pasta <b>suap-de</b> atualizada, para novas funções e novas atualizações.

```bash
git fetch --all --prune && git pull origin master
```

## Targets disponiveis para o make

| Target          | Ação                                                   |
|-----------------|--------------------------------------------------------|
| init            | executa um git clone dos repositorios "cron" e "suap" para dentro da pasta do projeto |
| start           | inicializa o containers suap-sql, suap-dba e suap-app  |
| stop            | paraliza os containers suap-sql, suap-dba e suap-app   |
| shell           | acessa o container via ssh                             |
| start-gunicorn  | inicia a aplicação suap via gunicorn                   |
| stop-gunicorn   | para a aplicação suap via gunicorn                     |
| synchronize     | sicroniza a aplicacao                                  |

## Configurações

Antes de usar o ambiente é necessario que se crie/altere os arquivos de configuração dos containers:

* .env-app - configuração do shell
* .env-dba - configuração do pgadmin
* .env-moo - configuração do moodle
* .env-red - configuração do redis
* .env-sql - configuração do postgres

### .env-dba

```
PGADMIN_DEFAULT_EMAIL=dsti@ifmt.edu.br
PGADMIN_DEFAULT_PASSWORD=dsti
```

### .env-moo

```
MOODLE_USERNAME=dsti
MOODLE_PASSWORD=dsti
MOODLE_EMAIL=sistemas@ifmt.edu.br
MOODLE_SITE_NAME=IFMT
MOODLE_DATABASE_TYPE=pgsql
MOODLE_DATABASE_HOST=sql
MOODLE_DATABASE_PORT_NUMBER=5432
MOODLE_DATABASE_NAME=moodle_dev
MOODLE_DATABASE_USER=postgres
MOODLE_DATABASE_PASSWORD=postgres
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

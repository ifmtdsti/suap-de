# suap-pc

Ambiente de desenvolvimento SUAP baseado em Docker para o PyCharm ou VsCode

## Requisitos

| Ferramenta      | Versão    | Ambiente      |
|-----------------|-----------|---------------|
| docker          | v20.10.14 | linux/windows |
| docker-compose  | v2.0.1    | linux/windows |
| git             | v2.25.1   | linux/windows |
| make            | v4.2.1    | linux/windows |
| sshpass         | v1.6      | linux         |

## Inicialização

#### Atenção: Crie a chave ssh antes de executar qualquer um dos comandos abaixo

A primeira tarefa a fazer é baixar o projeto via:

```bash
git clone git@gitlab.ifmt.edu.br:csn/suap-pc.git
```

Logo após, execute a inicialização:

```bash
make init
```

Este processo irá baixar todos as pastas necessárias para a habilitação do ambiente. Estas pastas são: <b>cron</b>, <b>safe</b>, <b>suap</b>.

Manteha sempre a pasta suap-pc atualizada, para novas funções e novas atualizações.

```bash
git fetch --all --prune && git pull origin master
```


## Targets disponiveis para o make

| Target          | Ação                                                   |
|-----------------|--------------------------------------------------------|
| init            | executa um git clone dos repositorios "cron" e "suap" para dentro da pasta do projeto |
| start           | inicializa o containers suap-sql, suap-dba e suap-ssh  |
| stop            | paraliza os containers suap-sql, suap-dba e suap-ssh   |
| shell           | acessa o container via ssh                             |
| start-gunicorn  | inicia a aplicação suap via gunicorn                   |
| stop-gunicorn   | para a aplicação suap via gunicorn                     |
| manage-sync     | execute "manage.py sync"                               |
| manage-password | executa "manage.py set_passwords_to"                   |

## Configurações

Antes de usar o ambiente é necessario que se crie/altere os arquivos de configuração dos containers:

* .env-dba - configuração do pgadmin
* .env-git - configuração do gitconfi
* .env-red - configuração do redis
* .env-sql - configuração do postgres

### .env-dba

```
PGADMIN_DEFAULT_EMAIL=dsti@ifmt.edu.br
PGADMIN_DEFAULT_PASSWORD=dsti
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

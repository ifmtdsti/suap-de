# suap-pc

Ambiente de desenvolvimento SUAP baseado em Docker para o PyCharm ou VsCode

## Requisitos

| Ferramenta      | Versão    |
|-----------------|-----------|
| docker          | v20.10.7  |
| docker-composer | v1.29.2   |
| git             | v2.25.1   |
| make            | v4.2.1    |
| sshpass         | v1.6      |

## Targets disponiveis para o make

| Target | Ação                                       |
|--------|--------------------------------------------|
| init   | executa um git clone do repositorio suap para dentro da pasta src e cria arquivos de configuração para o bash |
| start  | inicializa o containers sql, dba e app     |
| stop   | paraliza os containers sql, dba e app      |
| ssh    | acessa via ssh ao container "app"          |

## Configurações

Antes de usar o ambiente é necessario que se crie dois arquivos de configuração:

* .env-dba - configuração do phppgadmin
* .env-red - configuração do redis
* .env-sql - configuração do postgres

### .env-dba

```
PGADMIN_DEFAULT_EMAIL=admin@ifmt.edu.br
PGADMIN_DEFAULT_PASSWORD=admin
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

# suap-pc

Ambiente de desenvolvimento SUAP baseado em Docker para o PyCharm ou VsCode

## Requisitos

| Ferramenta      | Versão    | Ambiente      |
|-----------------|-----------|---------------|
| docker          | v20.10.7  | linux/windows |
| docker-composer | v1.29.2   | linux/windows |
| git             | v2.25.1   | linux/windows |
| make            | v4.2.1    | linux/windows |
| sshpass         | v1.6      | linux         |

## Targets disponiveis para o make

| Target              | Ação                                                   |
|---------------------|--------------------------------------------------------|
| build               | cria o container "suap-app", usado pelo pyCharm        |
| init                | executa um git clone do repositorio suap para dentro da pasta src e cria arquivos de configuração para o bash |
| start               | inicializa o containers suap-sql, suap-dba e suap-ssh  |
| stop                | paraliza os containers suap-sql, suap-dba e suap-ssh   |
| shell               | acessa o container via ssh                             |
| gunicorn            | executa a aplicação suap                               |
| manage-sync         | execute "manage.py sync"                               |
| manage-password-123 | executa "manage.py set_passwords_to_123"               |

## Configurações

Antes de usar o ambiente é necessario que se crie/altere os arquivos de configuração dos containers:

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

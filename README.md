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

| Target | Ação                                                  |
|--------|-------------------------------------------------------|
| init   | executa um git clone do repositorio suap para dentro da pasta src e cria arquivos de configuração para o bash |
| start  | inicializa o containers suap-sql, suap-dba e suap-ssh |
| stop   | paraliza os containers suap-sql, suap-dba e suap-ssh  |
| ssh    | acessa via ssh ao container "suap-ssh"                |
| run    | executa o comando "./manage.py runserver 0.0.0.0:8000 |
| build  | cria o container "suap-app", usado pelo pyCharm       |
| sshs   | O mesmo que ssh, só que usando sshpass                |
| runx   | o Mesmo que run, só que usando sshpass                |

## Configurações

Antes de usar o ambiente é necessario que se crie dois arquivos de configuração:

* .env-dba - configuração do phppgadmin
* .env-lda - configuração do openldap
* .env-red - configuração do redis
* .env-sql - configuração do postgres

### .env-dba

```
PGADMIN_DEFAULT_EMAIL=admin@ifmt.edu.br
PGADMIN_DEFAULT_PASSWORD=admin
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

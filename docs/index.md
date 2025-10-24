# Lloegrys Docker - Open Tibia Server Stack

Ambiente Docker completo para servidor Open Tibia com watchdog automático, SSL/TLS e interface web.

## 📋 Stack de Serviços

- **Traefik**: Reverse proxy com SSL/TLS automático (Let's Encrypt).
- **MariaDB 11**: Banco de dados para o servidor de jogo e website.
- **phpMyAdmin**: Interface web para administração do banco de dados.
- **ZnoteAAC**: Website AAC (Automatic Account Creator) para gerenciamento de contas.
- **Lloegrys Server**: Servidor de jogo com watchdog automático para alta disponibilidade.

## 🚀 Guia de Início Rápido

### 1. Pré-requisitos

- Docker 20.10+
- Docker Compose 2.0+
- Domínios apontando para o IP do seu servidor (opcional para desenvolvimento local).

### 2. Configuração de Variáveis de Ambiente

Copie o arquivo de exemplo `.env.example` para `.env` e edite as variáveis. **Esta é a etapa mais importante.**

```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar variáveis (IMPORTANTE!)
nano .env
```

**Variáveis críticas para configurar:**

```env
# Database - ALTERE AS SENHAS!
MYSQL_ROOT_PASSWORD=sua_senha_root_forte
MYSQL_PASSWORD=sua_senha_usuario_forte

# SSL/TLS - Configure seu email para renovação de certificados Let's Encrypt
ACME_EMAIL=seu-email@dominio.com

# Domínios (ajuste para seus domínios ou deixe como está para teste local)
DOMAIN_MAIN=lloegrys.dev
DOMAIN_ADMIN=admin.lloegrys.dev
DOMAIN_SERVER=server.lloegrys.dev
```

### 3. Preparar Certificados SSL

Crie o arquivo `acme.json` que será usado pelo Traefik para armazenar os certificados SSL.

```bash
# Criar arquivo acme.json com permissões restritas
touch traefik/acme.json
chmod 600 traefik/acme.json
```

### 4. Iniciar os Serviços

Com a configuração pronta, inicie todos os serviços em modo detached.

```bash
# Construir e iniciar todos os serviços
docker-compose up -d

# Acompanhar os logs para verificar se tudo iniciou corretamente
docker-compose logs -f

# Verificar o status e healthchecks dos contêineres
docker-compose ps
```

Após alguns instantes, os serviços estarão disponíveis nos domínios configurados.

---

## 🔧 Arquitetura e Detalhes Técnicos

### 📁 Estrutura de Arquivos Principal

```
lloegrys-docker/
├── _aac/              # Código-fonte do ZnoteAAC
├── _bin/              # Binário e arquivos de dados do servidor OT
│   ├── lloegrys       # Executável do servidor
│   ├── config.lua     # Configuração principal do servidor
│   └── data/          # Mundo, scripts, monstros, etc.
├── mariadb/           # Scripts de inicialização do banco de dados
│   └── init/
├── traefik/           # Configuração do Traefik e certificados
│   └── acme.json      # Armazenamento de certificados SSL
├── docker-compose.yml # Orquestração de todos os serviços
├── watchdog.sh        # Script de monitoramento e reinício automático do servidor
├── .env               # Suas variáveis de ambiente (NÃO versionar)
└── .env.example       # Template para o .env
```

### 🌐 Rede e Domínios

- **Website (ZnoteAAC)**: Acessível em `http://DOMAIN_MAIN` (redireciona para HTTPS).
- **phpMyAdmin**: Acessível em `http://DOMAIN_ADMIN` (redireciona para HTTPS).
- **Status do Servidor**: Acessível em `http://DOMAIN_SERVER`.
- **Portas de Jogo**: `7171` (login e game) são expostas diretamente.

### 🗃️ Banco de Dados (MariaDB)

**Inicialização Automática**: Na primeira vez que o serviço `mariadb` é iniciado, ele executa automaticamente os scripts `.sql` localizados em `mariadb/init/`. Este processo cria:
1.  O banco de dados `lloegrys`.
2.  O usuário `lloegrys` com as permissões necessárias.
3.  O schema completo do The Forgotten Server (TFS), importando todas as tabelas.

**Credenciais**: O `config.lua` do servidor e a configuração do ZnoteAAC já estão ajustados para usar as credenciais definidas no seu arquivo `.env` e para se conectar ao serviço `mariadb` na rede Docker.

**Resetar o Banco de Dados**: Para apagar completamente o banco e forçar a reinicialização a partir dos scripts, remova o volume do Docker:

```bash
docker-compose down
docker volume rm lloegrys-docker_mariadb_data
docker-compose up -d mariadb
```

### 🐕 Watchdog Automático

O servidor de jogo (`lloegrys`) é monitorado por um script `watchdog.sh` que:
- ✅ Verifica se o processo está ativo a cada 10 segundos.
- ✅ Reinicia automaticamente o servidor em caso de crash.
- ✅ Salva logs detalhados de crashes e do output do servidor em volumes persistentes.
- ✅ Previne loops de crash, limitando as tentativas de reinício.

**Logs do Watchdog**:
```bash
# Logs em tempo real do contêiner (inclui output do watchdog)
docker-compose logs -f lloegrys

# Acessar logs de crash persistentes
docker exec lloegrys cat /opt/lloegrys/logs/crashes.log
```

### 🌐 ZnoteAAC

Este projeto utiliza o ZnoteAAC como interface web. O código-fonte está no diretório `_aac/`.

- **Compatibilidade**: A versão incluída é compatível com a versão do TFS utilizada no servidor.
- **Configuração**: O arquivo `config.php` é pré-configurado para se conectar ao banco de dados `mariadb` usando as credenciais do `.env`.
- **Customização**: Para alterar temas ou adicionar plugins, modifique os arquivos dentro de `_aac/layout/` e `_aac/engine/`.

---

## 🔒 Segurança

### ⚠️ Checklist Essencial para Produção

1.  **Alterar todas as senhas** no arquivo `.env`. Use senhas fortes e únicas.
2.  **Configurar Firewall**: Libere apenas as portas necessárias (80, 443, 7171).
3.  **Restringir Acesso ao phpMyAdmin**: Adicione um middleware de IP whitelist no `docker-compose.yml` para permitir o acesso apenas do seu IP.
4.  **Backups Automáticos**: Configure uma rotina de backup para o banco de dados e para os volumes persistentes.
5.  **Não versionar o `.env`**: Garanta que seu arquivo `.env` esteja no `.gitignore`.

**Exemplo: Restringir phpMyAdmin por IP**

Edite o `docker-compose.yml` e adicione as seguintes labels ao serviço `phpmyadmin`:
```yaml
labels:
  # ... outras labels ...
  - "traefik.http.middlewares.admin-ipwhitelist.ipwhitelist.sourcerange=SEU.IP.AQUI/32"
  - "traefik.http.routers.phpmyadmin.middlewares=admin-ipwhitelist"
```

---

## 📊 Comandos Úteis

### Gerenciamento de Serviços
```bash
# Parar todos os serviços
docker-compose down

# Parar e remover volumes (CUIDADO: apaga todos os dados)
docker-compose down -v

# Reiniciar um serviço específico
docker-compose restart lloegrys
```

### Backup
```bash
# Backup completo do banco de dados
docker exec mariadb mysqldump -u root -p${MYSQL_ROOT_PASSWORD} lloegrys > backup_$(date +%Y%m%d).sql

# Backup dos logs do servidor
docker cp lloegrys:/opt/lloegrys/logs ./logs_backup
```

### Debugging
```bash
# Acessar o shell de um contêiner
docker exec -it lloegrys sh

# Verificar conectividade de rede entre contêineres
docker exec lloegrys nc -zv mariadb 3306
```

---

## 🐛 Troubleshooting Comum

- **Erro de Conexão com Banco**:
  1. Verifique se o serviço `mariadb` está com status `healthy` em `docker-compose ps`.
  2. Confirme que as senhas no `.env` estão corretas.

- **Certificado SSL não gerado**:
  1. Verifique os logs do `traefik` com `docker-compose logs traefik`.
  2. Confirme que as permissões do arquivo `traefik/acme.json` são `600`.
  3. Garanta que seus domínios estão apontando corretamente para o IP do servidor.

- **Servidor em Crash Loop**:
  1. Verifique o log de crashes: `docker exec lloegrys tail -100 /opt/lloegrys/logs/crashes.log`.
  2. Desabilite temporariamente o watchdog no `docker-compose.yml` para debugar o servidor manualmente.

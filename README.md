# e-SUS Docker

Projeto Dockerizado para rodar o **e-SUS PEC** com uma personalização via `iframe`, usando containers separados para a aplicação, banco de dados e Nginx.

## ✅ Requisitos

- Docker e Docker Compose instalados  
- Acesso privilegiado (`sudo`) caso esteja utilizando sistema Linux  
- Espaço em disco suficiente para a aplicação e banco de dados

---

## 🚀 Como rodar

### Criando Pec, banco e Nginx em containers separados

```bash
sudo docker-compose -f docker-compose.yml up -d
```

> 💡 Use a flag `--build` para recriar a imagem, caso necessário.

---

## 🌐 Acesso à aplicação

- Interface web: [http://localhost:8081](http://localhost:8081)  
- Banco de dados PostgreSQL: porta **5433**

---

## 🛠️ Solução de problemas comuns

- Se a aplicação não iniciar, verifique os logs:
  ```bash
  docker-compose logs pec
  ```

- Para problemas de conexão com o banco de dados, verifique se as variáveis de ambiente estão configuradas corretamente.

- Para acessar o banco de dados diretamente:
  ```bash
  docker-compose exec db psql -U $POSTGRES_USER -d $POSTGRES_DB
  ```

Atenção: Importante preencher o .env.

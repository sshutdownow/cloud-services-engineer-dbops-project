# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"
Создание новой БД и пользователя:
```sql 
CREATE DATABASE store;
CREATE USER store_user WITH PASSWORD 'passw0rd';
GRANT ALL privileges ON DATABASE store TO store_user;
```


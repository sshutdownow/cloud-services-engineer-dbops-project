# dbops-project
Репозиторий проекта дисциплины "DBOps". Основная цель проекта — нормализация и оптимизация схемы базы данных в рамках миграций.
 * Создание новой (тестовой) БД и пользователя:
```sql 
CREATE DATABASE store;
CREATE USER store_user WITH PASSWORD 'passw0rd';
GRANT ALL privileges ON DATABASE store TO store_user;
ALTER DATABASE store OWNER TO store_user;
```
### Далее все изменения с БД выполняются в рамках миграций.
#### Описание миграций:
   * `V001__create_tables.sql` создаёт в тестовой БД исходные таблицы идентичные в рабочей БД.
   * `V002__change_schema.sql` нормализует таблицы product и orders, удаляет ненужные: product_info и orders_date.
   * `V003__insert_data.sql` заполняет таблицы данными.
   * `V004__create_index.sql` добавляет индексы, ускоряющие выполнение запросов.

### Запрос, который показывает, какое количество сосисок было продано за каждый день предыдущей недели: 
```sql
SELECT o.date_created, SUM(op.quantity)
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped' AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY o.date_created;
```

#### Результат в моём конкретном случае:

|date_created|sum|
|------------|---|
|2025-05-22|943240|
|2025-05-23|947674|
|2025-05-24|947913|
|2025-05-25|937821|
|2025-05-26|944854|
|2025-05-27|936247|
|2025-05-28|683139|

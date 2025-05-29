# dbops-project
Репозиторий проекта дисциплины "DBOps". Основная цель проекта — практика по нормализации и оптимизации схемы базы данных в рамках миграций.
### На выделеном сервере
Создаём новую БД для тестов и пользователя:
```sql 
CREATE DATABASE store;
CREATE USER store_user WITH PASSWORD 'passw0rd';
GRANT ALL privileges ON DATABASE store TO store_user;
ALTER DATABASE store OWNER TO store_user;
```
### [GitHUB secrets](https://docs.github.com/ru/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
Создаём и задаём значения для: DB_HOST, DB_PORT, DB_NAME, DB_USER и DB_PASSWORD.

### Workflow GitHUB Actions
Добавляем в файл _.github/workflows/main.yml_:
```yaml
    #### Добавьте шаг с Flyway-миграциями
    # Устанавливаем JDK, который нужен для запуска приложений, написанных на Java (Flyway)
    - name: Set up JDK
      uses: actions/setup-java@v2
      with:
        distribution: 'temurin'
        java-version: '11'

    # Загружаем и устанавливаем Flyway, чтобы можно было использовать его для управления миграциями
    - name: Install Flyway
      run: |
        curl -L -o flyway-commandline.tar.gz "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/11.1.0/flyway-commandline-11.1.0-linux-x64.tar.gz"
        tar -xzf flyway-commandline.tar.gz
        sudo ln -s `pwd`/flyway-11.1.0/flyway /usr/local/bin/flyway

    # Проверяем, что Postgres работает и доступен перед выполнением миграций, чтобы избежать ошибок подключения
    - name: Wait for Postgres
      run: until pg_isready -h ${{ secrets.DB_HOST }} -p ${{ secrets.DB_PORT }}; do sleep 1; done

    # Выполняем миграции с помощью Flyway, используя URL подключения и учётные данные для базы данных
    - name: Run Flyway migrations
      env:
        FLYWAY_URL: "jdbc:postgresql://${{ secrets.DB_HOST }}:${{ secrets.DB_PORT }}/${{ secrets.DB_NAME }}"
        FLYWAY_USER: ${{ secrets.DB_USER }}
        FLYWAY_PASSWORD: ${{ secrets.DB_PASSWORD }}
      run: flyway migrate -locations=filesystem:migrations
```
Далее все изменения ([DDL](https://ru.wikipedia.org/wiki/Data_Definition_Language)) БД выполняются в рамках миграций через механизм [GitHUB actions](https://docs.github.com/en/actions/about-github-actions/understanding-github-actions).

#### Описание миграций:
   * [V001__create_tables.sql](migrations/V001__create_tables.sql) создаёт в тестовой БД исходные таблицы идентичные таблицам в рабочей БД.
   * [V002__change_schema.sql](migrations/V002__change_schema.sql) нормализует таблицы product и orders, удаляет ненужные таблицы product_info и orders_date.
   * [V003__insert_data.sql](migrations/V003__insert_data.sql) заполняет таблицы данными.
   * [V004__create_index.sql](migrations/V004__create_index.sql) добавляет индексы, ускоряющие выполнение запросов.

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

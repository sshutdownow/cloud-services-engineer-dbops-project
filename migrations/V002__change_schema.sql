-- из product_info
ALTER TABLE product ADD price DOUBLE PRECISION;

-- из orders_date
ALTER TABLE orders ADD date_created date;

-- больше не нужны - данные не переносим, только схему данных
DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date;

-- В таблицах product и orders есть поля id — primary key (первичный ключ), уникальный идентификатор записи в текущей таблице
ALTER TABLE product ADD PRIMARY KEY (id);
ALTER TABLE orders ADD PRIMARY KEY (id);

-- В таблице order_product поля order_id и product_id ссылаются на поля id таблиц orders и product — foreign key (внешний ключ)
ALTER TABLE order_product
    ADD CONSTRAINT fk_order
        FOREIGN KEY (order_id) REFERENCES orders(id),
    ADD CONSTRAINT fk_product
        FOREIGN KEY (product_id) REFERENCES product(id);

-- Заполним таблицы
INSERT INTO product (id, name, picture_url, price) VALUES (1, 'Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00);
INSERT INTO product (id, name, picture_url, price) VALUES (2, 'Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00);
INSERT INTO product (id, name, picture_url, price) VALUES (3, 'Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00);
INSERT INTO product (id, name, picture_url, price) VALUES (4, 'Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00);
INSERT INTO product (id, name, picture_url, price) VALUES (5, 'Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00);
INSERT INTO product (id, name, picture_url, price) VALUES (6, 'Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);

/*
INSERT INTO product_info (product_id, name, price) VALUES (1, 'Сливочная', 320.00);
INSERT INTO product_info (product_id, name, price) VALUES (2, 'Особая', 179.00);
INSERT INTO product_info (product_id, name, price) VALUES (3, 'Молочная', 225.00);
INSERT INTO product_info (product_id, name, price) VALUES (4, 'Нюренбергская', 315.00);
INSERT INTO product_info (product_id, name, price) VALUES (5, 'Мюнхенская', 330.00);
INSERT INTO product_info (product_id, name, price) VALUES (6, 'Русская', 189.00);
*/
INSERT INTO orders (id, status, date_created) SELECT i, (array['pending', 'shipped', 'cancelled'])[floor(random() * 3 + 1)], DATE(NOW() - (random() * (NOW()+'90 days' - NOW()))) FROM generate_series(1, 10000000) s(i);
-- ERROR: duplicate key value violates unique constraint "orders_pkey"
-- Update the sequence https://stackoverflow.com/questions/244243/how-to-reset-postgres-primary-key-sequence-when-it-falls-out-of-sync
SELECT setval('orders_id_seq', (SELECT GREATEST(MAX(id), nextval('orders_id_seq') - 1) FROM orders));
-- INSERT INTO orders_date (order_id, status, date_created) SELECT i, (array['pending', 'shipped', 'cancelled'])[floor(random() * 3 + 1)], DATE(NOW() - (random() * (NOW()+'90 days' - NOW()))) FROM generate_series(1, 10000000) s(i);
INSERT INTO order_product (quantity, order_id, product_id) SELECT floor(1+random()*50)::int, i, 1 + floor(random()*6)::int % 6 FROM generate_series(1, 10000000) s(i);

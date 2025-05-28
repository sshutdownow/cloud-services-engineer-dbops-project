CREATE INDEX order_product_order_id_idx ON order_product(order_id); 
CREATE INDEX orders_status_date_idx ON orders(status, date_created);

CREATE INDEX order_product_order_id_idx ON order_product(order_id); 
CREATE INDEX order_product_quantity_idx ON order_product(quantity); -- sum
CREATE INDEX orders_status_date_idx ON orders(status, date_created);

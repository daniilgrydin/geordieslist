-- Procedures and Functions on Customers

-- Return cursor with customer data looked up by customername
CREATE OR REPLACE FUNCTION fn_get_customer_by_customername(p_customername IN VARCHAR2) RETURN SYS_REFCURSOR IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT customer_id, customername, email, passd_hash, phone_number, date_created, is_verified
    FROM Customer
    WHERE customername = p_customername;
  RETURN l_cur;
END fn_get_customer_by_customername;


-- Check customername availability: returns 1 - available, 0 - taken
CREATE OR REPLACE FUNCTION fn_is_customername_available(p_customername IN VARCHAR2) RETURN NUMBER IS
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count FROM Customer WHERE customername = p_customername;
  IF l_count = 0 THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END fn_is_customername_available;


CREATE OR REPLACE PROCEDURE pr_create_customer(
  p_customername      IN VARCHAR2,
  p_email         IN VARCHAR2,
  p_passd_hash    IN VARCHAR2,
  p_phone_number  IN VARCHAR2,
  p_date_created  IN DATE,
  p_is_verified   IN CHAR
) IS
BEGIN
  INSERT INTO Customer(customer_id, customername, email, passd_hash, phone_number, date_created, is_verified)
  VALUES (
    'GL' || TO_CHAR(seq_customer_num.NEXTVAL),
    p_customername, p_email, p_passd_hash, p_phone_number, p_date_created, p_is_verified
  );
  COMMIT;
END pr_create_customer;


CREATE OR REPLACE PROCEDURE pr_mark_customer_verified(p_customer_id IN VARCHAR2) IS
BEGIN
  UPDATE Customer
    SET is_verified = 'TRUE'
    WHERE customer_id = p_customer_id;
  COMMIT;
END pr_mark_customer_verified;


CREATE OR REPLACE PROCEDURE pr_revoke_customer_verified(p_customer_id IN VARCHAR2) IS
BEGIN
  UPDATE Customer
    SET is_verified = 'FALSE'
    WHERE customer_id = p_customer_id;
  COMMIT;
END pr_mark_customer_verified;


-- update certain fields of the customer
CREATE OR REPLACE PROCEDURE pr_update_customer(
  p_customer_id       IN VARCHAR2,
  p_customername      IN VARCHAR2 DEFAULT NULL,
  p_email         IN VARCHAR2 DEFAULT NULL,
  p_passd_hash    IN VARCHAR2 DEFAULT NULL,
  p_phone_number  IN VARCHAR2 DEFAULT NULL,
  p_is_verified   IN CHAR     DEFAULT NULL
) IS
BEGIN
  UPDATE Customer
    SET customername     = COALESCE(p_customername, customername),
        email        = COALESCE(p_email, email),
        passd_hash   = COALESCE(p_passd_hash, passd_hash),
        phone_number = COALESCE(p_phone_number, phone_number),
        is_verified  = COALESCE(p_is_verified, is_verified)
    WHERE customer_id = p_customer_id;
  COMMIT;
END pr_update_customer;


-- delete both customer and all relevant data
CREATE OR REPLACE PROCEDURE pr_delete_customer(p_customer_id IN VARCHAR2) IS
BEGIN
  DELETE FROM Favourites WHERE customer_id = p_customer_id;
  DELETE FROM Message WHERE customer_id = p_customer_id;
  DELETE FROM Image WHERE listing_id IN (SELECT listing_id FROM Listing WHERE seller_id = p_customer_id);
  DELETE FROM Listing WHERE seller_id = p_customer_id;
  DELETE FROM Customer WHERE customer_id = p_customer_id;
  COMMIT;
END pr_delete_customer;

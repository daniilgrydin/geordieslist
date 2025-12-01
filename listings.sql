-- Procedures and functions on listings

CREATE OR REPLACE PROCEDURE pr_create_listing(
  p_title          IN VARCHAR2,
  p_description    IN VARCHAR2,
  p_price          IN NUMBER,
  p_location       IN VARCHAR2,
  p_date_created   IN DATE,
  p_date_expires   IN DATE,
  p_status         IN VARCHAR2,
  p_seller_id      IN VARCHAR2,
  p_category_id    IN VARCHAR2
) IS
BEGIN
  INSERT INTO Listing(listing_id, title, description, price, location, date_created, date_expires, status, seller_id, category_id)
  VALUES (
    'LS' || TO_CHAR(seq_listing_num.NEXTVAL),
    p_title, p_description, p_price, p_location, p_date_created, p_date_expires, p_status, p_seller_id, p_category_id
  );
  COMMIT;
END pr_create_listing;
/

CREATE OR REPLACE PROCEDURE pr_expire_listings(p_today IN DATE) IS
BEGIN
  UPDATE Listing
    SET status = 'expired'
    WHERE date_expires IS NOT NULL
      AND date_expires < p_today
      AND status = 'active';
  COMMIT;
END pr_expire_listings;
/

CREATE OR REPLACE PROCEDURE pr_add_favourite(p_customer_id IN VARCHAR2, p_listing_id IN VARCHAR2) IS
BEGIN
  INSERT INTO Favourites(customer_id, listing_id)
  VALUES (p_customer_id, p_listing_id);
  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    NULL; -- already favourite, ignore
END pr_add_favourite;
/

CREATE OR REPLACE PROCEDURE pr_remove_favourite(p_customer_id IN VARCHAR2, p_listing_id IN VARCHAR2) IS
BEGIN
  DELETE FROM Favourites WHERE customer_id = p_customer_id AND listing_id = p_listing_id;
  COMMIT;
END pr_remove_favourite;
/

-- delete a listing and all relevant data
CREATE OR REPLACE PROCEDURE pr_delete_listing(p_listing_id IN VARCHAR2) IS
BEGIN
  DELETE FROM Image WHERE listing_id = p_listing_id;
  DELETE FROM Favourites WHERE listing_id = p_listing_id;
  DELETE FROM Message WHERE listing_id = p_listing_id;
  DELETE FROM Listing WHERE listing_id = p_listing_id;
  COMMIT;
END pr_delete_listing;
/

-- update some values of a listing listing
CREATE OR REPLACE PROCEDURE pr_update_listing(
  p_listing_id    IN VARCHAR2,
  p_title         IN VARCHAR2 DEFAULT NULL,
  p_description   IN VARCHAR2 DEFAULT NULL,
  p_price         IN NUMBER    DEFAULT NULL,
  p_location      IN VARCHAR2 DEFAULT NULL,
  p_date_expires  IN DATE     DEFAULT NULL,
  p_status        IN VARCHAR2 DEFAULT NULL,
  p_category_id   IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
  UPDATE Listing
    SET title        = COALESCE(p_title, title),
        description  = COALESCE(p_description, description),
        price        = COALESCE(p_price, price),
        location     = COALESCE(p_location, location),
        date_expires = COALESCE(p_date_expires, date_expires),
        status       = COALESCE(p_status, status),
        category_id  = COALESCE(p_category_id, category_id)
    WHERE listing_id = p_listing_id;
  COMMIT;
END pr_update_listing;
/


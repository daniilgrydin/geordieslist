-- Functions and Procedures on Images

CREATE OR REPLACE PROCEDURE pr_add_image(
  p_image_id    IN VARCHAR2 DEFAULT NULL,
  p_listing_id  IN VARCHAR2,
  p_url         IN VARCHAR2,
  p_upload_date IN DATE
) IS
BEGIN
  INSERT INTO Image(image_id, listing_id, url, upload_date)
  VALUES (
    NVL(p_image_id, 'IM' || LPAD(TO_CHAR(seq_image_num.NEXTVAL), 3, '0')),
    p_listing_id, p_url, p_upload_date
  );
  COMMIT;
END pr_add_image;
/

CREATE OR REPLACE PROCEDURE pr_update_image(
  p_image_id    IN VARCHAR2,
  p_url         IN VARCHAR2 DEFAULT NULL,
  p_upload_date IN DATE     DEFAULT NULL
) IS
BEGIN
  UPDATE Image
    SET url = COALESCE(p_url, url),
        upload_date = COALESCE(p_upload_date, upload_date)
    WHERE image_id = p_image_id;
  COMMIT;
END pr_update_image;
/

CREATE OR REPLACE PROCEDURE pr_delete_image(p_image_id IN VARCHAR2) IS
BEGIN
  DELETE FROM Image WHERE image_id = p_image_id;
  COMMIT;
END pr_delete_image;
/
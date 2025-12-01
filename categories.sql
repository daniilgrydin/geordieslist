-- functions and procedures on Categories

CREATE OR REPLACE PROCEDURE pr_create_category(
  p_name        IN VARCHAR2,
  p_description IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
  INSERT INTO Category(category_id, name, description)
  VALUES ('CT' || TO_CHAR(seq_category_num.NEXTVAL), p_name, p_description);
  COMMIT;
END pr_create_category;


CREATE OR REPLACE PROCEDURE pr_update_category(
  p_category_id IN VARCHAR2,
  p_name        IN VARCHAR2 DEFAULT NULL,
  p_description IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
  UPDATE Category
    SET name = COALESCE(p_name, name),
        description = COALESCE(p_description, description)
    WHERE category_id = p_category_id;
  COMMIT;
END pr_update_category;


-- delete category and set referencing listing's category to null
CREATE OR REPLACE PROCEDURE pr_delete_category(p_category_id IN VARCHAR2) IS
BEGIN
  UPDATE Listing SET category_id = NULL WHERE category_id = p_category_id;
  DELETE FROM Category WHERE category_id = p_category_id;
  COMMIT;
END pr_delete_category;

-- Procedures and Functions on Messages

CREATE OR REPLACE PROCEDURE pr_send_message(
  p_customer_id     IN VARCHAR2,
  p_listing_id  IN VARCHAR2,
  p_date_sent   IN DATE,
  p_content     IN VARCHAR2
) IS
BEGIN
  INSERT INTO Message(customer_id, listing_id, date_sent, content, is_read)
  VALUES (p_customer_id, p_listing_id, p_date_sent, p_content, "F");
  COMMIT;
END pr_send_message;
/

-- return cursors for the specified listing
CREATE OR REPLACE FUNCTION fn_get_messages_for_listing(p_listing_id IN VARCHAR2) RETURN SYS_REFCURSOR IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT m.customer_id, m.listing_id, m.date_sent, m.content, m.is_read,
           u.customername
    FROM Message m
    LEFT JOIN Customer u ON m.customer_id = u.customer_id
    WHERE m.listing_id = p_listing_id
    ORDER BY m.date_sent DESC;
  RETURN l_cur;
END fn_get_messages_for_listing;
/

-- mark message as read
CREATE OR REPLACE PROCEDURE pr_mark_message_read(
  p_customer_id    IN VARCHAR2,
  p_listing_id IN VARCHAR2,
  p_date_sent  IN DATE
) IS
BEGIN
  UPDATE Message
    SET is_read = 'T'
    WHERE customer_id = p_customer_id
      AND listing_id = p_listing_id
      AND date_sent = p_date_sent;
  COMMIT;
END pr_mark_message_read;
/

-- edit a message
CREATE OR REPLACE PROCEDURE pr_update_message(
  p_customer_id    IN VARCHAR2,
  p_listing_id IN VARCHAR2,
  p_date_sent  IN DATE,
  p_content    IN VARCHAR2 DEFAULT NULL,
  p_is_read    IN CHAR     DEFAULT NULL
) IS
BEGIN
  UPDATE Message
    SET content = COALESCE(p_content, content),
        is_read = COALESCE(p_is_read, is_read)
    WHERE customer_id = p_customer_id
      AND listing_id = p_listing_id
      AND date_sent = p_date_sent;
  COMMIT;
END pr_update_message;
/

-- delete a message
CREATE OR REPLACE PROCEDURE pr_delete_message(
  p_customer_id    IN VARCHAR2,
  p_listing_id IN VARCHAR2,
  p_date_sent  IN DATE
) IS
BEGIN
  DELETE FROM Message
    WHERE customer_id = p_customer_id
      AND listing_id = p_listing_id
      AND date_sent = p_date_sent;
  COMMIT;
END pr_delete_message;
/
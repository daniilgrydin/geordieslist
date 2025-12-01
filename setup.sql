CREATE TABLE customer (
    customer_id        VARCHAR2(10)  PRIMARY KEY,
    username       VARCHAR2(50)  NOT NULL,
    email          VARCHAR2(100) NOT NULL UNIQUE,
    passd_hash     VARCHAR2(200) NOT NULL,
    phone_number   VARCHAR2(15),
    date_created   DATE          DEFAULT SYSDATE,
    is_verified    VARCHAR2(5)   CHECK (is_verified IN ('TRUE','FALSE'))
);

CREATE TABLE category (
    category_id    VARCHAR2(10) PRIMARY KEY,
    name           VARCHAR2(100) NOT NULL,
    description    VARCHAR2(500),
    parent_id      VARCHAR2(10),
    CONSTRAINT fk_category_parent
        FOREIGN KEY (parent_id)
        REFERENCES category(category_id)
);

CREATE TABLE listing (
    listing_id      VARCHAR2(10) PRIMARY KEY,
    title           VARCHAR2(200) NOT NULL,
    description     VARCHAR2(1000),
    price           NUMBER(10,2)  NOT NULL,
    location        VARCHAR2(100),
    date_created    DATE          DEFAULT SYSDATE,
    date_expires    DATE,
    status          VARCHAR2(20) CHECK (status IN ('active', 'sold', 'expired')),
    seller_id       VARCHAR2(10) NOT NULL,
    category_id     VARCHAR2(10) NOT NULL,

    CONSTRAINT fk_listing_customer
        FOREIGN KEY (seller_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_listing_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

DROP TABLE message;

CREATE TABLE message (
    customer_id       VARCHAR2(10) NOT NULL,
    listing_id    VARCHAR2(10) NOT NULL,
    date_sent     DATE DEFAULT SYSDATE,
    content       VARCHAR2(2000),
    is_read       VARCHAR2(5) CHECK (is_read IN ('TRUE','FALSE')),

    PRIMARY KEY(customer_id, listing_id, date_sent),

    CONSTRAINT fk_msg_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_msg_listing
        FOREIGN KEY (listing_id)
        REFERENCES listing(listing_id)
);

CREATE TABLE image (
    image_id     VARCHAR2(10) PRIMARY KEY,
    listing_id   VARCHAR2(10) NOT NULL,
    url          VARCHAR2(500) NOT NULL,
    upload_date  DATE,

    CONSTRAINT fk_image_listing
        FOREIGN KEY (listing_id)
        REFERENCES listing(listing_id)
        ON DELETE CASCADE
);

CREATE TABLE favourites (
    customer_id      VARCHAR2(10),
    listing_id   VARCHAR2(10),

    PRIMARY KEY (customer_id, listing_id),

    CONSTRAINT fk_fav_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_fav_listing
        FOREIGN KEY (listing_id)
        REFERENCES listing(listing_id)
        ON DELETE CASCADE
);
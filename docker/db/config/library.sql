CREATE TABLE "t_book" (
  "ISBN" int PRIMARY KEY,
  "title" varchar,
  "author" varchar,
  "pages" int
);

CREATE TABLE "t_book_copy" (
  "copy_id" int,
  "ISBN" int,
  "shelf_offset" int,
  PRIMARY KEY ("copy_id", "ISBN")
);

CREATE TABLE "t_publisher" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "address" varchar
);

CREATE TABLE "t_category" (
  "id" int PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "t_reader" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "address" varchar,
  "birthday" date
);

CREATE TABLE "t_publisher_book" (
  "ISBN" int,
  "publisher_id" int
);

CREATE TABLE "t_book_category" (
  "ISBN" int,
  "category_id" int
);

CREATE TABLE "t_reader_log" (
  "reader_id" int,
  "copy_id" int,
  "ISBN" int,
  "due_to" timestamp
);

ALTER TABLE "t_book_copy" ADD FOREIGN KEY ("ISBN") REFERENCES "t_book" ("ISBN");

ALTER TABLE "t_publisher_book" ADD FOREIGN KEY ("ISBN") REFERENCES "t_book" ("ISBN");

ALTER TABLE "t_publisher_book" ADD FOREIGN KEY ("publisher_id") REFERENCES "t_publisher" ("id");

ALTER TABLE "t_book_category" ADD FOREIGN KEY ("ISBN") REFERENCES "t_book" ("ISBN");

ALTER TABLE "t_book_category" ADD FOREIGN KEY ("category_id") REFERENCES "t_category" ("id");

ALTER TABLE "t_reader_log" ADD FOREIGN KEY ("reader_id") REFERENCES "t_reader" ("id");

ALTER TABLE "t_reader_log" ADD FOREIGN KEY ("copy_id", "ISBN") REFERENCES "t_book_copy" ("copy_id", "ISBN");

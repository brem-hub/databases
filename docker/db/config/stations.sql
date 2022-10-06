CREATE TABLE "t_station" (
  "name" varchar PRIMARY KEY,
  "number_of_tracks" int
);

CREATE TABLE "t_train" (
  "number" int PRIMARY KEY,
  "length" int
);

CREATE TABLE "t_city" (
  "name" varchar,
  "region" varchar,
  
  PRIMARY KEY(name, region)
);

CREATE TABLE "t_connection" (
  "train" int,
  "from" varchar,
  "to" varchar,
  "departure" timestamp,
  "arrival" timestamp
);

CREATE TABLE "t_train_start_end_stations" (
  "train" int,
  "depart_from" varchar,
  "arrive_to" varchar
);

CREATE TABLE "t_station_city" (
  "station" varchar,
  "name" varchar,
  "region" varchar
);


COMMENT ON COLUMN "t_train"."number" IS 'Each train has unique number given at registration';

COMMENT ON TABLE "t_train_start_end_stations" IS 'We can combine `Start` and `End` relatioships in one table, because they have same relationship degrees';

ALTER TABLE "t_connection" ADD FOREIGN KEY ("train") REFERENCES "t_train" ("number");

ALTER TABLE "t_connection" ADD FOREIGN KEY ("from") REFERENCES "t_station" ("name");

ALTER TABLE "t_connection" ADD FOREIGN KEY ("to") REFERENCES "t_station" ("name");

ALTER TABLE "t_train_start_end_stations" ADD FOREIGN KEY ("train") REFERENCES "t_train" ("number");

ALTER TABLE "t_train_start_end_stations" ADD FOREIGN KEY ("depart_from") REFERENCES "t_station" ("name");

ALTER TABLE "t_train_start_end_stations" ADD FOREIGN KEY ("arrive_to") REFERENCES "t_station" ("name");

ALTER TABLE "t_station_city" ADD FOREIGN KEY ("station") REFERENCES "t_station" ("name");

ALTER TABLE "t_station_city" ADD FOREIGN KEY ("name", "region") REFERENCES "t_city" ("name", "region");

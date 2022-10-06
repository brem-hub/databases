CREATE TABLE "t_station_personell" (
  "person_number" int PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "t_caregiver" (
  "person_number" int PRIMARY KEY,
  "qualification" varchar
);

CREATE TABLE "t_doctor" (
  "person_number" int PRIMARY KEY,
  "rank" int
);

CREATE TABLE "t_patient" (
  "patient_number" int PRIMARY KEY,
  "name" varchar,
  "disease" varchar
);

CREATE TABLE "t_station" (
  "station_number" int PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "t_room" (
  "number" int PRIMARY KEY,
  "beds" int
);

CREATE TABLE "t_station_staff" (
  "station" int,
  "staff" int
);

CREATE TABLE "t_station_room" (
  "station" int,
  "room" int
);

CREATE TABLE "t_room_patient" (
  "room" int,
  "patient" int,
  "from" timestamp,
  "to" timestamp
);

CREATE TABLE "t_doctor_patient" (
  "doctor" int,
  "patient" int
);

ALTER TABLE "t_caregiver" ADD FOREIGN KEY ("person_number") REFERENCES "t_station_personell" ("person_number");

ALTER TABLE "t_doctor" ADD FOREIGN KEY ("person_number") REFERENCES "t_station_personell" ("person_number");

ALTER TABLE "t_station_staff" ADD FOREIGN KEY ("station") REFERENCES "t_station" ("station_number");

ALTER TABLE "t_station_staff" ADD FOREIGN KEY ("staff") REFERENCES "t_station_personell" ("person_number");

ALTER TABLE "t_station_room" ADD FOREIGN KEY ("station") REFERENCES "t_station" ("station_number");

ALTER TABLE "t_station_room" ADD FOREIGN KEY ("room") REFERENCES "t_room" ("number");

ALTER TABLE "t_room_patient" ADD FOREIGN KEY ("room") REFERENCES "t_room" ("number");

ALTER TABLE "t_room_patient" ADD FOREIGN KEY ("patient") REFERENCES "t_patient" ("patient_number");

ALTER TABLE "t_doctor_patient" ADD FOREIGN KEY ("doctor") REFERENCES "t_doctor" ("person_number");

ALTER TABLE "t_doctor_patient" ADD FOREIGN KEY ("patient") REFERENCES "t_patient" ("patient_number");

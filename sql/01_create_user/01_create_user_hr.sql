alter session set container = XEPDB1;

create user hr identified by hr;
grant create session to hr;
grant alter any procedure to hr;
grant alter session to hr;
grant create any procedure to hr;
grant create any view to hr;
grant create synonym to hr;
grant create table to hr;
grant create view to hr;
grant drop any procedure to hr;
grant unlimited tablespace to hr;
grant connect to hr;
grant create sequence to hr;
grant create type to hr;

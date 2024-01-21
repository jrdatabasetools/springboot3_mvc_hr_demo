alter session set container = XEPDB1;


create or replace package hr.pkg_employee_demo
as


/**
 * records and cursors used for combo boxes
 */
type rec_id_no_desc_combo is record 
(
  id            number,
  description   varchar2(100)
);
type c_id_no_desc_combo is ref cursor return rec_id_no_desc_combo; 


type rec_id_varchar_desc_combo is record 
(
  id          varchar(10),
  description varchar2(100)
);
type c_id_varchar_desc_combo is ref cursor return rec_id_varchar_desc_combo; 


/**
 * record and cursor used for employees as search result
 */
type rec_employees is record 
(
  employee_id       employees.employee_id%type,
  first_name        employees.first_name%type,
  last_name         employees.last_name%type,
  email             employees.email%type,
  job_title         jobs.job_title%type,
  manager_fullname  varchar2(50),
  department_name   departments.department_name%type,
  city              locations.city%type,
  country_name      countries.country_name%type,
  region_name       regions.region_name%type
);
type c_employees is ref cursor return rec_employees; 


/**
 * record and cursor used for job titles
 */
type rec_job is record 
(
  job_id      jobs.job_id%type,
  job_desc    varchar2(100)
);
type c_job is ref cursor return rec_job; 


/**
 * record and cursor used for departments
 */
type rec_department is record 
(
  department_id      departments.department_id%type,
  department_desc    varchar2(150)
);
type c_department is ref cursor return rec_department; 

/**
 * record and cursor used for managers
 */
type rec_manager is record 
(
  manager_id        employees.employee_id%type,
  manager_full_desc varchar2(200)
);
type c_manager is ref cursor return rec_manager; 

/**
 * record and cursor used for job history
 */
type rec_job_history is record 
(
  start_date        varchar2(20),
  end_date          varchar2(20),
  job_title         jobs.job_title%type,
  department_name   departments.department_name%type
);
type c_job_history is ref cursor return rec_job_history; 


/**
 * load combo boxes
 *
 * @param o_c_jobs cursor of job titles
 * @param o_c_managers cursor of managers
 * @param o_c_departments cursor of departments
 * @param o_c_locations cursor of locations
 * @param o_c_countries cursor of countries
 * @param o_c_regions cursor of job regions
 */
procedure get_combos
(
  o_c_jobs          out c_id_varchar_desc_combo,
  o_c_managers      out c_id_no_desc_combo,
  o_c_departments   out c_id_no_desc_combo,
  o_c_locations     out c_id_no_desc_combo,
  o_c_countries     out c_id_varchar_desc_combo,
  o_c_regions       out c_id_no_desc_combo
);


/**
 * search for employees to list in master view
 *
 * @param i_job_id search only for specific job titles
 * @param i_search_term search term of first name, last name and email
 * @param i_manager_id search only for specific managers
 * @param i_department_id search only for specific departments
 * @param i_location_id search only for specific locations
 * @param i_country_id search only for specific countries
 * @param i_region_id search only for specific regions
 */
function list_employees
(
  i_job_id          in  jobs.job_id%type,
  i_search_term     in  varchar2,
  i_manager_id      in  employees.employee_id%type,
  i_department_id   in  departments.department_id%type,
  i_location_id     in  locations.location_id%type,
  i_country_id      in  countries.country_id%type,
  i_region_id       in  regions.region_id%type
)
return c_employees;


/**
 * load employee to show in detail view
 *
 * @param i_employee_id load employee for primary key of employee
 * @param o_employee_id copy of primary key
 * @param o_first_name first name
 * @param o_last_name last name
 * @param o_email email
 * @param o_phone_number phone number 
 * @param o_hire_date hire date
 * @param o_salary salary
 * @param o_commission_pct commission 
 * @param o_job_id foreign key to jobs
 * @param o_manager_id foreign key to managers
 * @param o_department_id foreign key to departments
 * @param o_c_job cursor for job title combo box
 * @param o_c_department cursor for department combo box
 * @param o_c_manager cursor for manager combo box
 * @param o_c_job_history cursor of job history
 */
procedure load_employee
(
  i_employee_id         in  employees.employee_id%type,
  o_employee_id         out employees.employee_id%type,
  o_first_name          out employees.first_name%type,
  o_last_name           out employees.last_name%type,
  o_email               out employees.email%type,
  o_phone_number        out employees.phone_number%type,
  o_hire_date           out varchar2,
  o_salary              out employees.salary%type,
  o_commission_pct      out employees.commission_pct%type,
  o_job_id              out employees.job_id%type,
  o_manager_id          out employees.manager_id%type,
  o_department_id       out employees.department_id%type,
  o_c_job               out c_job,
  o_c_department        out c_department,
  o_c_manager           out c_manager,
  o_c_job_history       out c_job_history
);


/**
 * save employee and update employee history
 *
 * @param i_employee_id primary key for update or null to add new employee 
 * @param i_first_name first name
 * @param i_last_name last name
 * @param i_email email
 * @param i_phone_number phone number
 * @param i_hire_date hire date
 * @param i_salary salary
 * @param i_commission_pct commission
 * @param i_job_id foreign key to jobs
 * @param i_manager_id foreign key to manager employee 
 * @param i_department_id foreign key to departments
 * @param o_employee_id old primary key on update or new primary key on insert
 */
procedure save_employee
(
  i_employee_id         in  employees.employee_id%type,
  i_first_name          in  employees.first_name%type,
  i_last_name           in  employees.last_name%type,
  i_email               in  employees.email%type,
  i_phone_number        in  employees.phone_number%type,
  i_hire_date           in  varchar2,
  i_salary              in  varchar2,
  i_commission_pct      in  varchar2,
  i_job_id              in  employees.job_id%type,
  i_manager_id          in  employees.manager_id%type,
  i_department_id       in  employees.department_id%type,
  o_employee_id         out employees.employee_id%type
);


/**
 * delete employee from tables employees and job_history
 * 
 * @param i_employee_id primary 
 */
procedure remove_employee
(
  i_employee_id         in  employees.employee_id%type
);


end pkg_employee_demo;
/
alter session set container = XEPDB1;
alter session set current_schema = hr;

create or replace package body pkg_employee_demo
as


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
)
is 
begin
  open o_c_jobs for 
    select  j.job_id,
            j.job_title || ' (' || count(1) || ')'
      from  employees e
            join jobs j on (e.job_id=j.job_id)
      group by j.job_id, 
               j.job_title
      order by j.job_title;
      
  open o_c_managers for 
    select  e.employee_id,
            trim(e.first_name || ' ' || e.last_name) || ' (' || count(1) || ')' manager_name 
      from  employees e
            join employees m on (e.employee_id=m.manager_id)
      group by e.employee_id,
               e.first_name,
               e.last_name
      order by e.last_name;
      
  open o_c_departments for 
    select  d.department_id,
            d.department_name || ' (' || count(1) || ')'
      from  employees e
            join departments d on (e.department_id=d.department_id) 
      group by d.department_id, 
               d.department_name
      order by d.department_name;
      
  open o_c_locations for 
    select  l.location_id,
            l.city || ' (' || count(1) || ')'
      from  locations l
            join departments d on (d.location_id=l.location_id)
            join employees e on (e.department_id=d.department_id)
      group by l.location_id,
               l.city      
      order by city;
      
  open o_c_countries for 
    select  c.country_id,
            c.country_name || ' (' || count(1) || ')'
      from  countries c
            join locations l on (l.country_id=c.country_id)
            join departments d on (d.location_id=l.location_id)
            join employees e on (e.department_id=d.department_id)
      group by c.country_id,
               c.country_name     
      order by country_name;
      
  open o_c_regions for 
    select  r.region_id,
            r.region_name || ' (' || count(1) || ')'
      from  regions r
            join countries c on (c.region_id=r.region_id)
            join locations l on (l.country_id=c.country_id)
            join departments d on (d.location_id=l.location_id)
            join employees e on (e.department_id=d.department_id)
      group by r.region_id,
               r.region_name   
      order by r.region_name;
end get_combos;


/**
 * search for employees
 *
 * @param i_search_term search term of first name, last name and email
 * @param i_job_id search only for specific job titles
 * @param i_manager_id search only for specific managers
 * @param i_department_id search only for specific departments
 * @param i_location_id search only for specific locations
 * @param i_country_id search only for specific countries
 * @param i_region_id search only for specific regions
 */
function list_employees
(
  i_search_term     in  varchar2,
  i_job_id          in  jobs.job_id%type,
  i_manager_id      in  employees.employee_id%type,
  i_department_id   in  departments.department_id%type,
  i_location_id     in  locations.location_id%type,
  i_country_id      in  countries.country_id%type,
  i_region_id       in  regions.region_id%type
)
return c_employees
is
  l_c_employees c_employees;
begin
  if (trim(i_search_term) is null) then
    open l_c_employees for
      select  e.employee_id,
              e.first_name,
              e.last_name,
              e.email,
              j.job_title,
              trim(m.first_name || ' ' || m.last_name) manager_name,
              d.department_name,
              l.city,
              c.country_name,
              r.region_name
        from  employees e
              join departments d on (d.department_id=e.department_id) 
              join locations l on (l.location_id=d.location_id)
              join countries c on (c.country_id=l.country_id)
              join regions r on (r.region_id=c.region_id)
              left join employees m on (m.employee_id=e.manager_id)
              join jobs j on (j.job_id=e.job_id)
        where nvl(i_job_id, e.job_id)=e.job_id and
              nvl(i_manager_id, nvl(e.manager_id, -999))=nvl(e.manager_id,-999) and
              nvl(i_department_id, d.department_id)=d.department_id and
              nvl(i_location_id, l.location_id)=l.location_id and
              nvl(i_country_id, c.country_id)=c.country_id and
              nvl(i_region_id, r.region_id)=r.region_id
        order by e.last_name;
  else
    open l_c_employees for
      select  e.employee_id,
              e.first_name,
              e.last_name,
              e.email,
              j.job_title,
              trim(m.first_name || ' ' || m.last_name) manager_name,
              d.department_name,
              l.city,
              c.country_name,
              r.region_name
        from  employees e
              join departments d on (d.department_id=e.department_id) 
              join locations l on (l.location_id=d.location_id)
              join countries c on (c.country_id=l.country_id)
              join regions r on (r.region_id=c.region_id)
              left join employees m on (m.employee_id=e.manager_id)
              join jobs j on (j.job_id=e.job_id)
        where nvl(i_job_id, e.job_id)=e.job_id and
              nvl(i_manager_id, nvl(e.manager_id, -999))=nvl(e.manager_id,-999) and
              nvl(i_department_id, d.department_id)=d.department_id and
              nvl(i_location_id, l.location_id)=l.location_id and
              nvl(i_country_id, c.country_id)=c.country_id and
              nvl(i_region_id, r.region_id)=r.region_id and
              upper(e.first_name) || ' ' || upper(e.last_name) || ' ' || upper(e.email) like upper('%'|| translate(i_search_term, ' *', '%%')  ||'%')
        order by e.last_name;
  end if;
  
  return l_c_employees;
end list_employees;


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
  o_hire_date           out employees.hire_date%type,
  o_salary              out employees.salary%type,
  o_commission_pct      out employees.commission_pct%type,
  o_job_id              out employees.job_id%type,
  o_manager_id          out employees.manager_id%type,
  o_department_id       out employees.department_id%type,
  o_c_job               out c_job,
  o_c_department        out c_department,
  o_c_manager           out c_manager,
  o_c_job_history       out c_job_history
)
is
begin
  if (i_employee_id is not null) then
    select  employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            hire_date,
            salary,
            commission_pct,
            job_id,
            manager_id,
            department_id
      into  o_employee_id,
            o_first_name,
            o_last_name,
            o_email,
            o_phone_number,
            o_hire_date,
            o_salary,
            o_commission_pct,
            o_job_id,
            o_manager_id,
            o_department_id
      from  employees 
      where employee_id=i_employee_id;    
  end if;

  open o_c_job for 
    select  job_id,
            job_title || ' (salary range : ' || min_salary || '-' || max_salary || ')'
      from  jobs
      order by job_title;

  open o_c_department for 
    select  d.department_id,
            d.department_name || ' (' || l.city || '/' || c.country_name || ')'
      from  departments d
            join locations l on (l.location_id=d.location_id)
            join countries c on (c.country_id=l.country_id)
      order by department_name;

  open o_c_manager for 
    select  e.employee_id,
            trim(e.first_name || ' ' || e.last_name) || ' (' || j.job_title || '/' || l.city || ')' 
      from  employees e  
            join jobs j on (j.job_id=e.job_id)
            join departments d on (d.department_id=e.department_id)
            join locations l on (l.location_id=d.location_id)
      order by e.last_name;

  open o_c_job_history for
    select  to_char(start_date, 'dd.mm.yyyy'),
            to_char(end_date, 'dd.mm.yyyy'),
            (select job_title from jobs j where j.job_id=jh.job_id) job_title,
            (select department_name from departments d where d.department_id=jh.department_id) department_name
      from  job_history jh
      where jh.employee_id=i_employee_id
      order by jh.start_date;
end load_employee;


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
  i_hire_date           in  employees.hire_date%type,
  i_salary              in  employees.salary%type,
  i_commission_pct      in  employees.commission_pct%type,
  i_job_id              in  employees.job_id%type,
  i_manager_id          in  employees.manager_id%type,
  i_department_id       in  employees.department_id%type,
  o_employee_id         out employees.employee_id%type
)
is
begin
  if (i_employee_id is not null) then
    update employees
      set first_name      = i_first_name,
          last_name       = i_last_name,
          email           = i_email,
          phone_number    = i_phone_number,
          hire_date       = i_hire_date,
          salary          = i_salary,
          commission_pct  = i_commission_pct,
          job_id          = i_job_id,
          manager_id      = i_manager_id,
          department_id   = i_department_id
      where employee_id=i_employee_id;  
    o_employee_id := i_employee_id;
  else
    insert into employees
      (
        employee_id,
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        salary,
        commission_pct,
        job_id,
        manager_id,
        department_id
      )
      values
      (
        employees_seq.nextval,
        i_first_name,
        i_last_name,
        i_email,
        i_phone_number,
        i_hire_date,
        i_salary,
        i_commission_pct,
        i_job_id,
        i_manager_id,
        i_department_id
      )
      return employee_id into o_employee_id; 
  end if;
end save_employee;


/**
 * delete employee from tables employees and job_history
 * 
 * @param i_employee_id primary 
 */
procedure remove_employee
(
  i_employee_id         in  employees.employee_id%type
)
is
begin
  delete from job_history
    where employee_id=i_employee_id;
    
  delete from employees
    where employee_id=i_employee_id;
end remove_employee;


end pkg_employee_demo;
/
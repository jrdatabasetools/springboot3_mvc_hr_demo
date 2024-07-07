/*
 * Copyright (c) Jan Richter, www.jr-database-tools.com, Switzerland, 2015-2024. All rights reserved.
 */

package com.jrdatabasetools.hrdemo.springbootmvc;

import java.lang.invoke.MethodHandles;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jrdatabasetools.hrdemo.springbootmvc.connector.service.PkgEmployeeDemoService;
import com.jrdatabasetools.hrdemo.springbootmvc.connector.transferobject.PkgEmployeeDemoTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HrDemoController {
  private static final Logger    logger       = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
  private static final String    DATE_PATTERN = "yyyy-MM-dd";

  @Autowired
  private PkgEmployeeDemoService service;

  
  @RequestMapping(value = { "/", "/master" })
  public ModelAndView getMasterView(HttpServletRequest request) {
    TimerCounter tc = new TimerCounter();

    try {
      PkgEmployeeDemoTO.GetCombosTO combos = service.getCombos(0);
      request.getSession().setAttribute("combos", combos);
      request.setAttribute("combos", combos);
    }
    catch (Exception e) {
      logger.error(e.getMessage(), e);
      request.setAttribute("error_message", e.getMessage());
    }
    finally {
      logger.info(tc.diff("load combos"));
    }

    return new ModelAndView("masterview");
  }

  @RequestMapping(value = { "/master_search" })
  public ModelAndView getMasterViewSearch(HttpServletRequest request,
                                          @RequestParam("jobId") String jobId,
                                          @RequestParam("search_term") String searchTerm,
                                          @RequestParam(value = "managerId", required = false) Integer managerId,
                                          @RequestParam(value = "departmentId", required = false) Integer departmentId,
                                          @RequestParam(value = "locationId", required = false) Integer locationId,
                                          @RequestParam("countryId") String countryId,
                                          @RequestParam(value = "regionId", required = false) Integer regionId)
  {
    TimerCounter tc = new TimerCounter();

    try {
      Object combos = request.getSession().getAttribute("combos");
      if (combos != null) {
        request.setAttribute("combos", combos);
      }
      else {
        combos = service.getCombos(0);
        request.getSession().setAttribute("combos", combos);
        request.setAttribute("combos", combos);
      }

      List<PkgEmployeeDemoTO.RecEmployees> searchResult = service.listEmployees(searchTerm,
                                                                                jobId,
                                                                                managerId,
                                                                                departmentId,
                                                                                locationId,
                                                                                countryId,
                                                                                regionId,
                                                                                0);
      request.setAttribute("search_result", searchResult);
    }
    catch (Exception e) {
      logger.error(e.getMessage(), e);
      request.setAttribute("error_message", e.getMessage());
    }
    finally {
      logger.info(tc.diff("load combos and search time"));
    }

    return new ModelAndView("masterview");
  }

  @RequestMapping(value = { "/detail" })
  public ModelAndView getDetail(HttpServletRequest request,
                                @RequestParam(value = "employeeId", required = false) Integer employeeId)
  {
    TimerCounter tc = new TimerCounter();

    try {
      PkgEmployeeDemoTO.LoadEmployeeTO employee = service.loadEmployee(employeeId, 0);
      request.setAttribute("employee", employee);
      request.setAttribute("hireDate", employee.getOHireDate().format(DateTimeFormatter.ofPattern(DATE_PATTERN)));
    }
    catch (Exception e) {
      logger.error(e.getMessage(), e);
      request.setAttribute("error_message", e.getMessage());
      return new ModelAndView("masterview");
    }
    finally {
      logger.info(tc.diff("load employee"));
    }

    return new ModelAndView("detailview");
  }

  @RequestMapping(value = { "/detail_save" })
  public ModelAndView doSaveDetail(HttpServletRequest request,
                                   @RequestParam(value = "employeeId", required = false) Integer employeeId,
                                   @RequestParam("firstName") String firstName,
                                   @RequestParam("lastName") String lastName,
                                   @RequestParam("email") String email,
                                   @RequestParam("phoneNumber") String phoneNumber,
                                   @RequestParam("hireDate") String hireDate,
                                   @RequestParam("salary") String salary,
                                   @RequestParam("commissionPct") String commissionPct,
                                   @RequestParam("jobId") String jobId,
                                   @RequestParam(value = "managerId", required = false) Integer managerId,
                                   @RequestParam(value = "departmentId", required = false) Integer departmentId)
  {
    TimerCounter tc = new TimerCounter();

    try {
      employeeId = service.saveEmployee(employeeId,
                                        firstName,
                                        lastName,
                                        email,
                                        phoneNumber,
                                        LocalDate.parse(hireDate, DateTimeFormatter.ofPattern(DATE_PATTERN)),
                                        Double.parseDouble(salary),
                                        commissionPct != null && commissionPct.length() > 0 ? Double.parseDouble(commissionPct) : null,
                                        jobId,
                                        managerId,
                                        departmentId);
    }
    catch (Exception e) {
      logger.error(e.getMessage(), e);
      request.setAttribute("error_message", e.getMessage());
      return getDetail(request, employeeId);
    }
    finally {
      logger.info(tc.diff("save employee"));
    }

    return getMasterView(request);
  }

  @RequestMapping(value = { "/remove" })
  public ModelAndView getRemove(HttpServletRequest request,
                                @RequestParam(value = "employeeId", required = false) Integer employeeId)
  {
    TimerCounter tc = new TimerCounter();

    try {
      service.removeEmployee(employeeId);
    }
    catch (Exception e) {
      logger.error(e.getMessage(), e);
      request.setAttribute("error_message", e.getMessage());
      return getDetail(request, employeeId);
    }
    finally {
      logger.info(tc.diff("remove employee"));
    }

    return getMasterView(request);
  }
}

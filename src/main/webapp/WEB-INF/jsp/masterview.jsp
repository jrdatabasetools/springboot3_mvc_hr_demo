<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%@ taglib
	uri="jakarta.tags.core" prefix="c"%>
<html>
<head>
<link rel="stylesheet" href="/css/styles.css">
</head>
<body>
	<h1>Master-View</h1>
	<hr>

	<c:if test = "${not empty error_message}">
	  <pre>${error_message}</pre>
		<hr>
	</c:if>

	<form action="/master_search">
		<table class="search_form">
			<tr class="search_form">
				<td class="search_form"><label for="search_term">Search
						Term</label></td>
				<td class="search_form"><input type="text" id="search_term"
					name="search_term" size="50"></td>
			</tr>
			
			<tr class="search_form">
				<td class="search_form"><label for="jobId">Job Title</label></td>
				<td class="search_form"><select name="jobId" id="jobId">
						<option value=""></option>
						<c:forEach var="job" items="${combos.getOCJobs()}">
							<option value="${job.id}">${job.description}</option>
						</c:forEach>
				</select></td>
			</tr>
			
			<tr class="search_form">
				<td class="search_form"><label for="managerId">Manager</label></td>
				<td class="search_form"><select name="managerId" id="managerId">
						<option value=""></option>
						<c:forEach var="manager" items="${combos.getOCManagers()}">
							<option value="${manager.id}">${manager.description}</option>
						</c:forEach>
				</select></td>
			</tr>
			
			<tr>
				<td class="search_form"><label for="departmentId">Department</label></td>
				<td class="search_form"><select name="departmentId"
					id="departmentId">
						<option value=""></option>
						<c:forEach var="department" items="${combos.getOCDepartments()}">
							<option value="${department.id}">${department.description}</option>
						</c:forEach>
				</select></td>
			</tr>
			
			<tr class="search_form">
				<td class="search_form"><label for="locationId">Location</label></td>
				<td class="search_form"><select name="locationId"
					id="locationId">
						<option value=""></option>
						<c:forEach var="location" items="${combos.getOCLocations()}">
							<option value="${location.id}">${location.description}</option>
						</c:forEach>
				</select></td>
			</tr>
			
			<tr class="search_form">
				<td class="search_form"><label for="countryId">Country</label></td>
				<td class="search_form"><select name="countryId" id="countryId">
						<option value=""></option>
						<c:forEach var="country" items="${combos.getOCCountries()}">
							<option value="${country.id}">${country.description}</option>
						</c:forEach>
				</select></td>
			</tr>
			
			<tr class="search_form">
				<td class="search_form" valign="top"><label for="regionId">Region</label></td>
				<td class="search_form" valign="top"><select name="regionId" id="regionId">
						<option value=""></option>
						<c:forEach var="region" items="${combos.getOCRegions()}">
							<option value="${region.id}">${region.description}</option>
						</c:forEach>
				</select></td>
				<td class="search_form" valign="top"><input type="submit" value="Search"></td>
				</form>

				<td valign="center" class="search_form">
					<form action="/detail">
						<input type="submit" value="New Employee">
					</form>
				</td>
			</tr>
		</table>

	<hr>

	<table>
		<thead>
			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
				<th>Job Title</th>
				<th>Manager</th>
				<th>Department</th>
				<th>Location</th>
				<th>Country</th>
				<th>Region</th>
			</tr>
		</thead>

		<tbody>
			<c:forEach var="employee" items="${search_result}">
				<tr>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.firstName}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.lastName}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.email}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.jobTitle}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.managerFullname}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.departmentName}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.city}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.countryName}</a></td>
					<td><a href="/detail?employeeId=${employee.employeeId}">${employee.regionName}</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>

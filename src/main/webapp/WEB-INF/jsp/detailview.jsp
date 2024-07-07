<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%@ taglib
	uri="jakarta.tags.core" prefix="c"%>
<html>
<head>
<link rel="stylesheet" href="/css/styles.css">
</head>
<body>
	<h1>Detail-View</h1>
  <p>(No Field Validation on Edit Fields - Errors will appear from Spring Controller or Oracle DB Errors to demonstrate Database Errors)</p>
	<hr>

	<c:if test="${not empty error_message}">
		<pre>${error_message}</pre>
		<hr>
	</c:if>

	<table class="search_form">
		<form action="/detail_save">

			<input type="hidden" id="employeeId" name="employeeId"
				value="${employee.getOEmployeeId()}">

			<tr class="search_form">
				<td class="search_form"><label for="firstName">First
						Name</label></td>
				<td class="search_form"><input type="text" id="firstName"
					name="firstName" size="50" value="${employee.getOFirstName()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="lastName">Last Name</label></td>
				<td class="search_form"><input type="text" id="lastName"
					name="lastName" size="50" value="${employee.getOLastName()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="email">Email</label></td>
				<td class="search_form"><input type="text" id="email"
					name="email" size="50" value="${employee.getOEmail()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="phoneNumber">Phone
						Number</label></td>
				<td class="search_form"><input type="text" id="phoneNumber"
					name="phoneNumber" size="50" value="${employee.getOPhoneNumber()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="hireDate">Hire Date</label></td>
        <td class="search_form"><input type="text" id="hireDate"
          name="hireDate" size="50" value="${hireDate}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="salary">Salary</label></td>
				<td class="search_form"><input type="text" id="salary"
					name="salary" size="50" value="${employee.getOSalary()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="commissionPct">Commission
						PCT</label></td>
				<td class="search_form"><input type="text" id="commissionPct"
					name="commissionPct" size="50"
					value="${employee.getOCommissionPct()}"></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="jobId">Job Title</label></td>
				<td class="search_form"><select name="jobId" id="jobId">
						<option value=""></option>
						<c:forEach var="job" items="${employee.getOCJob()}">
							<c:if test="${job.jobId == employee.getOJobId()}">
								<option value="${job.jobId}" selected="selected">${job.jobDesc}</option>
							</c:if>
							<c:if test="${job.jobId != employee.getOJobId()}">
								<option value="${job.jobId}">${job.jobDesc}</option>
							</c:if>
						</c:forEach>
				</select></td>
			</tr>

			<tr class="search_form">
				<td class="search_form"><label for="managerId">Manager</label></td>
				<td class="search_form"><select name="managerId" id="managerId">
						<option value=""></option>
						<c:forEach var="manager" items="${employee.getOCManager()}">
							<c:if test="${manager.managerId == employee.getOManagerId()}">
								<option value="${manager.managerId}" selected="selected">${manager.managerFullDesc}</option>
							</c:if>
							<c:if test="${manager.managerId != employee.getOManagerId()}">
								<option value="${manager.managerId}">${manager.managerFullDesc}</option>
							</c:if>
						</c:forEach>
				</select></td>
			</tr>

			<tr class="search_form">
				<td class="search_form" valign="top"><label for="departmentId">Department</label></td>
				<td class="search_form" valign="top"><select
					name="departmentId" id="departmentId">
						<option value=""></option>
						<c:forEach var="department" items="${employee.getOCDepartment()}">
							<c:if
								test="${department.departmentId == employee.getODepartmentId()}">
								<option value="${department.departmentId}" selected="selected">${department.departmentDesc}</option>
							</c:if>
							<c:if
								test="${department.departmentId != employee.getODepartmentId()}">
								<option value="${department.departmentId}">${department.departmentDesc}</option>
							</c:if>
						</c:forEach>
				</select></td>
				<td class="search_form" colspan="2" align="right" valign="top">
					<input type="submit" value="Save">
		</form>
		</td>
		<td valign="top" class="search_form">
			<form action="/master">
				<input type="submit" value="Back">
			</form>
		</td>
		<td valign="center" class="search_form">
			<form action="/remove">
        <input type="hidden" id="employeeId" name="employeeId" value="${employee.getOEmployeeId()}">
				<input type="submit" value="Delete">
			</form>
		</td>
		</tr>
	</table>

	<hr>

	<h4>Job History</h4>
	<table>
		<thead>
			<tr>
				<th>Start Date</th>
				<th>End Date</th>
				<th>Job Title</th>
				<th>Department</th>
			</tr>
		</thead>

		<tbody>
			<c:forEach var="job_history" items="${employee.getOCJobHistory()}">
				<tr>
					<td>${job_history.startDate}</td>
					<td>${job_history.endDate}</td>
					<td>${job_history.jobTitle}</td>
					<td>${job_history.departmentName}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

</body>
</html>

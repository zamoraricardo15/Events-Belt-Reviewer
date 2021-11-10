<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="org.apache.commons.lang3.StringUtils"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="assets/css/.css">
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
	<title>Event Manager: Home</title>
</head>
<body>
	<div class="container border-bottom border-info pb-3">
		<div class=row>
			<div class="col">
			<h1 class="h2 mt-2"><small>Welcome back, ${fn:toUpperCase(fn:substring(user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(user.firstName, 1,fn:length(user.firstName)))} ${fn:toUpperCase(fn:substring(user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(user.lastName, 1,fn:length(user.lastName)))} !</small></h1>
			</div>
			<div class="col-2 text-right pt-3">
				<a href="/logout"><button class="btn btn-danger">Logout</button></a>
			</div>
		</div>
	</div>
	<br>
	<div class="container">
		<h4 class="h4 border-bottom border-success d-inline-block mb-2 font-weight-normal">Here are some events in your home State (${user.state}):</h4>
		<br>
		<br>
		<table class="table table-sm table-success">
		  <thead>
		    <tr>
		      <th scope="col" class="bg-success">Event</th>
		      <th scope="col" class="bg-success">Date</th>
		      <th scope="col" class="bg-success">City</th>
		      <th scope="col" class="bg-success">Host</th>
		      <th scope="col" class="bg-success">Action</th>
		    </tr>
		  </thead>
		  <tbody class=" border border-success">
		  	<c:forEach items="${inState}" var="event">
			    <tr>
			      <td ><a href="events/${event.id }">${event.name}</a></td>
			      <td><fmt:formatDate type = "date" dateStyle = "long" timeStyle = "long" value = "${event.date}" /></td>
			      <td>${event.city}</td>
			      <td>
			      	 ${fn:toUpperCase(fn:substring(event.user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.firstName, 1,fn:length(event.user.firstName)))} ${fn:toUpperCase(fn:substring(event.user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.lastName, 1,fn:length(event.user.lastName)))}
			      </td>
			      <td class="text-center">
			      	<c:choose>
			      		<c:when test= "${event.user.id == user.id}">
			      			<a href="home/edit/${event.id}"><button class="btn btn-secondary btn-sm">Edit</button></a>
			      			<form action="/home/${event.id}<c:out value="${language.id}"/>" method="post" class="d-inline-block">
			      				<input type="hidden" name="_method" value="delete">
			      				<input type="hidden" name="userId" value="${user.id}">
			      				<input type="submit" class="btn btn-danger btn-sm" value="Delete">
			      			</form>
			      			
			      			
			      		</c:when>
			      		<c:when test="${event.user.id != user.id}">
			     			<c:set var = "attending" value = "${false}"/>
			     			<c:forEach items="${event.joinedUsers}" var="joinedUser">
			     				<c:if test ="${joinedUser == user}">
			     					<c:set var="attending" value="${true}"/>
			     				</c:if>
			     				
			     			</c:forEach>
			     			<c:choose>
			     				<c:when test="${attending == false}">
			     					<form:form action="/home/join" method="POST" modelAttribute="userEvent">
					      				<input type="hidden" value="${event.id}" name="event">
					      				<input type="hidden" value="${user.id}" name="user">
					      				<button class="btn btn-primary btn-sm" type="submit">Join</button>
					      			</form:form>
			     					
			     				</c:when>
			     				<c:otherwise>
				     				<Button class="btn btn-outline-primary btn-sm"disabled>Joined!</Button>
				     				<form action="/home/cancel<c:out value="${language.id}"/>" method="post" class="d-inline-block">
					      				<input type="hidden" name="_method" value="delete">
					      				<input type="hidden" name="userId" value="${user.id}">
					      				<input type="hidden" name="eventId" value="${event.id}">
					      				<input type="submit" class="btn btn-outline-danger btn-sm" value="Cancel">
					      			</form>
			     				</c:otherwise>
			     			</c:choose>
			     			
			      		</c:when>
			      		
			      	</c:choose>
			      </td>
			    </tr>
			</c:forEach>
		  </tbody>
		</table>
	</div>
	<br>
		<div class="container">
		<h4 class="h4 border-bottom border-warning d-inline-block mb-2 font-weight-normal">Here are some events in other States:</h4>
		<br>
		<br>
		<table class="table table-sm table-warning">
		  <thead>
		    <tr>
		      <th scope="col" class="bg-warning">Event</th>
		      <th scope="col" class="bg-warning">Date</th>
		      <th scope="col" class="bg-warning">City</th>
		      <th scope="col" class="bg-warning">State</th>
		      <th scope="col" class="bg-warning">Host</th>
		      <th scope="col" class="bg-warning">Action</th>
		     
		    </tr>
		  </thead>
		  <tbody class="border border-warning">
		  	<c:forEach items="${outState}" var="event">
			    <tr>
			      <td ><a href="events/${event.id }">${event.name}</a></td>
			      <td><fmt:formatDate type = "date" dateStyle = "long" timeStyle = "long" value = "${event.date}" /></td>
			      <td>${event.city}</td>
			      <td>${event.state}</td>
			      <td>
			      	 ${fn:toUpperCase(fn:substring(event.user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.firstName, 1,fn:length(event.user.firstName)))} ${fn:toUpperCase(fn:substring(event.user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.lastName, 1,fn:length(event.user.lastName)))}
			      </td>
			      <td class="text-center">
			      	<c:choose>
			      		<c:when test= "${event.user.id == user.id}">
			      			<a href="home/edit/${event.id}"><button class="btn btn-secondary btn-sm">Edit</button></a>
			      			<form action="/home/${event.id}<c:out value="${language.id}"/>" method="post" class="d-inline-block">
			      				<input type="hidden" name="_method" value="delete">
			      				<input type="hidden" name="userId" value="${user.id}">
			      				<input type="submit" class="btn btn-danger btn-sm" value="Delete">
			      			</form>
			      			
			      		</c:when>
			      		<c:when test="${event.user.id != user.id}">
			     			<c:set var = "attending" value = "${false}"/>
			     			<c:forEach items="${event.joinedUsers}" var="joinedUser">
			     				<c:if test ="${joinedUser == user}">
			     					<c:set var="attending" value="${true}"/>
			     				</c:if>
			     				
			     			</c:forEach>
			     			<c:choose>
			     				<c:when test="${attending == false}">
			     					<form:form action="/home/join" method="POST" modelAttribute="userEvent">
					      				<input type="hidden" value="${event.id}" name="event">
					      				<input type="hidden" value="${user.id}" name="user">
					      				<button class="btn btn-primary btn-sm" type="submit">Join</button>
					      			</form:form>
			     					
			     				</c:when>
			     				<c:otherwise>
				     				<Button class="btn btn-outline-primary btn-sm"disabled>Joined!</Button>
				     				<form action="/home/cancel<c:out value="${language.id}"/>" method="post" class="d-inline-block">
					      				<input type="hidden" name="_method" value="delete">
					      				<input type="hidden" name="userId" value="${user.id}">
					      				<input type="hidden" name="eventId" value="${event.id}">
					      				<input type="submit" class="btn btn-outline-danger btn-sm" value="Cancel">
					      			</form>
			     				</c:otherwise>
			     			</c:choose>
			 
			      		</c:when>
			      	</c:choose>
			      </td>
			    
			      
			    </tr>
			</c:forEach>
		   </tbody>
		  </table>
	</div>
	<br>
	<div class="container">
		<h4 class="h4 border-bottom border-info d-inline-block mb-2">Create an Event</h4>
		<form:errors path="eventForm.*" element="p" cssClass="alert alert-danger"/>
		<form:form action="/home" method="POST" modelAttribute="eventForm">
			
			<p>
				<form:label path="name" cssClass="h5 font-weight-normal">Event Name</form:label>
				<form:input path="name" cssClass="form-control  col-4 bg-info text-white"/>
			</p>
			<p>
				<form:label path="date" cssClass="h5 font-weight-normal">Date</form:label>
				<form:input path="date" type="date" cssClass="form-control  col-3 bg-info text-white"/>
			</p>
			<p>
				<form:label path="city" cssClass="h5 font-weight-normal">City</form:label>
				<form:input path="city" cssClass="form-control  col-4 bg-info text-white"/>
			</p>
			<p>
						<form:label path="state" cssClass="h5 font-weight-normal d-block">State</form:label>
						<form:select cssClass="custom-select col-4  bg-info text-white" path="state">
							<form:option value="AL">Alabama (AL)</form:option>
							<form:option value="AK">Alaska (AK)</form:option>
							<form:option value="AZ">Arizona (AZ)</form:option>
							<form:option value="AR">Arkansas (AR)</form:option>
							<form:option value="CA">California (CA)</form:option>
							<form:option value="CO">Colorado (CO)</form:option>
							<form:option value="CT">Connecticut (CT)</form:option>
							<form:option value="DE">Delaware (DE)</form:option>
							<form:option value="DC">District Of Columbia (DC)</form:option>
							<form:option value="FL">Florida (FL)</form:option>
							<form:option value="GA">Georgia (GA)</form:option>
							<form:option value="HI">Hawaii (HI)</form:option>
							<form:option value="ID">Idaho (ID)</form:option>
							<form:option value="IL">Illinois (IL)</form:option>
							<form:option value="IN">Indiana (IN)</form:option>
							<form:option value="IA">Iowa (IA)</form:option>
							<form:option value="KS">Kansas (KS)</form:option>
							<form:option value="KY">Kentucky (KY)</form:option>
							<form:option value="LA">Louisiana (LA)</form:option>
							<form:option value="ME">Maine (ME)</form:option>
							<form:option value="MD">Maryland (MD)</form:option>
							<form:option value="MA">Massachusetts (MA)</form:option>
							<form:option value="MI">Michigan (MI)</form:option>
							<form:option value="MN">Minnesota (MN)</form:option>
							<form:option value="MS">Mississippi (MS)</form:option>
							<form:option value="MO">Missouri (MO)</form:option>
							<form:option value="MT">Montana (MT)</form:option>
							<form:option value="NE">Nebraska (NE)</form:option>
							<form:option value="NV">Nevada (NV)</form:option>
							<form:option value="NH">New Hampshire (NH)</form:option>
							<form:option value="NJ">New Jersey (NJ)</form:option>
							<form:option value="NM">New Mexico (NM)</form:option>
							<form:option value="NY">New York (NY)</form:option>
							<form:option value="NC">North Carolina (NC)</form:option>
							<form:option value="ND">North Dakota (ND)</form:option>
							<form:option value="OH">Ohio (OH)</form:option>
							<form:option value="OK">Oklahoma (OK)</form:option>
							<form:option value="OR">Oregon (OR)</form:option>
							<form:option value="PA">Pennsylvania (PA)</form:option>
							<form:option value="RI">Rhode Island (RI)</form:option>
							<form:option value="SC">South Carolina (SC)</form:option>
							<form:option value="SD">South Dakota (SD)</form:option>
							<form:option value="TN">Tennessee (TN)</form:option>
							<form:option value="TX">Texas (TX)</form:option>
							<form:option value="UT">Utah (UT)</form:option>
							<form:option value="VT">Vermont(VT)</form:option>
							<form:option value="VA">Virginia(VA)</form:option>
							<form:option value="WA">Washington(WA)</form:option>
							<form:option value="WV">West Virginia(WV)</form:option>
							<form:option value="WI">Wisconsin(WI)</form:option>
							<form:option value="WY">Wyoming(WY)</form:option>
						</form:select>
			</p>
			<br>
			<div class="text-center pr-5">
				<Button type="submit" class="btn btn-info">Create Event</Button>
			</div>
		</form:form>
	</div>


	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
  </body>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<title>Event Info</title>
</head>
<body>
	<div class="container text-right ">
		<div class="mt-3 pr-2">
			<a href="/home"><button class="btn btn-success shadow">Home</button></a>
			<a href="/logout"><button class="btn btn-danger">Logout</button></a>
			
		</div>
	</div>
	
	<div class="container">
		<div class="row">
			<div class="col">
				<h1 class="display-4 border-bottom border-info d-inline-block ">${event.name}</h1>
				<div class="mt-4 ">
					<h5>Host: ${fn:toUpperCase(fn:substring(event.user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.firstName, 1,fn:length(event.user.firstName)))} ${fn:toUpperCase(fn:substring(event.user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(event.user.lastName, 1,fn:length(event.user.lastName)))}</h5>
					<h5>Date: <fmt:formatDate type = "date" dateStyle = "long" timeStyle = "long" value = "${event.date}" /></h5>
					<h5>Location: ${event.city}, ${event.state}</h5>
					<br>
					<div>
						<h4 class="border-bottom border-info d-inline-block font-weight-normal">Users who are attending this event</h4>
						<table class="table table-info">
							<thead>
							<tr>
								<th scope="col" class="bg-info">Name</th>
								<th scope="col" class="bg-info">From</th>
							</tr>
							</thead>
							<tbody class="border border-info">
								<c:forEach items="${event.joinedUsers}" var="j">
								
										<tr>
											<td>${j.firstName } ${j.lastName} </td>
											<td>${j. city }, ${j.state }</td>
										</tr>
									
								
									
								</c:forEach>
								
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<br>
			<div class="col mt-5">
				<h4 class="h3 text-center border-bottom border-info"><small>Message Wall</small></h4>
				<div class="h-75 border border-info" style="overflow: scroll;">
					<c:forEach items="${event.comments}" var="comment">
						<c:choose>
							<c:when test="${comment.user.id == user.id}">
								<p class="text-success"><u class="font-weight-bold">${fn:toUpperCase(fn:substring(comment.user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(comment.user.firstName, 1,fn:length(comment.user.firstName)))} ${fn:toUpperCase(fn:substring(comment.user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(comment.user.lastName, 1,fn:length(comment.user.lastName)))}</u> - ${comment.comment} </p>
								<p class="text-dark text-center border-bottom border-dark"></p>
							</c:when>
							<c:otherwise>
								<p class="text-primary"><u class="font-weight-bold">${fn:toUpperCase(fn:substring(comment.user.firstName, 0, 1))}${fn:toLowerCase(fn:substring(comment.user.firstName, 1,fn:length(comment.user.firstName)))} ${fn:toUpperCase(fn:substring(comment.user.lastName, 0, 1))}${fn:toLowerCase(fn:substring(comment.user.lastName, 1,fn:length(comment.user.lastName)))}</u> - ${comment.comment}</p>
								<p class="text-dark text-center border-bottom border-dark "></p>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</div>
				<br>
				<form:form action="/events/${event.id}" method="POST" modelAttribute="addComment">
					<form:input path="comment" cssClass="form-control bg-info text-white" placeholder="Comment here"/>
					<p><form:errors path="comment"/></p>
					<br>
					<div class="text-right">
						<Button type="submit" class="btn btn-outline-info ">Add Comment</Button>
					</div>
				</form:form>
				
			</div>
		</div>
	</div>
	

	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
  </body>
</body>
</html>
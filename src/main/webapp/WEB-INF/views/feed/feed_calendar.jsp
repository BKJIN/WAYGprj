<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/b4e02812b5.js" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<!-- calendar api start -->
<script src="js/feed/fc/main.js"></script>
<script src="js/feed/fc/locales/ko.js"></script>
<script src="js/feed/feed_calendar.js"></script>
<link href="css/feed/fc/main.css" rel="stylesheet"></link>
<!-- calendar api end -->
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/feed/feed_calendar.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<title>Feed Calendar</title>
</head>

<body>
<%@ include file="../includes/header.jsp" %>
<section class="container mb-5">
	<div class="body-container">
		<div id="feed-header" class="d-flex justify-content-around">
			<div id="profile-left" class="p-3 mb-5 bg-body"></div>
			<div id="profile-img" class="p-3 mb-5 bg-body">
				<i class="profile-img fa-regular fa-circle-user"></i>
			</div>
			<div id="profile-right" class="p-3 mb-5 bg-body"></div>
		</div>
		
		<hr />
	
		<div class="d-flex justify-content-between mt-4" id="main-body">
			<!-- create plan form -->
			<div class="border rounded p-3">
				<form action="feed/planList.do" id="frm" method="post">
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
					<div class="form-group">
						<label for="planName">?????? ??????</label>
						<input type="text" name="planName" id="planName" class="form-control" required/>
					</div>
					
					<div class="form-group">
						<label for="startDate">?????? ??????</label>
						<input type="text" name="startDate" id="startDate" class="form-control bg-light" required readonly/>
					</div>
					
					<div class="form-group">
						<label for="endDate">?????? ??????</label>
						<input type="text" name="endDate" id="endDate" class="form-control bg-light" required readonly/>
					</div>
					
					<div class="form-group">
						<label for="theme">??????</label>
						<select class="custom-select my-1 mr-sm-2 " id="theme" name="theme">
							<option value="??????" selected>??????</option>
							<option value="?????????">?????????</option>
							<option value="????????????">????????????</option>
							<option value="????????????">????????????</option>
							<option value="????????????">????????????</option>
							<option value="????????????">????????????</option>
							<option value="?????????">?????????</option>
							<option value="??????">??????</option>
							<option value="??????">??????</option>
							<option value="????????????">????????????</option>
							<option value="????????????">????????????</option>
						</select>
					</div>
					<div class="d-flex justify-content-end mp_btn">
						<button type="submit" class="btn btn-sm btn-primary mr-1" id="submit" >Create</button>
						<input type="reset" class="btn btn-sm btn-danger px-2" id="reset" value="Clear" />
					</div>
				</form>
			</div>
			<!-- fullcalendar div  -->
			<div id="calendar" class="container"></div>
		</div>
	</div>
	<!-- modal button -->
	<input type="hidden" id="modalBtn2" data-toggle="modal" data-target="#myModal2" value="modal" />

</section>

<%@ include file="event_modi_modal.jsp" %>
<%@ include file="../includes/footer.jsp" %>
</body>
</html>
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
<title>header</title>
</head>

<body>
<nav class="navbar navbar-default fixed-top border-bottom pt-3 bg-white">
	<div class="container">
		<div class="navbar-header">
			<a href="/init" class="navbar-brand">
				<i class="menu-icon fa-solid fa-house"></i>
			</a>
		</div>
		
		<div>
			<div class="input-group border rounded bg-light">
		    	<div class="input-group-btn">
		    		<button type="button" class="btn btn-default mr-1">filter</button>
		        	<button type="button" class="btn btn-default dropdown-toggle mr-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="caret"></span></button>
		        	<ul class="dropdown-menu">
		          		<li>filter 1</li>
		          		<li>filter 2</li>
		          		<li>filter 3</li>
		        	</ul>
		      	</div>
		      	<input type="text" class="form-control bg-light mr-1" size="30" aria-label="000" placeholder="search...">
	    		<a href="search" class="btn btn-default mr-1"><i class="fa-brands fa-sistrix"></i></a>	      	
		    </div>
		</div>
		
		<ul class="nav navbar">
		<s:authorize access="isAnonymous()">
			<li class="mr-4 feed">
				<a href="feed" id="anFeed">
					<i class="menu-icon fa-regular fa-circle-user"></i>
				</a>
			</li>
		</s:authorize>
		<s:authorize access="isAuthenticated()">
			<li class="mr-4 feed">
				<a href="feed" id="loginFeed">
					<i class="menu-icon fa-regular fa-circle-user"></i>
				</a>
			</li>
		</s:authorize>	
			<li class="mr-4 notice">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<i class="menu-icon fa-regular fa-bell"></i>
				</a>
	        	<ul class="dropdown-menu">
	        		<c:forEach begin="1" end="10" var="i">
			          	<li class="list-group-item">
			          		alarm${i}
			          	</li>
		          	</c:forEach>
	        	</ul>
				
			</li>
			
			<li class="mr-4 msg">
				<a href="chat/rooms">
					<i class="menu-icon fa-regular fa-comment-dots"></i>
				</a>
			</li>
		</ul>
		
	</div>
			
<script>
$(document).ready(function(){
	$('#anFeed').click(function(e){
		e.preventDefault();
		$('#loginModalBtn').trigger('click');
	});
});
</script>
</nav>
</body>
</html>
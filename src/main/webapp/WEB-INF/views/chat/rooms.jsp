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
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
</head>
<body>

<%@ include file="../includes/header.jsp" %>

<div class="container" style="margin-top:90px; margin-bottom:50px;">
	<div>
		<c:forEach items="${list}" var="room">
			<ul>
				<li>
					<a href="room?roomId=${room.roomId}">${room.name}</a>
				</li>
			</ul>
		</c:forEach>
	</div>
	<form action="croom" method="get">
		<input type="text" name="name" class="form-control">
		<button type="submit" class="btn btn-secondary btn-create">Create Room</button>
	</form>
</div>

<script>
	$(document).ready(function(){
		var roomName = "${roomName}";
		console.log("${roomName}");
		
		if(roomName != "")
			alert(roomName + "방이 개설되었습니다.");
		
		$(".btn-create").on("click", function(e){
			e.preventDefault();
			
			var name = $("input[name='name']").val();
			
			if(name == "")
				alert("Please write the name.")
			else
				$("form").submit();
		});
	});
</script>

<%@ include file="../includes/footer.jsp" %>

</body>
</html>
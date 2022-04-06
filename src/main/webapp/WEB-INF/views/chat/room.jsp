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
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="../css/includes/footer.css" />
<title>Insert title here</title>
</head>
<body>

<%@ include file="../includes/header.jsp" %>

<div class="container" style="margin-top:90px; margin-bottom:50px;">
	<div class="col-6">
		<h1>${room.name}</h1>
	</div>
	<div>
		<div id="msgArea" class="col"></div>
		<div class="col-6">
			<div class="input-group mb-3">
				<input type="text" id="msg" class="form-control">
				<div class="input-group-append">
					<button class="btn btn-oulint-secondary" type="button" id="button-send">Send</button>
				</div>
			</div>
		</div>
	</div>
	<div class="col-6"></div>
</div>

<script>
	$(document).ready(function(){
		var roomName = "${room.name}";
		var roomId = "${room.roomId}";
		var username = "jim";
		
		console.log(roomName + ", " + roomId + ", " + username);
		
		var sockJs = new SockJS("/init/chat");
		var stomp = Stomp.over(sockJs);
		
		stomp.connect({}, function(){
			console.log("STOMP Connection");
		
		stomp.subscribe("/sub/chat/room/" + roomId, function(chat) {
			console.log("메세지 받음");
			var content = JSON.parse(chat.body);
			
			var writer = content.writer;
			var str = '';
			
			if(writer == username) {
				str = "<div class='col-6'>";
				str += "<div class='alert alert-secondary'>";
				str += "<b>" + writer + " : " + content.message + "</b>";
				str += "</div></div>";
				$("#msgArea").append(str);
			}
			else {
				str = "<div class='col-6'>";
				str += "<div class='alert alert-warning'>";
				str += "<b>" + writer + " : " + content.message + "</b>";
				str += "</div></div>";
				$("#msgArea").append(str);
			}
			
			//$("#msgArea").append(str);
		});
		
		stomp.send('/pub/chat/enter', {}, JSON.stringify({roomId: roomId, writer: username}))
		});
	
	$("#button-send").on("click", function(e){
		var msg = document.getElementById("msg");
		
		console.log(username + ":" + msg.value);
		stomp.send('/pub/chat/message', {}, JSON.stringify({roomId: roomId, message: msg.value, writer: username}));
		msg.value = '';
	});
});
</script>

<%@ include file="../includes/footer.jsp" %>

</body>
</html>
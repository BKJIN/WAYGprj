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
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}">
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
<style>
body{margin-top:20px;}

.chat-online {
    color: #34ce57
}

.chat-offline {
    color: #e4606d
}

.chat-messages {
    display: flex;
    flex-direction: column;
    max-height: 800px;
    height:800px;
    overflow-y: scroll
}

.chat-message-left,
.chat-message-right {
    display: flex;
    flex-shrink: 0
}

.chat-message-left {
    margin-right: auto;
}

.chat-message-right {
    flex-direction: row-reverse;
    margin-left: auto;
}
.py-3 {
    padding-top: 1rem!important;
    padding-bottom: 1rem!important;
}
.px-4 {
    padding-right: 1.5rem!important;
    padding-left: 1.5rem!important;
}
.flex-grow-0 {
    flex-grow: 0!important;
}
.border-top {
    border-top: 1px solid #dee2e6!important;
}
#appOtherImg {
	height:50px;
}
</style>
</head>
<body>

<%@ include file="../includes/header.jsp" %>

<main class="content" style="margin-top:90px; margin-bottom:50px;">
    <div class="container p-0">

		<h1 class="h3 mb-3">Messages</h1>

		<div class="card">
			<div class="row g-0">
				<div id="searchAndUser" class="col-12 col-lg-5 col-xl-3 border-right" style="max-height:939px; overflow-y:scroll">

					<div class="px-4 d-none d-md-block">
						<div class="d-flex align-items-center">
							<div class="flex-grow-1">
								<input id="searchNick" type="text" class="form-control my-3" placeholder="회원 검색">
							</div>
						</div>
					</div>
					
					<a href="#" id="foundUserInfo" class="list-group-item list-group-item-action border-0" style="display:none;">
						<button id="createChat" style="all:unset;" class="float-right"><i class="fa-solid fa-message"></i></button>
						<div class="d-flex align-items-start">
							<img id="foundUserImg" class="rounded-circle mr-1" width="40" height="40">
							<div id="foundUserNick" class="flex-grow-1 ml-3">
							</div>
						</div>
					</a>
					
					<div id="userList">
					<c:forEach items="${chatRoomList}" var="dto">
					<button class="addedUserInfo ${dto.roomNum} list-group-item list-group-item-action border-0" style="display:none;">
						<div class="rId" style="display:none;">${dto.roomId}</div>
						<div class="d-flex align-items-start">
							<img src="${dto.roomImg}" class="rounded-circle mr-1" width="40" height="40">
							<div class="addedUserNicks flex-grow-1 ml-3">${dto.chatRoom}</div>
						</div>
					</button>
					</c:forEach>
					
				</div>
					<hr class="d-block d-lg-none mt-1 mb-0">
				</div>
				<div class="col-12 col-lg-7 col-xl-9 border-left">
					<div class="py-2 px-4 border-bottom d-none d-lg-block">
						<div id="appOtherImg" class="d-flex align-items-center py-1">
						</div>
					</div>

					<div class="position-relative">
						<div id="msgArea" class="chat-messages p-4">
						</div>
					</div>

					<div class="flex-grow-0 py-3 px-4 border-top">
						<div class="input-group">
							<input id="msg" type="text" class="form-control" placeholder="Type your message">
							<button id="button-send" class="btn btn-primary" disabled>Send</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</main>

<%@ include file="../includes/footer.jsp" %>

<script>
function check() {
	console.log("1");
}

$(document).ready(function() {
	var userInfo;
	$("#searchNick").keyup(function(){
		var val = $("#searchNick").val();
		$.ajax({
			type : "get",
			url : "searchNick",
			data : {nick:val},
			success : function(data) {
				console.log(data)
				if(data.userNick != null) {
					$("#foundUserInfo").css("display","block");
					$("#foundUserImg").attr("src","/init/resources/profileImg/"+data.userProfileImg);
					$("#foundUserNick").html(data.userNick);
					userInfo = {userNick:data.userNick, userImg:"/init/resources/profileImg/"+data.userProfileImg}
				} else {
					$("#foundUserInfo").css("display","none");
				}
			},error : function() {
				alert("에러입니다. 다시 시도해주세요.");
			}
		});
	});
	
	$("#createChat").click(function() {
		$.ajax({
			type : "POST",
			url : "croom",
			data: {subNick: userInfo.userNick, subImg: userInfo.userImg},
			beforeSend: function(xhr){
		    	var token = $("meta[name='_csrf']").attr('content');
		    	var header = $("meta[name='_csrf_header']").attr('content');
		    	xhr.setRequestHeader(header, token);
		    },
			success: function(data) {
				if(data.search("existRoom") > -1) {
					alert("이미 채팅방이 존재 합니다.");
				}
				else {
					location.reload();
				}
				
			},error: function() {
				alert("채팅방 생성 에러입니다. 다시 시도해 주세요.");
			}
			
		});
	});
	
	var uId = "${uId}";
	console.log(uId)
	if("${chatRoomList}" != null) {
		$(".addedUserInfo").css("display","block");
	} 
	
	var sockJs = new SockJS("/init/chat");
	var stomp = Stomp.over(sockJs);
	
	var roomId;
	var pubId;
	var pubImg;
	var pubNick;
	var subId;
	var subImg;
	var subNick;
	
	stomp.connect({}, function(){
		console.log("STOMP Connection");
		$(".addedUserInfo ${dto.roomNum}").click(function(){
			$(".addedUserInfo").attr("disabled",true);
			//$(".addedUserInfo").not(this).css("display","block");
			$("#searchAndUser").css("visibility","hidden");
			$("#msgArea").empty();
			$.ajax({
				type: "POST",
				url : "room",
				data: {roomId:$(this).children("div:first").html()},
				beforeSend: function(xhr){
			    	var token = $("meta[name='_csrf']").attr('content');
			    	var header = $("meta[name='_csrf_header']").attr('content');
			    	xhr.setRequestHeader(header, token);
			    },
			    success: function(data) {
			    	console.log("채팅방 입장 성공");
			    	
			    	pubId = data.cdto.pubId;
			    	pubImg = data.cdto.pubImg;
			    	pubNick = data.cdto.pubNick;
			    	subId = data.cdto.subId;
			    	subImg = data.cdto.subImg;
			    	subNick = data.cdto.subNick;
			    	roomId = data.cdto.roomId;
			    	
			    	if(uId == pubId) {
			    		var otherImg = subImg;
			    		var str = '';
			    		str = '<div class="position-relative">';
						str += '<img src="' + otherImg + '" class="rounded-circle mr-1" width="40" height="40">';
						str += '</div>';
			    		str += '<div class="flex-grow-1 pl-3">';
						str += '<strong>' + subNick + '</strong>';
						str += '</div>';
						str += '<button class="exitRoom" style="all:unset; cursor:pointer;">'
						str += '<i class="fa-solid fa-rectangle-xmark" style="font-size:2rem"></i>';
						str += '</button>'
						$("#appOtherImg").empty().append(str);
			    	} else {
			    		var otherImg = pubImg;
			    		var str = '';
			    		str = '<div class="position-relative">';
						str += '<img src="' + otherImg + '" class="rounded-circle mr-1" width="40" height="40">';
						str += '</div>';
			    		str += '<div class="flex-grow-1 pl-3">';
						str += '<strong>' + pubNick + '</strong>';
						str += '</div>';
						str += '<button class="exitRoom" style="all:unset; cursor:pointer;">'
						str += '<i class="fa-solid fa-rectangle-xmark" style="font-size:2rem"></i>';
						str += '</button>'
						$("#appOtherImg").empty().append(str);
			    	}
			    	
			   		for(var i = 0; i < data.mdtos.length; i++) {
			   			var str = '';
						var str1 = '';
						
			   			if(uId == data.mdtos[i].m_pubId) {
							if(data.mdtos[i].m_pubMsg != null) {
			   					str = '<div class="chat-message-right pb-4">';
								str += '<div>';
								str += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str += '</div>';
								str += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 mr-3">';
								str += data.mdtos[i].m_pubMsg;
								str += '</div>';
								str += '</div>';
								$("#msgArea").append(str);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
							if(data.mdtos[i].m_subMsg != null) {
								str1 = '<div class="chat-message-left pb-4">';
								str1 += '<div>';
								str1 += '<img src="' + data.mdtos[i].m_subImg + '" class="rounded-circle mr-1" width="40" height="40">';
								str1 += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str1 += '</div>';
								str1 += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
								str1 += '<div class="font-weight-bold mb-1">' + data.mdtos[i].m_subNick + '</div>';
								str1 += data.mdtos[i].m_subMsg;
								str1 += '</div>';
								str1 += '</div>';
								$("#msgArea").append(str1);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
						} else {
							if(data.mdtos[i].m_subMsg != null) {
								str = '<div class="chat-message-right pb-4">';
								str += '<div>';
								str += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str += '</div>';
								str += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 mr-3">';
								str += data.mdtos[i].m_subMsg;
								str += '</div>';
								str += '</div>';
								$("#msgArea").append(str);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
							if(data.mdtos[i].m_pubMsg != null) {
								str1 = '<div class="chat-message-left pb-4">';
								str1 += '<div>';
								str1 += '<img src="' + data.mdtos[i].m_pubImg + '" class="rounded-circle mr-1" width="40" height="40">';
								str1 += '<div class="text-muted small text-nowrap mt-2">' + data.mdtos[i].m_sendTime + '</div>';
								str1 += '</div>';
								str1 += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
								str1 += '<div class="font-weight-bold mb-1">' + data.mdtos[i].m_pubNick + '</div>';
								str1 += data.mdtos[i].m_pubMsg;
								str1 += '</div>';
								str1 += '</div>';
								$("#msgArea").append(str1);
								$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
							}
						}
			   		}
			    	
			    	stomp.subscribe("/sub/chat/room/" + roomId, function(chat) {
						console.log("메세지 받음");
						var content = JSON.parse(chat.body);
						var str = '';
						var msg;
						var img;
						var nick;
						
						if(content.m_pubMsg == null) {
							msg = content.m_subMsg;
						} else {
							msg = content.m_pubMsg;
						}
						
						if(uId == pubId) {
							img = content.m_subImg;
							nick = content.m_subNick;
						} else {
							img = content.m_pubImg;
							nick = content.m_pubNick;
						}
						
						if(uId == content.m_sendId) {
							str = '<div class="chat-message-right pb-4">';
							str += '<div>';
							str += '<div class="text-muted small text-nowrap mt-2">' + content.m_sendTime + '</div>';
							str += '</div>';
							str += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 mr-3">';
							str += msg;
							str += '</div>';
							str += '</div>';
							$("#msgArea").append(str);
							$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
						}
						else {
							str = '<div class="chat-message-left pb-4">';
							str += '<div>';
							str += '<img src="' + img + '" class="rounded-circle mr-1" width="40" height="40">';
							str += '<div class="text-muted small text-nowrap mt-2">' + content.m_sendTime + '</div>';
							str += '</div>';
							str += '<div class="flex-shrink-1 bg-light rounded py-2 px-3 ml-3">';
							str += '<div class="font-weight-bold mb-1">' + nick + '</div>';
							str += msg;
							str += '</div>';
							str += '</div>';
							$("#msgArea").append(str);
							$(".chat-messages").scrollTop($(".chat-messages")[0].scrollHeight);
						}
			
					});
		
			    },error: function() {
			    	alert("채팅방 입장 에러입니다. 다시 시도해주세요.");
			    }
			});		
				
		});	
			
	});
	
	$(document).on("click",".exitRoom",function(){
		location.reload();
	});
		
	$("#button-send").on("click", function(e){
		$("#msg").focus();
		var msg = document.getElementById("msg");
		var today = new Date();
		var sendTime = today.toLocaleString();
		
		if(uId==pubId) {
		stomp.send('/pub/chat/message', {}, JSON.stringify({m_roomId: roomId, m_pubId: pubId, m_pubNick: pubNick, m_subId: subId, m_subNick: subNick, m_sendTime: sendTime, m_pubImg: pubImg, m_subImg: subImg, m_sendId: uId, m_pubMsg: msg.value }));
		} else {
		stomp.send('/pub/chat/message', {}, JSON.stringify({m_roomId: roomId, m_pubId: pubId, m_pubNick: pubNick, m_subId: subId, m_subNick: subNick, m_sendTime: sendTime, m_pubImg: pubImg, m_subImg: subImg, m_sendId: uId, m_subMsg: msg.value }));
		}
		msg.value = '';
	});
	
	$('#msg').keypress(function(event){
		if ( event.which == 13 ) {
	     	$('#button-send').click();
	        return false;
	     }
	});
	
	$("#msg").keyup(function(){
		if($("#msg").val()=='')
			$("#button-send").attr("disabled",true);
		else
			$("#button-send").attr("disabled",false);
	});
				
});

</script>
</body>
</html>
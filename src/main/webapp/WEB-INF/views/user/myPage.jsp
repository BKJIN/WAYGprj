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
<title>myPage</title>
<style>
#prfImgArea {
	position : relative;
}

.prfBtn {
	position : absolute;
	right: 1px;
	color: black;
}

</style>

</head>
<body>

<%@ include file="../includes/header.jsp" %>

<div class="container" style="margin-top:90px; margin-bottom:20px;">
	<form action="add_PrfImg?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
		<div class="d-flex justify-content-center">
			<c:choose>
				<c:when test="${not empty fileName}">
					<div id="prfImgArea">
						<img src="/init/resources/profileImg/${fileName}" class="rounded-circle" width="100" height="100">
						<a href="#" class="prfBtn"><i class="fa-solid fa-eraser"></i></a>
					</div>
				</c:when>
				<c:otherwise>
					<i class="user-info-icon fa-regular fa-circle-user" style="font-size:6rem; color: #112FE0;"></i>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="d-flex justify-content-center">
			<div>${myPageInfo.userNick}</div>
		</div>
		<div class="d-flex justify-content-center mt-1">
			<div class="btn btn-sm btn-primary" style="height:32px;">
				<label for="prfImg">
					Profile Image
				</label>
			</div>
		</div>
		<input type="file" class="form-control" id="prfImg" name="pImg" accept="image/*" onchange="clicksubmit()" style="display:none;">
		<button id="submitImg" type="submit" class="btn btn-primary" style="display:none;">submit</button>
	</form>
	<div class="form-group">
		<label for="userProfileMsg">BIO</label>
		<textarea class="form-control" id="userProfileMsg" name="uPrfMsg" rows="5" readonly></textarea>
	</div>
	<div class="form-group">
		<label for="userEmail">EMAIL</label>
		<input type="text" class="form-control" id="userEmail" name="uEmail" value="${myPageInfo.userEmail}" readonly>
	</div>
	<div class="form-group">
		<label for="userBirth">BIRTH</label>
		<input type="text" class="form-control" id="userBirth" name="uBirth" value="${myPageInfo.userBirth}" readonly>
	</div>
	<div class="form-group" style="text-align:center; margin:0 auto;">
		<div class="btn-group btn-group-toggle" data-toggle="buttons">
			<label class="btn btn-outline-primary">
				<input type="radio" id="male" name="uGender" autocomplete="off" value="MALE">&nbsp;MALE&nbsp;
			</label>
			<label class="btn btn-outline-primary">
				<input type="radio" id="female" name="uGender" autocomplete="off" value="FEMALE">FEMALE
			</label>
		</div>
	</div>
	<div class="form-group">
		<label for="userAddr1">ADDRESS1</label>
			<div class="form-inline mb-2">
				<input type="text" class="form-control" id="userPst" name="uPst" value="${myPageInfo.userPst}" readonly>
			</div>
		<input type="text" class="form-control" id="userAddr1" name="uAddr1" value="${myPageInfo.userAddress}" readonly>
	</div>
	<div class="form-group">
		<label for="userAddr2">ADDRESS2</label>
		<input type="text" class="form-control" id="userAddr2" name="uAddr2" readonly>
	</div>
	<div class="d-flex justify-content-center">
		<div>
			<button type="button" id="modifyInfo" class="btn btn-secondary">회원정보 수정</button>
			<button type="button" id="modified" class="btn btn-success" style="display:none">수정 완료</button>
			<button type="button" class="btn btn-secondary">비밀번호 변경</button>
			<button type="button" class="btn btn-danger">회원 탈퇴</button>
		</div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>

<script>
console.log('${fileName}');

function clicksubmit() {
	console.log("clicksubmit")
	document.getElementById("submitImg").click();
}

$(document).ready(function(){
	//DB성별로 자동 고정
	if("${myPageInfo.userGender}" == "MALE") {
		$("#male").click();
		$("#female").prop("disabled",true);
	}
	else {
		$("#female").click();
		$("#male").prop("disabled",true);
	}
	
	$("#modifyInfo").click(function(){
		$("#modifyInfo").css("display","none");
		$("#modified").css("display","inline");
		$("textarea[name='uPrfMsg']").attr("readonly",false);
		$("input[name='uPst']").attr("readonly",false);
		$("input[name='uAddr1']").attr("readonly",false);
		$("input[name='uAddr2']").attr("readonly",false);
	});
});
</script>

</body>
</html>
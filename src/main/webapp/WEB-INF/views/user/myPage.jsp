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
<!-- KAKAO API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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
			<div id="userNick">${myPageInfo.userNick}</div>
			<input id="inputUserNick" type="text" value="${myPageInfo.userNick}" style="display:none; text-align:center">
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
		<textarea class="form-control border border-dark" id="userProfileMsg" name="uPrfMsg" rows="5" disabled></textarea>
	</div>
	<div class="form-group">
		<label for="userEmail">EMAIL</label>
		<input type="text" class="form-control border border-dark" id="userEmail" name="uEmail" value="${myPageInfo.userEmail}" disabled>
	</div>
	<div class="form-group">
		<label for="userBirth">BIRTH</label>
		<input type="text" class="form-control border border-dark" id="userBirth" name="uBirth" value="${myPageInfo.userBirth}" disabled>
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
				<div class="input-group border border-dark rounded">
					<input type="text" class="form-control" id="userPst" name="uPst" value="${myPageInfo.userPst}" onfocus="clickSerachPst()" disabled> <!-- readonly속성은 onfocus가 먹힘 -->
					<span class="input-group-btn">
						<button type="button" id="searchPst" class="btn btn-primary" onclick="serchPostCode()" style="display:none;">SERACH</button>
					</span>
				</div>
			</div>
		<span id="guide" style="color:#999;display:none"></span>
		<input type="text" class="form-control border border-dark" id="userAddr1" name="uAddr1" onfocus="clickSerachPst()" value="${myPageInfo.userAddress1}" disabled>
	</div>
	<div class="form-group">
		<label for="userAddr2">ADDRESS2</label>
		<input type="text" class="form-control border border-dark" id="userAddr2" name="uAddr2" value= "${myPageInfo.userAddress2}" disabled>
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

//프로필사진 파일 등록시 자동 submit
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
	
	//회원정보 수정
	$("#modifyInfo").click(function(){
		//회원정보 수정-> 수정 완료로 버튼 변경
		$("#modifyInfo").css("display","none");
		$("#modified").css("display","inline");
		
		//회원정보 수정가능하게 바뀜
		$("#userNick").css("display","none");
		$("#inputUserNick").css("display","inline");
		$("textarea[name='uPrfMsg']").attr("disabled",false);
		$("input[name='uPst']").attr("disabled",false);
		$("input[name='uAddr1']").attr("disabled",false);
		$("input[name='uAddr2']").attr("disabled",false);
		$("#searchPst").css("display","inline");
	});
	
	$("#modified").click(function(){
		var userNick = $("#inputUserNick").val();
		var userBio = $("#userProfileMsg").val();
		var userPst = $("#userPst").val();
		var userAddr1 = $("#userAddr1").val();
		var userAddr2 = $("#userAddr2").val();
		var allData = {"userBio":userBio,"userPst":userPst,"userAddr1":userAddr1,"userAddr2":userAddr2};
		console.log(userNick)
		
	});
});

//====== 주소 입력 ======
function clickSerachPst() { //POSTCODE input, ADDRESS1 input 포커스시 serchPst 클릭
	document.getElementById("searchPst").click();
	document.getElementById("userPst").blur();
	document.getElementById("userAddr1").blur();
}

//카카오 api
function serchPostCode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('userPst').value = data.zonecode;
            document.getElementById("userAddr1").value = roadAddr;
            
			var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
                var expRoadAddr = data.autoRoadAddress;
                guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                guideTextBox.style.display = 'block';

            } else {
                guideTextBox.innerHTML = '';
                guideTextBox.style.display = 'none';
            }
            document.getElementById("userAddr2").focus(); // userAddr1입력 후 포커스
            $('.userPst-validation').html('');
            chkPst = true;
        }
    }).open();
}

</script>

</body>
</html>
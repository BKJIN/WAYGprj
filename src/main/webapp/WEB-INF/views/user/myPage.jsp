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
	<!-- 회원정보 변경완료시, 비밀번호 변경시 모달 -->
	<!-- modal button -->
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" value="modal">
	<!-- modal창 -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WAYG</h4>
				</div>
				<div class="modal-body bg-light">
					<form action="modifyPw" id="modifyPwForm" method="post" style="display:none">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="form-group">
							<label for="curPw">Current password</label>
							<input type="password" class="form-control" id="curPw" name="crpw" autocomplete="off" required/>
							<div class="form-group" style="visibility:hidden; color:red; font-size:12px;" id="curPwError">현재 비밀번호가 일치하지 않습니다.</div>
						</div>
						<div class="form-group">
							<label for="newPw">New password</label>
							<input type="password" class="form-control"  id="newPw" name="npw" autocomplete="off" required/>
						</div>
						<div class="form-group">
							<label for="cfrmPw">Confirm new password</label>
							<input type="password" class="form-control"  id="cfrmPw" name="cfpw" autocomplete="off" required/>
						</div>
						<input type="submit" value="비밀번호 변경" class="btn btn-sm btn-primary"/>
					</form>
				</div>
				<div class="modal-footer bg-light">
					<button id="closeBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
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
		<textarea class="form-control border border-dark" id="userProfileMsg" name="uPrfMsg" rows="5" disabled>${myPageInfo.userProfileMsg}</textarea>
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
			<button type="button" id="modifyPw" class="btn btn-secondary">비밀번호 변경</button>
			<button type="button" id="resignation" class="btn btn-danger">회원 탈퇴</button>
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
		//Bio가 change되면 ajax로 보내 업데이트 되게 하기 위해
		var mdfBio = false;
		console.log(mdfBio)
		$("textarea[name='uPrfMsg']").change(function(){
			mdfBio = true;
			console.log(mdfBio)
		});
	
	$("#modified").click(function(){
		var userNick = $("#inputUserNick").val();
		var userBio = $("#userProfileMsg").val();
		var userPst = $("#userPst").val();
		var userAddr1 = $("#userAddr1").val();
		var userAddr2 = $("#userAddr2").val();
		var allData = {"userNick":userNick, "userBio":userBio, "userPst":userPst, "userAddr1":userAddr1, "userAddr2":userAddr2};
		
		//mdfBio변수를 따로 둔 이유는 내용에 엔터가 포함되면 자바스크립트 오류 발생
		if(userNick == "${myPageInfo.userNick}" && mdfBio == false && userPst == "${myPageInfo.userPst}" && userAddr1 == "${myPageInfo.userAddress1}" && userAddr2 == "${myPageInfo.userAddress2}") {
			location.reload();
		}else {
			$.ajax({
				type:"GET",
				url : "modifyMyPage",
				data: allData,
				success:function(data){
					if(data.search("modified") > -1) {
						$(".modal-body").html("<h5>회원정보가 변경되었습니다.</h5>") //모달창 메세지
						$("#modalBtn").trigger("click");
						$("#closeBtn").click(function(event){
							event.preventDefault();
							location.reload();
						});
					} else {
						$(".modal-body").text("다시 시도해 주세요."); //회원정보 변경 실패
						$("modalBtn").trigger("click");
					}
				},
				error:function() {
					alert("회원정보수정 에러 입니다. 다시 시도해 주세요.");
				}
			});
		}
	});
	
	//비밀번호 변경 버튼 클릭시 모달창 비밀번호변경 UI로 바뀜
	$("#modifyPw").click(function(){
		$("#modifyPwForm").css("display","inline");
		$("#modalBtn").trigger("click");
	});
	
	//모달창안에 비밀번호 변경 버튼 클릭시
	$("#modifyPwForm").submit(function(e){
		e.preventDefault();
		$.ajax({
			type : $("#modifyPwForm").attr("method"),
			url : $("#modifyPwForm").attr("action"),
			data : $("#modifyPwForm").serialize(),
			success : function(data) {
				if(data.search("pw-modified") > -1) {
					$(".modal-body").html("<h5>비밀번호가 변경되었습니다.</h5>")
					$("#closeBtn").click(function(){
						$("#modifyPwForm").css("display","inline");
					});
				}
				else if(data.search("pw-not-modified") > -1){
					alert("비밀번호 변경에 실패했습니다. 다시 시도해 주세요.");
				}
				else {
					//현재 비밀번호가 일치하지 않습니다. 보이게
					$("#curPwError").css("visibility","visible");
				}
			},
			error : function() {
				alert("비밀번호 수정 에러. 다시 시도해 주세요.");
			}
		});
	});
	
	//비밀번호변경 모달창 닫을시 모달창 초기화
	$("#closeBtn").click(function(event){
		$("#curPwError").css("visibility","hidden");
		$("#curPw").val("");
		$("#newPw").val("");
		$("#cfrmPw").val("");
	});
	
	$("#resignation").click(function(){
		alert("회원탈퇴 하시겠습니까?");
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
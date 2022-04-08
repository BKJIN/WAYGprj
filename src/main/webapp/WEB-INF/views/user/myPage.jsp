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

.eraseImg {
	position : absolute;
	right: 1px;
	color: black;
}

.validation {
	height:20px;
	font-size:14px; 
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
					<form action="chkPwForMdf" id="chkPwForMdf" method="post" style="display:none">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="form-group">
							<label for="curPw">Current password</label>
							<input type="password" class="form-control" id="curPw" name="crpw" autocomplete="off"/>
							<div class="form-group" style="visibility:hidden; color:red; font-size:14px;" id="curPwError">현재 비밀번호가 일치하지 않습니다.</div>
						</div>
						<input type="submit" value="확인" class="btn btn-sm btn-primary"/>
					</form>
					<form action="modifyPw" id="modifyPwForm" method="post" style="display:none">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="form-group">
							<label for="newPw">New password</label>
							<input type="password" class="form-control"  id="newPw" name="npw" autocomplete="off" maxlength="16"/>
							<div class="newPw-validation validation">
							</div>
						</div>
						<div class="form-group">
							<label for="cfrmPw">Confirm new password</label>
							<input type="password" class="form-control"  id="cfrmPw" name="cfpw" autocomplete="off" maxlength="16" readonly/>
							<div class="cfrmPw-validation validation">
							</div>
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
	
	<!-- 회원탈퇴시 모달 -->
	<!-- modal button -->
	<input id="resigModalBtn" type="hidden" class="btn" data-toggle="modal" data-target="#resigModal" value="modal">
	<!-- modal창 -->
	<div class="modal fade" id="resigModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WAYG</h4>
				</div>
				<div class="modal-body bg-light">
					<form action="chkPwForResig" id="chkPwForResig" method="post">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="form-group">
							<label for="resigPw">Password</label>
							<input type="password" class="form-control" id="resigPw" name="rgPw" autocomplete="off" required/>
							<div class="form-group" style="visibility:hidden; color:red; font-size:12px;" id="resigPwError">비밀번호가 일치하지 않습니다.</div>
						</div>
						<input type="submit" value="확인" class="btn btn-sm btn-primary"/>
					</form>
				</div>
				<div class="modal-footer bg-light">
					<button id="agreeResig" type="button" class="btn btn-default btn-danger" style="display:none">확인</button>
					<button id="resigCloseBtn" type="button" class="btn btn-default btn-success" data-dismiss="modal">Close</button>
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
						<a href="eraseImg" class="eraseImg"><i class="fa-solid fa-eraser"></i></a>
					</div>
				</c:when>
				<c:otherwise>
					<i class="user-info-icon fa-regular fa-circle-user" style="font-size:6rem; color: #112FE0;"></i>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="d-flex justify-content-center">
			<div id="userNick">${myPageInfo.userNick}</div>
			<input id="inputUserNick" type="text" value="${myPageInfo.userNick}" style="display:none; text-align:center;" onkeyup="checkNickName()" autocomplete="off" maxlength="20">
		</div>
		<div class="d-flex justify-content-center mt-1">
			<div class="userNick-validation validation" style="text-align:center;">
  			</div>
			<label for="prfImg" id="imgBtn" class="btn btn-sm btn-primary" >
				Profile Image
			</label>
		</div>
		<input type="file" class="form-control" id="prfImg" name="pImg" accept="image/*" onchange="clicksubmit()" style="display:none;">
		<button id="submitImg" type="submit" class="btn btn-primary" style="display:none;">submit</button>
	</form>
	<div class="form-group">
		<label for="userProfileMsg">BIO</label>
		<textarea class="form-control border border-dark" id="userProfileMsg" name="uPrfMsg" rows="5" maxlength="300" disabled>${myPageInfo.userProfileMsg}</textarea>
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
		<input type="text" class="form-control border border-dark" id="userAddr2" name="uAddr2" value= "${myPageInfo.userAddress2}" maxlength="50" disabled>
	</div>
	<div class="d-flex justify-content-center">
		<div>
			<button type="button" id="modifyInfo" class="btn btn-secondary">회원정보 수정</button>
			<button type="button" id="modified" class="btn btn-success" style="display:none">수정 완료</button>
			<button type="button" id="modifyPw" class="btn btn-secondary">비밀번호 변경</button>
			<button type="button" id="resigBtn" class="btn btn-danger">회원 탈퇴</button>
		</div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>

<script>
console.log('${fileName}');

//유효성 검사 통과유무 변수
var chkNick = true; //닉네임 input에 keyup이벤트 발생하지 않으면 true
var chkPw1 = false;
var chkPw2 = false;

//프로필사진 파일 등록시 자동 submit
function clicksubmit() {
	console.log("clicksubmit")
	document.getElementById("submitImg").click();
}

//nickname 유효성검사 및 중복 체크
function checkNickName() {
	var val = $('#inputUserNick').val();
	const regExp_nick = /^[가-힣|a-z|A-Z|0-9|]{2,20}$/; //닉네임 한글,영문,숫자 2자이상 20자이하 정규식
	const regExp_onlynum = /^[0-9]*$/; //숫자만 입력하는 정규식
	
	if("${myPageInfo.userNick}" !== val) { // 기존 닉네임이랑 같지 않을때만 
	if(regExp_onlynum.test(val) == false) { //숫자만으로 이루어지지 않았을때
		if(regExp_nick.test(val) == false) {
        	$('.userNick-validation').css('color', 'blue');
        	$('.userNick-validation').html('2자이상 20자이하로 입력해주세요.(영문,한글,숫자 사용가능. 숫자만X)');
			chkNick = false;
		} else {
			$.ajax({
				type : 'get',
				url : 'nickCheck',
				data : {nick:val},
				success : function(res){
					console.log('nickCheck');
					if(res != 1) {
			    		$('.userNick-validation').css('color', 'green');
			    		$('.userNick-validation').html('사용가능한 닉네임 입니다.');
			    		chkNick = true;
					} else {
						$('.userNick-validation').css('color', 'red');
			    		$('.userNick-validation').html('누군가 사용중인 닉네임 입니다.');
						chkNick = false;
					}
				},
				error:function(){
					alert("에러입니다.");
				}
			});
		}
		} else { //숫자만으로 이루어진 경우
        	$('.userNick-validation').css('color', 'blue');
        	$('.userNick-validation').html('2자이상 20자이하로 입력해주세요.(영문,한글,숫자 사용가능. 숫자만X)');
        	chkNick = false;
		}
	} else { //기존 닉네임이랑 같으면 validation 메세지 없애
		$('.userNick-validation').html('');
		chkNick = true;
	}
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
		$("#imgBtn").css("display","none");
		
	});
	
	//input type="text"가 form안에 들어있어서 엔터누르면 submit되기땜에 방지하기 위해
	$("#inputUserNick").keydown(function() {
	    if (event.keyCode === 13) {
	        event.preventDefault();
	    }
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
		} else if(!chkNick) {
			$("#inputUserNick").keyup().focus();
		} else {
			$.ajax({
				type:"GET",
				url : "modifyMyPage",
				data: allData,
				success:function(data){
					if(data.search("modified") > -1) {
						$(".modal-body").html("<h5>회원정보가 변경되었습니다.</h5>") //모달창 메세지
						$("#modalBtn").trigger("click");
						$('#myModal').on('hidden.bs.modal',function(e) { //모달 닫을때 이벤트
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
	
	//비밀번호 변경 버튼 클릭시 모달창 비밀번호입력 UI로 바뀜
	$("#modifyPw").click(function(){
		$("#chkPwForMdf").css("display","inline");
		$("#modalBtn").trigger("click");
	});
	
	//비밀번호 변경 버튼 -> 확인 버튼 클릭시
	$("#chkPwForMdf").submit(function(e){
		e.preventDefault();
		$.ajax({
			type : $("#chkPwForMdf").attr("method"),
			url : $("#chkPwForMdf").attr("action"),
			data : $("#chkPwForMdf").serialize(),
			success : function(data){
				if(data.search("Correct-pw") > -1) {
					$("#chkPwForMdf").css("display","none");
					$("#modifyPwForm").css("display","inline");
				} else {
					//비밀번호가 일치하지 않습니다. 보이게
					$("#curPwError").css("visibility","visible");
				}
			},
			error : function() {
				alert("비밀번호 확인 에러. 다시 시도해 주세요.");
			}
		});
	});
	
	//1차 비밀번호 유효성검사
    $('#newPw').keyup(function () {
    	$('#cfrmPw').val(''); //1차 pw input keyup시 2차 pw 입력값 초기화
    	$('.cfrmPw-validation').html(''); //1차 pw input keyup시 2차 pw validation 메세지 초기화
        var val = $('#newPw').val();
        const regExp_pw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&^])[A-Za-z\d$@$!%*#?&^]{8,}$/;

        if (regExp_pw.test(val) == false) {          
            $('.newPw-validation').css('color', 'blue');
            $('.newPw-validation').html('영문,숫자,특수문자를 혼합하여 8자 이상 16자 이하로 입력해주세요.');
            $('#cfrmPw').attr('readonly',true); //1차 pw 형식 안맞을시 2차 pw readonly true(입력불가)
            chkPw1 = false;
        } else {
            $('.newPw-validation').css('color', 'green');
            $('.newPw-validation').html('사용가능한 비밀번호 입니다.');
            $('#cfrmPw').attr('readonly',false); //1차 pw 형식 맞으면 2차 pw readonly false(입력가능)
            chkPw1 = true;
        }
    });
    
    //2차 비밀번호 유효성검사
    $('#cfrmPw').keyup(function () {
        var val = $('#newPw').val();
        var checkVal = $('#cfrmPw').val();
        if (checkVal!=''){ //2차 pw 입력값 없을땐 validation 메세지 아무것도 안뜸
			if (val != checkVal) {
            	$('.cfrmPw-validation').css('color', 'blue');
            	$('.cfrmPw-validation').html('동일한 비밀번호를 입력해주세요.');
            	chkPw2 = false;
        	} else {
            	$('.cfrmPw-validation').css('color', 'green');
            	$('.cfrmPw-validation').html('비밀번호가 일치합니다.');
       			chkPw2 = true;
        	}
        }
    });
	
	//비밀번호 변경 버튼 -> 확인 버튼 -> 비밀번호 변경 버튼 클릭시
	$("#modifyPwForm").submit(function(e){
		e.preventDefault();
		if(!chkPw1) {
			$("#newPw").keyup().focus();
		} else if(!chkPw2) {
			$("#cfrmPw").keyup().focus();
		} else {
		$.ajax({
			type : $("#modifyPwForm").attr("method"),
			url : $("#modifyPwForm").attr("action"),
			data : $("#modifyPwForm").serialize(),
			success : function(data) {
				if(data.search("pw-modified") > -1) {
					$(".modal-body").html("<h5>비밀번호가 변경되었습니다.</h5>")
					$('#myModal').on('hidden.bs.modal',function(e) { //모달 닫을때 이벤트
						location.reload();
					});
				}
				else { 
					alert("비밀번호 변경에 실패했습니다. 다시 시도해 주세요.");
				}
			},
			error : function() {
				alert("비밀번호 수정 에러. 다시 시도해 주세요.");
			}
		});
		}
	});
	
	//비밀번호변경 모달창 닫을시 모달창 초기화
	$('#myModal').on('hidden.bs.modal',function(e) {
		$("#curPwError").css("visibility","hidden");
		$("#curPw").val("");
		$("#modifyPwForm").css("display","none");
		$("#newPw").val("");
		$("#cfrmPw").val("");
		$("#cfrmPw").attr("readonly",true);
		$('.newPw-validation').html('');
		$('.cfrmPw-validation').html('');
	});
	
	//회원탈퇴 모달창 닫을시 모달창 초기화
	$('#resigModal').on('hidden.bs.modal',function(e) {
		$("#resigPwError").css("visibility","hidden");
		$("#resigPw").val("");
	});
	
	//회원탈퇴 버튼 클릭시 모달창 띄움
	$("#resigBtn").click(function(){
		$("#resigModalBtn").trigger("click");
	});
	
	//회원탈퇴 모달창안에 비밀번호 확인 버튼 누를시
	$("#chkPwForResig").submit(function(e){
		e.preventDefault();
		$.ajax({
			type : $("#chkPwForResig").attr("method"),
			url : $("#chkPwForResig").attr("action"),
			data : $("#chkPwForResig").serialize(),
			success: function(data) {
				if(data.search("Correct-pw") > -1) { //return값이 다른 return값에 포함되게 하면 안됨 (ex:correct-pw는 incorrect-pw에 포함됨)
					$(".modal-body").html("<h5>확인 버튼을 누르시면 모든 정보가 사라지며 다시 복구 할 수 없습니다.</h5>")
					$("#agreeResig").css("display","inline"); //회원탈퇴 최종 확인버튼 보이게
					$('#resigModal').on('hidden.bs.modal',function(e) { //모달 닫을때 이벤트
						location.reload();
					});
				} else {
					//비밀번호가 일치하지 않습니다. 보이게
					$("#resigPwError").css("visibility","visible");
				}
			},
			error: function() {
				alert("비밀번호 확인 에러. 다시 시도해 주세요.");
			}
		});
	});
	
	//회원탈퇴 최종 확인버튼 클릭시
	$("#agreeResig").click(function(e){
		location.href = "resignation";
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
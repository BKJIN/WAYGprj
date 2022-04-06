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
<link rel="stylesheet" type="text/css" href="css/includes/header.css" />
<link rel="stylesheet" type="text/css" href="css/search/searchResult.css" />
<link rel="stylesheet" type="text/css" href="css/includes/footer.css" />
<title>Search Result</title>
</head>

<body>
<%@ include file="../includes/header.jsp" %>

<section class="container mb-4">
	<input type="hidden" id="modalBtn" data-toggle="modal" data-target="#myModal" value="modal" />

	<div class="result_posts">
		<div class="posts d-flex flex-wrap justify-content-start mt-2">
			<c:forEach begin="1" end="20" var="i">
				<div class="post mr-2">
					<div class="post-top border rounded">
						<img src="images/5.jpg" alt="test"/>
					</div>
					<div class="post-bottom border">${ i}</div>
				</div>
			</c:forEach>
		</div>
	</div>

</section>

<%@ include file="../includes/post_details.jsp" %>
<%@ include file="../includes/footer.jsp" %>

<script>

$(document).ready(function() {
	// 포스트 이미지 클릭시 모달창 생성
	$('.post').click(function() {
		console.log($(this).text());
		$('#modalBtn').trigger('click');
	})
});

</script>
</body>
</html>
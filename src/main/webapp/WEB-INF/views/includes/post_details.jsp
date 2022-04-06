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
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/includes/post_details.css" />
</head>
<body>
<!-- modal button -->
<input type="hidden" id="modalBtn" data-toggle="modal" data-target="#myModal" value="modal" />

<!-- modal 창 -->
<div class="modal fade" id="myModal" role="dialog">
	<div class="modal-dialog modal-dialog-centered modal-xl d-block">
		<button type="button" id="modalCloseBtn" class="btn btn-lg btn-default text-white text-weight-bold display-1 float-right" data-dismiss="modal">&times;</button>
		<div class="modal-content">
			<div class="modal-body bg-light d-flex justify-content-between">
				<div class="post-img border rounded mr-2"><i class="modal-icon fa-regular fa-images"></i></div>
				<ul class="list-group d-block">
					<li class="list-group-item mb-1"><i class="modal-icon fa-regular fa-circle-user"></i></li>
					<li class="list-group-item mb-1"><i class="modal-icon fa-regular fa-rectangle-list"></i></li>
					<li class="list-group-item mb-1 d-flex row mx-0">
						<div class="col-6"><i class="modal-icon fa-regular fa-heart"></i></div>
						<div class="col-3"><i class="modal-icon fa-regular fa-bookmark"></i></div>
						<div class="col-3"><i class="modal-icon fa-regular fa-comment-dots"></i></div>
					</li>
					<li class="list-group-item"><i class="modal-icon fa-regular fa-comment-dots"></i></li>
				</ul>
			</div>
		</div>
	</div>
</div>

</body>
</html>
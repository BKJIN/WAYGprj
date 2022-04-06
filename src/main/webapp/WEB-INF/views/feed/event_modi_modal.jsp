<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
</head>
<body>
	
	<!-- modal 창 -->
	<div class="modal fade" id="myModal2" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-xl d-block">
			<button type="button" id="modalCloseBtn" class="btn btn-xl btn-default text-white text-weight-bold display-1 float-right" data-dismiss="modal">&times;</button>
			<div class="modal-content">
				<div class="modal-header bg-light d-flex justify-content-start">
					<h4 id="plan-name" class="modal-title display-4"></h4>
				</div>
				
				<div class="modal-body bg-light d-flex justify-content-center">
					<div id="map-container" class="d-block">
						<div id="map" class="border rounded bg-warning mb-2 text-white text-weight-bold">
							KAKAO MAP
						</div>
						<div id="locations" class="border rounded bg-light overflow-auto">
							<ul id="locations-list" class="list-group">
								
								<c:forEach begin="0" end="5">								
									<li class="list-group-item row d-flex mx-0 px-1 text-center ">
										<div class="location-name border col-7 overflow-hidden ml-1 mr-1 px-1 pt-1">location name</div>
										<div class="location-likes col-2 mr-1 px-1 pt-1"><i class="fa-solid fa-heart text-danger"></i> 425</div>
										
										<button type="button" class="btn btn-default">										
											<i class="fa-solid fa-circle-plus text-success"></i>
										</button>
	
										<button type="button" class="btn btn-default">
											<i class="fa-solid fa-circle-minus text-danger"></i>
										</button>
									</li>
								</c:forEach>
							</ul>
						</div>
					</div>

					<div id="plan_container" class="ml-2 px-1 overflow-auto">
						<c:forEach begin="0" end="5">
							<div class="time_box border rounded d-flex justify-content-around pt-1 my-1">
								<div class="form-group">
									<label for="start">장소</label>
									<input type="text" class="form-control" name="location" readonly />
								</div>
								
								<div class="form-group">
									<label for="start">시작시간</label>
									<input type="time" class="form-control" name="start" step="1800"/>
								</div>
														
								<div class="form-group">
									<label for="end">종료시간</label>
									<input type="time" class="form-control" name="end" />
								</div>
								<div class="d-block">
									<button type="button" class="del-btn btn btn-default"><i class="fa-solid fa-rectangle-xmark text-danger"></i></button>
								</div>
							</div>
						</c:forEach>
					</div>
					
					
					
				</div>
				<div class="modal-footer bg-light mb-2"></div>
			</div>
		</div>
	</div>

</body>
</html>
$(document).ready(function() {
	/* ---------------------------- Feed Calendar Page Init ---------------------------- */
	
	// fullcalendar load
	var Calendar = FullCalendar.Calendar;
		
	// calendar를 보여줄 domElement
	var calendarEl = document.getElementById('calendar');

	// dateclick에서 쓰일 count 변수
	var count = 0;
	
	// calendar 초기 세팅
	var calendar = new Calendar(calendarEl, {
		
		// 국가 설정
		locale: 'ko',
		
		// 헤더 툴바 설정
		headerToolbar: {
	    	left: 'prev', // 왼쪽 (한달 전, 한달 후, 오늘로 이동 버튼)
	    	center: 'title', // 가운데 (년 월 표시)
	    	right: 'today,next' // 오른쪽 (월단위 지도, 주단위 지도, 일단위 지도)
	  	},

		// 월별 달력 생성
	  	initialView: 'dayGridMonth',

		// 달력 날짜 클릭시 내용
		dateClick: function(info) {
			//클릭이 일어나면 count++
			count++;
			
			if ( count == 1 ) {
				// 첫번째 클릭시 startDate로 입력
				$('#startDate').val(info.dateStr);
				
			} else {
				// 두번째 클릭시 endDate로 입력
				$('#endDate').val(info.dateStr);
				
				// 클릭 카운트를 0으로 초기화
				count = 0;
			}
		},

		// 생성되어있는 event를 클릭했을 때 내용 (수정 or 삭제 modal 창에서 처리)
		eventClick: function(info) {
			// event 블럭을 클릭하면 endDate를 캘린더에 표시된 날짜로 출력 (endDate.date - 1)
			let yyyymm = info.event.endStr.substr(0, 8);
			let dd = Number(info.event.endStr.substr(8, 2) - 1);
			
			// date가 0보다 작으면 한 자리수로 나오므로 포맷에 맞게 2자리 수로 변경
			if ( dd < 10 ) {
				dd = "0" + dd
			}
			
			// 실제 표시될 eventEndDate를 생성
			let eventEndDate = yyyymm + dd;
			
	    	// modal창을 띄우고 수정할 내용을 각 input value에 뿌려줌
	    	$('#modalBtn2').trigger('click');
			$('.modal-body form #planNum').val(info.event.id);
    		$('.modal-body form .form-group #planName').val(info.event.title);
    		$('.modal-body form .form-group #startDate').val(info.event.startStr);
    		$('.modal-body form .form-group #endDate').val(eventEndDate);
		}
	});

	// calender를 불러옴
	calendar.render();	
	// getAllPlans 메서드 호출
	getAllPlans();

	
	// 일정 생성(Create 버튼 눌렀을 때)
	$('#submit').click(function(e) {

		// 각각의 form에 입력된 값을 변수에 저장
		var frm = $('#frm');
		var planName = $('#planName').val();
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		
		// 1st Validation : input null check
		if( planName == "" ) {
			alert('일정 이름을 입력해주세요.');
			return false;
		} else if( startDate =="" || endDate =="" ) {
			alert('일자를 선택해주세요.');
			return false;
			
		// 2nd Validation : 종료일자가 시작일자보다 빠르면 폼을 reset 시키고 submit 되지 않게 함.
		} else if ( startDate > endDate ) {
			alert("종료일자가 시작일자보다 빠를 수 없습니다.");
			$('.mp_btn #reset').trigger('click');
			return false;
		}
		
		// 3rd Validation : 선택한 일정이 맞는지 다시 한 번 체크
		if( confirm('선택한 일자로 일정을 만들까요?') == true ) {
			frm.submit();
		};
		
	})
	
	// eventclick 하여 modal창의 버튼을 눌렀을 때
	$('#modify_form .btn').click(function(e) {
		e.preventDefault();

		// 클릭된 버튼을 변수로 저장
		let eventBtn = $(this);
	
		// 각각의 input value를 변수로 저장
		let planNum = $('#modify_form #planNum').val();
		let planName = $('#modify_form .form-group #planName').val();
		let startDate = $('#modify_form .form-group #startDate').val();
		let endDate = $('#modify_form .form-group #endDate').val();
		
		// 클릭된 버튼의 id가 btn-modify일 때(수정 버튼)
		if ( eventBtn.attr('id') == 'btn-modify' ) {
			
			// 수정 메서드 실행
			modifyPlan(planNum, planName, startDate, endDate);

		// 클릭된 버튼의 id가 btn-modify이 아닐 때(삭제 버튼)
		} else {
			// confirm창에서 확인을 눌렀을 때
			if ( confirm("일정을 삭제할까요?") ) {
				// 삭제 메서드 실행
				deletePlan(planNum);

			// confirm창에서 취소가 눌렀을 때
			} else {
				return false;
			}
		}		
	})
	
	
	
	
	
	/* ---------------------------- Feed Calendar Page Use Method ---------------------------- */
	
	// DB에 저장된 일정 불러와 달력에 표시하는 메서드
	function getAllPlans()  {
		$.ajax({
	 			url : "feed/getAllPlans.do" ,
	 			type : "post",
				// security page에서 ajax시 _csrf.token, _csrf.header를 싣어서 보내야함
	 		    beforeSend: function(xhr){
		 		   	var token = $("meta[name='_csrf']").attr('content');
		 			var header = $("meta[name='_csrf_header']").attr('content');
	 		        xhr.setRequestHeader(header, token);
	 		    },
	 			success : function(data) {
	 				// arraylist를 json으로 변환한 데이터를 하나씩 꺼내와서 calendar에 event로 추가
	 				for (var i = 0; i < data.length; i++ ) {
	 					calendar.addEvent({
							// event가 가지고 있는 id라는 변수에 planNum 추가
							id: data[i].planNum,
	 						title : data[i].planName,
	 						start : data[i].startDate,
	 						end : data[i].endDate
	 					})
	 				}		
	 			},
	 			error : function(data) {
	 				console.log(data);
	 				alert('오류');
	 			}
	 		})
	};
	
	
	// 새로운 일정을 생성하는 메서드
	function insertPlan(planName, startDate, endDate) {
		// 1st Validation : input null check
		if( planName == "" ) {
			alert('일정 이름을 입력해주세요.');
			return false;
		} else if( startDate =="" || endDate =="" ) {
			alert('일자를 선택해주세요.');
			return false;
			
		// 2nd Validation : 종료일자가 시작일자보다 빠르면 폼을 reset 시키고 submit 되지 않게 함.
		} else if ( startDate > endDate ) {
			alert("종료일자가 시작일자보다 빠를 수 없습니다.");
			$('.mp_btn #reset').trigger('click');
			return false;
		}
		
		// 3rd Validation : 선택한 일정이 맞는지 다시 한 번 체크
		if( confirm('선택한 일자로 일정을 만들까요?') == true ) {

			// 실제 db에는 calendar allday 속성에 따라 실제 종료일자보다 + 1된 날짜로 들어가야 제대로 된 이벤트 블럭이 생성됨.
			let yyyymm = endDate.substr(0, 8);
			let dd = Number(endDate.substr(8, 2)) + 1;

			if ( dd < 10 ) {
				dd = "0" + dd
			}

			let realEndDate = yyyymm + dd;
			
			// 선택한 값을 json 형태 자료로 생성
			let json = {
					planName : planName,
					startDate : startDate,
					endDate : realEndDate
			};
		
			// ajax로 json 객체를 controller로 보내서 db 추가
			$.ajax({
				url : 'feed/insertPlan.do',
				type : 'post',
				// ajax로 보내는 데이터 타입
				contentType : 'application/json; charset=UTF-8',
				// json형태의 string 변수를 실제 json 타입 데이터로 변환
				data : JSON.stringify(json),
				// security _csrf 처리
	 		    beforeSend: function(xhr){
		 		   	var token = $("meta[name='_csrf']").attr('content');
		 			var header = $("meta[name='_csrf_header']").attr('content');
	 		        xhr.setRequestHeader(header, token);
	 		    },
				success : function(data) {
					console.log(data);
					// calendar의 모든 이벤트를 제거한 후 다시 db에서 불러오기
					calendar.removeAllEvents();
					getAllPlans();
				},
				error: function() {
					console.log('오류');
				}
			});
		// confirm창에서 취소를 눌렀을 때
		} else {
			return false;
		}
	}
	
	
	// 일정을 수정하는 메서드
	function modifyPlan(planNum, planName, startDate, endDate) {
			// 1st Validation : input null check
			if( planName == "" ) {
				alert('일정 이름을 입력해주세요.');
				return false;
				
			} else if( startDate =="" || endDate =="" ) {
				alert('일자를 선택해주세요.');
				return false;
				
			// 2nd Validation : 종료일자가 시작일자보다 빠르면 폼을 reset 시키고 submit 되지 않게 함.
			} else if ( startDate > endDate ) {
				alert("종료일자가 시작일자보다 빠를 수 없습니다.");
				$('.mp_btn #reset').trigger('click');
				return false;
			}
			
			// 실제 db에 들어갈 endDateSetting		
			let yyyymm = endDate.substr(0, 8);
			let dd = Number(endDate.substr(8, 2)) + 1;
			if ( dd < 10 ) {
				dd = "0" + dd
			}
			let realEndDate = yyyymm + dd;
			
			// 수정 요청하는 event value를 json형태 문자열 변수로 저장
			let m_plan = {
							planNum : planNum,
							planName : planName,
							startDate : startDate,
							endDate : realEndDate
						};
			
			// 수정 요청 ajax
			$.ajax({
				url : "feed/modify_plan.do",
				type : "post",
				// json형태의 string 변수를 실제 json 타입 데이터로 변환
				data : JSON.stringify(m_plan),
				// ajax로 보내는 데이터 타입
				contentType : 'application/json; charset=UTF-8',
				// security _csrf 처리
				beforeSend: function(xhr){
		 		   	var token = $("meta[name='_csrf']").attr('content');
		 			var header = $("meta[name='_csrf_header']").attr('content');
	 		        xhr.setRequestHeader(header, token);
	 		    },
				success : function(data) {
					if (data == "success") {
						// modal closeBtn을 자동으로 눌러줌
						$("#modalCloseBtn").trigger("click");
						// calendar의 모든 이벤트를 제거한 후 다시 db에서 불러오기
						calendar.removeAllEvents();
						getAllPlans();
					} else {
						alert("잘못된 값이 입력되었습니다.");
						return false;
					}
				},
				error: function() {
					console.log('오류');
				}
			})
	}
	
	
	// 일정을 삭제하는 메서드
	function deletePlan(planNum) {
		// 삭제 ajax
		$.ajax({
			url : "feed/delete_plan.do",
			method: "post",
			data : planNum,
			// ajax로 보내는 데이터 타입
			contentType : 'application/text; charset=UTF-8',
			// security _csrf 처리
			beforeSend: function(xhr){
	 		   	var token = $("meta[name='_csrf']").attr('content');
	 			var header = $("meta[name='_csrf_header']").attr('content');
 		        xhr.setRequestHeader(header, token);
 		    },
			success : function(data) {
				if (data == "success") {
					// modal closeBtn을 자동으로 눌러줌
					$("#modalCloseBtn").trigger("click");
					
					// calendar의 모든 이벤트를 제거한 후 다시 db에서 불러오기
					calendar.removeAllEvents();
					getAllPlans();
				} else {
					alert("삭제에 실패했습니다.");
					return false;
				}
			},
			error: function() {
				console.log('오류');
			}
		});
	}
	

});					
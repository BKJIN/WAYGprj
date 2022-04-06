package com.project.init;

import java.util.Calendar;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml")
@Transactional
public class JoinDaoTest {
	
	String UBirth = "19900210";
	
	@Test
	public void getAgeByBirthDay(String UBirth) {
		//년,월,일 자르기
		int bir_year = Integer.parseInt(UBirth.substring(0,4));
		int bir_month = Integer.parseInt(UBirth.substring(4,6));
		int bir_day = Integer.parseInt(UBirth.substring(6));
		//현재년,월,일 get		
		Calendar current = Calendar.getInstance();
		int cur_year = current.get(Calendar.YEAR);
		int cur_month = current.get(Calendar.MONTH);
		int cur_day = current.get(Calendar.DAY_OF_MONTH);
		int age = cur_year - bir_year;
		//만나이
		if(bir_month*100+bir_day>cur_month*100+cur_day) {
			age--;
		}
		System.out.println(age);
		
	}
}

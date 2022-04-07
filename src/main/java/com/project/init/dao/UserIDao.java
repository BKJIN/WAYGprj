package com.project.init.dao;

import com.project.init.dto.UserDto;

public interface UserIDao {
	
	public int emailCheck(String id);
	
	public int nickCheck(String nick);
	
	public String join(String UEmail, String UPw, String UNickName, String UBirth, String UGender, String UPst, String UAddr1, String UAddr2);
	
	public UserDto login(String uId);
	
	public void userVisit(String uId);
	
	public UserDto myPage(String uId);
	
	public String addPrfImg(UserDto udto);
	
	public String mdfMyPage(UserDto udto);
	
	public String pwcheck(String uId);
	
	public String modifyPw(String Npw, String uId);
	
	public void resign(String uId);
	
	public String getolduPrfImg(String uId);
	
	public void deletePrfImg(String uId);
}

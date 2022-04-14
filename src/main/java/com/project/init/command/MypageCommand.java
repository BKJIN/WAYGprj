package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;

import com.project.init.dao.UserDao;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

public class MypageCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		UserDao udao = Constant.udao;
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		UserDto dto = udao.myPage(uId);
		String uPrfImg = dto.getUserProfileImg();
		model.addAttribute("myPageInfo",dto);
		model.addAttribute("fileName",uPrfImg);
		
	}

}

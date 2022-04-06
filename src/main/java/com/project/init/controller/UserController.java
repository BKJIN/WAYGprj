package com.project.init.controller;

import java.io.File;
import java.util.Collection;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.project.init.command.AddPrfImgCommand;
import com.project.init.command.ICommand;
import com.project.init.command.JoinCommand;
import com.project.init.command.MypageCommand;
import com.project.init.dao.UserDao;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

@Controller
//@RequestMapping("/user")
public class UserController {
	
	private UserDao udao;
	@Autowired
	public void setUdao(UserDao udao) {
		this.udao = udao;
		Constant.udao = udao;
	}
	
	BCryptPasswordEncoder passwordEncoder;
	@Autowired
	public void setPasswordEncoder(BCryptPasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
		Constant.passwordEncoder = passwordEncoder;
	}
	
	private ICommand mcom;
	
	@RequestMapping("/user/join_view")
	public String join() {
		return "user/join_view";
	}
	
	@RequestMapping(value = "/user/join", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("join");
		mcom = new JoinCommand();
		mcom.execute(request, model);
		String result = (String) request.getAttribute("result");
		System.out.println(result);
		if(result.equals("success"))
			return "join-success";
		else
			return "join-failed";
	}
	
	@RequestMapping(value="/user/emailCheck") //왜 포스트 방식은 안돼?
	@ResponseBody
	public int emailCheck(@RequestParam("id") String id) {
		System.out.println("emailCheck");
		System.out.println(id);
		int res = udao.emailCheck(id);
		System.out.println(res);
		return res;
	}
	
	@RequestMapping(value="/user/nickCheck")
	@ResponseBody
	public int nickCheck(@RequestParam("nick") String nick) {
		System.out.println("nickCheck");
		System.out.println(nick);
		int res = udao.nickCheck(nick);
		System.out.println(res);
		return res;
	}
	
//	@RequestMapping(value="/processLogin", method = RequestMethod.GET)
//	public ModelAndView processLogin(
//			@RequestParam(value = "error", required = false) String error) {
//		System.out.println("processLogin");
//		ModelAndView model = new ModelAndView();
//		if(error != null && error !="" ) { //로그인시 에러발생하면 security에서 요청(값은 1)
//			model.addObject("error", "아이디와 비밀번호를 다시 확인해주세요.");
//			System.out.println(error);
//		}
//		model.setViewName("index");
//		return model;
//	}
	
	@RequestMapping(value="/processLogin")
	public String processLogin(@RequestParam(value="error") String error,Model model) {
		System.out.println("processLogin");
		if(error != null && error !="") {
			model.addAttribute("error", "아이디와 비밀번호를 다시 확인해주세요.");
			System.out.println(error);
		}
		return "/index";
	}
	
	//로그인 성공시
	@RequestMapping(value="/loginSuc")
	public String loginSuc(Authentication authentication) {
		System.out.println("loginSuc");
		UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		Constant.username = userDetails.getUsername();
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String auth = authorities.toString(); //role을 얻어서 문자열로 변환
		System.out.println(auth); //[ROLE_USER] 형태
		udao.userVisit(Constant.username); //로그인 날짜 업데이트
		return "/index";
	}
	
	@RequestMapping(value="/user/myPage")
	public String myPage(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("/user/myPage");
		mcom = new MypageCommand();
		mcom.execute(request, model);
		return "/user/myPage";
	}
	
	@RequestMapping("/user/add_PrfImg")
	public String add_PrfImg(MultipartHttpServletRequest mtpRequest, HttpServletRequest request, Model model) {
		System.out.println("add_PrfImg");
		String uPrfImg = null; //DB저장용 파일명
		
		MultipartFile mf = mtpRequest.getFile("pImg");
		String path = "C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/";
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/profileImg/";
		String originFileName = mf.getOriginalFilename();
		long prename = System.currentTimeMillis();
		long fileSize = mf.getSize();
		System.out.println("originFileName : " + originFileName);
		System.out.println("fileSize : " + fileSize);
		
		String safeFile = path + prename + originFileName;
		String safeFile1 = path1 + prename + originFileName;
		
		uPrfImg = prename + originFileName;
		
		UserDto udto = new UserDto(Constant.username,null,null,null,0,null,0,null,uPrfImg,null,null,null,null,null,null,null);
		mtpRequest.setAttribute("udto", udto);
		mcom = new AddPrfImgCommand();
		
		mcom.execute(mtpRequest, model);
		
		Map<String, Object> map = model.asMap();
		String res = (String) map.get("result");
		
		if(res.equals("success")) {
			try {
				mf.transferTo(new File(safeFile));
				mf.transferTo(new File(safeFile1));
			}
			catch(Exception e) {
				e.getMessage();
			}
			model.addAttribute("fileName", uPrfImg);
//			request.setAttribute("path", path);
//			request.setAttribute("path1", path1);
//			request.setAttribute("uPrfImg", uPrfImg);
			return "/user/myPage";
			//return "redirect:/user/myPage";
		}
		else {
			return "/user/myPage";
		}
		
		
		
		
	}

}

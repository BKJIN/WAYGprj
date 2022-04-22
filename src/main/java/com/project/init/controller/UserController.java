package com.project.init.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
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
import com.project.init.command.MdfMyPageCommand;
import com.project.init.command.ModifyPwCommand;
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
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException{
		System.out.println("join");
		mcom = new JoinCommand();
		long prename = System.currentTimeMillis();
		// 1. 원본 File, 복사할 File 준비
		File imgFile = new File("C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/circle-user-regular.svg");
		String basicImg = prename + "circle-user-regular.svg";
		File newImgFile = new File("C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/"+basicImg);
		// 2. 복사
		Files.copy(imgFile.toPath(), newImgFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
		model.addAttribute("basicImg", basicImg);
		mcom.execute(request, model);
		String result = (String) request.getAttribute("result");
		System.out.println(result);
		if(result.equals("success"))
			return "join-success";
		else
			return "join-failed";
	}
	
	//회원가입시 이메일 중복체크
	@RequestMapping(value="/user/emailCheck") //왜 포스트 방식은 안돼?
	@ResponseBody
	public int emailCheck(@RequestParam("id") String id) {
		System.out.println("emailCheck");
		System.out.println(id);
		int res = udao.emailCheck(id);
		System.out.println(res);
		return res;
	}
	
	//회원가입시 닉네임 중복체크
	@RequestMapping(value="/user/nickCheck")
	@ResponseBody
	public int nickCheck(@RequestParam("nick") String nick) {
		System.out.println("nickCheck");
		System.out.println(nick);
		int res = udao.nickCheck(nick);
		System.out.println(res);
		return res;
	}
		
	//로그인 실패 및 로그아웃시
	@RequestMapping(value="/processLogin")
	public String processLogin(@RequestParam(value="error", required = false) String error, @RequestParam(value="logout", required = false) String logout, Model model) {
		System.out.println("processLogin");
		if(error != null && error !="") {
			model.addAttribute("error", "아이디와 비밀번호를 다시 확인해주세요.");
			System.out.println(error);
		}
		
		if(logout != null && logout != "") {
			Constant.username = "";
			System.out.println("logged out");
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
		Authentication authentication1 = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication1.getPrincipal();
		udao.userVisit(user.getUsername()); //로그인 날짜 업데이트
		return "/index";
	}
	
	@RequestMapping(value="/user/myPage")
	public String myPage(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("/user/myPage");
		mcom = new MypageCommand();
		mcom.execute(request, model);
		return "/user/myPage";
	}
	
	//프로필사진 등록
	@RequestMapping("/user/add_PrfImg")
	public String add_PrfImg(MultipartHttpServletRequest mtpRequest, HttpServletRequest request, Model model) {
		System.out.println("add_PrfImg");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String olduPrfImg = udao.getolduPrfImg(user.getUsername()); //이미 DB에 저장돼있는 이미지사진 이름 가져오기
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
		UserDto udto = new UserDto(user.getUsername(),null,null,null,0,null,0,null,uPrfImg,null,null,null,null,null,null,null);
		mtpRequest.setAttribute("udto", udto);
		mcom = new AddPrfImgCommand();
		
		mcom.execute(mtpRequest, model);
		
		Map<String, Object> map = model.asMap();
		String res = (String) map.get("result");
		
		if(res.equals("success")) {
			try {
				mf.transferTo(new File(safeFile));
				mf.transferTo(new File(safeFile1));
				
				//기존 저장돼있던 사진 삭제
				if(!olduPrfImg.equals("circle-user-regular.svg")) {
					File file = new File(path + olduPrfImg);
					File file1 = new File(path1 + olduPrfImg);
					if(file.exists()) {
						file.delete();
					}
					if(file1.exists()) {
						file1.delete();
					}
				}
			}
			catch(Exception e) {
				e.getMessage();
			}
			return "redirect:/user/myPage";
		}
		else {
			return "redirect:/user/myPage";
		}
	}
	
	@RequestMapping("/user/eraseImg")
	public String eraseImg() throws IOException {
		System.out.println("eraseImg");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String olduPrfImg = udao.getolduPrfImg(user.getUsername());
		
		long prename = System.currentTimeMillis();
		// 1. 원본 File, 복사할 File 준비
		File imgFile = new File("C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/circle-user-regular.svg");
		String basicImg = prename + "circle-user-regular.svg";
		File newImgFile = new File("C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/"+basicImg);
		// 2. 복사
		Files.copy(imgFile.toPath(), newImgFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

		File imgFile1 = new File("C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/"+basicImg);
		File newImgFile1 = new File("C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/profileImg/"+basicImg);
		
		Files.copy(imgFile1.toPath(), newImgFile1.toPath(), StandardCopyOption.REPLACE_EXISTING);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("uId", user.getUsername());
		map.put("basicImg", basicImg);
		udao.deletePrfImg(map);
		
		//기존 저장돼있던 사진 삭제
		String path = "C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/";
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/profileImg/";
		File file = new File(path + olduPrfImg);
		File file1 = new File(path1 + olduPrfImg);
		if(file.exists()) {
			file.delete();
		}
		if(file1.exists()) {
			file1.delete();
		}
		
		return "redirect:/user/myPage";
	}
	
	//마이페이지 수정
	@RequestMapping("/user/modifyMyPage")
	@ResponseBody
	public String modifyMyPage(@RequestParam(value="userNick") String userNick, @RequestParam(value="userBio") String userProfileMsg, @RequestParam(value="userPst") String userPst, @RequestParam(value="userAddr1") String userAddress1, @RequestParam(value="userAddr2") String userAddress2, HttpServletRequest request, Model model) {
		System.out.println("modifyMyPage");
		int UserPst = Integer.parseInt(userPst);
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		UserDto udto = new UserDto(user.getUsername(), null, userNick, null, 0, null, UserPst, userAddress1, null, userProfileMsg, null, null, null, null, null, userAddress2);
		request.setAttribute("udto", udto);
		mcom = new MdfMyPageCommand();
		mcom.execute(request, model);
		String result = (String) request.getAttribute("result");
		System.out.println(result);
		if(result.equals("success"))
			return "modified";
		else
			return "not-modified";
	}
	
	//비밀번호 변경 전 비밀번호 확인
	@RequestMapping(value="/user/chkPwForMdf", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String chkPwForMdf(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("chkPwForMdf");
		String Crpw = request.getParameter("crpw");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String upw = udao.pwcheck(user.getUsername());
		passwordEncoder = new BCryptPasswordEncoder();
		if(passwordEncoder.matches(Crpw, upw)) {
			return "Correct-pw";
		} else {
			return "Incorrect-pw";
		}
			
	}
	
	//비밀번호 변경
	@RequestMapping(value="/user/modifyPw", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String modifyPw(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("modifyPw");
			mcom = new ModifyPwCommand();
			mcom.execute(request, model);
			String result = (String) request.getAttribute("result");
			System.out.println(result);
			if(result.equals("success"))
				return "pw-modified";
			else
				return "pw-not-modified";
	}
	
	//회원탈퇴시 비밀번호 확인
	@RequestMapping(value="/user/chkPwForResig", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String chkPwForResig(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("chkPwForResig");
		String RgPw = request.getParameter("rgPw");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String upw = udao.pwcheck(user.getUsername());
		passwordEncoder = new BCryptPasswordEncoder();
		if(passwordEncoder.matches(RgPw, upw)) {
			return "Correct-pw";
		} else {
			return "Incorrect-pw";
		}
		
	}
	
	//회원탈퇴
	@RequestMapping(value="/user/resignation")
	public String resignation() {
		System.out.println("resignation");
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		udao.resign(user.getUsername());
		SecurityContextHolder.clearContext(); //회원탈퇴시 로그아웃 위해
		return "redirect:/";
	}

}

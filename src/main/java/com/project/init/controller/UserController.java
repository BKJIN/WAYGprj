package com.project.init.controller;

import java.io.File;
import java.util.Collection;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
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
	
	//ȸ�����Խ� �̸��� �ߺ�üũ
	@RequestMapping(value="/user/emailCheck") //�� ����Ʈ ����� �ȵ�?
	@ResponseBody
	public int emailCheck(@RequestParam("id") String id) {
		System.out.println("emailCheck");
		System.out.println(id);
		int res = udao.emailCheck(id);
		System.out.println(res);
		return res;
	}
	
	//ȸ�����Խ� �г��� �ߺ�üũ
	@RequestMapping(value="/user/nickCheck")
	@ResponseBody
	public int nickCheck(@RequestParam("nick") String nick) {
		System.out.println("nickCheck");
		System.out.println(nick);
		int res = udao.nickCheck(nick);
		System.out.println(res);
		return res;
	}
		
	//�α��� ���� �� �α׾ƿ���
	@RequestMapping(value="/processLogin")
	public String processLogin(@RequestParam(value="error", required = false) String error, @RequestParam(value="logout", required = false) String logout, Model model) {
		System.out.println("processLogin");
		if(error != null && error !="") {
			model.addAttribute("error", "���̵�� ��й�ȣ�� �ٽ� Ȯ�����ּ���.");
			System.out.println(error);
		}
		
		if(logout != null && logout != "") {
			Constant.username = "";
			System.out.println("logged out");
		}
		return "/index";
	}
	
	//�α��� ������
	@RequestMapping(value="/loginSuc")
	public String loginSuc(Authentication authentication) {
		System.out.println("loginSuc");
		UserDetails userDetails = (UserDetails) authentication.getPrincipal();
		Constant.username = userDetails.getUsername();
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String auth = authorities.toString(); //role�� �� ���ڿ��� ��ȯ
		System.out.println(auth); //[ROLE_USER] ����
		udao.userVisit(Constant.username); //�α��� ��¥ ������Ʈ
		return "/index";
	}
	
	@RequestMapping(value="/user/myPage")
	public String myPage(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("/user/myPage");
		mcom = new MypageCommand();
		mcom.execute(request, model);
		return "/user/myPage";
	}
	
	//�����ʻ��� ���
	@RequestMapping("/user/add_PrfImg")
	public String add_PrfImg(MultipartHttpServletRequest mtpRequest, HttpServletRequest request, Model model) {
		System.out.println("add_PrfImg");
		String olduPrfImg = udao.getolduPrfImg(Constant.username); //�̹� DB�� ������ִ� �̹������� �̸� ��������
		String uPrfImg = null; //DB����� ���ϸ�
		
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
				
				//���� ������ִ� ���� ����
				File file = new File(path + olduPrfImg);
				File file1 = new File(path1 + olduPrfImg);
				if(file.exists()) {
					file.delete();
				}
				if(file1.exists()) {
					file1.delete();
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
	public String eraseImg() {
		System.out.println("eraseImg");
		String olduPrfImg = udao.getolduPrfImg(Constant.username);
		udao.deletePrfImg(Constant.username);
		
		//���� ������ִ� ���� ����
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
	
	//���������� ����
	@RequestMapping("/user/modifyMyPage")
	@ResponseBody
	public String modifyMyPage(@RequestParam(value="userNick") String userNick, @RequestParam(value="userBio") String userProfileMsg, @RequestParam(value="userPst") String userPst, @RequestParam(value="userAddr1") String userAddress1, @RequestParam(value="userAddr2") String userAddress2, HttpServletRequest request, Model model) {
		System.out.println("modifyMyPage");
		int UserPst = Integer.parseInt(userPst);
		UserDto udto = new UserDto(Constant.username, null, userNick, null, 0, null, UserPst, userAddress1, null, userProfileMsg, null, null, null, null, null, userAddress2);
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
	
	//��й�ȣ ����
	@RequestMapping(value="/user/modifyPw", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String modifyPw(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("modifyPw");
		String Crpw = request.getParameter("crpw"); //form���� ���� pw
		String upw = udao.pwcheck(Constant.username); //��ȣȭ�� pw
		passwordEncoder = new BCryptPasswordEncoder(); 
		if(passwordEncoder.matches(Crpw, upw)) { //form���� ���� pw�� ��ȣȭ�� pw ��
			mcom = new ModifyPwCommand();
			mcom.execute(request, model);
			String result = (String) request.getAttribute("result");
			System.out.println(result);
			if(result.equals("success"))
				return "pw-modified";
			else
				return "pw-not-modified";
		} else {
			return "curPwDoesNotMatch";
		}
		
	}
	
	//ȸ��Ż��� ��й�ȣ Ȯ��
	@RequestMapping(value="/user/chkPwForResig", method=RequestMethod.POST, produces = "application/text; charset=UTF8")
	@ResponseBody
	public String chkPwForResig(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("chkPwForResig");
		String RgPw = request.getParameter("rgPw");
		String upw = udao.pwcheck(Constant.username);
		passwordEncoder = new BCryptPasswordEncoder();
		if(passwordEncoder.matches(RgPw, upw)) {
			return "Correct-pw";
		} else {
			return "Incorrect-pw";
		}
		
	}
	
	//ȸ��Ż��
	@RequestMapping(value="/user/resignation")
	public String resignation() {
		System.out.println("resignation");
		udao.resign(Constant.username);
		SecurityContextHolder.clearContext(); //ȸ��Ż��� �α׾ƿ� ����
		return "redirect:/";
	}

}

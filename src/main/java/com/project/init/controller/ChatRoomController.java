package com.project.init.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.init.command.ChatRoomListCommand;
import com.project.init.command.ICommand;
import com.project.init.dao.ChatDao;
import com.project.init.dao.ChatRoomDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.ChatMessageDto;
import com.project.init.dto.ChatRoomDto;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

@Controller
@RequestMapping(value = "/chat")
public class ChatRoomController {
	
//	private final ChatRoomDao cdao;
//	
//	public ChatRoomController(ChatRoomDao cdao) {
//		//super();
//		this.cdao = cdao;
//	}
	
	private ChatDao cdao;
	@Autowired
	public void setCdao(ChatDao cdao) {
		this.cdao = cdao;
		Constant.cdao = cdao;
	}
	
	private UserDao udao;
	@Autowired
	public void setUdao(UserDao udao) {
		this.udao = udao;
		Constant.udao = udao;
	}
	
	private ICommand mcom;
	
	@RequestMapping(value="/messages")
	public String messages(HttpServletRequest request, Model model){
		System.out.println("messages");
		mcom = new ChatRoomListCommand();
		mcom.execute(request, model);
		request.setAttribute("uId", Constant.username);
		return "chat/messages";
	}
	
	@ResponseBody
	@RequestMapping(value="/searchNick")
	public UserDto searchNick(HttpServletRequest request) {
		System.out.println("searchNick");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		UserDto result = udao.searchNick(nick);
		return result;
	}
	
	//채팅방 목록 조회
//	@GetMapping(value="/rooms")
//	public ModelAndView rooms() {
//		
//		System.out.println("# All Chat Rooms");
//		
//		ModelAndView mv = new ModelAndView("/chat/rooms");
//		
//		mv.addObject("list", cdao.findAllRooms());
//		
//		return mv;
//	}
	
	//채팅방 개설
//	@GetMapping(value="/croom")
//	public String create(@RequestParam String name, RedirectAttributes rttr) {
//		System.out.println("# Create Chat Room, name: " + name);
//		rttr.addFlashAttribute("roomName", cdao.createChatRoomDto(name));
//		return "redirect:/chat/rooms";
//	}
	
	@PostMapping(value="/croom")
	@ResponseBody
	public String create(@RequestParam String subNick, @RequestParam String subImg ) {
		System.out.println("# Create Chat Room, subNick: " + subNick + ", subImg: " + subImg);
		String subId = cdao.idFromNick(subNick);
		String pubId = Constant.username;
		String pubNick = cdao.nickFromId(pubId);
		String roomId = UUID.randomUUID().toString();
		String pubImg = "/init/resources/profileImg/" + udao.searchImg(Constant.username);
		ChatRoomDto crdto = new ChatRoomDto(0,roomId,pubId,subId,pubImg,subImg,pubNick,subNick);
		cdao.createChatRoom(crdto);
		return roomId;
	}
	
	//채팅방 조회
//	@GetMapping("/room")
//	public ModelAndView getRoom(@RequestParam String roomId) {
//		System.out.println("# get Chat Room, roomID : " + roomId);
//		ModelAndView mv = new ModelAndView("/chat/room");
//		mv.addObject("room",cdao.findRoomById(roomId));
//		mv.addObject("uname",Constant.username);
//		return mv;
//	}
	
	@PostMapping("/room")
	@ResponseBody
	public HashMap<String, Object> enterRoom(@RequestParam String roomId) {
		System.out.println("# enter Chat Room, roomID : " + roomId);
		ChatRoomDto cdto = cdao.getChatRoomDto(roomId);
		ArrayList<ChatMessageDto> mdtos = cdao.getChatMessageDto(roomId);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("mdtos", mdtos);
		map.put("cdto", cdto);
		System.out.println(map);
		return map;
	}
}

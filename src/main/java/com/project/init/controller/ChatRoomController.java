package com.project.init.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.init.dao.ChatRoomDao;

@Controller
@RequestMapping(value = "/chat")
public class ChatRoomController {
	
	private final ChatRoomDao cdao;
	
	public ChatRoomController(ChatRoomDao cdao) {
		//super();
		this.cdao = cdao;
	}
	
	//채팅방 목록 조회
	@GetMapping(value="/rooms")
	public ModelAndView rooms() {
		
		System.out.println("# All Chat Rooms");
		
		ModelAndView mv = new ModelAndView("/chat/rooms");
		
		mv.addObject("list", cdao.findAllRooms());
		
		return mv;
	}
	
	//채팅방 개설
	@GetMapping(value="/croom")
	public String create(@RequestParam String name, RedirectAttributes rttr) {
		System.out.println("# Create Chat Room, name: " + name);
		rttr.addFlashAttribute("roomName", cdao.createChatRoomDto(name));
		return "redirect:/chat/rooms";
	}
	
	//채팅방 조회
	@GetMapping("/room")
	public ModelAndView getRoom(@RequestParam String roomId) {
		System.out.println("# get Chat Room, roomID : " + roomId);
		ModelAndView mv = new ModelAndView("/chat/room");
		mv.addObject("room",cdao.findRoomById(roomId));
		return mv;
	}
	
}

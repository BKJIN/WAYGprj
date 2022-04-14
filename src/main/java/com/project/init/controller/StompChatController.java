package com.project.init.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.init.dao.ChatDao;
import com.project.init.dto.ChatMessageDto;
import com.project.init.util.Constant;

@Controller
public class StompChatController {

	private final SimpMessagingTemplate template;

	public StompChatController(SimpMessagingTemplate template) {
		//super();
		this.template = template;
	}
	
	@RequestMapping(value="/chat/rooms")
	public String chatrooms() {
		return "chat/rooms";
	}
	
	@MessageMapping(value="/chat/message")
	public void message(ChatMessageDto message) {
		template.convertAndSend("/sub/chat/room/" + message.getM_roomId(), message);
		ChatDao cdao = Constant.cdao;
		cdao.saveMsg(message);
		cdao.enterRoom(message.getM_roomId()); //메세지를 보내면 pubExit,subExit 둘 다 f로 update
		System.out.println("메세지보냄");
	}
}

package com.project.init.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.init.dto.ChatMessageDto;

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
	
	
	@MessageMapping(value="/chat/enter")
	public void enter(ChatMessageDto message) {
		message.setMessage(message.getWriter() + "���� ä�ù濡 �����Ͽ����ϴ�.");
		template.convertAndSend("/sub/chat/room/" + message.getRoomId(), message);
		System.out.println("ä������");
	}
	
	@MessageMapping(value="/chat/message")
	public void message(ChatMessageDto message) {
		template.convertAndSend("/sub/chat/room/" + message.getRoomId(), message);
		System.out.println("�޼�������");
	}
}

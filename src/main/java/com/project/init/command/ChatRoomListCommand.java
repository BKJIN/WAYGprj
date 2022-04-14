package com.project.init.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dao.ChatDao;
import com.project.init.dto.ChatRoomDto;
import com.project.init.util.Constant;

public class ChatRoomListCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		ChatDao cdao = Constant.cdao;
		ArrayList<ChatRoomDto> dtos = cdao.chatRoomList(Constant.username);
		for (int i= (dtos.size() -1); i > -1; i--) {
			ChatRoomDto dto = dtos.get(i);
			System.out.println(dto.getPubId() + ", " + dto.getSubId());
			System.out.println(Constant.username);
			if(dto.getPubId().equals(Constant.username)) {
				if(dto.getPubExit().equals("t")) {
					dtos.remove(i);
				} else {
				dto.setChatRoom(dto.getSubNick());
				dto.setRoomImg(dto.getSubImg());
				}	
			} else {
				if(dto.getSubExit().equals("t")) {
					dtos.remove(i);
				} else {
				dto.setChatRoom(dto.getPubNick());
				dto.setRoomImg(dto.getPubImg());
				}
			}
			System.out.println(dto.getChatRoom() + ", " + dto.getRoomImg());
		}
		
		request.setAttribute("chatRoomList", dtos);
	}

}

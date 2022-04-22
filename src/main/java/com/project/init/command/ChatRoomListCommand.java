package com.project.init.command;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;

import com.project.init.dao.ChatDao;
import com.project.init.dto.ChatRoomDto;
import com.project.init.util.Constant;

public class ChatRoomListCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		ChatDao cdao = Constant.cdao;
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		ArrayList<ChatRoomDto> dtos = cdao.chatRoomList(user.getUsername());
		for (int i= (dtos.size() -1); i > -1; i--) {
			ChatRoomDto dto = dtos.get(i);
			System.out.println(dto.getPubId() + ", " + dto.getSubId());
			System.out.println(user.getUsername());
			if(dto.getPubId().equals(user.getUsername())) {
				if(dto.getPubExit().equals("t")) {
					dtos.remove(i);
				} else {
				dto.setChatRoom(dto.getSubNick());
				dto.setRoomImg(dto.getSubImg());
				dto.setNewMsgNum(dto.getPubUnReadMsg());
				dto.setRecentMsg(dto.getPubRecentMsg());
				//dto.setRoomImg("/init/resources/profileImg/" + cdao.findUserImg(dto.getSubId()));
				//String ChatRoomImg = "/init/resources/profileImg/" + cdao.findUserImg(dto.getSubId());
				//Map <String, Object> map = new HashMap<String, Object>();
				//map.put("ChatRoomImg", ChatRoomImg);
				//map.put("subId", dto.getSubId());
				//cdao.mdfChatRoomSImg(map);
				
				}	
			} else {
				if(dto.getSubExit().equals("t")) {
					dtos.remove(i);
				} else {
				dto.setChatRoom(dto.getPubNick());
				dto.setRoomImg(dto.getPubImg());
				dto.setNewMsgNum(dto.getSubUnReadMsg());
				dto.setRecentMsg(dto.getSubRecentMsg());
				//dto.setRoomImg("/init/resources/profileImg/" + cdao.findUserImg(dto.getPubId()));
				//String ChatRoomImg = "/init/resources/profileImg/" + cdao.findUserImg(dto.getPubId());
				//Map <String, Object> map = new HashMap<String, Object>();
				//map.put("ChatRoomImg", ChatRoomImg);
				//map.put("pubId", dto.getPubId());
				//cdao.mdfChatRoomPImg(map);
				}
			}
			System.out.println(dto.getChatRoom() + ", " + dto.getRoomImg());
		}
		
		request.setAttribute("chatRoomList", dtos);
	}

}

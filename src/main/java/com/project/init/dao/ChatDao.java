package com.project.init.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.project.init.dto.ChatMessageDto;
import com.project.init.dto.ChatRoomDto;

public class ChatDao implements ChatIDao {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public String idFromNick(String subNick) {
		String subId = sqlSession.selectOne("idFromNick",subNick);
		return subId;
	}
	
	@Override
	public String nickFromId(String pubId) {
		String pubNick =sqlSession.selectOne("nickFromId",pubId);
		return pubNick;
	}

	@Override
	public void createChatRoom(ChatRoomDto crdto) {
		sqlSession.insert("createChatRoom",crdto);
	}

	@Override
	public ArrayList<ChatRoomDto> chatRoomList(String id) {
		ArrayList<ChatRoomDto> result = (ArrayList)sqlSession.selectList("chatRoomList",id);
		return result;
	}

	@Override
	public ChatRoomDto getChatRoomDto(String roomId) {
		ChatRoomDto result = sqlSession.selectOne("getChatRoomDto",roomId);
		return result;
	}

	@Override
	public ArrayList<ChatMessageDto> getChatMessageDto(String roomId) {
		ArrayList<ChatMessageDto> result = (ArrayList)sqlSession.selectList("getChatMessageDto",roomId);
		return result;
	}
	

}

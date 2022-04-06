package com.project.init.dto;

import java.util.UUID;

public class ChatRoomDto {
	private String roomId;
	private String name;
	
	public ChatRoomDto() {
		super();
	}

	public ChatRoomDto(String roomId, String name) {
		super();
		this.roomId = roomId;
		this.name = name;
	}

	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static ChatRoomDto create(String name) {
		ChatRoomDto room = new ChatRoomDto();
		
		room.roomId = UUID.randomUUID().toString();
		room.name = name;
		return room;
	}
}

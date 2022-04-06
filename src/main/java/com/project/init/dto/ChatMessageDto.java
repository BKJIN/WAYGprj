package com.project.init.dto;

public class ChatMessageDto {
	private String roomId;
	private String writer;
	private String message;
	
	public ChatMessageDto() {
		super();
	}

	public ChatMessageDto(String roomId, String writer, String message) {
		super();
		this.roomId = roomId;
		this.writer = writer;
		this.message = message;
	}

	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}

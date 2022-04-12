package com.project.init.dto;


public class ChatRoomDto {	
	private int roomNum;
	private String roomId;
	private String pubId;
	private String subId;
	private String pubImg;
	private String subImg;
	private String pubNick;
	private String subNick;
	
	public ChatRoomDto() {
		super();
	}

	public ChatRoomDto(int roomNum, String roomId, String pubId, String subId, String pubImg, String subImg,
			String pubNick, String subNick) {
		super();
		this.roomNum = roomNum;
		this.roomId = roomId;
		this.pubId = pubId;
		this.subId = subId;
		this.pubImg = pubImg;
		this.subImg = subImg;
		this.pubNick = pubNick;
		this.subNick = subNick;
	}

	public int getRoomNum() {
		return roomNum;
	}

	public void setRoomNum(int roomNum) {
		this.roomNum = roomNum;
	}

	public String getRoomId() {
		return roomId;
	}

	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	public String getPubId() {
		return pubId;
	}

	public void setPubId(String pubId) {
		this.pubId = pubId;
	}

	public String getSubId() {
		return subId;
	}

	public void setSubId(String subId) {
		this.subId = subId;
	}

	public String getPubImg() {
		return pubImg;
	}

	public void setPubImg(String pubImg) {
		this.pubImg = pubImg;
	}

	public String getSubImg() {
		return subImg;
	}

	public void setSubImg(String subImg) {
		this.subImg = subImg;
	}

	public String getPubNick() {
		return pubNick;
	}

	public void setPubNick(String pubNick) {
		this.pubNick = pubNick;
	}

	public String getSubNick() {
		return subNick;
	}

	public void setSubNick(String subNick) {
		this.subNick = subNick;
	}
	
	
}

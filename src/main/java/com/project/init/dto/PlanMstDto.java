package com.project.init.dto;

public class PlanMstDto {
	
	
	private int planNum;
	private String planName;
	private String startDate;
	private String endDate;
	private String theme;

	public PlanMstDto() {
		super();
	}

	public PlanMstDto(int planNum, String planName, String startDate, String endDate, String theme) {
		super();
		this.planNum = planNum;
		this.planName = planName;
		this.startDate = startDate;
		this.endDate = endDate;
		this.theme = theme;
	}
	
	public int getPlanNum() {
		return planNum;
	}

	public void setPlanNum(int planNum) {
		this.planNum = planNum;
	}

	public String getPlanName() {
		return planName;
	}
	
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	
	public String getStartDate() {
		return startDate;
	}
	
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}
	
}

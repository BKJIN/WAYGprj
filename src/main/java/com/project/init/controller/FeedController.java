package com.project.init.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.init.command.ICommand;
import com.project.init.command.PlanMstInsertCommand;
import com.project.init.command.PlanMstSelectCommand;
import com.project.init.dto.PlanMstDto;

@Controller
@RequestMapping("/feed")
public class FeedController {
	
	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);
	
	private ICommand comm;
	
	@RequestMapping("")
	public String feed() {
		logger.info("feed() in >>>>");
		return "feed/feed_calendar";
	}
	
	@RequestMapping("planList.do")
	public String planListDo(PlanMstDto dto, HttpServletRequest request, Model model, RedirectAttributes rttr) {
		logger.info("planList.do(" + dto.getPlanName() + ") in >>>>");
		
		request.setAttribute("mstDto", dto);
		
		comm = new PlanMstInsertCommand();
		comm.execute(request, model);
		
		rttr.addAttribute("planNum", dto.getPlanNum());
		
		logger.info("planList.do(" + dto.getPlanName() + ") result : " + dto.getPlanNum());
		
		return "redirect:planList";
	}
	
	@RequestMapping("planList")
	public String planList(@RequestParam("planNum") int planNum, HttpServletRequest request, Model model) {
		logger.info("mappage() in >>>>");
		
		request.setAttribute("planNum", planNum);
		
		comm = new PlanMstSelectCommand();
		comm.execute(request, model);
		
		logger.info("mappage() result : " + (model.containsAttribute("mstDto") ? "success" : "failed"));

		return "feed/plan_list";
	}
	
	@RequestMapping(value="insertMap", produces = "application/text; charset=UTF8")
	@ResponseBody
	public String planList(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("insertMap() in >>>>");
		/*
		mcom = new MapCommand();
		mcom.execute(model, request);		
		*/
		
		String result = (String)request.getAttribute("result");

		
		logger.info("insertMap() result : " + result);
		if(result.equals("success"))
			return "insert-success";
		else
			return "insert-failed";
	}
	
}

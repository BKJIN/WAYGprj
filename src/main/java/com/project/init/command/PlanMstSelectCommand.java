package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;

import com.project.init.dao.PlanDao;
import com.project.init.dto.PlanMstDto;
import com.project.init.util.Constant;

public class PlanMstSelectCommand implements ICommand {
	
	private static final Logger logger = LoggerFactory.getLogger(PlanMstInsertCommand.class);
	
	private PlanDao planDao = Constant.pdao;
	
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		logger.info("execute() in >>> ");
		
		PlanMstDto dto = planDao.selectPlanMst((Integer)request.getAttribute("planNum"));
		
		model.addAttribute("mstDto", dto);
	}

}

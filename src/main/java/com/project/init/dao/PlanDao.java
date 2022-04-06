package com.project.init.dao;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.init.dto.PlanMstDto;
import com.project.init.util.Constant;

@Component
public class PlanDao implements PlanIDao {

	private static final Logger logger = LoggerFactory.getLogger(PlanDao.class);

	private final SqlSession sqlSession;
	
	@Autowired
	public PlanDao(SqlSession sqlSession) {
		logger.info("PlanDao Const in >>>");
		this.sqlSession = sqlSession;
		
		Constant.pdao = this;
		logger.info("PlanDao Const result : sqlSession getConn success ? " + sqlSession.toString());
	}
	
	
	@Override
	public void insertPlanMst(PlanMstDto dto) {
		logger.info("insertPlanMst(" + dto.getPlanName() + ")in >>>");
			
		int res = sqlSession.insert("insertPlanMst", dto);
		
		logger.info("insertPlan(" + dto.getPlanName() + ") result1 : " + (res > 0 ? "success" : "failed"));
		logger.info("insertPlan(" + dto.getPlanName() + ") result2 : planNum ? " + dto.getPlanNum());

	}

	@Override
	public PlanMstDto selectPlanMst(int planNum) {
		logger.info("selectPlanMst(" + planNum + ") in >>>");
		
		PlanMstDto dto = sqlSession.selectOne("selectPlanMst", planNum);
		
		logger.info("selectPlanMst(" + planNum + ") result : " + (dto != null ? "success" : "null"));
		return dto;
	}

	
}

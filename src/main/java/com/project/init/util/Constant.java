package com.project.init.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.project.init.dao.UserDao;
import com.project.init.dao.ChatDao;
import com.project.init.dao.PlanDao;

public class Constant {
	
	public static PlanDao pdao;
	public static BCryptPasswordEncoder passwordEncoder;
	public static UserDao udao;
	public static String username;
	public static ChatDao cdao;
}

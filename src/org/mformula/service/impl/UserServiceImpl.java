package org.mformula.service.impl;

import org.mformula.dao.UserDao;
import org.mformula.entity.User;
import org.mformula.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userdao;
	
	@Override
	public User findByUsername(String username) {
		
		return userdao.findByUsername(username);
	}

}

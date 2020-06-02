package org.mformula.service.impl;

import java.util.List;
import java.util.Map;

import org.mformula.dao.UserDao;
import org.mformula.entity.User;
import org.mformula.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;
	
	@Override
	public User findByUsername(String username) {
		
		return userDao.findByUsername(username);
	}

	@Override
	public int add(User user) {
		// TODO Auto-generated method stub
		return userDao.add(user);
	}

	@Override
	public List<User> getList(Map<String, Object> query) {
		// TODO Auto-generated method stub
		return userDao.getList(query);
	}

	@Override
	public Integer getTotal(Map<String, Object> query) {
		// TODO Auto-generated method stub
		return userDao.getTotal(query);
	}

	@Override
	public int edit(User user) {
		// TODO Auto-generated method stub
		return userDao.edit(user);
	}

}

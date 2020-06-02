package org.mformula.dao;

import java.util.List;
import java.util.Map;

import org.mformula.entity.User;
import org.springframework.stereotype.Repository;



@Repository
public interface UserDao {
	
	public User findByUsername(String username);
	
	public List<User> getList(Map<String,Object> query);
	
	public int add(User user);

	public int edit(User user);
	
	public Integer getTotal(Map<String,Object> query);
}

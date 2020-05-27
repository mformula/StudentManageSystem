package org.mformula.dao;

import org.mformula.entity.User;
import org.springframework.stereotype.Repository;

@Repository
public interface UserDao {
	
	public User findByUsername(String username);

}

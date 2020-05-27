package org.mformula.service;

import org.mformula.entity.User;
import org.springframework.stereotype.Service;

@Service
public interface UserService {
	
	public User findByUsername(String username);

}

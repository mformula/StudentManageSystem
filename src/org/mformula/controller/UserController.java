package org.mformula.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.mformula.entity.User;
import org.mformula.page.Page;
import org.mformula.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping(value="/user")
@Controller
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "/list",method = RequestMethod.GET)
	public ModelAndView list(ModelAndView view) {
		view.setViewName("user/user_list");
		return view;
	}
	
	@RequestMapping(value="get_list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> get_list(
			@RequestParam(name = "username",required=false,defaultValue = "") String username,
			Page page
			){
		Map<String,Object> ret = new HashMap<String,Object>();
		Map<String,Object> query = new HashMap<String,Object>();
		query.put("username","%"+username+"%");
		query.put("offset",page.getOffset());
		query.put("pageSize",page.getRows());
		List<User> list = userService.getList(query);
		ret.put("rows",list);
		ret.put("total",userService.getTotal(query));				
		return ret;
		
	}
	
	@RequestMapping(value="/add",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> add(User user){
		
		Map<String,String> ret = new HashMap<String,String>();
		
		if(user==null) {
			ret.put("type","error");
			ret.put("msg","数据绑定出错");
			return ret;						
		}
		if(StringUtils.isEmpty(user.getUsername())) {
			ret.put("type","error");
			ret.put("msg","用户名不能为空！");
			return ret;		
		}
		if(StringUtils.isEmpty(user.getPassword())) {
			ret.put("type","error");
			ret.put("msg","密码不能为空！");
			return ret;		
		}
		User existUser = userService.findByUsername(user.getUsername());
		if(existUser!=null) {
			ret.put("type","error");
			ret.put("msg","该用户名已存在！");
			return ret;		
		}
		if(userService.add(user)<=0) {
			ret.put("type","error");
			ret.put("msg","添加失败！");
			return ret;		
		}		
		ret.put("type","success");
		ret.put("msg","添加成功！");
		return ret;			

	}
	
	@RequestMapping(value="/edit",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,String> edit(User user){
		
		Map<String,String> ret = new HashMap<String,String>();
		
		if(user==null) {
			ret.put("type","error");
			ret.put("msg","数据绑定出错");
			return ret;						
		}
		if(StringUtils.isEmpty(user.getUsername())) {
			ret.put("type","error");
			ret.put("msg","用户名不能为空！");
			return ret;		
		}
		if(StringUtils.isEmpty(user.getPassword())) {
			ret.put("type","error");
			ret.put("msg","密码不能为空！");
			return ret;		
		}
		User existUser = userService.findByUsername(user.getUsername());
		if(existUser!=null) {
			if(user.getId()!=existUser.getId()) {
				ret.put("type","error");
				ret.put("msg","该用户名已存在！");
				return ret;		
			}			
		}
		if(userService.edit(user)<=0) {
			ret.put("type","error");
			ret.put("msg","修改失败！");
			return ret;		
		}		
		ret.put("type","success");
		ret.put("msg","修改成功！");
		return ret;			

	}
	
	

}

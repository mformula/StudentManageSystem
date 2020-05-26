package org.mformula.controller;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import org.mformula.utils.CpachaUtil;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;



@RequestMapping("/system")
@Controller
public class SystemController {
	
	//第一种方式
//	@RequestMapping(value="/index",method=RequestMethod.GET)
//	public String index() {
//		//寻找名为“Hello World”的jsp文件
//		return "Hello World";
//	}
	
	//第二种方式
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public ModelAndView index(ModelAndView model) {
		
		model.addObject("user", "mformula");
		model.setViewName("Hello World");
		return model;
		
	}
	
	/**
	 * 登录界面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public ModelAndView login(ModelAndView model) {
		
		model.setViewName("system/login");
		return model;
		
	}
	
	/**
	 * 登录表单提交
	 * @param username
	 * @param password
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> login(
			@RequestParam(value="username",required=true) String username,
			@RequestParam(value="password",required=true) String password,
			@RequestParam(value="vcode",required=true) String vcode,
			@RequestParam(value="type",required=true) String type,
			HttpServletRequest request
			) {
		
		Map<String,String> ret = new HashMap<String,String>();
		if(StringUtils.isEmpty(username)) {
			ret.put("type","error");
			ret.put("msg","用户名不能为空!");
			return ret;
		}
		if(StringUtils.isEmpty(password)) {
			ret.put("type","error");
			ret.put("msg","密码不能为空!");
			return ret;
		}
		if(StringUtils.isEmpty(vcode)) {
			ret.put("type","error");
			ret.put("msg","验证码不能为空!");
			return ret;
		}
		String loginCpacha = (String) request.getSession().getAttribute("loginCpacha");
		//检查验证码是否已失效
		if(StringUtils.isEmpty(loginCpacha)) {
			ret.put("type","error");
			ret.put("msg","长时间未操作，会话已失效，请刷新后重试！");
			return ret;
		}
		if(!vcode.toUpperCase().equals(loginCpacha.toUpperCase())) {
			ret.put("type","error");
			ret.put("msg","验证码错误");
			return ret;
		}
		//清空验证码
		request.getSession().setAttribute("loginCpacha", null);
		//从数据库中查找用户
		ret.put("type","success");
		ret.put("msg","登录成功!");					
		return ret;					
	}
	
	@RequestMapping(value="/get_cpacha",method=RequestMethod.GET)
	public void get_cpacha(HttpServletRequest request,
			@RequestParam(value="vl",defaultValue="4",required=false) Integer vl,
			@RequestParam(value="w",defaultValue="98",required=false) Integer w,
			@RequestParam(value="h",defaultValue="33",required=false) Integer h,
			HttpServletResponse response) {
		
		CpachaUtil cpachaUtil = new CpachaUtil(vl,w,h);
		//生成验证码
		String generatorVCode = cpachaUtil.generatorVCode();
		//生成验证码图片,并带有干扰线
		BufferedImage generatorVCodeImage = cpachaUtil.generatorVCodeImage(generatorVCode, true);
		HttpSession session = request.getSession();
		session.setAttribute("loginCpacha", generatorVCode );
		try {
			ImageIO.write(generatorVCodeImage,"gif",response.getOutputStream());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}

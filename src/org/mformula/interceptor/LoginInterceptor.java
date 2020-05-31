package org.mformula.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mformula.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.JSONObject;

public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {
		
		String url = request.getRequestURI();
		User user = (User) request.getSession().getAttribute("user");
		if(user==null) {
			//表示未登录或者登录状态失效
			System.out.println("未登录或者登录失效，url="+url);
			if("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))){
				Map<String,String> ret = new HashMap<String,String>();
				ret.put("type","error");
				ret.put("msg","登录状态已失效");
				response.getWriter().write(JSONObject.fromObject(ret).toString());
				return false;
			}
			//转到登录页面
			response.sendRedirect(request.getContextPath()+"/system/login");
			return false;
		}
		System.out.println(user.getUsername()+"登录成功，url="+url);
		return true;
	}

}

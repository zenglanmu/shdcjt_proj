<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.*" %>
<%
//判断密码强制修改
String changepwd = (String)request.getSession().getAttribute("changepwd");
if("n".equals(changepwd)){
	request.getSession().removeAttribute("changepwd");
	response.sendRedirect("/login/Login.jsp");
	return;
}else if("y".equals(changepwd)){
	request.getSession().removeAttribute("changepwd");
}


/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
%>
<%@ include file="/wui/common/page/initWui.jsp" %>
<%
/**
 * 系统主题
 */
String curTheme = "";
String ely6flg = "";
String gopage = Util.null2String(request.getParameter("gopage"));
String frompage = Util.null2String(request.getParameter("frompage"));
int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
String logintype = Util.null2String(user.getLogintype()) ;
curTheme = getCurrWuiConfig(session, user, "theme");

if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}

/*
if (ely6flg != null && !"".equals(ely6flg) && "ecology6".equals(ely6flg)) {	
	response.sendRedirect("/main.jsp");
	return;
}
*/
/*
 * 根据用户设置，跳转到相应的模式中
 */
request.getRequestDispatcher("/wui/theme/" + curTheme +"/page/main.jsp?"+request.getQueryString()).forward(request, response);
%>

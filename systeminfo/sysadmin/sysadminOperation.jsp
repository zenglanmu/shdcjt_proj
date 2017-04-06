<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.sysadmin.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String method = Util.null2String(request.getParameter("method"));

String loginid = Util.convertInput2DB(Util.null2String(request.getParameter("loginid")));
String password = Util.convertInput2DB(Util.null2String(request.getParameter("password")));
String lastname = Util.convertInput2DB(Util.null2String(request.getParameter("lastname")));
String description = Util.convertInput2DB(Util.null2String(request.getParameter("description")));
if(method.equals("add")){
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	if(!dao.ifHaveSameLoginId(loginid)){
		RecordSet.executeProc("HrmResourceMaxId_Get","");
		RecordSet.next();
		String id = ""+RecordSet.getInt(1);
		String tempSecPassword = Util.getEncrypt(password);
		HrmResourceManagerVO vo = new HrmResourceManagerVO();
		vo.setId(id);
		vo.setLoginid(loginid);
		vo.setPassword(tempSecPassword);
        vo.setLastname(lastname);
		vo.setSystemlanguage(Integer.toString(user.getLanguage()));
		vo.setDescription(description);
        vo.setCreator(String.valueOf(user.getUID()));
		
		dao.insertHrmResourceManagerVO(vo);
		response.sendRedirect("sysadminList.jsp");
	}else{
		response.sendRedirect("addSysadmin.jsp?result=false");
	}
}else if(method.equals("edit")){
    HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
    String id = Util.null2String(request.getParameter("id"));
    if(!dao.ifHaveSameLoginId(loginid,id)){
        HrmResourceManagerVO vo = new HrmResourceManagerVO();
        vo.setId(id);
        vo.setLoginid(loginid);
        vo.setLastname(lastname);
        vo.setSystemlanguage(Integer.toString(user.getLanguage()));
        vo.setDescription(description);
        dao.updateHrmResourceManagerVO(vo);
        response.sendRedirect("sysadminList.jsp");
	}else{
		response.sendRedirect("sysadminEdit.jsp?result=false&id="+id);
	}
}else if(method.equals("changepwd")){
	String id = Util.null2String(request.getParameter("id"));
    String oldpassword = Util.null2String(request.getParameter("oldpassword"));
	String newpassword = Util.null2String(request.getParameter("newpassword"));
    //编辑下级密码时不需要旧密码
    if(!oldpassword.equals("")){
        if(password.equals(Util.getEncrypt(oldpassword))){
            String tempSecPassword = Util.getEncrypt(newpassword);
            HrmResourceManagerVO vo = new HrmResourceManagerVO();
            vo.setId(id);
            vo.setPassword(tempSecPassword);
            HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
            dao.updateHrmPwd(vo);
            response.sendRedirect("sysadminList.jsp");
        }else{
            response.sendRedirect("changePwd.jsp?result=false&id="+id);
        }
    }else{
            String tempSecPassword = Util.getEncrypt(newpassword);
            HrmResourceManagerVO vo = new HrmResourceManagerVO();
            vo.setId(id);
            vo.setPassword(tempSecPassword);
            HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
            dao.updateHrmPwd(vo);
            response.sendRedirect("sysadminList.jsp");
    }
}else if(method.equals("del")){
	String id = Util.null2String(request.getParameter("id"));
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	dao.delHrmResourceManagerByID(id);
	response.sendRedirect("sysadminList.jsp");
}
%>
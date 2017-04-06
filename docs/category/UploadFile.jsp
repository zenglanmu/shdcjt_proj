<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%  
    if((!HrmUserVarify.checkUserRight("DocMainCategoryEdit:Edit", user))&&(!HrmUserVarify.checkUserRight("DocMainCategoryEdit:Delete", user))&&(!HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user))){
	    response.sendRedirect("/notice/noright.jsp");
	    return ;
	}
    MainCategoryManager.setClientAddress(request.getRemoteAddr());
    MainCategoryManager.setUserid(user.getUID());
    String message = MainCategoryManager.foruploadfile(request);
    if(!message.equals("")&&!message.equals("-1")&&!message.equals("-2")) {
        int spit = message.indexOf('_');
        int id = Util.getIntValue(message.substring(0,spit),0);
        int messageid = Util.getIntValue(message.substring(spit+1,message.length()),0);
        response.sendRedirect("DocMainCategoryEdit.jsp?id="+id+"&message="+messageid);
    }else if(message.equals("-1")){
        response.sendRedirect("DocMainCategoryAdd.jsp?errorcode=10");
        return;
    }else if(message.equals("-2")){
        response.sendRedirect("DocMainCategoryEdit.jsp?errorcode=10&id="+MainCategoryManager.getId());
        return;
    }else {
    	int id = MainCategoryManager.getId();
    	String operation = MainCategoryManager.getAction();
    	if(id>0&&!"delete".equals(operation)){
            MainCategoryComInfo.removeMainCategoryCache();
            response.sendRedirect("DocMainCategoryEdit.jsp?reftree=1&id="+id);
    	} else {
            MainCategoryComInfo.removeMainCategoryCache();
            response.sendRedirect("DocCategoryEdit.jsp?reftree=1");
    	}
    }
%>
<input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
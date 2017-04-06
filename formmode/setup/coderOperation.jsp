<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
  String method=  Util.null2String(request.getParameter("method"));
  String codemainid=  Util.null2String(request.getParameter("codemainid"));
  String postValue=  Util.null2String(request.getParameter("postValue"));
  int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);
  int codeFieldId=  Util.getIntValue(request.getParameter("codeFieldId"),0);
  int modeId=  Util.getIntValue(request.getParameter("modeId"),0);
  if ("update".equals(method)) {
    rs.executeSql("update ModeCode set isuse="+txtUserUse+",codeFieldId="+codeFieldId+" where modeid="+modeId);
    rs.executeSql("delete ModeCodeDetail where codemainid="+codemainid);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String type = memberAttibutes[2];

      String insertStr = "insert into ModeCodeDetail (codemainid,showname,showtype,showvalue,codeorder) values ("+codemainid+",'"+text+"','"+type+"','"+value+"',"+i+")";   
      rs.executeSql(insertStr);          
    }
    response.sendRedirect("ModeCode.jsp?modeId="+modeId);
  }
%>



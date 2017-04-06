<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String operation=Util.null2String(request.getParameter("operation"));
String tuserId=Util.null2String(request.getParameter("userId"));
if(!tuserId.equals(""+user.getUID()))
{
	return ;
}
%>

<script language="javascript">

<%

    if(operation.equals("docCheckIn")){

		String returnVlaue="";

		String docId=Util.null2String(request.getParameter("docId"));
		DocCheckInOutUtil.docCheckInNODwr(docId,request);
%>
        window.parent.returnTrue("<%=returnVlaue%>");
<%
    }

    if(operation.equals("whetherCanDelete")){

		String returnVlaue="";

		String docId=Util.null2String(request.getParameter("docId"));
		String userId=Util.null2String(request.getParameter("userId"));
		String userLoginType=Util.null2String(request.getParameter("userLoginType"));
		String strUserLanguage=Util.null2String(request.getParameter("strUserLanguage"));

		returnVlaue=DocCheckInOutUtil.whetherCanDeleteNODwr(docId,userId,userLoginType,strUserLanguage);
%>
        window.parent.checkForDelete("<%=returnVlaue%>");
<%
    }

    if(operation.equals("useTempletCancel")){

		String returnVlaue="";

		String docId=Util.null2String(request.getParameter("docId"));
		String versionId=Util.null2String(request.getParameter("versionId"));

		returnVlaue=DocCheckInOutUtil.useTempletCancel(docId,versionId);
%>
        window.parent.useTempletCancelReturn("<%=returnVlaue%>");
<%
    }

    if(operation.equals("saveIsignatureFun")){

		String returnVlaue="";

		String requestid=Util.null2String(request.getParameter("requestid"));
		String nodeId=Util.null2String(request.getParameter("nodeId"));
		String userId=Util.null2String(request.getParameter("userId"));
		String loginType=Util.null2String(request.getParameter("loginType"));
		String signNum=Util.null2String(request.getParameter("signNum"));

		DocCheckInOutUtil.saveIsignatureFun(requestid,nodeId,userId,loginType,signNum);
%>
        window.parent.saveIsignatureFunReturn();
<%
    }
%>



</script>
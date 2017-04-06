<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<html>
<head>


</head>
<body>
<%--<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
<%--<%@ include file="/systeminfo/RightClickMenu1.jsp" %>--%>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
if(operatelevel>0){
%>
<table>
    <tr>
        <td><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>£º</td>
        <td class=field>
    <select class="InputStyle" onchange="logtype(this);">
        <option value=0>----------</option>
        <option value=1><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
        <option value=2><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
        <option value=3><%=SystemEnv.getHtmlLabelName(15587,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
    </select>
        </td>
    </tr>

     <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD>
     </TR>

</table>
    <iframe id="slog" name="slog" frameborder="0" width=100% height=100% scrolling="auto" src=""></iframe>    
    <div name="log" id="log" ></div>
<%}else{
    response.sendRedirect("/notice/noright.jsp");
    return;
}%>
</body>
</html>
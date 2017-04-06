<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess,
                 weaver.hrm.resign.RoleDetail" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
String id=Util.null2String(request.getParameter("id"));
//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
String userId = "" + user.getUID();
String managerId = ResourceComInfo.getManagerID(id);
if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17575,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%





boolean hasNextPage=false;


//int total=Util.getIntValue(Util.null2String(request.getParameter("total")),1);
//int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
//int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
//角色不做分页处理，预留分页处理的借口。xiaofeng
ArrayList roles=ResignProcess.getRolesDetail(id,0,0,user.getLanguage());



%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>



<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  
  <TR class=Header>
  <th ><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></th>
  <th ><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan=2 ></TD></TR>
  <%
boolean islight=true;


Iterator iter=roles.iterator();
while(iter.hasNext()){
        RoleDetail role=(RoleDetail)iter.next();
	String roleid=role.getRoleid();
	String name=role.getRoleName();
	String level=role.getRolelevel();
	
	
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
  <td >
  <%if(HrmUserVarify.checkUserRight("HrmRoleMembersAdd:Add",user)){%>
  <A
  href="/hrm/roles/HrmRolesMembers.jsp?id=<%=roleid%>"><B><%=name%></B></A>&nbsp;
  <%}else{%>
  <B><%=name%></B>
  <%}%>
  </td>
  <td ><%=level%>
  </td>
  
  </tr>
  

<%
	islight=!islight;
	
}
%>
  </tbody>
</table>


<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   
 <td>

<%
if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16527,user.getLanguage())+",/hrm/roles/HrmRoles.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:returnMain(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<SCRIPT language="javascript">

function returnMain(){
        window.location="/hrm/resign/Resign.jsp?resourceid=<%=id%>";
}

</script>
</BODY></HTML>
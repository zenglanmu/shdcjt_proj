<%@ page import="weaver.general.Util,
                 weaver.hrm.group.GroupAction,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/group/HrmGroupAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RecordSet rs=GroupAction.getGroups(user);
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<FORM id=weaver name=frmMain action="" method=post>

<TABLE class=ListStyle cellspacing=1 >
 <COLGROUP>
  <COL width="10%">
  <COL width="10%">
  <COL width="30%">
  <COL width="20%">
 <TBODY>
   <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(17617,user.getLanguage())%></TH>
   </TR>
   </TR>
   <TR class=header>
       <TD class=Field><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=Field><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>    
    <TD class=Field><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>    
  </TR>
  <TR class=Line><TD colspan="4" style="padding:0px;" ></TD></TR> 
<%
int line = 0;
while(rs.next()){    
  if(line%2 == 0){  
%>  
    <tr class=datalight>
<%
  }else{
%>  
   <tr class=datadark>  
<%
  }
%>
  <td class=Field>
      <a href="/hrm/group/HrmGroupDetail.jsp?id=<%=rs.getString("id")%>">
        <%=rs.getString("id")%>
      </a>
      </td>

      <td class=Field>
      <a href="/hrm/group/HrmGroupDetail.jsp?id=<%=rs.getString("id")%>">
        <%=Util.toHtmlForSplitPage(rs.getString("name"))%>
		</a>
      </td>
      <td class=Field>
        <% String type=rs.getString("type");
        if(type.equals("0")){
        %>
        私人组
        <%}else{%>
        公共组
        <%}%>
      </td>      
      <td class=Field>
       <a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("owner")%>">  
       <%=ResourceComInfo.getResourcename(rs.getString("owner"))%>  </a>
      </td>  
    </tr>
<%
line++;
}
%>
 </tbody>
</table>
</form>
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

</BODY>
</HTML>

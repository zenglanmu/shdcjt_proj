<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FnaDptToKingdeeComInfo" class="weaver.fna.maintenance.FnaDptToKingdeeComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<br>
<FORM id=weaver name=frmmain method=post action="FnaDptToKingdeeOperation.jsp" >
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
String needfav ="1";
String needhelp ="";%>
<table  class=ListStyle cellspacing=1>
  <tr class=Header>
    <td width="25%" ><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
    <td width="25%" >K3<%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="8" ></TD></TR> 
<%boolean islight=true;
while(DepartmentComInfo.next())
{
%>
  <tr <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>> 
    <td width="25%"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></td>      
    <td width="25%"><INPUT class=InputStyle name=<%=DepartmentComInfo.getDepartmentid()%> maxLength=15 size=15 value="<%=FnaDptToKingdeeComInfo.getKingdeeCode(DepartmentComInfo.getDepartmentid())%>" ></td>   
  </tr>
<%
    islight=!islight;
   
}%>
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
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

</BODY>
</HTML>




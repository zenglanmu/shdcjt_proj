<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6002,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
/*
//Commented By Huang Yu On May 12th,2004 For Bug 95
if(HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",/hrm/tools/HrmValidateAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="HrmValidateOperation.jsp" method=post>
<input class=inputstyle type=hidden name=method value="save">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6002,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD>id</TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TD>
  </TR>

<%
    //rs.executeProc("HrmList_SelectAll","") ;
    rs.executeSql("select id,name,validate_n from HrmListValidate order by id");
    int needchange = 0;
      while(rs.next()){
        int id=rs.getInt("id");
        if(id==10){
        	continue;
        }
		String	name=rs.getString("name");
		int	validate=rs.getInt("validate_n");
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
  %>
  <TD><%=id%></TD>
    <TD><%=name%></TD>
    <%if(id<4){%>
    <td>
       <input class=inputstyle type=hidden name="isValidate" value="<%=id%>" ><img src="/images/BacoCheck.gif"></img>
    </td>
    <%}else{%>
    <TD>
      <input class=inputstyle type=checkbox name="isValidate" value="<%=id%>" <%if(validate==1){%>checked<%}%>>
    </TD>    
    <%}%>
  </TR>
<%}catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>  
 </TBODY>
 </TABLE>
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
 frmMain.submit();
}
</script>

</BODY>
</HTML>

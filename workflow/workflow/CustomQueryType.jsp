<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
boolean isedit = true;
if(user.getUID()!=1){
	isedit = false;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23799,user.getLanguage());
String needfav ="1";
String needhelp ="";


String shortName = Util.null2String(request.getParameter("shortName"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(isedit)
{
	//if(HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javaScript:donewQueryType(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
//}
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

<form name="frmSearch" method="post" >
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="shortName" class="inputStyle" value="<%=shortName%>">
			</td>
		</tr>
	</table>
</form>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="60%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(23799,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15521,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
    </TR>
    <TR class=Line style="height:1px;"><TD   colspan="3"  style="padding:0;"></TD></TR>

<%

	if ("".equals(shortName)) {
       rs.executeSql("select * from workflow_customQuerytype order by showorder,typename");
    } else {
    	rs.executeSql("select * from workflow_customQuerytype where typename like '%"+shortName+"%' order by showorder,typename");
    }
    int needchange = 0;
      while(rs.next()){
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><%if(isedit){%><a href="CustomQueryTypeEdit.jsp?id=<%=rs.getString("id")%>"><%=rs.getString("typename")%></a><%}else{%><%=rs.getString("typename")%><%}%></TD>
    <TD><%=rs.getString("typenamemark")%></TD>
    <TD><%=rs.getString("showorder")%></TD>
  </TR>
<%
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>
 </TBODY>
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
<script type="text/javascript">
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function donewQueryType(){
        enableAllmenu();
        location.href="/workflow/workflow/CustomQueryTypeAdd.jsp";        
    }
</script>

</BODY></HTML>
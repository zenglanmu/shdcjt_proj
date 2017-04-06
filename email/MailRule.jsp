<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" scope="page" />

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
</head>

<script language="javascript">
 function  submitForRule(){
    var chk = document.getElementsByName("isActive");
	var ruleIds = "";
	for(var i=0;i<chk.length;i++){
		if(chk[i].checked){
			ruleIds += chk[i].value + ",";
		}
	}
	fMailRule.activeRuleIds.value = ruleIds;
     
     fMailRule.submit();
 }
 
 function redirect(url){    
    if(url == "" || url == undefined){
      <%if(showTop.equals("")) {%>
			url = "MailRuleAdd.jsp";
		<%} else if(showTop.equals("show800")) {%>
			url = "MailRuleAdd.jsp?showTop=show800";
		<%}%>
    }
    window.location.href = url;
 }
</script>

<body>

<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitForRule(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table style="width:98%;height:92%;border-collapse:collapse"  align="center">

<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form id="fMailRule" method="post" action="MailRuleOperation.jsp">
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<input type="hidden" name="operation" value="active" />
<input type="hidden" name="activeRuleIds" id="activeRuleIds" value="" />
<table class="liststyle" cellspacing="1">
<tr class="header">
<th style="width:50%"><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())%></th>
<th style="width:20%"><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage())%></th>
<th style="width:10%"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></th>
<th style="width:10%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
</tr>

<%
int i = 0;
rs.executeSql("SELECT a.*, b.accountName FROM MailRule a, MailAccount b "
	+"where a.userId=b.userId AND a.userId="+user.getUID()+" AND a.mailAccountId=b.id "
	+"union "
	+"select a.*, '"+SystemEnv.getHtmlLabelName(30932,user.getLanguage())+"' as accountName "
		
		+"  from MailRule a "
	+"where a.userId="+user.getUID()+" and a.mailAccountId=-1 ");
while(rs.next()){
%>
<tr <%if((i%2)!=0){out.println("style='background-color:#EEE'");}%>>
<%if(showTop.equals("")) {%>
	<td><a href="javascript:redirect('MailRuleEdit.jsp?id=<%=rs.getInt("id")%>')"><%=rs.getString("ruleName")%></a></td>
<%} else if(showTop.equals("show800")) {%>
	<td><a href="javascript:redirect('MailRuleEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>')"><%=rs.getString("ruleName")%></a></td>
<%}%>
<td><%=rs.getString("accountName")%></td>
<td><input type="checkbox" name="isActive" value="<%=rs.getInt("id")%>" <%if(rs.getString("isActive").equals("1"))out.print("checked");%> /></td>
<td>
	<%if(showTop.equals("")) {%>
	<span class="href" onclick="javascript:redirect('MailRuleEdit.jsp?id=<%=rs.getInt("id")%>')"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
	<span class="href" onclick="javascript:if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){redirect('MailRuleOperation.jsp?id=<%=rs.getInt("id")%>')}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
	<%} else if(showTop.equals("show800")) {%>
	<span class="href" onclick="javascript:redirect('MailRuleEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>')"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
	<span class="href" onclick="javascript:if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){redirect('MailRuleOperation.jsp?showTop=show800&id=<%=rs.getInt("id")%>')}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
	<%}%>
</td>
</tr>
<%i++;}%>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</TABLE>
	</td>
</tr>

</table>
</body>

</html>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));
%>

<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />

<script language="javascript">
 function  MailRuleSubmit(){
     
     if(check_form(fMailRule,'ruleName')){
		fMailRule.submit();
	}
 }
 
 function redirect(url){    
    if(url == "" || url == undefined){
    <%if(showTop.equals("")) {%>
		url = "MailRule.jsp";
	<%} else if(showTop.equals("show800")) {%>
		url = "MailRule.jsp?showTop=show800";
	<%}%>
    }
    window.location.href = url;
 }
 
 
</script>

<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailRuleSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript" src="/js/prototype.js"></script>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailRuleOperation.jsp" id="fMailRule" name="fMailRule">
<input type="hidden" name="operation" value="add" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<input type="hidden" name="ruleConditionRowIndex" id="ruleConditionRowIndex" value="10," />
<input type="hidden" name="ruleActionRowIndex" id="ruleActionRowIndex" value="16," />
<table id="tblMailRule" class="ViewForm">
<colgroup>
<col width="25%">
<col width="75%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19834,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="ruleName" class="inputstyle" onchange="checkinput('ruleName','ruleNameSpan')" />
		<SPAN id="ruleNameSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage())%></td>
	<td class="Field">
		<input type="radio" id="matchAll0" name="matchAll" value="0" checked="checked" /><label for="matchAll0" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage())%></label>
		<input type="radio" id="matchAll1" name="matchAll" value="1" /><label for="matchAll1" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19837,user.getLanguage())%></label>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19838,user.getLanguage())%></td>
	<td class="Field">
		<input type="radio" id="applyTime0" name="applyTime" value="0" checked="checked" /><label for="applyTime0" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19839,user.getLanguage())%></label>
		<input type="radio" id="applyTime1" name="applyTime" value="1" /><label for="applyTime1" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19840,user.getLanguage())%></label>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage())%></td>
	<td class="Field">
		<select name="mailAccountId">
		<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
		<option value="<%=rs.getInt("id")%>"><%=rs.getString("accountName")%></option>
		<%}%>
		</select>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
</tbody>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
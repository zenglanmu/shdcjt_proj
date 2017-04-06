<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util"%>
<HTML>
<HEAD>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";

	String votingid = Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())+ ",javascript:doSave(),_top} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp"%>
<FORM id=frmmain name=frmmain action="VotingRemindersOperation.jsp" method=post>
<input type="hidden" name="votingid" value="<%=votingid%>">
<input type="hidden" name="method" value="reminders">
<TABLE width=100% height=100% border="0" cellspacing="0">
	<colgroup>
		<col width="10">
		<col width="*">
		<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td valign="top" colspan="3">
		  <TABLE class=Shadow>
			<tr>
			  <td valign="top">
				<table Class=viewForm>
					<COLGROUP>
					<COL width="15%">
			  		<COL width="85%">							
					<tr>
						<td><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></td>
						<td class=Field>
						  <INPUT type=radio name="sendtype" value="1" checked><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
						  <INPUT type=radio name="sendtype" value="0"><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
						</td>
					</tr>
					<tr style="height: 1px!important;"><td class=line colSpan=2></td></tr>	
					<tr>
						<td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
						<td class=Field>
						  <TEXTAREA class=inputStyle NAME=decision ROWS=15 STYLE="width:100%"></TEXTAREA>
						</td>
					</tr>
					<tr style="height: 1px!important;"><td class=line colSpan=2></td></tr>									
	            </table>
              </td>	             
           </tr>
        </TABLE>
     </td>
  </tr>
</TABLE>
</form>
</body>
<script language=javascript>
function doSave(){
	document.frmmain.submit();
}
</script>
</html>

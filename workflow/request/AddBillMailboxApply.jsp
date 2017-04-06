<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillMailboxApplyOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<%
    String mailidfield="";
%>
<%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
<table class=liststyle cellspacing=1   border=1 width="80%">
	<tr> 
      <td colspan=2 align=center bgcolor="lightblue"><b><%=SystemEnv.getHtmlLabelName(1022,user.getLanguage())%></b></td>
    </tr> 
    <tr> 
      <td colspan=2>
<b><%=SystemEnv.getHtmlLabelName(16659,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16661,user.getLanguage())%><p>
<b><%=SystemEnv.getHtmlLabelName(16660,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16662,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16663,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16664,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16665,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16666,user.getLanguage())%><p>
      </td>
    </tr>
    </table>    
</form>
 

<script language=vbs>
sub getTheDate(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script>

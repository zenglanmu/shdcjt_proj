<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/web/inc/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>

<BODY>
<FORM id=weaver action="MailListForCRMOperation.jsp" method=post>
<input type="hidden" name="method" value="save">
<BUTTON class=btnNew accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>


<TABLE class=ListShort>
<TBODY>
<TR class=Header>
	<th width=30>ักิ๑</th>
	<th>ร๛ณฦ</th>
	<th>ร่ส๖</th>
</TR>


<%
RecordSet.executeSql("select * from webMailList order by id ");
boolean isLight = false;
boolean isCheck = false;
String mailListUserTemp1 = "" ;
String CustomerIDTemp = ""+user.getUID()+"";
while(RecordSet.next())
{
	isCheck = false;
	mailListUserTemp1 = RecordSet.getString("userList");
	if (!mailListUserTemp1.equals("")) 
	{
		mailListUserTemp1 ="," + mailListUserTemp1 + "," ;
		if ((mailListUserTemp1.indexOf(CustomerIDTemp)!=-1)&&(user.getLogintype().equals("2")))
		{
			isCheck = true ;
		}
	}
	if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><input type=checkbox name=webIDs value="<%=RecordSet.getString("id")%>" <%if(isCheck){%>checked<%}%>></th>
			<td>
			<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
			</td>
			<td><%=Util.toScreen(RecordSet.getString("mailDesc"),user.getLanguage())%></td>	
    </tr> 
<%	
	isLight = !isLight;
}%>
	  </TBODY>
	  </TABLE>
</FORM>

</body>
</html>



<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.splitepage.transform.SptmForSms" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />

<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver.js"></script>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<%@ include file="/docs/docs/DocCommExt.jsp"%>
<script type="text/javascript" src="/js/WeaverTableExt.js"></script>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />
</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);

String useridname=ResourceComInfo.getResourcename(userid+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String messagetype=Util.fromScreen(request.getParameter("messagetype"),user.getLanguage());
String messagestatus=Util.fromScreen(request.getParameter("messagestatus"),user.getLanguage());
String isDelete = Util.null2String(request.getParameter("isDelete"));

String messageIDs = Util.null2String(request.getParameter("messageIDs"));
if("true".equals(isDelete) && null != messageIDs && !"".equals(messageIDs)){    
    messageIDs = messageIDs.substring(0, messageIDs.length() - 1);
    //System.out.println(messageIDs);
    String temStr = "update SMS_Message set isdelete='1' where id in ("+messageIDs+")";
    //System.out.println(temStr);
    RecordSet.executeSql(temStr);
}

String sqlwhere=" where isdelete='0' ";
if(userid!=0){
	sqlwhere+=" and userid="+userid;
}
if(!fromdate.equals("")){
	sqlwhere+=" and finishtime>='"+fromdate+" 00:00:00'";
}
if(!enddate.equals("")){
	sqlwhere+=" and finishtime<='"+enddate+" 23:59:59'";
}

if(!messagetype.equals("")){
	sqlwhere+=" and messagetype = '"+messagetype+"'";

}
if(!messagestatus.equals("")){
	sqlwhere+=" and messagestatus = '"+messagestatus+"'";
}


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16443,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name=frmmain method=post action="ViewMessage.jsp">
<input type="hidden" name="isDelete" value="false">
<input type="hidden" name="messageIDs" value="">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


			<table class=ViewForm>
			  <colgroup>
			  <col width="10%">
			  <col width="30%">
			  <col width="10%">
			  <col width="15%">
			  <col width="10%">
			  <col width="25%">
			  <tbody>
			  <tr>

			  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
			  <td class=field>
			  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=fromdate%>>
			  －&nbsp;&nbsp;<BUTTON type=button class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="enddate" value=<%=enddate%>>

			  </td>
              <td><%=SystemEnv.getHtmlLabelName(18523,user.getLanguage())%></td>
              <td>
              <select class=saveHistory id=messagestatus  name=messagestatus>
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=0 <%if(messagestatus.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18525,user.getLanguage())%></option>
				<option value=1 <%if(messagestatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18524,user.getLanguage())%></option>
				<option value=2 <%if(messagestatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18966,user.getLanguage())%></option>
			 </select>
              </td>
			  <td><%=SystemEnv.getHtmlLabelName(18527,user.getLanguage())%></td>
			  <td class=field>
			  <select class=saveHistory id=messagetype  name=messagetype>
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=2 <%if(messagetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18528,user.getLanguage())%></option>
				<option value=1 <%if(messagetype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%></option>
			 </select>
			  </td>
			  </tr>
			  <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
			<script language=vbs>		
			sub onShowuserid()
				id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
				if (Not IsEmpty(id)) then
				if id(0)<> "" then
				useridspan.innerHtml = "<A href='Hrmuserid.jsp?id="&id(0)&"'>"&id(1)&"</A>"
				frmmain.userid.value=id(0)
				else
				useridspan.innerHtml = ""
				frmmain.userid.value=""
				end if
				end if
			end sub
			</script>
			</tbody>
			</table>
			<BR>
			 <%@ page import="weaver.common.xtable.*" %>
			 <%
				ArrayList xTableColumnList=new ArrayList();
			 
				TableColumn xTableColumn_messageType=new TableColumn();
				xTableColumn_messageType.setColumn("messageType");
				xTableColumn_messageType.setDataIndex("messageType");
				xTableColumn_messageType.setHeader(SystemEnv.getHtmlLabelName(16975,user.getLanguage()));
				xTableColumn_messageType.setTransmethod("weaver.splitepage.transform.SptmForSms.getSend");
				xTableColumn_messageType.setPara_1("column:messageType");
				xTableColumn_messageType.setPara_2("column:UserType+column:UserID+column:sendNumber+column:toUserType+column:toUserID");
				xTableColumn_messageType.setSortable(false);				
				xTableColumn_messageType.setHideable(false);
				xTableColumn_messageType.setWidth(0.15); 
				xTableColumnList.add(xTableColumn_messageType);		
				
				TableColumn xTableColumn_2=new TableColumn();
				xTableColumn_2.setColumn("messageType2");
				xTableColumn_2.setDataIndex("messageType2");
				xTableColumn_2.setHeader(SystemEnv.getHtmlLabelName(15525,user.getLanguage()));
				xTableColumn_2.setTransmethod("weaver.splitepage.transform.SptmForSms.getRecieve");
				xTableColumn_2.setPara_1("column:messageType");
				xTableColumn_2.setPara_2("column:toUserType+column:toUserID+column:recieveNumber+column:UserType+column:UserID");
				xTableColumn_2.setSortable(false);
				xTableColumn_2.setHideable(false);
				xTableColumn_2.setWidth(0.15); 
				xTableColumnList.add(xTableColumn_2);
				
				TableColumn xTableColumn_3=new TableColumn();
				xTableColumn_3.setColumn("message");
				xTableColumn_3.setDataIndex("message");
				xTableColumn_3.setHeader(SystemEnv.getHtmlLabelName(18529,user.getLanguage()));
				xTableColumn_3.setSortable(true);
				xTableColumn_3.setHideable(false);
				xTableColumn_3.setWidth(0.31); 
				xTableColumnList.add(xTableColumn_3);		
				
				TableColumn xTableColumn_4=new TableColumn();
				xTableColumn_4.setColumn("messageStatus");
				xTableColumn_4.setDataIndex("messageStatus");
				xTableColumn_4.setHeader(SystemEnv.getHtmlLabelName(18523,user.getLanguage()));
				xTableColumn_4.setTransmethod("weaver.splitepage.transform.SptmForSms.getPersonalViewMessageStatus");
				xTableColumn_4.setPara_1("column:messageStatus");
				xTableColumn_4.setPara_2(user.getLanguage()+"+column:isdelete");				
				xTableColumn_4.setSortable(true);
				xTableColumn_4.setHideable(false);
				xTableColumn_4.setWidth(0.12); 
				xTableColumnList.add(xTableColumn_4);	
				
				TableColumn xTableColumn_5=new TableColumn();
				xTableColumn_5.setColumn("messageType3");
				xTableColumn_5.setDataIndex("messageType3");
				xTableColumn_5.setHeader(SystemEnv.getHtmlLabelName(18527,user.getLanguage()));
				xTableColumn_5.setTransmethod("weaver.splitepage.transform.SptmForSms.getMessageType");
				xTableColumn_5.setPara_1("column:messageType");
				xTableColumn_5.setPara_2(""+user.getLanguage());				
				xTableColumn_5.setSortable(true);
				xTableColumn_5.setHideable(false);
				xTableColumn_5.setWidth(0.12); 
				xTableColumnList.add(xTableColumn_5);	
				
				TableColumn xTableColumn_6=new TableColumn();
				xTableColumn_6.setColumn("finishTime");
				xTableColumn_6.setDataIndex("finishTime");
				xTableColumn_6.setHeader(SystemEnv.getHtmlLabelName(18530,user.getLanguage()));
				xTableColumn_6.setSortable(true);
				xTableColumn_6.setHideable(false);
				xTableColumn_6.setWidth(0.12); 
				xTableColumnList.add(xTableColumn_6);
				
				
				TableSql xTableSql=new TableSql();
				xTableSql.setBackfields("*");
				xTableSql.setPageSize(10);
				xTableSql.setSqlform("SMS_Message");
				xTableSql.setSqlwhere(sqlwhere);
				xTableSql.setSqlgroupby("");
				xTableSql.setSqlprimarykey("id");
				xTableSql.setSqlisdistinct("true");
				xTableSql.setSort("id");
				//xTableSql.setSqlisprintsql("true");
				xTableSql.setDir(TableConst.DESC);
				
				Table xTable=new Table(request); 
				xTable.setTableId("xTable_ViewMessage");//必填而且与别的地方的Table不能一样
				xTable.setTableGridType(TableConst.CHECKBOX);								
				xTable.setTableSql(xTableSql);
				xTable.setTableColumnList(xTableColumnList);
				xTable.setUser(user);
				xTable.setTableNeedRowNumber(false);
				xTable.setColumnWidth(50);
				out.println(xTable.toString());	
			 %>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

</form>

</body>
<script language="javascript">
function doDelete(){
    if(isdel()){
        jQuery("input[name=isDelete]").val("true");
        jQuery("input[name=messageIDs]").val(_table._xtable_CheckedCheckboxId());
        document.forms[0].submit();
    }
}
function doSubmit()
{
	document.forms[0].submit();
}
</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>


<script  language="javascript">
Ext.onReady(function(){
    Ext.get('loading').fadeOut();
});
</script>
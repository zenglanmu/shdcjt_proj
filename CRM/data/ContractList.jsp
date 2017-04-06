<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
    String CustomerID = request.getParameter("CustomerID");
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
    //out.print(CustomerID);
	RecordSet.executeProc("CRM_Contract_Select",CustomerID);

%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(614,user.getLanguage()) + " : " + "<a href=\"#\" onclick=\"javascript:parent.location='/CRM/data/ViewCustomer.jsp?CustomerID=" + CustomerID + "'\">" +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage()) + "</a>";
String needfav ="1";
String needhelp ="";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


/*check right begin*/

String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;	  
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;		
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
    canview=true;
    if(sharelevel>1) canedit=true;
}

/*check right end*/

%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>



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
		<%if(!isfromtab){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">
<% if (canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<% } %>
<%
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:comeBack("+CustomerID+"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
 </DIV>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="70%">
  <COL width="30%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage()) %>
  </th>
  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=2 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{ 
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="/CRM/data/ContractView.jsp?CustomerID=<%=CustomerID%>&id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("creater")),user.getLanguage())%></TD>
	</TR>
<%
	}
%>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY>
</HTML>
<script type="text/javascript">
function doAdd(){
	parent.location='/CRM/data/ContractAdd.jsp?CustomerID=<%=CustomerID%>';
}
function comeBack(customerID){
	if(parent){
		location="/CRM/data/ViewCustomerTotal.jsp?CustomerID="+customerID;
	}else{
		location="/CRM/data/ViewCustomer.jsp?CustomerID="+customerID;
	}
}
</script>

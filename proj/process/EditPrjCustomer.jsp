<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />


<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String id = Util.null2String(request.getParameter("id"));
String type = Util.null2String(request.getParameter("type"));
String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;	
			ismanager=true;  
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;	
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;	
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }	 
	 }
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdPRJ.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+" - "+"<a href='/proj/data/ViewProject.jsp?log=n&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
String customerid="";
String powerlevel="";
String reasondesc="";
RecordSet.executeProc("Prj_Customer_FindByID",id);
if(RecordSet.next()){
customerid=RecordSet.getString("customerid");
powerlevel=RecordSet.getString("powerlevel");
reasondesc=RecordSet.getString("reasondesc");
}
%>
<FORM id=weaver action="/proj/process/PrjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="type" value="<%=type%>">

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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=35%>
  <COL width="15%">
  <COL width=35%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
   
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowCustomer()"></button> 
              <span class=inputstyle id=Customerspan><%=CustomerInfoComInfo.getCustomerInfoname(customerid)%></span> 
              <input type=hidden name=CustomerID value="<%=customerid%>">
		  </TD>
          <TD><!--<%=SystemEnv.getHtmlLabelName(1291,user.getLanguage())%> --></TD>
          <TD >
				<!-- <select class=inputstyle  name=powerlevel>
				  <option value="0" <%if(powerlevel.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
				  <option value="1" <%if(powerlevel.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1292,user.getLanguage())%>
				  <option value="2" <%if(powerlevel.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1293,user.getLanguage())%>
				</SELECT> -->
				<input type="hidden" name=powerlevel value="<%=powerlevel%>">
		  </TD>
        </TR>  <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>

           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=reasondesc class=inputstyle maxLength=100 style="width=100%" value="<%=reasondesc%>">
		  </TD>
        </TR><TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
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

</FORM>


<script language=vbs>

sub onShowCustomer()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.CustomerID.value=id(0)
	else 
	Customerspan.innerHtml = ""
	weaver.CustomerID.value="0"
	end if
	end if
end sub

</script>
 <script language="javascript">
function submitClear()
{
if(isdel()){
		document.all("method").value="del" ;
		weaver.submit();
		}
}
</script>

</body>
</html>



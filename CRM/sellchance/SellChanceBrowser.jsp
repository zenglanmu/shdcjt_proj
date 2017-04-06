<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=20;
String resourcename=ResourceComInfo.getResourcename(resource+"");

String subject=Util.fromScreen(request.getParameter("subject"),user.getLanguage());
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String preyield=Util.null2String(request.getParameter("preyield"));
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());

String sqlwhere="";

if(!subject.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.subject like "+"'%"+subject+"%'";
	else	sqlwhere+=" and t1.subject like "+"'%"+subject+"%'";
}

if(!customer.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.customerid="+customer;
	else	sqlwhere+=" and t1.customerid="+customer;
}

if(!sellstatusid.equals("")){
	if(sqlwhere.equals(""))
        sqlwhere+=" where t1.sellstatusid="+sellstatusid;
	else
        sqlwhere+=" and t1.sellstatusid="+sellstatusid;
}

if(!preyield.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.preyield>="+preyield;
	else	sqlwhere+=" and t1.preyield>="+preyield;
}

if(!preyield_1.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.preyield<="+preyield_1;
	else	sqlwhere+=" and t1.preyield<="+preyield_1;
}

if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.endtatusid ="+endtatusid;
	else	sqlwhere+=" and t1.endtatusid ="+endtatusid;
}

String sqlstr = "";
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
String temptable = "temptable"+ Util.getRandom() ;

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
        sqlstr = "create table "+temptable+"  as select * from (select distinct t1.id,t1.subject,t1.preyield,t1.createdate,t1.sellstatusid,t1.endtatusid,t1.customerid,t1.predate  from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid order by t1.predate desc ) where rownum<"+ (pagenum*perpage+2);

	}else{
        sqlstr = "create table "+temptable+"  as select * from (select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + "  order by t1.predate desc ) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as (select distinct t1.* from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select distinct t1.* from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid  order by t1.predate desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		sqlstr = "create table "+temptable+"  as (select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + "  order by t1.predate desc  fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select distinct top "+(pagenum*perpage+1)+" t1.id,t1.subject,t1.preyield,t1.createdate,t1.sellstatusid,t1.endtatusid,t1.customerid,t1.predate into "+temptable+" from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0  and t3.id= t1.customerid and t1.customerid = t2.relateditemid ORDER BY t1.predate desc " ;
	}else{
        sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_SellChance t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + " ORDER BY t1.predate desc " ;
	}

}
RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(distinct(id)) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+"  ORDER BY predate) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1) ;	
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select   * from "+temptable+" ORDER BY predate fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+" ORDER BY predate,id ";
}
RecordSet.executeSql(sqltemp);
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="SellChanceBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value="<%=Util.null2String(request.getParameter("sqlwhere"))%>">
	<input type="hidden" name="pagenum" value="">
	<DIV align=right style="display:none">
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	</DIV>
	<table width=100% class=ViewForm>
	<colgroup>
	<col width="20%">
	<col width="30%">
	<col width="20%">
	<col width="30%">
	<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
		<td class=Field><INPUT class=InputStyle size=18 id="subject" name="subject" value="<%=subject%>"></td>
    <TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </TD>
    <TD class=Field><INPUT text class=InputStyle maxLength=20 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
     -- <INPUT text class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
    </TD>
	</tr>
	<tr>
    <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
    <TD class=Field>
	    <INPUT  class=wuiBrowser _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customer%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name="customer" value="<%=customer%>">
    </TD>
	  <%if(!user.getLogintype().equals("2")){%>
		<td><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
		<td class=field>
			<input class="wuiBrowser" type=hidden _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=resource%>'><%=Util.toScreen(resourcename,user.getLanguage())%></a>" _displayTemplate="<A href='HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" name=viewer value="<%=resource%>">
		</td>
	  <%}%>
	</tr>
	<tr>
	  <TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </TD>
    <TD class=Field>
	    <select text class=InputStyle id=sellstatusid name=sellstatusid>
	      <option value="" <%if(sellstatusid.equals("")){%> selected<%}%> ></option>
	    <%  
	    String theid="";
	    String thename="";
	    String sql="select * from CRM_SellStatus ";
	    RecordSet3.executeSql(sql);
	    while(RecordSet3.next()){
	        theid = RecordSet3.getString("id");
	        thename = RecordSet3.getString("fullname");
	        if(!thename.equals("")){
	        %>
	    <option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
	    <%}
	    }%>
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TD>
    <TD class=Field>
	    <select text class=InputStyle id=endtatusid  name=endtatusid>
	    <option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
	    <option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
	    <option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
	    <option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
    </TD>
	</tr>
	</table>
	<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
	<colgroup>
	<col width="20%">
	<col width="17%">
	<col width="17%">
	<col width="13%">
	<col width="13%">
	<col width="20%">
	<TR class=DataHeader>
	<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	<TH><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></TH>
	<th><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></th>
	<TH><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
	</tr><TR class=Line style="height: 1px"><TH colSpan=5></TH></TR>
	<%
	int i=0;
	int totalline=1;
	if(RecordSet.last()){
		do{
		String ids = RecordSet.getString("id");
		if(i==0){
			i=1;
	%>
	<TR class=DataLight>
	<%
		}else{
			i=0;
	%>
	<TR class=DataDark>
	<%
	}
	%>
		<TD style="display:none"><A HREF=#><%=ids%></A></TD>
		<TD><%=Util.toScreen(RecordSet.getString("subject"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("preyield"),user.getLanguage())%></td></TD>
		<TD><%=Util.toScreen(RecordSet.getString("createdate"),user.getLanguage())%></TD>
		<TD>
    <%
        String sellstatusid_1=Util.null2String(RecordSet.getString("sellstatusid"));
        String statusname = "";
        if(!sellstatusid_1.equals("")){
	        String sql_5="select * from CRM_SellStatus where id ="+sellstatusid_1;
	        RecordSet2.executeSql(sql_5);
	        if(RecordSet2.next()){
	        	statusname = RecordSet2.getString("fullname");
	        }
        }
    %>
     
    <%=Util.toScreen(statusname,user.getLanguage())%>
		</TD>
    <TD>
    	<%
				String endtatusid0 =RecordSet.getString("endtatusid");         
    	%>
			<%if(endtatusid0.equals("0")){%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
			<%if(endtatusid0.equals("1")){%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%><%}%>
			<%if(endtatusid0.equals("2")){%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%><%}%>
    </TD>  
		<TD><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid")),user.getLanguage())%></TD>
	</TR>
	<%
		if(hasNextPage){
			totalline+=1;
			if(totalline>perpage)	break;
		}
	}while(RecordSet.previous());
	}
	RecordSet.executeSql("drop table "+temptable);
	%>
	</TABLE>
	<table align=right>
	<tr style="display:none">
	   <td>&nbsp;</td>
	   <td>
		   <%if(pagenum>1){%>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
				<button type=submit class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
		   <%}%>
	   </td>
	   <td>
		   <%if(hasNextPage){%>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
				<button type=submit class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
		   <%}%>
	   </td>
	   <td>&nbsp;</td>
	</tr>
	</table>
</FORM>
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
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}

</script>
</BODY></HTML>

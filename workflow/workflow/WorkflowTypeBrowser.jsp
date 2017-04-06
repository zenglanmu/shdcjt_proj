<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));//added by XWJ on 2005-03-16 for td:1549
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
int typeid=Util.getIntValue(request.getParameter("typeid"),0);
String sqlwhere = " where (istemplate='0' or istemplate is null) ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}

	if(ishead==0){
		ishead = 1;
		sqlwhere += " and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}

if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}

//added by XWJ on 2005-03-16 for td:1549
if("contract".equals(propertyOfApproveWorkFlow)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " and formid = 49 and isbill = 1";
	}
	else{
	  sqlwhere += " and formid = 49 and isbill = 1";
	}
}
//System.out.println(sqlwhere);
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>



<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowTypeBrowser.jsp" method=post>

<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="typeid" value='<%=typeid%>'>
<%--added by XWJ on 2005-03-16 for td:1549--%>
<input type=hidden name=propertyOfApproveWorkFlow value="<%=propertyOfApproveWorkFlow%>">

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
		<td valign="top" width="100%">



<table width=100% class="viewform">
<TR>
<TD colSpan=6><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%>:<%=WorkTypeComInfo.getWorkTypename(""+typeid)%></TD>
<!-- TD  class=field colspan=3>
<select class=inputstyle  name=typeid size=1 style="width:20%" onChange="SearchForm.submit()">
    	  	<option value="0">&nbsp;</option>
    	  	<%
		    while(WorkTypeComInfo.next()){
		     	String checktmp = "";
		     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
		     		checktmp=" selected";
		%>
		<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		<%
		}
		%>
    	  </select>
</TD-->
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD ><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle name=fullname value="<%=fullname%>"></TD>
<TD ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle  name=description value="<%=description%>"></TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>

<TR class=Line style="height:1px;"><th colspan="3" ></Th></TR> 
<%
int i=0;


//sqlwhere = "select * from workflow_base "+sqlwhere;

String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=20;
/**
if(RecordSet.getDBType().equals("oracle")){
		sqlstr = "create table "+temptable+"  as select * from (select * from workflow_base " + sqlwhere + "  order by id desc) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
		sqlstr = "create table "+temptable+"  as (select * from workflow_base ) definition only ";

        RecordSet.executeSql(sqlstr);

       sqlstr = "insert  into "+temptable+" (select * from workflow_base " + sqlwhere + "order by id  desc fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		sqlstr = "select distinct top "+(pagenum*perpage+1)+" *  into "+temptable+" from workflow_base  " + sqlwhere + " order by id desc" ;
}
*/
//RecordSet.executeSql(sqlstr);
//System.out.println(sqlstr+"*********");
String temptable1="";

if(RecordSet.getDBType().equals("oracle")){
    temptable1="( select * from (select * from workflow_base " + sqlwhere + "  order by id desc) where rownum<"+ (pagenum*perpage+2) +")  s";
	
}else if(RecordSet.getDBType().equals("db2")){
    temptable1=" (select * from workflow_base " + sqlwhere + "order by id  desc fetch  first "+(pagenum*perpage+1)+" rows only ) as s" ;
    
}else{

    temptable1="( select distinct top "+(pagenum*perpage+1)+" * from workflow_base  " + sqlwhere + " order by id desc ) as s" ;

}

//System.out.print("Select count(id) RecordSetCounts from "+temptable1);
RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable1);
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
   
	sqltemp="select * from (select * from  "+temptable1+" order by id ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
   
    sqltemp="select  * from "+temptable1+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
    
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by id ";
}

//out.println("select * from (select * from  "+temp+" order by id ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1));
//2007-9-112007-9-112007-9-112007-9-11System.out.print(sqltemp);
RecordSet.execute(sqltemp);
	int totalline=1;
	if(RecordSet.last()){
	do{
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
	<TD><A HREF=#><%=RecordSet.getString(1)%></A></TD>
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	
</TR>
              <%   if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}while(RecordSet.previous());
				}
				//RecordSet.executeSql("drop table "+temptable);
				%>
					
						<%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit  style="display:none" class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
						<%}%>
						<%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
						<button type=submit style="display:none" class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
						<%}%>
						 
		
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
</FORM></BODY></HTML>

<<script type="text/javascript">
//<!--

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

});
function submitClear() {
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
//-->
</script>

 <script language="javascript">
function submitData()
{btnok_onclick();
}

function onSubmit() {
	$G("SearchForm").submit()
}
function onReset() {
	$G("SearchForm").reset()
}
</script>
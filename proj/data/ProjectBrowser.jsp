<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
}
if(!prjtype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.prjtype = "+ prjtype ;
	}
	else
		sqlwhere += " and t1.prjtype = "+ prjtype;
}
if(!worktype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.worktype = "+ worktype ;
	}
	else
		sqlwhere += " and t1.worktype = "+ worktype ;
}
if(!manager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager = "+ manager ;
	}
	else
		sqlwhere += " and t1.manager = "+ manager;
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status =" + status +" " ;
	}
	else
		sqlwhere += " and t1.status =" + status +" " ;
}
//String sqlstr = "select id,name,description,prjtype,worktype,manager,status from Prj_ProjectInfo " + sqlwhere;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
if(pagenum <= 0){
	pagenum = 1;
}
int perpage=10;
//*添加判断权限的内容--new--begin

String temptable = "prjstemptable"+ Util.getRandom() ;
String SearchSql = "";
String SqlWhere = "";

if(!sqlwhere.equals("")){
	SqlWhere = sqlwhere +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}else{
	SqlWhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}

if(RecordSet.getDBType().equals("oracle")){
	SearchSql = "create table "+temptable+"  as select * from (select  t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status from Prj_ProjectInfo  t1,PrjShareDetail  t2  "+ SqlWhere +" order by t1.id desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
	SearchSql = "create table "+temptable+"  as (select  t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status from Prj_ProjectInfo  t1,PrjShareDetail  t2 ) definition only ";

    RecordSet.executeSql(SearchSql);
 
    SearchSql = "insert into "+temptable+" (select  t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status  from Prj_ProjectInfo  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc fetch first "+(pagenum*perpage+1)+" rows only )"; 
}else{
	SearchSql = "select top "+(pagenum*perpage+1)+" t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status into "+temptable+" from Prj_ProjectInfo  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc"; 
}
 

RecordSet.executeSql(SearchSql);

//添加判断权限的内容--new--end*/

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
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
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select  * from "+temptable+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id ";
}
RecordSet.executeSql(sqltemp);

RecordSet.executeSql("drop table "+temptable);

%>
<BODY  scroll="auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenuHeight += RCMenuHeightStep ; //取消右键按钮 看不到按钮，只能查看3个！

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

if(pagenum>1){ RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:perPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep; };
if(hasNextPage) { RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep;} ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ProjectBrowser.jsp" method=post>
  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">


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



<table width=100% class=viewform>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input name=name value="<%=name%>" class="InputStyle"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select  class=inputstyle id=status name=status>
		<option value=""></option>
		<% while(ProjectStatusComInfo.next()) {  
			String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
		%>
          <option value=<%=tmpstatus%> <% if(tmpstatus.equals(status)) {%>selected<%}%>>
		  <%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage()),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select  class=inputstyle id=prjtype name=prjtype>
        <option value=""></option>
       	<%
       	while(ProjectTypeComInfo.next()){
       	%>		  
          <option value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%if(prjtype.equalsIgnoreCase(ProjectTypeComInfo.getProjectTypeid())) {%>selected<%}%>><%=ProjectTypeComInfo.getProjectTypename()%></option>
            <%}%>
        </select>
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
      <TD width=35% class=field>
      <select  class=inputstyle id=worktype name=worktype>
        <option value=""></option>
       	<%
       	while(WorkTypeComInfo.next()){
       	%>		  
          <option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%if(worktype.equalsIgnoreCase(WorkTypeComInfo.getWorkTypeid())) {%>selected<%}%>><%=WorkTypeComInfo.getWorkTypename()%></option>
            <%}%>
        </select>
      </TD>
</tr><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<%if(!user.getLogintype().equals("2")){%>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
<TD width=35% class=field>
     <input type=hidden name=manager class="wuiBrowser" id="manager" value="<%=manager%>" _displayText="<%=ResourceComInfo.getLastname(manager)%>"
     	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
  </td>
   <TD width=15%></TD>
  <TD width=35% class=field></TD>
</tr><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<%}%>
</table>
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1"  width="100%">

<TR class=DataHeader>
<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
      <TH ><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TH>      
	  <TH ><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TH>
      <TH ><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TH>
      <TH ><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TH>
      <TH ><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TH></tr>
	  <TR class=Line style="height:1px;"><Th colspan="5" ></Th></TR> 
<%
int i=0;
int totalline=1;
if(RecordSet.last()){
	do{
	String ids = RecordSet.getString("id");
	String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String prjtypes = RecordSet.getString("prjtype");
	String worktypes = RecordSet.getString("worktype");
	String managers = RecordSet.getString("manager");
	String statuss = RecordSet.getString("status");
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
	<td> <%=names%></TD>
	<TD><%=Util.toScreen(ProjectTypeComInfo.getProjectTypename(prjtypes),user.getLanguage())%>
	</TD>
	<TD><%=Util.toScreen(WorkTypeComInfo.getWorkTypename(worktypes),user.getLanguage())%></TD>
	<TD><%=Util.toScreen(ResourceComInfo.getResourcename(managers),user.getLanguage())%></TD>
	<TD><%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname(statuss)),user.getLanguage()),user.getLanguage())%></TD>
</TR>
<%
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}while(RecordSet.previous());
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

</FORM>
</BODY></HTML>


<script language="javascript">
function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
	}
function submitData()
{
	if (check_form(SearchForm,'')){
		document.getElementById("pagenum").value = "1";
		SearchForm.submit();
	}
}

function submitClear()
{
	btnclear_onclick();
}

function nextPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)+1 ;
	SearchForm.submit();	
}

function perPage(){
	document.getElementById("pagenum").value=parseInt(document.getElementById("pagenum").value)-1 ;
	SearchForm.submit();
}



function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
	 window.parent.parent.close();
	}
}
</script>
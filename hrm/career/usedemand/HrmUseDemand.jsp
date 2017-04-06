<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>	
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int numcount = 0;
  String sqlnum = "select count(id) from HrmUseDemand";
  rs.executeSql(sqlnum);
  rs.next();
  numcount = rs.getInt(1);

int perpage = 15;
String sqltemp ="";
String temptable = "temptable"+Util.getRandom();
String temptable1="";
if(rs.getDBType().equals("oracle")){
 	//sqltemp = "create table "+temptable+" as select * from (select t1.*  FROM HrmUseDemand t1 ,HrmJobTitles t2 where t1.DemandJobTitle=t2.ID order by referdate desc,t2.JobTitleName ) where rownum<"+(pagenum*perpage+1);
	temptable1="(select * from (select t1.*  FROM HrmUseDemand t1 ,HrmJobTitles t2 where t1.DemandJobTitle=t2.ID order by referdate desc,t2.JobTitleName ) where rownum<"+ (pagenum*perpage+1)+")  s";          
}else{
	//sqltemp = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from HrmUseDemand t1,HrmJobTitles t2 where t1.DemandJobTitle=t2.ID order by referdate desc,t2.JobTitleName";
	temptable1="(select top "+(pagenum*perpage+1)+" t1.*  from HrmUseDemand  t1,HrmJobTitles t2 where t1.DemandJobTitle=t2.ID order by referdate desc,t2.JobTitleName) as s";
}
//rs.executeSql(sqltemp);
//System.out.println("sqltemp:"+sqltemp);

//String sqlcount = "select count(id) from "+temptable;

rs.executeSql("Select count(id) RecordSetCounts from "+temptable1);
//rs.executeSql(sqlcount);

rs.next();
String sql;
int count = rs.getInt(1);
if(rs.getDBType().equals("oracle")){
	sql = "select * from ( Select * from "+temptable1+" order by referdate) where rownum<"+(count-(pagenum-1)*perpage+1);;
}else{
	sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable1+" order by referdate ";
}
boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/career/usedemand/HrmUseDemandAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmUseDemand:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+69+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(pagenum>1){
	RCMenu +="{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",HrmUseDemand.jsp?pagenum="+(pagenum-1)+",_self}";	
	RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
	RCMenu +="{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",HrmUseDemand.jsp?pagenum="+(pagenum+1)+",_self}";
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="15%">  
  <COL width="15%">
  <COL width="15%">
  <COL width="15%">
  <COL width="12%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
  </TR>

<% 
//String sql = "select * from HrmUseDemand order by referdate desc"; 
//System.out.println("sql:"+sql);
rs.executeSql(sql); 

int needchange = 0; 
while(rs.next()){ 
String	jobtitle=Util.null2String(rs.getString("demandjobtitle")); 
String  department = Util.null2String(rs.getString("demanddep")); 
String	num= Util.null2String(rs.getString("demandnum")); 
String  kind = Util.null2String(rs.getString("demandkind"));
String  date = Util.null2String(rs.getString("demandregdate"));
String  referman = Util.null2String(rs.getString("refermandid"));
int  status = Util.getIntValue(rs.getString("status"));
try{ 
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%} %>
   <TD>
   <a href="HrmUseDemandEdit.jsp?id=<%=rs.getString("id")%>"><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%></a>
   </TD>
   <td><%=DepartmentComInfo.getDepartmentname(department) %>
   </td>
   <TD><%=num%>
   </TD> 
   <TD><%=UseKindComInfo.getUseKindname(kind)%>
   </TD> 
   <TD><%=date%>
   </TD> 
   <td>
     <%if(status == 0){%><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%><%}%>
     <%if(status == 1){%><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%><%}%>
     <%if(status == 2){%><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%><%}%>
     <%if(status == 3){%><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%><%}%>
     <%if(status == 4){%><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%><%}%>
   </td>
   <td><%=ResourceComInfo.getResourcename(referman) %>
   </td>
  </TR>
<% 
  }catch(Exception e){ 
  System.out.println(e.toString()); 
  } 
} 
/*String sqldrop =" drop table "+temptable ;
 rs.executeSql(sqldrop);
*/
%>
<!--
<tr>
   <td colspan=8 align=right>
   <%if(pagenum>1){%><button class=btn accessKey=P onclick="location.href='HrmUseDemand.jsp?pagenum=<%=pagenum-1%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%>
   <%if(hasnext){%><button class=btn accessKey=N onclick="location.href='HrmUseDemand.jsp?pagenum=<%=pagenum+1%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
 </tr>
 -->
</TBODY>
</TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>
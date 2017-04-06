<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
boolean isoracle = rs.getDBType().equals("oracle") ;

boolean hasright = false;

if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
   hasright = true;
}
/*
Add by Huang Yu FOR BUG 237 ON May 9th ,2004
如果没有权限则判断是否和该招聘计划相关，即是否是通知人，负责人 或者是审核人
*/
String temptable1 ="";
String sqlStr ="";
if(!hasright){
     temptable1 = "temptable"+Util.getRandom();
     if(isoracle) {
         sqlStr = "CREATE TABLE "+temptable1+" AS SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3 WHERE t1.ID = t2.CareerPlanID(+) and t2.ID = t3.InviteID(+) and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }
     else{
         sqlStr ="SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate INTO "+temptable1+" From HrmCareerPlan t1 LEFT JOIN HrmCareerInvite t2 ON (t1.ID = t2.CareerPlanID) LEFT JOIN HrmCareerInviteStep t3 ON (t2.ID = t3.InviteID) WHERE (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }

     rs.executeSql(sqlStr);
     rs.executeSql("Select count(*) as count From "+temptable1) ;
     if(rs.next()){
		  if(rs.getInt("count") >0){
			 hasright = true;
		 }else{
			 rs.executeSql("drop table "+temptable1)    ;
		 }
	 }else{
			 rs.executeSql("drop table "+temptable1)    ;
	 }
    
}

if(!hasright){
     response.sendRedirect("/notice/noright.jsp");
     return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%


int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
String sqlnum ="";
if(!temptable1.equals(""))
    sqlnum = "select count(id) from "+temptable1;
else
    sqlnum = "select count(id) from HrmCareerPlan";

rs.executeSql(sqlnum);
if(rs.next()){
    numcount = rs.getInt(1);
}
  

/* 2004-06-17 号刘煜修改， 将排序规则设为按照 时间 和 id 的倒叙排列 */

String temptable = "temptable"+Util.getRandom();
String sqltemp = "" ;
if(isoracle) {
    if(!temptable1.equals(""))
        sqltemp = "create table "+temptable+" as select * from ( select t1.* from HrmCareerPlan t1,"+temptable1+" t2 WHERE t1.ID = t2.ID order by t1.startdate desc , t1.id desc )  where rownum<"+ (pagenum*perpage+1);
    else
        sqltemp = "create table "+temptable+" as select * from ( select * from HrmCareerPlan order by startdate desc , id desc)  where rownum<"+ (pagenum*perpage+1);
}
else {
    if(!temptable1.equals(""))
        sqltemp = "select top "+(pagenum*perpage)+" t1.* into "+temptable+" from HrmCareerPlan t1,"+temptable1+" t2 WHERE t1.ID = t2.ID order by t1.startdate desc , t1.id desc ";
    else
        sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmCareerPlan order by startdate desc , id desc ";

}
rs.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
rs.executeSql(sqlcount);
int count =0;
if(rs.next()){
	count = rs.getInt(1);
}

String sql = "" ;
if(isoracle) {
    /* 2004-06-17 号刘煜修改， 将 where rownum< "+ (count - ((pagenum-1)*perpage)) 改为 where rownum<="+ (count - ((pagenum-1)*perpage)) ， 使得隐藏一条的情况得到修正 */

    sql = "select * from (select * from "+temptable +" order by startdate , id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by startdate , id  ";
}

boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlanAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCareerPlan:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+70+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlan.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlan.jsp?pagenum="+(pagenum+1)+",_self} " ;
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
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=7><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH></TR>

  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15668,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></TD>
  </TR>

<%
//String sql = "select * from HrmCareerPlan order by startdate desc";
rs.executeSql(sql);
rs.afterLast() ;
int needchange = 0;
while(rs.previous()){
String	topic=Util.null2String(rs.getString("topic"));
String	principalid=Util.null2String(rs.getString("principalid"));
String  informmanid = Util.null2String(rs.getString("informmanid"));
String  startdate = Util.null2String(rs.getString("startdate"));
String  advice = Util.null2String(rs.getString("advice"));
try{
  if(needchange ==0){
  needchange = 1;
%>
  <TR class=datalight>
<%
}else{ needchange=0;
%>
  <TR class=datadark>
<%
}
%>
   <td><a href="HrmCareerPlanEdit.jsp?id=<%=rs.getString("id")%>"><%=topic%></a>
   </td>
   <TD><%=ResourceComInfo.getResourcename(principalid)%></a>
   </TD>
   <TD><%=ResourceComInfo.getResourcename(informmanid)%></a>
   </TD>
   <TD><%=startdate%>
   </TD>
   <TD><%=advice%>
   </TD>
  </TR>
<%
  }catch(Exception e){
  System.out.println(e.toString());
  }
 }


String sqldrop =" drop table "+temptable ;

rs.executeSql(sqldrop);
if(!temptable1.equals(""))   {
     sqldrop ="  drop table "+temptable1 ;
     rs.executeSql(sqldrop)  ;
}
%>
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
</BODY>
</HTML>
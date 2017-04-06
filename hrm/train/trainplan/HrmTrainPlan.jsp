<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
boolean isoracle = rs.getDBType().equals("oracle") ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
  String sqlnum = "select count(id) from HrmTrainPlan ";  
  rs.executeSql(sqlnum);
  rs.next();
  numcount = rs.getInt(1);


String temptable = "temptable"+Util.getRandom();
String sqltemp = "" ;
if(isoracle) {
    sqltemp = "create table "+temptable+" as select * from ( select * from HrmTrainPlan order by planstartdate desc,id desc )  where rownum<"+ (pagenum*perpage+1);
}
else {
    sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmTrainPlan  order by planstartdate desc,id desc";
}

rs.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
rs.executeSql(sqlcount);
rs.next();
int count = rs.getInt(1);
String sql = "" ;
if(isoracle) {
    sql = "select * from (select * from "+temptable +" order by planstartdate,id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by planstartdate,id  ";
}

boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//if(HrmUserVarify.checkUserRight("HrmTrainPlanAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlanAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//}
if(HrmUserVarify.checkUserRight("HrmTrain:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+82+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;	
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlan.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlan.jsp?pagenum="+(pagenum+1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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

<FORM id=weaver name=frmMain action="HrmDepartment.jsp" method=post>
 <TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TD>    
    </TR>
    
<%
    rs.executeSql(sql);    
    int needchange=0;    
    int line = 1;

   if(rs.last()){
    do{
    try{
              String id = Util.null2String(rs.getString("id"));
              String layoutid = Util.null2String(rs.getString("layoutid"));
              String name = Util.null2String(rs.getString("planname"));
              if(line%2==0){

        %>
          <TR class=datadark>
        <%
             }else{

        %>
          <TR class=datalight>
        <%
           }
        %>
            <TD>
            <a href="/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=<%=id%>"><%=name%></a>
            </TD>
            <TD>
              <%=TrainLayoutComInfo.getLayoutname(layoutid)%>
            </TD>
          </TR>
        <%
            if(hasnext){
                line+=1;
                if(line>perpage)	break;
             }
    }catch(Exception e){

    }
    } while(rs.previous()) ;

   }
String sqldrop =" drop table "+temptable ;
 rs.executeSql(sqldrop);
%>
 
 </TBODY></TABLE>
 <BR>
 </form>
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
</BODY>
</HTML>
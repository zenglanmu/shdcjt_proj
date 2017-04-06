<%@ page import="weaver.general.Util,
                 java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%!
    /*Add by Charoes Huang */
    private boolean canAddNewTrain(User user){
        boolean canAdd = false;
        String currentDate ="";
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd") ;
        currentDate = format.format(Calendar.getInstance().getTime());
        int userid = user.getUID() ;
         RecordSet rs = new RecordSet();
		 String sql ="SELECT COUNT(*) as COUNT FROM HrmTrainPlan WHERE (','+planorganizer+',' like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate='')";
		
		if(rs.getDBType().equals("oracle")){
			sql = "SELECT COUNT(*) as COUNT FROM HrmTrainPlan WHERE (concat(concat(',',planorganizer),',') like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate is null)";
		}
		//System.out.println(sql);
       
        rs.executeSql(sql);
        if(rs.next()){
            if(rs.getInt("COUNT") > 0 )
                canAdd = true;
        }
        return canAdd;
    }
%>
<%
boolean isoracle = rs.getDBType().equals("oracle") ;
boolean isdb2 = rs.getDBType().equals("db2") ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;
int numcount = 0;
  String sqlnum = "select count(id) from HrmTrain ";
  rs.executeSql(sqlnum);
  rs.next();
  numcount = rs.getInt(1);


String temptable = "temptable"+Util.getRandom();
String sqltemp = "" ;
if(isoracle) {
    sqltemp = "create table "+temptable+" as select * from ( select * from HrmTrain order by startdate desc,id desc )  where rownum<"+ (pagenum*perpage+1);
}else if(isdb2){
		sqltemp = "create table "+temptable+"  as (   select * from HrmTrain  ) definition only";
        rs.executeSql(sqltemp);
        sqltemp = "insert into "+temptable+" ( select * from HrmTrain order by startdate desc,id desc    fetch first "+(pagenum*perpage+1)+"  rows only)";
}
else {
    sqltemp = "select top "+(pagenum*perpage)+" * into "+temptable+" from HrmTrain  order by startdate desc,id desc";
}

rs.executeSql(sqltemp);
String sqlcount = "select count(id) from "+temptable;
rs.executeSql(sqlcount);
rs.next();
int count = rs.getInt(1);
String sql = "" ;
if(isoracle) {
    sql = "select * from (select * from "+temptable +" order by startdate,id ) where rownum<="+ (count - ((pagenum-1)*perpage)) ;
}else if(isdb2){
    sql = "select  from "+temptable +" order by startdate,id fetch first  "+(count - ((pagenum-1)*perpage)+1)+"  rows only";
}
else {
    sql = "select top "+(count - ((pagenum-1)*perpage)) +" * from "+temptable+" order by startdate ,id";
}

boolean hasnext = false;
if(numcount>pagenum*perpage){
  hasnext = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

if(canAddNewTrain(user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/train/train/HrmTrainPlanSelect.jsp,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrain:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+83+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+83+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
if(pagenum>1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp?pagenum="+(pagenum-1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(hasnext){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp?pagenum="+(pagenum+1)+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr style="height:1px">
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
  <COL width="25%">
  <COL width="25%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></TD>
  </TR>
  
<%
    rs.executeSql(sql);
    int line = 1;

    int needchange=0;
    if(rs.last()){
    do{
        try{
              String id = Util.null2String(rs.getString("id"));
              String planid = Util.null2String(rs.getString("planid"));
              String name = Util.null2String(rs.getString("name"));
              String advice = Util.null2String(rs.getString("advice"));
              if(needchange%2==0){
                needchange ++;
        %>
          <TR class=datadark>
        <%
              }else{
              needchange ++;
        %>
          <TR class=datalight>
        <%
              }
        %>
            <TD><a href="/hrm/train/train/HrmTrainEdit.jsp?id=<%=id%>"><%=name%></a></TD>
            <TD>
              <%=TrainPlanComInfo.getTrainPlanname(planid)%>
            </TD>

            <td><%=advice%></td>
          </TR>
        <%
            if(hasnext){
                line+=1;
                if(line>perpage)	break;
             }
        }catch(Exception e){

        }
    } while(rs.previous() );
    }
String sqldrop =" drop table "+temptable ;
 rs.executeSql(sqldrop);
%>


 </TBODY>
 </TABLE>
 <BR>
 </form>
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
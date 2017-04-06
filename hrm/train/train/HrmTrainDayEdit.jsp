<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>	
<html>
<%	
String id = request.getParameter("id");
String trainid = "";
String aim = "";
String content = "";
String effect = "";
String plain = "";
String day = "";

String sql = "select * from HrmTrainDay where id = "+id;	
rs.executeSql(sql);
while(rs.next()){
  trainid = Util.null2String(rs.getString("trainid"));
  aim = Util.toScreenToEdit(rs.getString("daytrainaim"),user.getLanguage());//Util.null2String(rs.getString("daytrainaim"));
  content = Util.toScreenToEdit(rs.getString("daytraincontent"),user.getLanguage());//Util.null2String(rs.getString("daytraincontent"));
  effect = Util.null2String(rs.getString("daytraineffect"));
  plain = Util.null2String(rs.getString("daytrainplain"));
  day = Util.null2String(rs.getString("traindate"));
 
}


//String trainid_ = request.getParameter("trainid");
/** 
 * begin td24253
 * Add by yangdacheng 20111215 
 * Get the startDate and endDate of the HrmTrain
  */
String sqlstr ="";
String startDate ="";
String endDate ="";
String trainid_="";
if(!trainid.equals("")){
    sqlstr = "Select a.startdate as startdate,a.enddate as enddate,b.trainid as trainidd from HrmTrain a ,HrmTrainDay b where a.id=b.trainid and b.id ="+id;
    rs.executeSql(sqlstr);
    rs.next();
    startDate = rs.getString("startdate");
    endDate = rs.getString("enddate");
    trainid_= rs.getString("trainidd");

}
String actor = "";
String sql1 = "select planactor from HrmTrainPlan where id = (select planid from HrmTrain where id = "+trainid_+")";	
rs.executeSql(sql1);
rs.next();
actor = rs.getString("planactor");
// begin td24253
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<FORM id=weaver name=frmMain action="TrainDayOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
          <td class=field>
            <BUTTON class=Calendar id=selectstartdate onclick="getDate(dayspan,day)" onchange='checkinput("day","dayspan")'></BUTTON> 
            <SPAN id=dayspan ><%=day%></SPAN> 
            <input type="hidden" id="day" name="day" value=<%=day%>>            
          </td>
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=field>
            <textarea class=inputstyle cols=50 rows=4 name=content value=<%=content%>><%=content%></textarea>
          </td>
        </tr>     
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=field>
            <textarea class=inputstyle  cols=50 rows=4 name=aim value=<%=aim%>><%=aim%></textarea>            
          </td>
        </tr>     
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16145,user.getLanguage())%> </td>
          <td class=field>
            <textarea class=inputstyle cols=50 rows=4 name=effect value=<%=effect%>><%=effect%></textarea>            
          </td>
        </tr>   
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%> </td>
          <td class=field>
            <textarea class=inputstyle cols=50 rows=4 name=plain value=<%=plain%>><%=plain%></textarea>            
          </td>
        </tr>   
  </TBODY>
</TABLE>
<table class=ListStyle cellspacing=1 >
 <COLGROUP>
  <COL width="20%">
  <COL width="80%">  
 <tbody>
   <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16146,user.getLanguage())%></TH>    
   </TR>
    <tr class=header>     
     <td><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></td>
     <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>     
   </tr>
   <TR class=Line><TD colspan="2" ></TD></TR> 
<%
 sql = "select * from HrmTrainActor where traindayid = "+id;  
 rs.executeSql(sql);
 while(rs.next()){
   String actorid = Util.null2String(rs.getString("id"));
   String resourceid = Util.null2String(rs.getString("resourceid"));
   String isattend = Util.null2String(rs.getString("isattend"));
%>
   <tr class=datalight>
     <td >
       <input type=checkbox name=actor value=<%=resourceid%> <%if(isattend.equals("1")){%>checked <%}%>>
     </td>
     <td >
       <%=ResourceComInfo.getResourcename(resourceid)%>
     </td>
   </tr>  
<%   
 }
%>       
 </tbody>
</table>
 
<input type="hidden" name=operation> 
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=trainid value=<%=trainid%>>

 </form>
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
<script language=javascript>
function dosave(){
if(check_form(document.frmMain,'day')&&checkDateValidity()){        
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
} 
function dodelete(){ 
  if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){     
    document.frmMain.operation.value="delete";
    document.frmMain.submit();
  }
}   

function checkDateValidity(){
    var isValid = true;
    var selectDay = frmMain.day.value;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    if(compareDate(startDate,selectDay)==1 || compareDate(selectDay,endDate)==1){
        alert("培训日期必须在"+startDate+"和"+endDate+"之间");
        isValid = false;
    }
    return isValid;
}
/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
 
 </script>
 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
 </HTML>
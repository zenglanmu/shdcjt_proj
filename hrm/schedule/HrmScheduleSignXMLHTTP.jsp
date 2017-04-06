<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleSignManager" class="weaver.hrm.schedule.HrmScheduleSignManager" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />



<%


User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

//签到（签退）只接受POST方法，不接受GET方法。
if(request==null||!"POST".equalsIgnoreCase(request.getMethod())){
	return ;
}


String returnString="";

String signType=Util.null2String(request.getParameter("signType"));

int userId=user.getUID();
int subCompanyId=user.getUserSubCompany1();
String userType=user.getLogintype();
Calendar today = Calendar.getInstance();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                   + Util.add0(today.get(Calendar.MINUTE), 2) + ":" 
				   + Util.add0(today.get(Calendar.SECOND), 2);


String tsql = "";
String tcurrentDate = "";
String tcurrentTime = "";
if("oracle".equals(RecordSet.getDBType()))
{
	tsql = "select to_char(sysdate,'yyyy-mm-dd') as currentDate,to_char(sysdate,'hh24:mi:ss') as currentTime from dual";
}
else
{
	tsql = "select convert(char(10),getdate(),20) currentDate,convert(char(8),getdate(),108) currentTime";	
}
RecordSet.executeSql(tsql);
while(RecordSet.next())
{
	tcurrentDate = RecordSet.getString("currentDate");
	tcurrentTime = RecordSet.getString("currentTime");
}
if(!"".equals(tcurrentDate))
{
	currentDate = tcurrentDate;
}
if(!"".equals(tcurrentTime))
{
	currentTime = tcurrentTime;
}
//System.out.println("tcurrentDate : "+tcurrentDate+"   ---tcurrentTime : "+tcurrentTime);
String clientAddress=request.getRemoteAddr();
String isInCom=HrmScheduleSignManager.getIsInCom(clientAddress);

RecordSet.executeSql("insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,clientAddress,isInCom) values("+userId+",'"+userType+"','"+signType+"','"+currentDate+"','"+currentTime+"','"+clientAddress+"','"+isInCom+"')");


if("1".equals(isInCom)){

//判断最后一次正常考勤与当前日期之间是否存在异常考勤  开始 
if(signType.equals("1")){
	HrmScheduleSignManager.setUser(user);
	boolean isAbnormal=HrmScheduleSignManager.getIsAbnormal(userId,userType,currentDate);
	if(isAbnormal){
		returnString+=SystemEnv.getHtmlLabelName(20116,user.getLanguage())+"，<br>";
	}
}
//判断最后一次正常考勤与当前日期之间是否存在异常考勤  结束
HrmScheduleDiffUtil.setUser(user);
Map onDutyAndOffDutyTimeMap=HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(currentDate,subCompanyId);
String onDutyTimeAM=Util.null2String((String)onDutyAndOffDutyTimeMap.get("onDutyTimeAM"));
String offDutyTimePM=Util.null2String((String)onDutyAndOffDutyTimeMap.get("offDutyTimePM"));


if(signType.equals("1")&&currentTime.compareTo(onDutyTimeAM)<=0){
	returnString+=SystemEnv.getHtmlLabelName(20034,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(20035,user.getLanguage())+"：";
}else if(signType.equals("1")&&currentTime.compareTo(onDutyTimeAM)>0){
	returnString+=SystemEnv.getHtmlLabelName(20036,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(20037,user.getLanguage())+"：";
}

if(signType.equals("2")&&currentTime.compareTo(offDutyTimePM)<0){
	returnString+=SystemEnv.getHtmlLabelName(20036,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(20037,user.getLanguage())+"：";
}else if(signType.equals("2")&&currentTime.compareTo(offDutyTimePM)>=0){
	returnString+=SystemEnv.getHtmlLabelName(20038,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(20039,user.getLanguage())+"：";
}

returnString+=currentDate+" "+currentTime;

}else{
	returnString+=SystemEnv.getHtmlLabelName(20157,user.getLanguage());
}

%>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<BODY>

<table   border="0" cellspacing="0" cellpadding="0">

<tr>
	<td valign="top"><%=returnString%>&nbsp;&nbsp;&nbsp;&nbsp;<BUTTON class=AddDoc  onclick="onCloseDivShowSignInfo()"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>
	</td>
</tr>
</TABLE>

</BODY>
</HTML>
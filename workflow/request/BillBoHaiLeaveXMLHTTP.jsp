<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />


<%


User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;


String returnString="";

String operation=Util.null2String(request.getParameter("operation"));



//检查其它请假类型是否可行
if("checkOtherLeaveType".equals(operation)){
	int leaveType=Util.getIntValue(request.getParameter("leaveType"),0);
	int otherLeaveType=Util.getIntValue(request.getParameter("otherLeaveType"),0);
	int resourceId=Util.getIntValue(request.getParameter("resourceId"),0);
	String fromDate=Util.null2String(request.getParameter("fromDate"));
    String fromYear="";
	if(fromDate.length()>=4){
		fromYear=fromDate.substring(0,4);
	}

	int requestId=Util.getIntValue(request.getParameter("requestId"),0);

	StringBuffer sb=new StringBuffer();
	sb.append(" select 1 ")
	  .append("   from Bill_BoHaiLeave b ")
	  .append("  where b.resourceId=").append(resourceId)
	  .append("    and b.otherLeaveType=").append(otherLeaveType==1?2:1)		
	  .append("    and (b.leaveType=3  or b.leaveType=4) ");

	if(!fromYear.equals("")){
		sb.append(" and b.fromDate like '").append(fromYear).append("%'");
	}

	if(requestId>0){
		sb.append(" and b.requestId<>"+requestId);
	}

	RecordSet.executeSql(sb.toString());
	if(RecordSet.next()){
		returnString+="false";
	}else{
		returnString+="true";
	}    
}

//根据起始日期、起始时间、结束日期、结束时间获得请假天数
if("getLeaveDays".equals(operation)){
	String fromDate=Util.null2String(request.getParameter("fromDate"));
	String fromTime=Util.null2String(request.getParameter("fromTime"));
	String toDate=Util.null2String(request.getParameter("toDate"));
	String toTime=Util.null2String(request.getParameter("toTime"));

	int resourceId=Util.getIntValue(request.getParameter("resourceId"),0);
	String departmentId=ResourceComInfo.getDepartmentID(""+resourceId);
	String subCompanyId=DepartmentComInfo.getSubcompanyid1(departmentId);

	//String totalWorkingDays=HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime);
    String sqlHrmResource = "select locationid from HrmResource where id ="+resourceId;
	RecordSet.executeSql(sqlHrmResource);
	String locationid = "";
	if (RecordSet.next()){
	   locationid=RecordSet.getString("locationid");
	}
	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	RecordSet.executeSql(sqlHrmLocations);
	String countryId = "";
	if (RecordSet.next()){
	   countryId =  RecordSet.getString("countryid");
	}
	user.setCountryid(countryId);
	HrmScheduleDiffUtil.setUser(user);
	String totalWorkingDays=HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,Util.getIntValue(subCompanyId,0));
	if(totalWorkingDays==null||totalWorkingDays.trim().equals("")){
		totalWorkingDays="0.00";
	}
	returnString+=totalWorkingDays;
}

%>

<%=returnString%>
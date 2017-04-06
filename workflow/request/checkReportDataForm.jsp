<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String formid=Util.null2String(request.getParameter("formid"));
int requestid=Util.getIntValue(request.getParameter("requestid"));
int reportUserId=Util.getIntValue(request.getParameter("reportUserId"));
int crmId=Util.getIntValue(request.getParameter("crmId"));
String year=Util.null2String(request.getParameter("year"));
String month=Util.null2String(request.getParameter("month"));
String day=Util.null2String(request.getParameter("day"));
String date=Util.null2String(request.getParameter("date"));
String src=Util.null2String(request.getParameter("src"));

    Calendar today = Calendar.getInstance();
    today.add(Calendar.DATE, -1) ;
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	int inprepId=0;
	String inprepfrequence="";
	String isInputMultiLine="";
	String inprepTableName="";
	RecordSet.executeSql("select inprepId,inprepfrequence,isInputMultiLine,inprepTableName from T_InputReport where billId="+formid);
	if(RecordSet.next()){
		inprepId=Util.getIntValue(RecordSet.getString("inprepId"),0);
		inprepfrequence=Util.null2String(RecordSet.getString("inprepfrequence"));
		isInputMultiLine=Util.null2String(RecordSet.getString("isInputMultiLine"));
        inprepTableName=Util.null2String(RecordSet.getString("inprepTableName"));
        if(isInputMultiLine.equals("1")) inprepTableName+="_main";
	}

    String ret="0";
	String thedate = currentdate;
	String dspdate = currentdate ;

    if(!inprepfrequence.equals("0")) {
		switch (Util.getIntValue(inprepfrequence)) {
			case 1:
				thedate = year + "-01-15" ;
				dspdate = year ;
				break ;
			case 2:
				thedate = year + "-"+month+"-15" ;
				dspdate = year + "-"+month ;
				break ;
			case 3:
				thedate = year + "-"+month+"-"+day ;
				dspdate = year + "-"+month ;
				if(day.equals("05")) dspdate += " 上旬" ;
				if(day.equals("15")) dspdate += " 中旬" ;
				if(day.equals("25")) dspdate += " 下旬" ;
					break ;
			case 4:
				thedate = date;
				Calendar todayNew = Calendar.getInstance();
				todayNew.set(Calendar.YEAR,Util.getIntValue(date.substring(0,4)));
				todayNew.set(Calendar.MONTH,Util.getIntValue(date.substring(5,7))-1);
  				todayNew.set(Calendar.DAY_OF_MONTH,Util.getIntValue(date.substring(8)));
				dspdate = Util.add0(todayNew.get(Calendar.YEAR), 4) + " 第" + Util.add0(todayNew.get(Calendar.WEEK_OF_YEAR), 2) + "周";
				break;
			case 5:
  				thedate = date ;
  				dspdate = date ;
  				break ;
            case 6:
                thedate = year + "-"+month+"-15" ;
                dspdate = year;
                if(month.equals("01")) dspdate += " 上半年" ;
			    if(month.equals("07")) dspdate += " 下半年" ;
                break;
		    case 7:
			    thedate = year + "-"+month+"-15" ;
                dspdate = year;
                if(month.equals("01")) dspdate += " 一季度" ;
			    if(month.equals("04")) dspdate += " 二季度" ;
                if(month.equals("07")) dspdate += " 三季度" ;
                if(month.equals("10")) dspdate += " 四季度" ;
                break;
		}
    }

	String sql=null;
    if(!inprepTableName.equals("")){
	if(!inprepfrequence.equalsIgnoreCase("0")){
		sql="SELECT inputstatus FROM "+inprepTableName+" WHERE inprepdspdate='"+dspdate+"' AND crmid="+crmId+" and requestid <>"+requestid;
	}else{//报表无周期限定
		sql="SELECT inputstatus FROM "+inprepTableName+" WHERE inputstatus='9' and inprepdspdate='"+dspdate+"' and crmid="+crmId+" AND reportuserid="+reportUserId+" and requestid <>"+requestid;
	}
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		String status=Util.null2String(RecordSet.getString("inputstatus"));
		ret=status.equalsIgnoreCase("9")?"2":"1";//status==9,表示已导入数据，但处于草稿状态中。
	}
    }
%>
<script language="javascript">
parent.checkReportDataReturn("<%=ret%>","<%=thedate%>","<%=dspdate%>","<%=src%>");
</script>
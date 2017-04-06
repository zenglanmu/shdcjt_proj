<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	String cancelFlag = request.getParameter("cancelFlag");
	int receiveUnitId = Util.getIntValue(request.getParameter("receiveUnitId"));
	int userId = Util.getIntValue(request.getParameter("userId"));

		if ("1".equals(cancelFlag)) {
			String sqlstr = " select id from DocReceiveUnit a where canceled='1' and exists (select 1 from DocReceiveUnit where superiorUnitId=a.id and id="+receiveUnitId+")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
		        out.println("0");
			} else {
				RecordSet.executeSql("update DocReceiveUnit set canceled = '0' where id ="+ receiveUnitId);
				out.println("1");
			}
		} else {
			String sqlstr = " select id from DocReceiveUnit where  (canceled = '0' or canceled is null) and superiorUnitId="+receiveUnitId;
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
		        out.println("0");
			} else {
				RecordSet.executeSql("update DocReceiveUnit set canceled = '1' where id ="+ receiveUnitId);		
				out.println("1");
			}
		}
		DocReceiveUnitComInfo.removeDocReceiveUnitCache();
%>

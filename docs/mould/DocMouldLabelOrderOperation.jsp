<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	
	if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

    int mouldId = Util.getIntValue(request.getParameter("mouldId"),-1); 

	int tempRecordId=0;
    double tempShowOrder=0;

  	int rowNum = Util.getIntValue(Util.null2String(request.getParameter("rowNum")));

	for(int i=0;i<rowNum;i++) {
		tempRecordId = Util.getIntValue(request.getParameter("labelOrder"+i+"_recordId"),0);
		tempShowOrder = Util.getDoubleValue(request.getParameter("labelOrder"+i+"_showOrder"),0);

		if(tempRecordId>0){
			RecordSet.executeSql("update MouldBookMark set showOrder="+tempShowOrder+" where id="+tempRecordId);
		}
	}
	
    //response.sendRedirect("DocMouldDspExt.jsp?id="+mouldId);
    response.sendRedirect("DocMouldLabelOrder.jsp?mouldId="+mouldId);	

%>

<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>

<form name="frmmain" method="post" action="BillDataCenterOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowAddRequestBodyDataCenter.jsp" %>
    <input type="hidden" name="needwfback" id="needwfback" value="1" />
</form>

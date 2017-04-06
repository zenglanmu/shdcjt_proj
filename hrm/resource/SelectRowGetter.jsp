<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    int fieldid = Util.getIntValue(request.getParameter("fieldid"));
    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",-1);
    cfm.getSelectItem(fieldid);
%>
<HTML>
<HEAD>
<script language="javascript">
function putRow(){
    obj = parent.selectRowObj;
    var isAdd = true;
    for(var i=0; i<parent.inputface.rows.length; i++){
        if(parent.inputface.rows[i].cells[0].childNodes[2].value=="<%=fieldid%>"){
            isAdd = false;
            break;
        }
    }
    if(isAdd){
	    obj.parentElement.parentElement.cells[3].innerHTML=selectitembuffer.innerHTML;
        obj.parentElement.parentElement.cells[0].innerHTML=selectidbuffer.innerHTML;
    }else{
    	alert("<%=SystemEnv.getHtmlLabelName(23264,user.getLanguage())%>£¡");
    }

}
</script>
</HEAD>
<BODY onload="putRow()">
<div id="selectidbuffer">
<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>:<input  class=InputStyle name="fieldlable"><input  type="hidden" name="fieldid" value="<%=fieldid%>">
</div>
<div id="selectitembuffer">

            <TABLE cellSpacing=0 cellPadding=1 width="100%" border=0 >
            <COLGROUP>
                <col width="40%">
                <col width="60%">
            </COLGROUP>
     <%
        while(cfm.nextSelect()){
     %>
        <tr>
            <td>
            	<input name=selectitemid type=hidden value="<%=cfm.getSelectValue()%>" >
	            <input  class=InputStyle name=selectitemvalue type=text value="<%=cfm.getSelectName()%>" style="width:100">
            </td>
            <td>
                <img src="/images/icon_ascend.gif" height="14" onclick="upitem(this)">
                <img src="/images/icon_descend.gif" height="14" onclick="downitem(this)">
                <img src="/images/delete.gif" height="14" onclick="delitem(this)">
            </td>
        </tr>

     <%}%>

            </TABLE>
            <input name=selectitemid type=hidden value="--">
            <input name=selectitemvalue type=hidden >

            <input name=flength type=hidden  value="100">
</div>

</BODY>
</HTML>

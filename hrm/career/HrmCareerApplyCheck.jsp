<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//add by wjy
    String temName = Util.null2String(request.getParameter("lastname"));
    String checkMessage = "";
    boolean isCheckHas = false;
    String tempSql = "";
    if(!temName.equals("")){
        tempSql = "select lastname from HrmCareerApply where lastname='"+temName+"'";
        rs.executeSql(tempSql);
        if(rs.next()){
            checkMessage = "姓名已经存在,是否继续？";
            isCheckHas = true;
        }
    }

    //end
%>
<HTML>
<HEAD>
<SCRIPT language="javascript">
function reUpdate(){
try{
<%
    if(isCheckHas){
%>
    parent.showConfirm("<%=checkMessage%>");
<%
    }else{
%>
    parent.checkPass();
<%
    }
%>
}catch(e){alert(e)}
}
</script>
</HEAD>
<BODY onload="reUpdate()">
</BODY>
</HTML>
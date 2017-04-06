<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//add by wjy
    String temName = Util.null2String(request.getParameter("lastname"));
    String temCode = Util.null2String(request.getParameter("workcode"));
    String checkMessage = "";
    boolean isCheckHas = false;
    boolean isCheckHasName = false;
    String tempSql = "";
    if(!temCode.equals("")){
        tempSql = "select workcode from HrmResource where workcode='"+temCode+"'";
        rs.executeSql(tempSql);
        if(rs.next()){
            String workcode=rs.getString("workcode");
            if(workcode.equals(temCode)){
            checkMessage = SystemEnv.getHtmlLabelName(21447,user.getLanguage());
            isCheckHas = true;
            }
        }
    }
    if(!temName.equals("")){
        tempSql = "select lastname from HrmResource where lastname='"+temName+"'";
        rs.executeSql(tempSql);
        if(rs.next()){
            if(!isCheckHas){
                checkMessage = SystemEnv.getHtmlLabelName(21445,user.getLanguage());
            }else{
                checkMessage = SystemEnv.getHtmlLabelName(21446,user.getLanguage());
            }
            isCheckHasName = true;
        }
    }

    //end
%>
<HTML>
<HEAD>
<SCRIPT language="javascript">
function reUpdate(){
<%
    if((isCheckHas&&isCheckHasName)||(isCheckHas&&!isCheckHasName)){
%>
    parent.showAlert("<%=checkMessage%>");
<%
    }else if(!isCheckHas&&isCheckHasName){
%>
    if(parent.showConfirm("<%=checkMessage%>")){
        parent.checkPass();
    }
<%
    }else{
%>
    parent.checkPass();
<%
    }
%>
}
</script>
</HEAD>
<BODY onload="reUpdate()">
aaaa
</BODY>
</HTML>
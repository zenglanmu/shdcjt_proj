<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
 WorkFlowBillUtil wf = new WorkFlowBillUtil();
 if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageWorkflowbill.jsp");
}   
%>

<html>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>编辑: 工作流单据</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="WorkflowbillOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="back()"><U>D</U>-返回</BUTTON>        
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>单据信息</TH>
          </TR>          
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
//String indexdesc = Util.toScreen(request.getParameter("indexdesc"),user.getLanguage(),"0");
String sql = "select * from workflow_bill where id = "+id;
rs.executeSql(sql);
while(rs.next()){
   int namelabel = Util.getIntValue(rs.getString("namelabel"),0);
   String indexdesc = Util.null2String(wf.getLabelByLabelId(namelabel));
   String tablename = Util.null2String(rs.getString("tablename"));	
   String createpageUrl = Util.null2String(rs.getString("createpage"));
   String managepageUrl = Util.null2String(rs.getString("managepage"));
   String viewpageUrl = Util.null2String(rs.getString("viewpage"));
   String operationpage = Util.null2String(rs.getString("operationpage"));
   String detailtablename = Util.null2String(rs.getString("detailtablename"));
   String detailkeyfield = Util.null2String(rs.getString("detailkeyfield"));            
%>
          
          <TR> 
            <TD>单据ID</TD>
            <input type=hidden name="id" value=<%=id%>>
            <TD Class=Field><%=id%></TD>
          </TR>
          <TR> 
            <TD>描叙</TD>
            <TD Class=Field><INPUT class=FieldxLong  name="indexdesc" value="<%= indexdesc%>"> </TD>
          </TR>
          <TR> 
            <TD>主数据库表名</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=maintable value="<%= tablename%>"></TD>
          </TR>
          <TR> 
            <TD>附数据库表名</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=detailtable value="<%= detailtablename%>"></TD>
          </TR>
          <TR> 
            <TD>新建页面</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=newpageUrl value="<%= createpageUrl%>"></TD>
          </TR>
          <TR> 
            <TD>查看页面</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=viewpageUrl value="<%= viewpageUrl%>"></TD>
          </TR>
          <TR> 
            <TD>编辑页面</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=editpageUrl value="<%= managepageUrl%>"></TD>
          </TR>
          <TR> 
            <TD>后台处理页面</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=operationpage value="<%= operationpage%>"></TD>
          </TR>
          <TR> 
            <TD>主附表表关联字段</TD>
            <TD Class=Field><INPUT class=FieldxLong  name=detailkeyfield value="<%= detailkeyfield%>"></TD>
          </TR>
<%
  }
%>          
          </TBODY> 
        </TABLE>
        <br>
<input type="hidden" name="operation" value="editWorkflowbill">
<script language=javascript>
  function back(){         
        location = "ViewWorkflowbill.jsp?id=<%=id%>";
    }
</script>

      </FORM>
      </BODY>
      </HTML>

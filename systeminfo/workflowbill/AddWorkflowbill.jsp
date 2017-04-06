<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
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
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 工作流单据</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
 <FORM style="MARGIN-TOP: 0px" name=addbillform method=post action="WorkflowbillOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>单据信息</TH>
          </TR>
          <%
            String errorMsg=Util.null2String(request.getParameter("errorMsg"));
            if(errorMsg.equals("1")) {
            
            %>
          <TR class=Section> 
            <TH colSpan=5>单据ID已经被占用,请重新选择</TH>
          </TR>
          <%}%>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>单据ID</TD>
            <%
            int id_1= 0;
	String maxIdSql = "";
	if(rs.getDBType().equals("oracle")){
		maxIdSql="select id from (select id from workflow_bill order by id desc) where rownum=1 ";
	}else{
		maxIdSql = "select top 1 id  from workflow_bill order by id desc";
	}

	rs.executeSql(maxIdSql); 
	if(rs.next()){
	   id_1= Util.getIntValue(rs.getString("id"),0);
	} 
	id_1=id_1+1;	
            
            %>
            <TD Class=Field><%=id_1%>
            <INPUT  type=hidden name="id_1" value=<%=id_1%>>
            </TD>
          </TR>
          <TR> 
            <TD>描叙</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=indexdesc></TD>
          </TR>
          <TR> 
            <TD>主数据库表名</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=maintable></TD>
          </TR>
          <TR> 
            <TD>附数据库表名</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=detailtable></TD>
          </TR>
          <TR> 
            <TD>新建页面</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=newpageUrl></TD>
          </TR>
          <TR> 
            <TD>查看页面</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=viewpageUrl></TD>
          </TR>
          <TR> 
            <TD>编辑页面</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=editpageUrl></TD>
          </TR>
          <TR> 
            <TD>后台处理页面</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=operationpage></TD>
          </TR>
          <TR> 
            <TD>主附表表关联字段</TD>
            <TD Class=Field><INPUT class=FieldxLong accessKey=Z name=detailkeyfield></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
	<input type="hidden" name="operation" value="addWorkflowbill">

      </FORM>
      </BODY>
      </HTML>

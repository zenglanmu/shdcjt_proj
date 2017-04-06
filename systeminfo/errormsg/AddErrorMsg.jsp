<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
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
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 错误信息</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 </TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ErrorMsgOperation.jsp">
    <BUTTON class=btn id=btnSave accessKey=S name=btnSave type=submit><U>E</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>错误信息信息</TH>
          </TR>
          <%
            String errorMsg=Util.null2String(request.getParameter("errorMsg"));
            if(errorMsg.equals("1")) {
            
            %>
          <TR class=Section> 
            <TH colSpan=5>错误信息ID已经被占用,请重新选择</TH>
          </TR>
          <%}%>
          <TR> 
            <TD>信息ID</TD>
            <%
            int id_1= 0;
	String maxIdSql = "";
	if(rs.getDBType().equals("oracle")){
		maxIdSql="select id from (select id from ErrorMsgindex order by id desc) where rownum=1 ";
	}else{
		maxIdSql = "select top 1 id  from ErrorMsgindex order by id desc";
	}
	rs.executeSql(maxIdSql); 
	if(rs.next()){
	   id_1= rs.getInt("id");
	} 
	id_1++;	
            
            %>
            <TD Class=Field><INPUT  name="id_1" value=<%=id_1%>></TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>描叙</TD>
            <TD Class=Field><INPUT class=FieldxLong name=indexdesc></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <TABLE class=Form>
          <COLGROUP><COL width="50%"> <COL width="50%"> 
          <TR class=Section> 
            <TH colSpan=2>错误信息名称</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <Td Class=Field>语言</Td>
            <Td Class=Field>错误信息名称</Td>
          </TR>
       


<%
String lanSql="select * from syslanguage";
rs.executeSql(lanSql);
while(rs.next()){
	String langid = rs.getString("id");
	//String langname = Util.toScreen(LanguageComInfo.getLanguagename(),user.getLanguage());
	String langname =rs.getString("language");
%>
          <TR> 
            <Td><%=langname%></Td>
            <Td><INPUT class=FieldLong name="errormsgname<%=langid%>"></Td>
          </TR>
<%
}
%>
<input type="hidden" name="operation" value="adderrormsg">
</TABLE>

      </FORM>
      </BODY>
      </HTML>

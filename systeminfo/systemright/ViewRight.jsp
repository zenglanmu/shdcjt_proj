<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRights_SelectByID",id);
	RecordSet.next()  ;
	String righttype = RecordSet.getString("righttype");
	String rightdescown = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
	String typename="";
	if(righttype.equals("0")) typename= SystemEnv.getHtmlLabelName(147,user.getLanguage()) ;
	else if(righttype.equals("1")) typename= SystemEnv.getHtmlLabelName(58,user.getLanguage()) ;
	else if(righttype.equals("2")) typename= SystemEnv.getHtmlLabelName(189,user.getLanguage()) ;
	else if(righttype.equals("3")) typename= SystemEnv.getHtmlLabelName(179,user.getLanguage()) ;
	else if(righttype.equals("4")) typename= SystemEnv.getHtmlLabelName(535,user.getLanguage()) ;
	else if(righttype.equals("5")) typename= SystemEnv.getHtmlLabelName(259,user.getLanguage()) ;
	else if(righttype.equals("6")) typename= SystemEnv.getHtmlLabelName(101,user.getLanguage()) ;
	else if(righttype.equals("7")) typename= SystemEnv.getHtmlLabelName(468,user.getLanguage()) ;
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 权限</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightOperation.jsp">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editright()"><U>E</U>-编辑</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteright()"><U>D</U>-删除</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addright()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewSQL()"><U>E</U>-导出SQL</BUTTON>
    <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="backSubmit()"><U>B</U>-返回</BUTTON> 
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>权限信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>标识</TD>
      <TD Class=Field><%=id%></TD>
    </TR>
    <tr> 
      <td>种类</td>
      <td class=Field><%=typename%></td>
    </tr>
    <TR> 
      <td>描叙</td>
      <td class=Field><%=rightdescown%></td>
    </TR>
    </TBODY> 
  </TABLE>
        <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="15%"> <COL width="15%"> <COL width="30%"><COL width="40%"><TBODY> 
          <TR class=Section> 
            
      <TH colSpan=4>权限详细</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=4></TD>
          </TR>
          <TR> 
            <Td Class=Field>标识</Td>
            <Td Class=Field>语言</Td>
            <Td Class=Field>名称</Td>
	        <Td Class=Field>描述</Td>
          </TR>
<%
RecordSet.executeProc("SystemRightsLanguage_SByID",id);
while(RecordSet.next())
{
	String rightname = Util.toScreen(RecordSet.getString("rightname"),user.getLanguage());
	String rightdesc = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
	String languageid= RecordSet.getString("languageid") ;
%>
         <TR> 
            <TD><%=id%></TD>
            <TD><%=Util.toScreen(LanguageComInfo.getLanguagename(languageid),user.getLanguage())%></TD>
            <TD><%=rightname%></TD>
			<TD><%=rightdesc%></TD>
          </TR>
<%
}
%>
</table>
<input type="hidden" name="operation" value="deleteright">
<input type="hidden" name="delete_right_id" value="<%=id%>">
      </FORM>
<script>
function deleteright(){
	if(confirmdel()) {
		document.frmView.submit();
	}
}
function addright() {	
	location="AddRight.jsp";
}
function editright() {	
	location='EditRight.jsp?id=<%=id%>';
}
function viewSQL(){
    location = 'ViewSql.jsp?id=<%=id%>';
}

function backSubmit(){
    location = "SystemRight.jsp";
}
</script>
      </BODY>
      </HTML>

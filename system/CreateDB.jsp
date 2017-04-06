<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=gbk">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String message = Util.null2String(request.getParameter("message")) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = "数据库设置" ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<DIV class=HdrProps>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2>数据库</TH>
    </TR>
    </TBODY> 
  </TABLE>
</DIV>


<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CreateDBOperation.jsp">
<div>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave type=button  onClick="OnSubmit()"><U>S</U>-创建</BUTTON> 
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重置</BUTTON> 
</div>    <br>
   
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
     <tr>
        <td nowrap>验证码:</td>
        <td  class=Field><input type=password  name=code maxlength=16 size=16> <a  href="\system\ModifyCode.jsp">更改验证码</a></td>
    </tr>
    <tr> 
      <td>数据库类型</td>
      <td class=Field> 
        <select name=dbtype onchange="if(this.value==1) dbport.value='1433';else if(this.value==2) dbport.value='1521';">
			<option value="1">SqlServer</option>
			<option value="2">Oracle</option>
			<!--option value="3">DB2</option-->
		</select>
      </td>
    </tr>
    <tr> 
      <td>数据库服务器IP</td>
      <td class=Field> 
        <input accesskey=Z name=dbserver  maxlength="20" value="127.0.0.1">
      </td>
    </tr>
    <tr>
    <tr>
      <td>数据库端口号</td>
      <td class=Field>
        <input accesskey=Z name=dbport  maxlength="20" value="">
      </td>
       <script>
           if(document.all('dbtype').value==1)
           document.all('dbport').value='1433';
           else if(document.all('dbtype').value==2)
           document.all('dbport').value='1521';
       </script>
    </tr>
    <tr>
      <td>数据库名称</td>
      <td class=Field> 
        <input accesskey=Z name=dbname  maxlength="20" value="ecology">
      </td>
    </tr>
    <tr> 
      <td>用户名</td>
      <td class=Field> 
        <input accesskey=Z name=username  maxlength="20" value="sa">
      </td>
    </tr>
    <tr> 
      <td>密码</td>
      <td class=Field> 
        <input accesskey=Z type=password name=password  maxlength="20" value="">
      </td>
    </tr>
    <tr> 
      <td>使用现有数据库</td>
      <td class=Field> 
        <input accesskey=Z type=checkbox name=isexist  value="1">
      </td>
    </tr>

    </TBODY> 
  </TABLE>
  </FORM>
	<%
	if(!message.equals("")){
	%>
	<DIV>
	<font color=red size=2>
	<%=message%>
	</font>
	</DIV>
	<%}%>

<SCRIPT language="javascript">
function OnSubmit(){
        document.frmMain.btnSave.disabled = true;
		document.frmMain.submit();
}
</script>
</BODY>
</HTML>

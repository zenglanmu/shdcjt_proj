<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  
<body>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19434,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>		
		<td valign="top">
			<TABLE  cellspacing="0" cellpadding="0" class="viewform">
			<colgroup>
			<col width="15%">
			<col width="33%">
			<col width="4%">
			<col width="15%">
			<col width="33%">
			<TR>
				<TD colspan=5><B><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></B></TD>				
			</TR>
			<TR><TD class=line1 colspan=5></TD></TR>
			<TR>
				<TD>样式名称</TD>
				<TD ><INPUT TYPE="text" NAME="txtInfoname" class=inputstyle></TD>
				<TD></TD>

				<TD rowspan=2>首页背景&nbsp;
				   <SELECT NAME="seleHpbg" onchange="seleChanage(this,this.parentNode.nextSibling,'txtHpbg')">
						<option value=1>图片</option>
						<option value=2>颜色</option>
					</SELECT>
				</TD>
				<TD rowspan=2>
					<span>
						<INPUT TYPE="file" NAME="txtHpbg" class=inputstyle onchange="fileChanage(this)">&nbsp;&nbsp;
					<span>
					<img style="display:none">
			    </TD>
				
			</TR>
			<TR><TD class=line colspan=5></TD></TR>
			<TR>
				<TD>样式描述</TD>
				<TD><INPUT TYPE="text" NAME="txtInfodesc" class=inputstyle width="80%"></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR><TD colspan=5 height=15px></TD></TR>

			<TR>
				<TD colspan=5><B><%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></B></TD>				
			</TR>
			<TR><TD class=line1 colspan=5></TD></TR>

			<TR>
				<TD>元素标题栏背景</TD>
				<TD ></TD>
				<TD></TD>
				<TD>元素内容背景</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR>
				<TD>元素标题的颜色</TD>
				<TD ></TD>
				<TD></TD>
				<TD>元素字体颜色</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR>
				<TD>元素边框颜色</TD>
				<TD ></TD>
				<TD></TD>
				<TD>时间显示方式</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR>
				<TD>锁定按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>锁定按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR>
				<TD>非锁定按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>非锁定按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>

			<TR>
				<TD>刷新按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>刷新按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>


			<TR>
				<TD>设置按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>设置按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>



			<TR>
				<TD>关闭按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>关闭按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>


			<TR>
				<TD>更多按钮1</TD>
				<TD ></TD>
				<TD></TD>
				<TD>更多按钮2</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>


			<TR>
				<TD>每行分隔线</TD>
				<TD ></TD>
				<TD></TD>
				<TD>每行前部小图标</TD>
				<TD ></TD>
			</TR>
			<TR><TD class=line colspan=5></TD></TR>
			</TABLE>


			<TABLE class="viewform"  cellspacing="0" cellpadding="0" >
			<TR><TD colspan=2 height=15px></TD></TR>
			<TR>
				<TD colspan=2><B>设置说明</B></TD>				
			</TR>
			<TR><TD class=line1 colspan=2></TD></TR>
			<TR>
				<TD></TD>	
				
				<TD></TD>
			</TR>
			<TR><TD class=line colspan=2></TD></TR>
			</TABLE>
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function onSave(){
}

function onClose(){
}

function seleChanage(obj1,obj2,obj3Name){
	if(obj1.value==1) obj2.innerHTML="<input type=file class=inputstyle name="+obj3Name+">";
	else obj2.innerHTML="<input type=text class=inputstyle name="+obj3Name+">";
}
function fileChanage(obj){
	imgobj=obj.parentNode.nextSibling;
	alert(imgobj.tagName)
	if(obj.value='') imgobj.style.display='none';
	else {
		imgobj.src=obj.value;
		imgobj.style.display='';

	}
}
</SCRIPT>
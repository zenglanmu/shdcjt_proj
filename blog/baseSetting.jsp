<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=0;
userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String isReceive="1";     //是否接收关注申请
String maxAttention="50"; //最大关注人数
String isThumbnail="1";   //是否显示缩略图

String sqlstr="select * from blog_setting where userid="+userid;
RecordSet.execute(sqlstr);
if(RecordSet.next()){
	isReceive=RecordSet.getString("isReceive");
	isThumbnail=RecordSet.getString("isThumbnail");
	maxAttention=RecordSet.getString("maxAttention");
}else{
	sqlstr="insert into blog_setting(userid,isReceive,isThumbnail,maxAttention) values("+userid+",1,1,50)";
	RecordSet.execute(sqlstr);
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  <body>
 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="edit" name="operation"/> 
    <TABLE class=ViewForm style="width: 98%;margin-left: 10px;"> 
		<COLGROUP>
		<COL width="30%">
		<COL width="20%">
		<COL width="50%">
		<TBODY>
			<TR class=Title>
				<TH colSpan=3><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH><!-- 基本设置 -->
			</TR>
			
			<TR class=Spacing style="height: 1px;">
			<TD class=Line1 colSpan=3></TD>
			</TR>
		
			<tr>
			  <td><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(25436,user.getLanguage())+SystemEnv.getHtmlLabelName(129,user.getLanguage())%></td><!-- 接收关注申请 -->     
			  <td class=Field>
				<input type="checkbox" name="isReceive" <%=isReceive.equals("1")?"checked=checked":""%> value="1" />
			  </td>
			  <td class="Field">
			    <span style="color: #666666"></span>
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=3></TD></TR>
			
			<tr style="display: none">
				  <td>关注人数上限</td>
				  <td class=Field>
					<input type="text" name="maxAttention" value="<%=maxAttention%>" style="width: 35px" size="4">
				  </td>
				  <td class="Field">
				    <span style="color: #666666">(最多可以关注的人数)</span>
				  </td>
				</tr>
				<TR style="height: 1px;"><TD class=Line colspan=3></TD></TR>
			<tr style="display: none">
			  <td>显示人员缩略图</td>
			  <td class=Field>
				<input type="checkbox" name="isThumbnail" <%=isThumbnail.equals("1")?"checked=checked":""%>  value="1" />
			  </td>
			  <td class="Field">
			    <span style="color: #666666"></span>
			  </td>
			</tr>			
			<TR style="display: none"><TD class=Line colspan=3></TD></TR>
		</TBODY>
	</TABLE>
	</form>  
  </body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
 </script>
</html>

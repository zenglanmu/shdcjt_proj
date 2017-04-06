<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<html>
	<head>
		<title>sap集成</title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30639,user.getLanguage());
		String opera="save";
		String hpid=Util.null2String(request.getParameter("hpid"));
		String sourcename="";
		String DBtype="";
		String serverip="";
		String port="";
		String dbname="";
		String username="";
		String password="";
		String minConnNum="";
		String maxConnNum="";
		String datasourceDes="";
		if("1".equals(isNew))
		{
			titlename =  SystemEnv.getHtmlLabelName(30641,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from dml_datasource where id='"+id+"'");
			if(RecordSet.next())
			{
				 hpid=RecordSet.getString("hpid");
				 sourcename=RecordSet.getString("sourcename");
				 DBtype=RecordSet.getString("DBtype");
				 serverip=RecordSet.getString("serverip");
				 port=RecordSet.getString("port");
				 dbname=RecordSet.getString("dbname");
				 username=RecordSet.getString("username");
				 password=RecordSet.getString("password");
				 minConnNum=RecordSet.getString("minConnNum");
				 maxConnNum=RecordSet.getString("maxConnNum");
				 datasourceDes=RecordSet.getString("datasourceDes");
			}
		}
		String needhelp ="";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowDatasource("1",id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
			<form action="/integration/dateSource/dataDMLOperation.jsp" method="post" name="datadml" id="datadml">
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="hpid" value="<%=hpid%>">
				
				
			<!-- 最外层表格-start-->
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
						<TABLE class="Shadow">
						<tr>
						<td valign="top">
								<table class=ViewForm>
								<colgroup>
								<col width="25%">
								<col width="*">
								<col width="25%">
								<col width="*">
								<tbody>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								
								<tr>    
								    <td width=20%><%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></td>
								    <td class=field colspan="3">
										<input type="text" name="sourcename"  value="<%=sourcename%>" onchange='checkinput("sourcename","sourcenamespan")'  maxlength="50">
										<span id=sourcenamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								
								<tr>    
								    <td width=20%><%=SystemEnv.getHtmlLabelName(30636,user.getLanguage())%></td>
								    <td class=field disabled>
										<%=SapUtil.getHeteProductsSelect("hpid","1","hideimg(this,sernamespan)",hpid,"selectmax_width","     ")%>
									</td>
									<td width=20%><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></td>
								    <td class=field>
								    	<%=SapUtil.getDBtypeSelect("DBtype","",DBtype,"selectmax_width","")%>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								<tr>    
								    <td width=20%><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>IP</td>
								    <td class=field>
								    	<input type="text" name="serverip" value="<%=serverip%>"  onchange='checkinput("serverip","serveripspan")'  maxlength="50">
								    	<span id=serveripspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								    <td width=20%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="port" value="<%=port%>" onchange='checkinput("port","portspan")'  maxlength="10">
								    	<span id=portspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								     </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								     <td width=20%><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></td>
								    <td class=field colspan="3">
								    	<input type="text" name="dbname" value="<%=dbname%>" onchange='checkinput("dbname","dbnamespan")'  maxlength="50">
								    	<span id=dbnamespan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								</tr>
								
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								   <td width=20%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="username" value="<%=username %>" onchange='checkinput("username","usernamespan")' maxlength="50">
								    	<span id=usernamespan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								    <td width=20%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="password" name="password" value="<%=password %>" onchange='checkinput("password","passwordspan")' maxlength="50">
								    	<span id=passwordspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								   <td width=20%><%=SystemEnv.getHtmlLabelName(30646,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="minConnNum" value="<%=minConnNum %>"  maxlength="3">
								    </td>
								   <td width=20%><%=SystemEnv.getHtmlLabelName(30647,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="maxConnNum" value="<%=maxConnNum %>" maxlength="3">
								    </td>
								</tr>
								
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								   <td width=20%><%=SystemEnv.getHtmlLabelName(30650,user.getLanguage())%></td>
								    <td class=field colSpan=3>
								    	<textarea rows="5" cols="80" name="datasourceDes"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=datasourceDes %></textarea>
								    </td>
								</tr>
							
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								</tbody>
								</table>
						</td>
						</tr>
						</TABLE>
				
				</td>
				<td></td>
				</tr>
				<tr>
				<td height="10" colspan="3"></td>
				</tr>
				</table>
			<!--最外层表格-end  -->
			</form>
</body>
<script type="text/javascript">
		
		function doSubmit()
		{
			var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			$("#datadml").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/dateSource/dataDMLlist.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
			{
				window.location.href="/integration/dateSource/dataDMLOperation.jsp?opera=delete&ids="+id+"&hpid=<%=hpid%>";
			}
		}
		function hideimg(obj,objspan)
		{
			if(obj.value)
			{
				$(objspan).html("");
			}else
			{
				$(objspan).html("<img src='/images/BacoError.gif' align=absMiddle>");
			}
			
		}
		//限制文本域的长度
		function checkLength(obj,maxlength){
		    if(obj.value.length > maxlength){
		        obj.value = obj.value.substring(0,maxlength);
		    }
		}
</script>
</html>


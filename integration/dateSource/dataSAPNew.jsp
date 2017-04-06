<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<script language="javascript" src="/js/weaver.js"></script>
<html>
	<head>
		<title>sap集成</title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30664,user.getLanguage());
		String opera="save";
		String hpid=Util.null2String(request.getParameter("hpid"));
		String dataname="";    
		String poolname="";    
		String hostname1="";
		String systemnum="";
		String saprouter="";
		String client="";
		String language="";
		String username="";
		String password="";
		String maxconnnum="";
		String datasourcedes="";
		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(30666,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from sap_datasource where id='"+id+"'");
			if(RecordSet.next())
			{
				 hpid=RecordSet.getString("hpid");    
				 dataname=RecordSet.getString("dataname");    
				 poolname=RecordSet.getString("poolname");    
				 hostname1=RecordSet.getString("hostname");    
				 systemnum=RecordSet.getString("systemNum");    
				 saprouter=RecordSet.getString("saprouter");    
				 client=RecordSet.getString("client");    
				 language=RecordSet.getString("language");    
				 username=RecordSet.getString("username");    
				 password=RecordSet.getString("password");    
				 maxconnnum=RecordSet.getString("maxConnNum");   
				 datasourcedes= RecordSet.getString("datasourcedes");  
			}
		}
		String needhelp ="";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowDatasource("3",id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
			
			<form action="/integration/dateSource/dataSAPOperation.jsp" method="post" name="sapnew" id="sapnew">
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="style" value="0">
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
								<col width="25%">
								<col width="25%">
								<col width="25%">
								<tbody>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								
								
								
								<tr>    
								    <td width=10%>SAP<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></td>
								    <td class=field colspan="3">
										<input type="text" name="poolname" style="width:200px;" value="<%=poolname%>" onchange='checkinput("poolname","poolnamespan")'  maxlength="50">
										<span id=poolnamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30636,user.getLanguage())%></td>
								    <td class=field disabled>
										<%=SapUtil.getHeteProductsSelect("","3","hideimg(this,hidspan)",hpid,"selectmax_width","     ")%>
									</td>
								     <td width=10%>
								     	<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>IP
								     </td>
								    <td class=field>
								   		<input type="text" name="hostname" style="width:200px;" value="<%=hostname1%>"  onchange='checkinput("hostname","hostnamespan")'   maxlength="50">
								   		<span id=hostnamespan>
								   			<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								   		</span>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="systemnum" style="width:200px;"  value="<%=systemnum%>"  onchange='checkinput("systemnum","systemnumspan")' maxlength="50">
								    	<span id=systemnumspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								    <td width=10%>SAP&nbsp;Router</td>
								    <td class=field>
								    	<input type="text" name="saprouter" style="width:200px;" value="<%=saprouter%>"  maxlength="80" >
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								    <td width=10%>SAP<%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></td>
								    <td class=field>
								    	
								    	<input type="text" name="client" style="width:200px;" value="<%=client%>" onchange='checkinput("client","clientspan")'  maxlength="50">
								    	<span id=clientspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								    <td width=10%><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
								    <td class=field>
								    	<select name="language"  id="language"  style="width:200px;">
								    		<option value="ZH" <% if("ZH".equals(language))  {%> selected="selected" <%} %>><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
								    		<option value="EN" <% if("EN".equals(language))  {%> selected="selected" <%} %>><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%></option>
								    	</select>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								   <td width=10%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="text" name="username" style="width:200px;" value="<%=username%>" onchange='checkinput("username","usernamespan")' maxlength="50">
								    	<span id=usernamespan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								    <td width=10%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
								    <td class=field>
								    	<input type="password" name="password" style="width:200px;" value="<%=password%>" onchange='checkinput("password","passwordspan")' maxlength="50">
								    	<span id=passwordspan>
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>
								   <td width=10%><%=SystemEnv.getHtmlLabelName(30673,user.getLanguage())%></td>
								    <td class=field colspan="3">
								    	<textarea rows="5" cols="100" name="datasourcedes"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"   style="height: 80px"><%=datasourcedes%></textarea>
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
<style>
	.huotu_dialog_overlay
	{
		z-index:99991;
		position:fixed;
		filter:alpha(opacity=30); BACKGROUND-COLOR: #000;
		width:100%;
		bottom:0px;
		height:100%;
		top:0px;
		right:0px;
		left:0px;
		opacity:.9;
		_position:absolute;		
		margin: 0px;
		padding: 0px;
		overflow: hidden;
		display: none;
	}
	.bd_dialog_main
	{	
		z-index:99992;
		position:fixed;
		_position:absolute;	
		color: white;	
	}
</style>	
 	
<DIV class=huotu_dialog_overlay id="test">
		<div style="width:200;height:100" id="test2" class="bd_dialog_main">
				<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>
		</div>
</DIV>

</body>
<script type="text/javascript">
		$(document).ready(function() {  
			$("#onsave").click (function(){
				//newServer.submit();
				//网页正文全文高
				var temp=document.body.scrollHeight;
				$("#test").css("height",temp);
				var h2=$("#test2").css("height");
				var w2=$("#test2").css("width");
				var a=(document.body.clientWidth)/2-100; 
				var b=(document.body.clientHeight)/2-50;
				$("#test2").css("left",a);
				$("#test2").css("top",b);
				$("#test").show();
			});
			
		});
		
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
			var hostname = $("input[name='hostname']").attr("value");
			var systemnum = $("input[name='systemnum']").attr("value");
			var saprouter = $("input[name='saprouter']").attr("value");
			var client = $("input[name='client']").attr("value");
			var language = $("#language").val();
			var username = $("input[name='username']").attr("value");
			var password = $("input[name='password']").attr("value");
			enableAllmenu();
			$.post("/integration/dateSource/checkSAPDataSourceAjax.jsp",{hostname:hostname,saprouter:saprouter,systemnum:systemnum,client:client,language:language,username:username,password:password},function(data){ 
				if(data["content"]) {
					$("#sapnew").submit();
				}else if(window.confirm("<%=SystemEnv.getHtmlLabelName(30675,user.getLanguage())%>"))  {
					$("#sapnew").submit();
				}
				displayAllmenu();
			},"json");
			
		}
		function doGoBack()
		{
			window.location.href="/integration/dateSource/dataSAPlist.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
			{
				window.location.href="/integration/dateSource/dataSAPOperation.jsp?opera=delete&ids="+id+"&hpid=<%=hpid%>";
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


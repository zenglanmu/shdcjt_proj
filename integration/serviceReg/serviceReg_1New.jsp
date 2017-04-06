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
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage())%></title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String hpid=Util.null2String(request.getParameter("hpid"));//异构产品的id
		String id=Util.null2String(request.getParameter("id"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30697,user.getLanguage());
		String opera="save";
		String poolid="";
		String opermode="";
		String serdesc="";
		String regname="";
		
		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(30699,user.getLanguage()); //修改DML服务
			opera="update";
			//查出默认值
			RecordSet.execute("select * from dml_service where id='"+id+"'");
			if(RecordSet.next())
			{
				 regname=RecordSet.getString("regname");
				 poolid=RecordSet.getString("poolid");
				 opermode=RecordSet.getString("opermode");
				 serdesc=RecordSet.getString("serdesc");
				 hpid=RecordSet.getString("hpid");
			}
		}
		String needhelp ="";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(1290,user.getLanguage()) +",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew))
			{
				RCMenu += "{"+ SystemEnv.getHtmlLabelName(23777,user.getLanguage()) +",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
			<form action="/integration/serviceReg/serviceReg_1Operation.jsp" method="post" name="datadml" id="datadml">
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
								<col width="25%">
								<col width="25%">
								<col width="25%">
								<tbody>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30672,user.getLanguage())%></td>
								    <td class=field colspan="3">
										<input type="text" name="regname"  value="<%=regname%>" onchange='checkinput("regname","regnamespan")' maxlength=50>
										<span id=regnamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30701,user.getLanguage())%></td>
								    <td class=field colspan="3">
										 	<%=SapUtil.getDatasourceSelect("2","poolid","hideimg(this,poolidspan)",poolid,"selectmax_width","   ") %>
										<span id=poolidspan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30662,user.getLanguage())%></td>
								    <td class=field colspan="3">
											<%=SapUtil.getDMLModeSelect("opermode","hideimg(this,opermodespan)",opermode,"selectmax_width","   ") %>
											<span id=opermodespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
											</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30676,user.getLanguage())%></td>
								    <td class=field colspan="3">
											<textarea rows="4" cols="80" name="serdesc" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=serdesc%></textarea>
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
				<td height="10" colspan="3">%</td>
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
				alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
				return;
			}
			$("#datadml").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/serviceReg/serviceReg_1list.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"))
			{
				window.location.href="/integration/serviceReg/serviceReg_1Operation.jsp?opera=delete&ids="+id+"&hpid=<%=hpid%>";
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


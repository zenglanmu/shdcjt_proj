<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="com.weaver.integration.params.*,com.weaver.integration.datesource.*,com.weaver.integration.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
			String servId = Util.null2String(request.getParameter("servId"));
			String browserId = Util.null2String(request.getParameter("browserId"));
			String poolid = Util.null2String(request.getParameter("poolid"));
			
			SAPInterationBean sib = SAPInterationDateSourceUtil.getSAPBean(poolid);
			String poolname = "";
			String serviceName = "";
			String sapfunname = "";
			String browserName = "";
			ServiceParamModeBean spmb = null;
			if(!"".equals(browserId)) {
				spmb = ServiceParamModeUtil.getSerParModBeanById(browserId, true);
			}
			if(spmb != null) {
				browserName = spmb.getParamModeName();
			}
			browserName = "".equals(browserName)?SystemEnv.getHtmlLabelName(30737,user.getLanguage()):SystemEnv.getHtmlLabelName(30736,user.getLanguage())+"-"+browserName;
			if(sib != null) {
				poolname = sib.getPoolname();
			}
			SAPServiceBean ssb = new SAPServcieUtil().getRegNameAndSAPFunctionById(servId);
			if(ssb != null) {
				serviceName = ssb.getRegname();
				sapfunname = ssb.getFunname();
			}
			
%>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(30735,user.getLanguage())%>-<%=browserName %></title>
		<style type="text/css">
			.selectItemCss {
				width:250px;
				margin-right: 0px;
			}
		</style>
	</head>
	<body>

	
		
		<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this,1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp" %>
		
		
		
		<div style="width: 100%;padding: 10px;">
		<!-- Shadow表格-start -->
		<TABLE class="Shadow">
			<tr>
				<td valign="top">
					<!--ListStyle 表格start  -->
				    <TABLE class=ListStyle cellspacing=1 style="table-layout: fixed;">
						<COLGROUP>
							<COL width="120px"/>
							<COL width="*"/>
						</COLGROUP>
						<TR class=Header >
							<TH colspan="2"><%=SystemEnv.getHtmlLabelName(30735,user.getLanguage())%>-<%=browserName %></TH>
						</TR>
						<TR class=Line style="height:1px">
							<TD colSpan=2 style="padding:0px"></TD>
						</TR>
						<TR class=DataLight>	
							<TD><%=SystemEnv.getHtmlLabelName(30660,user.getLanguage())%></TD>
							<TD>
								<select id="poolid" disabled="disabled" style="width:250px;">
									<option value="<%=poolid %>"><%=poolname %></option>
								</select>
							</TD>
						</TR>
						<TR class=DataDark>	
							<TD><%=SystemEnv.getHtmlLabelName(30738,user.getLanguage())%></TD>
							<TD>
								<select id="servId" disabled="disabled" style="width:250px;">
									<option value="<%=servId %>"><%=serviceName %></option>
								</select>
							</TD>
						</TR>
						<TR class=DataLight>	
							<TD><%=SystemEnv.getHtmlLabelName(30739,user.getLanguage())%></TD>
							<TD>
								<%=sapfunname%>
								<input type="hidden" style="width:250px;height:30px;" name="sapfunname" value="<%=sapfunname%>">
								<input type="hidden" id="marktemp" name="marktemp" value="<%=browserId%>">
							</TD>
						</TR>
					</TABLE>
					<!--ListStyle 表格end  -->
				</td>
			</tr>
		</TABLE>
		<!-- Shadow表格-end -->
		<iframe src="/integration/serviceReg/serviceReg_3NewParamsModeSet.jsp?browserId=<%=browserId %>&servId=<%=servId %>&poolid=<%=poolid %>" style="width: 100%;height: 400px;" frameborder="0" scrolling="no" id="maindiv">
		</iframe>
		</div>
		
	
	<DIV class=huotu_dialog_overlay id="hidediv">
			
	</DIV>
	<div  id="hidedivmsg" class="bd_dialog_main">
						
	</div>
		<script type="text/javascript">
			var temp=document.body.clientWidth;
			$("#hidediv").css("height",temp);
			var h2=$("#hidedivmsg").css("height");
			var w2=$("#hidedivmsg").css("width");
			var a=(document.body.clientWidth)/2-140; 
			var b=(document.body.clientHeight)/2-40;
			$("#hidedivmsg").css("left",a);
			$("#hidedivmsg").css("top",b);
			$("#hidediv").show();
			$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%> ").show();
		</script>
		<script type="text/javascript">
			//数据提交
			function doSubmit(obj,dataauth)
			{
				
				//验证外层页面的数据必填性
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
					alert("必要数据不完整!");
					return;
				}
				
				//验证内层页面的数据必填性
				if(window.frames["maindiv"].checkRequired())
				{
					//alert($("#mark").val()+"__"+$("#hpid").val());
				
			
					//判断是否显示数据授权界面
					var temp=document.body.clientWidth;
					$("#hidediv").css("height",temp);
					var h2=$("#hidedivmsg").css("height");
					var w2=$("#hidedivmsg").css("width");
					var a=(document.body.clientWidth)/2-140; 
					var b=(document.body.clientHeight)/2-40;
					$("#hidedivmsg").css("left",a);
					$("#hidedivmsg").css("top",b);
					$("#hidediv").show();
					$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>").show();
					window.frames["maindiv"].document.getElementById("weaver").submit();
				}
			}
			 $(window).unload(function () {
			 	 if($("#marktemp").val()!="")
			 	 {	
			 	 	window.returnValue=$("#marktemp").val();
			 	 }	
			 });
			 function changeurl(utlstr)
			 {
			 	//参考http://www.jb51.net/article/21139.htm
			 	window.name = "__self"; 
				window.open(utlstr, "__self"); 
				
			 }
			 
			 function doGoBack() {
				 window.close();
			 }
		</script>
	</body>
</html>


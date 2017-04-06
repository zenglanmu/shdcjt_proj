<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="com.weaver.integration.params.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="IntegratedMethod" class="com.weaver.integration.util.IntegratedMethod" scope="page"/>
<jsp:useBean id="su" class="com.weaver.integration.util.SAPServcieUtil" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<html>
	<head>
		<title>sap集成</title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String hpid=Util.null2String(request.getParameter("hpid"));//异构产品的id
		String id=Util.null2String(request.getParameter("id"))+"";//服务id
		boolean isCanUpdFlag = true;
		boolean isCanUpdFlag01= true;
		if(!"".equals(id)) {
			isCanUpdFlag01 = su.isExitParams(id);
		}
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30709,user.getLanguage());
		String opera="save";
		String poolid="";
		String funname="";
		String fundesc="";
		String loadmb="";
		String serdesc="";
		String regname="";
		ServiceParamModeBean spmb = null;
		String serviceParamModeId = "";
		String serviceParamModeName = "";
		String poolname="";
		String loadDate="";
		if("1".equals(isNew))
		{
			titlename =  SystemEnv.getHtmlLabelName(30710,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select a.*,b.poolname from sap_service  a left join sap_datasource b on a.poolid=b.id where a.id='"+id+"'");
			if(RecordSet.next())
			{
				 regname=RecordSet.getString("regname");
				 poolid=RecordSet.getString("poolid");
				 serdesc=RecordSet.getString("serdesc");
				 funname=RecordSet.getString("funname");
				 fundesc=RecordSet.getString("fundesc");
				 hpid=RecordSet.getString("hpid");
				 poolname=RecordSet.getString("poolname");
				 loadmb=RecordSet.getString("loadmb");
				 loadDate=RecordSet.getString("loadDate");
			}
			spmb = ServiceParamModeUtil.getSerParModBeanById(id, false);
			if(spmb != null) {
				serviceParamModeName = spmb.getParamModeName();
				serviceParamModeId = spmb.getId();
				isCanUpdFlag01=false;//表示已经绑定了服务参数模板
			}
		}
		String needhelp ="";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			if(isCanUpdFlag01)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				if(spmb == null) {
					RCMenu += "{"+SystemEnv.getHtmlLabelName(30711,user.getLanguage())+",javascript:doSubmitAndParseParams(this),_self} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			}else
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit2(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&IntegratedMethod.getIsShowBox3(id).equals("true"))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			<form action="/integration/serviceReg/serviceReg_3Operation.jsp" method="post" name="datadml" id="datadml">
				<input type="hidden" name="opera"  id="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="hpid" value="<%=hpid%>">
				<input type="hidden" name="serviceParamModeId" value="<%=serviceParamModeId%>">
				<input type="hidden" name="isParseParams" value="">
				<input type="hidden" name="isCheckFunction" value="">
				<input type="hidden" name="maxNums" value="">
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
										<input type="text" name="regname"  value="<%=regname%>"  onchange="checkinput('regname','regnamespan')" style="width:250px;" maxlength="80">
										<span id=regnamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								<tr>    
								    <td width=10%>SAP<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
								    <td class=field colspan="3">
								   			 <%if(!isCanUpdFlag01) {
													//如果该服务下存在函数模板，则不可删
								   					out.println(poolname);
								   					out.println("<input name='poolid' id='poolid' type='hidden' value="+poolid+">");
								   				 }else
								   				 {
										 			out.println(SapUtil.getDatasourceSelect("1","poolid","hideimg(this,poolidspan)",poolid,"selectmax_width","   ")); 
								   				 }
										 	%>
										<span id=poolidspan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30713,user.getLanguage())%></td>
								    <td class=field colspan="3">
								    		<%if(!isCanUpdFlag01) {
													//如果该服务下存在函数模板，则不可删
								   					out.println(funname);
								   					out.println("<input name='funname' id='funname' type='hidden' value="+funname+" maxlength=80>");
								   				 }else
								   				 {
								   			%>
								   				<input type="text" name="funname"  value="<%=funname%>" style="width:250px;" onchange="checkinput('funname','funnamespan'),getRegName(),upperCase(this)" maxlength=80>
								   			<%
								   				 }
										 	%>
											
											<span id=funnamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
											</span>
											<button  id="btnFunCheck" onclick="javascript:doTestFunction();" class="btn" type="button" <%if(!isCanUpdFlag) { %>disabled="disabled" <%} %>><%=SystemEnv.getHtmlLabelName(30714,user.getLanguage())%></button>
											<%if(!isCanUpdFlag01) {
											%>
												<button   class="btn"  onclick="javascript:gerparfar();" type="button"><%=SystemEnv.getHtmlLabelName(30716,user.getLanguage())%></button>
											<%
												}
											%>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>    
								    <td width=10% ><%=SystemEnv.getHtmlLabelName(30717,user.getLanguage())%></td>
								    <td class=field colspan="3">
											&nbsp;<button  id="servParamModeSetBtn"  class='browser' type="button" style="margin-bottom:1px;" onclick="javascript:servParamModeSetFunc();"></button>
											<span id="servParamModeSetSpan"><%=serviceParamModeName %></span>
											
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								
								
								<tr  style="<%if("".equals(serviceParamModeName)){out.println("display:none");}%>"  id="wf_show01">    
								    <td width=10% ><%=SystemEnv.getHtmlLabelName(30719,user.getLanguage())%></td>
								    <td class=field colspan="3">
											<input type="checkbox" value="1" name="loadmb" <%if("1".equals(loadmb)){out.println("checked='checked'");}%>>
									</td>
								</tr>
								<TR style="height:1px;<%if("".equals(serviceParamModeName)){out.println("display:none");}%>" id="wf_show02"><TD class=Line colSpan=4></TD></TR> 
								
								
								<tr>    
								    <td width=10% >自动抓取数据</td>
								    <td class=field colspan="3">
											<input type="checkbox" value="1" name="loadDate" <%if("1".equals(loadDate)){out.println("checked='checked'");}%>>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>    
								    <td width=10% height="80"><%=SystemEnv.getHtmlLabelName(30720,user.getLanguage())%></td>
								    <td class=field colspan="3">
											<textarea style="height: 100%;" name="serdesc" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=serdesc%></textarea>
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
			
	<DIV class=huotu_dialog_overlay id="hidediv">
			
	</DIV>
	<div  id="hidedivmsg" class="bd_dialog_main">
						
	</div>
</body>
<script type="text/javascript">

		function upperCase(x)   {
            var y=x.value;
            x.value=y.toUpperCase();
        }
		function servParamModeSetFunc() {
			<%if(isCanUpdFlag01) {%>
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
				//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
				if($("input[name='regname']").attr("value") == '') {
					alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				}
				var ischeckfun = $("input[name='isCheckFunction']").attr("value");
				if(ischeckfun == 'no') {
						alert("<%=SystemEnv.getHtmlLabelName(30722,user.getLanguage())%>");
						return;
				}else if(ischeckfun == '') {
					var funName = $.trim($("input[name='funname']").attr("value"));
					var poolid = $("#poolid").val();
					$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
						if(!data["flag"]) {
							$("input[name='funname']").focus().select();
							$("input[name='isCheckFunction']").attr("value","no");
							alert("<%=SystemEnv.getHtmlLabelName(30722,user.getLanguage())%>");
						    return;
						}else {
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30729,user.getLanguage())%>"))
							{
								$("input[name='isCheckFunction']").attr("value","yes");
								$("input[name='isParseParams']").attr("value","yes");
								var a=(document.body.clientWidth)/2-140; 
								var b=(document.body.clientHeight)/2-40;
								$("#hidedivmsg").css("left",a);
								$("#hidedivmsg").css("top",b);
								$("#hidediv").show();
								$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30730,user.getLanguage())%>").show();
								$("#datadml").submit();
							}
						}
					},"json");
				}else if(ischeckfun == 'yes') {
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30729,user.getLanguage())%>"))
					{
						$("input[name='isParseParams']").attr("value","yes");
						var a=(document.body.clientWidth)/2-140; 
						var b=(document.body.clientHeight)/2-40;
						$("#hidedivmsg").css("left",a);
						$("#hidedivmsg").css("top",b);
						$("#hidediv").show();
						$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30730,user.getLanguage())%>").show();
						$("#datadml").submit();
					}
				}
			<%}else {%>
				var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
		    	var top = Math.ceil((screen.height - 600) / 2);  //实现居中
		    	var serviceParamModeId = $.trim($("input[name='serviceParamModeId']").attr("value"));
		    	var urls ="/integration/serviceReg/serviceReg_3NewParamsMode.jsp?sid=3&poolid=<%=poolid%>&servId=<%=id%>&browserId="+serviceParamModeId;
					var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
		  		var temp = window.showModalDialog(urls,"",tempstatus);
		  		if(temp) {
		  			$("#servParamModeSetSpan").html("paramMode."+temp);
		  			$("input[name='serviceParamModeId']").attr("value",temp);
		  			$("#wf_show01").show();
		  			$("#wf_show02").show();
		  		}
			<%}%>
		}
		
		function doSubmit2(obj)
		{
			//只保存，只修改sap注册服务描述里面的内容
			$("#opera").attr("value","updatedesc");
			$("#datadml").submit();
		}
		function doSubmit(obj)
		{
			$(obj).parent().find("button").attr("disabled","disabled");
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
				$(obj).parent().find("button").attr("disabled","");
				return;
			}
			//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
			if($("input[name='regname']").attr("value") == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			var ischeckfun = $("input[name='isCheckFunction']").attr("value");
			if(ischeckfun == 'no') {
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30734,user.getLanguage())%>")) {
					$("#datadml").submit();
				}else {
					$(obj).parent().find("button").attr("disabled","");
					return;
				}
			}else if(ischeckfun == '') {
				var funName = $.trim($("input[name='funname']").attr("value"));
				var poolid = $("#poolid").val();
				$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
					if(!data["flag"]) {
						$("input[name='funname']").focus().select();
						$("input[name='isCheckFunction']").attr("value","no");
							if(window.confirm("<%=SystemEnv.getHtmlLabelName(30734,user.getLanguage())%>")) {
							$("#datadml").submit();
						}else {
							$(obj).parent().find("button").attr("disabled","");
							return;
						}
					}else {
						$("input[name='isCheckFunction']").attr("value","yes");
						$("#datadml").submit();
					}
				},"json");
			}else if(ischeckfun == 'yes') {
				$("#datadml").submit();
			}
		}
		
		function doSubmitAndParseParams(obj)
		{
			$(obj).parent().find("button").attr("disabled","disabled");
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
				$(obj).parent().find("button").attr("disabled","");
				return;
			}
			//$("input[name='regname']").attr("value",$.trim($("#regnameSpan").html()));
			if($("input[name='regname']").attr("value") == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			var ischeckfun = $("input[name='isCheckFunction']").attr("value");
			if(ischeckfun == 'no') {
							window.alert("<%=SystemEnv.getHtmlLabelName(30733,user.getLanguage())%>");
					$(obj).parent().find("button").attr("disabled","");
					return;
			}else if(ischeckfun == '') {
				var funName = $.trim($("input[name='funname']").attr("value"));
				var poolid = $("#poolid").val();
				$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
					if(!data["flag"]) {
						$("input[name='funname']").focus().select();
						$("input[name='isCheckFunction']").attr("value","no");
							window.alert("<%=SystemEnv.getHtmlLabelName(30733,user.getLanguage())%>");
							$(obj).parent().find("button").attr("disabled","");
							return;
					}else {
						if(window.confirm("<%=SystemEnv.getHtmlLabelName(30732,user.getLanguage())%>"))
						{
							$("input[name='isCheckFunction']").attr("value","yes");
							$("input[name='isParseParams']").attr("value","yes");
							$("#datadml").submit();
						}else
						{
							$(obj).parent().find("button").attr("disabled","");
						}
					}
				},"json");
			}else if(ischeckfun == 'yes') {
				$("input[name='isParseParams']").attr("value","yes");
				$("#datadml").submit();
			}
			
			
		}
		
		function doGoBack()
		{
			window.location.href="/integration/serviceReg/serviceReg_3list.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"))
			{
				window.location.href="/integration/serviceReg/serviceReg_3Operation.jsp?opera=delete&ids="+id+"&hpid=<%=hpid%>";
			}
		}
		function gerparfar()
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30731,user.getLanguage())%>"))
			{
				$("#opera").attr("value","refresh");
				$("input[name='isParseParams']").attr("value","yes");
				$("#datadml").submit();
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
			
			if($.trim($("input[name='funname']").attr("value")) == '' || $("#poolid").val() == '') {
				//$("#regnameSpan").html("");
			}else {
				getRegNameNum();
			}
			$("input[name='isCheckFunction']").attr("value","");
		}
		
		function getRegName() {
			$("input[name='isCheckFunction']").attr("value","");
			if($.trim($("input[name='funname']").attr("value")) == '' ||  $("#poolid").val() == '') {
				$("#regnameSpan").html("");
			}else {
				getRegNameNum();
			}
		}
		
		function getRegNameNum() {
				var temp  = $.trim($("input[name='funname']").attr("value"))+"_";
				var maxNums = $("input[name='maxNums']").attr("value");
				if(maxNums == '') {
					$.post("/integration/serviceReg/getMaxSAPServcieNumsAjax.jsp",{hpid:<%=hpid%>},function(data){ 
						$("#regnameSpan").html("").html(temp+data["content"]);
					},"json");
				}else {
					$("#regnameSpan").html("").html(temp+maxNums);
				}
				
		}
		
		function doTestFunction() {
			$("#btnFunCheck").attr("disabled","disabled");
			
			var funName = $.trim($("input[name='funname']").attr("value"));
			var poolid = $("#poolid").val();
			if(funName == '' || poolid == '') {
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				$("#btnFunCheck").attr("disabled","");
				return;
			}
			
			$.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",{funName:funName,poolid:poolid},function(data){ 
				alert(data["message"]);
				$("#btnFunCheck").attr("disabled","");
				if(!data["flag"]) {
					$("input[name='funname']").focus().select();
					$("input[name='isCheckFunction']").attr("value","no");
				}else {
					$("input[name='isCheckFunction']").attr("value","yes");
				}
			},"json");
		}
		
		//限制文本域的长度
		function checkLength(obj,maxlength){
		    if(obj.value.length > maxlength){
		        obj.value = obj.value.substring(0,maxlength);
		    }
		}
		
</script>
</html>


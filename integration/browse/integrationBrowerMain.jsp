<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="com.weaver.integration.params.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
			
			String browsertype=Util.null2String(request.getParameter("browsertype"));//如果=226表示是集成开发单选，=227表示是集成开发多选
			if("227".equals(browsertype))
			{
				out.println(SystemEnv.getHtmlLabelName(30653 ,user.getLanguage()));
				return;
			}
			
			String title="系统集成单选浏览按钮配置";
			String formid=Util.null2String(request.getParameter("formid"));//得到流程表单的formid
			String mark=Util.null2String(request.getParameter("mark")).trim();//浏览按钮标识的id
			String dataauth=Util.null2String(request.getParameter("dataauth"));//得到是否跳到数据授权界面
			String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
			String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
			String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
			String iframsr="/integration/browse/integrationSapDirections.jsp?w_type="+w_type;
			//String nodename = "";		
			//String workFlowName = "";
			int isbill = 0;//老表单还是新表单,0表示老表单1,表示新表单
			//节点id
			int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
			//是否节点后附加操作
			int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
			//出口id
			int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
			//工作流的id
			int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
			if("1".equals(w_type))
			{
				 title="节点动作action配置";
				//if(nodeid>0){
					//RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
					//if(RecordSet.next()){
						//nodename = RecordSet.getString("nodename");
					//}
				//}
				if(workflowid>-1){
					//workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowid));
					isbill = Util.getIntValue(WorkflowComInfo.getIsBill("" + workflowid), 0);
					formid = Util.getIntValue(WorkflowComInfo.getFormId("" + workflowid), 0)+"";
				}
			}
			
			String opera="save";
			if(!"".equals(mark)){opera="update";}
			String hpid="";
			String poolid="";
			String baseid="";//浏览按钮的id
			String w_enable="";//是否启用
			String regservice="";//所属服务
			String brodesc="";
			String authcontorl="";
			String sid="";
			String servicesid="";
			//boolean flag = false;
			String regname="";
			String w_actionorder="";
			//依据浏览按钮的标识，查出浏览按钮的基本信息
			if("update".equals(opera))
			{
			
				String sql="select a.*,b.sid from int_BrowserbaseInfo a left join  int_heteProducts b on a.hpid=b.id where mark='"+mark+"'";
				if(RecordSet.execute(sql)&&RecordSet.next())
				{
					 baseid=RecordSet.getString("id");
					 hpid=RecordSet.getString("hpid");
					 poolid=RecordSet.getString("poolid");
					 w_actionorder=RecordSet.getString("w_actionorder");
					 sid=RecordSet.getString("sid");
					 regservice=RecordSet.getString("regservice");//所属服务
					 brodesc=RecordSet.getString("brodesc");
					 authcontorl=RecordSet.getString("authcontorl");
					 w_enable=RecordSet.getString("w_enable");
					 servicesid=sid+"_"+hpid+"_"+poolid+"_"+regservice;
					 if("1".equals(sid))//1--中间表,对应的数据源为dml数据源表(这是规定)
					 {
					 	rs.execute("select * from dml_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }else if("2".equals(sid))//2--webservice,对应的数据源为webservice据源表(这是规定)
					 {
					 	rs.execute("select * from ws_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }else if("3".equals(sid))//3---rfc,对应的数据源为sap数据源表(这是规定)
					 {
					 	rs.execute("select * from sap_service where id="+regservice);
					 	if(rs.next())
					 	{
					 		regname=rs.getString("regname");
					 	}
					 }
				}
				// flag = ServiceParamsUtil.isExitsLocalParams(regservice);
				 iframsr="/integration/browse/integrationBrowerSet.jsp?opera="+opera+"&baseid="+baseid+"&formid="+formid+"&updateTableName="+updateTableName+"&dataauth="+dataauth+"&mark="+mark+"&regservice="+regservice+"&w_type="+w_type+"&isbill="+isbill+"&nodeid="+nodeid+"&workflowid="+workflowid+"&srcType="+srcType;
			}
		%>
<html>
	<head>
		<title><%=title%>-<%=mark%></title>
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
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86 ,user.getLanguage())+",javascript:doSubmit(this,1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//RCMenu += "{保存并存为模板,javascript:doSubmit(this,2),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		if(!"1".equals(w_type))
		{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30656 ,user.getLanguage())+",javascript:doSubmit(this,2),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201 ,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
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
							<COL width="300px"/>
							<COL width="*"/>
						</COLGROUP>
						<TR class=Header >
							<TH colspan="3"><%=title%>-<%=mark%></TH>
						</TR>
						<TR class=Line style="height:1px">
							<TD colSpan=3 style="padding:0px"></TD>
						</TR>
						<input type="hidden" id="mark" name="mark" value="<%=mark%>">
						<TR class=DataLight>	
							<TD><%=SystemEnv.getHtmlLabelName(30657 ,user.getLanguage()) %></TD>
							<TD colSpan=2>
								<button type='button' class='browser' onclick=onchangeservice(this)></button> 
								<input type=hidden name="servicesid" id="servicesid" value="<%=servicesid%>">
								<span><%=regname%></span>
								<span id=regservicesapn>
									<%if(!"update".equals(opera)){out.println("<img src='/images/BacoError.gif' align=absMiddle>");}%>
								</span>
							</TD>
						</TR>
						<TR class=DataDark>	
							<TD><%=SystemEnv.getHtmlLabelName(30658 ,user.getLanguage()) %></TD>
							<TD colSpan=2>
								<textarea rows="5" cols="80" id="brodesc" tabindex="1" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"><%=brodesc%></textarea>
							</TD>
						</TR>
						<%
							if("0".equals(w_type))
							{
						 %>
						<TR class=DataLight>	
							<TD><%=SystemEnv.getHtmlLabelName(30659 ,user.getLanguage()) %></TD>
							<TD colSpan=2>
								<input type="checkbox" name="authcontorl"  id="authcontorl" value="1" <%if("1".equals(authcontorl)){out.println("checked=checked");} %>>
							</TD>
						</TR>
						<%
							}
						 %>
						<%
						
							if("1".equals(w_type))
							{
								
								
						 %>
						<TR class=DataLight>	
							<TD><%=SystemEnv.getHtmlLabelName(18624 ,user.getLanguage()) %></TD>
							<TD colSpan=2>
								<input type="checkbox" name="w_enable" id="w_enable" value="1" <%if("1".equals(w_enable)){out.println("checked='checked'");}%>>
							</TD>
						</TR>
						
						<TR class=DataDark>	
							<TD>执行顺序</TD>
							<TD colSpan=2>
								<input type="text"  maxlength="3" name="w_actionorder" id="w_actionorder" value="<%=w_actionorder%>"> 
								(数据越小，执行优先)
							</TD>
						</TR>
						
						<%
							}	
						%>
							
					</TABLE>
					<!--ListStyle 表格end  -->
				</td>
			</tr>
		</TABLE>
		<!-- Shadow表格-end -->
		<iframe src="<%=iframsr%>" style="width: 100%;height: 400px;" frameborder="0" scrolling="no" id="maindiv">
		</iframe>
		</div>
		
	
	<DIV class=huotu_dialog_overlay id="hidediv">
			
	</DIV>
	<div  id="hidedivmsg" class="bd_dialog_main">
						
	</div>
		
		<script type="text/javascript">
		
			var updateChangeService="0";//1表示新建的时候change注册服务，2表示修改的时候change注册服务,"0"表示没用进行change操作,"3"表示修改的时候change操作到了初始状态的时候
			//判断iframe是否加载完成
			function iframeLoaded(iframeEl, callback) {
		     	if(iframeEl.attachEvent) {
		            iframeEl.attachEvent("onload", function() {
		                if(callback && typeof(callback) == "function") {
		                    callback();
		                }
		            });
		        } else {
		            iframeEl.onload = function() {
		                if(callback && typeof(callback) == "function") {
		                    callback();
		                }
		            }
		        }
		   }
		   //iframe加载完成后回调的函数
			function closeDIV()
			{
				document.getElementById("hidediv").style.display="none";
				document.getElementById("hidedivmsg").style.display="none";
			}
			
			function onchangeservice(obj)
			{
				<%
					if("save".equals(opera))
					{
				%>
						updateChangeService="1";
				<%
					}else if("update".equals(opera))
					{
				%>
						updateChangeService="2";
				<%
					}
				%>
					
				var selectedids=$("#servicesid").val();
				var sid = window.showModalDialog("/integration/browse/IntegrationServiceBrower.jsp?selectedids="+selectedids, "", "dialogWidth:550px;dialogHeight:550px;");
				if(sid)
				{
					$("#servicesid").attr("value",sid.id);
					$("#servicesid").next().html(sid.name);
					if(sid.id!="")
					{
						var regservice = $("#servicesid").val().split("_")[3];//服务的id
						$("#servicesid").next().next().html("");
						var temp=document.body.clientWidth;
						$("#hidediv").css("height",temp);
						var h2=$("#hidedivmsg").css("height");
						var w2=$("#hidedivmsg").css("width");
						var a=(document.body.clientWidth)/2-140; 
						var b=(document.body.clientHeight)/2-40;
						$("#hidedivmsg").css("left",a);
						$("#hidedivmsg").css("top",b);
						$("#hidediv").show();
						$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(30661 ,user.getLanguage()) %>"+"...").show();
						
						<%
							if("update".equals(opera))
							{
						%>
								if("<%=regservice%>"==regservice)
								{
									updateChangeService="3";
								}
						<%
							}
						%>
				
						var args0="?opera=<%=opera%>";
							args0+="&baseid=<%=baseid%>";
							args0+="&formid=<%=formid%>";
							args0+="&updateTableName=<%=updateTableName%>";
							args0+="&dataauth=<%=dataauth%>";
							args0+="&mark=<%=mark%>";
							args0+="&regservice="+regservice+"";
							args0+="&w_type=<%=w_type%>";
							args0+="&isbill=<%=isbill%>";
							args0+="&nodeid=<%=nodeid%>";
							args0+="&workflowid=<%=workflowid%>";
							args0+="&updateChangeService="+updateChangeService+"";
							args0+="&srcType=<%=srcType%>";
							
							
						document.getElementById("maindiv").src="/integration/browse/integrationBrowerSet.jsp"+args0;
						iframeLoaded(document.getElementById("maindiv"),closeDIV);//回调
					}else
					{
						$("#servicesid").next().next().html("<img src='/images/BacoError.gif' align=absMiddle>");
						document.getElementById("maindiv").src="/integration/browse/integrationSapDirections.jsp?w_type=<%=w_type%>";
						
					}
				}
			}
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
					alert("<%=SystemEnv.getHtmlLabelName(30622 ,user.getLanguage()) %>"+"!");
					return;
				}
				try
				{
					window.frames["maindiv"].document.getElementById("mark").value;
				}catch(e)
				{
					//如果报错，表示下面的页面对象不存在
					alert("<%=SystemEnv.getHtmlLabelName(30663 ,user.getLanguage()) %>"+"!");
					return;
				}
				
				//验证内层页面的数据必填性
				if(window.frames["maindiv"].checkRequired())
				{
					
					window.frames["maindiv"].document.getElementById("mark").value=$("#mark").val();
					window.frames["maindiv"].document.getElementById("hpid").value=$("#servicesid").val().split("_")[1];
					window.frames["maindiv"].document.getElementById("poolid").value=$("#servicesid").val().split("_")[2];
					window.frames["maindiv"].document.getElementById("regservice").value=$("#servicesid").val().split("_")[3];
					window.frames["maindiv"].document.getElementById("brodesc").value=$("#brodesc").val();
					window.frames["maindiv"].document.getElementById("w_actionorder").value=$("#w_actionorder").val();
					
					
					if($("#authcontorl").is(":checked"))//jquery判断复选框被选中
					{
						window.frames["maindiv"].document.getElementById("authcontorl").value="1";
					}
					window.frames["maindiv"].document.getElementById("ispreoperator").value="<%=ispreoperator%>";
					window.frames["maindiv"].document.getElementById("nodelinkid").value="<%=nodelinkid%>";
					if($("#w_enable").is(":checked"))//jquery判断复选框被选中
					{
						window.frames["maindiv"].document.getElementById("w_enable").value="1";
					}
					//判断是否显示数据授权界面
					window.frames["maindiv"].document.getElementById("dataauth").value=dataauth;
					var temp=document.body.clientWidth;
					$("#hidediv").css("height",temp);
					var h2=$("#hidedivmsg").css("height");
					var w2=$("#hidedivmsg").css("width");
					var a=(document.body.clientWidth)/2-140; 
					var b=(document.body.clientHeight)/2-40;
					$("#hidedivmsg").css("left",a);
					$("#hidedivmsg").css("top",b);
					$("#hidediv").show();
					$("#hidedivmsg").html("<%=SystemEnv.getHtmlLabelName(20240 ,user.getLanguage()) %>").show();
					window.frames["maindiv"].document.getElementById("weaver").submit();
				}
			}
			 $(window).unload(function () {
			 	 if($("#mark").val()!="")
			 	 {	
			 	 	window.returnValue=$("#mark").val();
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
			 //限制文本域的长度
			function checkLength(obj,maxlength){
			    if(obj.value.length > maxlength){
			        obj.value = obj.value.substring(0,maxlength);
			    }
			}
		</script>
	</body>
</html>


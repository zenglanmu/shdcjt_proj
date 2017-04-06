<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<jsp:useBean id="ServiceReginfo" class="com.weaver.integration.util.ServiceRegTreeInfo" scope="page"/>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage())%></title>
	</head>
	<%
		
		String hpid=Util.null2String(request.getParameter("hpid"));//异构产品的id
		String opermode=Util.null2String(request.getParameter("opermode"));//操作方式
		String serdesc=Util.null2String(request.getParameter("serdesc"));//服务描述
		String regname=Util.null2String(request.getParameter("regname"));//服务注册名
		String poolid=Util.null2String(request.getParameter("poolid"));//所属DML数据源
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename =ServiceReginfo.getHetename(hpid)+SystemEnv.getHtmlLabelName(30649,user.getLanguage()); //服务注册清单
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(hpid))
		{
			sqlwhere+=" and a.hpid='"+hpid+"'";
		}
		
		if(!"".equals(opermode))
		{
			sqlwhere+=" and a.opermode='"+opermode+"'";
		}
		
		if(!"".equals(serdesc))
		{
			sqlwhere+=" and a.serdesc like '%"+serdesc+"%'";
		}
		
		if(!"".equals(regname))
		{
			sqlwhere+=" and a.regname like '%"+regname+"%'";
		}
		if(!"".equals(poolid))
		{
			sqlwhere+=" and a.poolid ='"+poolid+"'";
		}
		String backfields=" a.*,b.sourcename " ;
		String perpage="10";
		String fromSql=" dml_service  a left join dml_datasource b on a.poolid=b.id "; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				"<checkboxpopedom     popedompara=\"column:a.id\"    showmethod=\"com.weaver.integration.util.IntegratedMethod.getIsShowBox1\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"140\"  text=\""+ SystemEnv.getHtmlLabelName(30644,user.getLanguage()) +"\" column=\"regname\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getRegname\"  otherpara=\"column:id\" />"+
				"           <col width=\"140\"  text=\""+ SystemEnv.getHtmlLabelName(30660,user.getLanguage()) +"\" column=\"sourcename\"   />"+
				"           <col width=\"140\"  text=\""+ SystemEnv.getHtmlLabelName(30662,user.getLanguage()) +"\" column=\"opermode\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getOpermode\"  />"+
				"           <col width=\"140\"  text=\""+ SystemEnv.getHtmlLabelName(30625,user.getLanguage()) +"\" column=\"serdesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(611,user.getLanguage()) +",javascript:doAdd(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(197,user.getLanguage()) +",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(23777,user.getLanguage()) +",javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>

				<form action="/integration/serviceReg/serviceReg_1list.jsp" method="post" name="sapserlist" id="sapserlist">
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
								<TR class="Title"> 
								      <TH colSpan="4">&nbsp;<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></TH>
								    </TR>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30632,user.getLanguage())%></td>
								    <td class=field>
								    <%=SapUtil.getDatasourceSelect("2","poolid","",poolid,"selectmax_width","   ") %>
									</td>
								     <td width=10%>
								     	<%=SystemEnv.getHtmlLabelName(30672,user.getLanguage())%>
								     </td>
								    <td class=field>
								    	<input type="text" name="regname" value="<%=regname%>">
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>				
								</tbody>
								</table>
								
								
								<TABLE width="100%">
								    <tr>
								        <td valign="top">  
								           	<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
								        </td>
								    </tr>
								</TABLE>
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
	<script type="text/javascript">
		function doRefresh(obj)
		{
			$("#sapserlist").submit(); 
		}
		function doAdd()
		{
			window.location.href="/integration/serviceReg/serviceReg_1New.jsp?hpid=<%=hpid%>";
		}
		function doUpdate(id)
		{
			
			window.location.href="/integration/serviceReg/serviceReg_1New.jsp?isNew=1&id="+id;
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage())%>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"))
				{
				window.location.href="/integration/serviceReg/serviceReg_1Operation.jsp?opera=delete&ids="+requestids+"&hpid=<%=hpid%>";
				}
			}		
		}
	</script>
	</body>
</html>


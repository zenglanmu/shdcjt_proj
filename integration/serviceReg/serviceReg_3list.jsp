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
		<title>sap集成</title>
		<style type="text/css">
			.selectItemCss {
				width:200px;
				margin-right: 0px;
			}
		</style>
	</head>
	<%
		
		
		String hpid=Util.null2String(request.getParameter("hpid"));
		String regname=Util.null2String(request.getParameter("regname"));
		String poolid=Util.null2String(request.getParameter("poolid"));
		String funname=Util.null2String(request.getParameter("funname"));
		String fundesc=Util.null2String(request.getParameter("fundesc"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = ServiceReginfo.getHetename(hpid)+SystemEnv.getHtmlLabelName(30649,user.getLanguage()); //服务注册清单
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(hpid))
		{
			sqlwhere+=" and a.hpid='"+hpid+"'";
		}
		if(!"".equals(regname))
		{
			sqlwhere+=" and a.regname like '%"+regname+"%'";
		}
		if(!"".equals(poolid))
		{
			sqlwhere+=" and a.poolid ='"+poolid+"'";
		}
		
		if(!"".equals(funname))
		{
			sqlwhere+=" and a.funname like '%"+funname+"%'";
		}
		
		if(!"".equals(fundesc))
		{
			sqlwhere+=" and a.fundesc like '%"+fundesc+"%'";
		}
		String backfields=" a.*,b.poolname " ;
		String perpage="10";
		String fromSql=" sap_service  a left join sap_datasource b on a.poolid=b.id "; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				"<checkboxpopedom     popedompara=\"column:id\"  showmethod=\"com.weaver.integration.util.IntegratedMethod.getIsShowBox3\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"100\"  text=\"所属数据源\" column=\"poolname\"   />"+
                "           <col width=\"120\"  text=\"服务注册名称\" column=\"regname\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getRegname\"  otherpara=\"column:id\"  />"+
				"           <col width=\"120\"  text=\"SAP-ABAP函数名\" column=\"funname\"    />"+
				"           <col width=\"220\"  text=\"注册服务描述\" column=\"serdesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{服务注册,javascript:doAdd(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{搜索,javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{删除,javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>

				<form action="/integration/serviceReg/serviceReg_3list.jsp" method="post" name="sapserlist" id="sapserlist">
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
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
								<tbody>
								<TR class="Title"> 
								      <TH colSpan="4">&nbsp;查询条件</TH>
								    </TR>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								<tr>    
								    <td width=15%>SAP数据源</td>
								    <td class=field>
								    <%=SapUtil.getDatasourceSelect("1","poolid","",poolid,"selectItemCss","   ") %>
									</td>
								     <td width=15%>
								     	服务注册名称
								     </td>
								    <td class=field>
								    	<input type="text" name="regname" value="<%=regname%>" style="width:200px;">
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
			window.location.href="/integration/serviceReg/serviceReg_3New.jsp?hpid=<%=hpid%>";
		}
		function doUpdate(id)
		{
			window.location.href="/integration/serviceReg/serviceReg_3New.jsp?isNew=1&id="+id;
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("请选择删除的项!");
				return;
			}else
			{	
				if(window.confirm("确定要执行删除操作吗!"))
				{
				window.location.href="/integration/serviceReg/serviceReg_3Operation.jsp?opera=delete&ids="+requestids+"&hpid=<%=hpid%>";;
				}
			}		
		}
	</script>
	</body>
</html>


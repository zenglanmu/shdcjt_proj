<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>

<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%></title>
	</head>
	<%
		
		String dataname=Util.null2String(request.getParameter("dataname")).trim();
		String datadesc=Util.null2String(request.getParameter("datadesc")).trim();
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30703 ,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(dataname))
		{	
			sqlwhere+=" and dataname like '%"+dataname+"%'";
		}
		if(!"".equals(datadesc))
		{	
			sqlwhere+=" and datadesc like '%"+datadesc+"%'";
		}
		String backfields=" * " ;
		String perpage="10";
		String fromSql=" int_dataInter "; 
		tableString =   " <table instanceid=\"sendDocListTable\"  ";
		tableString+=" tabletype=\"none\" ";
		tableString+=" pagesize=\""+perpage+"\" >";
			    tableString+=
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30704 ,user.getLanguage())+"\" column=\"dataname\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getDataname\"  otherpara=\"column:id\" />"+
				"           <col width=\"80%\"  text=\""+SystemEnv.getHtmlLabelName(30705 ,user.getLanguage())+"\" column=\"datadesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		
			<%
			/**
			if(SapUtil.getIsOpendataInterAdd())
			{
				RCMenu += "{添加,javascript:doAdd(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{删除,javascript:doDelete(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			*/	
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>

				<form action="/integration/dataInterlist.jsp" method="post" name="sapserlist" id="sapserlist">
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
								      <TH colSpan="4">&nbsp;<%=SystemEnv.getHtmlLabelName(20331 ,user.getLanguage())%></TH>
								    </TR>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30704 ,user.getLanguage())%></td>
								    <td  class=field>
										<input  type="text" name="dataname" value="<%=dataname%>">
									</td>
								     <td width=10%>
								     	<%=SystemEnv.getHtmlLabelName(30706 ,user.getLanguage())%>
								     </td>
								    <td class=field>
								   		<input   type="text" name="datadesc" value="<%=datadesc%>">
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
			window.location.href="/integration/dataInterNew.jsp";
		}
		function doUpdate(id)
		{
			window.location.href="/integration/dataInterNew.jsp?isNew=1&id="+id;
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30678 ,user.getLanguage())%>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>"+"!"))
				{
				window.location.href="/integration/dataInterOperation.jsp?opera=delete&sid="+requestids;
				}
			}		
		}
	</script>
	</body>
</html>


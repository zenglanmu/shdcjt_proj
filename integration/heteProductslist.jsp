<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>

<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage()) %></title>
	</head>
	<%
		
		String hetename=Util.null2String(request.getParameter("hetename")).trim();
		String hetedesc=Util.null2String(request.getParameter("hetedesc")).trim();
		String flag=Util.null2String(request.getParameter("flag"));
		String sid=Util.null2String(request.getParameter("sid"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30698,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(hetename))
		{	
			sqlwhere+=" and hetename like '%"+hetename+"%'";
		}
		if(!"".equals(hetedesc))
		{	
			sqlwhere+=" and hetedesc like '%"+hetedesc+"%'";
		}
		if(!"".equals(sid))
		{	
			sqlwhere+=" and sid="+sid+"";
		}
		String backfields="* " ;
		String perpage="10";
		String fromSql="  ( select a.*,b.dataname  from int_heteProducts a left join int_dataInter b on a.sid=b.id) s"; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                " <checkboxpopedom    popedompara=\"column:id+column:sid\" showmethod=\"com.weaver.integration.util.IntegratedMethod.getHeteProductsShowBox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30693,user.getLanguage())+"\" column=\"hetename\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getHetename\"  otherpara=\"column:id\" />"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30694,user.getLanguage())+"\" column=\"dataname\"    />"+
				"           <col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(30696,user.getLanguage())+"\" column=\"hetedesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
				<form action="/integration/heteProductslist.jsp" method="post" name="hetelist" id="hetelist">
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
								      <TH colSpan="4">&nbsp;<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %></TH>
								    </TR>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=4 class=line1></TD>
								</TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30693,user.getLanguage()) %></td>
								    <td class=field>
										<input type="text" name="hetename" value="<%=hetename%>">
									</td>
								     <td width=10%>
								     	<%=SystemEnv.getHtmlLabelName(30694,user.getLanguage()) %>
								     </td>
								    <td class=field>
								   		<%=SapUtil.getDataInterSelect("sid","",sid,"selectmax_width","     ")%>
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
			$("#hetelist").submit(); 
		}
		function doAdd()
		{
			window.location.href="/integration/heteProductsNew.jsp";
		}
		function doUpdate(id)
		{
			window.location.href="/integration/heteProductsNew.jsp?isNew=1&id="+id;
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage()) %>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>"+"!"))
				{
				window.location.href="/integration/heteProductsOperation.jsp?opera=delete&ids="+requestids;
				}
			}		
		}
	</script>
	</body>
</html>


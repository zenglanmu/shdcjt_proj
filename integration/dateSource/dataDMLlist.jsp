<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<jsp:useBean id="ServiceReginfo" class="com.weaver.integration.util.ServiceRegTreeInfo" scope="page"/>
<html>
	<head>
		<title>sap集成</title>
	</head>
	<%
		
		String sourcename=Util.null2String(request.getParameter("sourcename")).trim();
		String hpid=Util.null2String(request.getParameter("hpid"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename =ServiceReginfo.getHetename(hpid)+ SystemEnv.getHtmlLabelName(81369,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(sourcename))
		{	
			sqlwhere+=" and sourcename like '%"+sourcename+"%'";
		}
		if(!"".equals(hpid))
		{	
			sqlwhere+=" and hpid ='"+hpid+"'";
		}
		String backfields=" * " ;
		String perpage="10";
		String fromSql=" dml_datasource "; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				"<checkboxpopedom     popedompara=\"column:id\"   showmethod=\"com.weaver.integration.util.IntegratedMethod.getSourcenameDMLShowBox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(23963,user.getLanguage())+"\" column=\"sourcename\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getSourcenameDML\"  otherpara=\"column:id\" />"+
				"           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(15025,user.getLanguage())+"\" column=\"DBtype\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getDBtype\"/>"+
				"           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(15026,user.getLanguage())+"\" column=\"dbname\"   />"+
				"           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(2072,user.getLanguage())+"\" column=\"username\"   />"+
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

				<form action="/integration/dateSource/dataDMLlist.jsp" method="post" name="sapserlist" id="sapserlist">
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
								    <td width=10%><%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></td>
								    <td class=field>
										<input type="text" name="sourcename" value="<%=sourcename%>">
									</td>
								     <td width=10% class=field>
								     
								     </td>
								    <td class=field>
								   		
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
			window.location.href="/integration/dateSource/dataDMLNew.jsp?hpid=<%=hpid%>";
		}
		function doUpdate(id)
		{
			window.location.href="/integration/dateSource/dataDMLNew.jsp?isNew=1&id="+id+"&hpid=<%=hpid%>";
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(26178,user.getLanguage())%>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
				{
				window.location.href="/integration/dateSource/dataDMLOperation.jsp?opera=delete&ids="+requestids+"&hpid=<%=hpid%>";
				}
			}		
		}
	</script>
	</body>
</html>


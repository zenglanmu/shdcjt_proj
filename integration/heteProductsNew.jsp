<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage()) %></title>
	</head>
	<%
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));//异构产品的id
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30691,user.getLanguage());
		String opera="save";
		String hetename="";
		String hetedesc="";
		String sid="";

		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(30692,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from int_heteProducts where id='"+id+"'");
			if(RecordSet.next())
			{
				hetename=RecordSet.getString("hetename");
				hetedesc=RecordSet.getString("hetedesc");
				sid=RecordSet.getString("sid");
			}
		}
		String needhelp ="";
		
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowHeteProducts(sid,id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
			<form action="/integration/heteProductsOperation.jsp" method="post" name="heteProducts" id="heteProducts">
			
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
			
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
								<col width="75%">
								<tbody>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=2 class=line1></TD>
								</TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30693,user.getLanguage())%></td>
								    <td class=field>
										<input type="text" name="hetename" id="hetename" onchange='checkinput("hetename","hetenamespan")' value="<%=hetename%>" class="selectmax_width"  maxlength="50">
										<span id=hetenamespan>
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle ><%}%>
										</span>
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30694,user.getLanguage())%></td>
								   
								    	
								    	<%
								    		if(SapUtil.IsShowHeteProducts(sid,id)){
								    	%>
								    			<td class=field  disabled>
								    					<%=SapUtil.getDataInterSelect("","hideimg(this,sidspan)",sid,"selectmax_width","     ")%>
								    			</td>
								    	<%
								    			out.println("<input type='hidden' name='sid' value='"+sid+"'>");
								    		}else
								    		{
								    	 %>
								    	 
								    	  <td class=field>
										    	<%=SapUtil.getDataInterSelect("sid","hideimg(this,sidspan)",sid,"selectmax_width","     ")%>
										    	<span id=sidspan>
										    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										    	</span>
								    		</td>
								    	<%
								    		}
								    	 %>
								    
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								<tr>    
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30696,user.getLanguage())%></td>
								    <td class=field>
								    	<textarea rows="5" cols="150" name="hetedesc"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"  style="height: 80px"><%=hetedesc%></textarea>
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
				
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>"+"!");
				return;
			}
			$("#heteProducts").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/heteProductslist.jsp";
		}
		function doDelete(obj,id)
		{
			
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"+"!"))
			{
				window.location.href="/integration/heteProductsOperation.jsp?opera=delete&ids="+id;
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


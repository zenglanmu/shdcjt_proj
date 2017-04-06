<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<html>
	<head>
		<title>sap集成</title>
	</head>
	<%
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String imagefilename = "/images/hdMaintenance.gif";
		String titlename = SystemEnv.getHtmlLabelName(30685,user.getLanguage());//"新建webservice数据源";
		String opera="save";
		String hpid=Util.null2String(request.getParameter("hpid"));
		String dataname="";    
		String poolname="";    
		String wsdladdress="";
		String pooldesc="";
		if("1".equals(isNew))
		{
			titlename =  SystemEnv.getHtmlLabelName(30687,user.getLanguage());//"修改webservice数据源";
			opera="update";
			//查出默认值
			RecordSet.execute("select * from ws_datasource where id='"+id+"'");
			if(RecordSet.next())
			{
				 hpid=RecordSet.getString("hpid");    
				 dataname=RecordSet.getString("dataname");    
				 poolname=RecordSet.getString("poolname");    
				 wsdladdress=RecordSet.getString("wsdladdress");    
				 pooldesc=RecordSet.getString("pooldesc");    
			}
		}
		String needhelp ="";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowDatasource("2",id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
			<form action="/integration/dateSource/dataWebserviceOperation.jsp" method="post" name="newweb" id="newweb"> 
			
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
								<table class="ViewForm"> 
								<colgroup> 
								<col width="25%"> 
								<col width="25%"> 
								<col width="25%"> 
								<col width="25%"> 
								</colgroup><tbody> 
								 
								<tr>     
								    <td width="10%"><%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></td> 
								    <td class="field" colspan="3">
										<input type="text" name="poolname" value="<%=poolname%>" onchange='checkinput("poolname","poolnamespan")'  maxlength="50">
										<span id="poolnamespan">
											<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
										</span> 
									</td> 
								</tr> 
								<tr style="height: 1px;"><td class="Line" colspan="4"></td></tr> 
								 
								<tr>     
								    <td width="10%"><%=SystemEnv.getHtmlLabelName(30636,user.getLanguage())%></td> 
								    <td class="field" colspan="3"  disabled>
										<%=SapUtil.getHeteProductsSelect("","2","",hpid,"selectmax_width","     ")%> 
									</td> 
									 
								</tr> 
								<tr style="height: 1px;"><td class="Line" colspan="4"></td></tr> 
								<tr>     
								    <td width="10%">WSDL<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td> 
								    <td class="field" colspan="3"> 
								    	<input type="text" name="wsdladdress" value="<%=wsdladdress%>" onchange='checkinput("wsdladdress","wsdladdressspan")' maxlength="50"> 
								    	<span id="wsdladdressspan">
								    		<%if(!"1".equals(isNew)){%><img src="/images/BacoError.gif" align=absMiddle><%}%>
								    	</span> 
								    </td> 
								</tr> 
								<tr style="height: 1px;"><td class="Line" colspan="4"></td></tr>  
								<tr> 
								     <td width="10%"><%=SystemEnv.getHtmlLabelName(30650,user.getLanguage())%></td> 
								    <td class="field" colspan="3"> 
								    	<textarea rows="3" cols="80" name="pooldesc" onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=pooldesc%></textarea> 
								    </td> 
								</tr> 
								<tr style="height: 1px;"><td class="Line" colspan="4"></td></tr>  
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
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			$("#newweb").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/dateSource/dataWebservicelist.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
			{
				window.location.href="/integration/dateSource/dataWebserviceOperation.jsp?opera=delete&ids="+id+"&hpid=<%=hpid%>";
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


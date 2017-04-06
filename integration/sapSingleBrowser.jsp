<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="com.weaver.integration.entity.NewSapBrowserComInfo"%>
<%@page import="com.weaver.integration.entity.NewSapBrowser"%>
<%@page import="com.weaver.integration.entity.NewSapBaseBrowser"%>
<%@page import="com.weaver.integration.entity.Sap_outParameterBean"%>
<%@page import="com.weaver.integration.entity.Sap_outTableBean"%>
<%@page import="com.weaver.integration.entity.Sap_inParameterBean"%>
<%@page import="com.weaver.integration.entity.Sap_inStructureBean"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.List" %>
<%@ page import="weaver.parseBrowser.*" %>
<%@ page import="weaver.interfaces.sap.SAPConn" %>
<%@ page import="com.sap.mw.jco.JCO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<html>
	<body>
	
			<% 
				//如果是新建流程，只能从页面取数据
				String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
				boolean ismainfield = true;//是主字段
				String detailrow = "";//如果是明字段，代表行号
				String fromfieldid = "";//字段id
				String strs[] = frombrowserid.split("_");
				if(strs.length==2){
					fromfieldid = strs[0];
					detailrow = strs[1];
					ismainfield = false;
				}else{
					fromfieldid = strs[0];
				}
				String type=Util.null2String(request.getParameter("sapbrowserid"));//集成流程按钮标识 
				NewSapBrowserComInfo NewSapBrowserComInfo=new NewSapBrowserComInfo();
				NewSapBaseBrowser nb=NewSapBrowserComInfo.getSapBaseBrowser(type);
				List inParameter=nb.getSap_inParameter();//获取输入参数
				List listoafieldin=new ArrayList();//封装oa输入参数字段(有固定值的)
				List listoafieldno=new ArrayList();//封装oa输入参数字段(所有的)
				List intstrufield=nb.getSap_inStructure(); //获取输入结构
				//System.out.println("浏览按钮标识"+type);
				//System.out.println("输入参数的长度"+inParameter.size());
				//System.out.println("输入结构的长度"+intstrufield.size());
				
				IntegratedSapUtil insaputil=new IntegratedSapUtil();
				out.println(" <form action='/integration/sapSingleBrowserDetial.jsp' method='post' name='weaverfield' id='weaverfield'>");
				if(inParameter.size()>0)//说明有输入参数
				{
					for(int i=0;i<inParameter.size();i++)//循环参数
					{
						Sap_inParameterBean sap_inParameterBean=(Sap_inParameterBean)inParameter.get(i);
						String Constant=sap_inParameterBean.getConstant();//输入参数的固定值
						String Oafield=sap_inParameterBean.getOafield();//输入参数来源于OA字段的值
						String sapfield=sap_inParameterBean.getSapfield();//输入参数的sap字段
						String oafieldid=sap_inParameterBean.getFromfieldid();//OA字段的id
						String ismainfieldmy=sap_inParameterBean.getIsmainfield();//是否主表字段
						if("".equals(Constant)&&!"".equals(oafieldid))//如果没有固定值，那么这个值就来源于流程表单界面的字段,并且这个oa字段存在
						{
							if("1".equals(ismainfieldmy))//主表
							{
								listoafieldin.add("field"+oafieldid);
							}else//明细表字段
							{
								listoafieldin.add("field"+oafieldid+"_"+detailrow);
							}
						}
						if(!"".equals(oafieldid))
						{
							if("1".equals(ismainfieldmy))//主表
							{
								listoafieldno.add("field"+oafieldid+"@<>@"+Constant);
							}else//明细表字段
							{
								listoafieldno.add("field"+oafieldid+"_"+detailrow+"@<>@"+Constant);
							}
						}
					}
				}
				
				if(intstrufield.size()>0)//说明有输入结构
				{
					
					for(int i=0;i<intstrufield.size();i++)//循环参数
					{
						Sap_inStructureBean sap_inStructureBean=(Sap_inStructureBean)intstrufield.get(i);
						String Constant=sap_inStructureBean.getConstant();//输入参数的固定值
						//System.out.println("这个固定值"+Constant);
						String Oafield=sap_inStructureBean.getOafield();//输入参数来源于OA字段的值
						String sapfield=sap_inStructureBean.getSapfield();//输入参数的sap字段
						String oafieldid=sap_inStructureBean.getFromfieldid();//OA字段的id
						String ismainfieldmy=sap_inStructureBean.getIsmainfield();//是否主表字段
						if("".equals(Constant)&&!"".equals(oafieldid))//如果没有固定值，那么这个值就来源于流程表单界面的字段,并且这个oa字段存在
						{
							if("1".equals(ismainfieldmy))//主表
							{
								listoafieldin.add("field"+oafieldid);
							}else//明细表字段
							{
								listoafieldin.add("field"+oafieldid+"_"+detailrow);
							}
						}
						
						if(!"".equals(oafieldid))
						{
							if("1".equals(ismainfieldmy))//主表
							{
								
								listoafieldno.add("field"+oafieldid+"@<>@"+Constant);
							}else//明细表字段
							{
								listoafieldno.add("field"+oafieldid+"_"+detailrow+"@<>@"+Constant);
							}
						}
					}
				}
				listoafieldno=insaputil.removeDuplicateWithOrder(listoafieldno);//去掉重复的字段
				for(int i=0;i<listoafieldno.size();i++)
				{
					String templist[]=(listoafieldno.get(i)+"").split("@<>@");
					if(templist.length>1)
					{
						out.println("<input type='hidden' name='"+templist[0]+"' id='"+templist[0]+"' value='"+templist[1]+"'>");					
					}else
					{
						out.println("<input type='hidden' name='"+templist[0]+"' id='"+templist[0]+"' value=''>");
					}
				}
				out.println("<input type='hidden' name='type' id='type' value='"+type+"'>");
				out.println("<input type='hidden' name='detailrow' id='detailrow' value='"+detailrow+"'>");
				out.println("<input type='hidden' name='fromfieldid' id='fromfieldid' value='"+fromfieldid+"'>");
				out.println(" </form>");
			 %>
	</body>
</html>
<script type="text/javascript">
<!--
	$(document).ready(function() {  
		<%
			for(int j=0;j<listoafieldin.size();j++)
			{
		%>
		
			 try{
			 	if($.browser.msie) { 
						//得到输入参数要的字段值
						var obj = window.dialogArguments.document.getElementById("<%=listoafieldin.get(j)%>");
						if(obj.tagName=="SELECT"){
								//下拉框
								document.getElementById("<%=listoafieldin.get(j)%>").value=obj[obj.selectedIndex].text;
								//alert(obj[obj.selectedIndex].text);
						}else{
								document.getElementById("<%=listoafieldin.get(j)%>").value=obj.value;
						}
					}else{
					
						var obj = window.parent.dialogArguments.document.getElementById("<%=listoafieldin.get(j)%>");
						if(obj.tagName=="SELECT"){
								//下拉框
								document.getElementById("<%=listoafieldin.get(j)%>").value=obj[obj.selectedIndex].text;
								//alert(obj[obj.selectedIndex].text);
						}else{
								document.getElementById("<%=listoafieldin.get(j)%>").value=obj.value;
						}
					}
				}catch(e){
				}
		<%	
			}
		
		%>
		document.getElementById("weaverfield").submit();
	});
//-->
</script>

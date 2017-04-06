<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionImportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionExportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionBaseParamBean"%> 
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML>
	<base target="_self">
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
		String formid=Util.getIntValue(request.getParameter("formid"),0)+"";
		String checkvalue=Util.null2String(request.getParameter("checkvalue"));//选中的一项值
		String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
		String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
		int isbill= Util.getIntValue(request.getParameter("isbill"),0);//0表示老表单,1表示新表单
		String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
		//接收回写表
		String backtable=Util.null2String(request.getParameter("backtable"));
		
		String se_fieldname=Util.null2String(request.getParameter("se_fieldname")).toUpperCase().trim();
		String  se_fielddesc=Util.null2String(request.getParameter("se_fielddesc")).toUpperCase().trim();
		//String formid="-139";
		//String updateTableName="formtable_main_139";
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311 ,user.getLanguage())+",javascript:onClean(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{搜索,javascript:window.parent.onseach(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<form action="/integration/browse/integrationBatchOA.jsp" method="post"  id="SearchForm">



		

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>

<tr>
	<td ></td>
	<td valign="top">
	
			<TABLE class=Shadow>
					<tr>
					<td valign="top" width="100%">
					<table width=100% class="viewform">
					<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
					<tr>
					<TD ><%=SystemEnv.getHtmlLabelName(685 ,user.getLanguage()) %></TD>
					<TD  class=field>
							<input type='text' name='se_fieldname' value='<%=se_fieldname%>'>
					</TD>
					<TD ><%=SystemEnv.getHtmlLabelName(15456 ,user.getLanguage()) %></TD>
					<TD  class=field>
							<input type='text' name='se_fielddesc' value='<%=se_fielddesc%>'>
					</TD>
					</TR>
					<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
					</table>

		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">
			<input type='hidden'   name="formid"  value='<%=formid%>'>
			<input type="hidden"   name="updateTableName"  value="<%=updateTableName%>">
			<input type="hidden"   name="w_type"  value="<%=w_type%>">
			<input type="hidden"   name="isbill"  value="<%=isbill%>">
			<input type="hidden"   name="srcType"  value="<%=srcType%>">
			<input type="hidden"   name="backtable"  value="<%=backtable%>">
			<input type="hidden"   name="checkvalue"  value="<%=checkvalue%>">
		
<%

			out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			out.println("<TR class=DataHeader>");
			out.println("<TH style='display:none' ></TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(685 ,user.getLanguage())+"</TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(15456 ,user.getLanguage())+"</TH>");
			out.println("<TH width=25% >"+SystemEnv.getHtmlLabelName(17997 ,user.getLanguage())+"</TH>");
			out.println("</tr>");
		
			out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
			String sql="";
			if("0".equals(w_type))
			{
					if("0".equals(formid)&&0==isbill){
						
								//这种情况来源于字段管理--新建字段
								 FieldMainManager.resetParameter() ;
						        FieldMainManager.setUserid(user.getUID());
						        int jk=0;
						        if("mainfield".equals(srcType)){
						       				 FieldMainManager.selectAllCodViewField();
						       			 	while(FieldMainManager.next()){
						       			 			String  zh_Fieldname=FieldMainManager.getFieldManager().getFieldname().toUpperCase().trim();
													String  zh_Fielddesc=FieldMainManager.getFieldManager().getDescription().toUpperCase().trim();
													
													if(zh_Fieldname.indexOf(se_fieldname)==-1){
														continue;
													}
													if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
														continue;
													}
													if(jk%2==0)
													{
														out.println("<tr class=DataDark>");
													}else
													{
														out.println("<tr class=DataLight>");
													}
												
												out.println("<td style='display:none'>1_"+FieldMainManager.getFieldManager().getFieldid()+"</td>");//主表是1
												out.println("<td>"+zh_Fieldname+"</td>");
												out.println("<td>"+zh_Fielddesc+"</td>");
												out.println("<td>主字段</td>");	
												out.println("</tr>");
												jk++;
											}
						        }else{   
						        		 FieldMainManager.selectAllCodViewDetailField();
						        		 while(FieldMainManager.next()){
						        		 			String  zh_Fieldname=FieldMainManager.getFieldManager().getFieldname().toUpperCase().trim();
													String  zh_Fielddesc=FieldMainManager.getFieldManager().getDescription().toUpperCase().trim();
													if(zh_Fieldname.indexOf(se_fieldname)==-1){
														continue;
													}
													if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
														continue;
													}
													if(jk%2==0)
													{
														out.println("<tr class=DataDark>");
													}else
													{
														out.println("<tr class=DataLight>");
													}
												
												out.println("<td style='display:none'>0_"+FieldMainManager.getFieldManager().getFieldid()+"</td>");//明细是0
												out.println("<td>"+zh_Fieldname+"</td>");
												out.println("<td>"+zh_Fielddesc+"</td>");
												out.println("<td>明细字段</td>");	
												out.println("</tr>");
												jk++;
											}
						        }	
						        FieldMainManager.selectAllCodViewDetailField() ;
						        
							
					}else{
						
							 if(updateTableName.indexOf("_dt")>=0||updateTableName.indexOf("$_$")>=0)//明细表
							{
								//明细表的参数来源只能是当前明细表
								sql="select * from workflow_billfield where billid='"+formid+"' and detailtable='"+updateTableName+"' order by viewtype";
							}
							else //主表
							{
								//主表的参数来源，只能是主表
								sql="select * from workflow_billfield where billid='"+formid+"' and (detailtable is null or detailtable='')  order by viewtype";
							}
							RecordSet.execute(sql);
							int jk=0;
							while(RecordSet.next())
							{
								int fieldid_t = Util.getIntValue(RecordSet.getString("id"), 0);
								String  zh_Fieldname=RecordSet.getString("fieldname").toUpperCase().trim();
								String  zh_Fielddesc=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("fieldlabel")),user.getLanguage()).toUpperCase().trim();
								if(zh_Fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
									if("1".equals(RecordSet.getString("viewtype")))
									{
										out.println("<td style='display:none'>0_"+fieldid_t+"</td>");//明细表是0
										out.println("<td>"+zh_Fieldname+"</td>");
										out.println("<td>"+zh_Fielddesc+"</td>");
										//out.println("<td>"+updateTableName+"表字段(明细表)</td>");
										out.println("<td>"+SystemEnv.getHtmlLabelName(19325 ,user.getLanguage())+"</td>");
									}else
									{
										out.println("<td style='display:none'>1_"+fieldid_t+"</td>");//主表是1
										out.println("<td>"+zh_Fieldname+"</td>");
										out.println("<td>"+zh_Fielddesc+"</td>");
										//out.println("<td>"+updateTableName+"表字段(主表)</td>");
										out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"</td>");
									}
								out.println("</tr>");
								jk++;
							}
					}
			}else//表示是节点后动作
			{
					if("".equals(backtable))
					{
						List  sysname=new ArrayList();
						List  sysdesc=new ArrayList();
	
						sysname.add("REQUESTNAME");
						sysdesc.add(SystemEnv.getHtmlLabelName(26876, user.getLanguage()));
						sysname.add("REQUESTID");
						sysdesc.add(SystemEnv.getHtmlLabelName(18376, user.getLanguage()));
						sysname.add("CREATER");
						sysdesc.add(SystemEnv.getHtmlLabelName(882, user.getLanguage()));
						sysname.add("CREATEDATE");
						sysdesc.add(SystemEnv.getHtmlLabelName(772, user.getLanguage()));
						sysname.add("CREATETIME");
						sysdesc.add(SystemEnv.getHtmlLabelName(1339, user.getLanguage()));
						sysname.add("WORKFLOWNAME");
						sysdesc.add(SystemEnv.getHtmlLabelName(16579, user.getLanguage()));
						sysname.add("CURRENTUSE");
						sysdesc.add(SystemEnv.getHtmlLabelName(20558, user.getLanguage()));
						sysname.add("CURRENTNODE");
						sysdesc.add(SystemEnv.getHtmlLabelName(18564, user.getLanguage()));
					//	sysname.add("REQUESTMARK");
						//sysdesc.add(SystemEnv.getHtmlLabelName(19502, user.getLanguage()));
						int jk_s=0;
						for(int i=0;i<sysname.size();i++){
						
								String  zh_Fieldname=(sysname.get(i)+"").toUpperCase().trim();
								String  zh_Fielddesc=sysdesc.get(i)+"".toUpperCase().trim();
								
								if(zh_Fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk_s%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>1_"+((i+1)*-1)+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+zh_Fieldname+"</td>");
								out.println("<td>"+zh_Fielddesc+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
								out.println("</tr>");
								jk_s++;
						}
						/* out.println("<tr class=DataDark>");
									out.println("<td style='display:none'>1_-1</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>requestname</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(26876, user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						out.println("<tr class=DataLight>");
									out.println("<td style='display:none'>1_-2</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>requestid</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(18376, user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						out.println("<tr class=DataDark>");
									out.println("<td style='display:none'>1_-3</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>creater</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(882, user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						out.println("<tr class=DataLight>");
									out.println("<td style='display:none'>1_-4</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>createdate</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(772,user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						out.println("<tr class=DataDark>");
									out.println("<td style='display:none'>1_-5</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>createtime</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						
						
						out.println("<tr class=DataLight>");
									out.println("<td style='display:none'>1_-6</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>workflowname</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						
						
						out.println("<tr class=DataDark>");
									out.println("<td style='display:none'>1_-7</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>currentuse</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(20558,user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>");
						
						
						out.println("<tr class=DataLight>");
								out.println("<td style='display:none'>1_-8</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>currentnode</td>"); 
								out.println("<td>"+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(28415 ,user.getLanguage())+")</td>");
						out.println("</tr>"); */
						
						//主表字段循环
						
						if(isbill == 0){
							sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdict fd left join workflow_formfield ff on ff.fieldid=fd.id left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
						}else{
							sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where (viewtype=0 or viewtype is null) and billid="+formid+" order by bf.dsporder";
						}
						RecordSet.execute(sql);
						int jk=0;
						while(RecordSet.next())
						{
								int fieldid_t = Util.getIntValue(RecordSet.getString("id"), 0);
								String fieldname=Util.null2String(RecordSet.getString("fieldname")).toUpperCase().trim();
								String fieldlabel_t = Util.null2String(RecordSet.getString("fieldlabel")).toUpperCase().trim();
								if(fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(fieldlabel_t.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>1_"+fieldid_t+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+fieldname+"</td>");
								out.println("<td>"+fieldlabel_t+"</td>");
								out.println("<td>"+SystemEnv.getHtmlLabelName(21778 ,user.getLanguage())+"</td>");
							out.println("</tr>");
							jk++;
						}
						
						//明细表循环
						/* if(isbill == 0){
							sql = "select distinct groupid from workflow_formfield where formid="+formid+" and isdetail='1' order by groupid";
						}else{
							sql = "select tablename as groupid, title from Workflow_billdetailtable where billid="+formid+" order by orderid";
						}
						RecordSet.execute(sql);
						int groupCount = 0;
						while(RecordSet.next()){//明细表循环开始
							groupCount++;
							String groupid_tmp = "";
							if(isbill == 0){
								groupid_tmp = ""+Util.getIntValue(RecordSet.getString("groupid"), 0);
							}else{
								groupid_tmp = Util.null2String(RecordSet.getString("groupid"));
							}
							
							if(isbill == 0){
								sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
							}else{
								sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where bf.detailtable='"+groupid_tmp+"' and bf.viewtype=1 and bf.billid="+formid+" order by bf.dsporder";
							}
							//明细表字段循环
							RecordSet rs=new RecordSet();
							rs.execute(sql);
							while(rs.next()){
								int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
								String fieldname=Util.null2String(rs.getString("fieldname")).toUpperCase().trim();
								String fieldlabel_t = Util.null2String(rs.getString("fieldlabel")).toUpperCase().trim();
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>0_"+fieldid_t+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+fieldname+"</td>");
								out.println("<td>"+fieldlabel_t+"</td>");
									out.println("<td>"+SystemEnv.getHtmlLabelName(19325, user.getLanguage())+groupCount+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td>");
								out.println("</tr>");
								jk++;
							}
																
						}
				 */	}else
					{
						//明细表循环
						if(isbill == 0){
							sql = "select distinct groupid from workflow_formfield where formid="+formid+" and isdetail='1' order by groupid";
						}else{
							sql = "select tablename as groupid, title from Workflow_billdetailtable where billid="+formid+" order by orderid";
						}
						RecordSet.execute(sql);
						int groupCount = 0;
						while(RecordSet.next()){//明细表循环开始
							groupCount++;
							String groupid_tmp = "";
							if(isbill == 0){
								groupid_tmp = ""+Util.getIntValue(RecordSet.getString("groupid"), 0);
							}else{
								groupid_tmp = Util.null2String(RecordSet.getString("groupid"));
							}
							//System.out.println("groupid_tmp"+groupid_tmp);
							//System.out.println("backtable"+backtable);
							if(!groupid_tmp.equals(backtable.replace("mx_","")))
							{
								continue;
							}
							if(isbill == 0){
								sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
							}else{
								sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where bf.detailtable='"+groupid_tmp+"' and bf.viewtype=1 and bf.billid="+formid+" order by bf.dsporder";
							}
							//明细表字段循环
							RecordSet rs=new RecordSet();
							rs.execute(sql);
							int jk=0;
							while(rs.next()){
								int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
								String fieldname=Util.null2String(rs.getString("fieldname")).toUpperCase().trim();
								String fieldlabel_t = Util.null2String(rs.getString("fieldlabel")).toUpperCase().trim();
								if(fieldname.indexOf(se_fieldname)==-1){
									continue;
								}
								if(fieldlabel_t.indexOf(se_fielddesc)==-1){
									continue;
								}
								if(jk%2==0)
								{
									out.println("<tr class=DataDark>");
								}else
								{
									out.println("<tr class=DataLight>");
								}
								out.println("<td style='display:none'>0_"+fieldid_t+"</td>");//(1表示主表，0表示明细表)+字段的id+是否新表单字段
								out.println("<td>"+fieldname+"</td>");
								out.println("<td>"+fieldlabel_t+"</td>");
									out.println("<td>"+SystemEnv.getHtmlLabelName(19325, user.getLanguage())+groupCount+SystemEnv.getHtmlLabelName(261, user.getLanguage())+"</td>");
								out.println("</tr>");
								jk++;
							}
																
						}
					}
			}
	 	out.println("</TABLE>");
%>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
</form>
</BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var viewtypes = "";
var names = "";

//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
							viewtypes = ","+jQuery(this).find("td:eq(0)").text()
					   		names =","+jQuery(this).find("td:eq(1)").text()
					   		submitData();
		}
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});
function btnok_onclick() {
	window.parent.returnValue = {viewtype: viewtypes, name: names};//Array(documentids,documentnames)
    window.parent.close();
}
function onSubmit() {
		$G("SearchForm").submit()
}
function onReset() {
		$G("SearchForm").reset()
}
function submitData()
{
	btnok_onclick();
}
function onClean()
{
  	window.parent.returnValue = {viewtype: "-1",name: ""};
    window.parent.close();
}

function onseach(){
	$("#SearchForm").submit()
}
</script>
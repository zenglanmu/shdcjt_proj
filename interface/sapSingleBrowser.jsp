<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.parseBrowser.*" %>
<%@ page import="weaver.interfaces.sap.SAPConn" %>
<%@ page import="com.sap.mw.jco.JCO" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />

<HTML><HEAD>
<style>
	#loading{
	    position:absolute;
	    //left:37%;
	    //top:40%;
	    background:#ffffff;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    border:1px solid #ccc;
	}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String formid = Util.getIntValue(request.getParameter("formid"),-1)+"";
String isbill = Util.getIntValue(request.getParameter("isbill"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
String issearch = Util.null2String(request.getParameter("issearch"));
String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));//浏览框id
String frombrowserid = Util.null2String(request.getParameter("frombrowserid"));//触发字段id
int curpage = Util.getIntValue(request.getParameter("curpage"),1);//当前页

//System.out.println("workflowid=" + workflowid);
//System.out.println("sapbrowserid=" + sapbrowserid);
//System.out.println("userid=" + user.getUID());

//检查SAP浏览按钮是否有数据授权设置
List containFilterList = new ArrayList();
List noContainFilterList = new ArrayList();
String checksql = "select * from SAPData_Auth_setting where (browserids='"+sapbrowserid+"' or browserids like '"+sapbrowserid+",%' or browserids like '%,"+sapbrowserid+",%' or browserids like '%,"+sapbrowserid+"') and (wfids='"+workflowid+"' or wfids like '"+workflowid+",%' or wfids like '%,"+workflowid+",%' or wfids like '%,"+workflowid+"') ";
rs2.execute(checksql);
while(rs2.next()){
	boolean hasAuthSetting = false;
	
	int settingid = rs2.getInt("id");
	String resourcetype = Util.null2String(rs2.getString("resourcetype"));
	String resourceids = Util.null2String(rs2.getString("resourceids"));
	String roleids = Util.null2String(rs2.getString("roleids"));
	
	if(resourcetype.equals("0")){
		if(("," + resourceids + ",").indexOf(","+user.getUID()+",") >= 0){
			hasAuthSetting = true;
		}
	}else if(resourcetype.equals("1")){
		rs3.execute("select * from HrmRoleMembers where resourceid="+user.getUID());
		while(rs3.next()){
			String tmproleid = rs3.getString("roleid");
			if(("," + roleids + ",").indexOf(","+tmproleid+",") >= 0){
				hasAuthSetting = true;
				break;
			}
		}
	}
	if(hasAuthSetting){
		rs3.execute("select * from SAPData_Auth_setting_detail where settingid='"+settingid+"' and browserid='"+sapbrowserid+"'");
		while(rs3.next()){
			String filtertype = Util.null2String(rs3.getString("filtertype"));
			String sapcode = Util.null2String(rs3.getString("sapcode"));
			if(filtertype.equals("0")){
				containFilterList.add(sapcode);
			}else if(filtertype.equals("1")){
				noContainFilterList.add(sapcode);
			}
		}
	}
}

//System.out.println("containFilterList=" + containFilterList);
//System.out.println("noContainFilterList=" + noContainFilterList);

boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromfieldid = "";//字段id
String strs[] = frombrowserid.split("_");
if(strs.length==2){
	fromfieldid = strs[0];
	detailrow = strs[1];
	ismainfiled = false;
}else{
	fromfieldid = strs[0];
}

String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap AllField = (HashMap)session.getAttribute("AllField_"+workflowid+"_"+currenttime);
ArrayList AllFieldList = (ArrayList)session.getAttribute("AllFieldList_"+workflowid+"_"+currenttime);
if(AllField==null){
	AllField = new HashMap();
}
if(AllFieldList==null){
	AllFieldList = new ArrayList();
}
StringBuffer hiddenValue = new StringBuffer();
String fieldids[] = needChangeFieldString.split(",");
HashMap valueMap = new HashMap();
for(int i=0;i<fieldids.length;i++){
	String fieldid = Util.null2String(fieldids[i]);
	if(!fieldid.equals("")){
		String fieldvalue = Util.null2String(request.getParameter(fieldid));
		hiddenValue.append("<input type=\"hidden\" id=\""+fieldid+"\" name=\""+fieldid+"\" value=\""+fieldvalue+"\">");
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
		//System.out.println("fieldid:	"+fieldid+"	"+fieldvalue);
		valueMap.put(fieldid,fieldvalue);
	}
}
//System.out.println(hiddenValue.toString());

SapBaseBrowser SapBaseBrowser = (SapBaseBrowser)SapBrowserComInfo.getSapBaseBrowser(sapbrowserid);
String function = SapBaseBrowser.getFunction();//函数名
//System.out.println("function:"+function);

String authWorkflowID = Util.null2String(SapBaseBrowser.getAuthWorkflowID());

boolean authFlag = Util.null2String(SapBaseBrowser.getAuthFlag()).equalsIgnoreCase("Y") && (","+authWorkflowID+",").indexOf(","+workflowid+",") >= 0;
System.out.println("workflowid="+workflowid);
String sources = "";
if(!workflowid.equals("")){
	rs.executeSql("select SAPSource from workflow_base where id="+workflowid);
	if(rs.next())
		sources = rs.getString(1);
}
//执行函数
//System.out.println("sources="+sources);
SAPConn SAPConn = new SAPConn(sources);
JCO.Table Table = null;
JCO.Client sapconnection = SAPConn.getConnection();
JCO.Function bapi = SAPConn.excuteBapi(function,sapconnection); //
ArrayList import_input = SapBaseBrowser.getImport_input();
for(int i=0;i<import_input.size();i++){
	Field Field = (Field)import_input.get(i);
	String fname = Field.getName().toUpperCase();
	String fieldname = Field.getFromOaField().toUpperCase();
	String fieldid = Util.null2String((String)AllField.get(fieldname));
	String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
	
	//如果设置了固定值，固定值优先
	String constant = Util.null2String(Field.getConstant());
	if(!constant.equals("")){
		fieldvalue = constant;
	}
	//System.out.println("id:	"+fname+"	"+fieldname + "	" +fieldvalue);
	bapi.getImportParameterList().setValue(fieldvalue,fname);
	//System.out.println("fname====:		"+fname+"	"+fieldvalue);
}
ArrayList struct_input = SapBaseBrowser.getStruct_input();
for(int i=0;i<struct_input.size();i++){
	StructField StructField = (StructField)struct_input.get(i);//结构体对象
	ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
	String StructName = StructField.getStructName();//结构体名称
	if(!StructName.equals("")&&structFieldList.size()>0){
		JCO.Structure Structure = bapi.getImportParameterList().getStructure(StructName);
		for(int j=0;j<structFieldList.size();j++){
			Field Field = (Field)structFieldList.get(j);
			String fname = Field.getName().toUpperCase();
			String fieldname = Field.getFromOaField().toUpperCase();
			String fieldid = Util.null2String((String)AllField.get(fieldname));
			String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
			
			//如果设置了固定值，固定值优先
			String constant = Util.null2String(Field.getConstant());
			if(!constant.equals("")){
				fieldvalue = constant;
			}
			
			Structure.setValue(fieldvalue,fname);
		}
	}
}

sapconnection.execute(bapi);
SAPConn.releaseC(sapconnection);//释放连接

//获得返回结果 export
HashMap export_output_value_map = new HashMap();
ArrayList export_output = SapBaseBrowser.getExport_output();
for(int i=0;i<export_output.size();i++){
	Field Field = (Field)export_output.get(i);
	String fname = Field.getName().toUpperCase();
	String desc = Field.getDesc();
	String display = Field.getDisplay();
	String outvalue = Util.null2String(bapi.getExportParameterList().getString(fname));
	export_output_value_map.put("EXPORT_"+fname,outvalue);
	//System.out.println(fname+"	"+desc + "	" +display+"	"+outvalue);
}

ArrayList struct_output = SapBaseBrowser.getStruct_output();
for(int i=0;i<struct_output.size();i++){
	StructField StructField = (StructField)struct_output.get(i);//结构体对象
	ArrayList structFieldList = StructField.getStructFieldList();//结构体字段
	String StructName = StructField.getStructName();//结构体名称
	if(!StructName.equals("")&&structFieldList.size()>0){
		JCO.Structure Structure = bapi.getExportParameterList().getStructure(StructName);
		for(int j=0;j<structFieldList.size();j++){
			Field Field = (Field)structFieldList.get(j);
			String fname = Field.getName().toUpperCase();
			String desc = Field.getDesc();
			String display = Field.getDisplay();
			String outvalue = Util.null2String(Structure.getString(fname));
			export_output_value_map.put(StructName+"_"+fname,outvalue);
		}
	}
}

//获得返回结果 table
ArrayList searchList = new ArrayList();//获得查询字段
ArrayList table_output = SapBaseBrowser.getTable_output();
for(int i=0;i<table_output.size();i++){
	ArrayList table_output_value_list = new ArrayList();
	TableField TableField = (TableField)table_output.get(i);
	ArrayList tableFieldList = TableField.getTableFieldList();
	for(int k=0;k<tableFieldList.size();k++){
		Field Field = (Field)tableFieldList.get(k);
		String fname = Field.getName().toUpperCase();
		String desc = Field.getDesc();
		String display = Field.getDisplay();
		String search = Field.getSearch();
		String searchvalue = Util.null2String(request.getParameter(fname));
		Field.setSearchvalue(searchvalue);
		if(search.equals("Y")){
			searchList.add(Field);
		}
		//System.out.println(fname+"	"+desc + "	" +display+"	"+search);
	}
}

int sumcount = 0;//浏览按钮数据的总行数
HashMap Alltable_output_value_map = new HashMap();
for(int i=0;i<table_output.size();i++){
	ArrayList table_output_value_list = new ArrayList();
	TableField TableField = (TableField)table_output.get(i);
	
	String identityField = Util.null2String(TableField.getIdentityField()).toUpperCase();
	
	String output_tablename = TableField.getTableName(); 
	ArrayList tableFieldList = TableField.getTableFieldList();
	Table = bapi.getTableParameterList().getTable(output_tablename);
	for(int j=0;j<Table.getNumRows();j++){
		Table.setRow(j);
		HashMap table_output_value_map = new HashMap();
		boolean isLegal = true;
		for(int k=0;k<tableFieldList.size();k++){
			Field Field = (Field)tableFieldList.get(k);
			String fname = Field.getName().toUpperCase();
			String desc = Field.getDesc();
			String display = Field.getDisplay();
			String search = Field.getSearch();
			String outvalue = Util.null2String(Table.getString(fname));
			if(search.equals("Y")){
				String searchvalue = Util.null2String(request.getParameter(fname));
				if(!searchvalue.equals("")){
					if(outvalue.indexOf(searchvalue)<0){
						isLegal = false;
						break;
					}
				}
			}
			//System.out.println(output_tablename+"	"+fname+"	"+desc + "	" +display+"	"+outvalue);
			table_output_value_map.put(output_tablename+"_"+fname,outvalue);
			
		}
		if(authFlag){
			if(!identityField.equals("")){
				String identityFieldValue = ""; 
				String identityFields[] = identityField.split(",");
				for(int ti=0;ti<identityFields.length;ti++){
					String _identityField = Util.null2String(identityFields[ti]);
					if(!_identityField.equals("")){
						identityFieldValue += (identityFieldValue.equals("")?"":"$_$") + Util.null2String((String)table_output_value_map.get(output_tablename+"_" + _identityField));
					}
				}
				//String identityFieldValue = Util.null2String((String)table_output_value_map.get(output_tablename+"_" + identityField));
				
				if(!(containFilterList.contains(identityFieldValue) && noContainFilterList.contains(identityFieldValue))){
					if( !containFilterList.contains(identityFieldValue)){
						continue;
					}
					if( noContainFilterList.contains(identityFieldValue)){
						continue;
					}
				}
			}
		}
		
		if(isLegal){
			sumcount++;
			table_output_value_list.add(table_output_value_map);
		}
	}
	Alltable_output_value_map.put(output_tablename,table_output_value_list);
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(searchList.size()>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<div id="loading">
	<span><img src="/images/loading2.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></span>
</div>

<div id="content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="sapSingleBrowser.jsp" method=post>

<input type="hidden" id="curpage" name="curpage" value="<%=curpage%>">

<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="currenttime" name="currenttime" value="<%=currenttime%>">
<input type="hidden" id="issearch" name="issearch" value="<%=issearch%>">
<input type="hidden" id="sapbrowserid" name="sapbrowserid" value="<%=sapbrowserid%>">
<input type="hidden" id="frombrowserid" name="frombrowserid" value="<%=frombrowserid%>">
<%=hiddenValue%>

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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
		<%
			if(searchList.size()>0){//有搜索字段
		%>		
			<table width=100% class=ViewForm>
				<%
					for(int i=0;i<searchList.size();i++){
						Field Field = (Field)searchList.get(i);
						String fieldname = Field.getName();
						String desc = Field.getDesc();
						String searchvalue = Field.getSearchvalue();
				%>
					<tr>
						<TD width=15%><%=desc%></TD>
						<TD width=35% class=field><input name="<%=fieldname%>" value="<%=searchvalue%>" class="InputStyle" size="20"></TD>
						<%
							i++;
							if(i<searchList.size()){
								Field = (Field)searchList.get(i);
								fieldname = Field.getName();
								desc = Field.getDesc();
								searchvalue = Field.getSearchvalue();
						%>
								<TD width=15%><%=desc%></TD>
								<TD width=35% class=field><input name="<%=fieldname%>" value="<%=searchvalue%>" class="InputStyle" size="20"></TD>
						<%
							}
						%>
					</tr>
					<TR><TD class=Line colSpan=4></TD></TR>
				<%
				 	}
				%>
			</table>
			<br>
		<%	
			}
		%>

		
		<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" width="100%">
		<TR class=DataHeader>
		<TH style='display:none'></TH>
		<%
			int sumcolumn = 0;//总列数
		%>
		<!-- export 显示列  -->
		<%
			for(int i=0;i<export_output.size();i++){
				sumcolumn++;
				Field Field = (Field)export_output.get(i);
				String fname = Field.getName().toUpperCase();
				String desc = Field.getDesc();
				String display = Field.getDisplay();
				if(display.equals("N")){//不显示
					out.println("<TH style=\"display:none\">"+desc+"</TH>");	
				}else{
					out.println("<TH>"+desc+"</TH>");
				}
			}
		%>
		
		<!-- table 显示列 -->
		<%
			for(int i=0;i<table_output.size();i++){
				TableField TableField = (TableField)table_output.get(i);
				String output_tablename = TableField.getTableName(); 
				ArrayList tableFieldList = TableField.getTableFieldList();
				for(int k=0;k<tableFieldList.size();k++){
					sumcolumn++;
					Field Field = (Field)tableFieldList.get(k);
					String fname = Field.getName().toUpperCase();
					String desc = Field.getDesc();
					String display = Field.getDisplay();
					if(display.equals("N")){//不显示
						out.println("<TH style=\"display:none\">"+desc+"</TH>");	
					}else{
						out.println("<TH>"+desc+"</TH>");
					}
				}
			}
		%>
		</TR>
		<TR class=Line><TH colspan="<%=sumcolumn%>"></TH></TR> 
		<%
		int perpage = 50;//每页行数
		boolean nextpage = false;
		boolean lastpage = false;
		if(curpage*perpage<sumcount){
			nextpage = true;
		}
		if(curpage>1){
			lastpage = true;				
		}
		if(lastpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:onPage("+(curpage-1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(nextpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:onPage("+(curpage+1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		
		boolean trclass = true;
		int displayrows = 1;
		if(table_output.size()==0){//table 没有值，显示一行
			trclass = !trclass;
			String styleclass = "DataLight";
			if(trclass){
				styleclass = "DataDark";
			}
		%>
			<TR class="<%=styleclass%>">
				<TD style="display:none" id="returnvalue_2"></TD>
				<!-- 显示export 的值 -->
				<%
					for(int j=0;j<export_output.size();j++){
						Field Field = (Field)export_output.get(j);
						String fname = Field.getName().toUpperCase();
						String desc = Field.getDesc();
						String display = Field.getDisplay();
						String key = "EXPORT_"+fname;
						String outvalue = Util.null2String((String)export_output_value_map.get(key));
						if(display.equals("N")){
							out.println("<TD style=\"display:none\" id="+key+"_"+(2)+">"+outvalue+"</TD>");									
						}else{
							out.println("<TD div id="+key+"_"+(2)+">"+outvalue+"</TD>");
						}
					}
				%>
			</TR>
		<%
		}else{
			for(int i=0;i<table_output.size();i++){
				TableField TableField = (TableField)table_output.get(i);
				ArrayList tableFieldList = TableField.getTableFieldList();
				String output_tablename = TableField.getTableName();
				ArrayList table_output_value_list = (ArrayList)Alltable_output_value_map.get(output_tablename);
				if(table_output_value_list==null){
					table_output_value_list = new ArrayList();
				}
				
				int start = (curpage-1) * perpage;
				int end = curpage * perpage;
				if(end>sumcount) end = sumcount;//table_output_value_list.size()
				int index = -1;
				for(int j=start;j<end;j++){
					index++;
					HashMap table_output_value_map = (HashMap)table_output_value_list.get(j);
					if(table_output_value_map==null){
						table_output_value_map = new HashMap();
					}
					trclass = !trclass;
					String styleclass = "DataLight";
					if(trclass){
						styleclass = "DataDark";
					}
				%>
					<TR class="<%=styleclass%>">
						<TD style="display:none" id="returnvalue_<%=(index+2)%>"></TD>
						<!-- 显示export 的值 -->
						<%
							for(int k=0;k<export_output.size();k++){
								Field Field = (Field)export_output.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String key = "EXPORT_"+fname;
								String display = Field.getDisplay();
								String outvalue = Util.null2String((String)export_output_value_map.get(key));
								if(display.equals("N")){
									out.println("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									out.println("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
						%>
						<!-- 显示table 的值 -->
						<%
							for(int k=0;k<tableFieldList.size();k++){
								Field Field = (Field)tableFieldList.get(k);
								String fname = Field.getName().toUpperCase();
								String desc = Field.getDesc();
								String display = Field.getDisplay();
								String key = output_tablename+"_"+fname;
								String outvalue = Util.null2String((String)table_output_value_map.get(key));
								if(display.equals("N")){
									out.println("<TD style=\"display:none\" id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}else{
									out.println("<TD id="+key+"_"+(index+2)+">"+outvalue+"</TD>");
								}
							}
						%>
					</TR>
				<%}
			}
		}
		%>
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
</FORM>
</div>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
	window.parent.returnvalue = Array(0,"")
	window.parent.close
End Sub
Sub BrowseTable_onclick()
	Set e = window.event.srcElement
	If e.TagName = "TD" Then
		setParentWindowValue e.parentelement.rowIndex
		window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(0).innerText)
		window.parent.Close
   	ElseIf e.TagName = "A" Then
      	window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(0).innerText)
      	window.parent.Close
   	End If
End Sub
Sub BrowseTable_onmouseover()
   	Set e = window.event.srcElement
   	If e.TagName = "TD" Then
      	e.parentelement.className = "Selected"
   	ElseIf e.TagName = "A" Then
      	e.parentelement.parentelement.className = "Selected"
   	End If
End Sub
Sub BrowseTable_onmouseout()
   	Set e = window.event.srcElement
   	If e.TagName = "TD" Or e.TagName = "A" Then
      	If e.TagName = "TD" Then
         	Set p = e.parentelement
      	Else
         	Set p = e.parentelement.parentelement
      	End If
      	If p.RowIndex Mod 2 Then
         	p.className = "DataLight"
      	Else
         	p.className = "DataDark"
      	End If
   	End If
End Sub
</SCRIPT>
-->

<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		setParentWindowValue($(this).attr('rowIndex'));
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").text()};
		window.parent.close();
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	});

});
</script>


<script language="javascript">
jQuery(document).ready(function(){
	jQuery("#loading").hide();
})
function setParentWindowValue(rowindex){
	//alert("rowindex:"+rowindex);
	<%
		//获得需要赋值的字段
		ArrayList assignment = SapBaseBrowser.getAssignment();//赋值列表
		for(int i=0;i<assignment.size();i++){
			Field Field = (Field) assignment.get(i);
			String name = Field.getName();
			String from = Field.getFrom();
			String fieldid = (String)AllField.get(name);
	%>		
			var fieldid = "<%=fieldid%>";
			var from = "<%=from%>";
			var value = getValue(from,rowindex);
			if(fieldid=="field<%=fromfieldid%>"){
				jQuery(document.getElementById("returnvalue_"+rowindex)).text(value);
			}else{
				setValue(fieldid,value);
			}
	<%		
			//System.out.println(name+"	"+from+"	"+fieldid);
		}
	%>
}
function setValue(fieldid,value){
	var ismainfiled = "<%=ismainfiled%>";//如果是明细字段，加上行号
	var detailrow = "<%=detailrow%>";
	if(ismainfiled=="false"){
		fieldid = fieldid+"_"+detailrow;
	}
	try{
		getDialogArgumentByName(fieldid).value = value;
		if(getDialogArgumentByName(fieldid).type=="hidden"){
			getDialogArgumentByName(fieldid+"span").innerHTML = value;
		}else{
			getDialogArgumentByName(fieldid+"span").innerHTML = "";
		}
	}catch(e){
		
	}
}
function getValue(from,rowindex){
	var froms = from.split(",");
	var rvalue = "";
	if(froms.length>1){
		for(var i=0;i<froms.length;i++){
			var tempfield = froms[i];
			if(tempfield.length>2){
				if(tempfield.substring(0,1)=="$"&&tempfield.substring(tempfield.length-1,tempfield.length)=="$"){
					tempfield = tempfield.substring(1,tempfield.length-1);
					rvalue += getFieldValue(tempfield+"_"+rowindex);
				}else{
					rvalue += tempfield;
				}
			}else{
				rvalue += tempfield;
			}
		}
	}else{
		rvalue = getFieldValue(from+"_"+rowindex);
	}
	return rvalue;
}
function getFieldValue(fieldid){
	var rvalue = "";
	if(document.getElementById(fieldid)!=null){
		rvalue = jQuery(document.getElementById(fieldid)).text();
	}
	//alert(fieldid+"	"+document.getElementById(fieldid));
	return rvalue;
}

function btnclear_onclick(){
	window.parent.returnValue ={id:"",name:""};
	window.parent.close();
}

function onClear()
{
	window.parent.returnValue ={id:"",name:""};
	window.parent.close();
}
function onSubmit()
{
	jQuery("#content").hide();
	jQuery("#rightMenuIframe").hide();
	jQuery("#loading").show();
	SearchForm.submit();
}
function onPage(index)
{
	jQuery("#content").hide();
	jQuery("#rightMenuIframe").hide();
	jQuery("#loading").show();
	document.SearchForm.curpage.value = index;	
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}

function getDialogArgumentByName(name) {
	var _document = null;
    if (window.ActiveXObject) { 
    	_document = window.dialogArguments.document;
    } else{
    	_document = top.window.dialogArguments.document;
	}   

	var ele = _document.getElementById(name);
	if (ele == undefined || ele == null) {
		var eles = _document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	return ele;
}
</script>
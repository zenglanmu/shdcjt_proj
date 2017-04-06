<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver.css"></HEAD>
<%

String searchtablename = Util.null2String(request.getParameter("searchtablename"));
String searchfieldname = Util.null2String(request.getParameter("searchfieldname"));
String datasourceid = request.getParameter("datasourceid");
String tablenames = Util.null2String(request.getParameter("tablenames"));
ArrayList tablenamesArray = Util.TokenizerString(tablenames,",");
String tablenameOptions = "<option></option>";
RecordSet rs=new RecordSet();
RecordSet rs1=new RecordSet();
RecordSet rs3=new RecordSet();
RecordSetDataSource rsd=new RecordSetDataSource();
for(int i=0;i<tablenamesArray.size();i++){
	String tempS = (String)tablenamesArray.get(i);
	String formid = "";
	String tablename = "";
	formid = tempS.substring(0,tempS.indexOf(":"));
	tablename = tempS.substring(tempS.indexOf(":")+1,tempS.length());
	if(datasourceid!=null&&!datasourceid.equals("")){//外部数据源表
		String selected = "";
        //String tempSql = "select * from "+tablename;
		if(tablename.equals(searchtablename)) selected = " selected ";
		//rs3.executeSql(tempSql);
		tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablename+"</option>";
	}else{
	if(!formid.equals("")){//旧表单
		String selected = "";
		String tablelable = "";
		int groupId = 0;
		if(tablename.equals("workflow_formdetail")){
			groupId = Util.getIntValue(formid.substring(formid.indexOf("_")+1,formid.length()),0)+1;
			formid = formid.substring(0,formid.indexOf("_"));
		}
		if(formid.equals(searchtablename)) selected = " selected ";
		rs3.executeSql("select formname from workflow_formbase where id="+formid);
		if(rs3.next()) tablelable = rs3.getString("formname");
		if(tablename.equals("workflow_formdetail")) tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+groupId+")"+"</option>";
		else tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
	}else if(!tablename.equals("")){//新表单，单据，其它模块
		String selected = "";
		if(tablename.equals(searchtablename)) selected = " selected ";
		String tablelable = "";
		rs3.executeSql("select namelabel from workflow_bill where tablename='"+tablename+"'");//新表单,单据主表
		if(rs3.next()){
			tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
		}
		
		rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+tablename+"'");//单据明细表1
		if(rs3.next()){
			tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			rs.executeSql("select tablename from Workflow_billdetailtable where tablename='"+tablename+"'");
			if(!rs.next()){
				tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
				tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)"+"</option>";
			}
		}
		
		rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+tablename+"'");//新表单,单据明细表2
		if(rs3.next()){
			String billid = rs3.getString("billid");
			rs3.executeSql("select namelabel from workflow_bill where id="+billid);
			if(rs3.next()) tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			
			rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+billid);
			int detailIndex = 0;
			while(rs3.next()){
				detailIndex++;
				String detailtablename = Util.null2String(rs3.getString("tablename"));
				if(detailtablename.equals(tablename)){
					tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")"+"</option>";
				}
			}
		}
		
		String tempSql = "";
		if(user.getLanguage()==7) tempSql = "select tabledesc from Sys_tabledict where tablename='"+tablename+"'";
		if(user.getLanguage()==8) tempSql = "select tabledescen from Sys_tabledict where tablename='"+tablename+"'";
		rs3.executeSql(tempSql);//其它模块
		if(rs3.next()){
			tablelable = rs3.getString(1);
			tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
		}
	}
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="triggerTableFieldsBrowser.jsp" method=post>
<input type="hidden" id="tablenames" name="tablenames" value="<%=tablenames%>">
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">
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

			<table width=100% class=ViewForm>
			<TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=searchfieldname class="InputStyle" value="<%=searchfieldname%>"></TD>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%></TD>
			<TD width=35% class=field>
				<select id="searchtablename" name="searchtablename">
					<%=tablenameOptions%>
				</select>
			</TD>
			</TR>
			<TR style="height: 1px"><TD class=Line colspan=4></TD></TR>
			</table>
			<BR>
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
			<TR class=DataHeader>
			<TH width=70%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
			<TH width=30%><%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%></TH>
			</TR>
			<TR class=Line style="height: 1px"><TH colspan="2" ></TH></TR> 
			<%
			String sql = "";
			int i = 0;
			for(int j=0;j<tablenamesArray.size();j++){
				String tempS = (String)tablenamesArray.get(j);
				String formid = "";
				String tablename = "";
				String tablelable = "";
				formid = tempS.substring(0,tempS.indexOf(":"));
				tablename = tempS.substring(tempS.indexOf(":")+1,tempS.length());
				if(datasourceid!=null&&!datasourceid.equals("")){
					if(!searchtablename.equalsIgnoreCase("") && !searchtablename.equalsIgnoreCase(tablename)){
						continue;
					}
				    ArrayList allcolnums=rsd.getAllColumns(datasourceid,tablename);
					for(int m=0;m<allcolnums.size();m++){
					String fieldname=Util.null2String((String)allcolnums.get(m));
					if(!"".equals(searchfieldname) && fieldname.toUpperCase().indexOf(searchfieldname.toUpperCase())==-1){
						continue;
					}
                    if(i==0){
							i=1;
					%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
						<%}%>
						<TD style="display:none">
						<%=fieldname%>
						</TD>
						<TD>
						<%=fieldname%>
						</TD>
						<TD><%=tablename%></TD>
						<TD style="display:none"><%=tablename%></TD>
					</TR>
                <%
                    }
                }else{
				if(!formid.equals("")){//旧表单
					int groupId = 0;
					if(tablename.equals("workflow_form")) sql = "select fieldid from workflow_formfield where isdetail is null and formid="+formid;
					if(tablename.equals("workflow_formdetail")){
						groupId = Util.getIntValue(formid.substring(formid.indexOf("_")+1,formid.length()),0);
						formid = formid.substring(0,formid.indexOf("_"));
						sql = "select fieldid from workflow_formfield where groupId="+groupId+" and isdetail=1 and formid="+formid;
					}
					rs3.executeSql("select formname from workflow_formbase where id="+formid);
					if(rs3.next()) tablelable = rs3.getString("formname");
					if(tablename.equals("workflow_formdetail")) tablelable += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(groupId+1)+")";
					else tablelable += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
					
					if(!searchtablename.equals("")&&!searchtablename.equals(formid)) sql += " and 1=2";
					rs3.executeSql(sql);
					boolean firstflag = true;
					while(rs3.next()){
						String fieldid = rs3.getString("fieldid");
						rs.executeSql("select fieldid,fieldlable from workflow_fieldlable where langurageid="+user.getLanguage()+" and formid="+formid+" and fieldid="+fieldid);
						rs.next();
						if(!searchfieldname.equals("") && rs.getString("fieldlable").indexOf(searchfieldname) < 0) continue;
						
						if(firstflag&&!tablename.equals("workflow_formdetail")){
						    firstflag = false;
						    if(i==0){
						        i=1;
						    %>
						    <TR class=DataLight>
						    <%
						    }else{
						        i=0;
						    %>
						    <TR class=DataDark>
						    <%
						    }
						    %>
						    <TD style="display:none">requestid</TD>
						    <TD><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>ID</TD>
						    <TD><%=tablelable%></TD>
						    <TD style="display:none"><%=tablename%></TD>
						    </TR>
						<%    
						}
						
						if(i==0){
							i=1;
					%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
						<%
						}
						%>
						<TD style="display:none">
						<%
							String tempSql0 = "";
							if(tablename.equals("workflow_formdetail")) tempSql0 = "select fieldname from workflow_formdictdetail where id="+fieldid;
							else tempSql0 = "select fieldname from workflow_formdict where id="+fieldid;
							rs1.executeSql(tempSql0);
							if(rs1.next()){%>
							<%=rs1.getString("fieldname")%>
							<%}
						%>
						</TD>
						<TD>
							<%=rs.getString("fieldlable")%>
						</TD>
						<TD><%=tablelable%></TD>
						<TD style="display:none"><%=tablename%></TD>
						
					</TR>
					<%}
				}else{
					if(!searchtablename.equals("")&&!tablename.equals(searchtablename)) continue;
					else if(!searchtablename.equals("")&&tablename.equals(searchtablename)) tablename = searchtablename;
					
					rs3.executeSql("select id,namelabel from workflow_bill where tablename='"+tablename+"'");//新表单,单据主字段
					boolean firstflag = true;
					if(rs3.next()){
						String billid = rs3.getString("id");
						tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage())+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
						rs.executeSql("select fieldname,fieldlabel from workflow_billfield where viewtype=0 and billid="+billid);
						while(rs.next()){
							String fieldname = rs.getString("fieldname");
							String fieldlabel = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage());
							if(!searchfieldname.equals("") && fieldlabel.indexOf(searchfieldname) < 0) continue;
							
							if(firstflag){
							    firstflag = false;
							    if(i==0){
							        i=1;
							    %>
							    <TR class=DataLight>
							    <%
							    }else{
							        i=0;
							    %>
							    <TR class=DataDark>
							    <%
							    }
							    %>
							    <TD style="display:none">requestid</TD>
							    <TD><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>ID</TD>
							    <TD><%=tablelable%></TD>
							    <TD style="display:none"><%=tablename%></TD>
							    </TR>
							<%if(i==0){
							        i=1;
							    %>
							    <TR class=DataLight>
							    <%
							    }else{
							        i=0;
							    %>
							    <TR class=DataDark>
							    <%
							    }
							    %>
							    <TD style="display:none">id</TD>
							    <TD><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%>ID</TD>
							    <TD><%=tablelable%></TD>
							    <TD style="display:none"><%=tablename%></TD>
							    </TR>
							<%}
							if(i==0){
								i=1;
						%>
						<TR class=DataLight>
						<%
							}else{
								i=0;
						%>
						<TR class=DataDark>
							<%
							}
							%>
							<TD style="display:none"><%=fieldname%></TD>
							<TD>
								<%=fieldlabel%>
							</TD>
							<TD><%=tablelable%></TD>
							<TD style="display:none"><%=tablename%></TD>
							
						</TR>
						<%
						}
					}
					
					rs3.executeSql("select id,namelabel from workflow_bill where detailtablename='"+tablename+"'");//单据明细字段1
					rs.executeSql("select tablename from Workflow_billdetailtable where tablename='"+tablename+"'");
					if(rs3.next()&&!rs.next()){
						String billid = rs3.getString("id");
						tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage())+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
						rs.executeSql("select fieldname,fieldlabel from workflow_billfield where viewtype=1 and billid="+billid);
						while(rs.next()){
							String fieldname = rs.getString("fieldname");
							String fieldlabel = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage());
							if(!searchfieldname.equals("") && fieldlabel.indexOf(searchfieldname) < 0) continue;
							if(i==0){
								i=1;
						%>
						<TR class=DataLight>
						<%
							}else{
								i=0;
						%>
						<TR class=DataDark>
							<%
							}
							%>
							<TD style="display:none"><%=fieldname%></TD>
							<TD>
								<%=fieldlabel%>
							</TD>
							<TD><%=tablelable%></TD>
							<TD style="display:none"><%=tablename%></TD>
							
						</TR>
						<%
						}
					}
					
					rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+tablename+"'");//新表单,单据明细字段2
					if(rs3.next()){
						String billid = rs3.getString("billid");
						rs3.executeSql("select namelabel from workflow_bill where id="+billid);
						if(rs3.next()) tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
						
						rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+billid+" order by orderid");
						int detailIndex = 0;
						while(rs3.next()){
							detailIndex++;
							String detailtablename = Util.null2String(rs3.getString("tablename"));
							if(detailtablename.equals(tablename)){
								tablelable = tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
							}
						}
						
						rs.executeSql("select fieldname,fieldlabel from workflow_billfield where viewtype=1 and detailtable='"+tablename+"' and billid="+billid);
						while(rs.next()){
							String fieldname = rs.getString("fieldname");
							String fieldlabel = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage());
							if(!searchfieldname.equals("") && fieldlabel.indexOf(searchfieldname) < 0) continue;
							if(i==0){
								i=1;
						%>
						<TR class=DataLight>
						<%
							}else{
								i=0;
						%>
						<TR class=DataDark>
							<%
							}
							%>
							<TD style="display:none"><%=fieldname%></TD>
							<TD>
								<%=fieldlabel%>
							</TD>
							<TD><%=tablelable%></TD>
							<TD style="display:none"><%=tablename%></TD>
							
						</TR>
						<%
						}
					}
					
					rs3.executeSql("select id,tabledesc,tabledescen from Sys_tabledict where tablename='"+tablename+"'");//其它模块
					if(rs3.next()){
						String tabledictid = rs3.getString("id");
						if(user.getLanguage()==7) tablelable = rs3.getString("tabledesc");
						if(user.getLanguage()==8) tablelable = rs3.getString("tabledescen");
						tablelable += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
						rs.executeSql("select fieldname,fielddesc,fielddescen from Sys_fielddict where tabledictid="+tabledictid+" order by dsporder");
						while(rs.next()){
							String fieldname = rs.getString("fieldname");
							String fieldlabel = "";
							if(user.getLanguage()==7) fieldlabel = rs.getString("fielddesc");
							if(user.getLanguage()==8) fieldlabel = rs.getString("fielddescen");
							if(!searchfieldname.equals("") && fieldlabel.indexOf(searchfieldname) < 0) continue;
							if(i==0){
								i=1;
						%>
						<TR class=DataLight>
						<%
							}else{
								i=0;
						%>
						<TR class=DataDark>
							<%
							}
							%>
							<TD style="display:none"><%=fieldname%></TD>
							<TD>
								<%=fieldlabel%>
							</TD>
							<TD><%=tablelable%></TD>
							<TD style="display:none"><%=tablename%></TD>
							
						</TR>
						<%
						}
					}
				}
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
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		//window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(3).innerText)	
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text(),other1:$(this).find("td:first").next().next().next().text()};
		window.parent.close();
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected");
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected");
	});
})


function submitClear()
{
	window.parent.returnValue = {id:"",name:"",other1:""};
	window.parent.close()
}
function onClear()
{
	submitClear() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}
</script>
</BODY>
</HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
	window.parent.returnvalue = Array("","","")
	window.parent.close
End Sub
Sub BrowseTable_onclick()
	Set e = window.event.srcElement
	If e.TagName = "TD" Then   	
		window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(3).innerText)
		window.parent.Close
	ElseIf e.TagName = "A" Then
		window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
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

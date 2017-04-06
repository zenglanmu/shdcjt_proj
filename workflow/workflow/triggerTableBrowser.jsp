<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver.css"></HEAD>
<%
String wfid = Util.null2String(request.getParameter("wfid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = 0;
String tablename = Util.null2String(request.getParameter("tablename"));
int modetype = Util.getIntValue(Util.null2String(request.getParameter("modetype")),-1);
//out.println("wfid=="+wfid);
//out.println("fieldname=="+fieldname);
//out.println("tabletype=="+tabletype);
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="triggerTableBrowser.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
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
			<TD width=15%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=tablename class="InputStyle" value="<%=tablename%>"></TD>
			<TD width=15%>所属模块</TD>
			<TD width=35% class=field>
				<select id="modetype" name="modetype">
					<option value=-1 <%if(modetype==-1){%>selected<%}%>></option>
					<option value=0 <%if(modetype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
					<option value=1 <%if(modetype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
					<option value=2 <%if(modetype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></option>
					<option value=3 <%if(modetype==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></option>
					<option value=4 <%if(modetype==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></option>
					<option value=5 <%if(modetype==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></option>
					<option value=6 <%if(modetype==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></option>
					<option value=7 <%if(modetype==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18442,user.getLanguage())%></option>
					<!--<option value=9 <%if(modetype==9){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20613,user.getLanguage())%></option>
					<option value=10 <%if(modetype==10){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
					<option value=11 <%if(modetype==11){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16371,user.getLanguage())%></option>-->
				</select>
			</TD>
			</TR>
			<TR style="height:1px;"><TD class=Line colspan=4></TD></TR>
			</table>
			<BR>
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
			<TR class=DataHeader>
			<TH width=70%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></TH>
			<TH width=30%>所属模块</TH>
			</TR>
			<TR class=Line><TH colspan="2" ></TH></TR> 
			<%
			int i=0;
			String sql = "";
			if(modetype==0||modetype==-1){
			sql = "select id,formname from workflow_formbase where id in (select distinct formid from workflow_base where isvalid=1)";
			if(!tablename.equals("")) sql += " and formname like '%"+tablename+"%'";
			RecordSet.execute(sql);
			while(RecordSet.next()){
				if(i==0){i=1;
					%><TR class=DataLight><%
				}else{
					i=0;
					%><TR class=DataDark><%
				}
				%>
				
				<TD style="display:none">workflow_form</TD>
				<TD>
					<%=RecordSet.getString("formname")%>(<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>)
				</TD>
				<TD><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
				<TD style="display:none"><%=RecordSet.getString("id")%></TD>
				<TD style="display:none"><%=RecordSet.getString("id")%></TD>
				<TD style="display:none">-1</TD>
			</TR>
			<%
			int tempindex = 0;
			rs.execute("select distinct groupId from workflow_formfield where formid="+RecordSet.getString("id")+" and isdetail=1 order by groupId");
			while(rs.next()){
			tempindex++;
			if(i==0){
				i=1;
				%><TR class=DataLight><%
			}else{
				i=0;
				%><TR class=DataDark><%
			}
			%>
				<TD style="display:none">workflow_formdetail</TD>
				<TD>
					<%=RecordSet.getString("formname")%>(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+tempindex%>)
				</TD>
				<TD><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
				<TD style="display:none"><%=RecordSet.getString("id")+"_"+rs.getString("groupId")%></TD>
				<TD style="display:none"><%=RecordSet.getString("id")%></TD>
				<TD style="display:none"><%=rs.getString("groupId")%></TD>
			</TR>
			<%}}}
			if(modetype==0||modetype==-1) {
			sql = "select tablename,id,namelabel,detailtablename from workflow_bill order by id";
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String lablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
				//判断取得的标签表名是否为null值，修正当输入查询条件数据库表名的时候标签表名为null的时候查询出错。 2012/04/19  start
				if(lablename == null) {
					continue;
				}
				//判断取得的标签表名是否为null值，修正当输入查询条件数据库表名的时候标签表名为null的时候查询出错。 2012/04/19  end
				if(!tablename.equals(""))
					if(lablename.indexOf(tablename)<0) continue;
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
				<TD style="display:none"><%=RecordSet.getString(1)%></TD>
				<TD>
					<%=lablename%>(<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>)
				</TD>
				<TD><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
				<TD></TD>
				<TD style="display:none"><%=RecordSet.getString("id")%></TD>
				<TD style="display:none"><%=RecordSet.getString("id")%></TD>
				<TD style="display:none">-1</TD>
			</TR>
			<%
			String detailtablename = Util.null2String(RecordSet.getString("detailtablename"));
			String billid = Util.null2String(RecordSet.getString("id"));
			rs.execute("select tablename,orderid from Workflow_billdetailtable where tablename='"+detailtablename+"'");
			if(!detailtablename.equals("")&&!rs.next()){
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
				<TD style="display:none"><%=detailtablename%></TD>
				<TD>
					<%=lablename%>(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>1)
				</TD>
				<TD><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
				<TD></TD>
				<TD style="display:none"><%=billid%></TD>
				<TD style="display:none"><%=rs.getString("orderid") %></TD>
			</TR>
			<%}
			int j=0;
			rs.execute("select tablename,orderid from Workflow_billdetailtable where billid="+RecordSet.getString("id")+" order by orderid");
			while(rs.next()){
				j++;
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
				<TD style="display:none"><%=rs.getString(1)%></TD>
				<TD>
					<%=lablename%>(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+j%>)
				</TD>
				<TD><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></TD>
				<TD></TD>
				<TD style="display:none"><%=billid%></TD>
				<TD style="display:none"><%=rs.getString("orderid") %></TD>
			</TR>
			<%}
			}
			}
			if(user.getLanguage()==7) sql = "select tablename,tabledesc,modetype from Sys_tabledict";
			else if(user.getLanguage()==8) sql = "select tablename,tabledescen,modetype from Sys_tabledict";
				
			sql += " where 1=1 ";
			if(modetype!=-1){
				sql += " and modetype="+modetype;
			}
			if(!tablename.equals("")){
				if(user.getLanguage()==7) sql += " and tabledesc like '%"+tablename+"%'";
				else if(user.getLanguage()==8) sql += " and tabledescen like '%"+tablename+"%'";
			}
			sql += " order by modetype";
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String tempmodetype = Util.null2String(RecordSet.getString("modetype"));
				String modename = "";
				if(tempmodetype.equals("1")) modename = SystemEnv.getHtmlLabelName(179,user.getLanguage());
				if(tempmodetype.equals("2")) modename = SystemEnv.getHtmlLabelName(2115,user.getLanguage());
				if(tempmodetype.equals("3")) modename = SystemEnv.getHtmlLabelName(2113,user.getLanguage());
				if(tempmodetype.equals("4")) modename = SystemEnv.getHtmlLabelName(2114,user.getLanguage());
				if(tempmodetype.equals("5")) modename = SystemEnv.getHtmlLabelName(2116,user.getLanguage());
				if(tempmodetype.equals("6")) modename = SystemEnv.getHtmlLabelName(2117,user.getLanguage());
				if(tempmodetype.equals("7")) modename = SystemEnv.getHtmlLabelName(18442,user.getLanguage());
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
				<TD style="display:none"><%=RecordSet.getString(1)%></TD>
				<TD>
					<%=RecordSet.getString(2)%>(<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>)
				</TD>
				<TD><%=modename%></TD>
				<TD></TD>
				<TD style="display:none"></TD>
				<TD style="display:none">-1</TD>
			</TR>
			<%}%>
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

</BODY>
</HTML>


<SCRIPT LANGUAGE=VBS>

</SCRIPT>
<script language="javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		//window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(3).innerText,e.parentelement.cells(4).innerText,e.parentelement.cells(5).innerText)
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text(),other1:$(this).find("td:first").next().next().next().text(),other2:$(this).find("td:first").next().next().next().next().text(),other3:$(this).find("td:first").next().next().next().next().next().text()};
		window.parent.close();
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected");
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected");
	});

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:"",type1:"",options:""};
	window.parent.close()
}

function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:"",other1:"",other2:"",other3:""};
	window.parent.close();
}


function onClear()
{
	btnclear_onclick() ;
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
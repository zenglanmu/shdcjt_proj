<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver.css"></HEAD>
<%
String modeId = Util.null2String(request.getParameter("modeId"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")),0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
if("".equals(sqlwhere) && !"".equals(modeId)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(hasSqlwhere == false){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldBrowser.jsp" method=post>
<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
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
		<%if(hasSqlwhere == false){%>
			<table width=100% class=ViewForm>
			<TR>
			<TD width=15%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
			<TD width=35% class=field><input name=fieldname class="InputStyle" value="<%=fieldname%>"></TD>
			<TD width=15%>所属表类型</TD>
			<TD width=35% class=field>
				<select id="tabletype" name="tabletype">
					<option value=0 <%if(tabletype==0){%>selected<%}%>></option>
					<option value=1 <%if(tabletype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
					<option value=2 <%if(tabletype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>
				</select>
			</TD>
			</TR>
			<TR style="height: 1px" ><TD class=Line colspan=4></TD></TR>
			</table>
			<BR>
		<%}%>
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
			<TR class=DataHeader>
			<TH width=50%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
			<TH width=50%>所属表类型</TH>
			</TR>
			<TR class=Line style="height: 1px" ><TH colspan="2" ></TH></TR> 
			<%
			int i=0;
			String sql = "";
			String isbill = "";
			String formid = "";
			if(hasSqlwhere == false){
				RecordSet.executeSql("select formid from modeinfo where id="+modeId);
				if(RecordSet.next()){
					formid = RecordSet.getString("formid");
				}
				sql = "select id as fieldid,fieldlabel,viewtype as isdetail,dsporder as fieldorder, '' as description, detailtable as optionkey from workflow_billfield where billid="+formid;
				if(tabletype==1) sql += " and viewtype=0";
				if(tabletype==2) sql += " and viewtype=1";
				sql += " order by viewtype,optionkey,dsporder";
			}else{
				int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
				if(isdetail == 0){
					sql = "select id as fieldid, fieldlabel, 0 as isdetail, 0 as fieldorder, '' as description, '' as optionkey from workflow_billfield "+sqlwhere+" and viewtype = 0";
				}else{
					sql = "select id as fieldid, fieldlabel, 1 as isdetail, 0 as fieldorder, '' as description, '' as optionkey from workflow_billfield "+sqlwhere+" and viewtype <> 0";
				}
				sql += " order by id";
			}
			
			String mainOption = "";
			String optionsql = "";
			Hashtable detailOption = new Hashtable();
			if(hasSqlwhere == false){
			    optionsql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+formid;
			    optionsql += " order by viewtype,dsporder";
				rs.executeSql(optionsql);
				while(rs.next()){
				    String tempfieldname = "";
				    tempfieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
				    mainOption += "<,option value="+rs.getString(1)+">"+tempfieldname+"</option,>";
				}
		
			    ArrayList detailtablelist = new ArrayList();
			    optionsql = "select distinct detailtable from workflow_billfield where billid="+formid;
			    rs.executeSql(optionsql);
			    while(rs.next()){
			        String tempdetailtable = Util.null2String(rs.getString("detailtable"));
			        if(tempdetailtable.equals("")) continue;
			        detailtablelist.add(tempdetailtable);
			    }
			    for(int j=0;j<detailtablelist.size();j++){
			        String tempdetailtable = Util.null2String((String)detailtablelist.get(j));
			        if(tempdetailtable.equals("")) continue;
			        optionsql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="+formid+" and detailtable='"+tempdetailtable+"'";
			        optionsql += " order by viewtype,dsporder";
			        rs.executeSql(optionsql);
			        String wfDetailFieldsOptions = "";
			        while(rs.next()){
			            String tempfieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
			            wfDetailFieldsOptions += "<,option value="+rs.getString(1)+">"+tempfieldname+"</option,>";
			        }
			        detailOption.put(tempdetailtable,wfDetailFieldsOptions);
			    }
			}
			
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String fieldlablename = "";
				fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
				if(!fieldname.equals("")&&fieldlablename.indexOf(fieldname)<0) continue;
				String description_tmp = Util.null2String(RecordSet.getString("description")).trim();
				if(!"".equals(description_tmp)){
					fieldlablename = description_tmp;
				}
				int id_tmp = Util.getIntValue(RecordSet.getString("fieldid"), 0);
				
				String tempoption = ","+mainOption;
				String isdetail = Util.null2String(RecordSet.getString("isdetail"));
				if(isdetail.equals("1")){
				    String optionkey = Util.null2String(RecordSet.getString("optionkey"));
				    if(!optionkey.equals("")) tempoption = ","+(String)detailOption.get(optionkey);
				}
				tempoption += ",";
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
				<TD style="display:none"><%=RecordSet.getString("fieldid")%></TD>
				<TD>
					<%=fieldlablename%>
				</TD>
				<TD>
					<%if(RecordSet.getString("isdetail").equals("1")){
							out.print(SystemEnv.getHtmlLabelName(19325,user.getLanguage()));
						}else{
							out.print(SystemEnv.getHtmlLabelName(21778,user.getLanguage()));
						}
					%>
				</TD>
				<TD style="display:none"><%if(isdetail.equals("1")){%>1<%}else{%>0<%}%></TD>
				<TD style="display:none"><%=tempoption%></TD>
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

<script language="javascript">
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		window.parent.returnValue = {
			id:$($(this).children()[0]).text(),
			name:$($(this).children()[1]).text(),
			fieldtype:$($(this).children()[3]).text(),
			options:$($(this).children()[4]).text()
		};
		window.parent.close()
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})

function submitClear()
{
	window.parent.returnValue = {id:"",name:"",fieldtype:"",options:""};
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
</HTML>


<script language="javascript">

</script>
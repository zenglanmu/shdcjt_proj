<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="weaver.cowork.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery.js"></script>
</head>
<%

if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String logintype = user.getLogintype();
int userid=user.getUID();
String hrmid = Util.null2String(request.getParameter("hrmid"));
String typename="";
String departmentid="";
String managerid="";
String members="";
ConnStatement statement=new ConnStatement();
String sql="select * from cowork_types where id="+id;
boolean isoracle = (statement.getDBType()).equals("oracle");
try {
	statement.setStatementSql(sql);
	statement.executeQuery();
	if(statement.next()){
		typename = Util.toScreen(statement.getString("typename"),user.getLanguage());
		departmentid = Util.toScreen(statement.getString("departmentid"),user.getLanguage());
		if(isoracle){
			CLOB theclob = statement.getClob("managerid");
			String readline = "" ;
			StringBuffer clobStrBuff = new StringBuffer("") ;
			BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
			while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
			clobin.close() ;
			managerid = clobStrBuff.toString();
		}else{
			managerid = Util.toScreen(statement.getString("managerid"),user.getLanguage());
		}
		if(isoracle){
			CLOB theclob = statement.getClob("members");
			String readline = "" ;
			StringBuffer clobStrBuff = new StringBuffer("") ;
			BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
			while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
			clobin.close() ;
			members = clobStrBuff.toString();
		}else{
			members = Util.toScreen(statement.getString("members"),user.getLanguage());
		}
	}
}finally{
	statement.close();
}

boolean canDel = true;
if(id!=0){
	sql="select id from cowork_items where typeid="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		canDel = false;
	}
}


String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
			
<FORM id=weaver name=frmMain action="TypeOperation.jsp" method=post>
  <TABLE class=ViewForm width="100%">
    <TBODY>
    <TR class=title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      </TR>
      <TR class=spacing style="height: 1px">
        <TD class=line1 colSpan=2></TD></TR>
      <TR>
    <TR vAlign=top> 
      <TD width=100%> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="25%"> <COL width="75%"> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=inputstyle type=text maxLength=60 size=25 name=name id="name" value="<%=typename%>" onchange='checkinput("name","nameimage")'>
              <SPAN id=nameimage></SPAN>
            </TD>
          </TR>
          <TR style="height: 1px"><TD class=Line colspan=2></TD></TR> 
          <tr> <TD><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TD>
            <TD class=FIELD>
             <select name=departmentid id=dpid>
            <%while(CoMainTypeComInfo.next()){%>
            <option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%if(departmentid.equals(CoMainTypeComInfo.getCoMainTypeid())){%> selected <%}%>><%=CoMainTypeComInfo.getCoMainTypename()%></option>
            <%}%>
            </select>
  </TD>
          </TR>   
          <TR style="height: 1px"><TD class=Line colspan=2></TD></TR>          
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
          
  </TABLE>
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">
</FORM>

			
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


<script language=javascript>
function onSave() {
		var coworkname = $("#name").val();
		var typename = '<%=typename%>';				
		$.post("/cowork/type/CoworkTypeCheck.jsp",{coworkname:encodeURIComponent($("#name").val()),departmentid:$("#dpid").val(),id:'<%=id%>'},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,'name,departmentid,managerid,members')){
				 		document.frmMain.operation.value="edit";
						document.frmMain.submit();						
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}
function onDelete(){
	if(<%=canDel%>==false){
		alert("<%=SystemEnv.getHtmlLabelName(18864,user.getLanguage())%>");
		return;
	}
	if(isdel()) {
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}

function changeView(viewFlag,hiddenspan,accepterspan,flag){
	try {
		if(flag==1){
			document.getElementById(viewFlag).style.display='none';
			document.getElementById(hiddenspan).style.display='';
			document.getElementById(accepterspan).style.display='';
		}
		if(flag==0){
			document.getElementById(viewFlag).style.display='';
			document.getElementById(hiddenspan).style.display='none';
			document.getElementById(accepterspan).style.display='none';
		}
	}
	catch(e) {}
}

function back()
{
	window.history.back(-1);
}

 </script>
</BODY></HTML>

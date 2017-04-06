<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script language=javascript>
	function onClose(returnValue){
		//window.parent.returnValue = returnValue;
		window.parent.close();
	}
</script>
</HEAD>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int useapprovewf = Util.getIntValue(request.getParameter("useapprovewf"), 0);
	int approvewf = Util.getIntValue(request.getParameter("approvewf"), 0);
	int remindtype = Util.getIntValue(request.getParameter("remindtype"), 0);
	int beforestart = Util.getIntValue(request.getParameter("beforestart"), 0);
	int beforestarttime = Util.getIntValue(request.getParameter("beforestarttime"), 0);
	int beforestarttype = Util.getIntValue(request.getParameter("beforestarttype"), 0);
	int beforestartper = Util.getIntValue(request.getParameter("beforestartper"), 0);
	int beforeend = Util.getIntValue(request.getParameter("beforeend"), 0);
	int beforeendtime = Util.getIntValue(request.getParameter("beforeendtime"), 0);
	int beforeendtype = Util.getIntValue(request.getParameter("beforeendtype"), 0);
	int beforeendper = Util.getIntValue(request.getParameter("beforeendper"), 0);
	String sql = "";
	String sql_delete = "";
	String sql_insert = "";
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	int usesettotype = Util.getIntValue(request.getParameter("usesettotype"), 0);
	String mothed = Util.null2String(request.getParameter("mothed"));
	ArrayList idList = new ArrayList();
	ArrayList nameList = new ArrayList();
	if("save".equals(mothed)){
		String[] worktaskids = request.getParameterValues("worktaskid");
		for(int i=0; i<worktaskids.length; i++){
			int worktaskid = Util.getIntValue(worktaskids[i], 0);
			if(worktaskid == wtid){
				continue;
			}
			if(usesettotype == 0){//WorktaskFieldEdit
				sql_delete = "delete from worktask_taskfield where taskid="+worktaskid;
				sql_insert = "insert into worktask_taskfield (taskid, fieldid, crmname, isshow, isedit, ismand, orderid, defaultvalue, defaultvaluecn) select "+worktaskid+", fieldid, crmname, isshow, isedit, ismand, orderid, defaultvalue, defaultvaluecn from worktask_taskfield where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 1){//WorktaskListEdit
				sql_delete = "delete from worktask_tasklist where taskid="+worktaskid;
				sql_insert = "insert into worktask_tasklist (taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width, needorder) select "+worktaskid+", fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width, needorder from worktask_tasklist where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 2){//WorkTaskShareSet
				sql_delete = "delete from worktaskshareset where taskid="+worktaskid;
				sql_insert = "insert into worktaskshareset (taskid, taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) select "+worktaskid+", taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype from worktaskshareset where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 3){//worktaskCreateRight
				sql_delete = "delete from worktaskcreateshare where taskid="+worktaskid;
				sql_insert = "insert into worktaskcreateshare (taskid, sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser) select "+worktaskid+", sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser from worktaskcreateshare where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 4){//WTApproveWfEdit
				//sql_delete = "delete from worktaskcreateshare where taskid="+worktaskid;
				sql_insert = "update worktask_base set useapprovewf="+useapprovewf+", approvewf="+approvewf+" where id="+worktaskid;
				rs.execute(sql_insert);
			}else if(usesettotype == 5){//worktaskMonitorSet
				sql_delete = "delete from worktask_monitor where taskid="+worktaskid;
				sql_insert = "insert into worktask_monitor (taskid, monitor, monitortype) select "+worktaskid+", monitor, monitortype from worktask_monitor where taskid="+wtid;
				rs.execute(sql_delete);
				rs.execute(sql_insert);
			}else if(usesettotype == 6){//RemindedSet
				sql_insert = "update worktask_base set remindtype="+remindtype+", beforestart="+beforestart+", beforestarttime="+beforestarttime+", beforestarttype="+beforestarttype+", beforestartper="+beforestartper+", beforeend="+beforeend+", beforeendtime="+beforeendtime+", beforeendtype="+beforeendtype+", beforeendper="+beforeendper+" where id="+worktaskid;
				System.out.println(sql_insert);
				rs.execute(sql_insert);
			}
			//System.out.println("sql_insert = " + sql_insert);
		}
%>
		<script language=javascript>
			onClose("1");	
		</script>

<%
	}else{
		rs.executeSql("select * from worktask_base where isvalid=1 and id <>"+wtid+" order by orderid");
		while(rs.next()){
			int id = Util.getIntValue(rs.getString("id"), 0);
			String name = Util.null2String(rs.getString("name"));
			idList.add(""+id);
			nameList.add(name);
		}
	}
//System.out.println(accessorString);
%>

<BODY>
<Form name="frmSearch" method="method" action="WorktaskList.jsp">
<input type="hidden" name="mothed" />
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="usesettotype" value="<%=usesettotype%>">
<input type="hidden" name="useapprovewf" value="<%=useapprovewf%>">
<input type="hidden" name="approvewf" value="<%=approvewf%>">
<input type="hidden" name="remindtype" value="<%=remindtype%>">
<input type="hidden" name="beforestart" value="<%=beforestart%>">
<input type="hidden" name="beforestarttime" value="<%=beforestarttime%>">
<input type="hidden" name="beforestarttype" value="<%=beforestarttype%>">
<input type="hidden" name="beforestartper" value="<%=beforestartper%>">
<input type="hidden" name="beforeend" value="<%=beforeend%>">
<input type="hidden" name="beforeendtime" value="<%=beforeendtime%>">
<input type="hidden" name="beforeendtype" value="<%=beforeendtype%>">
<input type="hidden" name="beforeendper" value="<%=beforeendper%>">

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top}} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<table class="viewForm">
			<tr>
			<td>
			<Table width='100%' class='liststyle'>
			<colgroup>
			<col width='10%'>
			<col width='90%'>
			<tr class="Header">
				<td><input type="checkbox" class="inputstyle" id="allCheck" name="allCheck" value="1" onClick="checkAll()"></td>
				<td><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%></td>
			</tr>
			<TR class=Line style="height: 1px"><TD colspan="2" style="padding: 0px" ></TD></TR>
			<%
				String classStr = "DataLight";
				boolean trClass = false;
				for(int i=0; i<idList.size(); i++){
					String id = (String)idList.get(i);
					String name = (String)nameList.get(i);
			%>
			<tr class="<%=classStr%>">
				<td class=field><input type="checkbox" class="inputstyle" name="worktaskid" value="<%=id%>"></td>
				<td><%=name%></td>
			</tr>
			<%
				if(trClass == true){
					classStr = "DataLight";
					trClass = false;
				}else{
					classStr = "DataDark";
					trClass = true;
				}
				}%>
			</table>
			</td>
			</tr>
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
</FORM>
</BODY>


<script language=javascript>
	function onSave(){
		frmSearch.action="WorktaskList.jsp";
		frmSearch.mothed.value="save";
		frmSearch.submit();
	}

	function checkAll(){
		try{
			var worktaskid = document.getElementsByName("worktaskid");
			var allCheck = document.getElementById("allCheck").checked;
			if(worktaskid.length == null){
				worktaskid.checked = allCheck;
			}else{
				for(var i=0; i<worktaskid.length; i++) {
					worktaskid[i].checked = allCheck;
				}
			}
		}catch(e){}
	}
</script>
</HTML>
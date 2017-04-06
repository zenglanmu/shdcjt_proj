<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(27244,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String modeid="";
	String modename = "";
	String sql = "";
	String formID = "";	
	String isBill = "1";
    String Customname = "";
    String Customdesc = "";
	
	String id = Util.null2String(request.getParameter("id"));
	sql = "select a.modeid,a.customname,a.customdesc,b.modename,b.formid,a.defaultsql,a.disQuickSearch from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+id;
	rs.executeSql(sql);
	if(rs.next()){
		formID = Util.null2String(rs.getString("formid"));	
		isBill = "1";
	    Customname = Util.toScreen(rs.getString("Customname"),user.getLanguage()) ;
		modeid = Util.null2String(rs.getString("modeid"));
		modename = Util.null2String(rs.getString("modename"));
	    Customdesc = Util.toScreenToEdit(rs.getString("Customdesc"),user.getLanguage());
	}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name=frmMain action="/formmode/batchoperate/ModeBatchSetOperation.jsp" method=post>
<input type="hidden" id="id" name="id" class="inputstyle" value="<%=id%>">
<input type="hidden" id="operation" name="operation" class="inputstyle" value="edit">

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
		
	  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="15%">
  		<COL width="15%">
  		<COL width="15%">
		<COL width="15%">
		<COL width="15%">
		<COL width="15%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(81454,user.getLanguage())%></th><!-- 操作名称 -->
	      <th><%=SystemEnv.getHtmlLabelName(17987,user.getLanguage())%></th><!-- 用途描述 -->
	      <th><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></th><!-- 操作类型 -->
	      <th><%=SystemEnv.getHtmlLabelName(30828,user.getLanguage())%></th><!-- 显示名称 -->
	      <th><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></th><!-- 是否使用 -->
	      <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th><!-- 显示顺序 -->
	    </TR>
		<TR class=Line><TD colSpan=6 style="padding: 0"></TD></TR>
		
		<%
			if(rs.getDBType().equals("oracle")){
				sql = "select a.id,a.expendname,a.expenddesc,b.isuse,nvl(b.showorder,0) showorder,a.issystem,b.listbatchname,a.defaultenable from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+id+" where a.isbatch in(1,2) and a.modeid = " + modeid + " order by issystem desc,nvl(b.isuse,0) desc,showorder asc,a.id asc";
			}else{
				sql = "select a.id,a.expendname,a.expenddesc,b.isuse,isnull(b.showorder,0) showorder,a.issystem,b.listbatchname,a.defaultenable from mode_pageexpand a left join mode_batchset b on a.id = b.expandid and b.customsearchid = "+id+" where a.isbatch in(1,2) and a.modeid = " + modeid + " order by issystem desc,isnull(b.isuse,0) desc,showorder asc,a.id asc";	
			}
			rs.executeSql(sql);
			boolean isLight = false;
			int nLogCount=0;
			while(rs.next()) {
				String expendname = Util.null2String(rs.getString("expendname"));
				String defaultenable = Util.null2String(rs.getString("defaultenable"));
				String expenddesc = Util.null2String(rs.getString("expenddesc"));
				String listbatchname = Util.null2String(rs.getString("listbatchname"));
				String isuse = Util.null2String(rs.getString("isuse"));
				double showorder = Util.getDoubleValue(rs.getString("showorder"),0);
				int issystem = Util.getIntValue(rs.getString("issystem"),0);
				int expendid = Util.getIntValue(rs.getString("id"),0);
				String operatename = "";
				if(issystem==0){
					operatename = SystemEnv.getHtmlLabelName(73,user.getLanguage());
				}else{
					operatename = SystemEnv.getHtmlLabelName(28119,user.getLanguage());
					if(isuse.equals("")){
						isuse = defaultenable;
					}
				}
				
				if(listbatchname.equals("")){
					listbatchname = expendname;
				}
				
				if(isLight) {
		%>	
					<TR CLASS=DataLight>
		<%		
				}else{
		%>
					<TR CLASS=DataDark>
		<%		
				}
		%>
						<TD>
							<%=expendname%>
							<input type="hidden" id="expandid_<%=nLogCount%>" name="expandid_<%=nLogCount%>" class="inputstyle" value="<%=expendid%>">
						</TD>
						<TD><%=rs.getString("expenddesc")%></TD>
						<TD><%=operatename%></TD>
						<TD><input type="text" id="listbatchname_<%=nLogCount%>" name="listbatchname_<%=nLogCount%>" class="inputstyle" value="<%=listbatchname%>"></TD>
						<TD>
							<input type="checkbox" id="isuse_<%=nLogCount%>" name="isuse_<%=nLogCount%>" class="inputstyle" value="1" <%if(isuse.equals("1"))out.println("checked"); %>>
						</TD>
						<TD><input type="text" id="showorder_<%=nLogCount%>" name="showorder_<%=nLogCount%>" class="inputstyle" value="<%=showorder%>" onkeypress="ItemDecimal_KeyPress('showorder_<%=nLogCount%>',6,2)" onblur="checknumber1(this);"></TD>
			        </TR>
			<%
				isLight = !isLight;
				nLogCount++;
			}
		%>
	  </TBODY>
	  </TABLE>
	  <input type="hidden" id="nLogCount" name="nLogCount" value="<%=nLogCount%>">
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
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmMain.submit();
    }
    function doBack(){
		enableAllmenu();
        location.href="/formmode/search/CustomSearchEdit.jsp?id=<%=id%>";
    }
</script>

</BODY>
</HTML>

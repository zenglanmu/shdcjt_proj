<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(563,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String sql = "";
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	String pid = Util.null2String(request.getParameter("pid"));
	String pids[] = pid.split(CustomTreeData.Separator);
	String customdetailid = pids[0];
	String supid = pids[1];
	String defaultaddress = Util.null2String(request.getParameter("defaultaddress"));
	sql = "select * from mode_customtree where id = " + mainid;
	rs.executeSql(sql);
	while(rs.next()){
		titlename = Util.null2String(rs.getString("rootname"));
		defaultaddress = Util.null2String(rs.getString("defaultaddress"));
	}
	
	if(!defaultaddress.equals("")){
		response.sendRedirect(defaultaddress);
		return;
	}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
	<div>
		<p><strong>操作说明</strong></p>
		<ul>
		  <li>点击左边树中的节点，本页会显示该节点对应的数据</li>
		  <li>如果选中的节点没有配置对应的地址，那么本页面的内容不会刷新</li>
		</ul>
	</div>
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

</BODY>
</HTML>

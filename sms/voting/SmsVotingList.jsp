<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(22304,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/sms/voting/SmsVotingAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE width=100% height=95% border="0" cellspacing="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<form name="frmmain" method="post" action="SmsVotingList.jsp">
		<input type=hidden name=method value="">
		<input type=hidden name=id value="">
		<TABLE class=Shadow>
			<tr>
				<td valign="top">
				<!--列表部分-->
				<%
					//得到pageNum 与 perpage
					int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
					int perpage = UserDefaultManager.getNumperpage();
					if(perpage <2) perpage=15;

					//设置好搜索条件
					String backFields =" s.id as id, subject, senddate, sendtime, creater, s.status, createdate, createtime ";
					String fromSql = " smsvoting s ";
					String sqlWhere = " where (creater="+user.getUID()+" or (isseeresult=0 and exists(select h.id from smsvotinghrm h where h.smsvotingid=s.id and h.userid="+user.getUID()+" )))";

					String orderBy = " createdate, createtime ";
					String linkstr = "";
					linkstr = "SmsVotingView.jsp";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
								"<head>"+
									"<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" href=\""+linkstr+"\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"mainFrame\"/>"+
									"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" href=\""+linkstr+"\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"mainFrame\"/>"+
									"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(18961,user.getLanguage())+"\" column=\"senddate\" otherpara=\"column:sendtime\" orderkey=\"senddate, sendtime \" />"+
									"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForSmsVoting.getSmsVotingStatus\"/>"+
								"</head>"+
								"<operates width=\"15%\">"+
								"<popedom transmethod=\"weaver.splitepage.transform.SptmForSmsVoting.getSmsVotingOpt\"  otherpara=\"column:status+column:creater+"+user.getUID()+"\"></popedom>"+
								"	<operate href=\"javascript:onEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"0\"/>"+
								"	<operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>"+
								"</operates>"+
								"</table>";
				%>
				<TABLE width="100%" height="100%">
					<TR>
						<TD valign="top">
							<wea:SplitPageTag isShowTopInfo="true" tableString="<%=tableString%>"  mode="run"/>
						</TD>
					</TR>
				</TABLE>
				</td>
			</tr>
		</TABLE>  
		</form>
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</table>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
function onEdit(id){
	window.location='SmsVotingEdit.jsp?id='+id;
}
function onDel(id){
	if(isdel()){
		document.frmmain.action = "SmsVotingOperation.jsp";
		document.frmmain.method.value = "delete";
		document.frmmain.id.value = id;
		document.frmmain.submit();
		enableAllmenu();
	}
}
</SCRIPT>
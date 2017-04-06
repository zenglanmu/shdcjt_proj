<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
String needfav ="1";
String needhelp ="";

String customname = Util.null2String(request.getParameter("customname"));
String modeid=Util.null2String(request.getParameter("modeid"));
String monitor = Util.null2String(request.getParameter("monitor"));//创建监控菜单
String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(30247,user.getLanguage())+",javascript:createmenu(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30248,user.getLanguage())+",javascript:viewmenu(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createmenu1(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30246,user.getLanguage())+",javascript:viewmenu1(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
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
<%
	if(monitor.equals("1")){
%>
		<span><font color="red"><%=SystemEnv.getHtmlLabelName(30252,user.getLanguage())%></font></span>
		<p></p>
<%
	}
%>

<form name="frmSearch" method="post" action="/formmode/search/CustomSearch.jsp">
	<input type="hidden" name="monitor" id="monitor" value="<%=monitor%>">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="customname" class="inputStyle" value="<%=customname%>">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
			</td>
			<td class="Field">
				<button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
				<span id=modeidspan><%=modename%></span>
				<input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
//select a.modeid,a.customname,a.customdesc,b.modename from mode_customsearch a,modeinfo b where a.modeid = b.id
String SqlWhere = " where a.modeid = b.id";
if(!customname.equals("")){
	SqlWhere += " and a.customname like '%"+customname+"%'";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = '"+modeid+"'";
}


String perpage = "10";
String backFields = "a.id,a.modeid,a.customname,a.customdesc,b.modename";
String sqlFrom = " from mode_customsearch a,modeinfo b";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"radio\">"+
				  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				  "<head>"+                             
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"customname\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/search/CustomSearchEdit.jsp\" orderkey=\"customname\"/>"+
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(28485,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"/>"+
						  "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"customdesc\" orderkey=\"customdesc\"/>"+
				  "</head>"+
			  "</table>";


%>

<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>

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
<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		if($("#modeid").val()=='0'){
			if(confirm("请先保存基本信息！")){
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
	function createmenu(){
		var id = _xtable_CheckedRadioId();
		if(id==""){
			alert("<%=SystemEnv.getHtmlLabelName(30251,user.getLanguage())%>");
		}else{
			var url = "/formmode/search/CustomSearchBySimple.jsp?customid="+id;
			window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
		}
	}
	function viewmenu(){
		var id = _xtable_CheckedRadioId();
		if(id==""){
			alert("<%=SystemEnv.getHtmlLabelName(30251,user.getLanguage())%>");
		}else{
			var url = "/formmode/search/CustomSearchBySimple.jsp?customid="+id;
			prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
		}
	}
	function createmenu1(){
		var id = _xtable_CheckedRadioId();
		if(id==""){
			alert("<%=SystemEnv.getHtmlLabelName(30251,user.getLanguage())%>");
		}else{
			var url = "/formmode/search/CustomSearchBySimple.jsp?customid="+id+"&viewtype=3";
			window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
		}
	}
	function viewmenu1(){
		var id = _xtable_CheckedRadioId();
		if(id==""){
			alert("<%=SystemEnv.getHtmlLabelName(30251,user.getLanguage())%>");
		}else{
			var url = "/formmode/search/CustomSearchBySimple.jsp?customid="+id+"&viewtype=3";
			prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
		}
	}
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/search/CustomSearchAdd.jsp?modeid=<%=modeid%>&customname=<%=customname%>";
    }
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
</script>

</BODY></HTML>
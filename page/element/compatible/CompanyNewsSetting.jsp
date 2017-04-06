<%@ page language="java" contentType="text/html; charset=GBK"%>
<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.*"%>
<link href='/css/Weaver.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver.js'></script>
<%
	
	String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
	String eid = Util.null2String(request.getParameter("eid"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	String tabTitle = Util.null2String(request.getParameter("tabTitle"));
	tabTitle = URLDecoder.decode(tabTitle, "utf-8");
	rs.execute("select tabtitle from hpnewstabinfo where eid="+eid+" and tabid="+tabId);
	 if(rs.next()){
		 tabTitle = rs.getString("tabtitle");
	 }
	String whereKey = Util.null2String(request.getParameter("value"));
	String whereSrcName = "";
	if(!"".equals(whereKey))
	{
		whereSrcName = dnc.getDocNewsname(whereKey);
	}
%>

<TABLE class=viewForm >
	
	<TBODY>
		<TR valign=top><TD><%=SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId))%></TD><TD class=field><input  class=inputStyle id='tabTitle_<%=eid%>' type='text' value="<%=Util.toHtml2(tabTitle.replaceAll("&","&amp;"))%>"   onchange='checkinput("tabTitle_<%=eid%>","tabTitleSpan_<%=eid%>")' /><SPAN id='tabTitleSpan_<%=eid%>'>
		<% if(tabTitle.equals("")){%>
			<IMG src="/images/BacoError.gif" align=absMiddle>
		<%}%>
		</SPAN></TD></TR>
		<tr><td colspan=2 class="line"></td></tr>
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(22919,Util.getIntValue(userLanguageId))%></TD>
			<TD class=field>
				<INPUT id="_whereKey_<%=eid%>" type=hidden value="<%=whereKey %>" name="_whereKey_<%=eid%>">
				<BUTTON type="button" class=Browser onclick=onShowNewNews(_whereKey_<%=eid%>,spannews_<%=eid%>,<%=eid%>,0)></BUTTON>
				<SPAN id=spannews_<%=eid%>>
					<%
					if(!"".equals(whereKey))
					{
					%>
					<a href="/docs/news/NewsDsp.jsp?id=<%=whereKey %>" target='_blank'><%=whereSrcName %></a>
					<%
					}
					%>
				</SPAN>
			</TD>
		</TR>
		<tr><td colspan=2 class="line"></td></tr>
	</TBODY>
</TABLE>
<script type="text/javascript">

function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	return whereKeyStr;
}

function onShowNewNews(input,span,eid,publishtype){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp?publishtype="+publishtype)
	if (data){
		if (data.id!="0"){
			span.innerHTML = "<a href='/docs/news/NewsDsp.jsp?id="+data.id+"' target='_blank'>" +data.name+"</a>"
			input.value=data.id
		}else{ 
			span.innerHTML = ""
			input.value="0"
		}
	}
}

</script>
				
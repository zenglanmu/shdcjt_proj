<%@ include file="/page/element/settingCommon.jsp"%>
<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs_setting" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="common.jsp" %>
<%
String newsId = (String)valueList.get(nameList.indexOf("newsid"));
String newsTemplate = (String) valueList.get(nameList.indexOf("newstemplate"));
String newsName = "";
if(!"".equals(newsId))
{
	newsName = dnc.getDocNewsname(newsId);
}
String userLanguageId = user.getLanguage()+"";
String settingStr="";
String selected="";

rs_setting.execute("select * from pagenewstemplate where templatetype='1'");

settingStr+="<tr valign=top><TD>&nbsp;"+SystemEnv.getHtmlLabelName(23088, Util.getIntValue(userLanguageId))+"</TD>";
settingStr+="<TD class=field><select id='_newstemplate_"+eid+"' name='_newstemplate_"+eid+"'>";
settingStr+="<option value=''>"+SystemEnv.getHtmlLabelName(18214, Util.getIntValue(userLanguageId))+"</option>";
while(rs_setting.next()){
	if(rs_setting.getString("id").equals(newsTemplate)){
		selected = "selected";
	}else{
		selected="";
	}
	settingStr+="<option value='"+rs_setting.getString("id")+"' "+selected+">"+rs_setting.getString("templatename")+"</option>";
}
settingStr+="</select></TD></tr>";
%>



		
		<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(22919,user.getLanguage())%>
			</TD>
			<TD class="field">
				<INPUT id="_newsid_<%=eid%>" type=hidden value="<%=newsId %>" name="_newsid_<%=eid%>">
				<BUTTON class=Browser type="button" onclick=onShowNewNews(_newsid_<%=eid%>,spannews_<%=eid%>,<%=eid%>,0)></BUTTON>
				<SPAN id=spannews_<%=eid%>>
					<%
					if(!"".equals(newsName))
					{
					%>
					<a href="/docs/news/NewsDsp.jsp?id=<%=newsId %>" target='_blank'><%=newsName %></a>
					<%
					}
					%>
				</SPAN>
			</TD>
		</TR>		
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
		<%=settingStr%>
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
	</TABLE>
</form>
	

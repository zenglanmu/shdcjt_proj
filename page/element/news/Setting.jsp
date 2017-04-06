
<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_tabInfo" class="weaver.conn.RecordSet" scope="page" />
<%@page import="java.util.ArrayList;"%>
<%
	String showtitle = (String)valueList.get(nameList.indexOf("showtitle"));
	String showauthor = (String)valueList.get(nameList.indexOf("showauthor"));
	String showpubdate = (String)valueList.get(nameList.indexOf("showpubdate"));
	String showpubtime = (String)valueList.get(nameList.indexOf("showpubtime"));
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
	String whereKey = (String)valueList.get(nameList.indexOf("whereKey"));
	String listType = (String)valueList.get(nameList.indexOf("listType"));
	String imagesize =(String)valueList.get(nameList.indexOf("imagesize"));
	String randomValue = Util.null2String(request.getParameter("randomValue"));
	String whereSrcName = "";
	if(!"".equals(whereKey))
	{
		whereSrcName = dnc.getDocNewsname(whereKey);
	}
	String userLanguageId = user.getLanguage()+"";
	String settingStr="";
    rs_tabInfo.execute("select newstemplate from hpElement where id="+eid);
	
	String currentTemplateId="";
	String selected="";
	if(rs_tabInfo.next()){
		currentTemplateId = rs_tabInfo.getString("newstemplate");	
	}
	rs_tabInfo.execute("select * from pagenewstemplate where templatetype='1'");
	
	settingStr+="<tr valign=top><TD>&nbsp;"+SystemEnv.getHtmlLabelName(23088, Util.getIntValue(userLanguageId))+"</TD>";
	settingStr+="<TD class=field><select id='_newstemplate"+eid+"' >";
	settingStr+="<option value=''>"+SystemEnv.getHtmlLabelName(18214, Util.getIntValue(userLanguageId))+"</option>";
	while(rs_tabInfo.next()){
		if(rs_tabInfo.getString("id").equals(currentTemplateId)){
			selected = "selected";
		}else{
			selected="";
		}
		settingStr+="<option value='"+rs_tabInfo.getString("id")+"' "+selected+">"+rs_tabInfo.getString("templatename")+"</option>";
	}
	settingStr+="</select></TD></tr>";

	settingStr+="<TR vAlign=top>"+
	"<TD class=line colSpan=2></TD>"+
	"</TR>";
	String url = "/page/element/compatible/CompanyNewsSetting.jsp?eid="+eid+"&userLanguageId="+userLanguageId;
	String strTabSql = "select * from hpNewsTabInfo where eid="+eid +" order by cast(tabId as int)";
	
	rs_tabInfo.execute(strTabSql);
	
	settingStr+="<TR valign=top><TD>&nbsp;"+SystemEnv.getHtmlLabelName(22919,Util.getIntValue(userLanguageId))+"</TD><TD class=field>";
	settingStr+="<table id=tabSetting_"+eid+">";
	settingStr+="<TR><TD><a align=right href='javascript:addTab(\""+eid+"\",\""+url+"\",\""+ebaseid+"\")'>"+SystemEnv.getHtmlLabelName(611,Util.getIntValue(userLanguageId))+"</a></TD><TD></TD></TR>" ;
	
	String maxTabId="0";
	while(rs_tabInfo.next()){
		if(Util.getIntValue(rs_tabInfo.getString("tabId"))>Util.getIntValue(maxTabId)){
			maxTabId = rs_tabInfo.getString("tabId");
		}
		settingStr+="<TR><TD><span id = \"tab_"+eid+"_"+rs_tabInfo.getString("tabId")+"\" tabWhere=\""+rs_tabInfo.getString("sqlWhere")+"\" tabId=\""+rs_tabInfo.getString("tabId")+"\" tabTitle=\""+Util.toHtml2(rs_tabInfo.getString("tabTitle").replaceAll("&","&amp;"))+"\" >"+Util.toHtml2(rs_tabInfo.getString("tabTitle").replaceAll("&","&amp;"))+"" +
		"</span></TD><TD width=100 lign='right'><a href='javascript:deleTab("+eid+","+rs_tabInfo.getString("tabId")+",\""+ebaseid+"\")'>"+SystemEnv.getHtmlLabelName(91,Util.getIntValue(userLanguageId))+"</a> &nbsp;&nbsp; <a href='javascript:editTab("+eid+","+rs_tabInfo.getString("tabId")+",\""+ebaseid+"\")'>"+SystemEnv.getHtmlLabelName(22250,Util.getIntValue(userLanguageId))+"</a></TD></TR>";

	}
	settingStr+="</table>";
	settingStr+="<div id='tabDiv_"+eid+"_"+randomValue+"' tabCount='"+maxTabId+"' url='"+url+"' ><iframe id='dialogIframe_"+eid+"_"+randomValue+"' BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE width='100%' height='100%'  scrolling='NO' ></iframe></div>";
	settingStr+="</TD></TR>";
	
%>

			<TR vAlign=top>
				<TD>
					&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%>
				</TD>
				<!--显示字段-->
				<TD class=field>
					<INPUT type=checkbox <%if("7".equals(showtitle)){ %>checked<%} %> value="<%=showtitle %>" name=_showtitle_<%=eid%> onclick="if(this.checked){this.value='7';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(19524,user.getLanguage())%>:
					<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(19524,user.getLanguage())%> style="WIDTH: 24px" value="<%=wordcount %>" name="_wordcount_<%=eid%>" basefield="7">
					<BR>
					<INPUT type=checkbox <%if("8".equals(showauthor)){ %>checked<%} %> value="<%=showauthor %>" name="_showauthor_<%=eid%>" onclick="if(this.checked){this.value='8';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>
					<BR>
					<INPUT type=checkbox <%if("9".equals(showpubdate)){ %>checked<%} %> value="<%=showpubdate %>" name="_showpubdate_<%=eid%>" onclick="if(this.checked){this.value='9';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(17883,user.getLanguage())%>
					<BR>
					<INPUT type=checkbox <%if("10".equals(showpubtime)){ %>checked<%} %> value="<%=showpubtime %>" name="_showpubtime_<%=eid%>" onclick="if(this.checked){this.value='10';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%>
					<BR>
				</TD>
			</TR>
			<TR vAlign=top>
				<TD class=line colSpan=2></TD>
			</TR>
			<TR vAlign=top>
				<TD>
					&nbsp;<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
				</TD>
				<!--显示字段-->
				<TD class=field>
					<INPUT TYPE="text"  name="_imagesize_<%=eid%>" value="<%=imagesize%>" size=3 class="inputStyle" style="width:24PX">
				</TD>
			</TR>
			
			<%
			   String listSetting = "";
			   String showMode1="";
			   String showMode2="";
			   if(listType.equals("1")){
				   showMode1 = "selected";
			   }else if(listType.equals("2")){
				   showMode2="selected";
			   }
			listSetting+=	          
				"<TR><TD CLASS=LINE COLSPAN=2></TD></TR>"+
				"<TD>&nbsp;" +SystemEnv.getHtmlLabelName(89,Util.getIntValue(userLanguageId))+SystemEnv.getHtmlLabelName(599,Util.getIntValue(userLanguageId))+"</TD>" +
				"<!--显示方式-->" +
				"<TD  class=field><select name=\"_listType_"+eid+"\">" +
						"<option value=1 "+showMode1+">"+SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))+"</option>" +
	                	"<option value=2 "+showMode2+">"+SystemEnv.getHtmlLabelName(19527,Util.getIntValue(userLanguageId))+"</option>" +
						"</select>" ;
				listSetting+="</TD></TR>";
			%>
			<%= listSetting%>	

			<TR vAlign=top>
				<TD class=line colSpan=2></TD>
			</TR>
			<%=settingStr%>
			<TR vAlign=top>
				<TD class=line colSpan=2></TD>
			</TR>
		</TBODY>
	</TABLE>
</form>
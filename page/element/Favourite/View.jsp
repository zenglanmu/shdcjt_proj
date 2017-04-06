<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="farecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String ftitle = (String)valueList.get(nameList.indexOf("ftitle"));
String ftype = (String)valueList.get(nameList.indexOf("ftype"));
String flevel = (String)valueList.get(nameList.indexOf("flevel"));
String fdate = (String)valueList.get(nameList.indexOf("fdate"));
String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
%>
<TABLE id=newscontent_<%=eid%> style="COLOR: #003399" width="100%">
	<TBODY>
		<TR>
			<TD vAlign=top width=*>
				<TABLE width="100%">
					<TBODY>
						<%
							if((!"".equals(ftitle)||!"".equals(ftype)||!"".equals(flevel)||!"".equals(fdate)))
							{
								String iconImg=esc.getIconEsymbol(hpec.getStyleid(eid));
								String tesql = "";
								tesql = "select top "+perpage+" r.* from (select distinct a.* "
										+ " from sysfavourite a "
										+ " where a.resourceid =" + user.getUID()
										+ " ) r order by importlevel desc,adddate desc,id desc";
								
								String dbtype = farecordSet.getDBType();
								if(dbtype.equals("oracle"))
								{
									tesql = "select * from (select distinct a.* "
									+ " from sysfavourite a "
									+ " where a.resourceid =" + user.getUID()
									+ "  order by importlevel desc,adddate desc,id desc) r where rownum<="+perpage+"";
								}
								farecordSet.execute(tesql);
								while (farecordSet.next())
								{
									String pagename = farecordSet.getString("Pagename");
									//pagename = Util.toHtmlMode(pagename);
									
									String newpagename=Util.getMoreStr(pagename,Util.getIntValue(wordcount,8),"...");
									newpagename = newpagename.replaceAll("&nbsp", "£¦nbsp");
									newpagename = Util.toHtml5(newpagename);
									
									String url = farecordSet.getString("URL");
									
									String favouritetype = farecordSet.getString("favouritetype");
									String typename = "";
									if("1".equals(favouritetype))
									{
										typename = SystemEnv.getHtmlLabelName(22243,user.getLanguage());
									}
									else if("2".equals(favouritetype))
									{
										typename = SystemEnv.getHtmlLabelName(22244,user.getLanguage());
									}
									else if("3".equals(favouritetype))
									{
										typename = SystemEnv.getHtmlLabelName(22245,user.getLanguage());
									}
									else if("4".equals(favouritetype))
									{
										typename = SystemEnv.getHtmlLabelName(21313,user.getLanguage());
									}
									else
									{
										typename = SystemEnv.getHtmlLabelName(375,user.getLanguage());
									}
									
									String favouritedata = farecordSet.getString("adddate");
									favouritedata = favouritedata.substring(0,10);
									String importlevel = farecordSet.getString("importlevel");
									String importname = "";
									if("1".equals(importlevel))
									{
										importname = SystemEnv.getHtmlLabelName(154,user.getLanguage());
									}
									else if("2".equals(importlevel))
									{
										importname = SystemEnv.getHtmlLabelName(22241,user.getLanguage());
									}
									else
									{
										importname = SystemEnv.getHtmlLabelName(15533,user.getLanguage());
									}
								
						%>
						<TR height=18>
							<TD width=8><IMG src="<%=iconImg%>" name=esymbol></TD>
							<%
							if("7".equals(ftitle))
							{ 
							%>
							<TD title=<%=newpagename%> width=*><A href="<%=url %>" target="<%if("2".equals(linkmode)){ %>_blank<%}else{ %>_self<%} %>"><%="<font class=font>"+newpagename+"</font>" %></A></TD>
							<%
							} 
							%>
							<%
							if("8".equals(ftype))
							{ 
							%>
							<TD width=36><%="<font class=font>"+typename+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("9".equals(flevel))
							{ 
							%>
							<TD width=36><%="<font class=font>"+importname+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("10".equals(fdate))
							{ 
							%>
							<TD width=80><%="<font class=font>"+favouritedata+"</font>"%></TD>
							<%
							}
							%>
						</TR>
						<TR  class="sparator" style='height:1px' height=1>
							<TD colSpan=5 style='padding:0px'></TD>
						</TR>
						<%
								}
							}
						%>
					</TBODY>
				</TABLE>
			</TD>
		</TR>
	</TBODY>
</TABLE>
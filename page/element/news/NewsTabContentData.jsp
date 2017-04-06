<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="java.io.BufferedReader"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_doc" class="weaver.conn.RecordSet" scope="page" />

<%
	String showtitle = (String)valueList.get(nameList.indexOf("showtitle"));
	String showauthor = (String)valueList.get(nameList.indexOf("showauthor"));
	String showpubdate = (String)valueList.get(nameList.indexOf("showpubdate"));
	String showpubtime = (String)valueList.get(nameList.indexOf("showpubtime"));
	
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
	String listType = (String)valueList.get(nameList.indexOf("listType"));
	String whereKey = Util.null2String(request.getParameter("tabWhere"));
	int imagesize = Util.getIntValue((String)valueList.get(nameList.indexOf("imagesize")));
	String newstemplateid="";
	rs_Setting.execute("select newstemplate from hpElement where id="+eid);
	
	if(rs_Setting.next()){
		newstemplateid = rs_Setting.getString("newstemplate");	
	}
	String requesturl = request.getHeader("Host");
	NewsUtil newsf = new NewsUtil(requesturl);
	
	NewsPageBean newsp = newsf.getNewsPageBean(whereKey, "0", ""+perpage, "1", "1");
	ArrayList newsitems = newsp.getNewsItemList();
	
	
%>
<%
	String listShow ="";
	int rowcount=0;
	String imgSymbol="";
	if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
	
	%>
	<TABLE id=newscontent_<%=eid%> style="COLOR: #003399" width="100%">
	<TBODY>
		<TR>
			<TD vAlign=top width=*>
		
	<%

	if(listType.equals("2")){
		listShow += "<TABLE  width=\"100%\"";	
		listShow += " cellPadding='0' cellSpacing='0' >\n";
	
	
	
		for(int i=0; i<newsitems.size();i++){
			NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
			String newsid = newsitem.getNewsid();
			String docid =newsid;
			if(newsid.indexOf("&")!=-1){
				docid = newsid.substring(0,newsid.indexOf("&"));
			}
			String newsContent = newsitem.getContent();
			String newstitle = newsitem.getTitle();
			String nnewstitle=Util.getMoreStr(newstitle,Util.getIntValue(wordcount,8),"...");
			String strmemo = Util.getMoreStr(newsitem.getDescription(),80,"...");
			String newsauthor = newsitem.getAuthor();
			String newspubdate = newsitem.getPubDate();
			String strSql_DocContent="";
			ConnStatement statement=new ConnStatement();
			try{
			if(("oracle").equals(rs_doc.getDBType())){
				
				strSql_DocContent="select doccontent from docdetail d1,docdetailcontent d2 where d1.id=d2.docid and d1.id="+docid;
				statement.setStatementSql(strSql_DocContent, false);
				statement.executeQuery();
				if(statement.next()) {
				  CLOB theclob = statement.getClob("doccontent");
				  String readline = "";
				  StringBuffer clobStrBuff = new StringBuffer("");
				  BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				  while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				  clobin.close() ;
				  newsContent = clobStrBuff.toString();
				}	
			} else{
				strSql_DocContent="select doccontent from docdetail where id="+docid;
				statement.setStatementSql(strSql_DocContent, false);
				statement.executeQuery();
				if(statement.next()) newsContent=statement.getString("doccontent");
			}
			}finally{
				statement.close();
			}
			
			newspubdate = newspubdate.trim();
			int indexpos = newspubdate.indexOf(" ");
			String pubdate = "";
			String pubtime = "";
			if(indexpos>0)
			{
				pubdate = newspubdate.substring(0,indexpos);
				pubtime = newspubdate.substring(indexpos,newspubdate.length());
			}
			String newslink = newsitem.getLink();
			String iconImg=esc.getIconEsymbol(hpec.getStyleid(eid));
			listShow += "<TR height=18px>\n";
			
			listShow += "	<TD width=\"8\">"+imgSymbol+"</TD>\n";
			
			String strImg="";
			
		
			strImg = hpes.getImgPlay(request,newsid,newsContent,imagesize,0,hpc.getStyleid(hpid),eid);
			
			if("1".equals(linkmode)){
				if("".equals(newstemplateid)){
					
					newstitle = nnewstitle;
					
				}else{
					
					newstitle ="<A href=\"/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"\"><font class=\"font\">"+nnewstitle+"</font></A>";
					
				}
			}else{
				
				if("".equals(newstemplateid)){
					
					newstitle=nnewstitle;
					
				}else{
					
					newstitle="<a href=\"javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+newsid+"')\"><font class=\"font\">"+nnewstitle+"</font></A>";
					
				}
			} 
			
			if("".equals(newstitle )) imgSymbol="";
			listShow += "<TD colspan=" + 4+ ">"+
						   "<TABLE   width='100%'>" + 
						   "<TR>" + 
						   "	<TD  rowspan=4 align=left valign=top>"+ strImg + "</TD>" +
						   "	<TD  width='100%'  valign=top>"+
							"		<table width='100%'   valign=top>"+
						   "		<tr>"+
							"			<td>"+imgSymbol+ "<font class=\"font\">"+newstitle+ "</font>"+"</td>"+
						   "		</tr>"+
						   "		<tr height=1px style='height:1px' class='sparator'>"+
							"			<td style='padding:0px'></td>"+
						   "		</tr>"+
						   "		<tr>"+
							"			<td>"+ "<font class=\"font\">"+strmemo+"</font>"+"</td>"+
						   "		</tr>";
						   
		    if(!"".equals(pubdate)||!"".equals(pubtime))	
		    	//listShow += "<tr><td>"+ "<font class=font>"+pubdate+ "&nbsp;" + pubtime+"</font>"+"</td></tr>" ;
		    	listShow += "</table></TD></TR></TABLE></TD>";
			
		}
		out.print(listShow);
	}else{
	
%>
		<TABLE width="100%">
				
					<TBODY>
						<%
							
							if(!"".equals(whereKey)&&(!"".equals(showtitle)||!"".equals(showauthor)||!"".equals(showpubdate)||!"".equals(showpubtime)))
							{
								
								for (int i = 0;i<newsitems.size();i++)
								{
									NewsItemBean newsitem = (NewsItemBean)newsitems.get(i);
									String newsid = newsitem.getNewsid();
									String newstitle = newsitem.getTitle();
									String nnewstitle=Util.getMoreStr(newstitle,Util.getIntValue(wordcount,8),"...");
									String newsauthor = newsitem.getAuthor();
									String newspubdate = newsitem.getPubDate();
									newspubdate = newspubdate.trim();
									int indexpos = newspubdate.indexOf(" ");
									String pubdate = "";
									String pubtime = "";
									if(indexpos>0)
									{
										pubdate = newspubdate.substring(0,indexpos);
										pubtime = newspubdate.substring(indexpos,newspubdate.length());
									}
									String newslink = newsitem.getLink();
									String iconImg="";
						%>
						<TR height=18>
						<%
						if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
						%>
							<TD width=8><%=imgSymbol %>&nbsp;</TD>
							<%
							if("7".equals(showtitle))
							{ 
								if("1".equals(linkmode)){
									if("".equals(newstemplateid)){
										%>
										<TD title=<%=newstitle%> width=*><%="<font class=\"font\">"+nnewstitle+"</font>" %></TD>
										<%
									}else{
										%>
										<TD title=<%=newstitle%> width=*><A href="/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid=<%=newstemplateid%>&docid=<%=newsid%>"><%="<font class=\"font\">"+nnewstitle+"</font>" %></A></TD>
										<%
									}
								}else{
									if("".equals(newstemplateid)){
										%>
										<TD title=<%=newstitle%> width=*><%="<font class=\"font\">"+nnewstitle+"</font>" %></TD>
										<%
									}else{
										%>
										<TD title=<%=newstitle%> width=*><a href="javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid=<%=newstemplateid%>&docid=<%=newsid%>')"><%="<font class=\"font\">"+nnewstitle+"</font>" %></A></TD>
										<%
									}
								} 
							}
							%>
							<%
							if("8".equals(showauthor))
							{ 
							%>
							<TD width=76><%="<font class=\"font\">"+newsauthor+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("9".equals(showpubdate))
							{ 
							%>
							<TD width=80><%="<font class=\"font\">"+pubdate+"</font>"%></TD>
							<%
							} 
							%>
							<%
							if("10".equals(showpubtime))
							{ 
							%>
							<TD width=70><%="<font class=\"font\">"+pubtime+"</font>"%></TD>
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
				<%} %>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
String userid=""+user.getUID();
BlogDao blogDao=new BlogDao();
String recordType=request.getParameter("recordType");
int visitTotal=Util.getIntValue(request.getParameter("total"),0);
int visitCurrentpage=Util.getIntValue(request.getParameter("currentpage"),0);
int visitTotalpage=visitTotal%5>0?visitTotal/5+1:visitTotal/5;
List visitorList;
if(recordType.equals("visit"))
   visitorList=blogDao.getVisitorList(userid,visitCurrentpage,5,visitTotal);
else
	visitorList=blogDao.getAccessList(userid,visitCurrentpage,5,visitTotal);
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyyÄêMMÔÂddÈÕ");
SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");
%>
<%if(visitorList.size()>0){ %>
<ul class="people-list" style="width: 100%">
	<%for(int i=0;i<visitorList.size();i++){
		Map map=(Map)visitorList.get(i);
		String visitor=(String)map.get("userid");
		String visitdate=(String)map.get("visitdate");
		visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
		String visittime=(String)map.get("visittime");
		visittime=timeFormat.format(timeFormat.parse(visittime));
	%>
	<li style="margin-right: 0px;width: 100%;height: 45px">
			<div style="float: left;">
			  <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank">
			      <img style="border: 0px;cursor: pointer;" src="<%=ResourceComInfo.getMessagerUrls(visitor)%>" width="40px">
			  </a>
			</div>
			<div style="float: left;margin-left: 5px">
			   <span class="name" style="text-align: left;height: 40px;">
			      <span style="margin-bottom:3px;text-align: left;">
			        <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank"><%=ResourceComInfo.getLastname(visitor) %></a>
			      </span>
			      <span style="color: #666;text-align: left;"><%=visitdate+" "+visittime%></span>
			   </span>
			</div>
	  </li>
	<%}%>
  </ul>
<%}%>

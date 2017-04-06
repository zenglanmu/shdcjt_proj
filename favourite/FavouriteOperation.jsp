<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="favouriteInfo" class="weaver.favourite.FavouriteInfo"
	scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	String action = Util.null2String(request.getParameter("action"));
	//System.out.println("action : "+action);
	String favouriteid = Util.null2String(request.getParameter("favouriteid"));
	String favouritename = Util.null2String(request.getParameter("favouritename"));
	String favouritedesc = Util.null2String(request.getParameter("favouritedesc"));
	String favouriteorder = Util.null2String(request.getParameter("favouriteorder"));
	favouriteInfo.setUserid("" + user.getUID());
	favouriteInfo.setFavouriteid(favouriteid);
	favouriteInfo.setFavouritename(favouritename);
	favouriteInfo.setFavouritedesc(favouritedesc);
	favouriteInfo.setFavouriteorder(favouriteorder);
	StringBuffer resultStr = new StringBuffer();
	boolean result = false;
	if ("delete".equals(action))
	{
		result = favouriteInfo.deleteFavourite();
		//resultStr.append(result);
	}
	else if("add".equals(action))
	{	
		session.removeAttribute("fav_pagename");
		session.removeAttribute("fav_uri");
		session.removeAttribute("fav_pagename");
		resultStr.append(favouriteInfo.addFavourite());
	}
	else if("edit".equals(action))
	{
		resultStr.append(favouriteInfo.editFavourite());
	}
	else if("editname".equals(action))
	{
		resultStr.append(favouriteInfo.editFavouriteName());
	}
	else
	{
		String queryResult = favouriteInfo.queryFavourites();
		resultStr.append(queryResult);
	}
	if(result){
		String queryResult = favouriteInfo.queryFavourites();
		resultStr.append(queryResult);
	}
	//System.out.println("resultStr : "+resultStr.toString());
	out.print(resultStr.toString());
%>
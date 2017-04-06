<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String pagename = Util.null2String((String)request.getParameter("fav_pagename"));
	String uri = Util.null2String((String)request.getParameter("fav_uri"));
	String querystring = Util.null2String((String)request.getParameter("fav_querystring"));
	if("".equals(pagename))
	{
		pagename = Util.null2String((String) session.getAttribute("fav_pagename"));
	}
	if("".equals(uri))
	{
		uri = Util.null2String((String) session.getAttribute("fav_uri"));
	}
	if(uri.indexOf("ManageRequestNoForm.jsp")>0)
	{
		uri = uri.replaceFirst("ManageRequestNoForm.jsp","ViewRequest.jsp");
	}
	else if(uri.indexOf("ManageRequestNoFormBill.jsp")>0)
	{
		
		uri = uri.replaceFirst("ManageRequestNoFormBill.jsp","ViewRequest.jsp");
	}
	else if(uri.indexOf("ManageRequestNoFormMode.jsp")>0)
	{
		
		uri = uri.replaceFirst("ManageRequestNoFormMode.jsp","ViewRequest.jsp");
	}
	if("".equals(querystring))
	{
		querystring = Util.null2String((String) session.getAttribute("fav_querystring"));
	}
	String getpagename = request.getParameter("currentpagename");
	String getpurl = request.getParameter("currenturl");
	
	String action = request.getParameter("action");
	if("".equals(action)||null==action)
	{
		action = "addpage";
	}
	String sysfavouriteids =Util.null2String(request.getParameter("sysfavouriteids"));
	//System.out.println("getpagename : "+getpagename);
	//System.out.println("getpurl : "+getpurl);
	String urlname = "";
	
	if (!querystring.equals(""))
	{
		querystring = Util.replaceChar(querystring, '^', '&');
		urlname = uri + "?" + querystring+"&addfavourite=1";
	}
	else
	{
		urlname = uri;
	}
	if(!"".equals(getpurl)&&null!=getpurl)
	{
		urlname = getpurl;
		if(!"".equals(getpagename)&&null!=getpagename)
		{
			pagename = getpagename;
		}
		else
		{
			pagename = "";
		}
	}
	String imageStyle = "";
	if("".equals(pagename))
	{
		imageStyle = "visible";
	}
	else
	{
		imageStyle = "hidden";
	}
	//pagename = Util.toHtml10(pagename);
	//System.out.println("pagename : "+pagename);
%>
<HTML>
	<HEAD>
		<%if(user.getLanguage()==7) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-cn-gbk.js'></script>
		<%
		}
		else if(user.getLanguage()==8) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-en-gbk.js'></script>
		<%
		}
		else if(user.getLanguage()==9) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-tw-gbk.js'></script>
		<%
		}
		%>
		<link rel="stylesheet" type="text/css"
			href="/js/extjs/resources/css/ext-all.css" />
		<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="/js/extjs/ext-all.js"></script>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
		<script type="text/javascript">
		function checkPageName()
		{
			var pagename = document.getElementById("pagename").value;
			var checkPageName = document.getElementById("checkPageNameimg");
			pagename = pagename.replace(/(^\s*)|(\s*$)/g, "");
			if(pagename=="")
			{
				checkPageName.style.visibility = "visible";
			}
			else
			{
				checkPageName.style.visibility = "hidden";
			}
		}
		</script>
		<style>
			input{
				font-family:Verdana;
    			font-size:11px;
			}
		</style>
	</HEAD>
	<BODY onload="initFavouriteDiv();">
		<SPAN id=BacoTitle style="display:none;"><%=pagename%></SPAN>
		<FORM NAME=SearchForm STYLE="margin-bottom: 0;"
			action="javascript:void(0);" method=post>
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="10" colspan="2"></td>
				</tr>
				<tr>
					<td valign="top" height="100%">
						<TABLE class=Shadow height="100%">
							<tr>
								<td valign="top">
									<table width=100% class=viewform>
									<%if(!"append".equals(action)){ %>
										<TR>
											<TD width=15%><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(22426, user.getLanguage())%></span></TD>
											<TD width=85% class=field>		
												<input name=pagename id=pagename value='' width="100%" style="width:60%" onblur="javascript:checkPageName();"><img id="checkPageNameimg" src="/images/BacoError.gif" align="absmiddle" style="visibility:<%=imageStyle %>">
											</TD>
										</TR>
										<TR style="height:2px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<TR>
											<TD width=15%><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(18178, user.getLanguage())%></span></TD>
											<TD width=85% class=field>		
												<INPUT id="importlevel" type=radio name="importlevel" checked=true value="1"><%=SystemEnv.getHtmlLabelName(154, user.getLanguage())%>
												<INPUT id="importlevel" type=radio name="importlevel" value="2"><%=SystemEnv.getHtmlLabelName(22241, user.getLanguage())%>
												<INPUT id="importlevel" type=radio name="importlevel" value="3"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%>
											</TD>
										</TR>
										<TR style="height:2px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<TR>
											<TD width=15%><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(22242, user.getLanguage())%></span></TD>
											<TD width=85% class=field>		
												<INPUT id="favouritetype" type=radio name="favouritetype" checked=true value="1"><%=SystemEnv.getHtmlLabelName(22243, user.getLanguage())%>
												<INPUT id="favouritetype" type=radio name="favouritetype" value="2"><%=SystemEnv.getHtmlLabelName(22244, user.getLanguage())%>
												<INPUT id="favouritetype" type=radio name="favouritetype" value="3"><%=SystemEnv.getHtmlLabelName(22245, user.getLanguage())%>
												<INPUT id="favouritetype" type=radio name="favouritetype" value="4"><%=SystemEnv.getHtmlLabelName(21313, user.getLanguage())%>
												<INPUT id="favouritetype" type=radio name="favouritetype" value="0"><%=SystemEnv.getHtmlLabelName(375, user.getLanguage())%>
											</TD>
										</TR>
										<TR style="height:2px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<%
										}
										%>
										<TR>
											<TD width=15%>
												<span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(22246, user.getLanguage())%></span>
											</TD>
											<TD width=85% class=field>
												<INPUT TYPE=checkbox ID=favouriteid value="-1"
														name=favouriteid title="<%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>" <%if(!"append".equals(action)){ %>checked<%} %>>
												<span>
													<%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>
													<%=SystemEnv.getHtmlLabelName(22247, user.getLanguage())%>
												</span>
											</TD>
										</tr>
										<TR style="height:2px">
											<TD class=Line colSpan=2></TD>
										</TR>
									</table>
									<div id="favouritediv" style="overflow-y:scroll;width:100%;height:380px">
										<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1">
											<TR class=Line  >
												<Th colspan="5"></Th>
											</TR>
											<TR class=DataLight></TR>
											<%
												String sql = " select * from favourite where resourceid="
														+ user.getUID() + " order by displayorder,adddate desc ";
												
												rs.executeSql(sql);
												List idsList = new ArrayList();
												List namesList = new ArrayList();
												while (rs.next())
												{
													String id = rs.getString("id");
													String name = rs.getString("favouritename");
													idsList.add(id);
													namesList.add(name);
												}
												int count = idsList.size();
												int trcount = count / 3;
												int lastcount = count % 3;
												//System.out.println("count : " + count + " -- trcount : " + trcount);
												if (trcount > 0)
												{
													for (int i = 0; i < trcount; i++)
													{
												%>
														<TR class=DataLight>
															<%
																for (int j = 0; j < 3; j++)
																{
															%>
															<td width="33%" title="<%=namesList.get(i * 3 + j)%>">
																<INPUT TYPE=checkbox name="favouriteid"
																	value="<%=idsList.get(i * 3 + j)%>">
																<img src="/images/folder.small.png">
																<input type="text" value="<%=namesList.get(i * 3 + j)%>"
																	id="favouritename" name="favouritename" readonly="true"
																	style="background-color: transparent; border: 0px; width: 50%"
																	width="50%" ondblclick="javascript:editfavourite('<%=idsList.get(i * 3 + j)%>',this);">
															</td>
															<%
																}
															%>
														</tr>
												<%
													}
												}
												%>
											<TR class=DataLight id="lastfavourite">
												<%
													if (lastcount > 0)
													{
														for (int i = 0; i < lastcount; i++)
														{
												%>
															<td width="33%" title="<%=namesList.get(trcount * 3 + i)%>">
																<INPUT TYPE=checkbox name="favouriteid"
																	value="<%=idsList.get(trcount * 3 + i)%>">
																<img src="/images/folder.small.png">
																<input type="text"
																	value="<%=namesList.get(trcount * 3 + i)%>"
																	id="favouritename" name="favouritename" readonly="true"
																	style="background-color: transparent; border: 0px; width: 50%"
																	width="50%" ondblclick="javascript:editfavourite('<%=idsList.get(trcount * 3 + i)%>',this);">
															</td>
												<%
														}
													}
												%>
											</tr>
										</TABLE>
									</div>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				
				<tr width=100%>
					<td width=100% align="center" valign="top" colspan=2>
						<BUTTON class=btn accessKey=2 id=btnclear onclick="submitData();">
							<U>S</U>-<%=SystemEnv.getHtmlLabelName(16631, user.getLanguage())%></BUTTON>
						<BUTTON class=btnReset accessKey=T id=btncancel
							onclick="javascript:window.returnValue = 0;window.parent.close();">
							<U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
					</td>
				</tr>
			</table>
			<input type="hidden" name="sysfavouriteids" value="<%=sysfavouriteids %>" id="sysfavouriteids">
			<input type="hidden" name="action" value="<%=action %>" id="action">
			<input type="hidden" name="urlname" value="<%=urlname %>" id="urlname">
		</FORM>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>

		<%
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(16631, user.getLanguage())
					+ ",javascript:submitData(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(20002, user.getLanguage())
					+ ",javascript:addfavourite(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage())
					+ ",javascript:window.parent.close(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
	</BODY>
</HTML>
<script language="javascript">
function initFavouriteDiv()
{
	var action = "<%=action %>";
	if(action == "append")
	{
		 var favouritediv = document.getElementById("favouritediv");
		 favouritediv.style.height = "450px";
	}
	var BacoTitle = jQuery("#BacoTitle");
	if(BacoTitle)
	{
		var pagename = BacoTitle.html();
		var pagenameele = document.getElementById("pagename");
		if(pagenameele)
		{
			pagenameele.value=pagename;
		}
	}
}

function submitData()
{
	var action = document.getElementById("action").value;
	var urlname = "";
	var pagename = "";
	var importlevel = "";
	var favouritetype = "";
	if(action=="addpage")
	{
		urlname = document.getElementById("urlname").value;
		
		pagename = document.getElementById("pagename").value;
		pagename = pagename.replace(/(^\s*)|(\s*$)/g, "");
		if(pagename=="")
		{
			alert(favourite.other.pagenamenull);
			document.getElementById("pagename").focus();
			return;
		}
		importlevel = document.getElementsByName("importlevel");
		favouritetype = document.getElementsByName("favouritetype");
		for(var i=0;i<importlevel.length;i++)
		{
			if(importlevel[i].checked)
			{
				importlevel =importlevel[i].getAttribute("value");
				break;
	   		}
		}
		for(var i=0;i<favouritetype.length;i++)
		{
			if(favouritetype[i].checked)
			{
				favouritetype =favouritetype[i].getAttribute("value");
				break;
	   		}
		}
	}
	
	var checkfavouriteids = document.getElementsByName("favouriteid");
	var savefavouriteid = "";
	var sysfavouriteids = document.getElementById("sysfavouriteids").value;
	if(checkfavouriteids.length>0)
	{
		for(var i=0;i<checkfavouriteids.length;i++)
		{
			if(checkfavouriteids[i].checked==true)
			{
				savefavouriteid =savefavouriteid+","+checkfavouriteids[i].getAttribute("value");
	   		}
		}
		if(savefavouriteid =="")
		{
			alert(favourite.other.selectfavourite); 
			return;
		}
		Ext.Ajax.request({
       		url: '/favourite/SysFavouriteOperation.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: action,
       		 	favouriteid: savefavouriteid,
       		 	link: urlname,
       		 	title: pagename,
       		 	importlevel: importlevel,
       		 	favouritetype:favouritetype,
       		 	sysfavouriteid:sysfavouriteids
       		},
       		success: function(response, request)
			{
				alert(favourite.other.savetopic);
				window.parent.close();
			},
       		failure: function ( result, request) 
       		{ 
				alert(favourite.other.addfailure); 
			},
       		scope: this
   		  });
	}
	window.returnValue = 1;
}
function addfavourite()
{
	var lastfavourite = document.getElementById("lastfavourite");
	var tdlist = lastfavourite.getElementsByTagName("td");
	if(tdlist.length!=3)
	{
		var newtd = document.createElement("td");
		var newcinput = document.createElement("input");
		newcinput.setAttribute("type","checkbox");
		newcinput.setAttribute("id","newcinput");
		newcinput.setAttribute("name","");
		newcinput.setAttribute("value","");
		newcinput.style.marginRight ="4px"; 
		var newimg = document.createElement("img");
		newimg.setAttribute("src","/images/folder.small.png");
		
		var newinput = document.createElement("input");
		newinput.setAttribute("type","text");
		newinput.setAttribute("id","newfavourite");
		newinput.setAttribute("name","newfavourite");
		
		newinput.onblur = Function("return savefavourite();");
		newinput.setAttribute("value",favourite.other.newfa);
		newinput.setAttribute("width","50%");
		newinput.style.width="60%";
		newinput.style.paddingLeft ="5px";
		newtd.appendChild(newcinput);
		newtd.appendChild(newimg);
		newtd.appendChild(newinput);
		lastfavourite.appendChild(newtd);
		newinput.focus(); 
	}
}
function editfavourite(favouriteid,input)
{
	input.focus();
	var oldid = input.id;
	var oldname = input.name;
	var oldvalue = input.value;
	input.readOnly = false;
	input.style.backgroundColor ="";
	input.style.border = "1px inset #00008B";
	input.style.width = "60%";
	input.id="editfavourite";
	input.name="editfavourite";
	input.ondblclick=Function("return void(0);");
	input.setAttribute("name","editfavourite");
	input.onblur =function saveFavourite()
				  {
					  	var name = input.value;
					  	name = name.replace(/(^\s*)|(\s*$)/g, "");
						if(name=="")
						{
							alert(favourite.other.fanamenull);
							input.focus(); 
							input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
							return;
						}
						else if(name==oldvalue)
						{
							input.setAttribute("id",oldid);
           					input.setAttribute("name",oldname);
           					input.style.backgroundColor = "transparent";
           					input.style.border = "0px";
           					input.style.width = "60%";
           					input.readOnly = "true";
           					input.focus(); 
           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					input.onblur = "";
           					return;
						}
						else
						{
							var oldfavourites = document.getElementsByName("favouritename");
							if(oldfavourites.length>0)
							{
								for(var i=0;i<oldfavourites.length;i++)
								{
									if(oldfavourites[i].getAttribute("value")==name&&oldfavourites[i]!=input)
									{
										alert(favourite.other.fanameexist);
										input.focus(); 
										input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
										return;
									}
								}
							}
						}
						Ext.Ajax.request({
			       		url: '/favourite/FavouriteOperation.jsp',
			       		method: 'POST',
			       		params: 
			       		{
			       		 	action: "editname",
			       		 	favouriteid:favouriteid,
			       		 	favouritename:name
			       		},
			       		success: function(response, request)
						{
			   				try
			   				{
			   					var responseArray = Ext.decode(response.responseText);
							 	if(responseArray.databody.length>0)
							 	{
		           					input.setAttribute("id",oldid);
		           					input.setAttribute("name",oldname);
		           					input.style.backgroundColor = "transparent";
		           					input.style.border = "0px";
		           					input.style.width = "60%";
		           					input.readOnly = "true";
		           					input.focus(); 
		           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
		           					input.onblur = "";
							 	}
			    				else
			    				{
			    					input.value = oldvalue;
									input.setAttribute("id",oldid);
		           					input.setAttribute("name",oldname);
		           					input.style.backgroundColor = "transparent";
		           					input.style.border = "0px";
		           					input.style.width = "60%";
		           					input.readOnly = "true";
		           					input.focus(); 
		           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
		           					input.onblur = "";
			    					alert(favourite.window.failure);
			    				}
			   				 }
			   				 catch(e)
			   				 {
			   
			   				 }
						},
			       		failure: function ( result, request) 
			       		{ 
							input.value = oldvalue;
							input.setAttribute("id",oldid);
           					input.setAttribute("name",oldname);
           					input.style.backgroundColor = "transparent";
           					input.style.border = "0px";
           					input.style.width = "60%";
           					input.readOnly = "true";
           					input.focus(); 
           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					input.onblur = "";
           					alert(favourite.window.failure); 
						},
			       		scope: this
			   		  });
				  };
}
function savefavourite()
{
	var favouritename = document.getElementById("newfavourite");
	
	var name = document.getElementById("newfavourite").value;
	name = name.replace(/(^\s*)|(\s*$)/g, "");
	if(name=="")
	{
		alert(favourite.other.fanamenull);
		favouritename.focus(); 
		return;
	}
	else
	{
		var oldfavourites = document.getElementsByName("favouritename");
		if(oldfavourites.length>0)
		{
			for(var i=0;i<oldfavourites.length;i++)
			{
				if(oldfavourites[i].getAttribute("value")==name)
				{
					alert(favourite.other.fanameexist);
					favouritename.focus(); 
					return;
				}
			}
		}
	}
	Ext.Ajax.request({
           		url: '/favourite/FavouriteOperation.jsp',
           		method: 'POST',
           		params: 
           		{
           		 	action: "add",
           		 	favouritename:name
           		},
           		success: function(response, request)
   				{
       				try
       				{
           				var result = response.responseText;
           				var responseArray = Ext.decode(response.responseText);
					 	if(responseArray.databody.length>0)
					 	{
					 		var favouriteid = responseArray.databody[0].id;
           					favouritename.onblur = "";
           					favouritename.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					var newcinput = document.getElementById("newcinput");
           					newcinput.setAttribute("id","favouriteid");
           					newcinput.setAttribute("name","favouriteid");
           					newcinput.setAttribute("value",favouriteid);
           					
           					var newinput = document.getElementById("newfavourite");
           					newinput.setAttribute("id","favouritename");
           					newinput.setAttribute("name","favouritename");
           					newinput.parentNode.title = name;
           					newinput.style.backgroundColor = "transparent";
           					newinput.style.border = "0px";
           					newinput.style.width = "60%";
           					newinput.readOnly = "true";
           					newinput.focus(); 
           					var lastfavourite = document.getElementById("lastfavourite");
							var tdlist = lastfavourite.getElementsByTagName("td");
							if(tdlist.length==3)
							{
								lastfavourite.setAttribute("id","");
								
								var BrowseTable = document.getElementById("BrowseTable");
								var newtr = BrowseTable.insertRow();
								newtr.setAttribute("id","lastfavourite");
								newtr.setAttribute("class","DataLight");
								
							}
           				}
       				 }
       				 catch(e)
       				 {
       
       				 }
   				},
           		failure: function ( result, request) 
           		{ 
   					alert(favourite.other.addfafailure); 
				},
           		scope: this
       		  });
}
</script>
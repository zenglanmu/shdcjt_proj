<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.SimpleTimeZone" %>
<%@ page import="com.simplerss.dataobject.Item" %>
<%@ page import="com.simplerss.handler.RSSHandler" %>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<%

	String eid=Util.null2String(request.getParameter("eid"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	
	int perpage=30;
	String key=hpec.getStrsqlwhere(eid);	
	if("".equals(tabid)){
		rs.execute("select * from hpNewsTabInfo where eid="+eid +" order by tabId");
		rs.next();
		tabid = rs.getString("tabId");
	}


	rs.execute("select sqlWhere from hpNewsTabInfo where eid = '"+eid+"' and tabId='"+tabid+"'");
	if(rs.next()){
		key = rs.getString("sqlWhere");
	}
	String rssReadType="";
	String[] rssSettingList = Util.TokenizerString2(key,"^,^");
	if(rssSettingList.length==4){
		rssReadType = rssSettingList[3];
		key = rssSettingList[0]+"^,^"+rssSettingList[1]+"^,^"+rssSettingList[2];
	}else{
		rssReadType = rssSettingList[2];
		key = ""+"^,^"+rssSettingList[0]+"^,^"+rssSettingList[1];
	}
	
	String rssUrl = hpes.getRssUrlStr(key,perpage);
	//LinkedList rssElementList = hpes.getRssElementList(rssUrl);  

	String imagefilename = "/images/hdReport.gif";
	String titlename = "RSS"+SystemEnv.getHtmlLabelName(260,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
    
<HTML>
<HEAD>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
<SCRIPT language="javascript" src="/js/homepage/Element.js"></SCRIPT>
<SCRIPT language="javascript" src="/js/xmlextras.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
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
			<table class="listStyle">
				<tr class=header>
					<TH width="60%">RSS<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
					<TH width="40%"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH>					
				</tr>
			</table>


			<div id="divContent"/>
			
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
</BODY>
</HTML>
<%
if("2".equals(rssReadType)){
%>
<script type="text/javascript">
	
		var languageid=readCookie("languageidweaver");
		var objDiv=document.getElementById("divContent");
		objDiv.innerHTML="<img src=/images/loading2.gif><%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
		
	
</script>
<%
	String rssContent = "";
	boolean hasTitle=true;
	String linkmode="2";
	String strStyle = "";

	try {
		Class tempClass=null;
		Method tempMethod=null;
		Constructor ct=null;
		tempClass = Class.forName("weaver.homepage.HomepageExtShow");	
		tempMethod = tempClass.getMethod("getRssElementList", new Class[]{String.class});
		ct = tempClass.getConstructor(null);
		Item[] rssElementList=(Item[])tempMethod.invoke(ct.newInstance(null), new Object[] {rssUrl});

		rssContent = "<TABLE  width=100% class=listStyle>";
		
		for (int i = 0; i <rssElementList.length; i++) {
			Item itm = (Item) rssElementList[i];
			
			if(i%2==0) 
				strStyle="datadark";
			else  
				strStyle="datalight";
			rssContent+="<TR height=18px class="+strStyle+">";	
			if(hasTitle){
				rssContent+="<TD width='60%'>";
				if(linkmode=="1"){
					rssContent+="<a href="+itm.getLink()+"' target='_self' title="+itm.getTitle()+">"+itm.getTitle()+"</a>";
				}else {
					rssContent+="<a href=javascript:openFullWindowForXtable('"+itm.getLink()+"') title="+itm.getTitle()+">"+itm.getTitle()+"</a>";
				} 
				 rssContent+="</TD>";
			}
			
			rssContent+="<TD width='40%'>"+hpu.getCurrentTime(itm.getPubDate(), "date")+"&nbsp;&nbsp;"+hpu.getCurrentTime(itm.getPubDate(), "time")+"</TD>";
							
			rssContent+="</TR>";
		}
		
		rssContent+="</TABLE>";				

	} catch (Exception e) {
           rssContent=e.toString();
	}
		%>
		<script type="text/javascript">
			objDiv.innerHTML="<%=rssContent%>";
		</script>
		<% 
 }%>
<SCRIPT LANGUAGE="JavaScript">
<!--
	

	function parsRss(objDivId,rssUrl){		
	    var objDiv=document.getElementById(objDivId);
		var languageid=readCookie("languageidweaver");
		var returnStr="";	
		var imgSymbol="";
		var hasTitle="true";
		var hasDate="true";
		var hasTime="true";
		var titleWidth="*";
		var dateWidth="90";
		var timeWidth="90";
		var rssTitleLength="40";
		var linkmode="2";
		var size="3";
		
		
		objDiv.innerHTML="<img src=/images/loading2.gif><%=SystemEnv.getHtmlLabelName(19612,user.getLanguage())%>...";
		try{
			var rssRequest = XmlHttp.create();
			rssRequest.open("GET",rssUrl, true);	
			rssRequest.onreadystatechange = function () { 
				//alert(rssRequest.readyState)
				switch (rssRequest.readyState) {
				   case 3 : 					
						break;
				   case 4 : 
					   if (rssRequest.status==200)  {

						 returnStr+= "	    <TABLE  width=\"100%\" class=\"listStyle\">";
					   
							var items=rssRequest.responseXML;
							var titles=new Array(),pubDates=new Array(); dates=new Array(), times=new Array(), linkUrls=new Array(), descriptions=new Array()	
								
							var items_count=items.getElementsByTagName('item').length;

							//if(items_count>perpage) items_count=perpage;
							//alert(items_count)

							for(var i=0; i<items_count; i++) {
								titles[i]="";
								pubDates[i]="";
								linkUrls[i]="";
								descriptions[i]="";
								dates[i]="";
								times[i]="";

								if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
									titles[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0].firstChild.nodeValue;


								if(items.getElementsByTagName('item')[i].getElementsByTagName('pubDate').length==1)
									pubDates[i]=items.getElementsByTagName('item')[i].getElementsByTagName('pubDate')[0].firstChild.nodeValue;

								if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
									linkUrls[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0].firstChild.nodeValue;

								if(i%2==0) strStyle="datadark";
								else  strStyle="datalight";
								returnStr+="<TR height=18px class="+strStyle+">";	
								
								if(hasTitle=="true"){
									 returnStr+="<TD width='60%'>";
									  if(linkmode=="1"){
										returnStr+="<a href=\""+linkUrls[i]+"\" target=\"_self\" title=\""+titles[i]+"\">"+titles[i]+"</a>";
									  } else {
									  	returnStr+="<a href=\"javascript:openFullWindowForXtable('"+linkUrls[i]+"')\" title=\""+titles[i]+"\">"+titles[i]+"</a>";
									  } 
									
									 returnStr+="</TD>";
								} 
								if(pubDates[i]!=""){
									var d = new Date(pubDates[i]);
									if(d=='NaN'){
									dates[i]="";
									times[i]="";
									}else{
										dates[i]=d.getYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;

										if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
										else times[i]+= d.getHours() + ":";

										if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
										else times[i]+= d.getMinutes() + ":";

										if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
										else times[i]+= d.getSeconds() ;
									}
								} else {
									dates[i]="";
									times[i]="";
								}								
								returnStr+="<TD width='40%'>"+dates[i]+"&nbsp;&nbsp;"+times[i]+"</TD>";
								
								returnStr+="</TR>";
						
							}
						

							returnStr+="		</TABLE>";
							objDiv.innerHTML=returnStr;
					   } else {
						   objDiv.innerHTML=rssRequest.responseText;
					   }
					   break;
				} 
			}	
			rssRequest.setRequestHeader("Content-Type","text/xml")	
			rssRequest.send(null);	
		} catch(e){      
			if(e.number==-2147024891){
				if(this.languageid==8)
					objDiv.innerHTML="RSS use client read，It need let this site's url into you IE trust list.！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(How?)</a>";
				else if(this.languageid==9)
					objDiv.innerHTML="RSS採用的是客戶端讀取，需把本站點添加到受信任站點！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(怎樣添加?)< /a>";
				else
					objDiv.innerHTML="RSS采用的是客户端读取，需把本站点添加到受信任站点！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(怎样添加?)</a>";
			}   else {
				objDiv.innerHTML=e.number+":"+e.description;
			}
		}
		
 	}
	

//-->

</SCRIPT>

<SCRIPT FOR=window EVENT=onload LANGUAGE="JavaScript"> 
 
  //window.status = "Page is loaded!";
	if("<%=rssReadType%>"=="1"){
		 parsRss("divContent","<%=rssUrl%>")   
	}
</SCRIPT>





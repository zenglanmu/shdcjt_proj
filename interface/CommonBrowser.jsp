<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD> 
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%


String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
String issearch = Util.null2String(request.getParameter("issearch"));

String bts[] = type.split("\\|");
String frombrowserid = "";
type = bts[0];
if(bts.length>1){
	frombrowserid = bts[1];
}

String userid = user.getUID()+"";
Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String outpage = Util.null2String(browser.getOutPageURL());
String href = Util.null2String(browser.getHref());
if(!outpage.equals("")){
	if(outpage.indexOf("?")>=0){
		outpage += "&browsertype="+type;
	}else{
		outpage += "?browsertype="+type;
	}
	response.sendRedirect(outpage);
	return;
}
//
String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap allField = (HashMap)session.getAttribute("allField_"+workflowid+"_"+currenttime);
ArrayList allFieldList = (ArrayList)session.getAttribute("allFieldList_"+workflowid+"_"+currenttime);
if(allField==null){
	allField = new HashMap();
}
if(allFieldList==null){
	allFieldList = new ArrayList();
}
String fieldids[] = needChangeFieldString.split(",");
HashMap valueMap = new HashMap();
for(int i=0;i<fieldids.length;i++){
	String fieldid = Util.null2String(fieldids[i]);
	if(!fieldid.equals("")){
		String fieldvalue = Util.null2String(request.getParameter(fieldid));
		//System.out.println(fieldid+"	"+fieldvalue);
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
		valueMap.put(fieldid,fieldvalue);
	}
}
if(issearch.equals("1")){
	valueMap = (HashMap)session.getAttribute("valueMap_"+workflowid+"_"+currenttime);
	if(valueMap==null){
		valueMap = new HashMap();
	}
}else{
	session.setAttribute("valueMap_"+workflowid+"_"+currenttime,valueMap);
}

String Search = browser.getSearch();//.toLowerCase();//
String SearchByName = browser.getSearchByName();//.toLowerCase();// 

for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(!fieldname.equals("")){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
		//System.out.println("hahha:=====		"+fieldname +"	@	"+fieldid+"	@	"+fieldvalue);
		Search = Search.replace(fieldname,fieldvalue);
		SearchByName = SearchByName.replace(fieldname,fieldvalue);
	}
}

List l;
if(name.equals(""))
l=browser.search(userid,Search);
else
l=browser.searchByName(userid,name,SearchByName);

int curpage = Util.getIntValue(request.getParameter("curpage"),1);//当前页
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;



%>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CommonBrowser.jsp" method=post>

<input type=hidden id='type' name='type' value="<%=type%>">
<input type=hidden id='curpage' name='curpage' value="<%=curpage%>">
<input type=hidden id='workflowid' name='workflowid' value="<%=workflowid%>">
<input type=hidden id='currenttime' name='currenttime' value="<%=currenttime%>">
<input type=hidden id='issearch' name='issearch' value="1">

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

		<table width=100% class=ViewForm>
		<TD width=15%><%=Util.null2String(browser.getNameHeader())%></TD>
		<TD width=35% class=field><input name='name' value="<%=name%>" class="InputStyle" onchange="changeCurpage(1);"></TD>
		</TR>
		<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
	
		
		</table>
		<BR>
		<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" width="100%">
		<TR class=DataHeader>
		<TH style='display:none'></TH>
		
		<TH><%=Util.null2String(browser.getNameHeader())%></TH>
		<TH><%=Util.null2String(browser.getDescriptionHeader())%></TH>
		</TR>
		<TR class=Line style="height:1px;"><TH colspan="3" ></TH></TR> 
		<%
		int perpage = 50;//每页行数
		List templist = new ArrayList();
		int sumcount = l.size();
		boolean nextpage = false;
		boolean lastpage = false;
		if(curpage*perpage<sumcount) nextpage = true;
		if(curpage>1) lastpage = true;				
		if(lastpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:onPage("+(curpage-1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(nextpage){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:onPage("+(curpage+1)+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		int start = (curpage-1) * perpage;
		int end = curpage * perpage;
		if(end>sumcount) end = sumcount;
		for(int t=start;t<end;t++){
			templist.add(l.get(t));
		}

		int i=0;
	
		Iterator iter=templist.iterator();
		while(iter.hasNext()){
            BrowserBean bean=(BrowserBean)iter.next();
			String id = bean.getId();
			String beanname = bean.getName();
			String desc=bean.getDescription();
			
			if(i==0){
				i=1;
		%>
		<TR class=DataLight>
		<%
			}else{
				i=0;
		%>
		<TR class=DataDark>
			<%
			}
			%>
			<TD style='display:none'><A HREF=# ><%=id%></A></TD>
			<TD><%=beanname%></TD>
			<TD><%=desc%></TD>		
			
		</TR>
		<%}%>

		
		</TABLE>
		
        
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

</FORM>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>


<<script type="text/javascript">
//<!--
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text(),desc:$(this).find("td:first").next().next().text(),href:'<%=href%>'};
		window.parent.close();
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected");
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected");
	});

});

//-->
</script>
<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText,e.parentelement.parentelement.cells(2).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If

End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

</SCRIPT>

 -->
<script language="javascript">
function onClear()
{
	window.parent.returnValue = {id:"",name:""};
    window.parent.close();;
}
function onSubmit()
{
	SearchForm.submit();
}
function onPage(index)
{
	changeCurpage(index);//TD34490 lv 修改当前页
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}

//TD34490 lv 修改当前页
function changeCurpage(index){
	document.SearchForm.curpage.value = index;
}



</script>
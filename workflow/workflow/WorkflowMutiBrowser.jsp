<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String check_per = Util.null2String(request.getParameter("wfids"));
ArrayList chk_per = new ArrayList();
chk_per = Util.TokenizerString(check_per,",",false);

String documentids = "" ;
String documentnames ="";

if (!check_per.equals("")) {
	String strtmp = "select id,workflowname from workflow_base where  isvalid=1 and  id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
			documentids +="," + RecordSet.getString("id");
			documentnames += ","+RecordSet.getString("workflowname");
	}
}

String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));//added by XWJ on 2005-03-16 for td:1549
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
int typeid=Util.getIntValue(request.getParameter("typeid"),0);
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(typeid!=0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  isvalid=1  and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and isvalid=1  and workflowtype = '";
		sqlwhere += typeid;
		sqlwhere += "'";
	}
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isvalid=1  and workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and isvalid=1  and  workflowname like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isvalid=1  and  workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and isvalid=1  and   workflowdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}

//added by XWJ on 2005-03-16 for td:1549
if("contract".equals(propertyOfApproveWorkFlow)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where formid = 49 and isbill = 1  and isvalid=1";
	}
	else{
	  sqlwhere += " and formid = 49 and isbill = 1 and isvalid=1";
	}
}
//out.println(sqlwhere);
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowMutiBrowser.jsp" method=post>
<div style="display:none">
<button type=button  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
</div>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">

<%--added by XWJ on 2005-03-16 for td:1549--%>
<input type=hidden name=propertyOfApproveWorkFlow value="<%=propertyOfApproveWorkFlow%>">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">



<table width=100% class="viewform">
<TR>
<TD ><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
<TD  class=field colspan=3>
<select class=inputstyle  name=typeid size=1 style="width:20%" onChange="onSubmit()">
    	  	<option value="0">&nbsp;</option>
    	  	<%
		    while(WorkTypeComInfo.next()){
		     	String checktmp = "";
		     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
		     		checktmp=" selected";
		%>
		<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		<%
		}
		%>
    	  </select>
</TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD ><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle name=fullname value="<%=fullname%>"></TD>
<TD ><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD  class=field><input class=Inputstyle  name=description value="<%=description%>"></TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<th></th>
<TH width=30% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>

<TR class=Line  style="height:1px;"><th colspan="3" ></Th></TR> 
<%
int i=0;
sqlwhere = "select * from workflow_base "+sqlwhere;

//System.out.println("sql = "+sqlwhere);
//System.out.println("sqlWhere1 = "+sqlwhere1);
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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

	<%
	 String ischecked = "";
	 if(chk_per.contains(RecordSet.getString("id"))){
		ischecked = " checked ";
	 }
	 %>
	<td style="width:50px"><input type=checkbox name="check_per" value="<%=RecordSet.getString(1)%>" <%=ischecked%>></td>
	<TD style="display:none"><A HREF=#><%=RecordSet.getString(1)%></A></TD>
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	
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

</FORM></BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var ids = "<%=documentids%>";
var names = "<%=documentnames%>";


function btnclear_onclick() {
     window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
}

function btnok_onclick() {
	window.parent.returnValue = {id: ids, name: names};//Array(documentids,documentnames)
    window.parent.close();
}


//¶àÑ¡
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   		   obj.attr("checked", false);
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")

		   	}else{
		   		    obj.attr("checked", true);
		   		ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}

		}
		//µã»÷checkbox¿ò
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   	    ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + jQuery(this).find("td:eq(2)").text();
		   	}else{
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + jQuery(this).find("td:eq(2)").text(), "")
		   	}
	    }
		
		//window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		//	window.parent.close()
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});


</SCRIPT>

 <script language="javascript">

 function onSubmit() {
		$G("SearchForm").submit()
	}
	function onReset() {
		$G("SearchForm").reset()
	}
 
function submitData()
{
	btnok_onclick();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
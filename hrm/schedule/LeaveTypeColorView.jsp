<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(21609,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String companyid = Util.null2String(request.getParameter("companyid"));
if(companyid.equals("0")) subcompanyid = companyid;
String showname = "";
if(!subcompanyid.equals("0")) showname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
else showname = CompanyComInfo.getCompanyname("1");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("LeaveTypeColor:All",user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+SystemEnv.getHtmlLabelName(495,user.getLanguage())+",javascript:ondelete(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21671 , user.getLanguage())+",javascript:onSyn(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
	<td valign="top">
<TABLE class=Shadow>
	<tr>
	<td valign="top">
<table class=Viewform>
  <COLGROUP><COL width="18%"><COL width="82%">
      <TBODY>
      <TR class=Title colspan=5>
        <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
        <TD class=Line1 colspan=3></TD>
      </TR>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></TD>
        <TD class=field>
          <SPAN><%=showname%></SPAN>          
        </TD>              
      </TR>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     </TBODY>
</table>
<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="5%">
  <COL width="25%">
  <COL width="25%">

  <TBODY>
  <TR class=Header align=left>
    <TH><input type=checkbox name=checkbox value="" onclick="checkall(this)"></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></TH>
  </TR>

<%
    String leavetypeid = "";
    String otherleavetypeid = "";
    String sql = "select * from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType') ";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
      if(RecordSet.getString("fieldname").toLowerCase().equals("leavetype")) leavetypeid = RecordSet.getString("id");
      if(RecordSet.getString("fieldname").toLowerCase().equals("otherleavetype")) otherleavetypeid = RecordSet.getString("id");
    }

	sql = "select fieldid,selectvalue,selectname,a.id,b.id as colorid,itemid,color,subcompanyid from (select fieldid,selectvalue,selectname,id from workflow_SelectItem where isbill=1 and fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) ) a left join hrmleavetypecolor b on a.id = b.itemid and subcompanyid = " + subcompanyid + " order by fieldid asc,selectvalue asc";
	RecordSet.executeSql(sql);
	
	int i = 0 ;
	while(RecordSet.next()){
		String selectname =RecordSet.getString("selectname");
		String color=Util.null2String(RecordSet.getString("color"));
		String id = Util.null2String(RecordSet.getString("colorid"));
		if(RecordSet.getString("fieldid").equals(leavetypeid)&&RecordSet.getString("selectvalue").equals("4")) continue;
        if(color.equals("")) color = "#FF0000";
				
if(i==0) {
		i=1 ; 
%>
<TR class=DataLight>
<%
	}else{
		i=0 ; 
%>
<TR class=DataDark>
<%
}
%>
    <TD><input type="checkbox" id="periodbox" name="periodbox" value="<%=id%>"></TD>
    <TD><%=selectname%></A></TD>
    <TD><span style="width:16px;height:8px;display:inline-block;background:<%=color%>"></span></TD>   
    </TR>
<%}%>
</TBODY></TABLE>
    
</td>
</tr>
	</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="4"></td>
</tr>
</table>
</BODY>
<script language="javascript">
function onEdit(){
   location = "LeaveTypeColorEdit.jsp?subcompanyid=<%=subcompanyid%>";
}
function onSyn(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   var flag = false;
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) {
         if(v[i].value!="") ids = ids + v[i].value + ",";
         flag = true;
      }   
   }
   if(ids=="" && !flag){
      alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
      return false;
   }else{
     if(ids=="" && flag) ids = "-1,";
     if(confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>")){
       location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=syn&subcompanyid=<%=subcompanyid%>&ids="+ids;       
     }   
  }
}
function checkall(obj){
   var v = document.getElementsByName("periodbox");
   for(var i=0;i<v.length;i++){
      v[i].checked = obj.checked;
   }
}
function ondelete(){
   var v = document.getElementsByName("periodbox");
   var ids = "";
   var flag = false;
   for(var i=0;i<v.length;i++){
      if(v[i].checked == true) {
         if(v[i].value!="") ids = ids + v[i].value + ",";
         flag = true;
      }
   }
   if(ids=="" && !flag){
      alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
      return false;
   }else{
    if(ids=="" && flag) ids = "-1,";
    if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>")){
       if(confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>")){   
          location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=syndelete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }else{
          location.href="/hrm/schedule/LeaveTypeColorOperation.jsp?operation=delete&subcompanyid=<%=subcompanyid%>&ids="+ids;       
       }
    }
   }  
}
</script>
</HTML>
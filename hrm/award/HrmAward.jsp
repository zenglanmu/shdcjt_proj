<%@ page import="weaver.general.Util,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetid" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add" , user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(6100,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<% 
String departmentid = Util.null2String(request.getParameter("departmentid"));//部门
String resourceid = Util.null2String(request.getParameter("resourceid"));//惩罚人员的id
String rptypeid = Util.null2String(request.getParameter("rptypeid"));//惩罚种类id
String rpdate = Util.null2String(request.getParameter("rpdate"));//起始日期
String torpdate = Util.null2String(request.getParameter("torpdate"));//结束日期
%>
<%
   String fromSql="from HrmAwardInfo t1";
   String sqlWhere="";
   String str="";
   String hid="";
   int flag=0;
   RecordSet.executeSql("select  id, resourseid from HrmAwardInfo ");

   if(!resourceid.equals("")){//惩罚人员id不为空
           
 while(RecordSet.next()){
   str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmAwardInfo where "+ resourceid+"  in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	  }
  }
   sqlWhere=sqlWhere+"t1.id in("+hid+")";
   flag=1;
   }
   
   if(!rptypeid.equals("")){//惩罚种类id不为空
      if(flag==1){
	      sqlWhere=sqlWhere+" and rptypeid="+rptypeid;	  
	  }
      else{
	      sqlWhere=sqlWhere+" rptypeid="+rptypeid;
	       flag=1;
	  }
   }

if(!rpdate.equals("")) {//起始日期不为空
    if(flag==1){
	 sqlWhere=sqlWhere+" and rpdate >='"+rpdate+"'";
	}
	else{
	sqlWhere=sqlWhere+" rpdate >='"+rpdate+"'";
	flag=1;
	}
}

if(!torpdate.equals("")){//结束日期不为空
if(flag==1){
   sqlWhere=sqlWhere+" and rpdate<='"+torpdate+"'";
}
else{
   sqlWhere=sqlWhere+" rpdate<='"+torpdate+"'";
   flag=1;
 }
}
if(!departmentid.equals("")){
	RecordSet.executeSql("select  id, resourseid from HrmAwardInfo ");
	hid="";
if(flag==1){
     while(RecordSet.next()){
     str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmResource where departmentid="+departmentid +" and  id in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	}
}

sqlWhere=sqlWhere+"and t1.id in ("+hid+")";
}
else{
    while(RecordSet.next()){
     str=RecordSet.getString("resourseid");
	 RecordSetid.executeSql("select id from HrmResource where departmentid="+departmentid +" and  id in ("+str+")");
		while(RecordSetid.next()){
	       	  if(hid=="")
			          hid=hid+RecordSet.getInt("id");
	         else
				      hid=hid+","+RecordSet.getInt("id");
	}
}
   sqlWhere="t1.id in ("+hid+")";
}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:ResetCondition(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/award/HrmAwardAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=93,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmAward.jsp" method=post>
<table width=100% class=viewform>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15664,user.getLanguage())%></TD>
<TD class=Field> 
    <input class=wuiBrowser type=hidden name=resourceid id=resourceid value="<%=resourceid%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>">
    </TD>    
  <TD width=15%><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></TD>
   <td class=Field> 
    <input class=wuiBrowser type=hidden name=rptypeid id=rptypeid  value="<%=rptypeid%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp"
    _displayText="<%=Util.toScreen(AwardComInfo.getAwardName(rptypeid),user.getLanguage())%>">
  </td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
<TD width=35% class=field>
          <input class=wuiDate type="hidden" name="rpdate" id="rpdate" value="<%=rpdate%>">
          --&nbsp;&nbsp;
          <input class=wuiDate type="hidden" name="torpdate" id="torpdate" value="<%=torpdate%>">
        </td>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD class=Field >               
              <input class=wuiBrowser id=departmentid type=hidden name=departmentid value="<%=departmentid%>"
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
              _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>">
      </TD>

</tr>
<TR class=Spacing  style="height:1px"><TD class=Line colspan=6></TD></TR>
</table>

<table width="100%">
<tr>
<td valign="top">
<%
   String tableString="";
   int perpage=10;
   String backfields ="t1.id,t1.rptitle,t1.resourseid,t1.rptypeid,t1.rpdate,t1.rpexplain,t1.rptransact";
   tableString="<table tabletype=\"none\"  pagesize=\""+perpage+"\">"+"<sql  backfields=\""+backfields+"\"   sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlprimarykey=\"t1.id\"  sqlsortway=\"Desc\"  sqlisdistinct=\"true\" />"+
   "<head>"+ "<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(229, user.getLanguage())+"\"   column=\"rptitle\" orderkey=\"t1.rptitle\"   href=\"/hrm/award/HrmAwardEdit.jsp\"  linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_self\" />" +
    "<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15664, user.getLanguage())+"\"   column=\"resourseid\" orderkey=\"t1.resourseid\"    transmethod=\"weaver.splitepage.transform.SptmForHR.getResourName\"  />" +
	"<col  width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(716, user.getLanguage())+"\"   column=\"rptypeid\" orderkey=\"t1.rptypeid\"  transmethod=\"weaver.splitepage.transform.SptmForHR.getPunishType\"  />" +
	"<col  width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(97, user.getLanguage())+"\"   column=\"rpdate\" orderkey=\"t1.rpdate\" />" +
	"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(85, user.getLanguage())+"\"   column=\"rpexplain\" orderkey=\"t1.rpexplain\" />" +
	"<col  width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15432, user.getLanguage())+"\"   column=\"rptransact\" orderkey=\"t1.rptransact\" />" +
   "</head>"+
   "</table>";
    
  %>
<wea:SplitPageTag tableString="<%=tableString%>" mode="run"/>
</td>
</tr>
</table>

</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 SearchForm.submit();
}
function ResetCondition(){
	window.location='/hrm/award/HrmAward.jsp';
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT LANGUAGE=VBS>
  sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowAwardTypeID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	    spanname.innerHtml = id(1)
	    inputname.value=id(0)
	else
	    spanname.innerHtml = ""
	    inputname.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
</HTML>
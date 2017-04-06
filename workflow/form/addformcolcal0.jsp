<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
%>
</head>

<%
	String formname="";
	String formdes="";
	String createtype = Util.null2String(request.getParameter("createtype")) ;	
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int subCompanyId2 = -1;
    int subCompanyId= -1;
	if(formid!=0)
		RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","£¼").replaceAll(">","£¾").replaceAll("'","''");
		formdes = formdes.replaceAll("<","£¼").replaceAll(">","£¾").replaceAll("'","''");
	  subCompanyId = RecordSet.getInt("subcompanyid");
	  subCompanyId2 = subCompanyId;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}


    String colcalstr = "";
    String maincalstr = "";
    ArrayList mainid = new ArrayList();
    ArrayList mainlable = new ArrayList();
    String sql = "select * from workflow_formdetailinfo where formid ="+formid;
    if(formid!=0) RecordSet.executeSql(sql);
    if(RecordSet.next()){
        colcalstr = RecordSet.getString("colcalstr");
        maincalstr = RecordSet.getString("maincalstr");
    }

    sql = "select * from workflow_billfield where viewtype=0 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by id";
    if(formid!=0) RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainid.add(RecordSet.getString("id"));
        mainlable.add(SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage()));
    }

    sql = "select * from workflow_billfield where viewtype=1 and fieldhtmltype=1 and (type=2 or type=3 or type=4 or type=5) and billid="+formid+" order by detailtable, dsporder, id";
    if(formid!=0) RecordSet.executeSql(sql);

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int operatelevel=0;

    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }

%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6074,user.getLanguage())+"¡¢"+SystemEnv.getHtmlLabelName(18369,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
%>
<script language="JavaScript">


</script>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>

<%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveRole(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:colsaveRole(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;

if(!ajax.equals("1")){
if(createtype.equals("2")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",FormDesignMain.jsp?src=editform&formid="+formid+",_self}" ;
}
else {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
}

RCMenuHeight += RCMenuHeightStep ;
}
}
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>

<form name="colcalfrm" method="post" action="/workflow/form/formrole_operation0.jsp" >
<input type="hidden" value="colcalrole" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=createtype%>" name="createtype">
<input type=hidden name="ajax" value="<%=ajax%>">
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



<table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
   <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formname,user.getLanguage())%><strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR> <strong></strong>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formdes,user.getLanguage())%></strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
</table>
<br>

<table class="viewform">
  <COLGROUP>
   <COL width="10%">
   <COL width="45%">
   <COL width="45%">
  <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(579,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=3></TD></TR>
  <tr class=header>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18745,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18746,user.getLanguage())%></td>
  </tr>
      <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=3></TD></TR>
<%
    while(RecordSet.next()){
%>
  <tr class=header>
    <td align=center class=field>
        <input type="checkbox" name="sumcol" value="<%=RecordSet.getString("id")%>" <%=(colcalstr.indexOf("detailfield_"+RecordSet.getString("id"))==-1?"":"checked")%>>
    </td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage())%></td>
    <td align=center class=field>
    <input type="hidden" name="detailfield" value="<%=RecordSet.getString("id")%>">
    <select name="mainfield" style="width:100">
    <option value="">
    <%
        for(int i=0; i<mainid.size();i++){
    %>
        <option value="<%=mainid.get(i)%>" <%=(maincalstr.indexOf("mainfield_"+mainid.get(i)+"=detailfield_"+RecordSet.getString("id"))==-1?"":"selected")%>><%=mainlable.get(i)%>
    <%
        }
    %>
    </select>
    </td>
  </tr>
<%
    }
%>

</table>

<br>
</form>

</center>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function saveRole(){
    colcalfrm.submit();
}
</script>
<%}%>
</body>
</html>
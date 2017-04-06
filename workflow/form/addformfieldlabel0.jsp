<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<%FormFieldlabelMainManager.resetParameter();%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
	String formname="";
	String formdes="";
	int formid=0;
    int subCompanyId2 = -1;
    int subCompanyId= -1;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	
	RecordSet.executeSql("select * from workflow_bill where id="+formid);
	if(RecordSet.next()){
		formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
		formdes = RecordSet.getString("formdes");
		formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
		formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  subCompanyId2 = RecordSet.getInt("subcompanyid");
	  subCompanyId = subCompanyId2;
		formdes = Util.StringReplace(formdes,"\n","<br>");
	}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(176,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

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
    
    ArrayList fieldids = new ArrayList();
    ArrayList fieldnames = new ArrayList();
    ArrayList fieldlables = new ArrayList();
    ArrayList fieldlablenames = new ArrayList();
    ArrayList fieldlablenamesE = new ArrayList();
    ArrayList fieldlablenamesT = new ArrayList();
    ArrayList viewtypes = new ArrayList();
    if(formid!=0)
    	RecordSet.executeSql("select id,fieldname,fieldlabel,viewtype from workflow_billfield where billid="+formid+" order by viewtype,detailtable,dsporder");
  	while(RecordSet.next()){//取得表单的所有字段及字段显示名
    	int tempFieldLableId = RecordSet.getInt("fieldlabel");
    	fieldids.add(RecordSet.getString("id"));
    	fieldnames.add(RecordSet.getString("fieldname"));
    	fieldlables.add(""+tempFieldLableId);
    	fieldlablenames.add(SystemEnv.getHtmlLabelName(tempFieldLableId,7));
    	fieldlablenamesE.add(SystemEnv.getHtmlLabelName(tempFieldLableId,8));
    	fieldlablenamesT.add(SystemEnv.getHtmlLabelName(tempFieldLableId,9));
    	viewtypes.add(RecordSet.getString("viewtype"));
    }
%>
<script>
rowindex = 0;
</script>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>


<%
if(operatelevel>0){
%>
	  <%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall0(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>

<%
if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addform.jsp?src=editform&formid="+formid+",_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="editfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="" name="changefieldids">
<input type="hidden" value="" name="checkitems">

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
  </tr>
  <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formdes,user.getLanguage())%></strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD  class="Line1" colSpan=2></TD></TR>
</table>
<br>
<%
if(fieldids.size()==0){
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(15454,user.getLanguage())%></font></DIV>
</form>
<script>
function selectall(){
	window.document.fieldlabelfrm.submit();
}
</script>
</body>
</html>
<%
	return;
}
%>
<table cols=4 id="oTable" class=liststyle cellspacing=1   width="100%">
  <COLGROUP>
  <COL width="10%">
  <COL width="30%">
  <COL width="30%">
 
  <%if(GCONST.getZHTWLANGUAGE()==1){ %>
  <COL width="30%">
  <%} %>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</th>
  <th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)</th>
  <%if(GCONST.getZHTWLANGUAGE()==1){ %>
  <th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename("9")%>)</th>
  <%} %>
  </tr>
  <tr class=Line style="height: 1px"><th></th><th></th><th ></th></tr>
<!--  
  <tr class=header>
		<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
		<td>
			<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(English)
		</td>
	</tr>
-->
<%
int colorcount1 = 1;

for(int tmpcount=0; tmpcount< fieldids.size(); tmpcount++){
	String id = (String)fieldids.get(tmpcount);
	String fieldname = (String)fieldnames.get(tmpcount);
	String fieldlablename = (String)fieldlablenames.get(tmpcount);
	String fieldlablenameE = Util.null2String((String)fieldlablenamesE.get(tmpcount));
	String fieldlablenameT = Util.null2String((String)fieldlablenamesT.get(tmpcount));
	String viewtype = (String)viewtypes.get(tmpcount);

if(colorcount1==0){
		colorcount1=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount1=0;
%>
<TR class=DataDark>
	<%
	}
%>

<td>
	<%=fieldname%>       
	<%if(viewtype.equals("1")){%>
  <%="["+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+"]"%>
  <%}%>
 </td>
<td>
	<input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_CN" value="<%=fieldlablename%>" onchange="checkinput('field_<%=id%>_CN','field_<%=id%>_CN_span');setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"><span id=field_<%=id%>_CN_span></span>
</td>
<td><input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_En" value="<%=fieldlablenameE%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
<%if(GCONST.getZHTWLANGUAGE()==1){ %>
  <td>
	<input type="text" class=inputstyle style="width:95%;" name="field_<%=id%>_TW" value="<%=fieldlablenameT%>" onchange="setChange(<%=id%>)" maxlength="255" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>255(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
<%} %>
</tr>
<%
}
%>
</table>

</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
</form>
</body>

</html>
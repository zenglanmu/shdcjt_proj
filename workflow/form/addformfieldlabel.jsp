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
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);

	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	int fieldsum = 0;
	ArrayList langids=new ArrayList();
	ArrayList fields=new ArrayList();
	ArrayList detailfields=new ArrayList();
	ArrayList isdetails=new ArrayList();
	langids.clear();
	fields.clear();
	isdetails.clear();
	String insertlabels="";
	String haslabelslang = "";

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(176,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        subCompanyId=Util.getIntValue(String.valueOf(FormManager.getSubCompanyId2()),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
FormFieldMainManager.setFormid(formid);
FormFieldMainManager.selectAllFormField();
while(FormFieldMainManager.next()){
	fieldsum+=1;
	int curid=FormFieldMainManager.getFieldid();
	fields.add(""+curid);
	isdetails.add(FormFieldMainManager.getIsdetail());
}

FormFieldMainManager.selectAllDetailFormField();
while(FormFieldMainManager.next()){
	int curid=FormFieldMainManager.getFieldid();
	detailfields.add(""+curid);
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldlablesall(),_self}" ;
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

	  <%
if(operatelevel>0){
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:fieldlabeladdRow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitClear(),_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:fieldlabeldelRow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form name="fieldlabelfrm" id=fieldlabelfrm method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="formfieldlabel" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="" name="formfieldlabels">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=fields.size()%>" name="fieldSize">

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
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formname,user.getLanguage())%><strong></td>
  </tr>
  <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formdes,user.getLanguage())%></strong></td>
  </tr><TR class="Spacing">
    	  <TD  class="Line1" colSpan=2></TD></TR>
</table>
<br>
<%
if(fields.size()==0){
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
<table class="viewform">
  <COLGROUP>
   <COL width="20%">
   <COL width="20%">
   <COL width="20%">
   <COL width="60%">
  <TR class="Title">
    	<TH colSpan=><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TH>
  	<td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%><button type="button" class=browser onClick="showlanguage()"></button><span id=languagespan></span>
  		<input type=hidden name="languageList"></td>
	<td>
	</td>
	<td>

</td>
  </TR>

</table>
<%
int colnum =1;
int rownum = fieldsum+1;
FormFieldlabelMainManager.setFormid(formid);
//FormFieldlabelMainManager.setFieldid(tmpfieldid);
FormFieldlabelMainManager.selectLanguage();


%>

<table cols=<%=colnum%> id="oTable" class=liststyle cellspacing=1   width="100%">
  <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
             <%--<td><%=SystemEnv.getHtmlLabelName(15455,user.getLanguage())%></td>--%>
<%
while(FormFieldlabelMainManager.next()){
	int curid=FormFieldlabelMainManager.getLanguageid();
	langids.add(""+curid);
	haslabelslang += curid;
	haslabelslang += ",";
%>
<td><input type='checkbox' name='check_lang' value=<%=curid%>><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>(<%=LanguageComInfo.getLanguagename(""+curid)%>)</td>

<%--<td><input type="radio" name="isdefault" value="<%=curid%>" <%if(FormFieldlabelMainManager.getIsdefault().equals("1")){%>checked<%}%>></td>--%>
<%}%>

 </tr>
<%
int tmpnum = 1;
int colorcount1 = 1;



for(int tmpcount=0; tmpcount< fields.size(); tmpcount++) {
	String curid=(String)fields.get(tmpcount);
	int i=tmpcount+1;
	String isdetailtemp=(String)isdetails.get(tmpcount);
	insertlabels += "oRow = oTable.rows["+i+"];";
	insertlabels += "oCell = oRow.insertCell(-1);";
	insertlabels += "var oDiv = document.createElement('div');var sHtml = '<input type=input class=inputstyle name=label_'+oOption.value+'_";
	//TD10752
	//insertlabels += curid+" size=10 >';";
	insertlabels += curid;
	//TD9084
    //insertlabels += " onKeyup=\\'javascript:setMaxLenByByte_keyup(this, 100)\\' onpaste=\\'javascript:setMaxLenByByte_paste(this, 100)\\'";
	insertlabels += " maxlength=\\'100\\' onblur=\\'javascript:checkMaxLength(this)\\'";
	insertlabels += " alt=\\'"+ SystemEnv.getHtmlLabelName(20246,user.getLanguage()) + "100(" + SystemEnv.getHtmlLabelName(20247,user.getLanguage())+")\\'";
    insertlabels += " style=width:99%; >';";
	insertlabels += "oDiv.innerHTML = sHtml;oCell.appendChild(oDiv);";

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
	       
 <%if(detailfields.indexOf(""+curid)==-1){%>
  <%=FieldComInfo.getFieldname(curid)%><%if(!FieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+FieldComInfo.getFieldDesc(curid)+"]"%><%}%>
  <%}else{
  if(!"1".equals(isdetailtemp)){%>
   <%=FieldComInfo.getFieldname(curid)%><%if(!FieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+FieldComInfo.getFieldDesc(curid)+"]"%><%}%>
  <%}else{%>
  <%="["+DetailFieldComInfo.getFieldname(curid)+"]"%><%if(!DetailFieldComInfo.getFieldDesc(curid).trim().equals("")){%><%="["+DetailFieldComInfo.getFieldDesc(curid)+"]"%><%}%>
  <%}
  }%>
 </td>

<%
int colorcount = 1;
for (int tmpcount1=0;tmpcount1<langids.size();tmpcount1++)
	{
	String curidlanguage=(String)langids.get(tmpcount1);
	FormFieldlabelMainManager.resetParameter();



%>



<%
tmpnum = 1;

	String tfieldid=(String)curid;
	FormFieldlabelMainManager.resetParameter();
	FormFieldlabelMainManager.setFormid(formid);
	FormFieldlabelMainManager.setFieldid(Util.getIntValue(tfieldid,0));
	FormFieldlabelMainManager.setLanguageid(Util.getIntValue(curidlanguage,0));
	FormFieldlabelMainManager.selectSingleFormField();
%>


<td><input type="text" class=inputstyle style="width:99%;" name="label_<%=curidlanguage%>_<%=tfieldid%>" value="<%=FormFieldlabelMainManager.getFieldlabel()%>" maxlength="100" onblur="checkMaxLength(this)" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>100(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></td>
<%}%>
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
<tr>
	<td height="10" colspan="3">
    <input type="hidden" value="<%=rownum%>" name="rownum">
    <input type="hidden" value="<%=insertlabels%>" name="insertlabels"> 
    <input type="hidden" value="<%=haslabelslang%>" name="selectlangids">
</td>
</tr>
</table>

</form>
<%
if(!ajax.equals("1")){
%>
<script language="JavaScript" src="/js/addRowBg.js" ></script>
<script>
var selectlangids = document.fieldlabelfrm.selectlangids.value;
var rowColor="" ;
function addRow()
{	rowColor = getRowBg();
	ncol = oTable.cols;
	var oOption=document.fieldlabelfrm.languageList;
	if(oOption.value==''){
		alert("<%=SystemEnv.getHtmlLabelName(15457,user.getLanguage())%>！");
		return;
	}
	if(selectlangids.indexOf(oOption.value)!=-1){
		alert("<%=SystemEnv.getHtmlLabelName(15458,user.getLanguage())%>!");
		return;
	}
	oRow = oTable.rows[0];          		//在table中第一行,返回行的id
	oCell = oRow.insertCell();
	//oCell.style.background= rowColor;
	//oCell.style.height=23;
	var oDiv = document.createElement("div");
	var sHtml = "<input type='checkbox' name='check_lang' value='" + oOption.value +"'>";
//	oDiv.innerHTML = sHtml;    //内嵌html语句
//	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容

//	oCell = oRow.insertCell();
//	oCell.style.background= "#D2D1F1";
//	oCell.style.height=23;
//	var oDiv = document.createElement("div");
	sHtml += "<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%>("+ languagespan.innerHTML +")";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容


	<%--oCell = oRow.insertCell();--%>
	<%--oCell.style.background= rowColor;--%>
	<%--oCell.style.height=23;--%>
	<%--var oDiv = document.createElement("div"); //在document中创建一个元素,参数表示这个元素的tagname--%>
	<%--var sHtml = "<input type='radio' name='isdefault' value='" + oOption.value+"'>"; // add value--%>
	<%--oDiv.innerHTML = sHtml;    //内嵌html语句--%>
	<%--oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容--%>
    <%--alert(oOption.value);--%>
    <%--alert("<%=insertlabels%>");--%>
	<%=insertlabels%>

	rowindex +=<%=rownum%>;
	selectlangids += oOption.value;
	selectlangids += ",";
//	document.fieldlabelfrm.languageList.options[document.fieldlabelfrm.languageList.selectedIndex].disabled  = true;
}

function deleteRow1()
{



	len = document.fieldlabelfrm.elements.length;
	var i=0;
	var temps="";
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.fieldlabelfrm.elements[i].name=='check_lang'){
			if(document.fieldlabelfrm.elements[i].checked==true) {
//				if(document.fieldlabelfrm.elements[i].value!='0')
//					delids +=","+ document.fieldlabelfrm.elements[i].value;
				var tmp = document.fieldlabelfrm.elements[i].value + ',';
				if (temps!="")
				temps= temps+","+document.fieldlabelfrm.elements[i].value;
				else
				temps= document.fieldlabelfrm.elements[i].value;

				selectlangids=selectlangids.replace(tmp, '');
				//alert(selectlangids+" "+tmp+" "+selectlangids);
				
			}
			rowsum1 -=1;
		}
	}
if (temps!="")
	{
	temparray=temps.split(",");
	for (l=0;l<temparray.length;l++)
	{
	var m=0;
	var tempss=temparray[l];
    if(oTable.rows(0).cells.length>1)
	{
	for (k=0;k<oTable.rows(0).cells.length;k++)
		{
	     if (oTable.rows(0).cells(k).innerHTML.indexOf(tempss)>0&&oTable.rows(0).cells(k).innerHTML.indexOf("checkbox")>0)
			{
		      m=k;
		    }
	    }
	}
	for(j=0;j<oTable.rows.length;j++)
		{
			if(oTable.rows(j).cells.length>1)
			{ 
				oTable.rows(j).deleteCell(m);
			}
		}
	}
	}
    document.fieldlabelfrm.selectlangids.value=selectlangids;
	
}

function selectall(){
	
	window.document.fieldlabelfrm.formfieldlabels.value=selectlangids;
	window.document.fieldlabelfrm.submit();
}
</script>
<script language="javascript">
function submitData()
{
	if (checksubmit())
		fieldlabelfrm.submit();
}

function submitClear()
{
	if (isdel())
		deleteRow1();
}

</script>

<script language="javascript">
function showlanguage() {
	var id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != 0) {
			$G("languagespan").innerHTML = rname;
			$G("languageList").value = rid;
		} else {
			$G("languagespan").innerHTML = "";
			$G("languageList").value = "";
		}
	}
}
</script>
<!-- 
<script language=vbs>
sub showlanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	languagespan.innerHtml = id(1)
	document.fieldlabelfrm.languageList.value=id(0)
	else
	languagespan.innerHtml = ""
	document.fieldlabelfrm.languageList.value=""
	end if
	end if
end sub
</script>
 -->
<%}%>
</body>

</html>
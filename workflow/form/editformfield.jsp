<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<style type="text/css">
TH.efftfth {
	width:30px!important;
}
</style>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    if(!ajax.equals("1")){
			%>
			<script language=javascript src="/js/weaver.js"></script>
			<%
    }
%>

</head>
<%

	String type="";
	String formname="";
	String formdes="";
	String tablename="";
	int formid=0;
    int subCompanyId2 = -1;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

RecordSet.executeSql("select * from workflow_bill where id="+formid);
if(RecordSet.next()){
	tablename = RecordSet.getString("tablename");
	formname = SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage());
	formdes = RecordSet.getString("formdes");
	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	subCompanyId = RecordSet.getInt("subcompanyid");
	subCompanyId2 = subCompanyId;
	formdes = Util.StringReplace(formdes,"\n","<br>");
}
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

    subCompanyId2 = subCompanyId;

boolean canDelete = true;
String sql_tmp = "";
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
	sql_tmp = "select * from "+tablename+" where rownum<2";
}else{
	sql_tmp = "select top 1 * from "+tablename;
}
RecordSet.executeSql(sql_tmp);//如果表单已使用，则表单字段不能删除
if(RecordSet.next()) canDelete = false;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1")){
	needfav ="1";
}
String needhelp ="";
titlename+=SystemEnv.getHtmlLabelName(261,user.getLanguage());

String paramessage=Util.null2String(request.getParameter("message"));
if(paramessage.equals("nodelete")) paramessage = SystemEnv.getHtmlLabelName(22410,user.getLanguage());
if(paramessage.equals("nodeleteForSubWf")) paramessage = SystemEnv.getHtmlLabelName(24311,user.getLanguage());

%>  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>
<form name="editformfieldtab" method="post" action="/workflow/form/form_operation.jsp" >
<input type="hidden" value="listDelete" name="src">
<input type="hidden" value="" name="deleteids">
<input type="hidden" value="<%=formid%>" name="formid">
<%
    if(operatelevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",/workflow/field/addfield0.jsp?formid="+formid+",_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage())+",/workflow/form/addfieldbatch.jsp?formid="+formid+",_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/workflow/form/editfieldbatch.jsp?formid="+formid+",_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    //if(canDelete){
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteData(),_self}" ;
		    RCMenuHeight += RCMenuHeightStep ;
	    //}
    }
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
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
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;<font color="red"><%=paramessage%></font></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field>
    	<%=Util.toScreen(formname,user.getLanguage())%>
    </td>
  </tr><TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

    <%if(detachable==1){%>  
        <tr>
            <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
            <td colspan=5 class=field >
                <%if(operatelevel>0){%>
                    <BUTTON type='button' class=Browser id=SelectSubCompany onclick="adfonShowSubcompany()"></BUTTON>
                <%}%>
                <SPAN id=subcompanyspan1 name=subcompanyspan1> 
                    <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
                    <%if(String.valueOf(subCompanyId2).equals("")){%>
                        <IMG src="/images/BacoError.gif" align=absMiddle>
                    <%}%>
                </SPAN>
                <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
            </td>
        </tr>
        <tr class="Spacing" style="height: 1px"><td colspan=2 class="Line"></td></tr>
    <%}%>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field>
    	<%=Util.toScreen(formdes,user.getLanguage())%>
    </td>
  </tr><TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
  	<tr>
					<TD valign="top" colSpan=2>					
					<%
					String backfields = " id,fieldname,fieldlabel,viewtype,fieldhtmltype,type,dsporder,detailtable ";
					String sqlFrom = " workflow_billfield ";
					String sqlWhere = " where billid="+formid+" ";
					if(formid==0) sqlWhere =  " where 1=2";
					String orderby  = " viewtype,detailtable,dsporder ";
					String tabletype = "checkbox";
					//if(canDelete) tabletype = "checkbox";
					String tableString=""+
					    "<table pagesize=\"10\" tabletype=\""+tabletype+"\">"+
					    " <checkboxpopedom    popedompara=\"column:fieldname+column:viewtype+column:fieldhtmltype+column:detailtable+"+formid+"\" showmethod=\"weaver.general.FormFieldTransMethod.getCanCheckBox\" />"+
					    "<sql backfields=\"" + backfields + "\" sqlisdistinct=\"true\" sqlform=\"" + sqlFrom + "\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					    "<head>"+
					    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\" orderkey=\"fieldname\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldDetail\" otherpara=\"column:id\" />"+
					    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\" orderkey=\"fieldlabel\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldname\" otherpara=\""+user.getLanguage()+"\" />"+
					    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"viewtype\" orderkey=\"viewtype\" transmethod=\"weaver.general.FormFieldTransMethod.getViewType\" otherpara=\""+user.getLanguage()+"\" />"+		
					    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" orderkey=\"fieldhtmltype\" transmethod=\"weaver.general.FormFieldTransMethod.getHTMLType\" otherpara=\""+user.getLanguage()+"\" />"+	
					    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.general.FormFieldTransMethod.getFieldType\" otherpara=\"column:fieldhtmltype+column:id+"+user.getLanguage()+"\" />"+		
					    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"  />"+	    
					    "</head>"+
					    "</table>";
					%>
					<wea:SplitPageTag tableString="<%=tableString%>" mode="run"/>
					</TD>
  	</tr>
</table>
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

</form>
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function submitData(obj)
{
	if (check_form(addformtabf,'formname,subcompanyid')){
		addformtabf.submit();
        obj.disabled=true;
    }
}
function deleteData(){
    if(_xtable_CheckedCheckboxId()==""){
        alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
        return;
    }else{
        if(isdel()){
            if(confirm("<%=SystemEnv.getHtmlLabelName(22288,user.getLanguage())%>")){
                document.all("deleteids").value = _xtable_CheckedCheckboxId();
                editformfieldtab.submit();
            }
        }
    }
}

	function adfonShowSubcompany(){
		 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+$GetEle("subcompanyid").value);
		 issame = false;
		 if(datas){
		 if(datas.id!="0"&&datas.id!=""){
			 if(datas.id ==  $GetEle("subcompanyid").value){
			   issame = true;
			 }
			// document.getElementById("subcompanyspan1").innerHtml = datas.name;
			 $GetEle("subcompanyspan1").innerHTML = datas.name;
			  $GetEle("subcompanyid").value=datas.id;
			 }else{
				 $GetEle("subcompanyspan1").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				 $GetEle("subcompanyid").value="";
			 }
		 }
	}
</script>
<!--  <script language="VBScript">
sub adfonShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&addformtabf.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = addformtabf.subcompanyid.value then
		issame = true
	end if
	subcompanyspan1.innerHtml = id(1)
	addformtabf.subcompanyid.value=id(0)
	else
	subcompanyspan1.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	addformtabf.subcompanyid.value=""
	end if
	end if
end sub
</script>-->
<%}%>
</body>
</html>
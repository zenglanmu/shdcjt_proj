<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int design = Util.getIntValue(request.getParameter("design"),0);
	
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<html>
<%
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int wfid=0;
	int formid=0;
	int nodeid=-1;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),-1);
    String nodename="";
    String nodetype="";
    String modetype="";
    int printdes=0;
    int showdes=0;
    int viewtypeall=0;
    int viewdescall=0;
    int showtype=0;
    int vtapprove=0;
    int vtrealize=0;
    int vtforward=0;
    int vtpostil=0;
    int vtrecipient=0;
    int vtreject=0;
    int vtsuperintend=0;
    int vtover=0;
    int vtintervenor=0;
    int vdcomments=0;
    int vddeptname=0;
    int vdoperator=0;
    int vddate=0;
    int vdtime=0;
    int stnull=0;
    int toexcel=0;
    int vsignupload=0;
    int vsigndoc=0;
    int vsignworkflow=0;
    RecordSet.executeSql("select a.*,b.nodename from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and b.id=a.nodeid and a.workflowid="+wfid+" and a.nodeid="+nodeid);
    if(RecordSet.next()){
        nodetype=RecordSet.getString("nodetype");
        nodename=RecordSet.getString("nodename");
        modetype=""+Util.getIntValue(RecordSet.getString("ismode"), 0);
        showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
        printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
        viewtypeall=Util.getIntValue(Util.null2String(RecordSet.getString("viewtypeall")),0);
        viewdescall=Util.getIntValue(Util.null2String(RecordSet.getString("viewdescall")),0);
        showtype=Util.getIntValue(Util.null2String(RecordSet.getString("showtype")),0);
        vtapprove=Util.getIntValue(Util.null2String(RecordSet.getString("vtapprove")),0);
        vtrealize=Util.getIntValue(Util.null2String(RecordSet.getString("vtrealize")),0);
        vtforward=Util.getIntValue(Util.null2String(RecordSet.getString("vtforward")),0);
        vtpostil=Util.getIntValue(Util.null2String(RecordSet.getString("vtpostil")),0);
        vtrecipient=Util.getIntValue(Util.null2String(RecordSet.getString("vtrecipient")),0);
        vtreject=Util.getIntValue(Util.null2String(RecordSet.getString("vtreject")),0);
        vtsuperintend=Util.getIntValue(Util.null2String(RecordSet.getString("vtsuperintend")),0);
        vtover=Util.getIntValue(Util.null2String(RecordSet.getString("vtover")),0);
        vtintervenor=Util.getIntValue(Util.null2String(RecordSet.getString("vtintervenor")),0);
        vdcomments=Util.getIntValue(Util.null2String(RecordSet.getString("vdcomments")),0);
        vddeptname=Util.getIntValue(Util.null2String(RecordSet.getString("vddeptname")),0);
        vdoperator=Util.getIntValue(Util.null2String(RecordSet.getString("vdoperator")),0);
        vddate=Util.getIntValue(Util.null2String(RecordSet.getString("vddate")),0);
        vdtime=Util.getIntValue(Util.null2String(RecordSet.getString("vdtime")),0);
        stnull=Util.getIntValue(Util.null2String(RecordSet.getString("stnull")),0);
        toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
        vsignupload=Util.getIntValue(Util.null2String(RecordSet.getString("vsignupload")),0);
        vsigndoc=Util.getIntValue(Util.null2String(RecordSet.getString("vsigndoc")),0);
        vsignworkflow=Util.getIntValue(Util.null2String(RecordSet.getString("vsignworkflow")),0);
    }
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();

    //add by mackjoe at 2005-12-16
    //显示类型

    //如果表单中设定了模板，节点自动引用表单模板
    String showmode="";
    String printmode="";
    int showmodeid=0;
    int printmodeid=0;
    int showisform=0;
    int printisform=0;
    int isprint=0;
    int tempshowmodeid=0;
    String tempshowmdoe="";
    RecordSet.executeSql("select id,isprint,modename from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            showmodeid=RecordSet.getInt("id");
            showmode=RecordSet.getString("modename");
            //printmodeid=showmodeid;
            //printmode=showmode;
        }else{
            if(isprint==1){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
            }
        }
    }
    RecordSet.executeSql("select id,isprint,modename from workflow_formmode where formid="+formid+" and isbill="+isbill);
    while(RecordSet.next()){
        isprint=RecordSet.getInt("isprint");
        if(isprint==0){
            tempshowmodeid=RecordSet.getInt("id");
            tempshowmdoe=RecordSet.getString("modename");
            if(showmodeid<1 && showdes==0){
                showmodeid=tempshowmodeid;
                showmode=tempshowmdoe;
                showisform=1;
            }
        }else{
            if(printmodeid<1 && isprint==1 && printdes==0){
                printmodeid=RecordSet.getInt("id");
                printmode=RecordSet.getString("modename");
                printisform=1;
            }
        }
    }
    if(tempshowmodeid>0 && printmodeid<1 && printdes==0){
        printmodeid=tempshowmodeid;
        printmode=tempshowmdoe;
        printisform=1;
    }
    boolean indmouldtype = true;
    if (isbill.equals("1")) {
        RecordSet.executeSql("select indmouldtype from workflow_billfunctionlist where billid=" + formid);
        if (RecordSet.next()) {
            indmouldtype = Util.null2String(RecordSet.getString("indmouldtype")).equals("1") ? true : false;
        }
    }
    //end by mackjoe
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23688,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodefieldsave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(design==1) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
else {
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelEditNode(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%
if(!ajax.equals("1")){
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id="nodefieldform" name="nodefieldform" method=post action="wf_operation.jsp" >
<input type="hidden" value="<%=design%>" name="design">
<%if(ajax.equals("1")){%>
<input type=hidden name=ajax value="1">
<%}%>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field><strong><%=wfname%><strong></td>
  </tr>
    <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field><strong><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></strong></td>
  </tr>   <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
    <td class=field><strong>
    <%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></strong></td>
  </tr>   <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></td>
    <%if(isbill.equals("0")){
            %>
            <td class=field><strong><%=FormComInfo.getFormname(""+formid)%></strong></td>
            <%}
            else if(isbill.equals("1")){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
            %>
            <td class=field><strong><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></strong></td>
            <%}else{%>
            <td class=field><strong></strong></td>
            <%}%>
  </tr>   <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field><strong><%=wfdes%></strong></td>
  </tr>
          <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
    <td class=field><strong><%=nodename%></strong></td>
  </tr>   <TR class="Spacing" style="height:1px;" >
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH><%=SystemEnv.getHtmlLabelName(21657,user.getLanguage())%></th>
		<th><select class=inputstyle  name="modetype" onChange="change(this)">
		<%
		ArrayList specialBillIDList = sysPubRefComInfo.getDetailCodeList("SpecialBillID");
		boolean isSpecialBill = specialBillIDList.contains(""+formid)&&"1".equals(isbill);
		ArrayList wfsmtdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkflowShowModeType");
		ArrayList wfsmtdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkflowShowModeType");
		int useHtmlMode = 0;
		try{
			useHtmlMode = Util.getIntValue(baseBean.getPropValue("wfshowmode","wfhtmlmode"), 0);
		}catch(Exception e){}
		for(int listsize=0; listsize<wfsmtdetailCodeList.size(); listsize++){
			int detailCode = Util.getIntValue((String)wfsmtdetailCodeList.get(listsize), 0);
			int detailLabel = Util.getIntValue((String)wfsmtdetailLabelList.get(listsize), 0);
			String selectedStr = "";
			if(modetype.equals(""+detailCode)){
				selectedStr = " selected ";
			}
			if((useHtmlMode==0 || isSpecialBill==true) && detailCode==2){
				continue;
			}
			out.println("<option value=\""+detailCode+"\" "+selectedStr+"><STRONG>"+SystemEnv.getHtmlLabelName(detailLabel, user.getLanguage())+"</strong></option>");
		}
		%>
</select>
    	  </TH>
		</TR>
<TR class="Spacing" style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
</table>
<%if(!ajax.equals("1")){%>
<script>
//oDivOfAddWfNodeField：普通模式
//tDivOfAddWfNodeField：模板模式
//hDivOfAddWfNodeField：Html模式
function change(thisele) {
	var modeid= thisele.value;
    if(modeid=="1"){
        oDivOfAddWfNodeField.style.display="none";
        hDivOfAddWfNodeField.style.display="none";
        tDivOfAddWfNodeField.style.display="";
    }else if(modeid=="0"){
        oDivOfAddWfNodeField.style.display="";
        hDivOfAddWfNodeField.style.display="none";
        tDivOfAddWfNodeField.style.display="none";
    }else if(modeid=="2"){
    	oDivOfAddWfNodeField.style.display="none";
    	tDivOfAddWfNodeField.style.display="none";
    	hDivOfAddWfNodeField.style.display="";
    }
}
</script>
<%}%>

<%-- 图形化模板   start --%>
<div id="tDivOfAddWfNodeField" <%if(!modetype.equals("1")){%>style='display:none'<%}%>>
<table class="viewform">
<COLGROUP>
   <COL width="20%">
   <COL width="80%">
	<TR height="10">
		<TD colSpan=2></TD>
	</TR>
  <TR class="Title"><Th><%=SystemEnv.getHtmlLabelName(18017,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%></Th></TR>
  <TR class="Spacing" style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%></td>
    <td class=field>
    <button type="button"  class=AddDoc onclick="onShowBrowser4field('<%=formid%>','<%=nodeid%>','<%=isbill%>','0')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
    <button type="button"  class=AddDoc onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&isprint=0&ajax=<%=ajax%>')" <%if(!indmouldtype){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
    <span id="showmodespan"><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=showisform%>&isbill=<%=isbill%>&isprint=0&modeid=<%=showmodeid%>&ajax=<%=ajax%>')"><%=showmode%></a></span>
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>  
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></td>
    <td class=field>
    <button type="button"  class=AddDoc onclick="onShowBrowser4field('<%=formid%>','<%=nodeid%>','<%=isbill%>','1')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
    <button type="button"  class=AddDoc onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&isprint=1&ajax=<%=ajax%>')"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
    <span id="printmodespan"><a href="#" onclick="openFullWindowHaveBar('/workflow/mode/index.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=printisform%>&isbill=<%=isbill%>&isprint=1&modeid=<%=printmodeid%>&ajax=<%=ajax%>')"><%=printmode%></a></span>
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel"%></td>
    <td class=field>
    <input type="checkbox" name="toexcel" value="1" <%if(toexcel==1){%>checked<%}%>>
    </TD>
  </tr>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>  
  <TR class="Title"><Th><%=SystemEnv.getHtmlLabelName(21652,user.getLanguage())%></Th></TR>
  <TR class="Spacing" style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
  <TR class="Title">
    <Th><%=SystemEnv.getHtmlLabelName(17139,user.getLanguage())%></Th>
    <TD><input type="checkbox" name="viewtype_all" value="1" onclick="selectviewall('viewtype',this.checked)" <%if(viewtypeall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></TD>
  </TR>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
  <TR>
    <Td colspan="2">
        <table class="viewform" id="viewtypetab">
            <tr>
            <TD width="50%"><input type="checkbox" name="viewtype_approve" value="1" <%if(vtapprove==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewtype_realize" value="1" <%if(vtrealize==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewtype_forward" value="1" <%if(vtforward==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewtype_postil" value="1" <%if(vtpostil==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewtype_recipient" value="1" <%if(vtrecipient==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewtype_reject" value="1" <%if(vtreject==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewtype_superintend" value="1" <%if(vtsuperintend==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewtype_over" value="1" <%if(vtover==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewtype_intervenor" value="1" <%if(vtintervenor==1||viewtypeall==1){%>checked <%}if(viewtypeall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></TD>
            </tr>
        </table>
    </Td>
  </TR>
  <TR class="Title">
    <Th><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></Th>
    <TD><input type="checkbox" name="viewdesc_all" value="1" onclick="selectviewall('viewdesc',this.checked)" <%if(viewdescall==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></TD>
  </TR>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
  <TR>
    <Td colspan="2">
        <table class="viewform" id="viewdesctab">
            <tr>
            <TD width="50%"><input type="checkbox" name="viewdesc_comments" value="1" <%if(vdcomments==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_deptname" value="1" <%if(vddeptname==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewdesc_operator" value="1" <%if(vdoperator==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_date" value="1" <%if(vddate==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewdesc_time" value="1" <%if(vdtime==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_signdoc" value="1" <%if(vsigndoc==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
            </tr>
            <tr>
            <TD width="50%"><input type="checkbox" name="viewdesc_signworkflow" value="1" <%if(vsignworkflow==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
            <TD width="50%"><input type="checkbox" name="viewdesc_signupload" value="1" <%if(vsignupload==1||viewdescall==1){%>checked <%}if(viewdescall==1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></TD>    
            </tr>
        </table>
    </Td>
  </TR>
  <TR class="Title">
    <Th><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></Th>
    <TD>
    <table class="viewform" id="viewdesctab">
            <tr>
            <TD width="37%">
                <select class=inputstyle  name="showtype" >
                <option value="0" <%if(showtype!=1){%> selected <%}%>><STRONG><%=SystemEnv.getHtmlLabelName(21654,user.getLanguage())%></strong>
                <option value="1" <%if(showtype==1){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21655,user.getLanguage())%></strong>
                </select>
            </TD>
            <TD width="63%"><input type="checkbox" name="showtype_null" value="1" <%if(stnull==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(21678,user.getLanguage())%></TD>
            </tr>
     </table>
    </TD>
  </TR>
  <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>  
</table></div>
<%-- 图形化模板   end --%>

<%-- 普通模板   start --%>
<div id="oDivOfAddWfNodeField" <%if(!modetype.equals("0")){%>style='display:none'<%}%>>
  <table class=liststyle cellspacing=1 id="tab_dtl_list-1">
	<COLGROUP>
	<COL width="25%">
	<COL width="25%">
	<COL width="25%">
	<COL width="25%">
  	<TR height="10">
		<TD colSpan=4></TD>
	</TR>
	<tr>
		<td colspan="4">
		<table class="viewform" cellspacing="1">
			<tr>
				<td class="field"><strong><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><strong></td>
			</tr>
		</table>
		</td>
	</tr> 
	<TR style="height:1px;" ><TD class="Line1" colSpan=4 style="padding:0;"></TD></TR>
	<tr class=header>
			<td>
				<%-- 字段名称 --%>
				<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_viewall"  onClick="if(!this.checked){document.nodefieldform.title_editall.checked=false; document.nodefieldform.title_manall.checked=false;}; onChangeViewAll(-1,this.checked)" >
				<%-- 是否显示 --%>
				<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_editall"  onClick="if(this.checked){ document.nodefieldform.title_viewall.checked = this.checked; }else{ document.nodefieldform.title_manall.checked = false;}; onChangeEditAll(-1,this.checked)">
				<%-- 是否可编辑  --%>
				<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
			</td>
			<td>
				<input type="checkbox" name="title_manall"  onClick="if(this.checked){ document.nodefieldform.title_viewall.checked = this.checked; document.nodefieldform.title_editall.checked = this.checked;}; onChangeManAll(-1,this.checked)" >
				<%-- 是否必须输入 --%>
				<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
			</td>
</tr><TR class=Line  style="height:1px;" ><TD colSpan=4></TD></TR>


<%
int linecolor=0;
if(nodeid != -1){
//****************************************************
//***************  "标题"字段显示    start  *************
//****************************************************
	boolean isCreateNode = false;
	if(nodetype.equals("0")){
		isCreateNode = true;
	}
	String view="";
	String edit="";
	String man="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	//"说明"字段在workflow_nodeform中的fieldid 定为 "-1"
	WFNodeFieldMainManager.setFieldid(-1);
	WFNodeFieldMainManager.selectWfNodeField();
	if(WFNodeFieldMainManager.getIsview().equals("1"))   	view=" checked";
	if(WFNodeFieldMainManager.getIsedit().equals("1"))   	edit=" checked";
	if(WFNodeFieldMainManager.getIsmandatory().equals("1"))  man=" checked";
%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
		<td><input type="checkbox" name="title_view" <%=view%> onClick="if(this.checked==false){document.nodefieldform.title_edit.checked=false;document.nodefieldform.title_man.checked=false;}" disabled ></td>
		<td><input type="checkbox" name="title_edit" <%=edit%> onClick="if(this.checked==true){document.nodefieldform.title_view.checked=(this.checked==true?true:false);}else{document.nodefieldform.title_man.checked=false;}" <%if(isCreateNode||nodetype.equals("3")){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="title_man" <%=man%> onClick="if(this.checked==true){document.nodefieldform.title_view.checked=(this.checked==true?true:false);document.nodefieldform.title_edit.checked=(this.checked==true?true:false);}" disabled></td>
	</tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
//****************************************************
//***************  "标题"字段显示    end  ***************
//****************************************************
	

//****************************************************
//*************  "紧急程度"字段显示    start  ***********
//****************************************************
	isCreateNode = false;
	if(nodetype.equals("0")){
		isCreateNode = true;
	}
	view="";
	edit="";
	man="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
	WFNodeFieldMainManager.setFieldid(-2);
	WFNodeFieldMainManager.selectWfNodeField();
	if(WFNodeFieldMainManager.getIsview().equals("1"))		  view=" checked";
	if(WFNodeFieldMainManager.getIsedit().equals("1"))		  edit=" checked";
	if(WFNodeFieldMainManager.getIsmandatory().equals("1"))		man=" checked";
%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
		<td><input type="checkbox" name="level_view" <%=view%> onClick="if(this.checked==false){document.nodefieldform.level_edit.checked=false;document.nodefieldform.level_man.checked=false;}" disabled></td>
		<td><input type="checkbox" name="level_edit" <%=edit%> onClick="if(this.checked==true){document.nodefieldform.level_view.checked=(this.checked==true?true:false);}else{document.nodefieldform.level_man.checked=false;}" <%if(isCreateNode||nodetype.equals("3")){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="level_man" <%=man%> onClick="if(this.checked==true){document.nodefieldform.level_view.checked=(this.checked==true?true:false);document.nodefieldform.level_edit.checked=(this.checked==true?true:false);}" disabled></td>
	</tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
//****************************************************
//*************  "紧急程度"字段显示    end  *************
//****************************************************
}

//****************************************************
//*************  "短信提醒"字段显示    start  ***********
//****************************************************
String messageType = WFManager.getMessageType();
if(nodeid!=-1&&messageType.equals("1")){
	boolean isCreateNode = false;
	if(nodetype.equals("0")){
		isCreateNode = true;
	}
	String view="";
	String edit="";
	String man="";
	WFNodeFieldMainManager.resetParameter();
	WFNodeFieldMainManager.setNodeid(nodeid);
	//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
	WFNodeFieldMainManager.setFieldid(-3);
	WFNodeFieldMainManager.selectWfNodeField();
	if(WFNodeFieldMainManager.getIsview().equals("1"))		  view=" checked";
	if(WFNodeFieldMainManager.getIsedit().equals("1"))		  edit=" checked";
	if(WFNodeFieldMainManager.getIsmandatory().equals("1"))		  man=" checked";
%>
	<tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
		<td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
		<td><input type="checkbox" name="ismessage_view" <%=view%> onClick="if(this.checked==false){document.nodefieldform.ismessage_edit.checked=false;document.nodefieldform.ismessage_man.checked=false;}" disabled ></td>
		<td><input type="checkbox" name="ismessage_edit" <%=edit%> onClick="if(this.checked==true){document.nodefieldform.ismessage_view.checked=(this.checked==true?true:false);}else{document.nodefieldform.ismessage_man.checked=false;}" <%if(isCreateNode||nodetype.equals("3")){%>disabled<%}%> ></td>
		<td><input type="checkbox" name="ismessage_man" <%=man%> onClick="if(this.checked==true){document.nodefieldform.ismessage_view.checked=(this.checked==true?true:false);document.nodefieldform.ismessage_edit.checked=(this.checked==true?true:false);}" disabled></td>
	 </tr>
<%
	if(linecolor==0) {
		linecolor=1;
	}else{
		linecolor=0;
	}
	WFNodeFieldMainManager.closeStatement();
}
//****************************************************
//*************  "短信提醒"字段显示    end  *************
//****************************************************
%>


<%
if(nodeid!=-1 && isbill.equals("0")){
	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.setNodeid(nodeid);
	FormFieldMainManager.selectFormFieldLable();
	int groupid=-1;
	String dtldisabled="";
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		String fieldname=FieldComInfo.getFieldname(""+curid);
		//if (fieldname.equals("manager")) continue;//字段为“manager”这个字段是程序后台所用，不必做必填之类的设置!
		String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
		String curlable = FormFieldMainManager.getFieldLable();
		int curgroupid=FormFieldMainManager.getGroupid();
		//表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
		if(curgroupid==-1) curgroupid=999;
		String isdetail = FormFieldMainManager.getIsdetail();
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(curid);
		WFNodeFieldMainManager.selectWfNodeField();
		String view="";
		String edit="";
		String man="";
		if(isdetail.equals("1") && curgroupid>groupid) {
			groupid=curgroupid;
	
			WFNodeDtlFieldManager.setNodeid(nodeid);
			WFNodeDtlFieldManager.setGroupid(curgroupid);
			WFNodeDtlFieldManager.selectWfNodeDtlField();
			String dtladd = WFNodeDtlFieldManager.getIsadd();
				if(dtladd.equals("1")) dtladd=" checked";
			String dtledit = WFNodeDtlFieldManager.getIsedit();
				if(dtledit.equals("1")) dtledit=" checked";
			String dtldelete = WFNodeDtlFieldManager.getIsdelete();
				if(dtldelete.equals("1")) dtldelete=" checked";
			String dtlhide = WFNodeDtlFieldManager.getIshide();
				if(dtlhide.equals("1")) dtlhide=" checked";
			String dtldefault = WFNodeDtlFieldManager.getIsdefault();
	        	if(dtldefault.equals("1")) dtldefault=" checked";
	        String dtlneed = WFNodeDtlFieldManager.getIsneed();
	        	if(dtlneed.equals("1")) dtlneed=" checked";
			if(!dtladd.equals(" checked") && !dtledit.equals(" checked")) 
				dtldisabled="disabled";
			else
				dtldisabled="";
			%>
			</table>
			<table class=viewform cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<tr>
					<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid+1%><strong></td>
				</tr>	
				<TR style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
					<!--'<%=String.valueOf(groupid)%>'-->
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<%
	            if(!nodetype.equals("3"))
	            {
	            %>
	            <tr>
	                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
	                <td class=field><input type="checkbox" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>></td>
	            </tr>
	            <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <tr>
	                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
	                <td class=field><input type="checkbox" name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>></td>
	            </tr>
	            <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <%
	            }
	            %>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></td>
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				</table>
				<table class=liststyle cellspacing=1 id="tab_dtl_list<%=groupid%>" name="tab_dtl_list<%=groupid%>">
				<COLGROUP>
				<COL width="25%">
				<COL width="25%">
				<COL width="25%">
				<COL width="25%">
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
				<td>
					<input type="checkbox" name="title_viewall<%=groupid%>"  onClick="if(this.checked==false){document.nodefieldform.title_editall<%=groupid%>.checked=false;document.nodefieldform.title_manall<%=groupid%>.checked=false;};onChangeViewAll(<%=curgroupid%>,this.checked)" >
					<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
				</td>
				<td>
					<input type="checkbox" name="title_editall<%=groupid%>"  onClick="if(this.checked==true){document.nodefieldform.title_viewall<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldform.title_manall<%=groupid%>.checked=false;};onChangeEditAll(<%=curgroupid%>,this.checked)" <%=dtldisabled%>>
					<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
				</td>
				<td>
					<input type="checkbox" name="title_manall<%=groupid%>"  onClick="if(this.checked==true){document.nodefieldform.title_viewall<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldform.title_editall<%=groupid%>.checked=(this.checked==true?true:false);};onChangeManAll(<%=curgroupid%>,this.checked)" <%=dtldisabled%>>
					<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
				</td>
				</tr><TR class=Line  style="height:1px;" ><TD colSpan=5></TD></TR>
			<%
		}
	
		if(WFNodeFieldMainManager.getIsview().equals("1"))
			view=" checked";
		if(WFNodeFieldMainManager.getIsedit().equals("1"))
			edit=" checked";
		if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
			man=" checked";
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
	
			<td><%=Util.toScreen(curlable,user.getLanguage())%></td>
			<td><input type="checkbox" name="node<%=curid%>_view_g<%=curgroupid%>" <%=view%> onClick="if(this.checked==false){document.nodefieldform.node<%=curid%>_edit_g<%=curgroupid%>.checked=false;document.nodefieldform.node<%=curid%>_man_g<%=curgroupid%>.checked=false;}"></td>
			<td><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" <%=edit%> <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldform.node<%=curid%>_view_g<%=curgroupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldform.node<%=curid%>_man_g<%=curgroupid%>.checked=false;}" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7")){%>disabled<%}%>></td>
			<td><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>"  <%=man%>  <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldform.node<%=curid%>_view_g<%=curgroupid%>.checked=(this.checked==true?true:false);document.nodefieldform.node<%=curid%>_edit_g<%=curgroupid%>.checked=(this.checked==true?true:false);}" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7")){%>disabled<%}%>></td>
	</tr>
	<%
	 if(linecolor==0) linecolor=1;
			  else linecolor=0;
	}
	FormFieldMainManager.closeStatement();
}else if(nodeid!=-1 && isbill.equals("1")){
	boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
	//数据中心表（新表单对应表）
	String tmpDataCenterTableName = "";
	RecordSet.executeSql("select  inpreptablename  from T_InputReport where billid = "+formid);
	if(RecordSet.next()) tmpDataCenterTableName = Util.null2String(RecordSet.getString("inpreptablename"));
	
	RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
	if(RecordSet.next()){
		String temptablename = Util.null2String(RecordSet.getString("tablename"));
		if(temptablename.equals("formtable_main_"+formid*(-1))) isNewForm = true;
		if(temptablename.equals(tmpDataCenterTableName+ "_main")) isNewForm = true;
	}
	
	boolean iscptbill = false;
	if(isbill.equals("1")&&(formid==7||formid==14||formid==15||formid==18||formid==19||formid==201))
		iscptbill = true;
	
	String sql = "";
	if(isNewForm == true){
		if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER(substr(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),dsporder ";
		}else{
			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, substring(detailtable, "+(("formtable_main_"+formid*(-1)+"_dt").length()+1)+",30)),dsporder ";
		}
	}else{
		sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
	}
	RecordSet.executeSql(sql);
	String predetailtable=null;
	int groupid=0;
	String dtldisabled="";
	while(RecordSet.next()){
		String fieldhtmltype = RecordSet.getString("fieldhtmltype");
		String fieldname = RecordSet.getString("fieldname");
		int curid=RecordSet.getInt("id");
		int curlabel = RecordSet.getInt("fieldlabel");
		int viewtype = RecordSet.getInt("viewtype");
		String detailtable = Util.null2String(RecordSet.getString("detailtable"));
	
		WFNodeFieldMainManager.resetParameter();
		WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(curid);
		WFNodeFieldMainManager.selectWfNodeField();
		String view="";
		String edit="";
		String man="";
		if(viewtype==1 && !detailtable.equals(predetailtable)){
			groupid++;
			WFNodeDtlFieldManager.setNodeid(nodeid);
			WFNodeDtlFieldManager.setGroupid(groupid-1);
			WFNodeDtlFieldManager.selectWfNodeDtlField();
			String dtladd = WFNodeDtlFieldManager.getIsadd();
				if(dtladd.equals("1")) dtladd=" checked";
			String dtledit = WFNodeDtlFieldManager.getIsedit();
				if(dtledit.equals("1")) dtledit=" checked";
			String dtldelete = WFNodeDtlFieldManager.getIsdelete();
				if(dtldelete.equals("1")) dtldelete=" checked";
			String dtldefault = WFNodeDtlFieldManager.getIsdefault();
	        	if(dtldefault.equals("1")) dtldefault=" checked";
			String dtlhide = WFNodeDtlFieldManager.getIshide();
				if(dtlhide.equals("1")) dtlhide=" checked";
			String dtlneed = WFNodeDtlFieldManager.getIsneed();
	        	if(dtlneed.equals("1")) dtlneed=" checked";
			predetailtable=detailtable;
			if((formid==7||formid==156 || formid==157 || formid==158 || isNewForm || iscptbill) && !dtladd.equals(" checked") && !dtledit.equals(" checked"))
				dtldisabled="disabled";
			else
				dtldisabled="";
			%>
			</table>
			<%if(isNewForm){%>
			<!-- 节点属性字段 - 普通模版 - 明细 start -->
			<table class=viewform cellspacing=1 id="tab_dtl_<%=groupid%>" name="tab_dtl_'<%=groupid%>'">
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<tr>
					<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid%><strong></td>
				</tr>	
				<TR style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
				<tr>
					<!-- 允许新增明细 -->
					<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
					<td class=field><input type="checkbox" id="dt_add" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
					<!--'<%=String.valueOf(groupid)%>'-->
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<!-- 允许修改已有明细 -->
					<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
				</tr>	
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<!-- 允许删除已有明细 -->
					<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
				</tr>   
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<%
	            if(!nodetype.equals("3"))
	            {
	            %>
				<tr>
					<!-- 必须新增明细 初始化的时(也就是不勾选允许新增明细的时候) 把必须新增明细 不可用-->
	                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
	                <td class=field>
	                 <!-- 根据 允许新增明细 是否选中(dtladd) 判断 显示还是隐藏 ypc 2012-08-31-->
	                	<%if(dtladd.equals(" checked")){%>
		                 <input type="checkbox" id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
		                <%}else{%>
		                 <input type="checkbox" disabled=false id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
		                <%}%>
	                </td>
	            </tr>
	            <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <tr>
	            	<!-- 新增默认空明细  初始化的时(也就是不勾选允许新增明细的时候) 把新增默认空明细 不可用-->
	                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
	                <td class=field>
	                	 <!-- 根据 允许新增明细 是否选中(dtladd) 判断 显示还是隐藏 ypc 2012-08-31-->
	               		<%if(dtladd.equals(" checked")){%>
		                 <input type="checkbox" id="dt_def"  name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
		                <%}else{%>
		                <input type="checkbox" disabled=false id="dt_def"  name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
		                <%}%>
	                </td>
	            </tr>
	            <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <%} %>
				<tr>
					<!-- 是否打印空明细 -->
					<td><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></td>
				</tr>	 
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				</table>
			<!-- 节点属性字段 - 普通模版 - 明细 end -->
				<%}%>
			<table class=viewform cellspacing=1 name="tab_dtl_<%=groupid%>">
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<%if(!isNewForm){%>
				<tr>
					<td class=field colSpan=2><strong><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=groupid%><strong></td>
				</tr>
				<%}%>
				<TR style="height:1px;" ><TD class="Line1" colSpan=2></TD></TR>
				<% if(formid==7||formid==156 || formid==157 || formid==158 || iscptbill){%>	
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></td>
				</tr>
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></td>
				</tr>
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></td>
					<td class=field><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></td>
				</tr>
				<%
	            if(!nodetype.equals("3"))
	            {
	            %>
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <tr>
	                <td><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></td>
	                <td class=field><input type="checkbox"  name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>></td>
	            </tr>
	            <TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
	            <tr>
	                <td><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></td>
	                <td class=field><input type="checkbox" name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>></td>
	            </tr>
	            <%} %>
	            <%}%>
				<TR class="Spacing" style="height:1px;" ><TD class="Line" colSpan=2></TD></TR>
				</table>
				<table class=liststyle cellspacing=1 id="tab_dtl_list<%=groupid%>" >
				<COLGROUP>
				<COL width="25%">
				<COL width="25%">
				<COL width="25%">
				<COL width="25%">
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
					<td>
						<input type="checkbox" name="node_viewall_g<%=groupid%>"  onClick="if(this.checked==false){document.nodefieldform.node_editall_g<%=groupid%>.checked=false; document.nodefieldform.node_manall_g<%=groupid%>.checked=false;};onChangeViewAll(<%=groupid%>,this.checked)">
						<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%>
					</td>
					<td>
						<input type="checkbox" name="node_editall_g<%=groupid%>" <%=dtldisabled%>  onClick="if(this.checked==true){document.nodefieldform.node_viewall_g<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldform.node_manall_g<%=groupid%>.checked=false;};onChangeEditAll(<%=groupid%>,this.checked)" <%if(nodetype.equals("3")){%>disabled<%}%>>
						<%=SystemEnv.getHtmlLabelName(15604,user.getLanguage())%>
					</td>
					<td>
						<input type="checkbox" name="node_manall_g<%=groupid%>" <%=dtldisabled%>  onClick="if(this.checked==true){document.nodefieldform.node_viewall_g<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldform.node_editall_g<%=groupid%>.checked=(this.checked==true?true:false);};onChangeManAll(<%=groupid%>,this.checked)" <%if(nodetype.equals("3")){%>disabled<%}%>>
						<%=SystemEnv.getHtmlLabelName(15605,user.getLanguage())%>
					</td>
				</tr><TR class=Line  style="height:1px;" ><TD colSpan=4></TD></TR>
			<%
	
		}
		if(WFNodeFieldMainManager.getIsview().equals("1"))
			view=" checked";
		if(WFNodeFieldMainManager.getIsedit().equals("1"))
			edit=" checked";
		if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
			man=" checked";
	%>
	 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >
			<td><%=SystemEnv.getHtmlLabelName(curlabel,user.getLanguage())%></td>
			<td><input type="checkbox" name="node<%=curid%>_view_g<%=groupid%>" <%=view%> onClick="if(this.checked==false){document.nodefieldform.node<%=curid%>_edit_g<%=groupid%>.checked=false;document.nodefieldform.node<%=curid%>_man_g<%=groupid%>.checked=false;}"></td>
			<%if(!fieldhtmltype.equals("7")){%>		
			<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldform.node<%=curid%>_view_g<%=groupid%>.checked=(this.checked==true?true:false);}else{document.nodefieldform.node<%=curid%>_man_g<%=groupid%>.checked=false;}" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></td>
			<td><input type="checkbox" name="node<%=curid%>_man_g<%=groupid%>"  <%=man%>  <%=dtldisabled%> onClick="if(this.checked==true){document.nodefieldform.node<%=curid%>_view_g<%=groupid%>.checked=(this.checked==true?true:false);document.nodefieldform.node<%=curid%>_edit_g<%=groupid%>.checked=(this.checked==true?true:false);}" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></td>
			<%}else{%>
			<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
			<td><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></td>
			<%}%>
	</tr>
<%
		if(linecolor==0){
			linecolor=1;
		}else{
			linecolor=0;
		}
	}
}
%>
</table></div>
<%-- 普通模板   end --%>

<%-- Html模板   start --%>
<div id="hDivOfAddWfNodeField" <%if(!modetype.equals("2")){%>style='display:none'<%}%>>
<%
if(wfsmtdetailCodeList.size() == 3){
	//使用静态加载，防止java变量重复定义
%>
	<jsp:include page="/workflow/workflow/hDivOfWfNodeField.jsp" flush="true">
		<jsp:param name="wfid" value="<%=wfid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="isbill" value="<%=isbill%>" />
		<jsp:param name="formid" value="<%=formid%>" />
		<jsp:param name="ajax" value="<%=ajax%>" />
		<jsp:param name="design" value="<%=design%>" />
	</jsp:include>
<%
}
%>
</div>
<%-- Html模板   end --%>

<br>
<center>
<input type="hidden" value="wfnodefield" name="src">
  <input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="<%=nodeid%>" name="nodeid">
  <input type="hidden" value="<%=formid%>" name="formid">
  <input type="hidden" value="<%=isbill%>" name="isbill">
  <input type="hidden" value="<%=showmodeid%>" name="showmodeid">
  <input type="hidden" value="<%=printmodeid%>" name="printmodeid">
  <input type="hidden" value="<%=showisform%>" name="showisform">
  <input type="hidden" value="<%=printisform%>" name="printisform">
  <input type="hidden" value="<%=showmode%>" name="showmodename">
  <input type="hidden" value="<%=printmode%>" name="printmodename">
</center>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
</table>
</form>

<%if(!ajax.equals("1")){%>
<script language="javascript" type="text/javascript">
//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('addwfnodefield');
}
function submitData()
{
	if (check_form(nodefieldform,''))
		nodefieldform.submit();
}
function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  if("<%=design%>" == "1"){
  	window.showModalDialog(redirectUrl+'&design=1&timeStamp='+new Date().getTime(),window,
         					'dialogWidth:'+document.body.offsetWidth+';dialogHeight:'+document.body.offsetHeight)
  }else{
  	window.open(redirectUrl,"",szFeatures) ;
  }
}

function selectviewall(checkname, opt){
	var tab_id = checkname+"tab";
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=0; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
        var tmpTd0 = tmpTr.cells[0];
		if(tmpTd0 == undefined){
			continue;
		}
        if(opt) tmpTd0.childNodes[0].checked = opt;
        tmpTd0.childNodes[0].disabled = opt;
        var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}
        if(opt) tmpTd1.childNodes[0].checked = opt;
        tmpTd1.childNodes[0].disabled = opt;
    }
}

function checkChange(id) {
    len = document.nodefieldform.elements.length;
    var isenable=0;
    var isen=0; //ypc 修改 声明 2012-08-30
    if(document.all("dtl_add_"+id).checked){
        isen=1;
    }
    //start 2012-08-30 ypc 修改
    if(document.all("dtl_edit_"+id).checked){
    	isenable=1;
    }
    //end 2012-08-30 ypc 修改
    if(isen==1)
    {
    	document.all("dtl_ned_"+id).disabled=false;
    	document.all("dtl_def_"+id).disabled=false;
    }
    else
    {
    	document.all("dtl_ned_"+id).checked=false;  //当取消允许新增明细 是清空 必须新增明细 和 允许新增空明细 勾选 2012-08-30 ypc
    	document.all("dtl_def_"+id).checked=false; //当取消允许新增明细 是清空 必须新增明细 和 允许新增空明细 勾选 2012-08-30 ypc
		document.all("dtl_ned_"+id).disabled=true;
		document.all("dtl_def_"+id).disabled=true;
    }
    for( i=0; i<len; i++) {
        var elename=document.nodefieldform.elements[i].name;
        elename=elename.substr(elename.indexOf('_')+1);
        if (elename=='edit_g'+id || elename=='man_g'+id || elename=='editall_g'+id || elename=='manall_g'+id || elename=='editall'+id || elename=='manall'+id) {
            if(isenable==1||isen==1){ //更改此处
                document.nodefieldform.elements[i].disabled=false;
            }else{
				document.nodefieldform.elements[i].disabled=true;
            }
        } 
    } 
}


function onChangeViewAll(id, opt){
	var tab_id = "tab_dtl_list" + id;

	var tab_name = document.getElementById(tab_id);

	var row = tab_name.rows.length;

	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];

		if(tmpTr == undefined){
			continue;
		}
		var tmpTd1 = tmpTr.cells[1];
		if(tmpTd1 == undefined){
			continue;
		}

		if(tmpTd1.childNodes[0].disabled == false){
			tmpTd1.childNodes[0].checked = opt;
		}

		if(opt == false){
			var tmpTd2 = tmpTr.cells[2];
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}

			var tmpTd3 = tmpTr.cells[3];
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeEditAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = $G(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd2 = tmpTr.cells[2];
		if(tmpTd2 == undefined){
			continue;
		}
		if(tmpTd2.childNodes[0].disabled == false){
			tmpTd2.childNodes[0].checked = opt;
		}
		if(opt == false){
			var tmpTd3 = tmpTr.cells[3];
			if(tmpTd3.childNodes[0].disabled == false){
				tmpTd3.childNodes[0].checked = opt;
				}
		}else{
			var tmpTd1 = tmpTr.cells[1];
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
		}
	}
}

function onChangeManAll(id, opt){
	var tab_id = "tab_dtl_list" + id;
	var tab_name = document.getElementById(tab_id);
	var row = tab_name.rows.length;
	for(var i=1; i<row; i++){
		var tmpTr = tab_name.rows[i];
		if(tmpTr == undefined){
			continue;
		}
		var tmpTd3 = tmpTr.cells[3];
		if(tmpTd3 == undefined){
			continue;
		}
		if(tmpTd3.childNodes[0].disabled == false){
			tmpTd3.childNodes[0].checked = opt;
		}
		if(opt == true){
			var tmpTd1 = tmpTr.cells[1];
			if(tmpTd1.childNodes[0].disabled == false){
				tmpTd1.childNodes[0].checked = opt;
			}
			var tmpTd2 = tmpTr.cells[2];
			if(tmpTd2.childNodes[0].disabled == false){
				tmpTd2.childNodes[0].checked = opt;
			}
		}
	}
}
function encode(str){
    return escape(str);
}
function onShowBrowser4html(formid,nodeid,isbill,layouttype){
	urls = "/workflow/workflow/WorkflowHtmlBrowser.jsp?formid="+formid+"&layouttype="+layouttype+"&isbill="+isbill;
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	datas = window.showModalDialog(urls);
	if(datas.id!=""){
		if (layouttype=="0"){
			document.all("showhtmlid").value=datas.id;
			document.all("showhtmlisform").value=datas.isForm;
			document.all("showhtmlname").value=datas.name;
			if(datas.id==""){
				$("#showhtmlspan").html("");
			}
			else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=0&modeid="+datas.id+"')>"+datas.name+"</a>"
			
				$("#showhtmlspan").html(url);
			}
		}
		else{
			document.all("showhtmlid").value=datas.id;
			document.all("showhtmlisform").value=datas.isForm;
			document.all("showhtmlname").value=datas.name;
			if( datas.id==""){
				$("#printhtmlspan").html("");
			}else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=1&modeid="+datas.id+"')>"+datas.name+"</a>"
				$("#printhtmlspan").html(url);
			}
		}
	}
}

function onShowBrowser4field(formid,nodeid,isbill,isprint){
    urls="/workflow/workflow/WorkflowModeBrowser.jsp?formid="+formid+"&isprint="+isprint+"&isbill="+isbill;
    urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
    datas = window.showModalDialog(urls);
    if(datas){
        if (isprint!="1"){
            $("ipnut[name=showmodeid]").val(datas.id);
            $("ipnut[name=showisform").val(datas.isForm);
            $("ipnut[name=showmodename").val(datas.name);
            if (datas.id==""){
                $("#showmodespan").html("");
			}else{
                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=0&modeid="+datas.id+"')>"+datas.name+"</a>";
                $("#showmodespan").html(url);
			}
		}else{
			 $("ipnut[name=printmodeid]").val(datas.id);
	            $("ipnut[name=printisform").val(datas.isForm);
	            $("ipnut[name=printmodename").val(datas.name);
            if (datas.id==""){
            	 $("#printmodespan").html("");
            }else{
                url="<a href='#' onclick=openFullWindowHaveBar('/workflow/mode/index.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&isprint=1&modeid="+datas.id+"')>"+datas.name+"</a>"
                $("#printmodespan").html(url);
			}
		}
	}
}
function onShowNodes4html(wfid,nodeid,inputname,spanname,selectids){
	var selectids = $GetEle(inputname).value;
	if(selectids==""){
		selectids = "0";		
	}
	var urls="/workflow/workflow/WorkFlowNodesBrowser.jsp?wfid="+wfid+"_"+nodeid+"_"+selectids;
	urls="/systeminfo/BrowserMain.jsp?url="+urls
	var id1 = window.showModalDialog(urls);
	if(id1==null){
		return;	
	}else if(id1[0]==0||id1[1]==""){
		$GetEle(inputname).value="";
		$GetEle(spanname).innerHTML="";
	}else if(id1[0]==1){
		$GetEle(inputname).value=id1[1];
		$GetEle(spanname).innerHTML=id1[2];
	}
}

function onShowBrowser5html(formid,nodeid,isbill,layouttype){
	urls = "/workflow/workflow/WorkflowHtmlBrowser.jsp?formid="+formid+"&layouttype="+layouttype+"&isbill="+isbill;
	urls = "/systeminfo/BrowserMain.jsp?url="+encode(urls);
	datas = window.showModalDialog(urls);
	if(datas.id!=""){
		if (layouttype=="0"){
			document.all("showhtmlid").value=datas.id;
			document.all("showhtmlisform").value=datas.isForm;
			document.all("showhtmlname").value=datas.name;
			if(datas.id==""){
				$("#showhtmlspan").html("");
			}
			else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=0&modeid="+datas.id+"')>"+datas.name+"</a>"
			
				$("#showhtmlspan").html(url);
			}
		} else {
			document.all("mobilehtmlid").value=datas.id;
			document.all("mobilehtmlisform").value=datas.isForm;
			document.all("mobilehtmlname").value=datas.name;
			if( datas.id==""){
				$("#mobilehtmlspan").html("");
			}else{
				url="<a href='#' onclick=openFullWindowHaveBar('/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid=<%=wfid%>&nodeid="+nodeid+"&isform="+datas.isForm+"&isbill="+isbill+"&layouttype=1&modeid="+datas.id+"')>"+datas.name+"</a>"
				$("#mobilehtmlspan").html(url);
			}
		}
	} else {
		if (layouttype=="0"){
			$G("showhtmlid").value = "";
			$G("showhtmlisform").value = "";
			$G("showhtmlname").value = "";
			$("#showhtmlspan").html("");
		} else{
			$G("mobilehtmlid").value = "";
			$G("mobilehtmlisform").value = "";
			$G("mobilehtmlname").value = "";
			$("#mobilehtmlspan").html("");
		}
	}
}
</script>
<% }  %>
</body></html>
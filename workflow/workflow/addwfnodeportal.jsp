<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
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
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%WFNodePortalMainManager.resetParameter();%>
<html>
<%

 String[] sessionnames =  request.getSession(true).getValueNames();
 for(int i=0;i<sessionnames.length;i++){
 	String tmpname = sessionnames[i];
 	if(tmpname.indexOf("con")!=-1)
 		request.getSession(true).removeValue(tmpname);
 }
 String splitstr = ""+Util.getSeparator();

	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int wfid=0;
	int formid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
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
	int rowsum=0;
	int maxrow = 0;
	ArrayList nodeids = new ArrayList();
	ArrayList nodenames = new ArrayList();
	ArrayList nodetypes = new ArrayList();
    ArrayList nodeattrs = new ArrayList();
    nodeids.clear();
	nodenames.clear();
	nodetypes.clear();
    nodeattrs.clear();;
    //add by wjy :提取相关工作流的所有有规则的节点
    String sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=0";
    String hasRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("objid");
    }
	
	//zzl默认显示绿色钩子，表示有节点后操作
    sql2 = "select nodelinkid from int_BrowserbaseInfo where w_fid = "+wfid+" and nodelinkid <>0 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("nodelinkid");
    }
    //zzl-end
    
	
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
    boolean showwayoutinfo=GCONST.getWorkflowWayOut();
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
 if(operatelevel>0){
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:portsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
    if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;

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
<form id="portform" name="portform" method=post action="wf_operation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
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
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field><strong><%=wfname%><strong></td>
  </tr>    <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field><strong><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
    <td class=field><strong>
    <%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
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
            <<td class=field><strong></strong></td>
            <%}%>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field><strong><%=wfdes%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(15606,user.getLanguage())%></th><th>
    	  </TH></TR>
<%if(!ajax.equals("1")){%>
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>
<%
	WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
    String nodeidstr="";
    String nodeattrstr="";
    String nodenamestr="";
    String nodeidattr4="";
    while(WFNodeMainManager.next()){
		nodeids.add(""+WFNodeMainManager.getNodeid());
		nodenames.add(WFNodeMainManager.getNodename());
		nodetypes.add(WFNodeMainManager.getNodetype());
        nodeattrs.add(WFNodeMainManager.getNodeattribute());
        if(nodeidstr.equals("")){
            nodeidstr=""+WFNodeMainManager.getNodeid();
            nodeattrstr=WFNodeMainManager.getNodeattribute();
            nodenamestr=WFNodeMainManager.getNodename();
        }else{
            nodeidstr+=","+WFNodeMainManager.getNodeid();
            nodeattrstr+=","+WFNodeMainManager.getNodeattribute();
            nodenamestr+=splitstr+""+WFNodeMainManager.getNodename();
        }
        if("4".equals(WFNodeMainManager.getNodeattribute())) nodeidattr4+=","+WFNodeMainManager.getNodeid();
    }
%>
<select class=inputstyle  name="curnode">
<option class=Inputstyle value="-1"><STRONG>************<%=SystemEnv.getHtmlLabelName(15602,user.getLanguage())%>**************</strong>
<%
	for(int i=0;i<nodeids.size(); i++) {
	if("3".equals(nodetypes.get(i))) continue;
%>
<option value="<%=(String)nodeids.get(i)+"_"+(String)nodetypes.get(i)+"_"+nodeattrs.get(i)%>"><strong><%=(String)nodenames.get(i)%></strong>
<%
}
%>
</select>
<%if(!ajax.equals("1")){%>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15607,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow1();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15608,user.getLanguage())%></BUTTON>
<%}else{%>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow4port(<%=formid%>,<%=isbill%>,'<%=nodeidstr%>','<%=nodeattrstr%>','<%=nodenamestr%>','<%=nodeidattr4%>',<%=showwayoutinfo%>);"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15607,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow4port();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15608,user.getLanguage())%></BUTTON>
<%}%>
<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
      <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>
 <%if(!ajax.equals("1")){%>
  <table class=liststyle cellspacing=1   cols=6 id="oTable">
  <%}else{%>
  <table class=liststyle cellspacing=1   cols=6 id="oTable4port">
 <%}%>
      	<COLGROUP>
    <%if(showwayoutinfo){%>
	  	<COL width="5%">
	  	<COL width="17%">
	  	<COL width="10%">
	  	<COL width="5%">
	  	<COL width="6%">
	  	<COL width="6%">
	  	<COL width="14%">
	  	<COL width="25%">
	    <COL width="12%">
    <%}else{%>
	    <COL width="5%">
	  	<COL width="20%">
	  	<COL width="10%">
	  	<COL width="5%">
	  	<COL width="6%">
	  	<COL width="6%">
	  	<COL width="15%">
	  	<COL width="33%">
    <%}%>   
           <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15609,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(20576,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15074,user.getLanguage())%></td>
            <%if(showwayoutinfo){%><td><%=SystemEnv.getHtmlLabelName(21642,user.getLanguage())%></td><%}%>   
</tr><tr class="Line"><td colspan="9"> </td></tr>
<%
int colorcount=0;
WFNodePortalMainManager.resetParameter();
WFNodePortalMainManager.setWfid(wfid);
WFNodePortalMainManager.selectWfNodePortal();
while(WFNodePortalMainManager.next()){
	int tmpid = WFNodePortalMainManager.getId();
	int curid=WFNodePortalMainManager.getNodeid();
	int desid=WFNodePortalMainManager.getDestnodeid();
	String isreject = WFNodePortalMainManager.getIsreject();
	String isBulidCode = WFNodePortalMainManager.getIsBulidCode();
	String ismustpass = WFNodePortalMainManager.getIsMustPass();
	String checktmp = "";
	String isBulidCodeCheck="";
	String ismustpasscheck="";
	if(ismustpass.equals("1")) ismustpasscheck=" checked";
	if(isreject.equals("1"))
		checktmp = " checked";
	if(isBulidCode.equals("1"))
		isBulidCodeCheck = " checked";
	int tmpindex = nodeids.indexOf(""+curid);
	if(tmpindex!=-1){
		String curtype = ""+nodetypes.get(tmpindex);
        String curattr=""+nodeattrs.get(tmpindex);
        tmpindex = nodeids.indexOf(""+desid);
        String desattr="";
        if(tmpindex!=-1) desattr=""+nodeattrs.get(tmpindex);
if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
rowsum = tmpid;
if(tmpid>maxrow){
	maxrow = tmpid;
}
	%>
	<td height="23"><input type='checkbox' name='check_node'  value="<%=tmpid%>" >
	<input type="hidden" name="por<%=rowsum%>_id" size=25 value="<%=tmpid%>">
	</td>
    <td  height="23"><%=(String)nodenames.get(Util.getIntValue(""+nodeids.indexOf(""+curid)))%>
    <input type="hidden" name="por<%=rowsum%>_nodeid" value="<%=curid%>">
    </td>
    <td  height="23"><input type="checkbox" name="por<%=rowsum%>_rej" value="1" <%=checktmp%> <%if(!curtype.equals("1")){%> disabled <%}%>></td>
    <td  height="23">
     <%if(!ajax.equals("1")){%>
    <button type="button" class=Browser onclick="onShowBrowser(<%=tmpid%>,<%=rowsum%>)"></button>
     <%}else{%>
    <button type="button" class=Browser onclick="onShowBrowser4port(<%=tmpid%>,<%=rowsum%>,<%=formid%>,<%=isbill%>)"></button>
     <%}%>
    <input type="hidden" name="por<%=rowsum%>_con" value="<%=WFNodePortalMainManager.getCondition()%>">
    <!-- add by xhheng @20050205 for TD 1537 -->
    <input type="hidden" name="por<%=rowsum%>_con_cn" value="<%=WFNodePortalMainManager.getConditioncn()%>">
    <%
    //set value to session....
    request.getSession(true).setAttribute("por"+rowsum+"_con",WFNodePortalMainManager.getCondition());
    request.getSession(true).setAttribute("por"+rowsum+"_passtime",""+WFNodePortalMainManager.getPasstime());
    //add by xhheng @20050205 for TD 1537
    request.getSession(true).setAttribute("por"+rowsum+"_con_cn",WFNodePortalMainManager.getConditioncn());
    %>
    <span  name="por<%=rowsum%>_conspan" id="por<%=rowsum%>_conspan"><%if((WFNodePortalMainManager.getNodepassHour()+WFNodePortalMainManager.getNodepassMinute())>0 || (!WFNodePortalMainManager.getCondition().equals(""))){%><img src="/images/BacoCheck.gif" border=0></img>
    <%}%>
    </span>
    </td>
    <td  height="23">
	<button type="button" class=Browser onclick="onShowAddInBrowser(<%=tmpid%>)">
    </button>
    <span id="ischeck<%=tmpid%>span">
 <%if(hasRolesIds.indexOf(tmpid+"")!=-1){%>
    <img src="/images/BacoCheck.gif" width="16" height="16" border="0">
 <%}%>
  </span>
	</td>
    <td  height="23"><input type="checkbox" name="por<%=rowsum%>_isBulidCode" value="1" <%=isBulidCodeCheck%> ></td>
    <td  height="23"><input class=Inputstyle type="text" name="por<%=rowsum%>_link" value="<%=WFNodePortalMainManager.getLinkname()%>" onchange='checkinput("por<%=rowsum%>_link","por<%=rowsum%>_linkspan"),checkLength("por<%=rowsum%>_link","60","<%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%>","文本长度不能超过","1个中文字符等于2个长度")'><SPAN id=por<%=rowsum%>_linkspan>
    	<%
    	if(WFNodePortalMainManager.getLinkname().equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
    </td>
    <td height="23">
    <select class=inputstyle  name="por<%=rowsum%>_des" onchange='checkSame("por<%=rowsum%>_nodeid",this,"<%=nodeidattr4%>","por<%=rowsum%>_ismustpass","por<%=rowsum%>_ismustpassspan")'>
	<option value="-1"><STRONG><%=SystemEnv.getHtmlLabelName(15612,user.getLanguage())%></strong>
	<%  
		for(int i=0;i<nodeids.size(); i++) {
		    String tempattr=(String)nodeattrs.get(i);
			//if(curid == Util.getIntValue(""+nodeids.get(i))) continue;
			if(curattr.equals("1") && (tempattr.equals("3")||tempattr.equals("4"))) continue;
			if(curattr.equals("2") && (tempattr.equals("0")||tempattr.equals("1"))) continue;
			if((curattr.equals("0")||curattr.equals("3")||curattr.equals("4")) && tempattr.equals("2")) continue;
			String checkit = "";
			if(nodeids.get(i).equals(""+desid))
				checkit = "selected";

	%>
	<option value="<%=(String)nodeids.get(i)%>" <%=checkit%>><strong><%=(String)nodenames.get(i)%></strong>
	<%
	}
	%>
	</select><input  type="checkbox" name="por<%=rowsum%>_ismustpass" value="1" <%if(!desattr.equals("4")){%>style="display:none;"<%}%> <%=ismustpasscheck%>><SPAN  id="por<%=rowsum%>_ismustpassspan" <%if(!desattr.equals("4")){%>style="display:none;"<%}%>><%=SystemEnv.getHtmlLabelName(21398,user.getLanguage())%></SPAN>
</td>
<%if(showwayoutinfo){%>
<td height="23">
<input type='text' class=inputstyle name="por<%=rowsum%>_tipsinfo" onblur="checkInputInfoLength(<%=rowsum%>)" value="<%=WFNodePortalMainManager.getTipsinfo()%>" maxlength="500">
</td>
<%}else{%>
<input type="hidden" name="por<%=rowsum%>_tipsinfo" value="<%=WFNodePortalMainManager.getTipsinfo()%>">
<%}%>          
</tr>
<%
//rowsum+=1;
}
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
	<td height="10" colspan="3"></td>
</tr>
</table>

<br>
<center>
<input type="hidden" value="wfnodeportal" name="src">
  <input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="0" name="nodessum">
  <input type="hidden" value="" name="delids">
<center>
</form>
</div>
<%if(!ajax.equals("1")){%>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
var rowColor="" ;
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{		rowColor = getRowBg();
	ncol = 8;

	var oOption=document.portform.curnode.options[document.portform.curnode.selectedIndex];

	if(oOption.value == -1)
		return;

	tmpval = oOption.value;
	tmparry = tmpval.split("_");
	tmpval = tmparry[0];
	tmptype = tmparry[1];
    tmpattr =tmparry[2];

    oRow = oTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = oOption.text+"<input type='hidden' name='por"+rowindex+"_nodeid' value='"+tmpval+"'>";


				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex +"_rej' value='1'";
				if(tmptype != 1)
					sHtml += " disabled ";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='por"+rowindex+"_des' onchange=checkSame('por"+rowindex+"_nodeid',this,'<%=nodeidattr4%>','por"+rowindex+"_ismustpass','por"+rowindex+"_ismustpassspan')><option value='-1'><%=SystemEnv.getHtmlLabelName(15612,user.getLanguage())%></option>";
                <%
                for(int i=0;i<nodeids.size(); i++) {
                    String tempattr=(String)nodeattrs.get(i);
                %>
                    switch(tmpattr){
                        case "0":
                        case "3":
                        case "4":
                            if(<%=nodeattrs.get(i)%>!=2){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                        case "1":
                            if(<%=nodeattrs.get(i)%>!=3&&<%=nodeattrs.get(i)%>!=4){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                        case "2":
                            if(<%=nodeattrs.get(i)%>!=0&&<%=nodeattrs.get(i)%>!=1){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                    }
                <%
                }
                %>
                sHtml+= "</select><input type=checkbox name='por"+rowindex+"_ismustpass' value='1' style='display:none;'><SPAN id='por"+rowindex+"_ismustpassspan' style='display:none;'><%=SystemEnv.getHtmlLabelName(21398,user.getLanguage())%></SPAN>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);

				/*var osel = document.all("por"+rowindex+"_des");
				for(i=0;i<osel.options.length;i++){
					if(osel.options[i].value==tmpval)
						osel.options[i] = null;
				}*/
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type="button" class=Browser onclick='onShowBrowser(0,"+rowindex+")'></button>";
				sHtml +="<input type='hidden' name='por"+rowindex+"_con'>";
        /* add by xhheng @20050205 for TD 1537 */
        sHtml +="<input type='hidden' name='por"+rowindex+"_con_cn'>";
				sHtml += "<span  name='por"+rowindex+"_conspan' id='por"+rowindex+"_conspan'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type="button" class=Browser onclick='onShowAddInBrowser(0)'></button>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex +"_isBulidCode' value='1'";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex+"_link'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;

}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}
function selectall(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.portform.submit();
}

function onShowBrowser(id,row){
//	alert("id:"+id+",row:"+row);
    if(id==0)
		alert("<%=SystemEnv.getHtmlLabelName(15613,user.getLanguage())%>");
	else{
	url = "BrowserMain.jsp?url=showcondition.jsp?formid=<%=formid%>&isbill=<%=isbill%>&id="+row+"&linkid="+id;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:600px');
	if(con!=null)
	{
		if(con !=""){
      //modify by xhheng @20050205 for TD 1537
			document.all("por"+row+"_con").value=con.substring(0,con.indexOf(";"));
      document.all("por"+row+"_con_cn").value=con.substring(con.indexOf(";")+1,con.length);
			document.all("por"+row+"_conspan").innerHTML="<img src='/images/BacoCheck.gif' border=0></img>";
		}
		else{
			document.all("por"+row+"_con").value="";
      document.all("por"+row+"_con_cn").value="";
			document.all("por"+row+"_conspan").innerHTML="";
		}
	}
    }
}
function onShowAddInBrowser(row){
	if(row==0)
		alert("<%=SystemEnv.getHtmlLabelName(15613,user.getLanguage())%>");
	else{
		url = "BrowserMain.jsp?url=showaddinoperate.jsp?wfid=<%=wfid%>&linkid="+row;
		con = window.showModalDialog(url);
		if(con != undefined){
        if(con=="1"){
            document.all("ischeck"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("ischeck"+row+"span").innerHTML="";
        }
    }

	}
//	alert(url);
}
function checkSame(curNodePortal,obj,nodeidattr4,ismustpass,ismustpassspan){
    if(document.all(curNodePortal).value==obj.value)
    alert("<%=SystemEnv.getHtmlLabelName(18690,user.getLanguage())%>");
    tmpnodeid =","+obj.value+",";
    nodeidattr4+=",";
    if(nodeidattr4.indexOf(tmpnodeid)>-1){
        document.all(ismustpass).style.display='';
        document.all(ismustpassspan).style.display='';
    }else{
        document.all(ismustpass).style.display='none';
        document.all(ismustpassspan).style.display='none';
    }
}
</script>
<%}else{
%>
<div id=portrowsum style="display:none;"><%=maxrow+1%></div>
<%}%>
</body>
</html>
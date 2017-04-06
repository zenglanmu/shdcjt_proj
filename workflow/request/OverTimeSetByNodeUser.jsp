<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="OverTimeSetBean" class="weaver.workflow.request.OverTimeSetBean" scope="page" />
<%
    int userid=user.getUID();
    String logintype=user.getLogintype();
    int usertype=0;
    if(logintype.equals("1")) usertype = 0;
    if(logintype.equals("2")) usertype = 1;
    String option=Util.null2String(request.getParameter("option"));
    int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
    int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
    int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
    int billid=Util.getIntValue(Util.null2String(request.getParameter("billid")),0);
    String sql="";
    if(!OverTimeSetBean.getRight(requestid,workflowid,nodeid,userid,usertype)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
    String nodeids="";
    ArrayList nodeidlist=new ArrayList();
    ArrayList nodepasshourlist=new ArrayList();
    ArrayList nodepassminutelist=new ArrayList();
    ArrayList ProcessorOpinionlist=new ArrayList();
    if(option.equals("save")){
        nodeids=Util.null2String(request.getParameter("nodeids"));
        OverTimeSetBean.dosave(nodeids,requestid,workflowid,request);
    }else{
        nodeids=OverTimeSetBean.getCurrentNodeToEndNode(nodeid,workflowid,requestid,""+nodeid);
        ArrayList[] arrnodelist=OverTimeSetBean.getOverTimeInfo(requestid,workflowid,nodeid,formid,isbill,billid,nodeids);
        if(arrnodelist!=null&&arrnodelist.length==4){
            nodeidlist=arrnodelist[0];
            nodepasshourlist=arrnodelist[1];
            nodepassminutelist=arrnodelist[2];
            ProcessorOpinionlist=arrnodelist[3];
        }
    }
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/css/xpSpin.css">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id="overtiemform" name="overtiemform" method=post action="OverTimeSetByNodeUser.jsp" >
<input type="hidden" name="option" value="save">
<input type="hidden" name="requestid" value="<%=requestid%>">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="nodeid" value="<%=nodeid%>">
<input type="hidden" name="formid" value="<%=formid%>">
<input type="hidden" name="isbill" value="<%=isbill%>">
<input type="hidden" name="billid" value="<%=billid%>">
<input type="hidden" name="nodeids" value="<%=nodeids%>">
<table width=100% height=97% border="0" cellspacing="0" cellpadding="0">
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
  <table class=liststyle cellspacing=1 >
      	<COLGROUP>
  	<COL width="70%">
  	<COL width="30%">
              <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%></th><th>
    	  </TH></TR>
      <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2 style="padding:0px;margin:0px;"></TD></TR>
           <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(2068,user.getLanguage())%></td>
</tr><tr class="Line"><td colspan="2"> </td></tr>
<%
    int colorcount=0;
    for(int i=0;i<nodeidlist.size();i++){
        int tempnodeid=Util.getIntValue(""+nodeidlist.get(i));
        String tempnodename=OverTimeSetBean.getNodeName(tempnodeid);
        String tempProcessorOpinion=""+ProcessorOpinionlist.get(i);
        String tempnodepasshour=""+nodepasshourlist.get(i);
        String tempnodepassminute=""+nodepassminutelist.get(i);
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
	%>
    <td>
        <%=tempnodename%>
        <input type="hidden" name="nodeid_<%=tempnodeid%>" value="<%=tempnodeid%>">
        <input class=Inputstyle type="hidden" name="ProcessorOpinion_<%=tempnodeid%>" value="<%=tempProcessorOpinion%>"  maxlength="100" size="30">
    </td>
    <td>
        <input type=text class=InputStyle name="nodepasshour_<%=tempnodeid%>" 
        id ="nodepasshour_<%=tempnodeid%>" size=5 maxlength="3"  value="<%=tempnodepasshour%>" onKeyPress="ItemCount_KeyPress()"
             onBlur='checkcount1(this);if(this.value<0) this.value="";' ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
             
             
       <%
       if("true".equals(isIE)){%>
        	<span class="xpSpin1" id="nodepassminute_<%=tempnodeid%>"  fieldname="nodepassminute_<%=tempnodeid%>" 
         	min="0" max="59"  value="<%=tempnodepassminute%>" style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:40px;" 
         	language=<%=user.getLanguage()%>></span> 
       <%} else {%>
			<input type="number" min="0" max="59"  maxLength="2" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this);checkNum(this);" name="nodepassminute_<%=tempnodeid%>"  value="<%=tempnodepassminute%>" id="nodepassminute_<%=tempnodeid%>" style="width: 40px; height: 20px; font-family: MS Shell Dlg; font-size: 12px;" />
			<script type="text/javascript">
				function checkNum(obj) {
					var mintue = obj.value;
					if(parseInt(mintue) > 59) { 
						<%if (user.getLanguage() == 7) {%>
							alert("最大值不能超过59");
						<% } else if (user.getLanguage() == 8) {%>
							alert("Maximum value must not exceed 59");
						<% } else {%>
							alert("最大值不能超過59");
						<%}%>
						obj.value = 59; 
					}
				}
			</script>
       <%}%>  
         
         <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
    </td>
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
	<td height="10" colspan="3"></td>
</tr>
</table>
</form>
<script language=javascript>
function onsave(obj){
    obj.disabled=true;
    overtiemform.submit();
}
<%
if(option.equals("save")){
%>
window.close();
<%
}
%>
</script>
</body>
</html>
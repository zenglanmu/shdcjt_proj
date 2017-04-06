<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("ReservedCode:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

//是否分权系统
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}

        String sqlwhere="";

		String workflowIdStr="";
		String workflow_baseSqlPart="(1=0)";
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		String tempWorkflowSeqAlone="0";
		List workflowIdList=new ArrayList();
		List no_WorkflowIdList=new ArrayList();
		RecordSet.executeSql("select flowId as workflowId,formId,isBill,workflowSeqAlone from workflow_code where struSeqAlone='1' and struSeqSelect in('1','2','3')   and isUse='1'");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("workflowId"),-1);
			tempFormId=Util.getIntValue(RecordSet.getString("formId"),-1);
			tempIsBill=""+Util.getIntValue(RecordSet.getString("isBill"),0);
			tempWorkflowSeqAlone=Util.null2String(RecordSet.getString("workflowSeqAlone"));
			if(tempWorkflowId>0&&tempWorkflowSeqAlone.equals("1")){
				workflowIdList.add(""+tempWorkflowId);
			}else if(tempFormId>0){
				workflow_baseSqlPart+=" or (formId ="+tempFormId+" and isBill='"+tempIsBill+"') ";
			}
		}
		RecordSet.executeSql("select flowId as workflowId from workflow_code where flowId>0 and workflowSeqAlone='1' and isUse='1'");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("workflowId"),-1);
			if(tempWorkflowId>0){
				no_WorkflowIdList.add(""+tempWorkflowId);
			}
		}

		RecordSet.executeSql("select * from workflow_base where isvalid=1 and ("+workflow_baseSqlPart+")");
		while(RecordSet.next()){
			tempWorkflowId=Util.getIntValue(RecordSet.getString("id"),-1);
			if(tempWorkflowId>0&&(no_WorkflowIdList.indexOf(""+tempWorkflowId)==-1)){
				workflowIdList.add(""+tempWorkflowId);
			}
		}

		for(int i=0;i<workflowIdList.size();i++){
			workflowIdStr+=","+Util.getIntValue((String)workflowIdList.get(i));
		}

		if(!workflowIdStr.equals("")){
			workflowIdStr=workflowIdStr.substring(1);
		}

		if(!workflowIdStr.equals("")){
			sqlwhere=" and id in("+workflowIdStr+") ";
		}else{
			sqlwhere=" and 1=2 ";
		}

if(detachable==0){
    response.sendRedirect("WorkflowCodeSeqReserved_frmtwo.jsp?sqlwhere="+sqlwhere);
    return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"managestruabbr_help.jsp";
//alert(contentUrl);
if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>

<body scroll="no">
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="WorkflowCodeSeqReserved_left.jsp?rightStr=ReservedCode:Maintenance&sqlwhere=<%=sqlwhere%>" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="WorkflowCodeSeqReserved_frmtwo.jsp?sqlwhere=<%=sqlwhere%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
 </body>

</html>
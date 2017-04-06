<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int formid=Util.getIntValue(request.getParameter("formid"));
int isprint=Util.getIntValue(request.getParameter("isprint"));
int isbill=Util.getIntValue(request.getParameter("isbill"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
String nodename = Util.null2String(request.getParameter("nodename"));
ArrayList modeidlist=new ArrayList();
ArrayList modenamelist=new ArrayList();
ArrayList modeisform=new ArrayList();
ArrayList nodenamelist=new ArrayList();
ArrayList workflownames=new ArrayList();
String id="0";
String modename="";
if(workflowid <=0 && "".equals(nodename)){
	if(isprint==1){
	    RecordSet.executeSql("select id,modename from workflow_formmode where isprint='1' and formid="+formid+" and isbill='"+isbill+"'");
	    if(RecordSet.next()){
	        id=RecordSet.getString("id");
	        modename=RecordSet.getString("modename");
	        if(modename==null || modename.equals("")){
	            modename=SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
	        }
	        modeidlist.add(id);
	        modenamelist.add(modename);
	        modeisform.add("1");
	        nodenamelist.add("");
	        workflownames.add("");
	    }else{
	        RecordSet.executeSql("select id,modename from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
	        if(RecordSet.next()){
	            id=RecordSet.getString("id");
	            modename=RecordSet.getString("modename");
	            if(modename==null || modename.equals("")){
	                modename=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
	            }
	            modeidlist.add(id);
	            modenamelist.add(modename);
	            modeisform.add("1");
	            nodenamelist.add("");
	            workflownames.add("");
	        }
	    }
	}else{
	    RecordSet.executeSql("select id,modename from workflow_formmode where isprint='"+isprint+"' and formid="+formid+" and isbill='"+isbill+"'");
	    if(RecordSet.next()){
	        id=RecordSet.getString("id");
	        modename=RecordSet.getString("modename");
	        if(modename==null || modename.equals("")){
	            modename=SystemEnv.getHtmlLabelName(16450,user.getLanguage());
	        }
	        modeidlist.add(id);
	        modenamelist.add(modename);
	        modeisform.add("1");
	        nodenamelist.add("");
	        workflownames.add("");
	    }
	}
}
String sqlExt = "";
if(workflowid > 0){
	sqlExt += " and workflow_base.id="+workflowid+" ";
}
if(!"".equals(nodename)){
	sqlExt += " and workflow_nodebase.nodename like '%"+Util.convertInput2DB(nodename)+"%' ";
}
RecordSet.executeSql("select workflow_nodemode.id,modename,nodename,isprint,workflowname from workflow_nodemode,workflow_nodebase,workflow_base where (workflow_nodebase.IsFreeNode is null or workflow_nodebase.IsFreeNode!='1') and workflow_nodemode.workflowid=workflow_base.id and workflow_nodemode.nodeid=workflow_nodebase.id and workflow_nodemode.formid="+formid+" and isbill='"+isbill+"' "+sqlExt+" order by workflow_nodemode.workflowid,nodeid");
while(RecordSet.next()){
    id=RecordSet.getString("id");
    modename=RecordSet.getString("modename");
    int tisprint=Util.getIntValue(RecordSet.getString("isprint"),0);
    String nodename_tmp = RecordSet.getString("nodename");
    if(isprint<1 && tisprint==1){
        continue;
    }
    if(modename==null || modename.equals("")){
        if(tisprint==0){
            modename=nodename_tmp+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
        }else{
            modename=nodename_tmp+SystemEnv.getHtmlLabelName(257,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
        }
    }
    modeidlist.add(id);
    modenamelist.add(modename);
    modeisform.add("0");
    nodenamelist.add(nodename_tmp);
    workflownames.add(RecordSet.getString("workflowname"));
}
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM id="SearchForm" name="SearchForm" action="WorkflowModeBrowser.jsp" method="post">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="isprint" name="isprint" value="<%=isprint%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
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

<table class="ViewForm">
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
		<TD class="field">
	
			<input type="hidden" class="wuiBrowser" id="workflowid" name="workflowid" value="<%=workflowid%>" _displayText="<%=workflowComInfo.getWorkflowname(""+workflowid)%>"
				_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp">
		</TD>
	</TR>
	<TR style="height:1px;"><TD class="Line2" colspan="2"></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TD>
		<TD class="field"><input type="text" class="InputStyle" style="width:80%" id="nodename" name="nodename" value="<%=nodename%>"></TD>
	</TR>
	<TR style="height:1px;"><TD class="Line2" colspan="2"></TD></TR>
</table>

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1"  width="100%">
<TR class=DataHeader>
<TH width=40%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
</tr>

<TR class=Line style="height:1px;"><th colspan="5" ></Th></TR>
<%
int i=0;
for(int j=0;j<modeidlist.size();j++){
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><%=modeidlist.get(j)%></TD>
	<TD style="display:none"><%=modeisform.get(j)%></TD>
    <TD><%=modenamelist.get(j)%></TD>
	<TD><%=nodenamelist.get(j)%></TD>
    <TD><%=workflownames.get(j)%></TD>
</TR>
<%}%>
</TABLE>

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

</FORM>
</BODY>
</HTML>

 <script type="text/javascript">
 

 function btnclear_onclick(){
 	window.parent.returnValue = {id:"",isForm:"",name:""};
 	window.parent.close();
 }


 function BrowseTable_onmouseover(e){
 	e=e||event;
    var target=e.srcElement||e.target;
    if("TD"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = "Selected";
    }else if("A"==target.nodeName){
 		jQuery(target).parents("tr")[0].className = "Selected";
    }
 }
 function BrowseTable_onmouseout(e){
 	var e=e||event;
    var target=e.srcElement||e.target;
    var p;
 	if(target.nodeName == "TD" || target.nodeName == "A" ){
       p=jQuery(target).parents("tr")[0];
       if( p.rowIndex % 2 ==0){
          p.className = "DataDark"
       }else{
          p.className = "DataLight"
       }
    }
 }
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
 function BrowseTable_onclick(e){
    var e=e||event;
    var target=e.srcElement||e.target;

    if( target.nodeName =="TD"||target.nodeName =="A"  ){
      window.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),isForm:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
 	 window.parent.close();
 	}
 }

 function submitData()
 {btnok_onclick();
 }
function onSearch(){
	SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
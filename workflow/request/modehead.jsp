<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%
int userid = user.getUID();
String logintype = user.getLogintype();
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String topage = Util.null2String(request.getParameter("topage"));
String needcheck = Util.null2String(request.getParameter("needcheck"));
int messageType = Util.getIntValue(request.getParameter("messageType"));
int defaultName = Util.getIntValue(request.getParameter("defaultName"));
String username = Util.null2String((String)session.getAttribute(userid+"_"+logintype+"username"));
String currentdate = Util.null2String(request.getParameter("currentdate"));
String workflowname = Util.null2String((String)session.getAttribute(userid+"_"+workflowid+"workflowname"));
int Languageid = Util.getIntValue(request.getParameter("Languageid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
int formid = Util.getIntValue(request.getParameter("formid"));

String operationpage = "" ;
if(isbill==1) {
	RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
	if(RecordSet.next()){
		operationpage = Util.null2String(RecordSet.getString("operationpage"));
	}
}
if( operationpage.equals("") ){
	operationpage = "RequestOperation.jsp" ;
}
boolean hasRequestname = false;
boolean hasRequestlevel = false;
boolean hasMessage = false;
//boolean hasSign = false;
RecordSet.executeSql("select fieldid from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid in(-1,-2,-3)");
while(RecordSet.next()){
    int tmpfieldid = RecordSet.getInt("fieldid");
    if (tmpfieldid == -1) {
        hasRequestname = true;
    } else if (tmpfieldid == -2) {
        hasRequestlevel = true;
    } else if (tmpfieldid == -3) {
        hasMessage = true;
    }
}
%>
<form name="frmmain" method="post" action="<%=operationpage%>" enctype="multipart/form-data">
                <TABLE class="ViewForm" id="t_header">
                  <COLGROUP>
                  <COL width="20%">
                  <COL width="80%">
                  <%if(!hasRequestname||!hasRequestlevel){%>
                  <TR><TD class=Line1 colSpan=2></TD></TR>
                  <TR>
                  	<%if(!hasRequestname){%>
                    <TD><%=SystemEnv.getHtmlLabelName(21192,Languageid)%></TD>
                    <TD class=field>
                      <%if(defaultName==1){%>
                       <%--xwj for td1806 on 2005-05-09--%>
                        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit( workflowname+"-"+username+"-"+currentdate,Languageid )%>" >
                        <span id=requestnamespan></span>
                      <%}else{%>
                        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword('requestname',document.getElementById('requestname').value,1)" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "" >
                        <span id=requestnamespan><img src="/images/BacoError.gif" align=absmiddle></span>
                      <%}
                      }
                      if(!hasRequestlevel){%>
                      <%if(hasRequestname){%>
                    <TD><%=SystemEnv.getHtmlLabelName(15534,Languageid)%></TD>
                    <TD class=field>
                    <%}%>
                      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,Languageid)%>
                      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,Languageid)%>
                      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,Languageid)%>
                      <%}%>
                    </TD>
                  </TR>
                  <%}%>
                <TR><TD class=Line colSpan=2></TD></TR>
                  <%
                    if(messageType == 1&&!hasMessage){
                  %>
                  <TR>
                    <TD > <%=SystemEnv.getHtmlLabelName(17586,Languageid)%></TD>
                    <td class=field>
                          <span id=messageTypeSpan></span>
                          <input type=radio value="0" name="messageType" checked><%=SystemEnv.getHtmlLabelName(17583,Languageid)%>
                          <input type=radio value="1" name="messageType"><%=SystemEnv.getHtmlLabelName(17584,Languageid)%>
                          <input type=radio value="2" name="messageType"><%=SystemEnv.getHtmlLabelName(17585,Languageid)%>
                        </td>
                  </TR>  	   	
                  <TR><TD class=Line colSpan=2></TD></TR>
                  <%}%>
                </table>
                <input type=hidden name="workflowid" value="<%=workflowid%>">
                <input type=hidden name="workflowtype" value="<%=workflowtype%>">
                <input type=hidden name="nodeid" value="<%=nodeid%>">
                <input type=hidden name="nodetype" value="0">
                <input type=hidden name="src">
                <input type=hidden name="iscreate" value="1"> 
                <input type=hidden name ="topage" value="<%=topage%>">
                <input type=hidden name ="method">
                <input type=hidden name ="needcheck" value="<%=needcheck%>">
                <input type=hidden name ="inputcheck" value="">

				<input type=hidden name ="requestid" value="-1">
				<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
				<input type=hidden name="needoutprint" value="">
				<iframe name="delzw" width=0 height=0></iframe>

    <%if(isbill==1 && formid==7){%>
    <div id="t_headother">

    <table  class=form border=1 bordercolor='black'>
      <tbody>
      <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
      </TR>
          <tr class="Spacing"> <td class="Line2" ></td></tr>
      <%
      RecordSet.executeSql("select sum(amount) as sumamount from fnaloaninfo where organizationtype=3 and organizationid="+userid);
      RecordSet.next();
      double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
      %>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%> <%=loanamount%></td>
      </tr>     <tr class="Spacing"> <td class="Line2" ></td></tr>
      </tbody>
    </table>
    </div>
    <%}%>
    <%if(isbill==1 && formid==158){%>
    <div id="t_headother">

    <table  class=form border=1 bordercolor='black'>
      <tbody>
      <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
      </TR>
          <tr class="Spacing"> <td class="Line2" ></td></tr>
      <%
        RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+userid);
        RecordSet.next();
        double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
        //获取明细表设置
                WFNodeDtlFieldManager.resetParameter();
                WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
                WFNodeDtlFieldManager.setGroupid(0);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtledit = WFNodeDtlFieldManager.getIsedit();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
      %>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%> <%=loanamount%></td>
      </tr>     <tr class="Spacing"> <td class="Line2" ></td></tr>
      </tbody>
    </table>
    </div>
    <%}%>
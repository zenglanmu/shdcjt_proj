<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
	boolean editflag = Util.null2String(request.getParameter("editflag")).equals("true");
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String isaffirmancebody = Util.null2String(request.getParameter("isaffirmancebody"));
	String reEditbody = Util.null2String(request.getParameter("reEditbody"));
	String requestlevel_disabled = Util.null2String(request.getParameter("requestlevel_disabled"));
	String RequestName_Size = Util.null2String(request.getParameter("RequestName_Size"));
	String RequestName_MaxLength = Util.null2String(request.getParameter("RequestName_MaxLength"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
	int wfMessageType = Util.getIntValue(request.getParameter("wfMessageType"),-1);
	String messageType_disabled = Util.null2String(request.getParameter("messageType_disabled"));
	int rqMessageType = Util.getIntValue(request.getParameter("rqMessageType"),-1);
	String isEdit_ = Util.null2String(request.getParameter("isEdit_"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	int userid=user.getUID();
	String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
%>

  <%if(editflag&&"0".equals(nodetype)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <TD class=field>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestName_Size%> maxlength=<%=RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
          <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>

          <%if(requestlevel_disabled.equals("")){%>
          <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
          <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
          <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
          <%}else{%>
          <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
          <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
          <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
          <%}%>
        </TD>
    </TR>
    <TR style="height:1px;">
      <TD class="Line2" colSpan=2></TD>
    </TR>

  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=field>
                            <span id=messageTypeSpan></span>
                            <%if(messageType_disabled.equals("")){%>
                            <input type=radio value="0" name="messageType" <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                            <input type=radio value="1" name="messageType" <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                            <input type=radio value="2" name="messageType" <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                            <%}else{%>
                            <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
                            <%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
                            <%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
                            <input type=hidden name=messageType value="<%=rqMessageType%>">
                            <%}%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>
  <%}else if(editflag&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
      <TD class=field>
          <%if("1".equals(isEdit_)&&(!isaffirmancebody.equals("1")||reEditbody.equals("1"))){%>
          <input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan');changeKeyword()" size=<%=RequestName_Size%> maxlength=<%=RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
          <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
          <%}else{%>
         <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
         <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
          <%}%>

          <%if(requestlevel_disabled.equals("")){%>
          <input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
          <input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
          <input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
          <%}else{%>
          <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
          <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
          <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
          <%}%>
        </TD>
    </TR>
    <TR style="height:1px;">
      <TD class="Line1" colSpan=2></TD>
    </TR>

  <%
        if (wfMessageType==1) {
  %>
                    <TR>
                      <TD > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
                      <td class=field>
                            <span id=messageTypeSpan></span>
                            <%if(messageType_disabled.equals("")){%>
                            <input type=radio value="0" name="messageType" <%if(rqMessageType==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
                            <input type=radio value="1" name="messageType" <%if(rqMessageType==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
                            <input type=radio value="2" name="messageType" <%if(rqMessageType==2){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
                            <%}else{%>
                            <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
                            <%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
                            <%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
                            <input type=hidden name=messageType value="<%=rqMessageType%>">
                            <%}%>
                          </td>
                    </TR>
                    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
        <%}%>
  <%}else{%>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field>
         <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
         <input type=hidden temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
         <input type=hidden name=requestlevel value="<%=requestlevel%>">
       <input type=hidden name=messageType value="<%=rqMessageType%>"> 
        &nbsp;&nbsp;&nbsp;&nbsp;
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
        &nbsp;&nbsp;&nbsp;&nbsp;
          <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
          <%} else if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
          <%} else if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
        </td>
    </tr>  	   	<tr style="height:1px;">
      <td class="Line1" colSpan=2></td>
    </tr>
    <!--第一行结束 -->
  <%}%>
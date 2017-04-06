<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="OverTimeInfo" class="weaver.workflow.node.NodeOverTimeInfo" scope="page" />
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="GetShowCondition" class="weaver.workflow.workflow.GetShowCondition" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<link rel="stylesheet" type="text/css" href="/css/xpSpin.css">
<!--For Spin Button-->
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String overtimeset = bb.getPropValue(GCONST.getConfigFile() , "ecology.overtime");   
int conid = Util.getIntValue(request.getParameter("id"),0);

String isbill = Util.null2String(request.getParameter("isbill"));
String haspost = Util.null2String(request.getParameter("haspost"));
String isclear = Util.null2String(request.getParameter("isclear"));

int formid = Util.getIntValue(request.getParameter("formid"),0);
int design = Util.getIntValue(request.getParameter("design"),0);

//add by sean for TD3074
int fromBillManagement = Util.getIntValue(request.getParameter("fromBillManagement"),0);
int fromself = Util.getIntValue(request.getParameter("fromself"),0);
int linkid = Util.getIntValue(request.getParameter("linkid"),0);
String[] checkcons = request.getParameterValues("check_con");
conid = linkid;//赋值

//workflowid
String workflowid = "";
rs.executeSql("select workflowid from workflow_nodelink where id = " + linkid);
while(rs.next()){
	workflowid = Util.null2String(rs.getString("workflowid"));
}

ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();

ArrayList seclevel_opts = new ArrayList();
ArrayList seclevel_values = new ArrayList();
ArrayList seclevel_opt1s = new ArrayList();
ArrayList seclevel_value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
seclevel_opts.clear();
seclevel_values.clear();
seclevel_opt1s.clear();
seclevel_value1s.clear();
//add by mackjoe at 2006-04-13 增加超时提醒功能
int NodePassHour=Util.getIntValue(request.getParameter("nodepasshour"),0);    //节点超时小时
int NodePassMinute=Util.getIntValue(request.getParameter("nodepassminute"),0); //节点超时分钟
String IsRemind=Util.null2String(request.getParameter("isremind"));      //是否消息提醒
int RemindHour=Util.getIntValue(request.getParameter("remindhour"),0);      //提前提醒小时
int RemindMinute=Util.getIntValue(request.getParameter("remindminute"),0);    //提前提醒分钟
String FlowRemind=Util.null2String(request.getParameter("FlowRemind"));    //工作流提醒;
String MsgRemind=Util.null2String(request.getParameter("MsgRemind"));     // 短信提醒;
String MailRemind=Util.null2String(request.getParameter("MailRemind"));    // 邮件提醒
String IsNodeOperator=Util.null2String(request.getParameter("isnodeoperator")); //提醒节点操作本人
String IsCreater=Util.null2String(request.getParameter("iscreater"));       //提醒创建人
String IsManager=Util.null2String(request.getParameter("ismanager"));       //提醒节点操作人经理
String IsOther=Util.null2String(request.getParameter("isother"));         //提醒指定对象
String RemindObjectIds=Util.null2String(request.getParameter("remindobjectids"));  //提醒的指定对象
String IsAutoFlow=Util.null2String(request.getParameter("isautoflow"));        //是否超时处理
String FlowNextOperator=Util.null2String(request.getParameter("flownextoperator"));   //自动流转至下一操作者
String FlowObjectIds=Util.null2String(request.getParameter("flowobjectids"));      //指定流程干预对象
String ProcessorOpinion=Util.null2String(request.getParameter("ProcessorOpinion"));      //处理意见
String remindobjectnames=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds);
String flowobjectnames=OverTimeInfo.getResourceNameByResouceid(FlowObjectIds);

String sqlwherePara = Util.null2String(request.getParameter("sqlwhere"));
String sqlwherecnPara = Util.null2String(request.getParameter("sqlwherecn"));

String sqlwhere ="";
//add by xhheng @20050205 for TD 1537
String sqlwherecn="";

GetShowCondition.setSqlWhere(request,user);
sqlwhere = GetShowCondition.getsqlwhere();
sqlwherecn = GetShowCondition.getsqlwherecn();
ids = GetShowCondition.getids();
colnames = GetShowCondition.getcolnames();
opts = GetShowCondition.getopts();
values = GetShowCondition.getvalues();
names = GetShowCondition.getnames();
opt1s = GetShowCondition.getopt1s();
value1s = GetShowCondition.getvalue1s();
seclevel_opts = GetShowCondition.getseclevel_opts();
seclevel_values = GetShowCondition.getseclevel_values();
seclevel_opt1s = GetShowCondition.getseclevel_opt1s();
seclevel_value1s = GetShowCondition.getseclevel_value1s();

if(Util.null2String(request.getParameter("comefrom")).equals("1")){
	if(!sqlwhere.equals(""))
		sqlwhere = sqlwhere.substring(3);
//add by xhheng @20050205 for TD 1537
  if(!sqlwherecn.equals(""))
    sqlwherecn = sqlwherecn.substring(3);
}else{
	// modify by sean for TD3074
	if(fromBillManagement==1||design==1){
		/*
		rs.executeSql("select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid) ;
		if(rs.next()){
			sqlwhere = Util.null2String(rs.getString("condition"));
			sqlwherecn = Util.null2String(rs.getString("conditioncn"));
		}
		*/
		 //调整字段后新的读取方式开始
			 String strSql = "select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid;
			 weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
		   	 statement.setStatementSql(strSql, false);
		   	 statement.executeQuery();
			if(statement.next()){
			  	 if(rs.getDBType().equals("oracle"))
			  	 {
				  		oracle.sql.CLOB theclob = statement.getClob("condition"); 
				  		String readline = "";
				        StringBuffer clobStrBuff = new StringBuffer("");
				        java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
				        while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				        clobin.close() ;
				        sqlwhere = clobStrBuff.toString();
				        
				        oracle.sql.CLOB theclob2 = statement.getClob("conditioncn"); 
				  		String readline2 = "";
				        StringBuffer clobStrBuff2 = new StringBuffer("");
				        java.io.BufferedReader clobin2 = new java.io.BufferedReader(theclob2.getCharacterStream());
				        while ((readline2 = clobin2.readLine()) != null) clobStrBuff2 = clobStrBuff2.append(readline2);
				        clobin2.close() ;
				        sqlwherecn = clobStrBuff2.toString();
			  	  }else{
			  		  sqlwhere=statement.getString("condition");
			  		  sqlwherecn=statement.getString("conditioncn");
			  }
			}
		  	//调整字段后新的读取方式结束
	}else{
			sqlwhere = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con"));
		   //add by xhheng @20050205 for TD 1537
		   sqlwherecn = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con_cn"));
	}
}

String operatortype = Util.null2String(request.getParameter("operatortype"));
if(!sqlwhere.equals("")){
    if(!sqlwherePara.equals("")){
        if(operatortype.equals("and")){
            sqlwhere = "("+sqlwherePara+") and ("+sqlwhere+")";
            sqlwherecn = "("+sqlwherecnPara+") "+SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+sqlwherecn+")";
        }else{
            sqlwhere = "(("+sqlwherePara+") or ("+sqlwhere+"))";
            sqlwherecn = "(("+sqlwherecnPara+") "+SystemEnv.getHtmlLabelName(21695,user.getLanguage())+" ("+sqlwherecn+"))";
        }
    }
}else{
    sqlwhere = sqlwherePara;
    sqlwherecn = sqlwherecnPara;
}

if(haspost.equals("1")){
	request.getSession(true).setAttribute("por"+conid+"_con",sqlwhere);
  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn",sqlwherecn);
	if (!overtimeset.equals("")) {
    OverTimeInfo.init();
    OverTimeInfo.setCondition(sqlwhere);
    OverTimeInfo.setConditionCn(sqlwherecn);
    OverTimeInfo.setIsRemind(IsRemind);
    OverTimeInfo.setNodePassHour(NodePassHour);
    OverTimeInfo.setNodePassMinute(NodePassMinute);
    OverTimeInfo.setRemindHour(RemindHour);
    OverTimeInfo.setRemindMinute(RemindMinute);
    OverTimeInfo.setFlowRemind(FlowRemind);
    OverTimeInfo.setMsgRemind(MsgRemind);
    OverTimeInfo.setMailRemind(MailRemind);
    OverTimeInfo.setIsNodeOperator(IsNodeOperator);
    OverTimeInfo.setIsCreater(IsCreater);
    OverTimeInfo.setIsManager(IsManager);
    OverTimeInfo.setIsOther(IsOther);
    OverTimeInfo.setRemindObjectIds(RemindObjectIds);
    OverTimeInfo.setIsAutoFlow(IsAutoFlow);
    OverTimeInfo.setFlowNextOperator(FlowNextOperator);
    OverTimeInfo.setFlowObjectIds(FlowObjectIds);
    OverTimeInfo.setProcessorOpinion(ProcessorOpinion);    
    OverTimeInfo.updateOverTimeInfo(linkid);
	}
    // add by sean for TD3074
    boolean isOracle = rs.getDBType().equals("oracle");
	if(fromBillManagement==1||design==1||fromself==1){
		String savenode = "update workflow_nodelink set condition=?,conditioncn=?,nodepasstime=? where id=?";
		if(isOracle)
		    savenode = "update workflow_nodelink set condition=empty_clob(),conditioncn=empty_clob(),nodepasstime=? where id=?";
		ConnStatement statement = new ConnStatement();
		try{
			if(!isOracle){
			  statement.setStatementSql(savenode);
			  statement.setString(1 , sqlwhere);
			  statement.setString(2 , sqlwherecn);
			  statement.setFloat(3 , -1F);
			  statement.setInt(4 , linkid);
			}else{
			  statement.setStatementSql(savenode);
			  statement.setFloat(1 , -1F);
			  statement.setInt(2 , linkid);
			}
			  statement.executeUpdate();
		   if(isOracle){
				String sql = "select condition,conditioncn from workflow_nodelink where id = " +linkid;
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                statement.next();
                oracle.sql.CLOB theclob = statement.getClob(1);
                oracle.sql.CLOB theclob2 = statement.getClob(2);

                char[] contentchar = sqlwhere.toCharArray();
                java.io.Writer contentwrite = theclob.getCharacterOutputStream();
                contentwrite.write(contentchar);
                contentwrite.flush();
                contentwrite.close();
                
                char[] contentchar2 = sqlwherecn.toCharArray();
                java.io.Writer contentwrite2 = theclob2.getCharacterOutputStream();
                contentwrite2.write(contentchar2);
                contentwrite2.flush();
                contentwrite2.close();
			 }
		  }
		catch(Exception e) {
			  throw e ;
		}
		finally {
			  try { statement.close();}catch(Exception ex) {}
		}
	}



}else{
    //add by mackjoe at 2006-04-13 增加超时提醒功能
	 if (!overtimeset.equals("")){
    OverTimeInfo.init();
    OverTimeInfo.getNodelinkOverTimeInfo(linkid);
    NodePassHour=OverTimeInfo.getNodePassHour();    //节点超时小时
    NodePassMinute=OverTimeInfo.getNodePassMinute(); //节点超时分钟
    IsRemind=OverTimeInfo.getIsRemind();      //是否消息提醒
    RemindHour=OverTimeInfo.getRemindHour();      //提前提醒小时
    RemindMinute=OverTimeInfo.getRemindMinute();    //提前提醒分钟
    FlowRemind=OverTimeInfo.getFlowRemind();    //工作流提醒;
    MsgRemind=OverTimeInfo.getMsgRemind();     // 短信提醒;
    MailRemind=OverTimeInfo.getMailRemind();    //邮件提醒
    IsNodeOperator=OverTimeInfo.getIsNodeOperator(); //提醒节点操作本人
    IsCreater=OverTimeInfo.getIsCreater();       //提醒创建人
    IsManager=OverTimeInfo.getIsManager();       //提醒节点操作人经理
    IsOther=OverTimeInfo.getIsOther();         //提醒指定对象
    RemindObjectIds=OverTimeInfo.getRemindObjectIds();  //提醒的指定对象
    IsAutoFlow=OverTimeInfo.getIsAutoFlow();        //是否超时处理
    FlowNextOperator=OverTimeInfo.getFlowNextOperator();   //自动流转至下一操作者
    FlowObjectIds=OverTimeInfo.getFlowObjectIds();      //指定流程干预对象
    ProcessorOpinion=OverTimeInfo.getProcessorOpinion();//处理意见
    remindobjectnames=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds);
    flowobjectnames=OverTimeInfo.getResourceNameByResouceid(FlowObjectIds);
	 }
}

System.out.println("=========================clear:"+isclear);
if(isclear.equals("1")){
	request.getSession(true).setAttribute("por"+conid+"_con","");
  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn","");
  OverTimeInfo.init();
  OverTimeInfo.updateOverTimeInfo(linkid);
  // add by sean for TD3074
	if(fromBillManagement==1||design==1){
		String sql = "update workflow_nodelink  set condition ='', conditioncn ='' , nodepasstime = -1  where id="+linkid;
		if(rs.getDBType().equals("oracle"))
            sql = "update workflow_nodelink set condition=empty_clob() , conditioncn=empty_clob(),nodepasstime = -1 where id="+linkid;
		rs.executeSql(sql);
	}

}

boolean showovertimeset=OverTimeInfo.getIsCreateOrReject(linkid);
%>
<BODY>



<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
if(showovertimeset||overtimeset.equals("")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24541,user.getLanguage())+",javascript:submitData1(this),_self} " ;
}else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24541,user.getLanguage())+",javascript:submitData(this),_self} " ;
}
RCMenuHeight += RCMenuHeightStep;
if(showovertimeset||overtimeset.equals("")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24542,user.getLanguage())+",javascript:submitData2(this),_self} " ;
}else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24542,user.getLanguage())+",javascript:submitData3(this),_self} " ;
}
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showcondition.jsp" method="post">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="0" name="fromself">
<input type="hidden" value="<%=conid%>" name="id">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=workflowid value="<%=workflowid%>">
<input type=hidden name=haspost value="">
<input type=hidden name=isclear value="">
<input type=hidden name=comefrom value="1">
<input type=hidden name=fromBillManagement value="<%=fromBillManagement%>">
<input type=hidden name=linkid value="<%=linkid%>">
<input type=hidden name=sqlwhere value="<%=sqlwhere%>">
<input type=hidden name=sqlwherecn value="<%=sqlwherecn%>">
<input type=hidden name=operatortype value="and">

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

<table width=100% class="viewform">
<COLGROUP>
   <COL width="4%">
   <COL width="20%">
   <COL width="20%">
   <COL width="18%">
   <COL width="20%">
   <COL width="18%">
<%
 if (!overtimeset.equals("")){
if(!showovertimeset){%>
<TR class="title">
    	  <TH colSpan=6><%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%></TH></TR>
<TR class="title" style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
<TR  class="title">
    	  <Td  colSpan=2><%=SystemEnv.getHtmlLabelName(2068,user.getLanguage())%></Td>
    	  <Td colSpan=2>
    	  <input type=text class=InputStyle name="nodepasshour" id ="nodepasshour" maxlength="3"  value="<%if(NodePassHour>0){%><%=NodePassHour%><%}%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);if(this.value<0) this.value="";'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></Td>
          <Td colSpan=2>
             <input  class="spin height" type="text" maxlength="2" onkeypress="ItemCount_KeyPress()" onblur="checkNum(this);" id="nodepassminute" name="nodepassminute"  min="0" max="59" value="<%=NodePassMinute%>"> <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></Td>
             <script type="text/javascript">
				function checkNum(obj) {
					var mintue = obj.value;
					if(isNaN(mintue)) { 
						obj.value = 0;
					}
				}
			</script>
             <!--
    	     <span class="spin" id="nodepassminute" fieldname="nodepassminute" min="0" max="59" value="<%=NodePassMinute%>"  style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:59px;"></span><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></Td>
              -->
          </TR>
<TR class="Spacing" style="height:1px;" ><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    	  <Td  colSpan=6>
              <input type="checkbox" name="isremind" value="1" <%if(IsRemind.equals("1")){%> checked<%}%> onclick="checknodepass(1)"> <%=SystemEnv.getHtmlLabelName(18842,user.getLanguage())%>(<span style="color:red;"><%=SystemEnv.getHtmlLabelName(18854,user.getLanguage())%></span>)</Td>
    	  </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(18843,user.getLanguage())%></Td>
    <Td colSpan=2>
              <input type=text class=InputStyle name="remindhour" id ="remindhour" maxlength="3"  value="<%if(RemindHour>0){%><%=RemindHour%><%}%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);checkremindhour();if(this.value<0) this.value="";' <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></Td>
    <Td colSpan=2>
              <input  class="spin height" type="text" onkeypress="ItemCount_KeyPress()" onblur="checkremindhour()" onchange="checkremindhour()" maxlength="2" id="remindminute" name="remindminute"  min="0" max="59" value="<%=RemindMinute%>" style="<%if(!IsRemind.equals("1")){%> visibility:hidden;<%}%>"/>
              <!-- 
              <span class="spin1" id="remindminute"  fieldname="remindminute" message="<%=SystemEnv.getHtmlLabelName(18854,user.getLanguage())%>" min="0" max="59"  value="<%=RemindMinute%>" style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:59px;<%if(!IsRemind.equals("1")){%> visibility:hidden;<%}%>"></span>
               -->
              <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
    </Td>
</TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></Td>
    <Td>
              <input type="checkbox"  name="FlowRemind" id ="FlowRemind"  value="1" <%if(FlowRemind.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(18844,user.getLanguage())%></Td>
    <Td>
              <input type="checkbox"  name="MsgRemind" id ="MsgRemind"  value="1" <%if(MsgRemind.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></Td>
    <Td colSpan=2>
              <input type="checkbox"  name="MailRemind" id ="MailRemind"  value="1" <%if(MailRemind.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%></Td>
    </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(15793,user.getLanguage())%></Td>
    <Td >
              <input type="checkbox"  name="isnodeoperator" id ="isnodeoperator"  value="1" <%if(IsNodeOperator.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%></Td>
    <Td colSpan=3>
              <input type="checkbox"  name="iscreater" id ="iscreater"  value="1" <%if(IsCreater.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></Td>
    </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td colSpan=2></Td>
    <Td >
              <input type="checkbox"  name="ismanager" id ="ismanager"  value="1" <%if(IsManager.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%></Td>
    <Td colSpan=3>
        <input type="checkbox"  name="isother" id ="isother"  value="1" <%if(IsOther.equals("1")){%>checked<%}%> <%if(!IsRemind.equals("1")){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(18846,user.getLanguage())%>
        <button class=Browser name="remindobjectbrw"  onclick="onShowMutiHrm('remindobjectidspan','remindobjectids')" <%if(!IsRemind.equals("1")){%> disabled<%}%>></button>
        <input type=hidden name="remindobjectids" value="<%=RemindObjectIds%>">
        <input type=hidden name="remindobjectnames" value="<%=remindobjectnames%>">
        <span name="remindobjectidspan" id="remindobjectidspan"> <%if(IsOther.equals("1")){%><%=remindobjectnames%><%}%></span>
        </Td>
    </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    	  <Td  colSpan=6>
              <input type="checkbox" name="isautoflow" value="1" <%if(IsAutoFlow.equals("1")){%> checked<%}%> onclick="checknodepass(0)"> <%=SystemEnv.getHtmlLabelName(18848,user.getLanguage())%></Td>
    	  </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td colSpan=2><input type="radio"  id="flownextoperator" name="flownextoperator"  value="1" <%if(FlowNextOperator.equals("1")){%>checked<%}%> <%if(!IsAutoFlow.equals("1")){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18849,user.getLanguage())%>
    </Td>
    <Td colSpan=3>
        <input type="radio" id="flownextoperator"  name="flownextoperator" value="0" <%if(FlowNextOperator.equals("0")){%>checked<%}%> <%if(!IsAutoFlow.equals("1")){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18847,user.getLanguage())%>
        <button type="button" class=Browser name="flowobjectbrw" onclick="onShowMutiHrm('flowobjectidspan','flowobjectids')" <%if(!IsAutoFlow.equals("1")){%>disabled<%}%>></button>
        <input type=hidden name="flowobjectids" value="<%=FlowObjectIds%>">
        <input type=hidden name="flowobjectnames" value="<%=flowobjectnames%>">
        <span name="flowobjectidspan" id="flowobjectidspan"> <%if(FlowNextOperator.equals("0")){%><%=flowobjectnames%><%}%></span>
    </Td>
    </TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%>
    </Td>
    <Td colSpan=4>
        <input type=text class=InputStyle name="ProcessorOpinion" id ="ProcessorOpinion" maxlength="100" size="55" value="<%=ProcessorOpinion%>" <%if(!IsAutoFlow.equals("1")){%> disabled<%}%>>
    </Td>
</TR>
<TR class="Spacing" style="height:1px;"><TD class="Line" colspan=6></TD></TR>
<TR class="Spacing"><TD colspan=6>&nbsp;</TD></TR>
<%} }%>
<TR  class="title">
          <TH colSpan=6><%=SystemEnv.getHtmlLabelName(18850,user.getLanguage())%></TH>
</TR>
<TR class="Spacing" style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
<TR class=header>
<td></td>
<td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
<td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
</tr>
<tr  style="height:1px;">
<TD class="Line1" colspan=6></TD></TR>
<input type='checkbox' name='check_con' style="display:none">

<%
int linecolor=0;
String sql="";
if(isbill.equals("0"))
	//sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
	//出口信息中出口条件设置里面字段的顺序与节点信息节点表单字段里主字段的顺序保持一致（表单）myq 修改 2008.3.17
//	sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" order by workflow_formfield.isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder";
//TD15999
	sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" order by workflow_formfield.isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder";
else if(isbill.equals("1"))
	//sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type from workflow_billfield where billid = "+formid + " order by dsporder ";
	//出口信息中出口条件设置里面字段的顺序与节点信息节点表单字段里主字段的顺序保持一致（单据）myq 修改 2008.3.17
//	sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type from workflow_billfield where (viewtype is null or viewtype!=1) and billid = "+formid + " order by viewtype,detailtable,dsporder ";
//TD15999
	sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype from workflow_billfield where (viewtype is null or viewtype!=1) and billid = "+formid + " and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";

RecordSet.executeSql(sql);
int tmpcount = 0;
while(RecordSet.next()){
//tmpcount += 1;
String id = RecordSet.getString("id");
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
//TD15999
String dbtype = RecordSet.getString("dbtype");
//伪browser框，不能作为出口条件
if(htmltype.equals("3")&&(UrlComInfo.getUrlbrowserurl(type).equals("")||type.equals("141"))) continue;
if(htmltype.equals("7")||(htmltype.equals("2")&&type.equals("2"))) continue;
tmpcount += 1;
%>
 <tr class="Header">
<td><input type='checkbox' name='check_con'  value="<%=id%>" <%if(ids.indexOf(""+id)!=-1){%> checked <%}%>></td>
<td> <input type=hidden name="con<%=id%>_id" value="<%=id%>">
<%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
if(isbill.equals("1"))
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
%>
<%=Util.toScreen(label,user.getLanguage())%>
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
<!-- add by xhheng @20050205 for TD 1537 -->
<input type=hidden name="con<%=id%>_colname_cn" value="<%=label%>">
</td>

<%

//System.out.println("htmltype = " + htmltype + " type = " + type + " name = " + name);
%>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >

<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<input type=text class=InputStyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td >
<input type=text class=InputStyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
</td>
<td>
<select class=inputstyle  name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td>
<input type=text class=InputStyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
</td>
<%
}
else if(htmltype.equals("4")){
%>
<td colspan=4>
<input type=checkbox value="1" name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
</td>
<%}
else if(htmltype.equals("5")){
%>

<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td><td colspan=3>
<select class=inputstyle  name="con<%=id%>_value"  style="width:100%;"  onfocus="changelevel('<%=tmpcount%>')" onchange="setSelectTitle(this);">
<option></option>
<%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<option value="<%=tmpselectvalue%>" title="<%=Util.toScreen(tmpselectname,user.getLanguage())%>" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}%>
</select>
</td>
<%} else if(htmltype.equals("3") && !type.equals("152") && !type.equals("37") && !type.equals("9") && !type.equals("135") && !type.equals("8") && !type.equals("16") && !type.equals("169") && !type.equals("7") && !type.equals("1")&& !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17")&& !type.equals("24")&&!type.equals("160")&& !type.equals("4")&& !type.equals("57") && !type.equals("164")&&!type.equals("166")&&!type.equals("168")&&!type.equals("170")&&!type.equals("142")&&!type.equals("165")&&!type.equals("169")&&!type.equals("65")&&!type.equals("146")&&!type.equals("167")&&!type.equals("117")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<!-- TD15999 -->
<%if(type.equals("162")) {%>
	<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
	<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
<%} else {%>
	<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
	<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
<%}%>
</select>
</td>
<td colspan=3>
<!-- TD15999 -->
<%if(type.equals("161")) {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=type%>','<%=UrlComInfo.getUrlbrowserurl("162")%>?type=<%=dbtype%>')"></button>
<%} else if(type.equals("162")) {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=type%>','<%=UrlComInfo.getUrlbrowserurl("161")%>?type=<%=dbtype%>')"></button>
<%} else if(type.equals("224")||type.equals("225")) {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=type%>','<%=UrlComInfo.getUrlbrowserurl("224")%>?type=<%=dbtype%>|<%=id%>')"></button>
<%} else if(type.equals("226")) {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=type%>','<%=UrlComInfo.getUrlbrowserurl("226")%>?type=<%=dbtype%>|<%=id%>')"></button>
<%} else if(type.equals("227")) {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','<%=type%>','<%=UrlComInfo.getUrlbrowserurl("227")%>?type=<%=dbtype%>|<%=id%>')"></button>
<%} else {%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>')"></button>
<%}%>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && ( type.equals("9") || type.equals("8") || type.equals("16") || type.equals("7") || type.equals("1") || type.equals("165") || type.equals("169") || type.equals("4") || type.equals("164")|| type.equals("146")|| type.equals("167") )){//单部门，单分部
//System.out.println("htmltype = " + htmltype + " type = " + type + " name = " + name);
%>
<td colspan=4>
<select class=inputstyle  name="con<%=id%>_opt" style="width:26%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
</select>
<%
if(type.equals("4")||type.equals("167")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("57")%>')"></button>
<%
	//System.out.println(UrlComInfo.getUrlbrowserurl("57"));
}else if(type.equals("164")||type.equals("169")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/hrm/company/MutiSubcompanyBrowser.jsp')"></button>
<%
}else if(type.equals("1")||type.equals("165")||type.equals("146")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("17")%>')"></button>
<%
}else if(type.equals("7")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("18")%>')"></button>
<%
}else if(type.equals("16")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("152")%>')"></button>
<%
}else if(type.equals("8")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("135")%>')"></button>
<%
}else if(type.equals("9")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("37")%>')"></button>
<%
}else if(type.equals("117")){
%>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("41")%>')"></button>
<%
}
%>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
<%if(type.equals("1")){%>
<br>
<select class=inputstyle  name="seclevel_con<%=id%>_opt" style="width:26%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<input type=text class=InputStyle size=12 name="seclevel_con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)seclevel_values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<select class=inputstyle  name="seclevel_con<%=id%>_opt1" style="width:26%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)seclevel_opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<input type=text class=InputStyle size=12 name="seclevel_con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)seclevel_value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<%}%>
</td>
<%
}else if(htmltype.equals("3") && (type.equals("57")||type.equals("168"))){//多部门
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("4")%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>

<%
}else if(htmltype.equals("3") && (type.equals("142"))){//多收发文部门
	%>
	<td>
	<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
	<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
	<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
	</select>
	</td>
	<td colspan=3>
	<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp')"></button>
	<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
	<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
	<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
	</td>

	<%
	}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
</select>
</td>
<td>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/hrm/jobtitles/MutiJobTitlesBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>

<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<td >
<select class=inputstyle  name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
</td>
<td >
<button type="button" type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
 onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("135")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("8")%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("37")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("9")%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("152")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=UrlComInfo.getUrlbrowserurl("16")%>')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("65")){
%>
<td>
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("160")||type.equals("166"))){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}
else if(htmltype.equals("3") && type.equals("170")){
%>
<td >
<select class=inputstyle  name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
<option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
</td>
<td colspan=3>
<button type="button" class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp')"></button>
<input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value="<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>"<%}%>>
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"> <%if(ids.indexOf(""+id)!=-1){%><%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%></span>
</td>
<%}%>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
<%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>
          <TR class="Title">
    	  <TH colSpan=6><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH></TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=6></TD></TR>
<tr class=header>
<td   colspan=6>
<%=sqlwherecn%>
</td>
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

</FORM></BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
<script language="javaScript">
function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

</script>

<script type="text/javascript">
<!--

function btnok_onclick(){
	 $G("haspost").value = "1";
	 document.SearchForm.submit();
}

function btnclear_onclick(){
	 $G("isclear").value = "1";
	 document.SearchForm.submit();
}


function onShowBrowser(id,url){
	url= url+"?selectedids="+$("input[name=con"+id+"_value]").val()
	datas = window.showModalDialog(url);
	if(datas){
	     if(datas.id!=""){
	    	 spanNameHtml=doReturnSpanHtml(datas.name);
			$("#con"+id+"_valuespan").html(spanNameHtml);
			$("input[name=con"+id+"_value]").val(doReturnSpanHtml(datas.id));
			$("input[name=con"+id+"_name]").val(spanNameHtml);
	    }else{
	    	$("#con"+id+"_valuespan").html("");
			$("input[name=con"+id+"_value]").val("");
			$("input[name=con"+id+"_name]").val("");
		}
	}
}

function changelevel(tmpindex){
	document.SearchForm.check_con[tmpindex*1].checked = true;

}

//-->
</script>
<SCRIPT LANGUAGE=VBS>





sub onShowBrowser21(id,type1,url)
		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		   	if id1(0)<> "" then
			    ids = doReturnSpanHtml(id1(0))
				names = id1(1)
				descs = ""
				if type1 = 161 then
				    ids = Mid(ids,2,Len(ids))
					names = Mid(names,2,Len(names))
					document.all("con"+id+"_valuespan").innerHtml = "<a title='"&ids&"'>"&names&"</a>&nbsp"
					document.all("con"+id+"_value").value=ids
					document.all("con"+id+"_name").value=names
				end if
				if type1 = 162 then
					sHtml = ""
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("con"+id+"_valuespan").innerHtml = sHtml
					document.all("con"+id+"_value").value=doReturnSpanHtml(id1(0))
					document.all("con"+id+"_name").value=id1(1)
				end if
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub
	

sub onShowMutiHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=true
                    else
                        document.all("flownextoperator")(0).checked=false
                        document.all("flownextoperator")(1).checked=true
                    end if
                else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=false
                    else
                        document.all("flownextoperator")(0).checked=true
                        document.all("flownextoperator")(1).checked=false
                    end if
                end if
			end if
end sub
</script>
<script language="javascript">
function submitData(obj)
{
    if(SearchForm.isremind.checked){
        if(!SearchForm.FlowRemind.checked && !SearchForm.MsgRemind.checked && !SearchForm.MailRemind.checked){
            alert("<%=SystemEnv.getHtmlLabelName(18867,user.getLanguage())%>");
            return;
        }
        if(!SearchForm.isnodeoperator.checked && !SearchForm.iscreater.checked && !SearchForm.ismanager.checked && !SearchForm.isother.checked){
            alert("<%=SystemEnv.getHtmlLabelName(18868,user.getLanguage())%>");
            return;
        }
	}
    if(SearchForm.isautoflow.checked){
        if(!document.all("flownextoperator")[0].checked && !document.all("flownextoperator")[1].checked ){
            alert("<%=SystemEnv.getHtmlLabelName(18869,user.getLanguage())%>");
            return;
        }
	}
    if(checkremindhour()){
    SearchForm.operatortype.value="and";
    obj.disabled = true;
	btnok_onclick();
    }
}
function submitData3(obj)
{
    if(SearchForm.isremind.checked){
        if(!SearchForm.FlowRemind.checked && !SearchForm.MsgRemind.checked && !SearchForm.MailRemind.checked){
            alert("<%=SystemEnv.getHtmlLabelName(18867,user.getLanguage())%>");
            return;
        }
        if(!SearchForm.isnodeoperator.checked && !SearchForm.iscreater.checked && !SearchForm.ismanager.checked && !SearchForm.isother.checked){
            alert("<%=SystemEnv.getHtmlLabelName(18868,user.getLanguage())%>");
            return;
        }
	}
    if(SearchForm.isautoflow.checked){
        if(!document.all("flownextoperator")[0].checked && !document.all("flownextoperator")[1].checked ){
            alert("<%=SystemEnv.getHtmlLabelName(18869,user.getLanguage())%>");
            return;
        }
	}
    if(checkremindhour()){
    SearchForm.operatortype.value="or";
    obj.disabled = true;
	btnok_onclick();
    }
}
function submitData1(obj)
{
    SearchForm.operatortype.value="and";
	SearchForm.fromself.value="1";
    obj.disabled = true;
	btnok_onclick();
}
function submitData2(obj)
{
    SearchForm.operatortype.value="or";
	SearchForm.fromself.value="1";
    obj.disabled = true;
	btnok_onclick();
}

function submitClear()
{
	btnclear_onclick();
}
function checknodepass(remind){
    if(remind==1){
        if(SearchForm.isremind.checked){
            if($G("nodepassminute").value>0 || SearchForm.nodepasshour.value>0){
                SearchForm.remindhour.disabled=false;
                $G("remindminute").style.visibility="visible";
                SearchForm.FlowRemind.disabled=false;
                SearchForm.MsgRemind.disabled=false;
                SearchForm.MailRemind.disabled=false;
                SearchForm.isnodeoperator.disabled=false;
                SearchForm.iscreater.disabled=false;
                SearchForm.ismanager.disabled=false;
                SearchForm.isother.disabled=false;
                SearchForm.remindobjectbrw.disabled=false;
            }else{
                SearchForm.isremind.checked=false;
                alert("<%=SystemEnv.getHtmlLabelName(18853,user.getLanguage())%>");
            }
        }else{
            SearchForm.remindhour.disabled=true;
            $G("remindminute").style.visibility="hidden";
            SearchForm.FlowRemind.disabled=true;
            SearchForm.MsgRemind.disabled=true;
            SearchForm.MailRemind.disabled=true;
            SearchForm.isnodeoperator.disabled=true;
            SearchForm.iscreater.disabled=true;
            SearchForm.ismanager.disabled=true;
            SearchForm.isother.disabled=true;
            SearchForm.remindobjectbrw.disabled=true;
        }
    }else{
       if(SearchForm.isautoflow.checked){
           if($G("nodepassminute").value>0 || SearchForm.nodepasshour.value>0){
               document.all("flownextoperator")[0].disabled=false;
               document.all("flownextoperator")[1].disabled=false;
               SearchForm.flowobjectbrw.disabled=false;
               SearchForm.ProcessorOpinion.disabled=false;
           }else{
               SearchForm.isautoflow.checked=false;
               alert("<%=SystemEnv.getHtmlLabelName(18853,user.getLanguage())%>");
           }
        }else{
            document.all("flownextoperator")[0].disabled=true;
            document.all("flownextoperator")[1].disabled=true;
            SearchForm.flowobjectbrw.disabled=true;
            SearchForm.ProcessorOpinion.disabled=true;
       }
    }
}
function checkremindhour(){
    if(!SearchForm.isremind.checked){
    	return true;
    }
    var rehour=SearchForm.remindhour.value;
    rehour=rehour==""?0:parseInt(rehour);
    
    var nodehour=SearchForm.nodepasshour.value;
    nodehour=nodehour==""?0:parseInt(nodehour);
    
    if(!rehour>0){
        rehour=0;
    }
    if(!nodehour>0){
        nodehour=0;
    }
    if(rehour>nodehour){
        SearchForm.remindhour.value="";
        alert("<%=SystemEnv.getHtmlLabelName(18854,user.getLanguage())%>");
        SearchForm.remindhour.focus();
        return false;
    }else{
    if(rehour==nodehour&& parseInt($G("remindminute").value)>parseInt($G("nodepassminute").value)){
        $G("remindminute").value=$G("nodepassminute").value;
        //alert("<%=SystemEnv.getHtmlLabelName(18854,user.getLanguage())%>");
        $G("remindminute").focus();
        return false;
    }
    }
    return true;
}
function setSelectTitle(obj)
{
	var options = obj.options;
	for(var i = 0;i<options.length;i++)
	{
		var option = options[i];
		if(option.selected)
		{
			obj.title=option.title;
		}
	}
}
</script>

<script type="text/javascript">
//TODO

if ("<%=haspost%>" == "1"){
//add by xhheng @20050205 for TD 1537,用";"隔离英中文sqlwhere
    <%if(sqlwhere.equals("")){%>
   		window.parent.parent.returnValue = "";
    <%}else{%>
		window.parent.parent.returnValue = "<%=sqlwhere+";"+sqlwherecn%>";
	<%}if(design==1){%>
		window.parent.design_callback("showcondition","true");
	<%}else{%>
		window.parent.parent.close();
	<%}%>
}
if ("<%=isclear%>" == "1"){
	window.parent.returnValue = "";
	<%if(design==1){%>
		window.parent.design_callback("showcondition","false");
	<%}else{%>
		window.parent.parent.close();
	<%}%>
}

jQuery(document).ready(function(){
   jQuery(".spin").each(function(){
      var $this=jQuery(this);
      var min=$this.attr("min");
      var max=$this.attr("max");
      $this.spin({max:max,min:min});
      $this.blur(function(){
          var value=$this.val();
          if(isNaN(value))
            $this.val(0);
          else{
            value =parseInt(value); 
            if(value>59)
               $this.val(59);
            else if(value<0)
               $this.val(0);
            else
               $this.val(value); 
               
           if($this.val()=='NaN')
               $this.val(0);          
               
          }  
      });
   });
});

function onShowBrowser2(id,type1,url){
  id1 = window.showModalDialog(url,window);
  if(id1){
    if(wuiUtil.getJsonValueByIndex(id1,0)!= ""){
       ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1,0));
       names =wuiUtil.getJsonValueByIndex(id1,1);
       //descs =wuiUtil.getJsonValueByIndex(id1,2);
	   if(type1 == 161){
	     names=names.substr(1);
	     $G("con"+id+"_valuespan").innerHTML = "<a title='"+ids+"'>"+names+"</a>&nbsp;";
	     $G("con"+id+"_value").value=ids;
	     $G("con"+id+"_name").value=names;
      }
	if(type1==224){
		$G("con"+id+"_valuespan").innerHTML = names;
		$G("con"+id+"_value").value=ids;
		$G("con"+id+"_name").value=names;
	}
	if(type1==226||type1==227){
		$G("con"+id+"_valuespan").innerHTML = names;
		$G("con"+id+"_value").value=ids;
		$G("con"+id+"_name").value=names;
	}
    if(type1 == 162){
       sHtml = "";
       var idsArray=ids.split(",");
       var namesArray=names.split(",");
       //var descArray=descs.split(",");
       for(var i=0;i<idsArray.length;i++){
         if(idsArray[i]!="")
            sHtml = sHtml+"<a title='"+ids[i]+"' >"+namesArray[i]+"</a>&nbsp;";
       }
       $G("con"+id+"_valuespan").innerHTML = sHtml;
       $G("con"+id+"_value").value=doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1,0));
       $G("con"+id+"_name").value=wuiUtil.getJsonValueByIndex(id1,1);
    }
   }else{
	    $G("con"+id+"_valuespan").innerHTML ="";
	    $G("con"+id+"_value").value="";
	    $G("con"+id+"_name").value="";
   }
  }
}


</script>
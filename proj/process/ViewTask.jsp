<%@ page language="java" contentType="text/html; charset=GBK" %>
<!--  -->
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.AclManager " %>

<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetReqDoc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetReqWF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="docrs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="docrs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%
char flag = 2;
String ProcPara = "";
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));

//td8154 
   //文档部分
  docrs.executeSql("select * from prj_doc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update prj_doc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }
  //参考文档部分
  docrs.executeSql("select * from Prj_task_referdoc t1,docdetail t2  where taskid="+taskrecordid+" and t1.docid=t2.id");
  while(docrs.next()){
    int docedition=docrs.getInt("docedition");
    int doceditionid=docrs.getInt("doceditionid");
    int ishistory=docrs.getInt("ishistory");
    int docid=docrs.getInt("docid");
    if(doceditionid>-1&&ishistory==1){
        docrs1.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " and (docstatus=1 or docstatus=2) order by docedition desc ");
        while(docrs1.next()){      
            int newDocId = docrs1.getInt("id");
            docrs1.executeSql("update Prj_task_referdoc set docid="+newDocId+" where docid="+docid);
       }
    }    
  }


//==============================================================================================	
//TD3732
//added by hubo,2006-03-14
if(taskrecordid.equals("")){
	RecordSet.executeSql("SELECT id FROM Prj_TaskProcess WHERE prjid="+Util.getIntValue(request.getParameter("prjid"))+" AND taskindex="+Util.getIntValue(request.getParameter("taskindex"))+"");
	if(RecordSet.next())	taskrecordid = String.valueOf(RecordSet.getInt("id"));
}
//==============================================================================================
RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");

//==============================================================================================
//TD4080
//added by hubo,2006-04-12
int relatedRequestId = Util.getIntValue(request.getParameter("requestid"),-1);
if(relatedRequestId!=-1){
	response.sendRedirect("/proj/process/RequestOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&requestid="+relatedRequestId+"");
}
int relatedDocId = Util.getIntValue(request.getParameter("docid"),-1);
if(relatedDocId!=-1){
	response.sendRedirect("/proj/process/DocOperation.jsp?method=add&type=2&ProjID="+ProjID+"&taskid="+taskrecordid+"&docid="+relatedDocId+"");
}
//==============================================================================================

int taskStatus = RecordSet.getInt("status");


/*项目状态*/
 RecordSet rs = new RecordSet();
    /*
String isCurrentActived="";
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+" order by id";
rs.executeSql(sql_tatus);
if(rs.next())
 isCurrentActived=rs.getString("isactived");
 */
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划
String status_prj="" ;
String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
rs.executeSql(sql_prjstatus);
if(rs.next())
 status_prj=rs.getString("status");
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结


String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;
			ismanager=true;
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }
	 }
}

	boolean isResponser=false;
	if( RecordSet.getString("parenthrmids").indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}

if(!canview && !CoworkDAO.haveRightToViewTask(Integer.toString(user.getUID()),taskrecordid)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>




<%if(canedit || isResponser){%>
<FORM id=delplan name=delplan action="/proj/process/TaskOperation.jsp" method=post>
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
<input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
<input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
<input type="hidden" name="method" value="del">
</form>
<%
	if(!status_prj.equals("3")&&!status_prj.equals("4")&&!status_prj.equals("6")&&(taskStatus == 0 || taskStatus == 2)){//项目完成和冻结时不允许编辑,项目任务待审批时不允许修改和删除
	//TD2501
	//modified by hubo,2006-03-15
	if(taskStatus!=2){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/proj/process/EditTask.jsp?taskrecordid="+taskrecordid+"&ProjID="+ProjID+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDeletePlan();,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",/cowork/AddCoWork.jsp?taskrecordid="+taskrecordid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/process/ViewProcess.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</DIV>
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




<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>

  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("subject")%></TD>
         </TR>
		 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmid")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
        </TR>
         	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("begindate").equals("x")){%>
				<%=RecordSet.getString("begindate")%>
          <%}%>
          </TD>
        </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("enddate").equals("-")){%>
				<%=RecordSet.getString("enddate")%>
		  <%}%>
          </TD>
         </TR>	 
<tr style="height:1px;"><td height="10" colspan="2" class="line"></td></tr>
<!--ActualBeginDate,ActualEndDate-->
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
   <TD class=Field><%=RecordSet.getString("actualBeginDate")%></TD>
</TR>
<tr style="height:1px;"><td height="10" colspan="2" class="line"></td></tr>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
   <TD class=Field><%=RecordSet.getString("actualEndDate")%></TD>
</TR>			
			
			<tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("workday")%></TD>
         </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
<!--added by lupeng 2004-07-21-->
<TR>
         <TD><%=SystemEnv.getHtmlLabelName(17501,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("realManDays")%></TD>
         </TR>
	<tr style="height:1px;"><td height="10" colspan="2" class="line"></td></tr>
<!--end-->
<%if(!user.getLogintype().equals("2")){%>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("fixedcost")%> </TD>
         </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
<%}%>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
          <TD class=Field><%=Util.getIntValue(RecordSet.getString("finish"),0)%>%</TD>
            </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(RecordSet.getString("islandmark").equals("1")){%> checked <%}%> disabled></TD>
        </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
        <TR>
        <%
        String pretaskid=RecordSet.getString("prefinish");
        String taskname="";
        if(!pretaskid.equals("")){
            ArrayList pretaskids = Util.TokenizerString(pretaskid,",");
            int taskidnum = pretaskids.size();
            for(int j=0;j<taskidnum;j++){
				//==============================================================================================	
				//TD3732
				//modified by hubo,2006-03-14
            //String sql_1="select subject from Prj_TaskProcess where id = "+pretaskids.get(j);
				String sql_1="select id,subject from Prj_TaskProcess where prjid="+Util.getIntValue(ProjID)+" AND taskIndex="+pretaskids.get(j)+"";
            RecordSet3.executeSql(sql_1);
            RecordSet3.next();
            taskname +="<a href=/proj/process/ViewTask.jsp?taskrecordid="+RecordSet3.getInt("id")+">"+ RecordSet3.getString("subject")+ "</a>" +" ";
				//==============================================================================================
            }
        }
        %>
            <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
            <%if(pretaskid.equals("")){%> <TD class=Field></TD>
            <%}else{%>
             <TD class=Field><%=taskname%></TD>
            <%}%>
        </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</tr>
        <!-- 隐藏项目任务审批状态
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2234,user.getLanguage())%></TD>
           <TD class=Field><%if((RecordSet.getString("taskconfirm")).equals("0")){%><%=SystemEnv.getHtmlLabelName(2235,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(2236,user.getLanguage())%><%}%></TD>
           </TR>
         <TR>
         -->
           <TD  ><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
           <TD class=Field><%=Util.toHtml(RecordSet.getString("content"))%></TD>
         </TR>	 <tr style="height:1px;">
	<td height="10" colspan="2" class="line1"></td>
</tr>
     </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top  style="word-break: break-all;"  >


	<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="PT">
     <input type="hidden" name="sign" value="process">
	 <input type="hidden" name="sortid" value="<%=taskrecordid%>">
   <TABLE  class=liststyle cellspacing=1 >
   <COLGROUP>
        <COL width="30%">
        <COL width="70%">
       <TBODY>
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       <Td align=right >
		<%
		//TD2518
		//modified by hubo,2006-03-15
		if(!status_prj.equals("4")){
		%>
        <a href="javascript:if(check_form(Exchange,'ExchangeInfo')){Exchange.submit();}"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp&nbsp
		<%}%>
      </Td>
      </TR><tr class="Line" style="height:1px;"><td colspan="2" style="padding:1px;"></td></tr>
	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=inputstyle NAME=ExchangeInfo ROWS=3 STYLE="width:96%" onchange='checkinput("ExchangeInfo","ExchangeInfospan")'<%if(status_prj.equals("4")){out.println("disabled");}%>></TEXTAREA>
			  <span id=ExchangeInfospan name=ExchangeInfospan >
 			  <IMG src='/images/BacoError.gif' align=absMiddle>
 			  </span>
		 </TD>
	   </TR>

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td class=Field>
      	<%if(!status_prj.equals("4")){%>
     	 	<input type=hidden name="relateddoc" class="wuiBrowser" value="0"  
     	 		_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
     	 <%}%>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colspan=2 style="padding:0;"></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=Field><%if(!status_prj.equals("4")){%>
      <input type=hidden class="wuiBrowser" name="relatedcus" value="0" _param="resourceids"
      		_displayTemplate="<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}')>#b{name}</a>&nbsp"
      	 _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
      <%}%>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colspan=2 style="padding:0;"></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
      <td class=Field><%if(!status_prj.equals("4")){%>
      <input type=hidden name="relatedprj" value="0" class="wuiBrowser"
      	_displayTemplate="<a href=javascript:openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=#b{id}')>#b{name}</a>&nbsp"
      	 _url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp" _param="resourceids">
      	<%}%>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colspan=2 style="padding:0;"></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=Field><%if(!status_prj.equals("4")){%><button type="button" class=browser onclick="onShowMRequest('relatedwf','relatedrequestspan')"></button>
      <input type=hidden name="relatedwf" value="0"><span id="relatedrequestspan"></span><%}%>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colspan=2 style="padding:0;"></TD></TR> 

     </TBODY>
	 </TABLE>
	</FORM>

  <TABLE class=liststyle cellspacing=1 >
		<COLGROUP>
		<COL width="30%">
		<COL width="20%">
		<COL width="20%">
		<COL width="30%">
    <TBODY>
	<%
	boolean isLight = false;
	char flag0=2;
	int nLogCount=0;
	RecordSetEX.executeProc("ExchangeInfo_SelectBID",taskrecordid+flag0+"PT");
	while(RecordSetEX.next())
	{
		String relatedprj = Util.null2String(RecordSetEX.getString("relatedprj"));
		String relatedcus = Util.null2String(RecordSetEX.getString("relatedcus"));
		String relatedwf = Util.null2String(RecordSetEX.getString("relatedwf"));
		String relateddoc = Util.null2String(RecordSetEX.getString("relateddoc"));
		ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
		ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
		ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
		ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");
		nLogCount++;
		if (nLogCount==2) {
			%>
		</tbody></table>
		<div  id=WorkFlowDiv style="display:none">
	    <table class=liststyle cellspacing=1 >
	    	<COLGROUP>
	    	<COL width="30%">
				<COL width="20%">
	  		<COL width="20%">
	  		<COL width="30%">
	    	<tbody>
		<%}%>
	    	<TR class="Header">
	      	<TD colspan="4">
					<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
					<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
					<%}else{%>
					<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
					<%}%>
					<%=" "+RecordSetEX.getString("createDate")+" "+RecordSetEX.getString("createTime")%>
				  </TD>
    		</TR>
				<%if(isLight){%>	
				<TR CLASS=DataLight>
				<%}else{%>
				<TR CLASS=DataDark>
				<%}%>
					<TD style="word-break:break-all"  colSpan=4>
					<%=Util.toHtml(RecordSetEX.getString("remark"))%>
					</TD>
				</TR>
				<tr style="height:1px;"><td class=Line colspan=4 style="padding:0;"></td></tr>
				<%if(isLight){%>	
				<TR CLASS=DataLight>
				<%}else{%>
				<TR CLASS=DataDark>
				<%}%>
			    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
			    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
			    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
			    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
			  </tr>
			  <tr style="height:1px;"><td class=Line colspan=4 style="padding:0;"></td></tr>
			  <%if(relateddocList.size()+relatedprjList.size()+relatedcusList.size()+relatedwfList.size()!=0){%>
				<%if(isLight){%>	
				<TR CLASS=DataLight>
				<%}else{%>
				<TR CLASS=DataDark>
				<%}%>
			    <td>
					<%for(int i=0;i<relateddocList.size();i++){%>
						<a href="javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>')">
						<%=DocComInfo.getDocname(relateddocList.get(i).toString())%><br>
						</a>
					<%}%>
					</td>
			    <td>
					<%for(int i=0;i<relatedprjList.size();i++){%>
						<a href="javascript:openFullWindowForXtable('/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>')">
						<%=ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())%><br>
						</a>
					<%}%>
					</td>
			    <td>
					<%for(int i=0;i<relatedcusList.size();i++){%>
						<a href="javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>')">
						<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%><br>
						</a>
					<%}%>		
					</td>
			    <td>
					<%for(int i=0;i<relatedwfList.size();i++){%>
						<a href="javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>')">
						<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%><br>
						</a>
					<%}%>		
					</td>
			  </tr>
			  <tr style="height:1px;"><td class=Line colspan=4 style="padding:0;"></td></tr>

			<%}
		isLight = !isLight;
		}%>
			</TBODY>
	  </TABLE>
<% if (nLogCount>=2) { %> </div> <%}%>
        <table class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody>
          <tr>
            <td> </td>
            <td> </td>
            <% if (nLogCount>=2) { %>
            <td align=right><SPAN id=WorkFlowspan><a href='/discuss/ViewExchange.jsp?types=PT&sortid=<%=taskrecordid%>&types_prj=2' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
            <%}else{%>
            <td></td>
            <%} %>
          </tr>
         </tbody>
        </table>
	</TD>
   </TR>
   </TBODY>
</TABLE>

<%
String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
String sql="";
String sqlwhere="";
String orderby="";
String topage="";

topage=URLEncoder.encode( "/proj/process/RequestOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid);
%>

<!--RequiredWF Begin-->
<%
sql="SELECT a.id, a.workflowname, b.isNecessary, b.isTempletTask FROM workflow_base a, Prj_task_needwf b WHERE b.taskId="+Integer.parseInt(taskrecordid)+" AND a.id=b.workflowid";
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 id="tblRequiredWF">
<TBODY>
	<TR class=header>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
		<th style="width:100px;text-align:right">
		<%
		//TD2518
		//modified by hubo,2006-03-15
		if(ismanager&&!status_prj.equals("4")){%>
			<a href="javascript:onShowWorkflow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
		<%}%>
		</th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></th>
	   <th style="width:80px"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line  style="height:1px;"><TD colSpan=3 style="padding:0px;"></TD></TR>
<%
int reqWFId = 0;
String reqWFName="";
String reqWFIsNecessary="";
String reqWFIsTemplet = "";
int requiredWFCount = 0;

while(RecordSet.next()){
	reqWFId = RecordSet.getInt("id");
	reqWFName = RecordSet.getString("workflowname");
	reqWFIsNecessary = RecordSet.getString("isNecessary");
	reqWFIsTemplet = RecordSet.getString("isTempletTask");
%>
	<tr class=datadark>
      <td><a href="/workflow/request/AddRequest.jsp?workflowid=<%=reqWFId%>&prjid=<%=ProjID%>&topage=/proj/process/ViewTask.jsp?taskrecordid=<%=taskrecordid%>"><%=Util.toScreen(reqWFName,user.getLanguage())%></a><%
			/* the count of required workflow that has been added */
sql="select count(distinct t1.requestid) as requiredWFCount from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" AND t3.workflowid="+reqWFId;
sql=sql+sqlwhere;
			RecordSetReqWF.executeSql(sql);
			if(RecordSetReqWF.next())
				requiredWFCount = RecordSetReqWF.getInt("requiredWFCount");
			%></a> 
			(<%=requiredWFCount%>)
			<%if(requiredWFCount==0 && reqWFIsNecessary.equals("1"))	out.println("<img src='/images/BacoError.gif' align='absmiddle'>");%></td>
      <td>
			<input 
				type="checkbox" 
				name="requiredWF<%=reqWFId%>"
				value="<%=reqWFId%>"
				<%
				if(reqWFIsNecessary.equals("1")) out.println("checked");
				if(!ismanager) out.println("disabled");
				%>
				onclick="javascript:modifyRequiredWFNecessary()"
			>
		</td>
      <TD>
			<%if(ismanager){%>
			<a href="/proj/process/TaskRelatedOperation.jsp?method=delRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&requiredWFID=<%=reqWFId%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<input type="checkbox" name="requiredWFIDs" value="<%=reqWFId%>" style="visibility:hidden" checked>
			<%}%>
		</TD>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredWF End-->
<a name="anchor_wf">
      <TABLE class=liststyle cellspacing=1 >
	<form name=workflow method=get action="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=4><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
          <%
			//TD2518
			//modified by hubo,2006-03-15
			if(!status_prj.equals("4") && (canedit || isResponser)){%>
		  <A href="javascript:onShowRequest();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  <A href="javascript:document.workflow.submit();"><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></A>
          <%}%>
		  </TD></TR>

        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
		  <th style="width:80px"><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
		  <TD style="width:100px"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
		</TR>        <TR class=line  style="height:1px;">
          <TD colSpan=6 style="padding:0px;"></TD></TR>

<%
sql="select distinct t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status,t3.id as recorderid from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" ";
orderby=" order by t1.requestid desc ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String requestid=RecordSet.getString("requestid");
	String createdate=RecordSet.getString("createdate");
	String creater=RecordSet.getString("creater");
	String creatertype=RecordSet.getString("creatertype");
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowid=RecordSet.getString("workflowid");
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	String requestname=RecordSet.getString("requestname");
	String status=RecordSet.getString("status");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td>
      <%if(creatertype.equals("0")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%}%><%=Util.toScreen(creatername,user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(creatertype.equals("1")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=creater%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(creater),user.getLanguage())%></a>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
      <%}%>
      </td>
      <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
      <td><%=Util.toScreen(status,user.getLanguage())%></td>
      <TD nowrap>
		  <%if(canedit || isResponser || ( creater.equals(""+user.getUID()) && ((creatertype.equals("0") && user.getLogintype().equals("1")) || (creatertype.equals("1") && user.getLogintype().equals("2")) ) )){%>
		  <a href="/proj/process/RequestOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id=<%=RecordSet.getString("recorderid")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  <%}%>
	  </TD>
       </tr>

<%}%>
		</TBODY>
	</TABLE>


<!--RequiredDocs Begin-->
<%
sql="SELECT docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask FROM Prj_task_needdoc WHERE taskId="+Integer.parseInt(taskrecordid);
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
		<th style="width:100px;text-align:right">
			<%
			//TD2518
			//modified by hubo,2006-03-15
			if(ismanager && !status_prj.equals("4")){%><a href="javascript:onSelectCategory()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%>
		</th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></th>
	   <th style="width:80px"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
		<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
	</TR>
	<TR class=line style="height:1px;"><TD colSpan=3 style="padding:0px;"></TD></TR>
<%
String reqDocMainCategory="";
String reqDocSubCategory="";
String reqDocSecCategory = "";
String reqIsNecessary = "";
String reqIsTempletTask = "";
int requiredDocCount = 0;
while(RecordSet.next()){
	reqDocMainCategory = RecordSet.getString("docMainCategory");
	reqDocSubCategory = RecordSet.getString("docSubCategory");
	reqDocSecCategory = RecordSet.getString("docSecCategory");
	reqIsNecessary = RecordSet.getString("isNecessary");
	reqIsTempletTask = RecordSet.getString("isTempletTask");
%>
	<tr class=datadark>
      <td>
			<a href="javascript:openFullWindowHaveBar('/docs/docs/DocAdd.jsp?prjid=<%=ProjID%>&mainid=<%=reqDocMainCategory%>&subid=<%=reqDocSubCategory%>&secid=<%=reqDocSecCategory%>&topage=/proj/process/ViewTask.jsp?taskrecordid=<%=taskrecordid%>')"><%=Util.toScreen(MainCategoryComInfo.getMainCategoryname(reqDocMainCategory),user.getLanguage())%>/<%=Util.toScreen(SubCategoryComInfo.getSubCategoryname(reqDocSubCategory),user.getLanguage())%>/<%=Util.toScreen(SecCategoryComInfo.getSecCategoryname(reqDocSecCategory),user.getLanguage())%><%
			/* the count of required document that has been added */
			sql="SELECT COUNT(*) AS requiredDocCount FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3 ";
			sqlwhere=" where t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" AND t3.secid="+Util.getIntValue(reqDocSecCategory);	
			//sqlwhere += " and ( t1.doccreaterid="+user.getUID()+" or t1.docstatus=1 or t1.docstatus=2 )";
			sql=sql+sqlwhere;
			RecordSetReqDoc.executeSql(sql);
			if(RecordSetReqDoc.next())
				requiredDocCount = RecordSetReqDoc.getInt("requiredDocCount");
			%></a> 
			(<%=requiredDocCount%>)
			<%if(requiredDocCount==0 && reqIsNecessary.equals("1"))	out.println("<img src='/images/BacoError.gif' align='absmiddle'>");%>
		</td>
      <td>
			<input 
				type="checkbox" 
				name="requiredDoc<%=reqDocSecCategory%>"
				value="<%=reqDocSecCategory%>"
				<%
				if(reqIsNecessary.equals("1")) out.println("checked");
				if(!ismanager) out.println("disabled");
				%> 
				onclick="javascript:modifyRequiredDocNecessary()"
			>
		</td>
		<td>
			<%if(ismanager){%>
			<a href="/proj/process/TaskRelatedOperation.jsp?method=delRequiredDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&secID=<%=reqDocSecCategory%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		</td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredDocs End  -->
<!--ReferencedDocs Begin-->
<%
sql="SELECT a.id, a.docsubject, a.ownerid, a.usertype, a.doccreatedate, a.doccreatetime FROM DocDetail a, Prj_task_referdoc b, "+tables+" t2 WHERE b.taskId="+Integer.parseInt(taskrecordid)+" AND a.id=b.docid and a.id=t2.sourceid";
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=3><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>		<!--TODO:Label-->
		<th style="width:100px;text-align:right">
		<%
		//TD2518
		//modified by hubo,2006-03-15
		if(ismanager && !status_prj.equals("4")){%><a href="javascript:onShowMultiDocsRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a><%}%></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line style="height:1px;"><TD colSpan=4 style="padding:0px;"></TD></TR>
<%
int refDocId = 0;
String refDocCreateDate="";
String refDocCreateTime="";
String refDocName="";
String refOwnerType = "";
String refOwnerID = "";
while(RecordSet.next()){
	refDocId = RecordSet.getInt("id");
	refDocCreateDate = RecordSet.getString("doccreatedate");
	refDocCreateTime = RecordSet.getString("doccreatetime");
	refDocName = RecordSet.getString("docsubject");
	refOwnerType = RecordSet.getString("usertype");
	refOwnerID = RecordSet.getString("ownerid");
%>
	<tr class=datadark>
      <td style="width:220px"><%=Util.toScreen(refDocCreateDate,user.getLanguage())%> <%=Util.toScreen(refDocCreateTime,user.getLanguage())%></td>
      <td style="width:80px">
			<%if(refOwnerType.equals("1")){%>
				<a href="/hrm/resource/HrmResource.jsp?id=<%=refOwnerID%>"><%=Util.toScreen(ResourceComInfo.getResourcename(refOwnerID),user.getLanguage())%></a>
			<%}else if(refOwnerType.equals("2")){%>
				<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=refOwnerID%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(refOwnerID),user.getLanguage())%></a>
			<%}%>
		</td>
      <td><a href="/docs/docs/DocDsp.jsp?id=<%=refDocId%>"><%=Util.toScreen(refDocName,user.getLanguage())%></a></td>
      <td>
		<%if(ismanager){%>
		<a href="/proj/process/TaskRelatedOperation.jsp?method=delReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docID=<%=refDocId%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		<%}%></td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--ReferencedDocs End-->



<%
topage=URLEncoder.encode( "/proj/process/DocOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid);
%>
<a name="anchor_doc">
      <TABLE class=liststyle cellspacing=1 >
	<form name=doc method=post action="/docs/docs/DocList.jsp?isOpenNewWind=1">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
          <%
			//TD2518
			//modified by hubo,2006-03-15
			if(!status_prj.equals("4") && (canedit || isResponser)){%>
  		  <A href="javascript:onShowDoc();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  <A href="javascript:document.doc.submit();"><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></A>
		  <% } %>
		  </TD></TR>

        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		  <TD style="width:100px"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
		</TR>    <TR class=line style="height:1px;">
          <TD  colSpan=4 style="padding:0px;"></TD></TR>

<%

sql="SELECT distinct t1.id, t1.docsubject, t1.ownerid, t1.usertype, t1.doccreatedate, t1.doccreatetime,t3.id as recorderid FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3 ";
sqlwhere=" where t1.docstatus in ('1','2','5') and t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" " ;
sqlwhere += " and ( t1.doccreaterid="+user.getUID()+" or t1.docstatus=1 or t1.docstatus=2 )";
orderby=" ORDER BY t1.id DESC ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String id=RecordSet.getString("id");
	String createdate=RecordSet.getString("doccreatedate");
	String createtime=RecordSet.getString("doccreatetime");
	String ownerid=RecordSet.getString("ownerid");
	String ownertype=RecordSet.getString("usertype");
	String docsubject=RecordSet.getString("docsubject");
%>
    <tr class=datadark>
      <td style="width:220px"><%=Util.toScreen(createdate,user.getLanguage())%>&nbsp<%=Util.toScreen(createtime,user.getLanguage())%></td>
      <td style="width:80px">
      <%if(ownertype.equals("1")){%>
      <%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=ownerid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(ownerid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
      <%}else if(ownertype.equals("2")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ownerid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerid),user.getLanguage())%></a>
      <%}%>
      </td>
      <td><a href="/docs/docs/DocDsp.jsp?id=<%=id%>"><%=Util.toScreen(docsubject,user.getLanguage())%></a></td>
      <TD nowrap>
		  <%if(canedit || isResponser || ( ownerid.equals(""+user.getUID()) && ownertype.equals(""+user.getLogintype()) )){%>
		  <a href="/proj/process/DocOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id=<%=RecordSet.getString("recorderid")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  <%}%>
	  </TD>
       </tr>
<%}%>
		</TBODY>
	</TABLE>
      <TABLE class=liststyle cellspacing=1 >
        <TBODY>
        <TR class=header>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
		<%
		//TD2518,TD2517
		//modified by hubo,2006-03-15
		if(!status_prj.equals("4") && (canedit || isResponser)){
		%>
		  <A href="/proj/process/AddPrjCustomer.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=taskrecordid%>&type=2&method=add"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		<%}%>
		  </TD></TR>

        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
          <!--TD><%=SystemEnv.getHtmlLabelName(1291,user.getLanguage())%></TD-->
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD style="width:100px"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD></TR>
              <TR class=line style="height:1px;">
          <TD  colSpan=4 style="padding:0;"></TD></TR>
<%
	ProcPara = ProjID + flag + taskrecordid;
	RecordSet.executeProc("Prj_Customer_FindByTaskID",ProcPara);
while(RecordSet.next())
{
%>
        <TR class=DataDark>
          <TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("customerid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid")),user.getLanguage())%></a>
          </TD>
          <!--TD>
				<%if(RecordSet.getString("powerlevel").equals("1")){%>
						<%=SystemEnv.getHtmlLabelName(1292,user.getLanguage())%>
				<%}else if(RecordSet.getString("powerlevel").equals("2")){%>
						<%=SystemEnv.getHtmlLabelName(1293,user.getLanguage())%>
				<%}else{%>
						<%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
				<%}%>
		  </TD-->
          <TD><%=RecordSet.getString("reasondesc")%></TD>
          <TD nowrap>
		  <%if(canedit || isResponser){%>
		  <a href="EditPrjCustomer.jsp?ProjID=<%=ProjID%>&taskrecordid=<%=taskrecordid%>&type=2&id=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
		  <%}%>
		  </TD>
        </TR>
<%}%>
		</TBODY>
	</TABLE>
<%if(software.equals("ALL")){%>
<%
topage=URLEncoder.encode( "/proj/process/CptOperation.jsp?method=add&ProjID="+ProjID+"&type=2&taskid="+taskrecordid);
%>
      <TABLE class=liststyle cellspacing=1 >
	<form name=cpt method=post action="/cpt/capital/CptCapital.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=4><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
  		  <%
			//TD2518
			//modified by hubo,2006-03-15
			if(!status_prj.equals("4") && (canedit || isResponser)){%>
		  <A href="javascript:onShowCptRequest();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  <%}%>
		  </TD></TR>

        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
		  <TD style="width:100px"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD>
		</TR>     <TR class=line style="height:1px;">
          <TD  colSpan=6 style="padding:0;"></TD></TR>

<%

/*
sql="select distinct t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status, t3.id as recorderid from workflow_requestbase t1,workflow_currentoperator t2, Prj_Cpt t3 ";
sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" and t3.taskid = "+taskrecordid+" ";
orderby=" order by t1.createdate desc ";
*/

sql="Select t2.id as recorderid,t1.id,t1.mark,t1.name,t1.resourceid,t1.departmentid From CptCapital t1 ,Prj_Cpt t2 where t1.id = t2.requestid  and t2.prjid="+ProjID+" and t2.taskid = "+taskrecordid+" ";
sql=sql+orderby;

//out.println(sql);
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String id = Util.null2String(RecordSet.getString("id"));
	String recorderid = Util.null2String(RecordSet.getString("recorderid"));
	String mark = Util.null2String(RecordSet.getString("mark"));
	String name = Util.null2String(RecordSet.getString("name"));
	String resourceid = Util.null2String(RecordSet.getString("resourceid"));
	String departmentid = Util.null2String(RecordSet.getString("departmentid"));
%>
    <tr class=datadark>


      <td><%=mark%></td>
      <td><a href="/cpt/Capital/CptCapital.jsp?id=<%=id%>"><%=name%></a></td>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></td>
	  <td><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></td>
      <TD nowrap>
		  <%if(canedit || isResponser){%>
		  <a href="/proj/process/CptOperation.jsp?method=del&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&id=<%=recorderid%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
		  <%}%>
	  </TD>
       </tr>

<%}%>
		</TBODY>
	</TABLE>
<%}%>

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
<script type="text/javascript">
	function onShowDoc(){
		datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/proj/process/DocBrowser.jsp");
		if (datas&&datas.id){
			window.location = "/proj/process/DocOperation.jsp?method=add&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&docid="+datas.id;
		}
	}


	function onShowWorkflow(){
		var  wfIDs = $("input[name=requiredWFIDs]");
		var tmpIds="";
		if (wfIDs.length>0 ){
			for (var i=0 ;i< wfIDs.length;i++){
				tmpIds = tmpIds + wfIDs[i].value + ","
			}
			
			tmpIds = tmpIds.substr(1);
		}

		tmpIds2 = "," + tmpIds + ",";
		
		var  oTbl = document.getElementById("tblRequiredWF")
		var  rows = oTbl.rows;
		
		datas = window.showModalDialog("/workflow/WFBrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpIds);
		if (datas){
			if(datas.id!=""&&datas.id!="0"){
				window.location = "/proj/plan/TaskRelatedOperation.jsp?method=addRequiredWF&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&wfIDs="+datas.id;
			}
		}
	}

	function onShowMultiDocsRow(){
		var refdocs = document.getElementsByName("referdocs");
		var tmpIds="";
		for (i=0 ;i< refdocs.length;i++){
			tmpIds = tmpIds + refdocs[i].value + ",";
		}
		tmpIds = tmpIds.substr(1);
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+tmpIds)
		if(datas.id!=""){
			window.location = "/proj/plan/TaskRelatedOperation.jsp?method=addReferencedDoc&ProjID=<%=ProjID%>&taskID=<%=taskrecordid%>&docIDs="+datas.id;
		}
	}

	function onShowRequest(){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1");
		if (datas){
			if (datas.id!= "" && datas.id!="0"){
				window.location = "/proj/process/RequestOperation.jsp?method=add&ProjID=<%=ProjID%>&type=1&taskid=<%=taskrecordid%>&requestid=" +datas.id;
			}
		}
	}

	function onShowCptRequest(){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2")
		if (datas&&datas.id){
			window.location = "/proj/process/CptOperation.jsp?method=add&ProjID=<%=ProjID%>&type=2&taskid=<%=taskrecordid%>&requestid="+datas.id;
		}
	}

	function onShowMRequest(inputname,spanname){
		tmpids =$("input[name="+inputname+"]").val();
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+tmpids);
		if (datas){
			if(datas.id){
				resourceids =datas.id;
				resourcename = datas.name;
				sHtml = "";
				resourceids = resourceids.split(",");
				$("input[name="+inputname+"]").val(resourceids);
				resourcename = resourceids.split(",");
			for(i=0;i<resourceids.length;i++){
				if(resourceids[i]){
					curid = resourceids[i];
					curname = resourcename[i];
					sHtml = sHtml+"<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="+curid&"')>"+curname+"</a>&nbsp"
				}
			}
			$("#"+spanname).html(sHtml);
						
			}else{
				$("#"+spanname).emty();
				$("input[name="+inputname+"]").val("");
			}
		}
	}
</script>
<script language=vbs>






</script>
<script language=vbs>




</script>
<script language=javascript>

function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
    }
    else{
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></a>";
        WorkFlowDiv.style.display = "";
    }
}


function onSelectCategory() {
	var oTbl = document.getElementById("tblRequiredDoc");
	/* returnValue = Array(1, id, path, mainid, subid); */
   var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	if (datas&&datas.id>0) {
	      location = "TaskRelatedOperation.jsp?method=addRequiredDoc&taskID=<%=taskrecordid%>&secID="+datas.id;
	}
}

function modifyRequiredWFNecessary(){
	with(window.event.srcElement){
		checked ? isNecessaryTmp=1 : isNecessaryTmp=0;
		location = "/proj/process/TaskRelatedOperation.jsp?method=modifyRequiredWFN&taskID=<%=taskrecordid%>&wfID="+value+"&isNecessary="+isNecessaryTmp;
	}
}

function modifyRequiredDocNecessary(){
	with(window.event.srcElement){
		checked ? isNecessaryTmp=1 : isNecessaryTmp=0;
		location = "/proj/process/TaskRelatedOperation.jsp?method=modifyRequiredDocN&taskID=<%=taskrecordid%>&secID="+value+"&isNecessary="+isNecessaryTmp;
	}
}

function doDeletePlan(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.delplan.submit();
    }
}
</script>
</BODY>
</HTML>


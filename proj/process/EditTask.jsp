<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/css/xpSpin.css">
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin.js"></script>
<style>
 .xpSpin  span{
   font-family: webdings !important;
   font-size: 9pt;
 }

</style>
</HEAD>

<%
int sign = Util.getIntValue(request.getParameter("sign"),-1);
String taskrecordid = request.getParameter("taskrecordid");
String ProjID=Util.null2String(request.getParameter("ProjID"));
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
String thesql="select manager from Prj_projectInfo where id =  " +ProjID ;
RecordSetM.executeSql(thesql);
RecordSetM.next();
String manager = RecordSetM.getString("manager");

String userid = ""+user.getUID() ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <%if(!(manager.equals(userid))){%>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}else{%>
	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%}%>

	<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/process/ViewTask.jsp?taskrecordid="+taskrecordid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%

if(sign!=-1){//如果从计算天数的页面返回的话

String parentid=Util.null2String(request.getParameter("parentid"));
String parentids=Util.null2String(request.getParameter("parentids"));
String parenthrmids=Util.null2String(request.getParameter("parenthrmids"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String oldhrmid=Util.null2String(request.getParameter("oldhrmid"));
String finish=Util.null2String(request.getParameter("finish"));
String level=Util.null2String(request.getParameter("level"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String islandmark=Util.null2String(request.getParameter("islandmark"));
String pretaskid=Util.null2String(request.getParameter("taskids02"));
String content=Util.null2String(request.getParameter("content"));

// added by lupeng 2004-07-21
String realManDays = Util.null2String(request.getParameter("realmandays"));
// end


//冻结和完成的项目任务不能编辑
/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4")||status_prj.equals("6"))){//项目冻结或者项目完成,待审批
	response.sendRedirect("ViewTask.jsp?taskrecordid="+taskrecordid);
}
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();

/*Add by Huang Yu ON April 22 ,2204##################START###########*/
/*如果状态为删除和新增时，不能再进行编辑*/
int status = RecordSet.getInt("status");
if(status ==1 || status == 3){
	response.sendRedirect("ViewTask.jsp?taskrecordid="+taskrecordid);
	return;
}

/*Add by Huang Yu ON April 22 ,2204##################END###########*/
//String pretaskid=RecordSet.getString("prefinish");
String taskname="";
if(!pretaskid.equals("0")){
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


/*查看是否前置任务都已经完成，若有一个没有完成（100％）那么就不能对此任务进行编辑*/
//==================================================================================
//modified by hubo,20060228,TD3741
int size_t = 0;
String temstr = "";
if(!parentids.equals("")){
	size_t = parentids.length();
	temstr = parentids.substring (0,size_t-1);
}
String sql_Task="select prefinish from Prj_TaskProcess where id in (" + temstr +")";
RecordSet4.executeSql(sql_Task);
String PreTaskid="";
while(RecordSet4.next()){
    if(!((RecordSet4.getString("prefinish")).equals(""))){
        PreTaskid += RecordSet4.getString("prefinish") +",";
    }
}
int size_2 = 0;
String temstr_2 = "";
if(!PreTaskid.equals("")){
	size_2 = PreTaskid.length();
	temstr_2 = PreTaskid.substring (0,size_2-1);
}
//==================================================================================
boolean canedit_finish = true;

    /*查看前置任务的id是否全为零，若全为零说明没有前置任务*/
ArrayList task_0 = Util.TokenizerString(temstr_2,",");
boolean isallzero = true;
int task_size = task_0.size();
for(int j=0;j<task_size;j++ ){
    String is0 =""+ task_0.get(j);
    if(!is0.equals("0")){
        isallzero=false;
    }
}

if(!isallzero){//如果不全为零
//TD4408
//modified by hubo,2006-05-24
//String sql_preTask= "select finish from  Prj_TaskProcess where id in ( " +temstr_2 +")";
String sql_preTask= "select finish from  Prj_TaskProcess where taskindex in ( " +temstr_2 +") AND prjid="+Util.getIntValue(ProjID)+"";
RecordSet4.executeSql(sql_preTask);

while(RecordSet4.next()){
    if(!((RecordSet4.getString("finish")).equals("100"))){
        canedit_finish= false;
    }
}
}
//判断前置任务完毕！！！




//out.print(manager.equals(userid));
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

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+userid;

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

if(!canedit && !isResponser){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>


<FORM id=weaver name=weaver action="/proj/process/TaskOperation.jsp" method=post>
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="type" value="process">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  <input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
  <input type="hidden" name="oldhrmid" value="<%=RecordSet.getString("hrmid")%>">
  <%if(!(manager.equals(userid))){%>
  <input type="hidden" name="submittype" value="0">
  <%}else{%>
  <input type="hidden" name="submittype" value="1">
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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3></TD>
  </TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>

		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=80 size=40 name="subject" value="<%=subject%>" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan></span> </TD>
         </TR>
		  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          
          
          <button type="button" type="button" class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> 
			<span
            id=Hrmidspan>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			</span>
             <INPUT  type="hidden" name="hrmid" value="<%=hrmid%>" 
             	_url="/systeminfo/BrowserMain.jsp?url=/proj/process/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>" >
          </TD>
        </TR>    <TR class=spacing>
    <TD class=line colSpan=2 style="height:1px;"></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" type="button" class=Calendar onclick="getProjPBDate()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">

          </TD>
        </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" type="button" class=Calendar onclick="getProjPEDate()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">

          </TD>
         </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>

  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=workday%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday");onWorkDayChange("workday","begindate","begindatespan","enddate","enddatespan")'>
                            </TD>
         </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>

  <!--added by lupeng 2004-07-21-->
  <TR>
         <TD><%=SystemEnv.getHtmlLabelName(17501,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="realmandays" value="<%=realManDays%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("realmandays")'>
                            </TD>
         </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>
  <!--end-->
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
         <%if(canedit_finish){%>
          <TD class=Field><INPUT type=text class=inputstyle maxLength=3 size=5 name="finish" value="<%=finish%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);checkvalue("<%=finish%>")'>%<SPAN id=finishimage></SPAN></TD>
              <%}else{%>
              <TD class=Field>
              <font class=fontred>0% <%=SystemEnv.getHtmlLabelName(15277,user.getLanguage())%></font>
              </TD>
              <%}%>

         </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=3></TD>
  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=20 name="fixedcost" value="<%=fixedcost%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'><SPAN id=workdayimage></SPAN></TD>
         </TR>  <TR class=spacing>
    <TD class=line colSpan=2  style="height:1px;"></TD>
  </TR>
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
          <TD class=Field>
          	<button type="button" class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span">
             <%=taskname%>

            </span>
		  </TD>


        </TR>  <TR class=spacing  style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>

    <%if(RecordSet.getString("level_n").equals("1")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(islandmark.equals("1")){%> checked <%}%>  ></TD>
        </TR>  <TR class=spacing  style="height:1px;">
    <TD class=line1 colSpan=2></TD>
  </TR>
    <%}%>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%"><%=content%></TEXTAREA></TD>
         </TR>
     </TABLE>
	</TD>
   </TR>
   </TBODY>
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
<script language="javascript">
oldbegindate="";
oldenddate="";
setTimeout("CaculateWorkDay();",50);
function CaculateWorkDay(){
	begindate = document.all("begindate").value;
	enddate = document.all("enddate").value;
	if((begindate!=oldbegindate||enddate!=oldenddate)&&begindate!=""&&enddate!="" && begindate != null && enddate != null){
		oldbegindate = begindate;
		oldenddate = enddate;
		begindateY = begindate.substring(0,begindate.indexOf("-"));
		begindateM = begindate.substring(begindate.indexOf("-")+1,begindate.lastIndexOf("-"))-1;
		begindateD = begindate.substring(begindate.lastIndexOf("-")+1);
		enddateY = enddate.substring(0,enddate.indexOf("-"));
		enddateM = enddate.substring(enddate.indexOf("-")+1,enddate.lastIndexOf("-"))-1;
		enddateD = enddate.substring(enddate.lastIndexOf("-")+1);
		bd = new Date(begindateY,begindateM,begindateD);
		ed = new Date(enddateY,enddateM,enddateD);
		diffdays = Math.floor((ed.valueOf()-ed.getTimezoneOffset()*60000)/(3600*24000))-Math.floor((bd.valueOf()-bd.getTimezoneOffset()*60000)/(3600*24000))+1;
		document.all("workday").value = diffdays;
	}
	setTimeout("CaculateWorkDay();",50);
} 
function onWorkDayChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = document.all(workLongObj).value
	beginDate = document.all(beginDateObj).value
	endDate = document.all(endDateObj).value
	
	if(workLong!=""&&beginDate!=""){
		newDate = getAddNewDateStr(beginDate,workLong);
		document.all(spanEndDateObj).innerHTML=newDate;
		document.all(endDateObj).value=newDate;
		return;
	}

	if (workLong!=""&&endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong);
		document.all(spanBeginDateObj).innerHTML=newDate;
		document.all(beginDateObj).value=newDate;
		return;
	}
}
function submitData()
{
	if (check_form(weaver,'tsubject,hrmid')&&checkDateRange(weaver.begindate,weaver.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		weaver.submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>



<%}else{


RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
ProjID = RecordSet.getString("prjid");


/*Add by Huang Yu ON April 22 ,2204##################START###########*/
/*如果状态为删除和新增时，不能再进行编辑*/
int status = RecordSet.getInt("status");
//System.out.println("status = "+status);
if(status ==1 || status == 3){
	response.sendRedirect("ViewTask.jsp?taskrecordid="+taskrecordid);
	return;
}

/*Add by Huang Yu ON April 22 ,2204##################END###########*/

String pretaskid=RecordSet.getString("prefinish");
String taskname="";
if(!pretaskid.equals("0")){
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



/*查看是否前置任务都已经完成，若有一个没有完成（100％）那么就不能对此任务进行编辑*/
String parentids= RecordSet.getString("parentids");
parentids = parentids.startsWith("'") ? parentids.substring(1,parentids.length()) : parentids;
parentids = parentids.endsWith("'") ? parentids.substring(0,parentids.length()-1) : parentids;
//==================================================================================
//modified by hubo,20060228,TD3741
int size_t = 0;
String temstr = "";
if(!parentids.equals("")){
	size_t = parentids.length();
	temstr = parentids.substring (0,size_t-1);
}
String sql_Task="select prefinish from Prj_TaskProcess where id in (" + temstr +")";
RecordSet4.executeSql(sql_Task);
String PreTaskid="";
while(RecordSet4.next()){
    if(!((RecordSet4.getString("prefinish")).equals(""))){
        PreTaskid += RecordSet4.getString("prefinish") +",";
    }
}
int size_2 = 0;
String temstr_2 = "";
if(!PreTaskid.equals("")){
	size_2 = PreTaskid.length();
	temstr_2 = PreTaskid.substring (0,size_2-1);
}
//==================================================================================
boolean canedit_finish = true;

    /*查看前置任务的id是否全为零，若全为零说明没有前置任务*/
ArrayList task_0 = Util.TokenizerString(temstr_2,",");
boolean isallzero = true;
int task_size = task_0.size();
for(int j=0;j<task_size;j++ ){
    String is0 =""+ task_0.get(j);
    if(!is0.equals("0")){
        isallzero=false;
    }
}

if(!isallzero){//如果不全为零
//TD4408
//modified by hubo,2006-05-24
//String sql_preTask= "select finish from  Prj_TaskProcess where id in ( " +temstr_2 +")";
String sql_preTask= "select finish from  Prj_TaskProcess where taskindex in ( " +temstr_2 +") AND prjid="+Util.getIntValue(ProjID)+"";

RecordSet4.executeSql(sql_preTask);

while(RecordSet4.next()){
    if(!((RecordSet4.getString("finish")).equals("100"))){
        canedit_finish= false;
    }
}
}
//判断前置任务完毕！！！



//out.print(manager.equals(userid));
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

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+userid;

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

if(!canedit && !isResponser){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

%>

<FORM id=weaver name=weaver action="/proj/process/TaskOperation.jsp" method=post >

  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="type" value="process">
  <input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("prjid")%>">
  <input type="hidden" name="parentids" value="<%=RecordSet.getString("parentids")%>">
  <input type="hidden" name="oldhrmid" value="<%=RecordSet.getString("hrmid")%>">
  <%if(!(manager.equals(userid))){%>
  <input type="hidden" name="submittype" value="0">
  <%}else{%>
  <input type="hidden" name="submittype" value="1">
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
          <TD class=Field><INPUT class=inputstyle maxLength=80 size=40 name="subject" value="<%=RecordSet.getString("subject")%>" onChange="checkinput('subject','subjectspan')"> <span
            id=subjectspan></span> </TD>
         </TR>  <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Browser id=SelectHrmid onClick="onShowHrmid()"></BUTTON> <span
            id=Hrmidspan>
				<%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>"><%}%><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmid")),user.getLanguage())%><%if(user.getLogintype().equals("1")){%></a><%}%>
			</span>
			 <INPUT class=inputstyle type=hidden name="hrmid" value="<%=RecordSet.getString("hrmid")%>"></TD>
              </TD>
        </TR>    <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getcalBeWorkday()"></BUTTON>
              <SPAN id=begindatespan >
				  <%if(!RecordSet.getString("begindate").equals("x")){%>
						<%=RecordSet.getString("begindate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="begindate" id="begindate" value="<%=RecordSet.getString("begindate")%>">

          </TD>
        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <button type="button" class=Calendar onclick="getcalEeWorkday()"></BUTTON>
              <SPAN id=enddatespan >
				  <%if(!RecordSet.getString("enddate").equals("-")){%>
						<%=RecordSet.getString("enddate")%>
				  <%}%>
			  </SPAN>
              <input type="hidden" name="enddate" id="enddate" value="<%=RecordSet.getString("enddate")%>">

          </TD>
         </TR>
		 <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
			
<!--ActualBeginDate,ActualEndDate-->
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
   <TD class=Field>
		<button type="button" class=Calendar onclick="getActualBDate()"></BUTTON>
      <SPAN id="actualBeginDateSpan"><%=RecordSet.getString("actualBeginDate")%></SPAN>
      <input type="hidden" name="actualBeginDate" id="actualBeginDate" value="<%=RecordSet.getString("actualBeginDate")%>">
   </TD>
</TR>  
<TR class=spacing style="height:1px;"><TD class=line colSpan=2></TD></TR>
<TR>
   <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
   <TD class=Field>
		<button type="button" class=Calendar onclick="getActualEDate()"></BUTTON>
      <SPAN id="actualEndDateSpan"><%=RecordSet.getString("actualEndDate")%></SPAN>
      <input type="hidden" name="actualEndDate" id="actualEndDate" value="<%=RecordSet.getString("actualEndDate")%>">
   </TD>
</TR>  
<TR class=spacing  style="height:1px;"><TD class=line colSpan=2></TD></TR>
<!--ActualBeginDate,ActualEndDate-->
			

			
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
          <TD class=Field><INPUT readonly="true" class=inputstyle maxLength=5 size=5 name="workday" value="<%=RecordSet.getString("workday")%>" ><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <!--added by lupeng 2004-07-21-->
  <TR>
         <TD><%=SystemEnv.getHtmlLabelName(17501,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="realmandays" value="<%=RecordSet.getString("realManDays")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("realmandays")'>
                            </TD>
         </TR>  <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2></TD>
  </TR>
  <!--end-->
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
         <%if(canedit_finish){%>
         <TD class=Field>
				<!--<INPUT type=text class=inputstyle maxLength=3 size=5 name="finish" value="<%=RecordSet.getString("finish")%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);checkvalue("<%=RecordSet.getString("finish")%>")'>%<SPAN id=finishimage></SPAN>-->
				<%
				String tfinish = RecordSet.getString("finish");
				int max = 100;
				String imageStyle = "";
				boolean hasUnFinishedDoc = false;
				boolean hasUnFinishedWF = false;
				boolean hasUnNewFinishdedDoc = false;//判断文档状态
				String sql = "";
				
				sql =	 "SELECT docSecCategory FROM prj_task_needdoc ";
				sql += "WHERE taskid="+taskrecordid+" AND isNecessary=1 AND docSecCategory NOT IN(SELECT secid FROM prj_doc WHERE taskid="+taskrecordid+" AND secid IS NOT NULL)";	
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnFinishedDoc = true;

				sql = "select t1.docstatus t1 from DocDetail t1 ,prj_doc t2  ";
				sql +="where t2.taskid ="+taskrecordid+" and t1.id = t2.docid and t1.docstatus not in (1,2,5,7,8)";
				//System.out.println("sqlDoc:"+sql);
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnNewFinishdedDoc = true;

				sql =	 "SELECT workflowid FROM prj_task_needwf ";
					
				sql += "WHERE taskid="+taskrecordid+" AND isNecessary=1 AND workflowid NOT IN("+
				"SELECT a.workflowid FROM prj_request a,workflow_requestbase b "+
                   "WHERE a.taskid ="+taskrecordid+
                     " AND a.workflowid IS NOT NULL "+
	     			 " and a.requestid=b.requestid)";	
				RecordSetR.executeSql(sql);
				if(RecordSetR.next())	hasUnFinishedWF = true;

				if(hasUnFinishedDoc || hasUnFinishedWF||hasUnNewFinishdedDoc){max=99;imageStyle="visible";}else{imageStyle="hidden";}
				if(max==99&&"100".equals(tfinish))
				{
					String updatetask = "update Prj_TaskProcess set finish=99 where id="+taskrecordid +" and finish=100";
					tfinish = "99";
					RecordSetR.executeSql(updatetask);
				}
				%>
				<input  class="spin height" type="text" onkeypress="ItemNum_KeyPress('finish')" onblur="checknumber('finish')" id="finish" name="finish"  min="0" max="<%=max%>" value="<%=tfinish%>">%
				<!--  
				<span class="xpSpin" id="finish" min="0" max="<%=max%>" value="<%=tfinish %>" style="font-size:12px;font-family:MS Shell Dlg;height:20px;width:59px;"></span>&nbsp;
				-->
				<img src="/images/BacoError.gif" align="absmiddle" style="visibility:<%=imageStyle%>">
			</TD>
         <%}else{%>
         <TD class=Field>
				<font class=fontred>0% <%=SystemEnv.getHtmlLabelName(15277,user.getLanguage())%></font>
         </TD>
         <%}%>

         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=20 size=20 name="fixedcost" value="<%=RecordSet.getString("fixedcost")%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'><%=SystemEnv.getHtmlLabelName(15279,user.getLanguage())%><SPAN id=workdayimage></SPAN></TD>
         </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
          <TD class=Field>
          	<button type="button" class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskrecordid')"></button>
			<input type=hidden name="taskids02" value="<%=pretaskid%>">
			<span id="taskids02span">
             <%=taskname%>

            </span>
		  </TD>


        </TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

    <%if(RecordSet.getString("level_n").equals("1")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2232,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=checkbox name="islandmark" value=1  <%if(RecordSet.getString("islandmark").equals("1")){%> checked <%}%>  ></TD>
        </TR><TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
    <%}%>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%"><%=RecordSet.getString("content")%></TEXTAREA></TD>
         </TR>
     </TABLE>
	</TD>
   </TR>
   </TBODY>
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
<script language=javascript>
function checkvalue(prevalue){
    check_value=eval(toFloat(document.all("finish").value,0));

    if(check_value>100 ){
        alert("<%=SystemEnv.getHtmlLabelName(15278,user.getLanguage())%>！");
        document.all("finish").value=prevalue;
    }
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}


</script>
<script language="javascript">
oldbegindate="";
oldenddate="";
setTimeout("CaculateWorkDay();",50);
function CaculateWorkDay(){
	begindate = document.all("begindate").value;
	enddate = document.all("enddate").value;
	if((begindate!=oldbegindate||enddate!=oldenddate)&&begindate!=""&&enddate!="" && begindate != null && enddate != null){
		oldbegindate = begindate;
		oldenddate = enddate;
		begindateY = begindate.substring(0,begindate.indexOf("-"));
		begindateM = begindate.substring(begindate.indexOf("-")+1,begindate.lastIndexOf("-"))-1;
		begindateD = begindate.substring(begindate.lastIndexOf("-")+1);
		enddateY = enddate.substring(0,enddate.indexOf("-"));
		enddateM = enddate.substring(enddate.indexOf("-")+1,enddate.lastIndexOf("-"))-1;
		enddateD = enddate.substring(enddate.lastIndexOf("-")+1);
		bd = new Date(begindateY,begindateM,begindateD);
		ed = new Date(enddateY,enddateM,enddateD);
		diffdays = Math.floor((ed.valueOf()-ed.getTimezoneOffset()*60000)/(3600*24000))-Math.floor((bd.valueOf()-bd.getTimezoneOffset()*60000)/(3600*24000))+1;
		document.all("workday").value = diffdays;
	}
	setTimeout("CaculateWorkDay();",50);
} 
function onWorkDayChange(workLongObj,beginDateObj,spanBeginDateObj,endDateObj,spanEndDateObj){
	workLong = document.all(workLongObj).value
	beginDate = document.all(beginDateObj).value
	endDate = document.all(endDateObj).value
	
	if(workLong!=""&&beginDate!=""){
		newDate = getAddNewDateStr(beginDate,workLong);
		document.all(spanEndDateObj).innerHTML=newDate;
		document.all(endDateObj).value=newDate;
		return;
	}

	if (workLong!=""&&endDate!=""){
		newDate = getSubtrNewDateStr(endDate,workLong);
		document.all(spanBeginDateObj).innerHTML=newDate;
		document.all(beginDateObj).value=newDate;
		return;
	}
} 
function submitData()
{
	if (check_form(weaver,'subject,hrmid')&&checkDateRange(weaver.begindate,weaver.enddate,"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")) {
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		weaver.submit();
	}
}

</script>
</BODY>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript"  type='text/vbScript' src="/js/projTask/ProjTask.vbs"></SCRIPT> 
</HTML>
<%}%>
<%@include file="/hrm/include.jsp"%>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData.js"></script>

<script type="text/javascript">

function onShowHrmid(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>");
	if (data){
		if (data.id){
			$("#Hrmidspan").html( "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			$("input[name=hrmid]").val(data.id);
		}else{
			$("#Hrmidspan").html("");
			$("input[name=hrmid]").val("");
		}
	}
}



function onShowMTask(spanname,inputename,prj,task){
        ProjID = $("input[name="+prj+"]").val();
        taskrecordid = $("input[name="+task+"]").val();
		taskids = $("input[name="+inputename+"]").val();
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid);
        if (data){
				if(data.id){
					task_ids = data.id.split(",");
					taskname = data.name.split(",");
					sHtml="";
					for(var i=0;i<task_ids.length;i++){
						if(task_ids[i]){
							sHtml = sHtml+"<a href=/proj/process/ViewTask.jsp?taskrecordid="+task_ids[i]+">"+taskname[i]+"</a>&nbsp";
						}
					}
					$("#"+spanname).html( sHtml);
					$("input[name="+inputename+"]").val(data.id);
				}else{
					$("#"+spanname).html( "");
					$("input[name="+inputename+"]").val("");
				}
	}
}


function checkvalue(prevalue){
    check_value=eval(toFloat(document.all("finish").value,0));

    if(check_value>100 ){
        alert("<%=SystemEnv.getHtmlLabelName(15278,user.getLanguage())%>！");
        document.all("finish").value=prevalue;
    }
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
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
            $this.val(max);
          else{
            value =parseInt(value); 
            if(value>max)
               $this.val(max);
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

</script>
<script>
function protectTask() {
	if(!checkDataChange())
  	event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
document.body.onbeforeunload=function () {protectTask();}
difInput('finish','%');//finish的特殊用法
</script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
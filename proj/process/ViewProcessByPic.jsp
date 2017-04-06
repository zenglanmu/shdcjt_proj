<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.teechart.TeeChart" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectProcessList" class="weaver.proj.Maint.ProjectProcessList" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
TeeChart teechart=new TeeChart();
String chartstr = teechart.ChartBaseSet() ;              // 图片基本属性的字符串
String chartvaluestr = "" ;         // 图片值的字符串
String prjname="";

String islandmark = Util.null2String(request.getParameter("islandmark"));
//out.print(islandmark);
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
int Version=0;
String ProjID = Util.null2String(request.getParameter("ProjID"));
RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProjID);
if(!RecordSet.next()){
	response.sendRedirect("/proj/plan/NewPlan.jsp?log=n&ProjID="+ProjID) ;
}

/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID+"order by id";
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isCurrentActived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

String taskrecordid="";

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false; //能否查看
boolean canedit=false; //能否编辑
boolean iscreater=false; //是否是创建者
boolean ismanager=false; //是否是项目经理
boolean ismanagers=false; //是否是项目经理的经理
boolean ismember=false; //是否是成员
boolean isrole=false; 
boolean isshare=false;
String iscustomer="0";

String ViewSql="select * from PrjShareDetail where prjid="+ProjID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);
//out.print(ViewSql);
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

if(ismanager){
    if((""+user.getUID()).equals(""+user.getManagerid())){
        ismanagers=true;
    }
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/



String log = Util.null2String(request.getParameter("log"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));

if(level.equals("")){
	level = "10" ;
}
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
String members=RecordSet.getString("members"); 


prjname=RecordSet.getString("name");
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(1338,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(prjname,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and  level_n <= 10 and isdelete<>'1' ";
if(!subject.equals("")){
	sqlwhere+=" and subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and hrmid='"+hrmid+"'";
}
    sqlwhere+=" and level_n<="+level;
// 添加选择当前最大的显示顺序的取得(根据parentid) 
String sqlstr = "" ;
ArrayList theparentmaxdsporder = null ;
if(!islandmark.equals("1")) {
    theparentmaxdsporder = new ArrayList() ;
    String sqlmaxorderstr = " select max(dsporder) , parentid from Prj_TaskProcess " + sqlwhere + 
                            " group by parentid " ;
    RecordSet.executeSql(sqlmaxorderstr);
    while( RecordSet.next() ) {
        String maxdsporder = ""+Util.getIntValue(RecordSet.getString(1),0) ;
        String theparentid = Util.null2String(RecordSet.getString(2)) ;
        theparentmaxdsporder.add(theparentid+"_"+maxdsporder) ;
    }
    sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " order by parentid , dsporder";
}
else {
    sqlstr = " SELECT * FROM Prj_TaskProcess " +sqlwhere+ " and islandmark='1' order by parentid, dsporder ";
}

//System.out.println("sqlstr :"+sqlstr);
ProjectProcessList.getProcessList(sqlstr) ;

String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;

ArrayList requesttaskids=new ArrayList();
ArrayList requesttaskcounts=new ArrayList();
ArrayList doctaskids=new ArrayList();
ArrayList doctaskcounts=new ArrayList();

sqlstr="select t3.taskid, count(distinct t3.requestid) from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		requesttaskids.add(RecordSetC.getString(1));
		requesttaskcounts.add(RecordSetC.getString(2));
}

sqlstr="SELECT t3.taskid, count(distinct t3.docid) FROM DocDetail  t1, DocShareDetail t2, Prj_Doc t3  where t1.id = t2.docid and t2.userid = "+CurrentUser + " and t1.id = t3.docid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		doctaskids.add(RecordSetC.getString(1));
		doctaskcounts.add(RecordSetC.getString(2));
}

ProcPara = ProjID + flag + "0" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
%>
<BODY onload="FillChart()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>




<DIV>
<%
// add by dongping for Fixed BUG728
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javaScript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:submitPic(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%if(ProjectProcessList.getCounts()>0 && canedit){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1348,user.getLanguage())+",/proj/process/ProjNotice.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%if(ProjectProcessList.getCounts()>0){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1349,user.getLanguage())+",/proj/process/DspMember.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+",/proj/process/DspRequest.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+",/proj/process/DspDoc.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(407,user.getLanguage())+SystemEnv.getHtmlLabelName(522,user.getLanguage())+",/proj/plan/ViewPlan.jsp?ProjID="+ProjID+"&log=n,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1297,user.getLanguage())+",/proj/report/PlanAndProcess.jsp?ProjID="+ProjID+"&log=n,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%if(ismanager){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2100,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=saveasplan,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}%>
<%if(isCurrentActived.equals("2")  && ismanagers ){ /*在项目已经立项批准的情况下经理可以进行：正常，延期，完成，冻结等操作 */ %>
   
   <%
   //modify by dongping for TD730
  /* RCMenu += "{"+SystemEnv.getHtmlLabelName(587,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=normal,_self} " ;
   RCMenuHeight += RCMenuHeightStep;

RCMenu += "{|"+SystemEnv.getHtmlLabelName(2228,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=normal,_self} " ;

RCMenu += "{|"+SystemEnv.getHtmlLabelName(2229,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=delay,_self} " ;

RCMenu += "{|"+SystemEnv.getHtmlLabelName(2230,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=complete,_self} " ;

RCMenu += "{|"+SystemEnv.getHtmlLabelName(2231,user.getLanguage())+",/proj/plan/PlanOperation.jsp?ProjID="+ProjID+"&method=freeze,_self} " ;*/

%>

<%}%>
 <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15275,user.getLanguage())+",/proj/data/ViewTaskLog.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
 <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2232,user.getLanguage())+",/proj/process/ViewProcess.jsp?ProjID="+ProjID+"&&islandmark=1,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=weaver id=weaver method=post action="/proj/process/ViewProcessByPic.jsp">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  

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

<table class=liststyle cellspacing=1 >
  <tr class=datadark>
     <td width="60"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select  name=level size=1 class=inputstyle   onChange="weaver.submit()">
		 <%for(int i=1;i<=10;i++){%>
			 <option value="<%=i%>" <%if(level.equals(""+i)){%>selected<%}%>><%=i%></option>
		 <%}%>
		 </select>	 
	 </td>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
     <td class=field>&nbsp
		<input name=subject size=15 class="InputStyle" value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>">	 
	 </td>
     <TD align=right><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate01span,begindate01)></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">
			  －	<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate02span,begindate02)></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		  
	</TD>
     <TD align=right><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate01span,enddate01)></BUTTON>&nbsp;
			  <SPAN id=enddate01span ><%=enddate01%></SPAN>
			  <input type="hidden" name="enddate01" value="<%=enddate01%>">
			  －	<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate02span,enddate02)></BUTTON>&nbsp;
			  <SPAN id=enddate02span ><%=enddate02%></SPAN>
			  <input type="hidden" name="enddate02" value="<%=enddate02%>">
		  
	</TD>
     <td width="60" align=right><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
     <td class=field>&nbsp
		<select   name=hrmid size=1 class=inputstyle   onChange="weaver.submit()">
			 <option value="" <%if(hrmid.equals("")){%>selected<%}%>></option>
		 <%while(RecordSetHrm.next()){%>
			 <option value="<%=RecordSetHrm.getString("hrmid")%>" <%if(RecordSetHrm.getString("hrmid").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("hrmid"))%></option>
		 <%}%>
		 </select>	 
	 </td>
  </tr>
</table>
</form>
<%
teechart.SetFooterText(prjname+SystemEnv.getHtmlLabelName(18820,user.getLanguage()));
//teechart.SetVTitle("任务");
//teechart.SetHTitle("时间");
chartvaluestr+=teechart.FillChart();
chartvaluestr+=teechart.DrawGanttStyle();
int counts=0;
int order=ProjectProcessList.getCounts();
while(ProjectProcessList.next()) {
        String pbegindate=ProjectProcessList.getBegindate();
        String penddate=ProjectProcessList.getEnddate();
        if(pbegindate!=null && !pbegindate.equals("") && !pbegindate.equals("x") && penddate!=null && !penddate.equals("") && !penddate.equals("-")){
        chartvaluestr+=teechart.DrawGanttData(pbegindate,penddate,order,ProjectProcessList.getSubject());
        counts++;
        order--;
        }        
}
%>
<table border="0" width="100%" >
<tr>
    <td align="center" width="100%" style="display:none">
            <OBJECT align=textTop 
            classid=CLSID:BEE97215-8536-11D2-808C-006097385FF5 
            data=data:application/x-oleobject;base64,FXLpvjaF0hGAjABglzhf9VRQRjANVFRlZUNvbW1hbmRlcgAETGVmdAIAA1RvcAIABVdpZHRoA2cCBkhlaWdodAIgAAA= 
            height=32 id=TeeCommander0 name=TeeCommander0  width="<%=teechart.GetPicwidth()%>" codebase="/weaverplugin/teechart.ocx#version=4,0,0,0"></OBJECT>
    </td>
  </t>
<tr>
    <td align="center" width="100%">
            <OBJECT classid=CLSID:008BBE7E-C096-11D0-B4E3-00A0C901D681 
            data=data:application/x-oleobject;base64,fr6LAJbA0BG04wCgyQHWgVRQRjAKVE9EQkNDaGFydAAETGVmdAIAA1RvcAIABVdpZHRoA2MCBkhlaWdodAMMARRCYWNrV2FsbC5CcnVzaC5Db2xvcgcHY2xXaGl0ZRRCYWNrV2FsbC5CcnVzaC5TdHlsZQcHYnNDbGVhchJUaXRsZS5UZXh0LlN0cmluZ3MBBghUZWVDaGFydAAAAAAAAAABAAAAAA== 
            height="<%=((counts*25)<400)?400:(counts*25)%>" width="100%" id="Chart0" name="Chart0" type="application/x-oleobject" 
            codebase="/weaverplugin/teechart.ocx#version=4,0,0,0"></OBJECT>
    </td>
  </tr>
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

		



<script language=vbs>
Sub Chart0_OnDblClick()
  //Chart0.ShowEditor
end sub

Sub ChartBaseSet
<%=chartstr%>
FillChart()

End sub
SUB FillChart
<%=chartvaluestr%>
END SUB

sub getProj(prjid)
	returndate =  window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ProjNotice.jsp?ProjID="&prjid)

   
end sub
ChartBaseSet()

</script>

<script language=javascript >
function submitPic(){
    weaver.action="ViewProcess.jsp";
    weaver.submit();
}
function rankclick(targetId)
{    
  
		var objSrcElement = window.event.srcElement;
    if (document.all(targetId)==null) {

           objSrcElement.src = "/images/project_rank1.gif";

	} else {
         var targetElement = document.all(targetId);

          if (targetElement.style.display == "none") 
		{
             objSrcElement.src = "/images/project_rank1.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2.gif";
             targetElement.style.display = "none";
		}
	}

}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>

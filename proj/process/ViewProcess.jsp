<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
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
<%@ include file="/docs/common.jsp" %>

<HTML><HEAD>
<style type="text/css">
.redgraph td,greengraph td {
	background:none!important;
}
.greengraph tbody tr td,.redgraph tbody tr td{
	background:none!important;
	background-image:none!important;
	background-color:none!important;
}

</style>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var e;
var rowsNum = 0;
var tbl;
var imgIDs = "";
window.onload = function(){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;

	var aImgIDs = imgIDs.split(",");
	for(var i=0; i<aImgIDs.length; i++){
		try{setImgSrc(aImgIDs[i])}catch(e){}
	}
}

function toggleChild(tr, children){
	for(var i=0; i<children.length; i++){
		var child = children[i];
		var childType = getChildType(child);
		var clicked = child.getAttribute("clicked");
		//alert(child+","+childType+","+clicked);
		if(childType=="node" && clicked=="false"){
			toggleChild(child, getChildren(child));
		}
		child.style.display = tr.open=="true" ? "none" : "";
	}
	changeImg(tr);
}

function changeImg(tr){
	var img = document.getElementById("img"+tr.id);
	if(tr.open=="true"){
		img.src = img.src.replace("rank1", "rank2");
	}else{
		img.src = img.src.replace("rank2", "rank1");
	}
	tr.open = tr.open=="true" ? "false" : "true";
}

function getChildType(tr){
	var type;
	var level = tr.getAttribute("level");
	var _level;
	try{
		_level = tbl.rows(tr.rowIndex+1).getAttribute("level");
		if(_level==parseInt(level)+1){
			type = "node";
		}else{
			type = "leaf";
		}
	}catch(e){
		type = "leaf";
	}
	return type;
}

function getChildren(tr){
	tbl = document.getElementById("mytbl");
	if(!tbl) return;
	rowsNum = tbl.rows.length;
	
	var children = new Array();
	var level = tr.getAttribute("level");
	var _level = -1;
	for(var i=tr.rowIndex+1; i<rowsNum; i++){
		_level = tbl.rows[i].getAttribute("level");
		if(_level==parseInt(level)+1){
			children.push(tbl.rows[i]);
		}else if(level==_level){
			break;
		}else{
			continue;
		}
	}
	return children;
}

function setImgSrc(trId){
	
	var tr = document.getElementById(trId);
	var o = document.getElementById("img"+trId);
	var trType = getChildType(tr);
	o.src = trType=="leaf" ? o.src.replace("rank2", "rank1") : o.src.replace("rank1", "rank2");
	
	//changeImg(document.getElementById(trId));
}
</script>
</HEAD>
<%

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
	//response.sendRedirect("/proj/plan/NewPlan.jsp?log=n&ProjID="+ProjID) ;
%>
	<script>
	window.location="/proj/plan/NewPlan.jsp?log=n&ProjID=<%=ProjID%>";
	</script>
<%
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



String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(1338,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+ProjID+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

String sqlwhere="";
sqlwhere=" where prjid = "+ProjID+" and  level_n <= 10 and isdelete<>'1' ";
if(!subject.equals("")){
	sqlwhere+=" and subject like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and actualBeginDate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and actualBeginDate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and actualEndDate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and actualEndDate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and hrmid='"+hrmid+"'";
}

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

sqlstr="SELECT t3.taskid, count(distinct t3.docid) FROM DocDetail  t1, "+tables+" t2, Prj_Doc t3  where t1.docstatus in ('1','2','5') and t1.id = t2.sourceid  and t1.id = t3.docid  and t3.prjid = "+ProjID+" group by t3.taskid ";
RecordSetC.executeSql(sqlstr);
while(RecordSetC.next()){
		doctaskids.add(RecordSetC.getString(1));
		doctaskcounts.add(RecordSetC.getString(2));
}

ProcPara = ProjID + flag + "0" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>




<DIV>
<%
// add by dongping for Fixed BUG728
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18820,user.getLanguage())+",javaScript:submitPic(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%if(canedit&&!status_prj.equals("3")&&!status_prj.equals("4")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1342,user.getLanguage())+",/proj/process/AddTask.jsp?ProjID="+ProjID+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}%>
<%if(ProjectProcessList.getCounts()>0 && canedit){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1348,user.getLanguage())+",/proj/process/ProjNotice.jsp?ProjID="+ProjID+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

	<!-- BUTTON AccessKey=B CLASS=btn onclick="if(issubmit()){location='/proj/plan/PlanOperation.jsp?ProjID=<%=ProjID%>&method=tellmember'}"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1348,user.getLanguage())%></BUTTON -->
   <!-- <BUTTON AccessKey=B CLASS=btn onclick='getProj("<%=ProjID%>")'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1348,user.getLanguage())%></BUTTON > -->
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
<form name=weaver id=weaver method=post action="/proj/process/ViewProcess.jsp">
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
     <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate01span,begindate01)></BUTTON>&nbsp;
			  <SPAN id=begindate01span ><%=begindate01%></SPAN>
			  <input type="hidden" name="begindate01" value="<%=begindate01%>">
			  －	&nbsp;<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(begindate02span,begindate02)></BUTTON>&nbsp;
			  <SPAN id=begindate02span ><%=begindate02%></SPAN>
			  <input type="hidden" name="begindate02" value="<%=begindate02%>">
		  
	</TD>
     <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
     <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate01span,enddate01)></BUTTON>&nbsp;
			  <SPAN id=enddate01span ><%=enddate01%></SPAN>
			  <input type="hidden" name="enddate01" value="<%=enddate01%>">
			  －	&nbsp;<BUTTON class=calendar id=SelectDate onclick=getProjSubDate(enddate02span,enddate02)></BUTTON>&nbsp;
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
boolean isLight = false;
if(ProjectProcessList.getCounts()>0){
	RecordSet2.executeProc("Prj_TaskProcess_Sum",ProjID);
	RecordSet2.next();
%>
<TABLE class=liststyle cellspacing=1  id="mytbl">
<TBODY>
  <colgroup> 
  <col width="30%">
  <col width="10%">
  <col width="7%">
  <col width="6%">  
  <col width="6%"> 
  <col width="5%">
  <col width="10%">
  <col width="10%">
  <col width="7%">
  <col width="9%">
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2238,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())//协作%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></th>
          <th nowrap colspan=2><%=SystemEnv.getHtmlLabelName(2237,user.getLanguage())%></th>	      
		  <th nowrap><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></th>
	      <th nowrap><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></th>
		  <th nowrap><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
          <th nowrap><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></th>          
	    </TR>
	    <TR class=Header>
	      <th>Total</th>
		  <th nowrap>&nbsp;</th>
		  <th nowrap>&nbsp;</th>
          <th nowrap height=100%> 
            <%
                int finishint=(int)(Util.getDoubleValue(RecordSet2.getString("finish")));
              if(finishint!=0){  
                if( Util.getDoubleValue(RecordSet2.getString("finish"))<1 && Util.getDoubleValue(RecordSet2.getString("finish")) >0 ) finishint = 1;
            %>
                <TABLE height="100%" cellSpacing=1 
                    <%if(finishint==100){%>
                    class=redgraph 
                    <%}else{%>
                    class=greengraph 
                    <%}%>
                    width="<%=finishint%>%"> </tr> 
				           <tr class="Line redgraph"><td colspan="11"></td></tr>	                     
                 </TABLE>
            <%}%>
          </th>	
          <th><%=finishint%>%</th>
		  <th nowrap><%=RecordSet2.getString("workday")%></th>
		  <th nowrap><%if(!RecordSet2.getString("actualBeginDate").equals("x")){%><%=RecordSet2.getString("actualBeginDate")%><%}%></th>
		  <th nowrap><%if(!RecordSet2.getString("actualEndDate").equals("-")){%><%=RecordSet2.getString("actualEndDate")%>		  <%}%></th>

		  <th nowrap>&nbsp;</th>
          <th nowrap><%=(RecordSet2.getString("fixedcost"))%> </th>          
	    </TR>

<%
int prelevel=1;
String prerecid="";
while(ProjectProcessList.next()) {
	boolean isResponser=false;
	if( (ProjectProcessList.getParenthrmids()).indexOf(","+user.getUID()+"|")!=-1 && user.getLogintype().equals("1") ){
	  isResponser=true;
	}
%>
   <%/*##################显示任务列表开始##########################*/%>
	<TR CLASS=<%if(isLight){%>DataLight<%}else{%>DataDark<%}%>
		id="<%=ProjectProcessList.getId()%>" 
		level="<%=Util.getIntValue(ProjectProcessList.getLevel_n())%>" 
		clicked="false" 
		<%
		if(Util.getIntValue(ProjectProcessList.getLevel_n())>Util.getIntValue(level)){
			out.print(" style=\"display:none\" open=\"true\" ");
		}else{
			out.print(" style=\"display:\" open=\"true\" ");
		}
		%>>
          <TD>
			<%for(int i=1;i<Util.getIntValue(ProjectProcessList.getLevel_n());i++){%>&nbsp&nbsp&nbsp&nbsp<%}%>
			<img id="img<%=ProjectProcessList.getId()%>" 
				src="/images/project_rank1.gif"
				class="project_rank"  
				onmouseup='rankclick("taskdiv<%=ProjectProcessList.getId()%>")'>
				<%if(Util.getIntValue(ProjectProcessList.getLevel_n())==Util.getIntValue(level)){%> 
					<script type="text/javascript">imgIDs+="<%=ProjectProcessList.getId()%>,";</script>
				<%}%>
				<a href="/proj/process/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>" ><%=ProjectProcessList.getSubject()%></a>&nbsp;&nbsp;
            <%
                String prefinish= ProjectProcessList.getPrefinish();
                if(!prefinish.equals("0")){%> 
                    <img src="/images/ArrowUpGreen.gif" width="7" height="10">
                 <%}
				/*在项目任务后生成任务更改状态的信息*/
				/*Modified by Huang Yu On April 21,2004########START####*/
				int status = Integer.valueOf(ProjectProcessList.getStatus()).intValue();
				switch(status){
					//================================================================================
					//TD2521
					//modified by hubo,2006-03-19
					case 0:  /*正常*/
						if(ismanager || ismanagers){
							out.println("<a href=\"ProjectTaskApprovalDetail.jsp?TaskID="+ProjectProcessList.getId()+"\">"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</a>");
						}else{
							out.println(SystemEnv.getHtmlLabelName(225,user.getLanguage()));
						}
						break;
					case 1: /*增加，待审批*/
						if(ismanager || ismanagers){
							out.println("<a href=\"ProjectTaskApprovalDetail.jsp?TaskID="+ProjectProcessList.getId()+"\">"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(456,user.getLanguage())+")");
						}else{
							out.println(SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(456,user.getLanguage())+")");
						}
						break;
					case 2: /*修改，待审批*/
						if(ismanager || ismanagers){
							out.println("<a href=\"ProjectTaskApprovalDetail.jsp?TaskID="+ProjectProcessList.getId()+"\">"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(103,user.getLanguage())+")");
						}else{
							out.println(SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(103,user.getLanguage())+")");
						}
						break;
					case 3: /*删除，待审批*/
						if(ismanager || ismanagers){
							out.println("<a href=\"ProjectTaskApprovalDetail.jsp?TaskID="+ProjectProcessList.getId()+"\">"+SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"</a>("+SystemEnv.getHtmlLabelName(91,user.getLanguage())+")");
						}else{
							out.println(SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(91,user.getLanguage())+")");
						}
						break;
					//================================================================================
				
				}
			   /*Modified by Huang Yu On April 21,2004########END####*/	
		     %>  
				 

            </TD>
          <TD nowrap>
<%
		String temptaskid="";
		String temprequestcount="0";
		String tempdoccount="0";
		for(int i=0;i<requesttaskids.size();i++){
			temptaskid=(String) requesttaskids.get(i);
			if(temptaskid.equals(ProjectProcessList.getId())) {
				temprequestcount=(String) requesttaskcounts.get(i);
				break;
			}
		}
		for(int i=0;i<doctaskids.size();i++){
			temptaskid=(String) doctaskids.get(i);
			if(temptaskid.equals(ProjectProcessList.getId())) {
				tempdoccount=(String) doctaskcounts.get(i);
				break;
			}
		}
		int coworkCount = 0;
		String taskIds = "";//coworkIds
		//=============================================Cowork_Items
		if("oracle".equals(RecordSet.getDBType())){
			RecordSet.executeSql("SELECT id FROM cowork_items WHERE ','||relatedprj||',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}else{
			RecordSet.executeSql("SELECT id FROM cowork_items WHERE ','+relatedprj+',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}
		while(RecordSet.next()){
			coworkCount ++;
			taskIds += RecordSet.getString("id") + ",";
		}
		//if(taskIds.endsWith(",")) taskIds = taskIds.substring(0,taskIds.length()-1);
		//=============================================Cowork_Discuss
		if("oracle".equals(RecordSet.getDBType())){
			RecordSet.executeSql("SELECT coworkid FROM cowork_discuss WHERE ','||relatedprj||',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}else{
			RecordSet.executeSql("SELECT coworkid FROM cowork_discuss WHERE ','+relatedprj+',' LIKE '%,"+ProjectProcessList.getId()+",%'");
		}
		while(RecordSet.next()){
			if((","+taskIds).indexOf(","+RecordSet.getString("coworkid")+",")==-1){
				coworkCount++;
				taskIds += RecordSet.getString("coworkid") + ",";
			}
		}
		if(taskIds.endsWith(",")) taskIds = taskIds.substring(0,taskIds.length()-1);
%>
			<%if(!temprequestcount.equals("0")){%>
				<a href="/proj/process/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>#anchor_wf"><img src="/images/prj_request.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>"></a><%=temprequestcount%> 
			<%}%>
			<%if(!tempdoccount.equals("0")){%>
				<a href="/proj/process/ViewTask.jsp?taskrecordid=<%=ProjectProcessList.getId()%>#anchor_doc" ><img src="/images/prj_doc.gif" border=0 alt="<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>"></a><%=tempdoccount%>
			<%}%>
			<%if(coworkCount>0){%>
				<a href="/cowork/coworkview.jsp?taskIds=<%=taskIds%>&type=all"><img src="/images_face/ecologyFace_2/LeftMenuIcon/MyAssistance.gif" style="border:0" alt="<%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())//协作%>" /></a><%=coworkCount%>
			<%}%>
		  </TD>
          <TD nowrap><%if(user.getLogintype().equals("1")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=ProjectProcessList.getHrmid()%>"><%if(ProjectProcessList.getHrmid().equals(""+user.getUID())){ %><font class=fontred><%}}%><%=ResourceComInfo.getResourcename(ProjectProcessList.getHrmid())%><%if(user.getLogintype().equals("1")){%><%if(ProjectProcessList.getHrmid().equals(""+user.getUID())){ %></font></a><%}}%></TD>
          <td height="100%">
            <%if((ProjectProcessList.getFinish()).equals("0")){%>               
            <%}else{%>
                <TABLE height="100%" cellSpacing=0 width="100%">
                <TBODY>
                <TR>
                    <TD height="100%" 
                    <%if(Util.getIntValue(ProjectProcessList.getFinish(),0)==100){%>
                    class=redgraph 
                    <%}else{%>
                    class=greengraph 
                    <%}%>
                  width="<%=ProjectProcessList.getFinish()%>%"></td><td></td>
                 </TR>
                 </TBODY>
                 </TABLE>
              <%}%>
              </td>  
              <td>
                  <%if(Util.getIntValue(ProjectProcessList.getFinish(),0)==100){%>
                  <font class=fontred><%=Util.getIntValue(ProjectProcessList.getFinish(),0)%>%</font>
                  <%}else{%>
                  <%=Util.getIntValue(ProjectProcessList.getFinish(),0)%>%
                  <%}%>
              </TD>
          <TD nowrap><%=ProjectProcessList.getWorkday()%></TD>
          <TD nowrap>
			  <%if(!ProjectProcessList.getActualBeginDate().equals("x")){%>
				  <%if(Util.getIntValue(ProjectProcessList.getFinish(),0)==0 && CurrentDate.compareTo( ProjectProcessList.getActualBeginDate())>=0){%>
						<font class=fontred><%=ProjectProcessList.getActualBeginDate()%></font>
				  <%} else {%>
						<%=ProjectProcessList.getActualBeginDate()%>
				  <%}%>
			  <%}%> 
		  </TD>
          <TD nowrap>
			  <%if(!ProjectProcessList.getActualEndDate().equals("-")){%>
				  <%if(Util.getIntValue(ProjectProcessList.getFinish(),0)!=100 && CurrentDate.compareTo( ProjectProcessList.getActualEndDate())>=0){%>
						<font class=fontred><%=ProjectProcessList.getActualEndDate()%></font>
				  <%} else {%>
						<%=ProjectProcessList.getActualEndDate()%>
				  <%}%>
			  <%}%> 
		  </TD>
           <TD nowrap>
		  <%if(canedit || isResponser){%>				  
		  <a href="/proj/process/AddTask.jsp?ProjID=<%=ProjID%>&parentid=<%=ProjectProcessList.getId()%>"><%=SystemEnv.getHtmlLabelName(2098,user.getLanguage())%></a>
		  <%}%>
		  </TD>
          <TD><%=ProjectProcessList.getFixedcost()%> </TD>
    </TR>
	<%/*################显示任务列表结束####################*/%>

<%
	isLight = !isLight;
	prelevel = Util.getIntValue(ProjectProcessList.getLevel_n());
	prerecid = ProjectProcessList.getId() ;
}
%>

<%
}
%>
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

		



<script language=vbs>
sub getProj(prjid)
	returndate =  window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/process/ProjNotice.jsp?ProjID="&prjid)

   
end sub


</script>

<script language=javascript >
function submitPic(){
    weaver.action="ViewProcessByPic.jsp";
    weaver.submit();
}
function rankclick(targetId)
{ 
  
  /*
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
	*/

	e = event.srcElement;
	var o = e;
	while(o.tagName!="TR") o=o.parentNode;
	var children = getChildren(o);
	var trType = getChildType(o);
	if(trType=="leaf") return;
	toggleChild(o, children);
	o.clicked = o.clicked=="true" ? "false" : "true";
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
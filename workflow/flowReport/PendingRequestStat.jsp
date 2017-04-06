<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
	String imagefilename = "/images/hdReport.gif" ; 
	String titlename = SystemEnv.getHtmlLabelName(19028,user.getLanguage()) ; 
	String needfav = "1" ;
	String needhelp = "" ; 
	String objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	int objType1=Util.getIntValue(request.getParameter("objType"),0);
	String objIds=Util.null2String(request.getParameter("objId"));
	String objNames=Util.null2String(request.getParameter("objNames"));
	
	
	String sqlCondition=" ";  //未查询前不显示记录
	String sql="";
	
	String userRights=shareRights.getUserRights("-2",user);//得到用户查看范围
	   if (userRights.equals("-100")){
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }

	String wfNames = Util.null2String(request.getParameter("wfNames"));
	String datefrom = Util.toScreenToEdit(request.getParameter("datefrom"),user.getLanguage());
	String dateto = Util.toScreenToEdit(request.getParameter("dateto"),user.getLanguage());
	String wfIds = Util.null2String(request.getParameter("wfId"));
	String isthisWeek = Util.null2String(request.getParameter("isthisWeek"));
	String isthisMonth = Util.null2String(request.getParameter("isthisMonth"));
	String isthisSeason = Util.null2String(request.getParameter("isthisSeason"));
	String isthisYear = Util.null2String(request.getParameter("isthisYear"));

	String exportpara = "objType="+objType1+"&objId="+objIds+"&datefrom="+datefrom+"&dateto="+dateto+"&wfId="+wfIds+"&isthisWeek="+isthisWeek+"&isthisMonth="+isthisMonth+"&isthisSeason="+isthisSeason+"&isthisYear="+isthisYear;

	Calendar now = Calendar.getInstance();
	String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
	int year=now.get(Calendar.YEAR);
	int month=now.get(Calendar.MONTH);
	int day=now.get(Calendar.DAY_OF_MONTH);

	if("1".equals(isthisWeek)){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		datefrom = lastday;
		dateto = today;
	}else if("1".equals(isthisMonth)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		datefrom = lastday;
		dateto = today;
	}else if("1".equals(isthisSeason)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String month_season = "";
		if(0<=month && month<=2){
			month_season = "01";
		}else if(3<=month && month<=5){
			month_season = "04";
		}else if(6<=month && month<=8){
			month_season = "07";
		}else{
			month_season = "10";
		}
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+month_season+"-01";
		datefrom = lastday;
		dateto = today;
	}else if("1".equals(isthisYear)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-01-01";
		datefrom = lastday;
		dateto = today;
	}

	String newwhere = "";
	if(!datefrom.equals("")){//开始日期
		newwhere = " workflow_currentoperator.receivedate >= '" + datefrom + "'";//workflow_currentoperator.receivedate,workflow_currentoperator.receivetime
	}
	if(!dateto.equals("")){//结束日期
		if(!newwhere.equals("")) newwhere += " and ";
		newwhere += " workflow_currentoperator.receivedate <= '" + dateto + "' ";
	}
	
	//td11783 start
	String devfromdate = Util.null2String(request.getParameter("devfromdate"));
	String devtodate = Util.null2String(request.getParameter("devtodate"));	
	if(!"".equals(devfromdate)) {
		sqlCondition = " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate >='"+devfromdate+"')";
	}
	if(!"".equals(devtodate)) {
		sqlCondition = " and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and createdate <='"+devtodate+"')";
	}
    //td11783 end

	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";
    ArrayList users=new ArrayList();
    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList temp=new ArrayList();     
    ArrayList newremarkwfcounts0=new ArrayList(); 
    ArrayList wftypecounts0=new ArrayList(); 
    ArrayList wfUsers=new ArrayList(); 
    ArrayList flowUsers=new ArrayList();
    if (userRights.equals(""))
    {sqlCondition +=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition +=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
	//sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    		
     String sql2="";
	String sqlfrom="";
	
	switch (objType1){
	        case 1:
	        objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	        sql="select userid,workflowtype, workflowid,"+
			   	 " count(distinct requestid) workflowcount from "+
				 " workflow_currentoperator where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			     "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and islasttimes=1 and  usertype='0' " ;
			sql+=" and userid in ("+objIds+")"  ;
			sqlfrom="workflow_currentoperator,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;
			sql+=sqlCondition;   
	        sql+=" group by userid,workflowtype, workflowid ";
	        sql+= " order by userid,workflow_currentoperator.workflowtype, workflowid";
	        break;
	        case 2:
	        sql="select a.departmentid,workflowtype, workflowid,"+
			    " count(distinct requestid) workflowcount from "+
			    " workflow_currentoperator ,hrmresource a  where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			    "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and  usertype='0' and islasttimes=1 and  a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.departmentid in ("+objIds+")"  ; 
	        sql+=sqlCondition;
			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2="where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;
	        sql+=" group by a.departmentid,workflowtype, workflowid ";
	        sql+= " order by a.departmentid,workflow_currentoperator.workflowtype, workflowid";
	        objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
	        break;
	        case 3:
	        sql="select a.subcompanyid1,workflowtype, workflowid,"+
			    " count(distinct requestid) workflowcount from "+
			    " workflow_currentoperator ,hrmresource a  where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			    "  workflowtype > 0 and isremark in ('0','1','5','8','9','7') and islasttimes=1 and  usertype='0' and a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.subcompanyid1 in ("+objIds+")"  ;
	        sql+=sqlCondition;

			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','8','9','7') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
			sql2+=(wfIds.equals("")?"":" and workflow_currentoperator.workflowid in (" + wfIds + ") ");
			sql2+=(newwhere.equals("")?"":" and "+newwhere);
			sql2+=sqlCondition;

	        sql+=" group by a.subcompanyid1,workflowtype, workflowid ";
	        sql+= " order by a.subcompanyid1,workflow_currentoperator.workflowtype, workflowid"; 
	        objType=SystemEnv.getHtmlLabelName(141,user.getLanguage());
	        break;
	}
   if (objType1!=0)
   {
   RecordSet.executeSql(sql) ;

	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;
        String objId=Util.null2String(RecordSet.getString(1)) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            int userIndex=users.indexOf(objId);
            int wfindex = workflows.indexOf(theworkflowid) ;
            workflows.add(theworkflowid) ;
            newremarkwfcounts0.add(""+theworkflowcount);
            flowUsers.add(objId);	
            int wftindex = wftypes.indexOf(theworkflowtype) ;
            int tempIndex=temp.indexOf(objId+"$"+theworkflowtype);
            if (userIndex!=-1)
            { 
            
            workflowcounts.set(userIndex,""+(Util.getIntValue((String)workflowcounts.get(userIndex),0)+theworkflowcount)) ;
            if(tempIndex != -1) {
            wftypecounts.set(tempIndex,""+(Util.getIntValue((String)wftypecounts.get(tempIndex),0)+theworkflowcount)) ;
            }
            else {
            temp.add(objId+"$"+theworkflowtype); 
            wftypes.add(theworkflowtype) ;
            wfUsers.add(objId);
            wftypecounts.add(""+theworkflowcount) ;
             
            }
            }
            else
            {
            temp.add(objId+"$"+theworkflowtype);
            users.add(objId);
            workflowcounts.add(""+theworkflowcount) ;  
            wftypes.add(theworkflowtype) ;
            wfUsers.add(objId);
            wftypecounts.add(""+theworkflowcount) ;
            }
           
        }
	}
	}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,javascript:doExportExcel(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<FORM id=frmMain name=frmMain action=PendingRequestStat.jsp method=post>
<input name=isthisWeek type=hidden value="<%=isthisWeek%>">
<input name=isthisMonth type=hidden value="<%=isthisMonth%>">
<input name=isthisSeason type=hidden value="<%=isthisSeason%>">
<input name=isthisYear type=hidden value="<%=isthisYear%>">
<!--查询条件-->
<table  class="viewform">
   <tr>
    <td width="5%">
    <%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>
    </td>
    <td class=field width="29%">
    <select class=inputstyle  name=objType onChange="onChangeType()">
    <option value="1" <%if (objType1==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
    <option value="2" <%if (objType1==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
    <option value="3" <%if (objType1==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
    </select>
    <BUTTON type=button class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName');" name=showresource></BUTTON> 
	<BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName');" name=showdepartment></BUTTON> 
    <BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%> onClick="onShowBranch('objId','objName');" name=showBranch></BUTTON>
	
	<SPAN id=objName>
	<%=objNames%>
	</SPAN><SPAN id=nameimage>
	<%if (objIds.equals("")) {%>
	<IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	<%}%>
	</SPAN> 
	<input type=hidden name="objId" id="objId" value="<%=objIds%>">
	<input type=hidden name="objNames" id="objNames" value="<%=objNames%>">
	</td>
	<td width="5%">
    <%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>
    </td>
    <td class=field width="28%">
		<BUTTON type="button" class=Browser onClick="onShowWorkflow('wfId','wfNamespan')" name=ShowWorkflow></BUTTON>
		<SPAN id=wfNamespan>
		<%=wfNames%>
		</SPAN>
		<input type=hidden name="wfId" id="wfId" value="<%=wfIds%>">
		<input type=hidden name="wfNames" id="wfNames" value="<%=wfNames%>">
	</td>
	</tr>
	<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=4></TD></TR>
	<tr>
	<td width="5%">
    <%=SystemEnv.getHtmlLabelName(19482, user.getLanguage())%>
    </td>
    <td class=field width="28%">
		<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>:<BUTTON  type=button class=calendar id=SelectDate onClick="getDate(datefromspan,datefrom)"></button>&nbsp;
		<span id=datefromspan ><%=datefrom%></span>-&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>:
		<BUTTON  type=button class=calendar id=SelectDate2 onClick="getDate(datetospan,dateto)"></button>&nbsp;
		<span id=datetospan><%=dateto%></span>
		<input id="datefrom" type="hidden" name="datefrom" value="<%=datefrom%>">
		<input id="dateto" type="hidden" name="dateto" value="<%=dateto%>">
	</td>
	<td width="5%">
	  <%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%>	    
	</td>
	<td class=field width="25%">
	  <BUTTON  type=button class=calendar onclick=getDate(devfromdatespan,devfromdate)></BUTTON>
		<SPAN id=devfromdatespan><%=devfromdate%></SPAN> 										
		&nbsp;- &nbsp;
		<BUTTON  type=button class=calendar onclick=getDate(devtodatespan,devtodate)></BUTTON>
		<SPAN id=devtodatespan><%=devtodate%></SPAN>
		<input type="hidden" name="devfromdate" value="<%=devfromdate%>">
		<input type="hidden" name="devtodate" value="<%=devtodate%>">
	</td>
	</tr>
    <TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=4></TD></TR>
	<tr>
	<td colspan="4">
	<table class="viewform">
	<colgroup>
	<col width="25%">
	<col width="25%">
	<col width="25%">
	<col width="25%">
	<tbody>
	<tr>
		<td class=field align=center><span id="spanisthisWeek" name="spanisthisWeek" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisWeek)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisWeek();">[<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%>]</span></td>
		<td class=field align=center><span id="spanisthisMonth" name="spanisthisMonth" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisMonth)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisMonth();">[<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%>]</span></td>
		<td class=field align=center><span id="spanisthisSeason" name="spanisthisSeason" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisSeason)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisSeason();">[<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%>]</span></td>
		<td class=field align=center><span id="spanisthisYear" name="spanisthisYear" style="font-size:12px;TEXT-DECORATION:none;color:<%if("1".equals(isthisYear)){%>#0000FF<%}else{%>#6A9EE6<%}%>;cursor:hand" onclick="javascript:submitDataisthisYear();">[<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%>]</span></td>
	</tr>
	</table>
	</td>
	</tr style="height:2px">
	<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=6></TD></TR>
    </table>
</FORM>


<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
    <COLGROUP> 
  <col width="20%"> 
  <col width="15%"> 
  <col width="65%"> 

<TR class=Header align=left> 
<td><%=objType%></td>
<td><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></td>
<td><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></td>
</tr>
</table>
<fieldset style="height:100%;border-width:0px;">
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
    <COLGROUP> 
  <col width="20%" valign="top"> 
  <col width="15%" valign="top"> 
  <col width="65%" valign="top"> 
  
<%
BarTeeChart bar=null;
boolean isLight = false ;
if (objType1!=0)
{
	bar=TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(19028,user.getLanguage()),700,2000);
	//bar.isDebug();
	bar.setMarksStyle(BarTeeChart.SMS_Value);
	if(users.size()>1)bar.setExternalJs("if(document.all('seriesType3'))document.all('seriesType3').disabled=true;");
	List maxList=new ArrayList();
	List tmpList=new ArrayList();
	Map[] dataMap=new HashMap[users.size()];
	String chartTitle=null;
for (int i=0;i<users.size();i++)
{
	String sql3=""; 
	String userId=""+users.get(i);
	isLight=!isLight;
	dataMap[i]=new HashMap();
%>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
<td>
<%
switch (objType1){
case 1:
	    sql3=sql2+" and workflow_currentoperator.userid="+users.get(i)  ;
		out.print("<a href='javaScript:openhrm("+users.get(i)+");' onclick='pointerXY(event);'>"+resourceComInfo.getLastname(""+users.get(i))+"</a>");
		chartTitle=resourceComInfo.getLastname(""+users.get(i));
		break;
case 2:
	    sql3=sql2+" and  b.departmentid="+users.get(i)  ;
		out.print("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+users.get(i)+"' target='_new'>"+DepartmentComInfo.getDepartmentname(""+users.get(i))+"</a>");
		chartTitle=DepartmentComInfo.getDepartmentname(""+users.get(i));
		break;
case 3:
		sql3=sql2+" and  b.subcompanyid1="+users.get(i)  ;
		out.print("<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+users.get(i)+"' target='_new'>"+SubCompanyComInfo.getSubCompanyname(""+users.get(i))+"</a>");
		chartTitle=SubCompanyComInfo.getSubCompanyname(""+users.get(i));
		break;				
}%></td>
<td><a href="WorkflowList.jsp?sql=<%=sql3%>&fromsql=<%=sqlfrom%>" target="_newlist"><%=workflowcounts.get(i)%></a></td>
<td align="left">
<table class=ListStyle cellspacing=1 >
<%
	
for (int j=0;j<wftypes.size();j++) {
String tempObjId=""+wfUsers.get(j);
String wfId=""+wftypes.get(j);
if (!tempObjId.equals(userId)) continue;
isLight=!isLight;
/*****************************/
dataMap[i].put(WorkTypeComInfo.getWorkTypename(wfId),wftypecounts.get(j).toString());
tmpList.add(WorkTypeComInfo.getWorkTypename(wfId));
/*****************************/
%>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'><td>
<a href="WorkflowList.jsp?sql=<%=sql3%>&fromsql=<%=sqlfrom%>&workflowtypeid=<%=wfId%>" target="_newlist"><%=WorkTypeComInfo.getWorkTypename(wfId)%></a>(<%=wftypecounts.get(j)%>)
</td></tr>

<%for (int k=0;k<workflows.size();k++) {
String curtypeid=WorkflowComInfo.getWorkflowtype(""+workflows.get(k));
String tempUser=""+flowUsers.get(k);
if(!curtypeid.equals(wfId)||!tempUser.equals(userId))	continue;
isLight=!isLight;
%>
<TR class=Line><TD colspan="1" ></TD></TR>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'><td>
　　　　　<a href="WorkflowList.jsp?sql=<%=sql3%>&fromsql=<%=sqlfrom%>&workflowid=<%=workflows.get(k)%>" target="_newlist"><%=WorkflowComInfo.getWorkflowname(""+workflows.get(k))%></a>(<%=newremarkwfcounts0.get(k)%>)
</td></tr>

<%
  workflows.remove(k);
  flowUsers.remove(k);
  newremarkwfcounts0.remove(k);
  k--;
}
  wftypes.remove(j);
  wfUsers.remove(j);
  wftypecounts.remove(j);
  j--;
  
}%>
</table>
</td>
</tr>
<TR class=Line ><TD colspan="3" ></TD></TR>
<%
		//if(tmpList.size()>maxList.size())maxList=tmpList;//保存最多项目个数的链表
		dataMap[i].put("title",chartTitle+"("+workflowcounts.get(i)+")");
	}//Enf for.
	
	HashSet hprstmp = new HashSet(tmpList);
    tmpList.clear();
    tmpList.addAll(hprstmp);
	maxList=tmpList;
	
	BarChartModel bc=null;
	String tmp=null;
	for(int i=0;i<dataMap.length;i++){
		tmpList=new ArrayList();
		for(int n=0;n<maxList.size();n++){
			tmp=maxList.get(n).toString();
			bc=new BarChartModel();			
			bc.setCategoryName(tmp);
			bc.setValue(dataMap[i].containsKey(tmp)?dataMap[i].get(tmp).toString():"0");
			tmpList.add(bc);
		}
		if(dataMap.length==1) bar.addSeries(dataMap[i].get("title").toString(),tmpList,"");
		else bar.addSeries(dataMap[i].get("title").toString(),tmpList);//这里颜色为空表示list中每一项都为随机色
	}//End for.
}

//没有记录的人员/部门/分部
ArrayList queryObj=Util.TokenizerString(objIds,",");
for (int m=0;m<queryObj.size();m++)
{
String tempRights=","+userRights+",";
if (users.indexOf(""+queryObj.get(m))==-1&&tempRights.indexOf(","+resourceComInfo.getDepartmentID(""+queryObj.get(m))+",")>0)
{
isLight=!isLight;
%>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
<td>
<%
switch (objType1){
case 1:
		out.print("<a href='javaScript:openhrm("+queryObj.get(m)+");' onclick='pointerXY(event);'>"+resourceComInfo.getLastname(""+queryObj.get(m))+"</a>");
		break;
case 2:
		out.print("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+queryObj.get(m)+"' target='_new'>"+DepartmentComInfo.getDepartmentname(""+queryObj.get(m))+"</a>");
		break;
case 3:
		out.print("<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+queryObj.get(m)+"' target='_new'>"+SubCompanyComInfo.getSubCompanyname(""+queryObj.get(m))+"</a>");
		break;				
}%></td>
<td>0</td>
<td></td></tr>
<TR class=Line><TD colspan="3" ></TD></TR>
<%
}
}
%>

<!--详细内容结束-->


</TABLE>
<br>
<div title="图形化报表显示区">
<%
if ("true".equals(isIE)){
	if(bar!=null)bar.print(out);
}else{   if(bar!=null) {%>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%}}%>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
</fieldset>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr >
<td height="10" colspan="3"></td>
</tr>
</table>
<iframe id="iframePending" style="display:none"></iframe>
<script>
	function doExportExcel(){
		document.getElementById("iframePending").src = "PendingRequestStatXLS.jsp?<%=exportpara%>";
	}

  function onChangeType(){
 
	thisvalue=document.frmMain.objType.value;
	$G("objId").value="";
	$G("objName").innerHTML ="";
	$G("nameimage").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>";
	if(thisvalue==3){
 		$G("showBranch").style.display='';
	}
	else{
		$G("showBranch").style.display='none';
	}
	if(thisvalue==2){
 		$G("showdepartment").style.display='';
		
	}
	else{
		$G("showdepartment").style.display='none';
	}
	if(thisvalue==1){
 		$G("showresource").style.display='';
		
	}
	else{
		$G("showresource").style.display='none';
		
    }
	
}

function submitData(){
	if (check_form(frmMain,'objId')){
		if(document.getElementById("datefrom").value != "" || document.getElementById("dateto").value != ""){
			onClearQuick();
		}
		document.frmMain.submit();
	}
}
function submitDataisthisWeek(){
	onClearSwift();
	document.frmMain.isthisWeek.value="1";
	document.getElementById("spanisthisWeek").style.color = "#0000FF";
	submitData();
}
function submitDataisthisMonth(){
	onClearSwift();
	document.frmMain.isthisMonth.value="1";
	document.getElementById("spanisthisMonth").style.color = "#0000FF";
	submitData();
}
function submitDataisthisSeason(){
	onClearSwift();
	document.frmMain.isthisSeason.value="1";
	document.getElementById("spanisthisSeason").style.color = "#0000FF";
	submitData();
}
function submitDataisthisYear(){
	onClearSwift();
	document.frmMain.isthisYear.value="1";
	document.getElementById("spanisthisYear").style.color = "#0000FF";
	submitData();
}
function onClearSwift(){
	document.frmMain.isthisWeek.value="0";
	document.frmMain.isthisMonth.value="0";
	document.frmMain.isthisSeason.value="0";
	document.frmMain.isthisYear.value="0";
	document.getElementById("spanisthisWeek").style.color = "#6A9EE6";
	document.getElementById("spanisthisMonth").style.color = "#6A9EE6";
	document.getElementById("spanisthisSeason").style.color = "#6A9EE6";
	document.getElementById("spanisthisYear").style.color = "#6A9EE6";
	document.getElementById("datefromspan").innerHTML = "";
	document.getElementById("datefrom").value = "";
	document.getElementById("datetospan").innerHTML = "";
	document.getElementById("dateto").value = "";
}
function onClearQuick(){
	document.frmMain.isthisWeek.value="0";
	document.frmMain.isthisMonth.value="0";
	document.frmMain.isthisSeason.value="0";
	document.frmMain.isthisYear.value="0";
	document.getElementById("spanisthisWeek").style.color = "#6A9EE6";
	document.getElementById("spanisthisMonth").style.color = "#6A9EE6";
	document.getElementById("spanisthisSeason").style.color = "#6A9EE6";
	document.getElementById("spanisthisYear").style.color = "#6A9EE6";
}
function onShowResource(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.substr(1).split(",");
	    	var names=datas.name.substr(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.substr(1));
			jQuery("#objNames").val(datas.name.substr(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowDepartment(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.split(",");
	    	var names=datas.name.split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                if(ids[i]!="")
                   strs=strs+"<a target='_blank' href=/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.substr(1));
			jQuery("#objNames").val(datas.name.substr(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}
function onShowBranch(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.substr(1).split(",");
	    	var names=datas.name.substr(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmSubCompanyDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.substr(1));
			jQuery("#objNames").val(datas.name.substr(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#objNames").val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}

function showFlowType(datas,e){
  if(datas&&datas.name!="")
      jQuery('#wfNames').val(datas.name.substr(1));
}

function onShowWorkflow(inputename,showname){
    tmpids = $G(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpids);
	if (id1){
        if (id1.id!="") {
          resourceids = id1.id;
          resourcename = id1.name;
          sHtml = ""
         
          resourceids =resourceids.substr(1);
          $G(inputename).value= resourceids;
          resourcename =resourcename.substr(1);
          
          resourceids=resourceids.split(",");
          resourcename=resourcename.split(",");
          for(var i=0;i<resourceids.length;i++){
              sHtml = sHtml+resourcename[i]+"&nbsp;";
          }
          $G(showname).innerHTML = sHtml;
	      $G("wfNames").value=sHtml;
        }else{
		  $G(showname).innerHTML ="";
          $G(inputename).value="";
       }
    }
}


</script>
<SCRIPT language=VBS>
sub onShowDepartment1(inputename,showname)
    tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   if (Not IsEmpty(id)) then
        if id(0)<> "" then
          resourceids = id(0)
          resourcename = id(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
          document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
         end if
         end if
end sub


sub onShowResource1(inputename,showname)
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
            sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
		  document.all("objNames").value=sHtml
        else
          document.all(inputename).value=""
		  document.all(showname).innerHtml =""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub
	
	
sub onShowBranch1(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)
   
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
            sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
	      document.all("objNames").value=sHtml
        else
		
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
         end if
end sub

sub onShowWorkflow1(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="&tmpids)
   
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
          document.all(showname).innerHtml = sHtml
	      document.all("wfNames").value=sHtml
        else
		
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
        end if
         end if
end sub
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</body></html>

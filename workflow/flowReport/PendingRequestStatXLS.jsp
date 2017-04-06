<%@ page language="java" contentType="application/vnd.ms-excel; charset=gbk" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<HTML><HEAD>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
<!--
TABLE.ListStyle {
	width:"100%" ;
	BACKGROUND-COLOR: #FFFFFF ;
	BORDER-Spacing:1pt ; 
}
TABLE.ListStyle TR.Header {
	COLOR: #003366; BACKGROUND-COLOR: #C8C8C8 ; HEIGHT: 30px ;BORDER-Spacing:1pt
}
TABLE.ListStyle TR.DataLight {
	BACKGROUND-COLOR: #FFFFFF ; HEIGHT: 22px ; BORDER-Spacing:1pt 
}
TABLE.ListStyle TR.DataLight TD {
	PADDING-RIGHT: 0pt; PADDING-LEFT: 0pt; LINE: 100%
}
-->
</style>
</head>

<BODY>
<%
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-disposition","attachment;filename=report.xls");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
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

	String exportpara = "objType="+objType1+"&objId="+objIds+"&objNames="+objNames+"&wfNames="+wfNames+"&datefrom="+wfNames+"&dateto="+dateto+"&wfId="+wfIds+"&isthisWeek="+isthisWeek+"&isthisMonth="+isthisMonth+"&isthisSeason="+isthisSeason+"&isthisYear="+isthisYear;

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
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    		
     String sql2="";
	String sqlfrom="";
	
	switch (objType1){
	        case 1:
	        objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	        sql="select userid,workflowtype, workflowid,"+
			   	 " count(distinct requestid) workflowcount from "+
				 " workflow_currentoperator where "+
				(wfIds.equals("")?"":"workflowid in (" + wfIds + ") and ")+(newwhere.equals("")?"":newwhere+" and ")+
			     "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and islasttimes=1 and  usertype='0' " ;
			sql+=" and userid in ("+objIds+")"  ;
			sqlfrom="workflow_currentoperator,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and workflow_currentoperator.requestid=a.requestid" ;
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
			    "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and  usertype='0' and islasttimes=1 and  a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.departmentid in ("+objIds+")"  ; 
	        sql+=sqlCondition;
			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2="where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
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
			    "  workflowtype > 0 and isremark in ('0','1','5','7','8','9') and islasttimes=1 and  usertype='0' and a.id=workflow_currentoperator.userid " ;
	        sql+=" and a.subcompanyid1 in ("+objIds+")"  ;
	        sql+=sqlCondition;

			sqlfrom="workflow_currentoperator,hrmresource b ,workflow_requestbase a";
			sql2=" where workflow_currentoperator.workflowtype>0 and workflow_currentoperator.isremark in ('0','1','5','7','8','9') and workflow_currentoperator.islasttimes=1 and  workflow_currentoperator.usertype='0'  and b.id=workflow_currentoperator.userid and workflow_currentoperator.requestid=a.requestid" ;
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




<TABLE class=ListStyle cellspacing=1 border="1">
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

<TABLE class=ListStyle cellspacing=1 border="1">
<!--详细内容在此-->
    <COLGROUP> 
  <col width="20%" valign="top"> 
  <col width="15%" valign="top"> 
  <col width="65%" valign="top"> 
  
<%

boolean isLight = false ;
if (objType1!=0)
{
	List maxList=new ArrayList(),tmpList=null;
	Map[] dataMap=new HashMap[users.size()];
	String chartTitle=null;
for (int i=0;i<users.size();i++)
{
	String sql3=""; 
	String userId=""+users.get(i);
	isLight=!isLight;
	tmpList=new ArrayList();
	dataMap[i]=new HashMap();
%>
<tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
<td>
<%
switch (objType1){
case 1:
	    sql3=sql2+" and workflow_currentoperator.userid="+users.get(i)  ;
		out.print(resourceComInfo.getLastname(""+users.get(i)));
		chartTitle=resourceComInfo.getLastname(""+users.get(i));
		break;
case 2:
	    sql3=sql2+" and  b.departmentid="+users.get(i)  ;
		out.print(DepartmentComInfo.getDepartmentname(""+users.get(i)));
		chartTitle=DepartmentComInfo.getDepartmentname(""+users.get(i));
		break;
case 3:
		sql3=sql2+" and  b.subcompanyid1="+users.get(i)  ;
		out.print(SubCompanyComInfo.getSubCompanyname(""+users.get(i)));
		chartTitle=SubCompanyComInfo.getSubCompanyname(""+users.get(i));
		break;				
}%></td>
<td><%=workflowcounts.get(i)%></td>
<td align="left">
<table class=ListStyle cellspacing=1 border="1">
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
<%=WorkTypeComInfo.getWorkTypename(wfId)%> (<%=wftypecounts.get(j)%>)
</td></tr>

<%for (int k=0;k<workflows.size();k++) {
String curtypeid=WorkflowComInfo.getWorkflowtype(""+workflows.get(k));
String tempUser=""+flowUsers.get(k);
if(!curtypeid.equals(wfId)||!tempUser.equals(userId))	continue;
isLight=!isLight;
%>

<tr class='<%=( isLight ? "datalight" : "datadark" )%>'><td>
　　　　　<%=WorkflowComInfo.getWorkflowname(""+workflows.get(k))%> (<%=newremarkwfcounts0.get(k)%>)
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

<%
		if(tmpList.size()>maxList.size())maxList=tmpList;//保存最多项目个数的链表
	}//Enf for.


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
		out.print(resourceComInfo.getLastname(""+queryObj.get(m)));
		break;
case 2:
		out.print(DepartmentComInfo.getDepartmentname(""+queryObj.get(m)));
		break;
case 3:
		out.print(SubCompanyComInfo.getSubCompanyname(""+queryObj.get(m)));
		break;				
}%></td>
<td>0</td>
<td></td></tr>

<%
}
}
%>

<!--详细内容结束-->


</TABLE>


</body></html>

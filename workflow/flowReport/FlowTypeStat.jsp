<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
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
String titlename = SystemEnv.getHtmlLabelName(19027 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-1",user);//得到用户查看范围

    if (userRights.equals("-100"))
    {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
    }

%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>



<%
	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";
   
    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();     //总计
	ArrayList workflowcountst=new ArrayList();     //总计流程类型
	ArrayList nodeTypes=new ArrayList();           //节点类型
    ArrayList newremarkwfcounts0=new ArrayList(); //草稿总数
    ArrayList newremarkwfcounts1=new ArrayList(); //待批准
    ArrayList newremarkwfcounts2=new ArrayList(); //待提交
    ArrayList newremarkwfcounts3=new ArrayList();  //归档
    ArrayList wftypecounts0=new ArrayList(); //草稿总数总计
    ArrayList wftypecounts1=new ArrayList(); //待批准总计
    ArrayList wftypecounts2=new ArrayList(); //待提交总计
    ArrayList wftypecounts3=new ArrayList();  //归档总计
    ArrayList wftypess=new ArrayList();
    int totalcount=0;
    String sqlCondition="";
    String fromdate=Util.null2String(request.getParameter("fromdate"));
    String todate=Util.null2String(request.getParameter("todate"));
    String fromdateOver=Util.null2String(request.getParameter("fromdateOver"));
    String todateOver=Util.null2String(request.getParameter("todateOver"));
  
   
    //创建日期 
    if (userRights.equals(""))
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3))";
    }
    else
    {sqlCondition=" and exists (select 1 from hrmresource where id=workflow_currentoperator.userid  and departmentid in ("+userRights+") and hrmresource.status in (0,1,2,3))";
    }
    if(!fromdate.equals("")){
		sqlCondition+=" and workflow_requestbase.createdate>='"+fromdate+"'";
	}
	if(!todate.equals("")){
		sqlCondition+=" and workflow_requestbase.createdate<='"+todate+"'";
	}
	//归档日期
	if (!todateOver.equals("")||!todateOver.equals(""))
	{
	 sqlCondition+=" and workflow_requestbase.currentnodetype='3' ";
	}
	if(!fromdateOver.equals("")){
	sqlCondition+=" and workflow_requestbase.lastoperatedate>='"+fromdateOver+"'";
	}
	
	if(!todateOver.equals("")){
		sqlCondition+=" and workflow_requestbase.lastoperatedate<='"+todateOver+"'";
	}
    String sql="select workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,  currentnodetype,"+
    " count(distinct workflow_requestbase.requestid) workflowcount from "+
    " workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid "+
    " and workflow_currentoperator.workflowtype>1  "+sqlCondition+" group by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid,currentnodetype "+
    " order by workflow_currentoperator.workflowtype, workflow_currentoperator.workflowid";
	//out.print(sql);
	RecordSet.executeSql(sql) ;

	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
        int nodetype=Util.getIntValue(RecordSet.getString("currentnodetype"),0) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
                if(nodetype==0){
                    newremarkwfcounts0.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts0.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==1){
                    newremarkwfcounts1.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts1.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==2){
                    newremarkwfcounts2.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts2.get(wfindex),0)+theworkflowcount)) ;
                }
                if(nodetype==3){
                    newremarkwfcounts3.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts3.get(wfindex),0)+theworkflowcount)) ;
                }
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
                if(nodetype==0){
                    newremarkwfcounts0.add(""+theworkflowcount);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+0);
                }else if(nodetype==1){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+theworkflowcount);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+0);
                }else if(nodetype==2){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+theworkflowcount);
                    newremarkwfcounts3.add(""+0);
                }
                else if(nodetype==3){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+0);
                    newremarkwfcounts2.add(""+0);
                    newremarkwfcounts3.add(""+theworkflowcount);
                    
                }
                
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
            if(wfindex != -1) {
            //wftypess.set(wftindex,""+(Util.getIntValue((String)wftypess.get(wftindex),0)+1));
            }
            else
            {
            wftypess.set(wftindex,""+(Util.getIntValue((String)wftypess.get(wftindex),0)+1));
            //wftypess.add(""+1);
            }
            wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
             if(nodetype==0){
                wftypecounts0.set(wftindex,""+(Util.getIntValue((String)wftypecounts0.get(wftindex),0)+theworkflowcount)) ;
            }
            else if(nodetype==1){
                wftypecounts1.set(wftindex,""+(Util.getIntValue((String)wftypecounts1.get(wftindex),0)+theworkflowcount)) ;
            }
              else if(nodetype==2){
                wftypecounts2.set(wftindex,""+(Util.getIntValue((String)wftypecounts2.get(wftindex),0)+theworkflowcount)) ;
            }
              else if(nodetype==3){
                wftypecounts3.set(wftindex,""+(Util.getIntValue((String)wftypecounts3.get(wftindex),0)+theworkflowcount)) ;
            }
            
            }
            else {
                wftypess.add(""+1);
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
                 if(nodetype==0){
                    wftypecounts0.add(""+theworkflowcount);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+0);
                }else if(nodetype==1){
                   wftypecounts0.add(""+0);
                    wftypecounts1.add(""+theworkflowcount);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+0);
                }else if(nodetype==2){
                   wftypecounts0.add(""+0);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+theworkflowcount);
                    wftypecounts3.add(""+0);
                }
                else if(nodetype==3){
                    wftypecounts0.add(""+0);
                    wftypecounts1.add(""+0);
                    wftypecounts2.add(""+0);
                    wftypecounts3.add(""+theworkflowcount);
                    
                }
            }

            totalcount += theworkflowcount;
        }
	}
%>

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
<FORM id=frmMain name=frmMain action=FlowTypeStat.jsp method=post>
<!--查询条件-->
<table  class="viewform">
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
    <td class=field> <input  class=wuiDate  type="hidden" name="fromdate" class=Inputstyle value="<%=fromdate%>">
      -&nbsp;&nbsp;  <input  class=wuiDate  type="hidden" name="todate" value="<%=todate%>" class=Inputstyle>&nbsp;
 
	  
    </td>   <td><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></td>
    <td class=field><input class=wuiDate type="hidden" name="fromdateOver" value="<%=fromdateOver%>" class=Inputstyle>&nbsp;
      -&nbsp;&nbsp;  <input type="hidden" class=wuiDate name="todateOver" value="<%=todateOver%>" class=Inputstyle>&nbsp;
    </td></tr>
    <TR style="height:2px" class=Separartor><TD class="Line" COLSPAN=4></TD></TR>
    </table>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> 
  <col width="30%"> 
  <col width="9%"> 
  <col width="9%"> 
  <col  width="9%"> 
  <col  width="9%"> 
  <col  width="9%"> 
  <col width="25%">

 <TR class=Header align=left> 
    <TD><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%>)</TD>
    <TD><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></TD><!--草稿-->
    <TD><%=SystemEnv.getHtmlLabelName(19044,user.getLanguage())%></TD><!--待批准-->
    <TD><%=SystemEnv.getHtmlLabelName(19045,user.getLanguage())%></TD><!--戴提交-->
    <TD><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></TD><!--归档-->
    <TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD><!--总计-->
    <TD>%</TD><!--%-->
   
  </TR>
  </table>
  <fieldset style="overflow:auto;height:90%;border-width:0px;">
  <TABLE  class=ListStyle cellspacing=1   >
  
  <COLGROUP> 
  <col width="30%"> 
  <col width="9%"> 
  <col  width="9%"> 
  <col  width="9%"> 
  <col  width="9%"> 
  <col  width="9%"> 
  <col width="25%">
  <TR class=Line><TD style="padding:0px;" colspan="7" ></TD></TR>
  <%if (wftypes.size()>0) {%><TR ><TD style="padding:0px;" colspan="7" >
  <span id="headSum"></span></TD></TR>
   <%}%>
  <%  boolean isLight = false ;
      int sumNode0=0;
      int sumNode1=0;
      int sumNode2=0;
      int sumNode3=0;
      int sumNodes=0;
      float percents=0;
      String percentString="";
      for(int i=0;i<wftypes.size();i++){
       isLight = !isLight ; 
       typeid=(String)wftypes.get(i);
       typecount=(String)wftypecounts.get(i);
       typename=WorkTypeComInfo.getWorkTypename(typeid);
 %> <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD>
   
    <span id="img<%=i%>" onclick="changImg('img<%=i%>','detail<%=i%>')" style="cursor:hand"><IMG SRC="/images/btnDocExpand.gif"  BORDER="0" HEIGHT="12px" WIDTH="12px"></img>
    </span>
    <b><%=Util.toScreen(typename,user.getLanguage())%>(<%=wftypess.get(i)%>)</b></TD>
    <TD><%=wftypecounts0.get(i)%></TD>
    <TD><%=wftypecounts1.get(i)%></TD>
    <TD><%=wftypecounts2.get(i)%></TD>
    <TD><%=wftypecounts3.get(i)%></TD>
    <TD><%=wftypecounts.get(i)%></TD>
    <TD><%
    if (Util.getIntValue(""+totalcount,0)!=0)
    {
    
    percentString=""+((Util.getFloatValue(""+wftypecounts.get(i),0)/Util.getFloatValue(""+totalcount,0))*100);
    
    percentString=Util.round(percentString,1);
    }
    
    %>
    <TABLE height="100%" cellSpacing=0 width="100%" border="0"  >
        <TBODY>
        <TR>
          <TD width="45"><%=percentString%>%</TD>
          <TD ><img src="/images/BDStatBlue.jpg" height="15" width="<%=percentString%>%"></img></TD>
          </TR></TBODY></TABLE>
  </TD><!--%-->
    </tr>
    <TR class=Line><TD style="padding:0px;" colspan="7" ></TD></TR>
    <TR><TD  style="padding:1px;" colspan="7"><div id="detail<%=i%>" style="display:none">
    <TABLE class=ListStyle cellspacing=1>

	  <COLGROUP> 
	  <col width="30%"> 
	  <col width="9%"> 
	  <col  width="9%"> 
	  <col width="9%"> 
	  <col  width="9%"> 
	  <col  width="9%"> 
	  <col width="25%">
    <%
    for(int j=0;j<workflows.size();j++){
     isLight = !isLight ;
     workflowid=(String)workflows.get(j);
     String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
     if(!curtypeid.equals(typeid))	continue;
     workflowname=WorkflowComInfo.getWorkflowname(workflowid);
    %>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD>　　<%=workflowname%></TD>
    <TD><%=newremarkwfcounts0.get(j)%></TD>
    <TD><%=newremarkwfcounts1.get(j)%></TD>
    <TD><%=newremarkwfcounts2.get(j)%></TD>
    <TD><%=newremarkwfcounts3.get(j)%></TD>
    <TD><%=workflowcounts.get(j)%></TD>
    <TD><%
    percentString="0";
    if (Util.getIntValue(""+wftypecounts.get(i),0)!=0)
    {
    
    percentString=""+((Util.getFloatValue(""+workflowcounts.get(j),0)/Util.getFloatValue(""+wftypecounts.get(i),0))*100);
    
    percentString=Util.round(percentString,1);
    }
    
    %>
    <TABLE height="100%" cellSpacing=0 width="100%" border="0">
        <TBODY>
        <TR>
          <TD width="45"><%=percentString%>%</TD>
          <TD ><img src="/images/BDStatRed.jpg" height="15" width="<%=percentString%>%"></img></TD>
          </TR></TBODY></TABLE></TD><!--%-->
    </tr>
    <TR class=Line  ><TD colspan="7"  style="padding:1px;"></TD></TR>
  <%
  workflows.remove(j);
  workflowcounts.remove(j);
  newremarkwfcounts0.remove(j);
  newremarkwfcounts1.remove(j);
  newremarkwfcounts2.remove(j);
  newremarkwfcounts3.remove(j);
  j--;
  }%>
  </table></div></TD></TR>
  <%
  sumNode0+=Util.getIntValue(""+wftypecounts0.get(i),0);
  sumNode1+=Util.getIntValue(""+wftypecounts1.get(i),0);
  sumNode2+=Util.getIntValue(""+wftypecounts2.get(i),0);
  sumNode3+=Util.getIntValue(""+wftypecounts3.get(i),0);
  sumNodes+=Util.getIntValue(""+wftypecounts.get(i),0);
  }
   isLight = !isLight ;
   
  %>
  <%if (wftypes.size()>0) {%>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD align="right"><b><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></b></TD>
    <TD><%=sumNode0%></TD>
    <TD><%=sumNode1%></TD>
    <TD><%=sumNode2%></TD>
    <TD><%=sumNode3%></TD>
    <TD><%=sumNodes%></TD>
    <TD></td>
    <tr>
   <TR class=Line><TD  style="height: 0px" colspan="7" ></TD></TR>
   <%}%>
  <TBODY> 
</TABLE>
<!--详细内容结束-->
</fieldset>
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

<script>  
<%if (wftypes.size()>0) {%>
 tempspan="<table  class=ListStyle  cellspacing=1><tr class='<%=( isLight ? "datalight" : "datadark" )%>'>"+
          "<TD align=right width=30%><b><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></b></TD>"+
          "<TD  width=9%><%=sumNode0%></TD>"+
          "<TD  width=9%><%=sumNode1%></TD>"+
    	  "<TD  width=9%><%=sumNode2%></TD>"+
    	  "<TD  width=9%><%=sumNode3%></TD>"+
    	  "<TD  width=9%><%=sumNodes%></TD>"+
    	  "<TD width=25%></td>"+
    	  "<tr>"+
    	  "<TR class=Line><TD  style='padding:3px;'  colspan=7 ></TD></TR></table>";
document.all("headSum").innerHTML=tempspan;
<%}%>
function changImg(obj1,obj2)
{

if (document.all(obj2).style.display=="none")
{
document.all(obj1).innerHTML="<IMG SRC='/images/btnDocCollapse.gif' BORDER=0 HEIGHT=12px WIDTH=12px></img>";
document.all(obj2).style.display="";
}
else
{
document.all(obj1).innerHTML="<IMG SRC='/images/btnDocExpand.gif' BORDER=0 HEIGHT=12px WIDTH=12px></img>";
document.all(obj2).style.display="none";
}
}
function submitData()
{
	
		frmMain.submit();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

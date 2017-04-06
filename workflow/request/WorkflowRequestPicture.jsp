<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import = "weaver.general.TimeUtil"%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>

<%@ include file="/systeminfo/init.jsp" %>
<%
if(user == null)  return ;


String requestid = Util.null2String(request.getParameter("requestid")) ;
String workflowid = Util.null2String(request.getParameter("workflowid")) ;
String nodeid = Util.null2String(request.getParameter("nodeid")) ;
String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid = Util.null2String(request.getParameter("formid")) ;
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"));
String userid=new Integer(user.getUID()).toString();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 内部用户  2:外部用户
String isurger=Util.null2String(request.getParameter("isurger"));
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}
if(isOldWf_){
String url = "/workflow/request/WorkflowManageRequestPicture_old.jsp?requestid=" + requestid + "&workflowid="+workflowid+"&nodeid="+nodeid+"&isbill="+isbill+"&formid="+formid;
response.sendRedirect(url);

}

%>


<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/js/init.js"></script>
<script language=javascript src="/js/weaver.js"></script>
<script type="text/javascript">
document.oncontextmenu = Function("return false;");
function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
	   if(document.cookie.length  >  0) {    
	       offset  =  document.cookie.indexOf(search);  
	       if  (offset  !=  -1)  
	       {    
	           offset  +=  search.length;  
	           end  =  document.cookie.indexOf(";",  offset);  
	           if  (end  ==  -1)  end  =  document.cookie.length;  
	           cookieValue  =  unescape(document.cookie.substring(offset,  end))  
	       }  
	   }  
   }catch(exception){
   }
   return  cookieValue;  
} 
</script>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<%@ include file="/hrm/resource/simpleHrmResource.jsp" %>
<TABLE border=0 cellpadding=0 cellspacing=0  width="100%"><TR><TD ID='IMAGETD'>


<%
rs.execute("select count(*) from workflow_monitor_bound where monitorhrmid="+userid+" and workflowid="+workflowid); 
if(isurger.equals("true")||rs.next()){
   StringBuffer sqlsb = new StringBuffer();
	sqlsb.append("select * ");
	sqlsb.append("	  from (select a.nodeid, ");
	sqlsb.append("	               b.nodename, ");
	sqlsb.append("              a.userid, ");
	sqlsb.append("              a.isremark, ");
	sqlsb.append("              a.lastisremark, ");
	sqlsb.append("              a.usertype, ");
	sqlsb.append("             a.agentorbyagentid, ");
	sqlsb.append("             a.agenttype, ");
	sqlsb.append("             a.receivedate, ");
	sqlsb.append("             a.receivetime, ");
	sqlsb.append("             a.operatedate, ");
	sqlsb.append("             a.operatetime, ");
	sqlsb.append("             a.viewtype, ");
	sqlsb.append("             a.nodetype ");
	sqlsb.append("        from (SELECT distinct requestid, ");
	sqlsb.append("                              userid, ");
	sqlsb.append("                              workflow_currentoperator.workflowid, ");
	sqlsb.append("                              workflowtype, ");
	sqlsb.append("                              isremark, ");
	sqlsb.append("                              lastisremark, ");
	sqlsb.append("                              usertype, ");
	sqlsb.append("                              workflow_currentoperator.nodeid, ");
	sqlsb.append("                              agentorbyagentid, ");
	sqlsb.append("                              agenttype, ");
	sqlsb.append("                              receivedate, ");
	sqlsb.append("                              receivetime, ");
	sqlsb.append("                              viewtype, ");
	sqlsb.append("                              iscomplete, ");
	sqlsb.append("                              operatedate, ");
	sqlsb.append("                              operatetime, ");
	sqlsb.append("                              nodetype ");
	sqlsb.append("                FROM workflow_currentoperator, workflow_flownode ");
	sqlsb.append("               where workflow_currentoperator.nodeid = ");
	sqlsb.append("                     workflow_flownode.nodeid ");
	sqlsb.append("                 and requestid = "+requestid+") a, ");
	sqlsb.append("             workflow_nodebase b ");
	sqlsb.append("       where a.nodeid = b.id ");
	sqlsb.append("         and a.requestid = "+requestid+" ");
	sqlsb.append("         and a.agenttype <> 1 ");
	sqlsb.append("      union ");
	sqlsb.append("      select a.nodeid, ");
	sqlsb.append("             b.nodename, ");
	sqlsb.append("             a.userid, ");
	sqlsb.append("             a.isremark, ");
	sqlsb.append("             a.isremark as lastisremark, ");
	sqlsb.append("             a.usertype, ");
	sqlsb.append("             0 as agentorbyagentid, ");
	sqlsb.append("             '' as agenttype, ");
	sqlsb.append("             a.receivedate, ");
	sqlsb.append("             a.receivetime, ");
	sqlsb.append("             a.operatedate, ");
	sqlsb.append("             a.operatetime, ");
	sqlsb.append("             a.viewtype, ");
	sqlsb.append("             a.nodetype ");
	sqlsb.append("        from (SELECT distinct o.requestid, ");
	sqlsb.append("                              o.userid, ");
	sqlsb.append("                              o.workflowid, ");
	sqlsb.append("                              o.isremark, ");
	sqlsb.append("                              o.usertype, ");
	sqlsb.append("                              o.nodeid, ");
	sqlsb.append("                              o.receivedate, ");
	sqlsb.append("                              o.receivetime, ");
	sqlsb.append("                              o.viewtype, ");
	sqlsb.append("                              o.operatedate, ");
	sqlsb.append("                              o.operatetime, ");
	sqlsb.append("                              n.nodetype ");
	sqlsb.append("                FROM workflow_otheroperator o, workflow_flownode n ");
	sqlsb.append("               where o.nodeid = n.nodeid ");
	sqlsb.append("                 and o.requestid = "+requestid+") a, ");
	sqlsb.append("             workflow_nodebase b ");
	sqlsb.append("       where a.nodeid = b.id ");
	sqlsb.append("         and a.requestid = "+requestid+") a ");
	sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");
   rs.executeSql(sqlsb.toString());
   
}else{
    String viewLogIds = "";
    ArrayList canViewIds = new ArrayList();
    String viewNodeId = "-1";
    String tempNodeId = "-1";
    String singleViewLogIds = "-1";
    rs.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid);

    while(rs.next()){
	    viewNodeId = rs.getString("nodeid");
	    rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
	    if(rs1.next()){
	    	singleViewLogIds = rs1.getString("viewnodeids");
	    }
	
	    if("-1".equals(singleViewLogIds)){//全部查看
		    rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
		    while(rs1.next()){
			    tempNodeId = rs1.getString("nodeid");
			    if(!canViewIds.contains(tempNodeId)){
			    	canViewIds.add(tempNodeId);
			    }
		    }
	    }
	    else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
	
	    }
	    else{//查看部分
		    String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
		    for(int i=0;i<tempidstrs.length;i++){
			    if(!canViewIds.contains(tempidstrs[i])){
			    	canViewIds.add(tempidstrs[i]);
			    }
		    }
	    }
    }

//处理相关流程的查看权限

    if(desrequestid>0)
    {
		//System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
	    rs.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in ('2','4') and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
	    while(rs.next()){
		    viewNodeId = rs.getString("nodeid");
		    rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
		    if(rs1.next()){
		    	singleViewLogIds = rs1.getString("viewnodeids");
		    }
		
		    if("-1".equals(singleViewLogIds)){//全部查看
			    rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid+"))");
			    while(rs1.next()){
				    tempNodeId = rs1.getString("nodeid");
				    if(!canViewIds.contains(tempNodeId)){
				    	canViewIds.add(tempNodeId);
				    }
			    }
		    }
		    else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看
		
		    }
		    else{//查看部分
			    String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
			    for(int i=0;i<tempidstrs.length;i++){
				    if(!canViewIds.contains(tempidstrs[i])){
				    	canViewIds.add(tempidstrs[i]);
				    }
			    }
		    }
	    }
    }
    if(canViewIds.size()>0){
	    for(int a=0;a<canViewIds.size();a++)
	    {
	    	viewLogIds += (String)canViewIds.get(a) + ",";
	    }
	    viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
    }
    else{
    	viewLogIds = "-1";
    }
    StringBuffer sqlsb = new StringBuffer();
    sqlsb.append("select * ");
    sqlsb.append("	  from (select a.nodeid, ");
    sqlsb.append("             b.nodename, ");
    sqlsb.append("             a.userid, ");
    sqlsb.append("             a.isremark, ");
    sqlsb.append("             a.lastisremark, ");
    sqlsb.append("             a.usertype, ");
    sqlsb.append("             a.agentorbyagentid, ");
    sqlsb.append("             a.agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct requestid, ");
    sqlsb.append("                              userid, ");
    sqlsb.append("                              workflow_currentoperator.workflowid, ");
    sqlsb.append("                              workflowtype, ");
    sqlsb.append("                              isremark, ");
    sqlsb.append("                              lastisremark, ");
    sqlsb.append("                              usertype, ");
    sqlsb.append("                              workflow_currentoperator.nodeid, ");
    sqlsb.append("                              agentorbyagentid, ");
    sqlsb.append("                              agenttype, ");
    sqlsb.append("                              receivedate, ");
    sqlsb.append("                              receivetime, ");
    sqlsb.append("                              viewtype, ");
    sqlsb.append("                              iscomplete, ");
    sqlsb.append("                              operatedate, ");
    sqlsb.append("                              operatetime, ");
    sqlsb.append("                              nodetype ");
    sqlsb.append("                FROM workflow_currentoperator, workflow_flownode ");
    sqlsb.append("               where workflow_currentoperator.nodeid = ");
    sqlsb.append("                     workflow_flownode.nodeid ");
    sqlsb.append("                 and requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+" ");
    sqlsb.append("         and a.agenttype <> 1 ");
    sqlsb.append("         and a.nodeid in ("+viewLogIds+") ");
    sqlsb.append("      union ");
    sqlsb.append("      select a.nodeid, ");
    sqlsb.append("             b.nodename, ");
    sqlsb.append("             a.userid, ");
    sqlsb.append("             a.isremark, ");
    sqlsb.append("             a.isremark as lastisremark, ");
    sqlsb.append("             a.usertype, ");
    sqlsb.append("             0 as agentorbyagentid, ");
    sqlsb.append("             '' as agenttype, ");
    sqlsb.append("             a.receivedate, ");
    sqlsb.append("             a.receivetime, ");
    sqlsb.append("             a.operatedate, ");
    sqlsb.append("             a.operatetime, ");
    sqlsb.append("             a.viewtype, ");
    sqlsb.append("             a.nodetype ");
    sqlsb.append("        from (SELECT distinct o.requestid, ");
    sqlsb.append("                              o.userid, ");
    sqlsb.append("                              o.workflowid, ");
    sqlsb.append("                              o.workflowtype, ");
    sqlsb.append("                              o.isremark, ");
    sqlsb.append("                              o.usertype, ");
    sqlsb.append("                              o.nodeid, ");
    sqlsb.append("                              o.receivedate, ");
    sqlsb.append("                              o.receivetime, ");
    sqlsb.append("                              o.viewtype, ");
    sqlsb.append("                              o.operatedate, ");
    sqlsb.append("                              o.operatetime, ");
    sqlsb.append("                              n.nodetype ");
    sqlsb.append("                FROM workflow_otheroperator o, workflow_flownode n ");
    sqlsb.append("               where o.nodeid = n.nodeid ");
    sqlsb.append("                 and o.requestid = "+requestid+") a, ");
    sqlsb.append("             workflow_nodebase b ");
    sqlsb.append("       where a.nodeid = b.id ");
    sqlsb.append("         and a.requestid = "+requestid+" ");
    sqlsb.append("         and a.nodeid in ("+viewLogIds+")) a ");
    sqlsb.append(" order by a.receivedate, a.receivetime, a.nodetype");
    rs.executeSql(sqlsb.toString());
    //rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct t1.id,t1.requestid ,t1.userid ,t1.workflowid ,workflowtype ,isremark ,t1.usertype ,t1.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator t1,workflow_flownode t2,(select max(id) id,nodeid,userid,usertype from workflow_currentoperator where requestid="+requestid+" group by nodeid,userid,usertype) t3  where t1.id=t3.id and t1.nodeid=t2.nodeid and t1.requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype");

}
%>

<table class=ListStyle cellspacing=1>
    <COLGROUP>
    <COL width="14%">
    <COL width="10%">
    <COL width="15%">
    <COL width="17%">
    <COL width="17%">
    <COL width="27%">
    <tr class=header>
        <td><b><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18008,user.getLanguage())%></b></td>
        <td><b><%=SystemEnv.getHtmlLabelName(18003,user.getLanguage())%></b></td>
    </tr>

    <%
    int tmpnodeid_old=-1;
    boolean islight=false;
    while(rs.next()){
        int     tmpnodeid=rs.getInt("nodeid");
        String  tmpnodename=rs.getString("nodename");
        String  tmpuserid=rs.getString("userid");
        //int     tmpisremark=rs.getInt("isremark");
        String  tmpisremark = Util.null2String(rs.getString("isremark"));
        if(tmpisremark.equals(""))
        {
        	tmpisremark = Util.null2String(rs.getString("lastisremark"));
        }
        int     tmpusertype=rs.getInt("usertype");
        String  tmpagentorbyagentid=rs.getString("agentorbyagentid");
        int     tmpagenttype=rs.getInt("agenttype");
        String  tmpreceivedate=rs.getString("receivedate");
        String  tmpreceivetime=rs.getString("receivetime");
        String  tmpoperatedate=rs.getString("operatedate");
        String  tmpoperatetime=rs.getString("operatetime");
        String  viewtype=rs.getString("viewtype");
        boolean flags=false;
        String  tmpIntervel="";
		//如果tmpisremark=2 判断时候在日志表里有该人（确定是否是由非会签得到的isremark=2）
        rs1.execute("select operator from workflow_requestlog where requestid="+requestid+" and nodeid="+tmpnodeid+" and operator="+tmpuserid);
        if (rs1.next()) flags=true;
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始
        if ("sqlserver".equals((rs1.getDBType()))) {
        	rs1.executeSql("select * from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.requestid="+requestid+" and a.userid="+tmpuserid);         	
        } else {
        	rs1.executeSql("select * from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder='3' and a.requestid="+requestid+" and a.userid="+tmpuserid);
        }
        //if(rs1.next()&&tmpisremark==2&&tmpoperatedate!=null && !tmpoperatedate.equals("")){
        if(rs1.next()&&tmpisremark.equals("2")&&tmpoperatedate!=null && !tmpoperatedate.equals("")){
        	tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 结束
       // if ((tmpisremark==2&&rs1.next())||tmpisremark!=2)
         {
        //if(tmpisremark==2 &&flags&& tmpoperatedate!=null && !tmpoperatedate.equals("")){
        if(tmpisremark.equals("2") &&flags&& tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
    islight=!islight;
    

    if (!islight)
	{%>
	<tr class=datadark>
	<%} else {%>
	<tr class=DataLight>
	<% }%>
        <TD>
        <%if(tmpnodeid_old==tmpnodeid){%>

        <%}else{%>
            <%=Util.toScreen(tmpnodename,user.getLanguage())%>
            <%tmpnodeid_old=tmpnodeid;%>
        <%}%>
        </TD>

        <TD>
            <img border="0" src="/images/replyDoc/userinfo.gif" />
            <%if(tmpusertype == 0){%>
                <%if(tmpagenttype!=2){%>
                    <A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                    	<%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}else{%>
                    <A href="javaScript:openhrm(<%=tmpagentorbyagentid%>);" onclick='pointerXY(event);'>
                    	<%=Util.toScreen(ResourceComInfo.getResourcename(tmpagentorbyagentid),user.getLanguage())%>
                    </A>
                    <A href="javaScript:openhrm(<%=tmpuserid%>);" onclick='pointerXY(event);'>
                    	<%=Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())%>
                    </A>
                <%}%>
            <%}else{%>
             <A  href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=tmpuserid%>">
               <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpuserid),user.getLanguage())%>
            </A>
            <%}%>
        </TD>

        <TD>
        
        <%
       
        if(tmpisremark.equals("2")&&flags){%>
            <%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%>
        <%}else if(tmpisremark.equals("0")||tmpisremark.equals("1")||tmpisremark.equals("5")||tmpisremark.equals("4")||tmpisremark.equals("8")||tmpisremark.equals("9")||tmpisremark.equals("7")||(tmpisremark.equals("2")&&!flags)){%>
            <%if(viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))){%>
                <FONT COLOR="#FF33CC"><%=SystemEnv.getHtmlLabelName(18006,user.getLanguage())%></FONT>
            <%}else{%>
                <FONT COLOR="#FF0000"><%=SystemEnv.getHtmlLabelName(18007,user.getLanguage())%></FONT>
            <%}%>
        <%}else if(tmpisremark.equals("s")){%>
        	<%=SystemEnv.getHtmlLabelName(20387,user.getLanguage())%>
         <%}else if(tmpisremark.equals("c")){%>
        	<%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%>
        <%}else if(tmpisremark.equals("r")){%>
        	<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
        <%} %>
        </TD>

        <TD>
        	<%if(!tmpisremark.equals("s")&&!tmpisremark.equals("c")&&!tmpisremark.equals("r")){ %>
            <%=Util.toScreen(tmpreceivedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpreceivetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
            <%} %>
        </TD>

        <TD>
            <%=Util.toScreen(tmpoperatedate,user.getLanguage())%>&nbsp;<%=Util.toScreen(tmpoperatetime,user.getLanguage())%>&nbsp;&nbsp;&nbsp;
        </TD>



        <TD>
            <%=Util.toScreen(tmpIntervel,user.getLanguage())%>
        </TD>
    </TR>

    <%}}%>
</table>
<p></p>
</TD></TR></TABLE>
<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.workflow.request.RequestAddShareInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<%
/*
* last modified by cyril on 2008-08-25 for td:9236
* 流程代理的优化
*/
int agentId = 0;
boolean flag = true;
String method=request.getParameter("method");
String haveAgentAllRight = request.getParameter("haveAgentAllRight");
String sql = "";
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String[] value;
String[] value1;
String isCountermandRunning="";
String beaid="";
String aid="";
String wfid="";
char separ = Util.getSeparator();
String Procpara = "";
/*-----------------  流程代理设置 ----------------------- */
/*----------- td2551 xwj 20050902 begin ----*/
int isPendThing=Util.getIntValue(request.getParameter("isPendThing"),0);
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
if(method.equals("add")){
    int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    
    int isCreateAgenter = 0;
    if(Util.getIntValue(request.getParameter("isCreateAgenter"),0) == 1){
      isCreateAgenter = 1;
    }
    int beagentwfid = -1; //被代理流程ID
    try{
    String workflowids="";
    Map map = new HashMap();//存T
    Map wmap = new HashMap();//存W
    boolean flag1 = false;
    try{
     for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
    	String paramName = (String) En.nextElement();
	    value1=request.getParameterValues(paramName);
	     for(int i=0;i<value1.length;i++){
	      value1[i]=Util.null2String(value1[i]);
	      if(value1[i].toUpperCase().indexOf("T")!=-1) {
	      	flag1 = true;
	      	//取得所选的所有流程 by cyril 
	      	int typeid = Util.getIntValue(value1[i].substring(1, value1[i].length()),-1);
	      	//System.out.println("value1="+value1[i]+" typeid="+typeid+" sub="+(value1[i].indexOf("T")+1));
			if (usertype == 0) {
				sql = "select * from workflow_base where isvalid=1 and workflowtype=" + typeid + " order by workflowname ";
				rs.executeSql(sql);
				while (rs.next()) {
					map.put("W"+rs.getString("id"), rs.getString("id"));
                    workflowids+=","+Util.getIntValue(rs.getString("id"));
				}
			} else if (usertype == 1) {
				//客户用户只能代理“外部访问者支持”类型的流程
				sql = "select id from workflow_base where isvalid=1 and workflowtype=29 order by workflowname";
				rs.executeSql(sql);
				while (rs.next()) {
					map.put("W"+rs.getString("id"),rs.getString("id"));
                    workflowids+=","+Util.getIntValue(rs.getString("id"));
				}
			}
	      	sql = "";
	      	break;
	      }
	      if(value1[i].toUpperCase().indexOf("W")!=-1){
	    	wmap.put(value1[i], value1[i].substring(1, value1[i].length()));
              workflowids+=","+value1[i].substring(1);
	    	//System.out.println(value1[i]+"=========---->"+value1[i].substring(1, value1[i].length()));
	        flag1 = true;
	      }
	     }
	  }
	  }catch(Exception e){}
    if(!flag1){
    response.sendRedirect("wfAgentAdd.jsp?infoKey=1");
    return;  //xwj for td3218 20051201
    }
    if(workflowids.length()>0){
        String cntSQL = " select * from workflow_Agent where workflowId in("+ workflowids.substring(1) +") and beagenterId=" + beagenterId +
				 " and agenttype = '1' " +" and agenterId!="+agenterId+
				 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
				 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
				 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
				 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
        rs1.executeSql(cntSQL);
        if(rs1.next()){
            response.sendRedirect("wfAgentStatistic.jsp?infoKey=5");
            return;
        }
    }
    Iterator it = wmap.entrySet().iterator();
    while(it.hasNext()) {
    	Map.Entry entry = (Map.Entry) it.next();
		String mapKey = entry.getKey().toString();
		String mapValue = entry.getValue().toString();
		if(map.get(mapKey)==null) {
			//System.out.println("add mapKey="+mapKey+" mapValue="+mapValue);
			map.put(mapKey, mapValue);
		}
    }
    
    it = map.entrySet().iterator();
    while(it.hasNext()) {
    	Map.Entry entry = (Map.Entry) it.next();
		String mapKey = entry.getKey().toString();
		String mapValue = entry.getValue().toString();
    /*
    for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	    value=request.getParameterValues((String) En.nextElement());
	     for(int i=0;i<value.length;i++){
	      value[i]=Util.null2String(value[i]);
	      if(value[i].indexOf("W")!=-1){
	    	  beagentwfid = Integer.parseInt(value[i].substring(1,value[i].length()));
	*/
	      	 beagentwfid = Integer.parseInt(mapValue);
	      	 //对每一个代理进行处理
	   /* -------------- td2483 xwj 20050812 begin-------------*/
	      	 
	  //sql = "select * from workflow_agent where beagenterId = " + beagenterId + 
    //" and agenttype='1' and (endDate >= '" + currentDate + "' or endDate = '' or endDate is null) and workflowid = " + beagentwfid;
    
    
 /* xwj for td2551 view层已有验证
    sql = " select * from workflow_Agent where workflowId="+ beagentwfid +" and beagenterId=" + beagenterId + 
    " and agenttype = '1' " +  
    " and ( ( (endDate = '" + currentDate + "' and (endTime='' or endTime is null))" + 
    " or (endDate = '" + currentDate + "' and endTime > '" + currentTime + "' ) ) " + 
    " or endDate > '" + currentDate + "' or endDate = '' or endDate is null)" +
    " and ( ( (beginDate = '" + currentDate + "' and (beginTime='' or beginTime is null))" + 
	  " or (beginDate = '" + currentDate + "' and beginTime < '" + currentTime + "' ) ) " + 
	  " or beginDate < '" + currentDate + "' or beginDate = '' or beginDate is null)";
                     
    rs.executeSql(sql);
    */
    

    rs1.executeSql("select * from SequenceIndex where indexdesc = 'workflowagentid' ");
    if(rs1.next()){
    agentId = rs1.getInt("currentid");
    }
    rs1.executeSql("update SequenceIndex set currentid = " + (agentId+1) + " where indexdesc= 'workflowagentid' ");
    /* -------------- td2483 xwj 20050812 end-------------*/
    
    /* xwj for td2551 view层已有验证
    if(rs.next()){
    rs1.executeSql("update workflow_agent set agenttype = '0' where agentid = " + rs.getString("agentid"));
    rs1.executeSql("insert into workflow_agent values "+
    "("+agentId+","+beagentwfid+","+beagenterId+","+agenterId+",'"+beginDate + "','"+beginTime + 
    "','"+endDate+"','"+endTime+"',"+isCreateAgenter+",'1',"+user.getUID()+",'"+currentDate+"','"+currentTime+"')");
    }
    */
   // else{
	 //added by cyril on 2008-12-01 for td:9684
	 String cntSQL = "select count(1) as cnt from workflow_agent "+
	 	"where workflowid='"+beagentwfid+"' and beagenterid='"+beagenterId+"' "+ 
		"and agenterid='"+agenterId+"' ";
	 String v1 = "";
	 String v2 = "";
	 String v3 = "";
	 String v4 = "";
	 if(rs1.getDBType().equals("oracle")) {
		 if(beginDate.equals(""))
			 v1 = "IS NULL";
		 else v1 = "='"+beginDate+"'";
		 if(beginTime.equals(""))
			 v2 = "IS NULL";
		 else v2 = "='"+beginTime+"'";
		 if(endDate.equals(""))
			 v3 = "IS NULL";
		 else v3 = "='"+endDate+"'";
		 if(endTime.equals(""))
			 v4 = "IS NULL";
		 else v4 = "='"+endTime+"'";
		 cntSQL += "and begindate "+v1+"  and beginTime "+v2+"  and enddate "+v3+" and endtime "+v4+"  ";
	 }
	 else {
		 cntSQL += "and begindate='"+beginDate+"' "+
			"and beginTime='"+beginTime+"' and enddate='"+endDate+"' "+
			"and endtime='"+endTime+"' ";
	 }
	 
	 cntSQL += "and iscreateagenter='"+isCreateAgenter+"' "+
		"and agenttype='1' and operatorid='"+user.getUID()+"' "+
		"and isset='0' and ispending='"+isPendThing+"' ";
	 rs1.executeSql(cntSQL);
	 //System.out.println(cntSQL);
	 int cnt = -1;
	 if(rs1.next()) cnt = rs1.getInt("cnt");
	 if(cnt==0)
     rs1.executeSql("insert into workflow_agent values "+
    "("+agentId+","+beagentwfid+","+beagenterId+","+agenterId+",'"+beginDate+ "','"+beginTime+ 
    "','"+endDate+"','"+endTime+"',"+isCreateAgenter+",'1',"+user.getUID()+",'"+currentDate+"','"+currentTime+"','0','"+isPendThing+"','','')");
    //}
    
    //added by cyril on 2008-12-01 for td:9684
    /*
    rs1.executeSql("delete from workflow_agent where agentid >("+
    		"select min(b.agentid)  from workflow_agent b "+ 
    		"where workflow_agent.workflowid=b.workflowid and workflow_agent.beagenterid=b.beagenterid "+ 
    		"and workflow_agent.agenterid=b.agenterid and workflow_agent.begindate=b.begindate "+
    		"and workflow_agent.beginTime=b.beginTime and workflow_agent.enddate=b.enddate "+
    		"and workflow_agent.endtime=b.endtime and workflow_agent.iscreateagenter=b.iscreateagenter "+
    		"and workflow_agent.agenttype=b.agenttype and workflow_agent.operatorid=b.operatorid "+
    		"and workflow_agent.isset=b.isset and workflow_agent.ispending=b.ispending "+
    		") ");
	 */     	
//modify by mackjoe at 2005-09-14 创建权限移至新建流程页面处理
/*
	     if(isCreateAgenter == 1){//只有有代理创建权限时才会更新创建人列表
	   //更新创建人列表
	   rs1.executeSql("select b.id from workflow_flownode a,workflow_nodegroup b where a.workflowid="+beagentwfid+" and a.nodetype=0 and a.nodeid=b.nodeid");
     if(rs1.next()){
     RequestCheckUser.setWorkflowid(beagentwfid);
      RequestCheckUser.updateCreateList(rs1.getInt("id"));
     }
     }
*/
//modify by mackjoe at 2005-09-15 td2746 增加待办事宜处理
    //没有设置开始时间，被代理人失去任务，并设置被代理人
	String currentDateTime=TimeUtil.getCurrentTimeString();
	String beginTimes=beginTime;
    if (beginTime.equals("")) beginTimes="00:00:00";
    else beginTimes = beginTimes+":00";
	long timeIntervals=TimeUtil.timeInterval(beginDate+' '+beginTimes,currentDateTime);
    if(isPendThing==1&&(beginDate.equals("")||timeIntervals>=0)){
		
        sql="select a.id,a.requestid,a.groupid,a.workflowid,a.workflowtype,a.usertype,a.nodeid,a.showorder,a.isremark,b.isbill,a.groupdetailid from workflow_currentoperator a,workflow_base b where a.workflowid=b.id and a.userid = " + beagenterId + " and a.isremark in ('0','1','5','7','8','9') and a.agenttype ='0' and a.agentorbyagentid ='-1' and a.workflowid="+beagentwfid;
        rs.executeSql(sql);
        ArrayList requestids=new ArrayList();
        ArrayList nodeids=new ArrayList();
        ArrayList isbills=new ArrayList();
        while(rs.next()){
            requestids.add(rs.getString("requestid"));
            nodeids.add(rs.getString("nodeid"));
            isbills.add(rs.getString("isbill"));
            int coid1 = Util.getIntValue(rs.getString("id"));
            //让代理人获得任务
            Procpara = rs.getString("requestid") + separ + ""+agenterId + separ + rs.getString("groupid") + separ + rs.getString("workflowid") + separ + rs.getString("workflowtype") + separ  + rs.getString("usertype") + separ + rs.getString("isremark") + separ+ rs.getString("nodeid") + separ + ""+beagenterId + separ + "2" + separ + rs.getString("showorder")+separ+rs.getInt("groupdetailid");
            rs1.executeProc("workflow_CurrentOperator_I", Procpara);
            if("1".equals(rs.getString("isremark"))){
	            int coid2 = 0;
	            rs1.execute("select max(id) as id from workflow_currentoperator where requestid="+rs.getString("requestid"));
	            if(rs1.next()){
	            	coid2 = Util.getIntValue(rs1.getString("id"));
	            }
	            rs1.executeSql("update workflow_forward set beforwardid = " + coid2 + " where requestid="+rs.getString("requestid")+" and beforwardid="+coid1);
	            rs1.executeSql("update workflow_forward set forwardid = " + coid2 + " where requestid="+rs.getString("requestid")+" and forwardid="+coid1);
            }
        }
        sql="update workflow_currentoperator set isremark = '2', agenttype ='1', agentorbyagentid ="+agenterId + " where userid = " + beagenterId + " and (agenttype is null or agenttype='0') and isremark in ('0','1','5','7','8','9') and agenttype ='0' and agentorbyagentid ='-1' and workflowid="+beagentwfid;
        rs1.executeSql(sql);
        //add by xhheng @20051011 for TD2887,调用RequestAddShareInfo处理共享
        RequestAddShareInfo shareinfo = new RequestAddShareInfo();
        for(int j=0;j<requestids.size();j++){

            shareinfo.setRequestid(Util.getIntValue((String)requestids.get(j)));
            shareinfo.SetWorkFlowID(beagentwfid);
            shareinfo.SetNowNodeID(Util.getIntValue((String)nodeids.get(j)));
            shareinfo.SetNextNodeID(Util.getIntValue((String)nodeids.get(j)));
            shareinfo.setIsbill(Util.getIntValue((String)isbills.get(j),0));
            shareinfo.setUser(user);
            shareinfo.SetIsWorkFlow(1);
            shareinfo.setHaspassnode(true);
            shareinfo.addShareInfo();
        }
    }
    //end by mackjoe
	      	
	       //}
	     //}
	   }
   }
   catch(Exception e){
    flag = false;
   }
if(flag){
response.sendRedirect("wfAgentStatistic.jsp?infoKey=1");
return;  //xwj for td3218 20051201
}
else{
response.sendRedirect("wfAgentStatistic.jsp?infoKey=2");
return;  //xwj for td3218 20051201
}
}
/*----------- td2551 xwj 20050902 end ----*/


/* -------------    统计页面代理收回   ---------*/
else if(method.equals("countermand")){
isCountermandRunning=request.getParameter("isCountermandRunning");
beaid=request.getParameter("beaid");
aid=request.getParameter("aid");
try{
//设置无效状态
rs.executeSql("select * from workflow_agent where agenttype = '1' and beagenterId = " + beaid + " and agenterId = " + aid);
while(rs.next()){
rs1.executeSql("update workflow_agent set agenttype = '0',backDate='"+currentDate+"',backTime='"+currentTime+"' where agentid = " + rs.getString("agentid"));
//modify by mackjoe at 2005-09-14 创建权限移至新建流程页面处理
//更新创建人列表
/*
rs1.executeSql("select b.id from workflow_flownode a,workflow_nodegroup b where a.workflowid="+rs.getString("workflowId")+" and a.nodetype=0 and a.nodeid=b.nodeid");
if(rs1.next()){
   RequestCheckUser.setWorkflowid(rs.getInt("workflowId"));
   RequestCheckUser.updateCreateList(rs1.getInt("id"));
}
*/
}
//收回流转中的代理 对于老数据不做处理, 当一个代理人又是操作者本身时很难区分
if("y".equals(isCountermandRunning)){
 String updateSQL = "";
 rs1.executeSql("select * from workflow_currentoperator where isremark in ('0','1','5','7','8','9')  and userid = " + aid + " and agentorbyagentid = " + beaid + " and agenttype = '2'");//td2302 xwj
 while(rs1.next()){
	   int wfcoid = Util.getIntValue(rs1.getString("id"));
   String tmprequestid=rs1.getString("requestid");
   String tmpisremark=rs1.getString("isremark");
   int tmpgroupid=rs1.getInt("groupid");
   int currentnodeid = rs1.getInt("nodeid");//流程当前所在节点
   int tmpuserid=rs1.getInt("userid");
   String tmpusertype=rs1.getString("usertype");
   int tmppreisremark=Util.getIntValue(rs1.getString("preisremark"),0);
	int upcoid = 0;
	rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1' and agentorbyagentid = " + tmpuserid +" and usertype=0 and groupid="+tmpgroupid+" and nodeid="+currentnodeid);
	if(rs2.next()){
		upcoid = Util.getIntValue(rs2.getString("id"));
		updateSQL = "update workflow_currentoperator set isremark = '" + tmpisremark + "',preisremark='"+tmppreisremark+"', agenttype ='0', agentorbyagentid = -1  where id="+upcoid;
		//应该只更新当前节点的代理关系，已经经过的节点不用更新
		rs2.executeSql(updateSQL);  //被代理人重新获得任务
		//失效的代理人删除
		rs2.executeSql("delete workflow_currentoperator where id="+wfcoid);//td2302 xwj
		rs2.executeSql("update workflow_forward set beforwardid = " + upcoid + " where requestid="+tmprequestid+" and beforwardid="+wfcoid);
		rs2.executeSql("update workflow_forward set forwardid = " + upcoid + " where requestid="+tmprequestid+" and forwardid="+wfcoid);
	}
   PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,10,tmpusertype,Util.getIntValue(tmprequestid));
   PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,0,tmpusertype,Util.getIntValue(tmprequestid));
   //add by fanggsh 20060519 TD4346 begin 流程代理收回导致操作人查不到流程
   rs3.executeSql("select id from workflow_currentoperator where requestid ="+tmprequestid+" and userid="+tmpuserid+" and usertype="+usertype+" order by id desc ");
   if(rs3.next()){
       rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + tmpuserid + " and id = " + rs3.getString("id"));
   }
   //add by fanggsh 20060519 TD4346 end

   //回收代理人文档权限
   rs2.executeSql("select distinct docid,sharelevel from Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
   boolean hasrow=false;
   ArrayList docslist=new ArrayList();
   ArrayList sharlevellist=new ArrayList();
   while(rs2.next()){
       hasrow=true;
       docslist.add(rs2.getString("docid"));
       sharlevellist.add(rs2.getString("sharelevel"));
   }
   if(hasrow){
       rs2.executeSql("delete Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
   }
   for(int j=0;j<docslist.size();j++){
       rs3.executeSql("select Max(sharelevel) sharelevel from Workflow_DocShareInfo where docid="+docslist.get(j)+" and userid="+aid);
       if(rs3.next()){
          int sharelevel=Util.getIntValue(rs3.getString("sharelevel"),0);
          if(sharelevel>0){
              rs.executeSql("update DocShare set sharelevel="+sharelevel+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid+" and sharelevel>"+sharelevel);
          }else{
              rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
          }
       }else{
          rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
       }
       //重新赋予被代理人文档权限
       rs.executeSql("update DocShare set sharelevel="+sharlevellist.get(j)+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+beaid);
       DocViewer.setDocShareByDoc((String)docslist.get(j));
   }   
   //end by mackjoe
  }
}
//通过默认的工作流提醒 
//TODO
}
catch(Exception e){
flag = false;
}
if(flag){
response.sendRedirect("wfAgentStatistic.jsp?infoKey=3");
return;  //xwj for td3218 20051201
}
else{
response.sendRedirect("wfAgentStatistic.jsp?infoKey=4");
return;  //xwj for td3218 20051201
}

}


/* -------------    查询页面代理收回    ---------*/
else if(method.equals("listountermand")){
int agentid = 0;
ArrayList arr1 = new ArrayList();
ArrayList arr2 = new ArrayList();
try{
for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	    value=request.getParameterValues((String) En.nextElement());
	     for(int i=0;i<value.length;i++){
	      value[i]=Util.null2String(value[i]);
	      if(value[i].indexOf("cm")!=-1){
	       arr1.add(value[i].substring(2,value[i].length()));
	      }
	      if(value[i].indexOf("rm")!=-1){
	       arr2.add(value[i].substring(2,value[i].length()));
	      }
	     }
}
}catch(Exception e){}
for(int i =0; i< arr1.size(); i++){
  agentid = Integer.parseInt(arr1.get(i).toString().trim());
  if(arr2.contains(agentid+"")){
  isCountermandRunning="y";
  }
  rs3.executeSql("select * from workflow_agent where agentid = " + agentid);
  if(rs3.next()){
  beaid = rs3.getString("beagenterid");
  aid = rs3.getString("agenterid");
  wfid= rs3.getString("workflowid");
  }
 //System.out.println("isCountermandRunning" + isCountermandRunning);
try{
//设置无效状态
rs1.executeSql("update workflow_agent set agenttype = '0',backDate='"+currentDate+"',backTime='"+currentTime+"' where agentid = " + agentid);
//modify by mackjoe at 2005-09-14 创建权限移至新建流程页面处理
/*
//更新创建人列表
rs1.executeSql("select b.id from workflow_flownode a,workflow_nodegroup b where a.workflowid="+wfid+" and a.nodetype=0 and a.nodeid=b.nodeid");
if(rs1.next()){
   RequestCheckUser.setWorkflowid(Integer.parseInt(wfid));
   RequestCheckUser.updateCreateList(rs1.getInt("id"));
}
*/
//收回流转中的代理 //对于老数据不做处理, 当一个代理人又是操作者本身时很难区分 TODO
if("y".equals(isCountermandRunning)){
 String updateSQL = "";
 rs1.executeSql("select * from workflow_currentoperator where isremark in ('0','1','5','7','8','9') and userid = " + aid + " and agentorbyagentid = " + beaid + " and agenttype = '2' and workflowid = " + wfid);//td2302 xwj
 while(rs1.next()){
	int wfcoid = Util.getIntValue(rs1.getString("id"));
   String tmprequestid=rs1.getString("requestid");
   String tmpisremark=rs1.getString("isremark");
   int tmpgroupid=rs1.getInt("groupid");
   int currentnodeid = rs1.getInt("nodeid");//流程当前所在节点
   int tmpuserid=rs1.getInt("userid");
   String tmpusertype=rs1.getString("usertype");
   int tmppreisremark=Util.getIntValue(rs1.getString("preisremark"),0);
	int upcoid = 0;
	rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1'  and agentorbyagentid = " + tmpuserid+" and usertype=0 and groupid="+tmpgroupid+" and nodeid="+currentnodeid);
	if(rs2.next()){
		upcoid = Util.getIntValue(rs2.getString("id"), 0);
		updateSQL = "update workflow_currentoperator set isremark = '" + tmpisremark + "',preisremark='"+tmppreisremark+"', agenttype ='0', agentorbyagentid = -1  where id = " + upcoid;
		//应该只更新当前节点的代理关系，已经经过的节点不用更新
		rs2.executeSql(updateSQL);  //被代理人重新获得任务
		//失效的代理人删除
		rs2.executeSql("delete workflow_currentoperator where id="+wfcoid);//td2302 xwj
		rs2.executeSql("update workflow_forward set beforwardid = " + upcoid + " where requestid="+tmprequestid+" and beforwardid="+wfcoid);
		rs2.executeSql("update workflow_forward set forwardid = " + upcoid + " where requestid="+tmprequestid+" and forwardid="+wfcoid);
	}
   PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,10,tmpusertype,Util.getIntValue(tmprequestid));
   PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,0,tmpusertype,Util.getIntValue(tmprequestid));
   //add by fanggsh 20060519 TD4346 begin 流程代理收回导致操作人查不到流程
   rs3.executeSql("select id from workflow_currentoperator where isremark in ('0','1','5','7','8','9') and requestid ="+tmprequestid+" and userid="+tmpuserid+" and usertype="+usertype+" order by id desc ");
   if(rs3.next()){
       rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + tmpuserid + " and id = " + rs3.getString("id"));
   }
   //add by fanggsh 20060519 TD4346 end

   //回收代理人文档权限
   rs2.executeSql("select distinct docid,sharelevel from Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
   boolean hasrow=false;
   ArrayList docslist=new ArrayList();
   ArrayList sharlevellist=new ArrayList();
   while(rs2.next()){
       hasrow=true;
       docslist.add(rs2.getString("docid"));
       sharlevellist.add(rs2.getString("sharelevel"));
   }
   if(hasrow){
       rs2.executeSql("delete Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
   }
   for(int j=0;j<docslist.size();j++){
       rs3.executeSql("select Max(sharelevel) sharelevel from Workflow_DocShareInfo where docid="+docslist.get(j)+" and userid="+aid);
       if(rs3.next()){
          int sharelevel=Util.getIntValue(rs3.getString("sharelevel"),0);
          if(sharelevel>0){
              rs.executeSql("update DocShare set sharelevel="+sharelevel+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid+" and sharelevel>"+sharelevel);
          }else{
              rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
          }
       }else{
          rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
       }
       //重新赋予被代理人文档权限
       rs.executeSql("update DocShare set sharelevel="+sharlevellist.get(j)+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+beaid);
       DocViewer.setDocShareByDoc((String)docslist.get(j));
   }   
   //end by mackjoe
  }
}
//通过默认的工作流提醒 
//TODO
}
catch(Exception e){
flag = false;
}

  
}
if(flag){
response.sendRedirect("wfAgentStatistic.jsp?infoKey=3");
return;  //xwj for td3218 20051201
}
else{
response.sendRedirect("wfAgentStatistic.jsp?infoKey=4");
return;  //xwj for td3218 20051201
}
}

/* ------------------------- 代  理  编  辑 ----------------------------- */
else if(method.equals("edit")){
    int agentid = Util.getIntValue(request.getParameter("agentid"),0);
    int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    int isCreateAgenter = 0;
    if(Util.getIntValue(request.getParameter("isCreateAgenter"),0) == 1){
        isCreateAgenter = 1;
    }
    try{
        String editString = "update workflow_agent set "+
                            "beagenterId="+beagenterId+","+
                            "agenterId="+agenterId+","+
                            "beginDate='"+beginDate+"',"+
                            "beginTime='"+beginTime+"',"+
                            "endDate='"+endDate+"',"+
                            "endTime='"+endTime+"',"+
                            "isCreateAgenter="+isCreateAgenter+" "+
                            "where agentId="+agentid;
        rs1.executeSql(editString);
    }
    catch(Exception e){
        flag = false;
    }
    if(flag){
        response.sendRedirect("wfAgentList.jsp?infoKey=1");
        return;  //xwj for td3218 20051201
    }else{
        response.sendRedirect("wfAgentList.jsp?infoKey=2");
        return;  //xwj for td3218 20051201
    }
}


else{

}
%>


<%! //老数据
public boolean isOldData(String requestid){
RecordSet RecordSetOld = new RecordSet();
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}
return isOldWf_;
}

%>
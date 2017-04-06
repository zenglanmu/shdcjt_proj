<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.workflow.request.*" %>

<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page"/>
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page"/>
<jsp:useBean id="HomepageFiled" class="weaver.homepage.HomepageFiled" scope="page"/>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />


<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页
 
		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		strsqlwherecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>
<%	
	String wftypeSetting="";
	String wflowSetting="";
	String wfNodeSetting="";
	String viewType="１";
	String strSqlWf="";
	String showCopy="1";
	String completeflag="0";
	int isExclude=0;
	
	//更新当前tab信息
	String tabid = Util.null2String(request.getParameter("tabId"));
	String updateSql = "update  hpcurrenttab set currenttab ='"+tabid+"' where eid="
		+ eid
		+ " and userid="
		+ user.getUID()
		+ " and usertype="
		+ user.getType();
	rs.execute(updateSql);
	
  if (!"".equals(strsqlwhere))  { //表示为老版本流程中心
		HomepageSetting.wfCenterUpgrade(strsqlwhere,Util.getIntValue(eid));
   } 

   String scolltype = "";
   rs.execute("select scrolltype from hpelement where id="+eid ); 
   if(rs.next()){
	   scolltype = rs.getString("scrolltype");
   }


   String imgType="";
   String imgSrc ="";
  // String scolltype="";
   rs.execute("select imgtype,imgsrc from hpFieldLength where eid="+eid+" and usertype=3 order by id desc");
   if(rs.next()){
		imgType = rs.getString("imgtype");
		imgSrc = rs.getString("imgsrc");

   }
   String tabId = Util.null2String(request.getParameter("tabId"));
   
   ConnStatement statement=new ConnStatement();
   String sSql="select * from hpsetting_wfcenter where eid="+eid+" and tabId ='"+tabId+"'";
   statement.setStatementSql(sSql) ;	
   statement.executeQuery();     
   if(statement.next()){
	    viewType=Util.null2String(statement.getString("viewType")); 	
	    completeflag=Util.null2String(statement.getString("completeflag")); 		
		
	    showCopy = Util.null2String(statement.getString("showCopy"));
	    if((statement.getDBType()).equals("oracle")){
            CLOB theclob = statement.getClob("typeids");
            String readline = "";
            StringBuffer clobStrBuff = new StringBuffer("");
            BufferedReader clobin;
            if(theclob!=null) {
	            clobin = new BufferedReader(theclob.getCharacterStream());
	            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
	            clobin.close() ;
	            wftypeSetting = clobStrBuff.toString();
            }
            
            
            theclob = statement.getClob("flowids");
            readline = "";
            clobStrBuff = new StringBuffer("");
            if(theclob!=null) {
	            clobin = new BufferedReader(theclob.getCharacterStream());
	            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
	            clobin.close() ;
	            wflowSetting = clobStrBuff.toString();
            }
            
            
            theclob = statement.getClob("nodeids");
            readline = "";
            clobStrBuff = new StringBuffer("");
            if(theclob!=null) {
	            clobin = new BufferedReader(theclob.getCharacterStream());
	            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
	            clobin.close() ;
	            wfNodeSetting = clobStrBuff.toString();
            }            
        }else{
        	wftypeSetting=Util.null2String(statement.getString("typeids")); 
    		wflowSetting=Util.null2String(statement.getString("flowids")); 
    		wfNodeSetting=Util.null2String(statement.getString("nodeids")); 
        }
	    if(!"".equals(wftypeSetting)&&",".equals(wftypeSetting.substring(wftypeSetting.length()-1))){
			wftypeSetting=wftypeSetting.substring(0,wftypeSetting.length()-1);
		}
		if(!"".equals(wflowSetting)&&",".equals(wflowSetting.substring(wflowSetting.length()-1))){
			wflowSetting=wflowSetting.substring(0,wflowSetting.length()-1);
		}
		if(!"".equals(wfNodeSetting)&&",".equals(wfNodeSetting.substring(wfNodeSetting.length()-1))){
			wfNodeSetting=wfNodeSetting.substring(0,wfNodeSetting.length()-1);
		} 
	    isExclude=Util.getIntValue(statement.getString("isExclude"),0);
		
	}		
    statement.close();
   	if(!wftypeSetting.equals("")){
	    if(wftypeSetting.substring(wftypeSetting.length()-1).equals(",")){
	    	wftypeSetting = wftypeSetting.substring(0,wftypeSetting.length()-1);
	    }
   	}
   	String extSql = "";
	if(!"".equals(wflowSetting)){
		extSql = " and f.workflowid in ("+wflowSetting+") ";
	}
	String backFields="";
	String sqlFrom="";
	String sqlWhere="";
	//System.out.println("=============>type="+Util.getIntValue(viewType));
	if(Util.getIntValue(viewType)==1){ //1:待办事宜
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
		if("1".equals(showCopy)){//显示抄送事宜
			sqlWhere="where t1.requestid = t2.requestid and (t2.isremark='0' or  t2.isremark='1' or  t2.isremark='5' or  t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		}else{//不显示抄送事宜
			sqlWhere="where t1.requestid = t2.requestid and (t2.isremark='0' or  t2.isremark='1' or  t2.isremark='5' or  t2.isremark='7') and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		}
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and t2.nodeid not in("+wfNodeSetting+")";
		} else {
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype  in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid  in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and ( t2.nodeid   in("+wfNodeSetting+") or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
		}*/
		
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t2.nodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and (exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t2.nodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" )) ";
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t2.nodeid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and (exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t2.nodeid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" )) ";
			}
		}
		
		
	} else if (Util.getIntValue(viewType)==2){//2:已办事宜
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
	
		sqlWhere="where t1.requestid = t2.requestid and t2.isremark=2 and  t2.iscomplete=0  and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and t1.currentnodeid not in("+wfNodeSetting+") and EXISTS(select 1 from workflow_nownode where nownodeid not in("+wfNodeSetting+") and requestid=t1.requestid)";
		} else {
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t1.currentnodeid in("+wfNodeSetting+") or EXISTS(select 1 from workflow_nownode where nownodeid in("+wfNodeSetting+") and requestid=t1.requestid) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
		}*/
		
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and exists (select 1 from workflow_nownode where not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||nownodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid)";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from workflow_nownode where exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||nownodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid) or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t1.currentnodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and exists (select 1 from workflow_nownode where not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(nownodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid)";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from workflow_nownode where exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(nownodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid) or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t1.currentnodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}
		
		sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
	} else if (Util.getIntValue(viewType)==3){// 3:办结事宜
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
	
		sqlWhere="where t1.requestid = t2.requestid and t2.isremark in('2','4')  and t1.currentnodetype = '3'  and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
		} else {
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
		}*/
		
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
			}
		}
		sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
	} else if (Util.getIntValue(viewType)==4){//4:我的请求
		
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
	
		sqlWhere="where t1.requestid = t2.requestid and t1.creater = "+user.getUID()+" and t1.creatertype = "+(Util.getIntValue(user.getLogintype())-1)+" and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and t1.currentnodeid not in("+wfNodeSetting+") and EXISTS(select 1 from workflow_nownode where nownodeid not in("+wfNodeSetting+") and requestid=t1.requestid)";
		} else {
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
            if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t1.currentnodeid in("+wfNodeSetting+") or EXISTS(select 1 from workflow_nownode where nownodeid in("+wfNodeSetting+") and requestid=t1.requestid) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
		}*/
		
		
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and exists (select 1 from workflow_nownode where not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||nownodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid)";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from workflow_nownode where exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||nownodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid) or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t1.currentnodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and exists (select 1 from workflow_nownode where not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(nownodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid)";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from workflow_nownode where exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(nownodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"') and requestid=t1.requestid) or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t1.currentnodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}
		
		
		if(completeflag.equals("1")){
		    sqlWhere += " and t1.currentnodetype <> '3' ";
		}else if(completeflag.equals("2")){
		    sqlWhere += " and t1.currentnodetype = '3' ";
		}
		sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
	}else if (Util.getIntValue(viewType)==5){//5:抄送事宜
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
	
		sqlWhere="where t1.requestid = t2.requestid and ( t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
				" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);

		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
		} else {
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+")";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
		}*/
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
			}
		}
		
		
	}else if (Util.getIntValue(viewType)==6){//6:督办事宜 
		
		ArrayList  flowList=Util.TokenizerString(wflowSetting,",");	
	
		int logintype = Util.getIntValue(user.getLogintype());
	    int userID = user.getUID();
	    
	    WFUrgerManager.setLogintype(logintype);
	    WFUrgerManager.setUserid(userID);
	    
	    ArrayList wftypes=WFUrgerManager.getWrokflowTree();
	    
	    List requestlist = new ArrayList();
        StringBuffer requestidsb = new StringBuffer();
        StringBuffer requestidsql = new StringBuffer(" 1=2 ");
	    for(int i=0;i<wftypes.size();i++){
	    	WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
	    	ArrayList workflows=wftype.getWorkflows();
	    	
	    	for (int j=0;j<workflows.size();j++){
	    		WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
                String tempWorkflow=wfworkflow.getWorkflowid()+"";
                if("".equals(wflowSetting)||flowList.contains(tempWorkflow)) {
                    ArrayList requests=wfworkflow.getReqeustids();
                    requestlist.addAll(requests);
                    /*
                    for(int k=0;k<requests.size();k++){
                        if(requestids.equals("")){
                            requestids=(String)requests.get(k);
                        }else{
                            requestids+=","+requests.get(k);
                        }
                    }
                    */
                }
	    	}
	    }
	    
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, max(t2.receivedate) as receivedate,t2.receivetime,t1.requestlevel ";
        if (rs.getDBType().equals("oracle")) {
            sqlFrom = " from (select workflowtype,nodeid,workflowid,requestid,max(receivedate||' '||receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid,workflowid,nodeid,workflowtype) t2,workflow_requestbase t1 ";
        } else {
            sqlFrom = " from (select workflowtype,nodeid,workflowid,requestid,max(receivedate+' '+receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid,workflowtype,nodeid,workflowid) t2,workflow_requestbase t1 ";
        }
	
		sqlWhere="where t2.requestid=t1.requestid ";
		for(int i = 0;i<requestlist.size();i++)
		{
			if(requestlist.size()>100)
			{
				if((i%100==0)&&i>0)
				{
					requestidsql.append(" or t1.requestid in(-1").append(requestidsb.toString()).append(") ");
					requestidsb = new StringBuffer();
				}
			}
			requestidsb.append(",").append((String)requestlist.get(i));
		}
    	if(!requestidsb.toString().equals(""))
		{
    		requestidsql.append(" or t1.requestid in(-1").append(requestidsb.toString()).append(") ");
		}
		sqlWhere+=" and ("+requestidsql.toString()+")";
		
		sqlWhere += " group by t1.requestid,t1.creater,t1.creatertype, t1.workflowid, t1.requestname,t2.receivetime,t1.requestlevel ";
	}else if (Util.getIntValue(viewType)==7){//7:超时事宜
		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ";
	
		sqlWhere="where t1.requestid = t2.requestid and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and  ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') "+
				" and t1.currentnodetype <> 3";
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid not in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t2.nodeid not in("+wfNodeSetting+"))";
		}else{
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and (t2.nodeid in("+wfNodeSetting+") or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
		}*/
		
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"')";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t2.nodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t2.nodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"')";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t2.nodeid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') or  exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t2.nodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}
		
		
		
		
		
	}else if (Util.getIntValue(viewType)==8){//8:反馈事宜

		//backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
		backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t2.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark,t2.isprocessed ";
		//sqlFrom=" from workflow_requestbase t1, ( select  receivedate,receivetime,requestid,viewtype,isreminded,nodeid,isremark,workflowtype,workflowid from workflow_currentoperator where "+
		//			" id in( select max(id) from workflow_currentoperator where needwfback=1 and viewtype=-1 and isremark in('2','4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+"  group by requestid) "+
		//			") t2 ";

		sqlFrom=" from workflow_requestbase t1, ( select  receivedate,receivetime,requestid,viewtype,isreminded,nodeid,isremark,workflowtype,workflowid,isprocessed from workflow_currentoperator where "+
					" id in( select max(id) from workflow_currentoperator where needwfback=1 and viewtype=-1 and isremark in('2','4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+"  group by requestid) "+
					") t2 ";
		sqlWhere=" t1.requestid = t2.requestid ";
		
		/*if (isExclude==1){
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype not in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid  not in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and ( t2.nodeid not in("+wfNodeSetting+"))";
		}else{
			if(!"".equals(wftypeSetting)) sqlWhere+=" and t2.workflowtype in("+wftypeSetting+") ";
			if(!"".equals(wflowSetting)) sqlWhere+=" and t2.workflowid in("+wflowSetting+")";
			if(!"".equals(wfNodeSetting)) sqlWhere+=" and ( t2.nodeid in("+wfNodeSetting+")  or t2.nodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ) )";
		}*/
		if(rs.getDBType().equals("oracle")){
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t1.currentnodeid||',%' and eid="+eid+" and tabId ='"+tabId+"')";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||typeids||',' like '%,'||t2.workflowtype||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','||flowids||',' like '%,'||t2.workflowid||',%' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','||nodeids||',' like '%,'||t2.nodeid||',%' and eid="+eid+" and tabId ='"+tabId+"') or exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t2.nodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}else{
			if (isExclude==1){
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and not exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t1.currentnodeid as varchar)+',%' and eid="+eid+" and tabId ='"+tabId+"')";
				
			} else {
				if(!"".equals(wftypeSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(typeids as varchar(8000))+',' like '%,'+CAST(t2.workflowtype as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wflowSetting)) 
					sqlWhere+=" and  exists (select 1 from hpsetting_wfcenter where ','+CAST(flowids as varchar(8000))+',' like '%,'+CAST(t2.workflowid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') ";
				if(!"".equals(wfNodeSetting)) 
					sqlWhere+=" and(  exists (select 1 from hpsetting_wfcenter where ','+CAST(nodeids as varchar(8000))+',' like '%,'+CAST(t2.nodeid as varchar)+'%,' and eid="+eid+" and tabId ='"+tabId+"') or  exists (select 1 from  workflow_nodebase n, workflow_flownode f where n.id=t2.nodeid and n.id=f.nodeid and n.isfreenode='1' "+extSql+"  ))";
				
			}
		}
		sqlWhere += WorkflowComInfo.getDateDuringSql(WorkflowComInfo.getDateDuringForFirst());
	}
	//System.out.println(sqlFrom+sqlWhere);
	
	//out.println("viewType:"+viewType);
	//out.println("backFields:"+backFields);
	sppb.setBackFields(backFields);
	sppb.setPrimaryKey("t1.requestid");
	sppb.setDistinct(true);
	//sppb.setIsPrintExecuteSql(true);
	sppb.setSqlFrom(sqlFrom);
	sppb.setSqlWhere(sqlWhere); 
	if (Util.getIntValue(viewType)==6) {
		sppb.setSqlOrderBy("receivedate ,t2.receivetime");
	}else {
		sppb.setSqlOrderBy("t2.receivedate ,t2.receivetime");
	}
	sppb.setSortWay(sppb.DESC);
	
	spu.setRecordCount(perpage);
	spu.setSpp(sppb);


	String imgSymbol="";
	if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
	
	
	String  strStyle="";
	if("1".equals(isFixationRowHeight)) strStyle+="height:"+(perpage*23)+"px;";
	if(!"".equals(background)) strStyle+="background:url('/weaver/weaver.file.FileDownload?fileid="+background+"');";
		int rowcount=0;
				
		rs=spu.getCurrentPageRs(1,perpage);
		int height = rs.getCounts()*23;
	//System.out.println(strStyle);
%>

	  <%
		if("Up".equals(scolltype)||"Down".equals(scolltype)) {
			out.println("<MARQUEE DIRECTION="+scolltype+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200 height="+height+">");
		}else if("Left".equals(scolltype)||"Right".equals(scolltype)) {
			out.println("<MARQUEE DIRECTION="+scolltype+"  id=\"webjx_"+eid+"\" onmouseover=\"webjx_"+eid+".stop()\" onmouseout=\"webjx_"+eid+".start()\"  SCROLLDELAY=200>");
		}
	 %>
<TABLE  style="<%=strStyle%>" id="_contenttable_<%=eid%>" class=Econtent  width=100%>
   <TR valign='middle'>
	 <TD width=1px valign='middle'>
	 <%if(imgType.equals("1")){ %>
		<img src='<%=imgSrc%>' />
	 <%} %>
	 </TD>
	 <TD width='*' valign="top">
		<TABLE width="100%">    
		<%
		String receivetime = "";
		while (rs.next()){
			String requestid=Util.null2String(rs.getString("requestid"));			
			String workflowid=Util.null2String(rs.getString("workflowid"));
			String nodeid=Util.null2String(rs.getString("nodeid"));
			String workflowtype=Util.null2String(rs.getString("workflowtype"));
			String requestlevel=Util.null2String(rs.getString("requestlevel"));
			String creater=Util.null2String(rs.getString("creater"));
			String isremark=Util.null2String(rs.getString("isremark"));
			
		%>
		<TR  height="18px" >
                <TD width="8"><%=imgSymbol%></TD>
				<%					
					int size=fieldIdList.size();
					for(int i=0;i<size;i++){
                        String fieldId=(String)fieldIdList.get(i);
                        String columnName=(String)fieldColumnList.get(i);
                        String strIsDate=(String)fieldIsDate.get(i);
                        String fieldTransMethod=(String)fieldTransMethodList.get(i);
                        String fieldwidth=(String)fieldWidthList.get(i);
                        String linkurl=(String)linkurlList.get(i);
                        String valuecolumn=(String)valuecolumnList.get(i);	

                        String isLimitLength=(String)isLimitLengthList.get(i);
                        String showValue="";                    
                        String cloumnValue=Util.null2String(rs.getString(columnName)); 
                        String titleValue = cloumnValue;
                        //cloumnValue = "<font >"+cloumnValue+"</font>";
                        
                       	String nameTdTitle="";
                        if("requestname".equals(columnName)){   
                        	//改为按要求显示自定义流程标题的前缀信息
							String nodetitle="";
							if(Util.getIntValue(viewType)!=6){ //非督办
								if("0".equals(isremark)){
									rsIn.executeSql("select nodetitle from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
								}else{
									if(rsIn.getDBType().equals("oracle")){
										rsIn.executeSql("select nodetitle from workflow_flownode f, (select nodeid from workflow_currentoperator t2 where rownum = 1 and t2.isremark=0 and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and t2.requestid="+requestid+" order by  t2.receivedate desc, t2.receivetime desc ) n where f.workflowid="+workflowid+" and f.nodeid = n.nodeid ");
									}else{
										rsIn.executeSql("select nodetitle from workflow_flownode where workflowid="+workflowid+" and nodeid = (select top 1 nodeid from workflow_currentoperator t2 where t2.isremark=0 and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and t2.requestid="+requestid+" order by  t2.receivedate desc, t2.receivetime desc ) ");
									}
								}
								if(rsIn.next()){
									nodetitle = Util.null2String(rsIn.getString("nodetitle"));
								}
							}  
							nameTdTitle=titleValue;
							if("".equals(nodetitle)) cloumnValue=cloumnValue;   
							else 	cloumnValue="（"+nodetitle+"）"+cloumnValue;  
							                 
                        }                                      
                        //if("1".equals(isLimitLength))   cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
						if("1".equals(isLimitLength)){

							cloumnValue=Util.StringReplace(cloumnValue,"&lt;","<");	
							cloumnValue=Util.StringReplace(cloumnValue,"&gt;",">");	
							cloumnValue=Util.StringReplace(cloumnValue,"&quot;","\"");
							cloumnValue=Util.StringReplace(cloumnValue,"&nbsp;"," ");

							cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
						}
                       	
			  %>
			  <%if("requestname".equals(columnName)){%>
				<td width="<%=fieldwidth%>" title="<%=nameTdTitle%>">
					<%		
					
						cloumnValue = "<font class=font><span  onclick='javaScript:setWorkFlowRefresh("+eid+","+ebaseid+")' >"+cloumnValue+"</span></font>";
						String strName="";	
						if(Util.getIntValue(viewType)==6){
							String para2 = requestid+"+"+workflowid+"+"+user.getUID()+"+"+(Util.getIntValue(user.getLogintype())-1)+"+"+ user.getLanguage();
							strName=WorkFlowTransMethod.getWfNewLinkByUrger(cloumnValue,para2);
						} else {
							
							//if(Util.getIntValue(viewType)==1)
							//{
								int isbill=0;
								int formid=0;
								////根据后台设置在MAIL标题后加上流程中重要的字段
								rsIn.execute("select formid,isbill from workflow_base where id="+workflowid);
								if (rsIn.next()){
									formid=rsIn.getInt(1);
									isbill=rsIn.getInt(2);
									
								}
								MailAndMessage mailTitle=new MailAndMessage();
								String titles=mailTitle.getTitle(Util.getIntValue(requestid,-1),Util.getIntValue(workflowid,-1),formid,user.getLanguage(),isbill);
								if(!titles.equals("")) {
									cloumnValue+="<b>（"+titles+"）</b>";
									//out.println("<b>（"+titles+"）</b>");
								}
							//}
							
							strName=HomepageFiled.getRequestNewLink(rs,user,cloumnValue,linkmode);
						}	
					
						 //strName = "<font class=font>"+strName+"</font>";
						out.println(strName);
					%>
				</td>
			 <%}%>  
				
			 <%if("importantleve".equals(columnName)){%>
				<td width="<%=fieldwidth%>"><%="<font class=font>"+WorkFlowTransMethod.getWFSearchResultUrgencyDegree(requestlevel,""+user.getLanguage())+"</font>"%></td>
			  <%}%>  
				
				
			   <%if("creater".equals(columnName)){
			  
			   String tmpValue = HomepageFiled.getHrmStr(rs,user,cloumnValue,linkmode);
			   tmpValue = tmpValue.substring(0,tmpValue.indexOf(">")+1)+"<font class=font>"+tmpValue.substring(tmpValue.indexOf(">")+1,tmpValue.indexOf("</a>"))+"</font>"+tmpValue.substring(tmpValue.indexOf("</a>"),tmpValue.length());
			   %>
				<td width="<%=fieldwidth%>"><%=tmpValue%></td>
			  <%}%>

			   <%if("createrDept".equals(columnName)){%>
				<td width="<%=fieldwidth%>">
					<%="<font class=font>"+DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(creater))+"</font>"%>
			   </td>
			  <%}%>

			   <%if("workflowtype".equals(columnName)){%>
				<td  width="<%=fieldwidth%>">
					<%="<font class=font>"+WorkflowComInfo.getWorkflowname(workflowid)+"</font>"%>
				</td>
			  <%}%>
			   <%
				if(Util.getIntValue(viewType)==6){//TD:39434
				    cloumnValue = Util.null2String(rs.getString("receivedate"));
				    receivetime = cloumnValue.substring(11);
				    cloumnValue = cloumnValue.substring(0,10);
			    }	 	
				if("receivedate".equals(columnName)){%>
				<td width="<%=fieldwidth%>"><%="<font class=font>"+cloumnValue+"</font>"%></td>
			  <%}%>

			  <%if("receivetime".equals(columnName)){
				  if(Util.getIntValue(viewType)==6){
					cloumnValue = receivetime;
				  }
				  %>
				<td width="<%=fieldwidth%>"><%="<font class=font>"+cloumnValue+"</font>"%></td>
			  <%}%>

			<%}%>
		</TR>
		<%
		rowcount++;
		if(perpage!=1&&rowcount<perpage){
		%>		
		 <TR class='sparator' style='height:1px' height=1px><td style='padding:0px' colspan=<%=size+1%>></td></TR>
		 <%}%>
		<%}%>
		 </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>
<%if("Left".equals(scolltype)||"Right".equals(scolltype)||"Up".equals(scolltype)||"Down".equals(scolltype)) 
	out.println("</MARQUEE>");
%>



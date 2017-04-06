<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.homepage.cominfo.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />

<%@ include file="/systeminfo/init.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title></title>
</head>
<body>
<%
	int eid= Util.getIntValue(request.getParameter("eid"),0) ;
	int tabid = Util.getIntValue(request.getParameter("tabid"),0);
	int completeflag = Util.getIntValue(request.getParameter("completeflag"),0);
	if(tabid==0){
		rs.execute("select * from hpsetting_wfcenter where eid="+eid +" order by tabId");
		rs.next();
		tabid = Util.getIntValue(rs.getString("tabId"));
		completeflag = Util.getIntValue(rs.getString("completeflag"));
	}
	if(eid==0) return;	
	int wfviewtype= Util.getIntValue(request.getParameter("viewtype"),-1) ;

	String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
	int usertype = 0;
	String logintype = ""+user.getLogintype();
	//System.out.println(userid+"=="+user.getUID());
	if(userid.equals("")||!userid.equals(""+user.getUID())) {
		userid = ""+user.getUID();
		session.setAttribute("RequestViewResource",userid) ;
		if(logintype.equals("2")) usertype= 1;
	}
	
	 
	String strsqlwhere=hpec.getStrsqlwhere(""+eid);
	if(strsqlwhere.equals("")){
		String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" and tabId="+tabid;
		rs.execute(tabSql);
		strsqlwhere = rs.getString("sqlWhere");
	}
    int viewType=0;
	 
	String wftypeSetting=""; 
	String wfids="";
	String nodeids="";
	String strSqlWf="";
	int isExclude=0;
	String showCopy="1";
	
	//if (!"".equals(strsqlwhere))  { //表示为老版本流程中心
	//	HomepageSetting.wfCenterUpgrade(strsqlwhere,eid);
    //} 
	ConnStatement statement=new ConnStatement();
   String sSql="select * from hpsetting_wfcenter where eid="+eid+" and tabId="+tabid;
   statement.setStatementSql(sSql) ;	
   statement.executeQuery();     
   if(statement.next()){
	    viewType=Util.getIntValue(statement.getString("viewType")); 		
	    showCopy = Util.null2String(statement.getString("showCopy"));
	    completeflag = Util.getIntValue(statement.getString("completeflag"));
		
	    if((statement.getDBType()).equals("oracle")){
            CLOB theclob = statement.getClob("typeids");
            String readline = "";
            StringBuffer clobStrBuff = new StringBuffer("");
            BufferedReader clobin ;
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
	            wfids = clobStrBuff.toString();
            }
            
            
            theclob = statement.getClob("nodeids");
            readline = "";
            clobStrBuff = new StringBuffer("");
            if(theclob!=null) {
	            clobin = new BufferedReader(theclob.getCharacterStream());
	            while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
	            clobin.close() ;
	            nodeids = clobStrBuff.toString();    
            }            
        }else{
        	wftypeSetting=Util.null2String(statement.getString("typeids")); 
        	wfids=Util.null2String(statement.getString("flowids")); 
        	nodeids=Util.null2String(statement.getString("nodeids")); 
        }
	    isExclude=Util.getIntValue(statement.getString("isExclude"),0);
		
	}		
    statement.close();
    
	//System.out.println("wfids:"+wfids);
	//System.out.println("nodeids:"+nodeids);
	String extSql = "";
	if(!"".equals(wfids)){
		extSql = " and f.workflowid in ("+wfids+") ";
	}
	
  	String inSelectedStr="";
  	String whereclause="";
	String orderclause="";
	String orderclause2="";

	SearchClause.resetClause();
	if(viewType==1){ //待办事宜
		if(!"".equals(wfids)){
			
			if(!"".equals(nodeids)){
				if (isExclude==1){
					inSelectedStr += "t1.workflowid not in ("+wfids+") and t1.currentnodeid not in ("+nodeids+") ";
				} else {
					inSelectedStr += "t1.workflowid in ("+wfids+") and (t1.currentnodeid  in ("+nodeids+") or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ) )";
				}				
			}else{
				if (isExclude==1){
					inSelectedStr += "t1.workflowid not in ("+wfids+") ";
				} else {
					inSelectedStr += "t1.workflowid in ("+wfids+") ";
				}
				
			}
		}
		whereclause += inSelectedStr;
		if("1".equals(showCopy)){//显示抄送事宜
			if("".equals(whereclause)){
				whereclause +=" t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
			}else{
				whereclause +=" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1";
			}
		}else{//不显示抄送事宜
			if("".equals(whereclause)){
				whereclause +=" t2.isremark in( '0','1','5','7') and t2.islasttimes=1";
			}else{
				whereclause +=" and t2.isremark in( '0','1','5','7') and t2.islasttimes=1";
			}
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	    
	    //System.out.println("isExclude:"+isExclude);
		//System.out.println("whereclause:"+whereclause);
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&iswaitdo=1");
		
	}else if(viewType==2){ //已办事宜
		if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
                if(!"".equals(nodeids)) inSelectedStr+=" and t1.currentnodeid not in("+nodeids+") and EXISTS(select 1 from workflow_nownode where nownodeid not in("+nodeids+") and requestid=t1.requestid)";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
                if(!"".equals(nodeids)) inSelectedStr+=" and (t1.currentnodeid in("+nodeids+") or EXISTS(select 1 from workflow_nownode where nownodeid in("+nodeids+") and requestid=t1.requestid) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
			}			
		}
		whereclause += inSelectedStr;
		if("".equals(whereclause)){
			whereclause = "t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
		}else{
			whereclause += " and t2.isremark ='2'  and t2.iscomplete=0 and t2.islasttimes=1 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	}else if(viewType==3){ //办结事宜
		if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}
		whereclause += inSelectedStr;
		if("".equals(whereclause)){
			whereclause = "t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
		}else{
			whereclause += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
   	}else if(viewType==4){ //我的请求
   		if(!"".equals(wfids)){
   			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
                if(!"".equals(nodeids)) inSelectedStr+=" and t1.currentnodeid not in("+nodeids+") and EXISTS(select 1 from workflow_nownode where nownodeid not in("+nodeids+") and requestid=t1.requestid)";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
                if(!"".equals(nodeids)) inSelectedStr+=" and (t1.currentnodeid in("+nodeids+") or EXISTS(select 1 from workflow_nownode where nownodeid in("+nodeids+") and requestid=t1.requestid) or t1.currentnodeid in (select n.id from workflow_nodebase n, workflow_flownode f where n.id=f.nodeid and n.isfreenode='1' "+extSql+" ))";
			}
		}
		whereclause += inSelectedStr;
		
		if("".equals(whereclause)){
			whereclause +=" t1.creater = "+userid+" and t1.creatertype = " + usertype;
		}else{
			whereclause +=" and t1.creater = "+userid+" and t1.creatertype = " + usertype;
		}
		whereclause += " and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
		if(completeflag==1){
		    whereclause += " and t1.currentnodetype <> '3' ";
		}else if(completeflag==2){
		    whereclause += " and t1.currentnodetype = '3' ";
		}
		//System.out.println("whereclause=="+whereclause);
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	}else if(viewType==5){ //抄送事宜
		if(!"".equals(wfids)){
			
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}
		}
	
		whereclause += inSelectedStr;
	
		if("".equals(whereclause)){
			whereclause +=" t2.isremark in ('8', '9','7') ";
		}else{
			whereclause +=" and t2.isremark in ('8', '9','7') ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		
		//whereclause+="  and t2.workflowtype!=1 ";
	
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	}else if(viewType==6){ //督办事宜
		if(!"".equals(wfids)){
		
			inSelectedStr += "t1.workflowid in ("+wfids+") ";
		}
		whereclause += inSelectedStr;
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	    SearchClause.setWorkflowId(wfids);
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSuperviseList.jsp?method=workflow");
		
	}else if(viewType==7){ //超时事宜
		if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}
		whereclause += inSelectedStr;
		
		if("".equals(whereclause)){
			whereclause +=" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
	        whereclause += " and t1.currentnodetype <> 3 ";
		}else{
			whereclause +=" and ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') ";
	        whereclause += " and t1.currentnodetype <> 3 ";
		}
		if(wfviewtype!=-1)		whereclause+=" and t2.viewtype="+wfviewtype;
		//whereclause+="  and t2.workflowtype!=1 ";
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	}else if(viewType==8){ //反馈事宜
		if(!"".equals(wfids)){
			if (isExclude==1){
				inSelectedStr += "t1.workflowid not in ("+wfids+") ";
			} else {
				inSelectedStr += "t1.workflowid in ("+wfids+") ";
			}			
		}
		whereclause += inSelectedStr;
	
		if(!"".equals(whereclause)){
			whereclause +=" and ";
		}
		whereclause += " t2.needwfback=1 and viewtype=-1 and isremark in('2','4') and t1.requestid = t2.requestid and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1);		
		whereclause += " and t2.id in(select max(id) from workflow_currentoperator where needwfback = 1 and viewtype = -1 and isremark in ('2', '4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+" group by requestid)";
		
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	} else{ //不是以上任何一个，跳转到安全页面
		inSelectedStr += "t1.workflowid in (0) ";
		whereclause += inSelectedStr;
		SearchClause.setWhereClause(whereclause);
	
	    orderclause="t2.receivedate ,t2.receivetime ";
	
	    SearchClause.setOrderClause(orderclause);
	    SearchClause.setOrderClause2(orderclause2);
	
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1");
		
	}
%>
</body>
</html>
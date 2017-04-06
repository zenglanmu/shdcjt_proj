<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*,java.text.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
	String userRights=shareRights.getUserRights("-11", user);//得到用户查看范围
	if(userRights.equals("-100")){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String objIds=Util.null2String(request.getParameter("objId"));
	String ownDepid = resourceComInfo.getDepartmentID(""+user.getUID());
	String ownDepName = departmentComInfo.getDepartmentname(ownDepid);
	if("".equals(objIds)){
		objIds = ownDepid;
	}
	String imagefilename = "/images/hdReport.gif" ; 
	String titlename = SystemEnv.getHtmlLabelName(21899,user.getLanguage()) ; 
	String needfav = "1" ;
	String needhelp = "" ;
	String objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
	int objType1=Util.getIntValue(request.getParameter("objType"), 2);

	String objidShow = Util.null2String(request.getParameter("objId"));
	if("".equals(objidShow)){
		objidShow = ownDepid;
	}
	String objnameShow = "";
	if(!"".equals(objidShow) && !"0".equals(objidShow)){
		ArrayList objidList_tmp = Util.TokenizerString(objidShow, ",");
		objidShow = "";
		for(int cx=0; cx<objidList_tmp.size(); cx++){
			int objid = Util.getIntValue((String)objidList_tmp.get(cx), 0);
			if(objid > 0){
				if(objType1 == 1){//人力资源
					objidShow += (","+ objid);
					objnameShow += ("<a href='javaScript:openhrm("+objid+")' onclick='pointerXY(event)'>"+resourceComInfo.getLastname(""+objid)+"</a>"+"&nbsp;");
				}else if(objType1 == 2){//部门
					objidShow += (","+ objid);
					objnameShow += ("<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+objid+" target=_new>"+departmentComInfo.getDepartmentname(""+objid)+"</a>"+"&nbsp;");
				}else if(objType1 == 3){//分部
					objidShow += (","+ objid);
					objnameShow += ("<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+objid+" target=_new>"+subCompanyComInfo.getSubCompanyname(""+objid)+"</a>"+"&nbsp;");
				}
			}
		}
		if(!"".equals(objidShow)){
			objidShow = objidShow.substring(1);
		}
	}
	String objidStr = "";
	String sql4Right = "";
	Hashtable subcompanyid1_sh = new Hashtable();
	if("".equals(userRights)){
		if(objType1 == 1){//人力资源
			sql4Right = "select id from hrmresource where id in ("+objIds+")";
		}else if(objType1 == 2){//部门
			sql4Right = "select id from hrmdepartment where id in ("+objIds+")";
		}else if(objType1 == 3){//分部
			sql4Right = "select id, subcompanyid1 from hrmdepartment where subcompanyid1 in ("+objIds+")";
		}
	}else{
		if(objType1 == 1){//人力资源
			sql4Right = "select id from hrmresource where departmentid in ("+userRights+") and id in ("+objIds+")";
		}else if(objType1 == 2){//部门
			sql4Right = "select id from hrmdepartment where id in ("+userRights+") and id in ("+objIds+")";
		}else if(objType1 == 3){//分部
			sql4Right = "select id, subcompanyid1 from hrmdepartment where id in ("+userRights+") and subcompanyid1 in ("+objIds+")";
		}
	}
	rs.execute(sql4Right);
	objIds = "";//拼下面的SQL，还是用这个变量
	while(rs.next()){
		int id_tmp = Util.getIntValue(rs.getString(1), 0);
		if(id_tmp > 0){
			objIds += (","+ id_tmp);
			if(objType1 == 1){//人力资源
				objidStr += (","+ id_tmp);
			}else if(objType1 == 2){//部门
				objidStr += (","+ id_tmp);
			}else if(objType1 == 3){//分部
				int subcompanyid1_tmp = Util.getIntValue(rs.getString(2), 0);
				int hasSuchSubCompanyid = Util.getIntValue((String)subcompanyid1_sh.get("subcompanyid1_tmp"+subcompanyid1_tmp), 0);
				if(hasSuchSubCompanyid == 0){
					objidStr += (","+ subcompanyid1_tmp);
					subcompanyid1_sh.put("subcompanyid1_tmp"+subcompanyid1_tmp, "1");
				}
			}
		}
	}
	if(!"".equals(objIds)){
		objIds = objIds.substring(1);
		objidStr = objidStr.substring(1);
	}else{
		objIds = "0";
		objidStr = "";
	}

	String wfIds = Util.null2String(request.getParameter("wfId"));
	String wfNames = Util.null2String(request.getParameter("wfNames"));
	String sqlCondition=" ";  //未查询前不显示记录
	String sql="";
	String datefrom = Util.toScreenToEdit(request.getParameter("datefrom"),user.getLanguage());
	String dateto = Util.toScreenToEdit(request.getParameter("dateto"),user.getLanguage());
	String isthisWeek = Util.null2String(request.getParameter("isthisWeek"));
	String isthisMonth = Util.null2String(request.getParameter("isthisMonth"));
	String isthisSeason = Util.null2String(request.getParameter("isthisSeason"));
	String isthisYear = Util.null2String(request.getParameter("isthisYear"));

	if(!"1".equals(isthisYear) && !"1".equals(isthisMonth) && !"1".equals(isthisWeek) && !"1".equals(isthisSeason) && "".equals(datefrom) && "".equals(dateto)){
		isthisMonth = "1";
	}
	String sqlIsvalid = " and exists (select 1 from workflow_base where workflow_base.id=c.workflowid and isvalid='1') ";
	sqlCondition=" and exists (select 1 from hrmresource where id=c.userid and hrmresource.status in (0,1,2,3) )";
	//System.out.println("userRights = " + userRights);
	Calendar now = Calendar.getInstance();
	String today=Util.add0(now.get(Calendar.YEAR), 4) +"-"+Util.add0(now.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(now.get(Calendar.DAY_OF_MONTH), 2) ;
	int year=now.get(Calendar.YEAR);
	int month=now.get(Calendar.MONTH);
	int day=now.get(Calendar.DAY_OF_MONTH);
    String sql2="";
	String sqlfrom="";
	String wfSql = "";
	String timeSql1 = " ";//countType == 1
	String timeSql2 = " ";//countType == 2
	String timeSql3 = " ";//countType == 3
	String timeSql4 = " ";//countType == 4
	String timeSql5 = " ";//countType == 5
	String timeSql6 = " ";//countType == 6
	String linkSql1 = "";
	String linkSql2 = "";
	String linkSql3 = "";
	String linkSql4 = "";
	String linkSql5 = "";
	String linkSql6 = "";
	Hashtable count_hs = new Hashtable();
	if(!"".equals(wfIds)){
		wfSql += " and c.workflowid in ("+wfIds + ") ";
	}
	if("1".equals(isthisWeek)){
		int days=now.getTime().getDay();
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,day-days);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		datefrom = lastday;
		dateto = today;
		timeSql1 += " and ((c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"') or (c.operatedate <='"+today+"' and c.operatedate >= '"+lastday+"')) " ;
		timeSql2 += " and a.createdate <='"+today+"' and a.createdate >='"+lastday+"' ";
		timeSql3 += " and c.operatedate <='"+today+"' and c.operatedate >='"+lastday+"' ";
		timeSql4 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql5 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql6 += " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark=4 ) and ( c.receivedate <='"+today+"' and c.receivedate >='"+lastday+"' ) ";
	}else if("1".equals(isthisMonth)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		datefrom = lastday;
		dateto = today;
		timeSql1 += " and ((c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"') or (c.operatedate <='"+today+"' and c.operatedate >= '"+lastday+"')) " ;
		timeSql2 += " and a.createdate <='"+today+"' and a.createdate >='"+lastday+"' ";
		timeSql3 += " and c.operatedate <='"+today+"' and c.operatedate >='"+lastday+"' ";
		timeSql4 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql5 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql6 += " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark=4 ) and ( c.receivedate <='"+today+"' and c.receivedate >='"+lastday+"' ) ";
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
		System.out.println("month = " + month);
		System.out.println("month_season = " + month_season);
		System.out.println("lastday = " + lastday);
		datefrom = lastday;
		dateto = today;
		timeSql1 += " and ((c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"') or (c.operatedate <='"+today+"' and c.operatedate >= '"+lastday+"')) " ;
		timeSql2 += " and a.createdate <='"+today+"' and a.createdate >='"+lastday+"' ";
		timeSql3 += " and c.operatedate <='"+today+"' and c.operatedate >='"+lastday+"' ";
		timeSql4 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql5 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql6 += " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark=4 ) and ( c.receivedate <='"+today+"' and c.receivedate >='"+lastday+"' ) ";
	}else if("1".equals(isthisYear)){
		Calendar tempday = Calendar.getInstance();
		tempday.clear();
		tempday.set(year,month,1);
		String lastday = Util.add0(tempday.get(Calendar.YEAR), 4) +"-01-01";
		datefrom = lastday;
		dateto = today;
		timeSql1 += " and ((c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"') or (c.operatedate <='"+today+"' and c.operatedate >= '"+lastday+"')) ";
		timeSql2 += " and a.createdate <='"+today+"' and a.createdate >='"+lastday+"' ";
		timeSql3 += " and c.operatedate <='"+today+"' and c.operatedate >='"+lastday+"' ";
		timeSql4 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql5 += " and c.receivedate <='"+today+"' and c.receivedate >= '"+lastday+"' ";
		timeSql6 += " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark=4 ) and ( c.receivedate <='"+today+"' and c.receivedate >='"+lastday+"' ) ";
	}else{
		if(!"".equals(datefrom)){
			timeSql2 += " and a.createdate >='"+datefrom+"' ";
			timeSql3 += " and c.operatedate >='"+datefrom+"' ";
			timeSql4 += " and c.receivedate >= '"+datefrom+"' ";
			timeSql5 += " and c.receivedate >= '"+datefrom+"' ";
			timeSql6 += " and c.receivedate >='"+datefrom+"' ";
		}
		if(!"".equals(dateto)){
			timeSql2 += " and a.createdate <='"+dateto+"' ";
			timeSql3 += " and c.operatedate <='"+dateto+"' ";
			timeSql4 += " and c.receivedate <='"+dateto+"' ";
			timeSql5 += " and c.receivedate <='"+dateto+"' ";
			timeSql6 += " and c.receivedate <='"+dateto+"' ";
		}
		if(!"".equals(datefrom) && !"".equals(dateto)){
			timeSql1 += " and ((c.receivedate <='"+dateto+"' and c.receivedate >= '"+datefrom+"') or (c.operatedate <='"+dateto+"' and c.operatedate >= '"+datefrom+"')) ";
		}else if(!"".equals(datefrom)){
			timeSql1 += " and (c.receivedate >= '"+datefrom+"' or c.operatedate >= '"+datefrom+"') ";
		}else if(!"".equals(dateto)){
			timeSql1 += " and (c.receivedate <='"+dateto+"' or c.operatedate <='"+dateto+"') ";
		}
		if(!"".equals(timeSql6)){
			timeSql6 = " and exists (select c2.requestid from workflow_currentoperator c2 where c2.requestid=c.requestid and c2.isremark=4 ) " + timeSql6;
		}
	}
	switch (objType1){
		case 1:
	        objType=SystemEnv.getHtmlLabelName(1867,user.getLanguage());
	        sql = "select count(distinct c.requestid) as count, '1' as countType, userid as objid from workflow_currentoperator c where c.islasttimes=1 and workflowtype>1 and usertype='0'  and c.userid in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql1;
			sql += " group by userid";
			linkSql1 += " c.requestid=a.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql1 + " and c.userid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_1", count_tmp);
			}
			sql = "select count(distinct a.requestid) as count, '2' as countType, a.creater as objid from workflow_currentoperator c, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0'  and a.creater in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
			sql += " group by creater";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql2 + " and a.creater=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_2", count_tmp);
			}
			sql = "select count(distinct c.requestid) as count, '3' as countType, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0'  and c.userid in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
			sql += " group by userid";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql3 + " and c.userid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_3", count_tmp);
			}
			sql = "select count(distinct c.requestid) as count, '4' as countType, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0'  and c.userid in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
			sql += " group by userid";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql4 + " and c.userid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_4", count_tmp);
			}
			sql = "select count(distinct c.requestid) as count, '5' as countType, userid as objid from workflow_currentoperator c where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and workflowtype>1 and usertype='0'  and c.userid in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
			sql += " group by userid";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql5 + " and c.userid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_5", count_tmp);
			}
			sql = "select count(distinct c.requestid) as count, '6' as countType, userid as objid from workflow_currentoperator c where c.islasttimes=1 and workflowtype>1 and usertype='0'  and userid in ("+objIds+") " + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
			sql += " group by userid";
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' " + sqlCondition + " " + wfSql + timeSql6 + " and c.userid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_6", count_tmp);
			}

	        break;
		case 2:
			objType=SystemEnv.getHtmlLabelName(124,user.getLanguage());
			sql = "select count(distinct c.requestid) as count, '1' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql1;
	        sql+=" group by h.departmentid";
			linkSql1 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql1 + " and h.departmentid="; 
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_1", count_tmp);
			}
			sql ="select count(distinct a.requestid) as count, '2' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
	        sql+=" group by h.departmentid";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater " + sqlCondition + " " + wfSql + timeSql2 + " and h.departmentid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_2", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '3' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
	        sql+=" group by h.departmentid";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql3 + " and h.departmentid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_3", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '4' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
	        sql+=" group by h.departmentid";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql4 + " and h.departmentid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_4", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '5' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
	        sql+=" group by h.departmentid";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql5 + " and h.departmentid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_5", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '6' as countType, h.departmentid as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
	        sql+=" group by h.departmentid";
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql6 + " and h.departmentid=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_6", count_tmp);
			}

	        break;
		case 3:
	        objType=SystemEnv.getHtmlLabelName(141,user.getLanguage());
			sql = "select count(distinct c.requestid) as count, '1' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h  where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql1;
	        sql+=" group by h.subcompanyid1";
			linkSql1 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql1 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_1", count_tmp);
			}
			sql ="select count(distinct a.requestid) as count, '2' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h, workflow_requestbase a where c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql2;
	        sql+=" group by h.subcompanyid1";
			linkSql2 += " c.islasttimes=1 and a.requestid=c.requestid and workflowtype>1 and usertype='0' and  h.id=a.creater " + sqlCondition + " " + wfSql + timeSql2 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_2", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '3' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql3;
	        sql+=" group by h.subcompanyid1";
			linkSql3 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (2, 4) and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql3 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_3", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '4' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql4;
	        sql+=" group by h.subcompanyid1";
			linkSql4 += " a.requestid=c.requestid and c.islasttimes=1 and c.isremark in (0, 1, 8, 9,7) and viewtype=0 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql4 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_4", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '5' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql5;
	        sql+=" group by h.subcompanyid1";
			linkSql5 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and c.isremark in (0, 1, 8, 9,7) and viewtype in (-1, -2) and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql5 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			rs.execute(sql);
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_5", count_tmp);
			}
			sql ="select count(distinct c.requestid) as count, '6' as countType, h.subcompanyid1 as objid from workflow_currentoperator c, hrmresource h where c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid and h.departmentid in ("+objIds+")" + sqlCondition + " " + sqlIsvalid;
			sql += wfSql + timeSql6;
	        sql+=" group by h.subcompanyid1";
			rs.execute(sql);
			linkSql6 += " a.requestid=c.requestid and c.islasttimes=1 and workflowtype>1 and usertype='0' and  h.id=c.userid " + sqlCondition + " " + wfSql + timeSql6 + " and h.departmentid in ("+objIds+") and h.subcompanyid1=";
			while(rs.next()){
				String objid_tmp = Util.null2o(rs.getString("objid"));
				String count_tmp = Util.null2o(rs.getString("count"));
				count_hs.put(objid_tmp+"_6", count_tmp);
			}
	        break;
	}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(2073,user.getLanguage())+",javascript:onClearSwiftAll(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="DocWfReport.jsp" method=post>
<input name=isthisWeek type=hidden value="<%=isthisWeek%>">
<input name=isthisMonth type=hidden value="<%=isthisMonth%>">
<input name=isthisSeason type=hidden value="<%=isthisSeason%>">
<input name=isthisYear type=hidden value="<%=isthisYear%>">
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
    <BUTTON type=button class=Browser <%if (objType1==2||objType1==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName')" name=showresource></BUTTON> 
	<BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName')" name=showdepartment></BUTTON> 
    <BUTTON type=button class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none"  <%}%> onClick="onShowBranch('objId','objName')" name=showBranch></BUTTON>
	<SPAN id=objName>
	<%=objnameShow%>
	</SPAN><SPAN id=nameimage>
	<%if (objidShow.equals("") || objidShow.equals("0")) {%>
	<IMG src='/images/BacoError.gif' align=absMiddle></IMG>
	<%}%>
	</SPAN> 
	<input type=hidden name="objId" id="objId" value="<%="0".equals(objidShow)?"":objidShow%>">
	</td>
	<td width="5%">
    <%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>
    </td>
    <td class=field width="28%">
	<input class=wuiBrowser type=hidden name="wfId" id="wfId" value="<%=wfIds%>"
	_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp"
	_trimLeftComma="yes" _callBack="onShowWorkflow"   _displayText="<%=wfNames%>"
	>
	
	<input type=hidden name="wfNames" id="wfNames" value="<%=wfNames%>">
	</td>
	<td width="5%">
    <%=SystemEnv.getHtmlLabelName(19482, user.getLanguage())%>
    </td>
    <td class=field width="28%">
		<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>:<button type=button class=calendar id=SelectDate onClick="getDate(datefromspan,datefrom)"></button>&nbsp;
		<span id=datefromspan ><%=datefrom%></span>-&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>:
		<button type=button  class=calendar id=SelectDate2 onClick="getDate(datetospan,dateto)"></button>&nbsp;
		<span id=datetospan><%=dateto%></span>
		<input type="hidden" name="datefrom" value="<%=datefrom%>">
		<input type="hidden" name="dateto" value="<%=dateto%>">
	</td>
	</tr>
    <TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=6></TD></TR>
	<tr>
	<td colspan="6">
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
	</tr>
	<TR class=Separartor style="height:2px"><TD class="Line" COLSPAN=6></TD></TR>
    </table>

<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
	<COLGROUP>
	<col width="20%">
	<col width="10%">
	<col width="10%">
	<col width="10%">
	<col width="10%">
	<col width="10%">
	<col width="10%">
	<col width="10%">
	<col width="10%">

	<TR class=Header align=left>
	<td><%=objType%></td>
	<td><%=SystemEnv.getHtmlLabelName(21905,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21906,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21907,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21908,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21909,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21910,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21911,user.getLanguage())%></td>
	<td><%=SystemEnv.getHtmlLabelName(21912,user.getLanguage())%></td>
	</TR>
	<%
		String tdClassStr = "datalight";//datadark
		DecimalFormat dFormat = new DecimalFormat("#0.00");
		ArrayList objIdList = Util.TokenizerString(objidStr, ",");
		for(int i=0; i<objIdList.size(); i++){
			if(i%2 == 0){
				tdClassStr = "datalight";
			}else{
				tdClassStr = "datadark";
			}
			String objid_tmp = (String)objIdList.get(i);
			if("0".equals(objid_tmp)){
				continue;
			}
			int count1 = Util.getIntValue((String)count_hs.get(objid_tmp+"_1"), 0);
			int count2 = Util.getIntValue((String)count_hs.get(objid_tmp+"_2"), 0);
			int count3 = Util.getIntValue((String)count_hs.get(objid_tmp+"_3"), 0);
			int count4 = Util.getIntValue((String)count_hs.get(objid_tmp+"_4"), 0);
			int count5 = Util.getIntValue((String)count_hs.get(objid_tmp+"_5"), 0);
			int count6 = Util.getIntValue((String)count_hs.get(objid_tmp+"_6"), 0);
			float tmp_f;
			String rat1 = "0.00";
			String rat2 = "0.00";
			if(count1 > 0){
				tmp_f = (count3 * 10000) / count1;
				tmp_f = tmp_f / 100;
				rat1 = dFormat.format(tmp_f);
				tmp_f = (count6 * 10000) / count1;
				tmp_f = tmp_f / 100;
				rat2 = dFormat.format(tmp_f);
			}
	%>
	<TR class="<%=tdClassStr%>">
		<td>
		<%
		switch(objType1){
		case 1:
			out.print("<a href='javaScript:openhrm("+objid_tmp+");' onclick='pointerXY(event);'>"+resourceComInfo.getLastname(objid_tmp)+"</a>");
				break;
		case 2:
				out.print("<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+objid_tmp+"' target='_new'>"+departmentComInfo.getDepartmentname(objid_tmp)+"</a>");
				break;
		case 3:
				out.print("<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+objid_tmp+"' target='_new'>"+subCompanyComInfo.getSubCompanyname(objid_tmp)+"</a>");
				break;				
		}%>
		</td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql1+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count1%></a></td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql2+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count2%></a></td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql3+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count3%></a></td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql4+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count4%></a></td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql5+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count5%></a></td>
		<td><a href="DocWfList.jsp?gridTabletype=none&sql=<%=linkSql6+objid_tmp%>&fromsql=workflow_requestbase a, workflow_currentoperator c, hrmresource h" target="_newlist"><%=count6%></a></td>
		<td><%=rat1%>%</td>
		<td><%=rat2%>%</td>
	</TR>
	<!--
	<TR style="height: 1px;"><TD class=Line colspan="9" style="padding: 0px;"></TD></TR>
	 -->
	<%}%>
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
</FORM>
<script>
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
	if (check_form($G("frmMain"),'objId')){
		if($G("datefrom").value != "" || $G("dateto").value != ""){
			onClearQuick();
		}
		$G("frmMain").submit();
	}
}
function submitDataisthisWeek(){
	onClearSwift();
	$G("isthisWeek").value="1";
	$G("spanisthisWeek").style.color = "#0000FF";
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
	$G("isthisWeek").value="0";
	$G("isthisMonth").value="0";
	$G("isthisSeason").value="0";
	$G("isthisYear").value="0";
	$G("spanisthisWeek").style.color = "#6A9EE6";
	$G("spanisthisMonth").style.color = "#6A9EE6";
	$G("spanisthisSeason").style.color = "#6A9EE6";
	$G("spanisthisYear").style.color = "#6A9EE6";
	$G("datefromspan").innerHTML = "";
	$G("datefrom").value = "";
	$G("datetospan").innerHTML = "";
	$G("dateto").value = "";
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
//function onClearSwiftAll(){
	//onClearSwift();
	//document.getElementById("wfNamespan").innerHTML = "";
	//document.getElementById("wfId").value = "";
	//document.getElementById("wfNames").value = "";
//}
function onShowResource(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a href=javaScript:openhrm("+ids[i]+"); onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
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
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
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
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+"<a target='_blank' href=/hrm/company/HrmSubCompanyDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
            }
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			jQuery("#nameimage").html("");
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			jQuery("#nameimage").html("<IMG src='/images/BacoError.gif' align=absMiddle></IMg>");
			
		}
	}
}

function onShowWorkflow(datas,e){
   if(datas&&datas.name!="")
      jQuery("#wfNames").val(datas.name.substr(1));
   else
      jQuery("#wfNames").val("");   
}

</script>
<SCRIPT language=VBS>
sub onShowDepartment1(inputename,showname)
    tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedDepartmentIds="&tmpids)
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
          sHtml = sHtml&"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&resourceids&" target=_new>"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
        else
		  document.all(showname).innerHtml =""
          document.all(inputename).value=""
          document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
         end if
         end if
	if document.all(inputename).value="" then
	<%if("".equals(ownDepid) || "0".equals(ownDepid)){%>
		document.all(showname).innerHtml =""
        document.all(inputename).value=""
        document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
	<%}else{%>
		document.all(showname).innerHtml ="<a href=/hrm/company/HrmDepartmentDsp.jsp?id=<%=ownDepid%>><%=ownDepName%></a>&nbsp"
        document.all(inputename).value="<%=ownDepid%>"
        document.all("nameimage").innerHtml=""
	<%}%>
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
        else
          document.all(inputename).value=""
		  document.all(showname).innerHtml =""
		  document.all("nameimage").innerHtml="<IMG src='/images/BacoError.gif' align=absMiddle></IMg>"
        end if
	end if
end sub
	
	
sub onShowBranch1(inputename,showname)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedDepartmentIds="&tmpids)
   
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
          sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&resourceids&" target=_new>"&resourcename&"</a>&nbsp"
          document.all(showname).innerHtml = sHtml
          document.all("nameimage").innerHtml=""
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

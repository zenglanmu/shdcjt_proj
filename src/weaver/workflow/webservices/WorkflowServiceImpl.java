package weaver.workflow.webservices;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import weaver.conn.RecordSet;
import weaver.cpt.capital.CapitalComInfo;
import weaver.crm.Maint.CustomerInfoComInfo;
import weaver.docs.category.SecCategoryComInfo;
import weaver.docs.docs.DocComInfo;
import weaver.docs.docs.DocImageManager;
import weaver.docs.senddoc.DocReceiveUnitComInfo;
import weaver.general.AttachFileUtil;
import weaver.general.BaseBean;
import weaver.general.StaticObj;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.hrm.company.DepartmentComInfo;
import weaver.hrm.company.SubCompanyComInfo;
import weaver.hrm.report.schedulediff.HrmScheduleDiffUtil;
import weaver.hrm.resource.ResourceComInfo;
import weaver.interfaces.workflow.browser.Browser;
import weaver.interfaces.workflow.browser.BrowserBean;
import weaver.proj.Maint.ProjectInfoComInfo;
import weaver.share.ShareManager;
import weaver.soa.workflow.WorkFlowInit;
import weaver.soa.workflow.bill.BillBgOperation;
import weaver.soa.workflow.bill.BillManager;
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.DetailTableInfo;
import weaver.soa.workflow.request.Log;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.RequestService;
import weaver.soa.workflow.request.Row;
import weaver.workflow.field.BrowserComInfo;
import weaver.workflow.field.FieldComInfo;
import weaver.workflow.mode.FieldInfo;
import weaver.workflow.request.RequestCheckUser;
import weaver.workflow.request.RequestComInfo;
import weaver.workflow.request.RequestLogOperateName;
import weaver.workflow.request.WFCoadjutantManager;
import weaver.workflow.request.WFForwardManager;
import weaver.workflow.request.WFLinkInfo;
import weaver.workflow.request.WorkflowJspBean;
import weaver.workflow.workflow.WFNodeDtlFieldManager;
import weaver.workflow.workflow.WFNodeFieldMainManager;
import weaver.workflow.workflow.WFNodeFieldManager;
import weaver.workflow.workflow.WorkTypeComInfo;
import weaver.workflow.workflow.WorkflowBillComInfo;
import weaver.workflow.workflow.WorkflowComInfo;
import weaver.workflow.workflow.WorkflowRequestComInfo;
import weaver.systeminfo.SystemEnv;

public class WorkflowServiceImpl extends BaseBean implements WorkflowService {

	private RequestService requestService = new RequestService();
	
	/**
	 * 该方法为兼容老版本客户端，新版本请调用
	 * public WorkflowRequestInfo getWorkflowRequest(int requestid, int userid,int fromrequestid, int pagesize)
	 * 此方法推后两个版本后删除
 	 */
	public WorkflowRequestInfo getWorkflowRequest(int requestid, int userid,int fromrequestid) {
		try {
			RequestInfo ri = requestService.getRequest(requestid);
			if (ri != null) {
				return getFromRequestInfo(ri, userid,fromrequestid, 10);
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return null;
	}

	/**
	 * 删除流程
	 * @param requestid
	 * @return
	 */
	public boolean deleteRequest(int requestid,int userid) {
		try {
			return requestService.deleteRequest(requestid);
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
			return false;
		}
	}
	
	public WorkflowRequestInfo getWorkflowRequest4split(int requestid, int userid,int fromrequestid, int pagesize) {
		try {
			RequestInfo ri = requestService.getRequest(requestid, pagesize);
			if (ri != null) {
				return getFromRequestInfo(ri, userid,fromrequestid, pagesize);
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return null;
	}

	public String doCreateWorkflowRequest(WorkflowRequestInfo wri, int userid) {
		try {
			RequestInfo ri = toRequestInfo(wri);
			return requestService.createRequest(ri);
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return null;
	}

	public String forwardWorkflowRequest(int requestid, String recipients, String remark, int userid, String clientip) {
		try {
			if (requestService.forwardFlow(requestid, userid, recipients, remark, clientip))
				return "success";
			else
				return "failed";
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return "error";
	}

	public String submitWorkflowRequest(WorkflowRequestInfo wri, int requestid, int userid, String type, String remark) {
		String result = "error";
		try {
			RequestInfo ri = this.toRequestInfo(wri);
			if (type.equals("submit")) {
				if (requestService.nextNodeBySubmit(ri, requestid, userid, remark))
					result = "success";
				else
					result = "failed";
			} else if (type.equals("subnoback")) {
				if (requestService.nextNodeBySubmit(ri, requestid, userid, remark, "0"))
					result = "success";
				else
					result = "failed";
			} else if (type.equals("subback")) {
				if (requestService.nextNodeBySubmit(ri, requestid, userid, remark, "1"))
					result = "success";
				else
					result = "failed";
			} else if (type.equals("reject")) {
				if (requestService.nextNodeByReject(requestid, userid, remark))
					result = "success";
				else
					result = "failed";
			}
			
			if (!"success".equals(result)) {
				String mobileSuffix = getMobileSuffix(remark);
				if (mobileSuffix != null && !"".equals(mobileSuffix)) {
					remark = remark.substring(0, remark.lastIndexOf(mobileSuffix));
					int usertype = (getUser(userid).getLogintype()).equals("1") ? 0 : 1;
					RecordSet rs = new RecordSet();
					rs.executeSql("update workflow_requestlog set remark='"+remark+"' where requestid='"+requestid+"' and operator='"+userid+"' and operatortype='"+usertype+"' and logtype='1'");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return result;
	}

	public int getHendledWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 ";
		where += "  and t2.iscomplete=0  and  t2.islasttimes=1 ";
		where += " and (t2.isremark = 2 and t2.userid = '"+userid+"' or (t2.isremark in(0,1)  and t2.requestid in(select requestid from workflow_zf t9 where  zfrid = '"+userid+"'))) ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getHendledWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 ";
		where += "  and t2.iscomplete=0 and t2.islasttimes=1 ";
		where += " and (t2.isremark = 2 and t2.userid = '"+userid+"' or (t2.isremark in(0,1)  and t2.requestid in(select requestid from workflow_zf t9 where  zfrid = '"+userid+"'))) ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}

	public int getMyWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t1.creater = " + userid + " and t1.creatertype = 0 and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getMyWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t1.creater = " + userid + " and t1.creatertype = 0 and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}

	public int getProcessedWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getProcessedWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}

	public int getToDoWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in( '0','1','5','7') and t2.islasttimes=1 ";
		//--加入孙小俊开发的过滤条件
		where += " AND not EXISTS (select 1 from workflow_zf t9 where t1.requestid=t9.requestid and zfrid="+userid+") ";
		//-end-加入孙小俊开发的过滤条件
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getToDoWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in( '0','1','5','7') and t2.islasttimes=1 ";
		//--加入孙小俊开发的过滤条件
		where += " AND not EXISTS (select 1 from workflow_zf t9 where t1.requestid=t9.requestid and zfrid="+userid+") ";
		//-end-加入孙小俊开发的过滤条件
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}

	public int getCCWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in( '8','9' ) and t2.islasttimes=1 ";
		
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getCCWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and t2.isremark in( '8','9' ) and t2.islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}
	
	public int getAllWorkflowRequestCount(int userid, String[] conditions) {
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t3.id=t2.workflowid and t3.isvalid=1 ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and islasttimes=1 and islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}

		String sql = getPaginationCountSql(select, fields, from, where);

		return getWorkflowRequestCount(sql);
	}

	public WorkflowRequestInfo[] getAllWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		String select = " select distinct ";
		String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
		String from = " from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3 ";
		String where = " where t1.requestid=t2.requestid ";
		where += " and t3.id=t2.workflowid and t3.isvalid=1 ";
		where += " and t2.usertype = 0 and t2.userid = " + userid;
		where += " and islasttimes=1 and islasttimes=1 ";
		if (conditions != null)
			for (int m=0;m<conditions.length;m++) {
				String condition = conditions[m];
				where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
			}
		String orderby = " order by t2.receivedate desc,t2.receivetime desc,t1.requestid desc ";
		String orderby1 = " order by receivedate asc,receivetime asc,requestid asc ";
		String orderby2 = " order by receivedate desc,receivetime desc,requestid desc ";

		String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

		return getWorkflowRequestList(sql);
	}

	/**
	 * 取得分页统计记录数的SQL
	 * @param select sql中select
	 * @param fields sql中fields
	 * @param from sql中from
	 * @param where sql中where
	 * @return String sql分页统计记录数语句
	 */
	private String getPaginationCountSql(String select, String fields, String from, String where) {
		String sql = " select count(*) my_count from ( " + select + " " + fields + " " + from + " " + where + " ) tableA ";
		return sql;
	}

	/**
	 * 取得分页的SQL
	 * @param select sql中select
	 * @param fields sql中fields
	 * @param from sql中from
	 * @param where sql中where
	 * @param orderby sql中orderby
	 * @param orderby1 sql中orderby1
	 * @param orderby2 sql中orderby2
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @return String 分页SQL
	 */
	private String getPaginationSql(String select, String fields, String from, String where, String orderby, String orderby1, String orderby2, int pageNo, int pageSize, int recordCount) {
		String sql = "";
		RecordSet rs = new RecordSet();
		int firstResult = 0;
		int endResult = 0;
		if (rs.getDBType().equals("oracle")) {
			firstResult = pageNo * pageSize + 1;
			endResult = (pageNo - 1) * pageSize;
			sql = " select * from ( select my_table.*,rownum as my_rownum from ( select tableA.*,rownum as r from ( " + select + " " + fields + " " + from + " " + where + " " + orderby + " ) tableA  ) my_table where rownum < " + firstResult + " ) where my_rownum > " + endResult;
		} else {
			firstResult = pageSize * pageNo;
			endResult = pageSize;
			if (firstResult > recordCount) {
				firstResult = recordCount;
				endResult = recordCount - (pageSize * (pageNo - 1));
			}
			if (pageNo == 1)
				sql = select + " top " + endResult + " " + fields + " " + from + " " + where + " " + orderby;
			else
				sql = " select top " + endResult + " * from ( select top " + endResult + " * from ( " + select + " top " + firstResult + " " + fields + " " + from + " " + where + " " + orderby + " " + ") tbltemp1 " + orderby1 + " ) tbltemp2 " + orderby2;
		}
		return sql;
	}

	/**
	 * 取得sql中的记录数
	 * @param sql sql语句
	 * @return int 记录数
	 */
	private int getWorkflowRequestCount(String sql) {
		RecordSet rs = new RecordSet();
		int count = 0;
		try {
			rs.executeSql(sql);
			if (rs.next()) {
				count = rs.getInt("my_count");
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return count;
	}

	/**
	 * 取得sql中的流程记录
	 * @param sql sql语句
	 * @return WorkflowRequestInfo[] 流程记录
	 */
	private WorkflowRequestInfo[] getWorkflowRequestList(String sql) {
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();

		List wris = new ArrayList();
		try {
			WorkflowComInfo workflowComInfo = new WorkflowComInfo();
			WorkTypeComInfo workflowTypeComInfo = new WorkTypeComInfo();
			ResourceComInfo resourceComInfo = new ResourceComInfo();

			rs.executeSql(sql);
			while (rs.next()) {
				WorkflowRequestInfo wri = new WorkflowRequestInfo();

				wri.setRequestId(rs.getString("requestid"));
				wri.setRequestName(rs.getString("requestname"));
				wri.setRequestLevel(rs.getString("requestlevel"));

				WorkflowBaseInfo wbi = new WorkflowBaseInfo();

				wbi.setWorkflowId(rs.getString("workflowid"));
				wbi.setWorkflowName(workflowComInfo.getWorkflowname(rs.getString("workflowid")));
				wbi.setWorkflowTypeId(workflowComInfo.getWorkflowtype(rs.getString("workflowid")));
				wbi.setWorkflowTypeName(workflowTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(rs.getString("workflowid"))));

				wri.setWorkflowBaseInfo(wbi);

				String currentnodeid = "";
				String currentnodename = "";
				currentnodeid = rs.getString("currentnodeid");

				rs1.executeSql("select * from workflow_nodebase where id = " + currentnodeid);
				if (rs1.next())
					currentnodename = rs1.getString("nodename");
				wri.setCurrentNodeName(currentnodename);
				wri.setCurrentNodeId(currentnodeid);
				
				String requestid = "";
				String status = "";
				requestid = wri.getRequestId();
				rs1.executeSql("select * from workflow_requestbase where requestid = " + requestid);
				if (rs1.next())
					status = rs1.getString("status");
				wri.setStatus(status);

				wri.setCreatorId(rs.getString("creater"));
				wri.setCreatorName(resourceComInfo.getLastname(rs.getString("creater")));
				wri.setCreateTime(rs.getString("createdate") + " " + rs.getString("createtime"));
				wri.setLastOperatorName(resourceComInfo.getLastname(rs.getString("lastoperator")));
				wri.setLastOperateTime(rs.getString("lastoperatedate") + " " + rs.getString("lastoperatetime"));
				wri.setReceiveTime(rs.getString("receivedate") + " " + rs.getString("receivetime"));

				wris.add(wri);
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		WorkflowRequestInfo[] wriarrays = new WorkflowRequestInfo[wris.size()];
		for (int i = 0; i < wris.size(); i++)
			wriarrays[i] = (WorkflowRequestInfo) wris.get(i);
		return wriarrays;
	}

	public WorkflowBaseInfo[] getCreateWorkflowList(int pageNo, int pageSize, int recordCount, int userid, int workflowType, String[] conditions) {
		/*
		if (pageNo < 1)
			pageNo = 1;
		List wbis = new ArrayList();
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();

			String select = " select distinct ";
			String fields = " t1.workflowid,t2.workflowname,t2.workflowtype,t3.typename ";
			String from = " from workflow_createrlist t1,workflow_base t2,workflow_type t3 ";
			String where = " where t1.workflowid=t2.id and t2.workflowtype = t3.id and t2.isvalid='1' ";
			if (workflowType > 0)
				where += " and t2.workflowtype = " + workflowType + " ";
			where += " and ( ( t1.usertype = 0 and t1.userid =" + userid + ") or (t1.userid = -1 and t1.usertype <= " + resourceComInfo.getSeclevel(userid + "") + " and t1.usertype2 >= " + resourceComInfo.getSeclevel(userid + "") + ") ) ";
			if (conditions != null)
				for (int m=0;m<conditions.length;m++) {
					String condition = conditions[m];
					where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
				}
			String orderby = " order by t3.typename desc,t2.workflowname desc ";
			String orderby1 = " order by typename asc,workflowname asc ";
			String orderby2 = " order by typename desc,workflowname desc ";

			String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

			RecordSet rs = new RecordSet();

			rs.executeSql(sql);
			while (rs.next()) {
				WorkflowBaseInfo wbi = new WorkflowBaseInfo();

				wbi.setWorkflowId(rs.getString("workflowid"));
				wbi.setWorkflowName(rs.getString("workflowname"));
				wbi.setWorkflowTypeId(rs.getString("workflowtype"));
				wbi.setWorkflowTypeName(rs.getString("typename"));

				wbis.add(wbi);
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		WorkflowBaseInfo[] wbiarrays = new WorkflowBaseInfo[wbis.size()];
		for (int i = 0; i < wbis.size(); i++)
			wbiarrays[i] = (WorkflowBaseInfo) wbis.get(i);
		return wbiarrays;
		*/
		
		List wbis = new ArrayList();
		try {
			WorkTypeComInfo workTypeComInfo = new WorkTypeComInfo();
			WorkflowComInfo workflowComInfo = new WorkflowComInfo();
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			
			RecordSet recordSet = new RecordSet();
			RecordSet rs = new RecordSet();
			
			if (pageNo < 1) {
				pageNo = 1;
			}
			if (pageSize < 1) {
				pageSize = 1;
			}
			
			String workflowName = conditions.length > 0 ? Util.null2String(conditions[0]) : "";
			String formids = conditions.length>1 && !"".equals(Util.null2String(conditions[1])) ? Util.null2String(conditions[1]) : "0";
			
			List alloworkflow = new ArrayList();
			recordSet.executeSql("select id from workflow_base where isvalid='1' and  ( isbill=0 or (isbill=1 and formid<0) or (isbill=1 and formid in ("+formids+")))");
			while(recordSet.next()){
				alloworkflow.add(recordSet.getString("id"));
			}
			
			User user = this.getUser(userid);
			
			String logintype = user.getLogintype();
			int usertype = 0;
			if(logintype.equals("2")){
				usertype = 1;
			}

			String seclevel = user.getSeclevel();

			String selectedworkflow="";
			String isuserdefault="";

			recordSet.executeProc("workflow_RUserDefault_Select",""+userid);
			if(recordSet.next()){
				selectedworkflow=recordSet.getString("selectedworkflow");
				isuserdefault=recordSet.getString("isuserdefault");
			}
			
			//是否显示自定义工作流,目前默认显示全部
			isuserdefault = "0";
			
			if(!selectedworkflow.equals("")) {
				selectedworkflow+="|";
			}

			ArrayList NewWorkflowTypes = new ArrayList();
			ShareManager shareManager = new ShareManager();
			String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
			String sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and " + wfcrtSqlWhere;
			recordSet.executeSql(sql);
			while(recordSet.next()){
				NewWorkflowTypes.add(recordSet.getString("workflowtype"));
			}
			/*
			if(usertype ==0){
				sql = "select distinct workflowtype from workflow_createrlist t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.userid = -1 and t1.usertype <= "+seclevel + " and t1.usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflowTypes.add(recordSet.getString("workflowtype"));
				}
			} else if(usertype ==1){
				sql = "select distinct workflowtype from workflow_createrlist t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.userid = -2 and t1.usertype <= "+seclevel + " and t1.usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflowTypes.add(recordSet.getString("workflowtype"));
				}
			}
			*/
			//modify by xhheng @20050110 for 流程代理
			ArrayList NewWorkflows = new ArrayList();

			sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
			recordSet.executeSql(sql);
			while(recordSet.next()){
				NewWorkflows.add(recordSet.getString("workflowid"));
			}
			/*
			if(usertype ==0){
				char flag=Util.getSeparator() ;
				recordSet.executeProc("Workflow_createlist_select","" + userid + flag + usertype);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
				sql = "select * from workflow_createrlist where userid = -1 and usertype <= "+seclevel + " and usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
			} else if(usertype ==1){
				sql = "select * from workflow_createrlist where userid =" + userid +" and usertype = " + usertype;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
				sql = "select * from workflow_createrlist where userid = -2 and usertype <= "+seclevel + " and usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
			}
			*/
			/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
			ArrayList AgentWorkflows = new ArrayList();
			ArrayList Agenterids = new ArrayList();
			/* 暂时不开放流程代理创建权限
			if (usertype == 0) {
				//获得当前的日期和时间
				Calendar today = Calendar.getInstance();
				String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

				String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			                     Util.add0(today.get(Calendar.SECOND), 2) ;
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int agentworkflowtype=0;
				int agentworkflow=0;
				int beagenterid=0;
				sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" order by t1.workflowtype,t.workflowid";
				recordSet.executeSql(sql);
				while(recordSet.next()){
					begindate=Util.null2String(recordSet.getString("begindate"));
					begintime=Util.null2String(recordSet.getString("begintime"));
					enddate=Util.null2String(recordSet.getString("enddate"));
					endtime=Util.null2String(recordSet.getString("endtime"));
					agentworkflowtype=Util.getIntValue(recordSet.getString("workflowtype"),0);
					agentworkflow=Util.getIntValue(recordSet.getString("workflowid"),0);
					beagenterid=Util.getIntValue(recordSet.getString("beagenterid"),0);
					if(!begindate.equals("")){
						if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
							continue;
					}
					if(!enddate.equals("")){
						if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
							continue;
					}
					String sqltemp = "select * from workflow_createrlist a,hrmresource b where b.id="+beagenterid+" and ((userid = -1 and usertype <= b.seclevel and usertype2 >= b.seclevel) or (userid="+beagenterid+" and usertype=0)) and workflowid="+agentworkflow;
					rs.executeSql(sqltemp);
					if(rs.next()){
						if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
							NewWorkflowTypes.add(agentworkflowtype+"");
						}
						int indx=AgentWorkflows.indexOf(""+agentworkflow);
						if(indx==-1){
							AgentWorkflows.add(""+agentworkflow);
							Agenterids.add(""+beagenterid);
						}else{
							String tempagenter=(String)Agenterids.get(indx);
							tempagenter+=","+beagenterid;
							Agenterids.set(indx,tempagenter);
						}
					}
				}
				//end
			}
			*/

			String dataCenterWorkflowTypeId="";
			recordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
			if(recordSet.next()){
				dataCenterWorkflowTypeId=Util.null2String(recordSet.getString("currentId"));
			}

			int total = 0;
			int startindex = (pageNo-1)*pageSize+1;
			int endindex = pageNo*pageSize;
			while(workTypeComInfo.next()){
				String wftypename=workTypeComInfo.getWorkTypename();
				String wftypeid = workTypeComInfo.getWorkTypeid();

				if(NewWorkflowTypes.indexOf(wftypeid)==-1){
		 			continue;            
				}
			 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
					continue;
				}
			 	if(dataCenterWorkflowTypeId.equals(wftypeid)) {
					continue;
				}
			 	
			 	if(workflowType > 0 && workflowType != Util.getIntValue(wftypeid, 0)) {
			 		continue;
			 	}
				
				while(workflowComInfo.next()){
					String wfname=workflowComInfo.getWorkflowname();
					String wfid = workflowComInfo.getWorkflowid();
					String curtypeid = workflowComInfo.getWorkflowtype();
					String agentname="";
					ArrayList agenterlist=new ArrayList();
					
					if(alloworkflow.indexOf(wfid) == -1) continue;
					
					if(!curtypeid.equals(wftypeid)) continue;
					
					if(!"".equals(workflowName) && wfname.indexOf(workflowName) == -1) continue;

					//check right
					if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					
					if(NewWorkflows.indexOf(wfid)==-1){
						if(AgentWorkflows.indexOf(wfid)==-1){
							continue;
						}else{
							agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
							for(int k=0;k<agenterlist.size();k++){
								total++;
								if (total < startindex || total > endindex) continue;
								agentname="("+resourceComInfo.getResourcename((String)agenterlist.get(k))+"->"+user.getUsername()+")";
								WorkflowBaseInfo wbi = new WorkflowBaseInfo();
								wbi.setWorkflowId(wfid);
								wbi.setWorkflowName(Util.toScreen(wfname,user.getLanguage()) + agentname);
								wbi.setWorkflowTypeId(wftypeid);
								wbi.setWorkflowTypeName(wftypename);
								wbis.add(wbi);
							}
						}
					}else{
						total++;
						if (total < startindex || total > endindex) continue;
						WorkflowBaseInfo wbi = new WorkflowBaseInfo();
						wbi.setWorkflowId(wfid);
						wbi.setWorkflowName(Util.toScreen(wfname,user.getLanguage()));
						wbi.setWorkflowTypeId(wftypeid);
						wbi.setWorkflowTypeName(wftypename);
						wbis.add(wbi);
					}
				}
				workflowComInfo.setTofirstRow();
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		
		WorkflowBaseInfo[] wbiarrays = new WorkflowBaseInfo[wbis.size()];
		wbis.toArray(wbiarrays);
		return wbiarrays;
	}

	public int getCreateWorkflowCount(int userid, int workflowType, String[] conditions) {
		/*
		int count = 0;
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();

			String select = " select distinct ";
			String fields = " t1.workflowid,t2.workflowname,t2.workflowtype,t3.typename ";
			String from = " from workflow_createrlist t1,workflow_base t2,workflow_type t3 ";
			String where = " where t1.workflowid=t2.id and t2.workflowtype=t3.id and t2.isvalid='1' ";
			if (workflowType > 0)
				where += " and t2.workflowtype = " + workflowType + " ";
			where += " and ( ( t1.usertype = 0 and t1.userid =" + userid + ") or (t1.userid = -1 and t1.usertype <= " + resourceComInfo.getSeclevel(userid + "") + " and t1.usertype2 >= " + resourceComInfo.getSeclevel(userid + "") + ") ) ";
			if (conditions != null)
				for (int m=0;m<conditions.length;m++) {
					String condition = conditions[m];
					where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
				}

			String sql = getPaginationCountSql(select, fields, from, where);

			RecordSet rs = new RecordSet();

			rs.executeSql(sql);
			if (rs.next()) {
				count = rs.getInt("my_count");
			}

		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return count;
		*/
		
		int total = 0;
		try {
			WorkTypeComInfo workTypeComInfo = new WorkTypeComInfo();
			WorkflowComInfo workflowComInfo = new WorkflowComInfo();
			
			RecordSet recordSet = new RecordSet();
			RecordSet rs = new RecordSet();
			
			String workflowName = conditions.length > 0 ? Util.null2String(conditions[0]) : "";
			
			User user = this.getUser(userid);
			
			String logintype = user.getLogintype();
			int usertype = 0;
			if(logintype.equals("2")){
				usertype = 1;
			}

			String seclevel = user.getSeclevel();

			String selectedworkflow="";
			String isuserdefault="";

			recordSet.executeProc("workflow_RUserDefault_Select",""+userid);
			if(recordSet.next()){
				selectedworkflow=recordSet.getString("selectedworkflow");
				isuserdefault=recordSet.getString("isuserdefault");
			}
			
			if(!selectedworkflow.equals("")) {
				selectedworkflow+="|";
			}

			ArrayList NewWorkflowTypes = new ArrayList();
			ShareManager shareManager = new ShareManager();
			String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");
			String sql = "select distinct workflowtype from ShareInnerWfCreate t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and " + wfcrtSqlWhere;
			recordSet.executeSql(sql);
			while(recordSet.next()){
				NewWorkflowTypes.add(recordSet.getString("workflowtype"));
			}
			/*
			if(usertype ==0){
				sql = "select distinct workflowtype from workflow_createrlist t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.userid = -1 and t1.usertype <= "+seclevel + " and t1.usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflowTypes.add(recordSet.getString("workflowtype"));
				}
			} else if(usertype ==1){
				sql = "select distinct workflowtype from workflow_createrlist t1,workflow_base t2 where t1.workflowid=t2.id and t2.isvalid='1' and t1.userid = -2 and t1.usertype <= "+seclevel + " and t1.usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflowTypes.add(recordSet.getString("workflowtype"));
				}
			}
*/
			//modify by xhheng @20050110 for 流程代理
			ArrayList NewWorkflows = new ArrayList();
			sql = "select * from ShareInnerWfCreate t1 where " +  wfcrtSqlWhere;
			recordSet.executeSql(sql);
			while(recordSet.next()){
				NewWorkflows.add(recordSet.getString("workflowid"));
			}
			/*
			if(usertype ==0){
				char flag=Util.getSeparator() ;
				recordSet.executeProc("Workflow_createlist_select","" + userid + flag + usertype);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
				sql = "select * from workflow_createrlist where userid = -1 and usertype <= "+seclevel + " and usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
			} else if(usertype ==1){
				sql = "select * from workflow_createrlist where userid =" + userid +" and usertype = " + usertype;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
				sql = "select * from workflow_createrlist where userid = -2 and usertype <= "+seclevel + " and usertype2 >= "+seclevel ;
				recordSet.executeSql(sql);
				while(recordSet.next()){
					NewWorkflows.add(recordSet.getString("workflowid"));
				}
			}
			*/
			/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
			ArrayList AgentWorkflows = new ArrayList();
			ArrayList Agenterids = new ArrayList();
			//TD13554
			/*
			if (usertype == 0) {
				//获得当前的日期和时间
				Calendar today = Calendar.getInstance();
				String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

				String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			                     Util.add0(today.get(Calendar.SECOND), 2) ;
				String begindate="";
				String begintime="";
				String enddate="";
				String endtime="";
				int agentworkflowtype=0;
				int agentworkflow=0;
				int beagenterid=0;
				sql = "select distinct t1.workflowtype,t.workflowid,t.beagenterid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agent t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agenterid="+userid+" order by t1.workflowtype,t.workflowid";
				recordSet.executeSql(sql);
				while(recordSet.next()){
					begindate=Util.null2String(recordSet.getString("begindate"));
					begintime=Util.null2String(recordSet.getString("begintime"));
					enddate=Util.null2String(recordSet.getString("enddate"));
					endtime=Util.null2String(recordSet.getString("endtime"));
					agentworkflowtype=Util.getIntValue(recordSet.getString("workflowtype"),0);
					agentworkflow=Util.getIntValue(recordSet.getString("workflowid"),0);
					beagenterid=Util.getIntValue(recordSet.getString("beagenterid"),0);
					if(!begindate.equals("")){
						if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
							continue;
					}
					if(!enddate.equals("")){
						if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
							continue;
					}
					String sqltemp = "select * from workflow_createrlist a,hrmresource b where b.id="+beagenterid+" and ((userid = -1 and usertype <= b.seclevel and usertype2 >= b.seclevel) or (userid="+beagenterid+" and usertype=0)) and workflowid="+agentworkflow;
					rs.executeSql(sqltemp);
					if(rs.next()){
						if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
							NewWorkflowTypes.add(agentworkflowtype+"");
						}
						int indx=AgentWorkflows.indexOf(""+agentworkflow);
						if(indx==-1){
							AgentWorkflows.add(""+agentworkflow);
							Agenterids.add(""+beagenterid);
						}else{
							String tempagenter=(String)Agenterids.get(indx);
							tempagenter+=","+beagenterid;
							Agenterids.set(indx,tempagenter);
						}
					}
				}
				//end
			}
			*/
			String dataCenterWorkflowTypeId="";
			recordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
			if(recordSet.next()){
				dataCenterWorkflowTypeId=Util.null2String(recordSet.getString("currentId"));
			}
			
			while(workTypeComInfo.next()){
				String wftypename=workTypeComInfo.getWorkTypename();
				String wftypeid = workTypeComInfo.getWorkTypeid();

				if(NewWorkflowTypes.indexOf(wftypeid)==-1){
		 			continue;            
				}
			 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")){
					continue;
				}
			 	if(dataCenterWorkflowTypeId.equals(wftypeid)) {
					continue;
				}
			 	
			 	if(workflowType > 0 && workflowType != Util.getIntValue(wftypeid, 0)) {
			 		continue;
			 	}
				
				while(workflowComInfo.next()){
					String wfname=workflowComInfo.getWorkflowname();
					String wfid = workflowComInfo.getWorkflowid();
					String curtypeid = workflowComInfo.getWorkflowtype();
					String agentname="";
					ArrayList agenterlist=new ArrayList();
					
					if(!curtypeid.equals(wftypeid)) continue;
					
					if(!"".equals(workflowName) && wfname.indexOf(workflowName) == -1) continue;

					//check right
					if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
					
					if(NewWorkflows.indexOf(wfid)==-1){
						if(AgentWorkflows.indexOf(wfid)==-1){
							continue;
						}else{
							agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
							for(int k=0;k<agenterlist.size();k++){
								total++;
							}
						}
					}else{
						total++;
					}
				}
				workflowComInfo.setTofirstRow();
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		
		return total;
	}

	public WorkflowBaseInfo[] getCreateWorkflowTypeList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions) {
		if (pageNo < 1)
			pageNo = 1;
		List wbis = new ArrayList();
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			ShareManager shareManager = new ShareManager();
			//获取流程新建权限体系sql条件
			String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(this.getUser(userid), "t1");
			
			String select = " select distinct ";
			String fields = " t2.workflowtype,t3.typename ";
			String from = " from ShareInnerWfCreate t1,workflow_base t2,workflow_type t3 ";
			String where = " where t1.workflowid=t2.id and t2.workflowtype = t3.id and t2.isvalid='1' and ( ";
			where += wfcrtSqlWhere;
			where += " ) ";
			if (conditions != null)
				for (int m=0;m<conditions.length;m++) {
					String condition = conditions[m];
					where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
				}
			String orderby = " order by t3.typename desc,t2.workflowtype desc ";
			String orderby1 = " order by typename asc,workflowtype asc ";
			String orderby2 = " order by typename desc,workflowtype desc ";

			String sql = getPaginationSql(select, fields, from, where, orderby, orderby1, orderby2, pageNo, pageSize, recordCount);

			RecordSet rs = new RecordSet();

			rs.executeSql(sql);
			while (rs.next()) {
				WorkflowBaseInfo wbi = new WorkflowBaseInfo();

				wbi.setWorkflowId("");
				wbi.setWorkflowName("");
				wbi.setWorkflowTypeId(rs.getString("workflowtype"));
				wbi.setWorkflowTypeName(rs.getString("typename"));

				wbis.add(wbi);
			}
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		WorkflowBaseInfo[] wbiarrays = new WorkflowBaseInfo[wbis.size()];
		for (int i = 0; i < wbis.size(); i++)
			wbiarrays[i] = (WorkflowBaseInfo) wbis.get(i);
		return wbiarrays;
	}

	public int getCreateWorkflowTypeCount(int userid, String[] conditions) {
		int count = 0;
		try {
			ResourceComInfo resourceComInfo = new ResourceComInfo();

			ShareManager shareManager = new ShareManager();
			//获取流程新建权限体系sql条件ShareInnerWfCreate
			String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(this.getUser(userid), "t1");
			
			String select = " select distinct ";
			String fields = " t2.workflowtype,t3.typename ";
			String from = " from ShareInnerWfCreate t1,workflow_base t2,workflow_type t3 ";
			String where = " where t1.workflowid=t2.id and t2.workflowtype = t3.id and t2.isvalid='1' and ( ";
			where += wfcrtSqlWhere;
			where += " ) ";
			if (conditions != null)
				for (int m=0;m<conditions.length;m++) {
					String condition = conditions[m];
					where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
				}

			String sql = getPaginationCountSql(select, fields, from, where);

			RecordSet rs = new RecordSet();

			rs.executeSql(sql);
			if (rs.next()) {
				count = rs.getInt("my_count");
			}

		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return count;
	}

	public WorkflowRequestInfo getCreateWorkflowRequestInfo(int workflowid, int userid) {
		WorkflowRequestInfo wri = new WorkflowRequestInfo();
		try {
			RecordSet rs = new RecordSet();
			char flag = Util.getSeparator() ;
			WorkFlowInit wfi = new WorkFlowInit();
			User user = getUser(userid);

			//检查用户是否有创建权限
			RequestCheckUser requestCheckUser = new RequestCheckUser();

			requestCheckUser.setUserid(userid);
			requestCheckUser.setWorkflowid(workflowid);
			requestCheckUser.setLogintype(user.getLogintype());
			requestCheckUser.checkUser();
			int hasright=requestCheckUser.getHasright();
			if(hasright==0){
				return null;
			}

			WorkflowComInfo workflowComInfo = new WorkflowComInfo();
			WorkTypeComInfo workflowTypeComInfo = new WorkTypeComInfo();
			
			ResourceComInfo resourceComInfo = new ResourceComInfo();
			
			WorkflowBaseInfo wbi = new WorkflowBaseInfo();
			
			//获得当前的日期和时间
			Calendar today = Calendar.getInstance();
			String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

			String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			                     Util.add0(today.get(Calendar.SECOND), 2) ;

			wbi.setWorkflowId(workflowid+"");
			wbi.setWorkflowName(workflowComInfo.getWorkflowname(workflowid+""));
			wbi.setWorkflowTypeId(workflowComInfo.getWorkflowtype(workflowid+""));
			wbi.setWorkflowTypeName(workflowTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(workflowid+"")));

			wri.setWorkflowBaseInfo(wbi);
			
		    String needAffirmance = "";//是否需要确认
		    String defaultName = ""; //是否默认说明
		    rs.executeSql("select needAffirmance,defaultName from workflow_base where id="+workflowid);
		    if (rs.next()) {
		    	needAffirmance = rs.getString("needAffirmance");
		    	defaultName = rs.getString("defaultName");
		    }
		    if ("1".equals(needAffirmance)) {
		    	wri.setNeedAffirmance(true);
		    } else {
		    	wri.setNeedAffirmance(false);
		    }

		    String defaultRequestName = "";
		    if ("1".equals(defaultName)) {
				defaultRequestName = wbi.getWorkflowName()+"-"+user.getLastname()+"-"+currentdate;
		    }

			wri.setRequestId("0");
			wri.setRequestName(defaultRequestName);
			wri.setRequestLevel("0");
			wri.setMessageType("0");

			String creatorid = userid+"";
			
			weaver.workflow.request.WFLinkInfo wfLinkInfo = new weaver.workflow.request.WFLinkInfo();
			
			int nodeid = -1;
			rs.executeProc("workflow_CreateNode_Select",workflowid+"");
			if(rs.next()) nodeid = Util.getIntValue(Util.null2String(rs.getString(1)));
			String nodetype=wfLinkInfo.getNodeType(nodeid);
			String nodename="";
			
			wri.setCreatorId(creatorid);
			wri.setCreatorName(resourceComInfo.getLastname(user.getUID()+""));
			wri.setCreateTime(currentdate + " " + currenttime);
			wri.setLastOperatorName(resourceComInfo.getLastname(user.getUID()+""));
			wri.setLastOperateTime(currentdate + " " + currenttime);
			
			boolean canView = true ;// 是否可以查看
			boolean canEdit = true;// 是否可以编辑
			
			wri.setCanView(canView);
			wri.setCanEdit(canEdit);
			Map map=getRightMenu(wri.getWorkflowBaseInfo().getWorkflowId(), nodeid, wri.getRequestId(), 0, user, nodetype, false);
			/*
			String submitButtonName = "";
			String rejectButtonName = "";
			String forwardButtonName = "";
			//创建节点 //提交
			submitButtonName = (String)map.get("submitName");//提交
			*/
			wri.setSubmitButtonName((String)map.get("submitName"));
			wri.setSubnobackButtonName((String)map.get("subnobackName"));
			wri.setSubbackButtonName((String)map.get("subbackName"));
			wri.setRejectButtonName((String)map.get("rejectName"));
			wri.setForwardButtonName((String)map.get("forwardName"));
			
			rs.executeSql("select * from workflow_nodebase where id = " + nodeid);
			if (rs.next())
				nodename = rs.getString("nodename");
			wri.setCurrentNodeName(nodename);
			wri.setCurrentNodeId(nodeid+"");
			
			WorkflowMainTableInfo wmti = getWorkflowMainTableInfo(workflowid+"", "0", user, wri);
			
			wri.setWorkflowMainTableInfo(wmti);

			WorkflowDetailTableInfo[] wdtis = getWorkflowDetailTableInfos(wri, user);
			wri.setWorkflowDetailTableInfos(wdtis);

			wri.setWorkflowRequestLogs(new WorkflowRequestLog[]{});
			
			wri = getWorkflowRequestInfoHTMLTemplete(wri, user);
			
			wri.setMustInputRemark(requestService.whetherMustInputRemark(Util.getIntValue(wri.getRequestId(), 0), workflowid, nodeid, userid, 1));
			//流程短语
			wri.setWorkflowPhrases(getWorkflowPhrases(user));
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return wri;

	}

	/**
	 * 将WorkflowRequestInfo转换为RequestInfo
	 * 
	 * @param WorkflowRequestInfo
	 * @return RequestInfo
	 */
	private RequestInfo toRequestInfo(WorkflowRequestInfo wri) throws Exception {
		if(wri==null) return null;
		
		int formid = 0;
		String isbill = "0";
		RecordSet rs = new RecordSet();
		int workflowid = Util.getIntValue(wri.getWorkflowBaseInfo().getWorkflowId(), 0);
		//单据(系统表单)特殊逻辑
		rs.executeProc("workflow_Workflowbase_SByID", workflowid + "");
		if (rs.next()) {
			formid = Util.getIntValue(rs.getString("formid"), 0);
			isbill = "" + Util.getIntValue(rs.getString("isbill"), 0);
		}
		
		if("1".equals(isbill) && formid == 158) {//报销申请单
			String amount = "0";
			WorkflowDetailTableInfo[] wdtis = wri.getWorkflowDetailTableInfos();
			if(wdtis != null) {
				for(int i=0; i<wdtis.length; i++) {
					WorkflowRequestTableRecord[] wrtrs = wdtis[i].getWorkflowRequestTableRecords();
					if(wrtrs != null) {
						for(int j=0; j<wrtrs.length; j++) {
							if(wrtrs[j]!=null && wrtrs[j].getRecordOrder()==-1) {
								WorkflowRequestTableField[] wrtfs = wrtrs[j].getWorkflowRequestTableFields();
								if(wrtfs != null) {
									for(int k=0; k<wrtfs.length; k++) {
										if(wrtfs[k]!=null && "amount".equals(wrtfs[k].getFieldName())){
											amount = wrtfs[k].getFieldValue();
										}
									}
								}
							}
						}
					}
				}
			}
			
			WorkflowMainTableInfo wmti = wri.getWorkflowMainTableInfo();
			if(wmti!=null) {
				WorkflowRequestTableRecord[] wrtrs = wmti.getRequestRecords();
				if(wrtrs!=null&&wrtrs[0]!=null) {
					for(int i=0;i<wrtrs[0].getWorkflowRequestTableFields().length;i++) {
						WorkflowRequestTableField wrtf = wrtrs[0].getWorkflowRequestTableFields()[i];
						if(wrtf!=null && "total".equals(wrtf.getFieldName())){
							wrtf.setFieldValue(amount);
						}
					}
				}
			}
		}
		
		RequestInfo requestInfo = new RequestInfo();
		
		if(Util.getIntValue(wri.getRequestId())>0) requestInfo = requestService.getRequest(Util.getIntValue(wri.getRequestId()));
		
		requestInfo.setRequestid(wri.getRequestId());
		requestInfo.setWorkflowid(wri.getWorkflowBaseInfo().getWorkflowId());
		requestInfo.setCreatorid(wri.getCreatorId());
		requestInfo.setDescription(wri.getRequestName());
		requestInfo.setRequestlevel(wri.getRequestLevel());
		requestInfo.setRemindtype(wri.getMessageType());
		
		MainTableInfo mainTableInfo = new MainTableInfo();
		List fields = new ArrayList();
		
		WorkflowMainTableInfo wmti = wri.getWorkflowMainTableInfo();
		if(wmti!=null) {
			WorkflowRequestTableRecord[] wrtrs = wmti.getRequestRecords();
			if(wrtrs!=null&&wrtrs[0]!=null) {
				for(int i=0;i<wrtrs[0].getWorkflowRequestTableFields().length;i++) {
					WorkflowRequestTableField wrtf = wrtrs[0].getWorkflowRequestTableFields()[i];
					if(wrtf!=null){
						if(wrtf.getFieldName()!=null&&!"".equals(wrtf.getFieldName())
								&&wrtf.getFieldValue()!=null&&!"".equals(wrtf.getFieldValue())
								&&wrtf.isView()&&wrtf.isEdit()){
							Property field = new Property();
							field.setName(wrtf.getFieldName());
							field.setValue(wrtf.getFieldValue());
							field.setType(wrtf.getFieldType());
							fields.add(field);
						}
					}
				}
			}
		}
		Property[] fieldarray = (Property[]) fields.toArray(new Property[fields.size()]);
		mainTableInfo.setProperty(fieldarray);
		requestInfo.setMainTableInfo(mainTableInfo);
		
		DetailTableInfo detailTableInfo = new DetailTableInfo();
		WorkflowDetailTableInfo[] wdtis = wri.getWorkflowDetailTableInfos();
		
		//手机版暂不支持明细字段编辑功能
		//wdtis = null;
		
		List detailTables = new ArrayList();
		
		for(int i=0;wdtis!=null&&i<wdtis.length;i++){
			DetailTable detailTable = new DetailTable();
			detailTable.setId((i+1)+"");
			
			WorkflowDetailTableInfo wdti = wdtis[i];
			
			WorkflowRequestTableRecord[] wrtrs = wdti.getWorkflowRequestTableRecords();
			
			List rows = new ArrayList();
			
			for(int j=0;wrtrs!=null&&j<wrtrs.length;j++) {
				
				Row row = new Row();
				row.setId(j+"");
				
				WorkflowRequestTableRecord wrtr = wrtrs[j];
				
				WorkflowRequestTableField[] wrtfs = wrtr.getWorkflowRequestTableFields();
				
				List cells = new ArrayList();
				
				for(int k=0;wrtfs!=null&&k<wrtfs.length;k++) {
				
					WorkflowRequestTableField wrtf = wrtfs[k];
					
					if(wrtf!=null) {
						
						if(wrtf.getFieldName()!=null&&!"".equals(wrtf.getFieldName())
								&&wrtf.getFieldValue()!=null&&!"".equals(wrtf.getFieldValue())
								&&wrtf.isView()&&wrtf.isEdit()){
						
							Cell cell = new Cell();
							
							cell.setName(wrtf.getFieldName());
							cell.setValue(wrtf.getFieldValue());
							cell.setType(wrtf.getFieldType());
							cells.add(cell);
						}
					
					}
				}
				
				if(cells!=null&&cells.size()>0) {
					Cell[] cellarray = (Cell[])cells.toArray(new Cell[cells.size()]);
					row.setCell(cellarray);
				}
				rows.add(row);
			}
			
			if(rows!=null&&rows.size()>0) {
				Row[] rowarray = (Row[])rows.toArray(new Row[rows.size()]);
				detailTable.setRow(rowarray);
			}
			detailTables.add(detailTable);
		}
		DetailTable[] detailTablearray = (DetailTable[])detailTables.toArray(new DetailTable[detailTables.size()]);
		detailTableInfo.setDetailTable(detailTablearray);
		requestInfo.setDetailTableInfo(detailTableInfo);

		return requestInfo;
	}

	/**
	 * 将RequestInfo转换为WorkflowRequestInfo
	 * 
	 * @param RequestInfo
	 * @return WorkflowRequestInfo
	 */
	private WorkflowRequestInfo getFromRequestInfo(RequestInfo ri, int userid, int fromrequestid, int pagesize) throws Exception {
		WorkflowRequestInfo wri = new WorkflowRequestInfo();

		WorkflowComInfo workflowComInfo = new WorkflowComInfo();
		WorkTypeComInfo workflowTypeComInfo = new WorkTypeComInfo();
		RequestComInfo requestComInfo = new RequestComInfo();

		ResourceComInfo resourceComInfo = new ResourceComInfo();

		WorkFlowInit wfi = new WorkFlowInit();
		User user = getUser(userid);

		wri.setRequestId(ri.getRequestid());
		wri.setRequestName(ri.getDescription());
		wri.setRequestLevel(ri.getRequestlevel());
		wri.setMessageType(ri.getRemindtype());

		WorkflowBaseInfo wbi = new WorkflowBaseInfo();

		wbi.setWorkflowId(ri.getWorkflowid());
		wbi.setWorkflowName(workflowComInfo.getWorkflowname(ri.getWorkflowid()));
		wbi.setWorkflowTypeId(workflowComInfo.getWorkflowtype(ri.getWorkflowid()));
		wbi.setWorkflowTypeName(workflowTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(ri.getWorkflowid())));

		wri.setWorkflowBaseInfo(wbi);

		String creatorid = "";
		
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		char flag = Util.getSeparator() ;
		weaver.workflow.request.WFLinkInfo wfLinkInfo = new weaver.workflow.request.WFLinkInfo();
		
		int nodeid=wfLinkInfo.getCurrentNodeid(Util.getIntValue(ri.getRequestid()),userid,Util.getIntValue(user.getLogintype(),1));               //节点id
		String nodetype=wfLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档
		String nodename="";
		
		// 查询请求的相关工作流基本信息
		rs.executeProc("workflow_Requestbase_SByID",ri.getRequestid());
		if(rs.next()){
		    if(nodeid<1) nodeid = Util.getIntValue(rs.getString("currentnodeid"),0);
		    if(nodetype.equals("")) nodetype = Util.null2String(rs.getString("currentnodetype"));
		    creatorid = rs.getString("creater");
		}

		wri.setCreatorId(creatorid);
		wri.setCreatorName(resourceComInfo.getLastname(creatorid));
		wri.setCreateTime(requestComInfo.getRequestCreateTime(ri.getRequestid()));
		wri.setLastOperatorName(resourceComInfo.getLastname(ri.getLastoperator()));
		wri.setLastOperateTime(requestComInfo.getRequestCreateTime(ri.getRequestid()));
		
		boolean canView = false ;// 是否可以查看
		boolean canEdit = false;// 是否可以编辑
		boolean canSubmit = false;// 是否可以提交
		rs.executeSql("select requestid,isremark,nodeid from workflow_currentoperator where userid="+userid+" and requestid="+ri.getRequestid()+" order by isremark,id");
		while(rs.next()) {
			canView=true;
		    String isremark = Util.null2String(rs.getString("isremark")) ;
		    int tmpnodeid=Util.getIntValue(rs.getString("nodeid"));
		    if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
		    	canEdit=true;
		    	canView=true;
		    	canSubmit=true;
		    	nodeid=tmpnodeid;
		    	nodetype=wfLinkInfo.getNodeType(nodeid);  
		    	break;
		    }
		    if(isremark.equals("8")){
		    	canView=true;
		        break;
		    }
		}
		if(fromrequestid>0){      // 从相关工作流过来,有查看权限
		    rs.executeSql("select count(*) from workflow_currentoperator where userid="+userid+" and requestid="+fromrequestid);
		    if(rs.next()){
		        int counts=rs.getInt(1);
		        if(counts>0){
		        	canView=true;
		        }
		    }
		}

		int isremark = -1 ;
		rs.executeSql("select isremark from workflow_currentoperator where (isremark<8 or isremark>8) and requestid="+ri.getRequestid()+" and userid="+userid+" order by isremark");
		while(rs.next())	{
		    int tempisremark = Util.getIntValue(rs.getString("isremark"),0) ;
		    if( tempisremark == 0 || tempisremark == 1 || tempisremark == 5 || tempisremark == 9|| tempisremark == 7) {                       // 当前操作者或被转发者
		        isremark = tempisremark ;
		        break ;
		    }
		}
		if(isremark==-1){
			rs.executeSql("select isremark from workflow_currentoperator where isremark=8 and requestid="+ri.getRequestid()+" and userid="+userid);
			while(rs.next())	{
			    int tempisremark = Util.getIntValue(rs.getString("isremark"),0) ;
			    if(tempisremark==8){//抄送（不提交）查看页面即更新为已办事宜。
			    	rs2.executeProc("workflow_CurrentOperator_Copy",ri.getRequestid()+""+flag+userid+flag+user.getLogintype()+"");
			    	if(nodetype.equals("3")){
			    		rs2.executeSql("update workflow_currentoperator set iscomplete=1 where requestid="+ri.getRequestid()+" and userid="+userid);
			    	} 
			    	canView = true;
			    	canEdit = false;
			    	canSubmit = true;
			    	break;
			    }
			}
		}
		if( isremark != 0 && isremark != 1&& isremark != 5 && isremark != 9&& isremark != 7) {
			canEdit = false;
			canSubmit = false;
		}
		
		wri.setCanView(canView);
		wri.setCanEdit(canEdit);

		Map map=getRightMenu(wri.getWorkflowBaseInfo().getWorkflowId(), nodeid, wri.getRequestId(), isremark, user, nodetype, fromrequestid > 0);

		/*
		if(nodetype.equals("0")){//创建节点 //提交
			submitButtonName = (String)map.get("submitName");//提交
		} else if(nodetype.equals("1")){//审批节点 
			if(isremark == 0) {//批准、退回、沟通、转办
				submitButtonName = (String)map.get("submitName");
				rejectButtonName = (String)map.get("rejectName");// 退回
				forwardButtonName = (String)map.get("forwardName");// 转发
			} else if(isremark == 1 || isremark == 8 || isremark == 9) {//批准
				submitButtonName = (String)map.get("submitName");
			}
		} else if(nodetype.equals("2")){//处理节点
			if(isremark == 0) {//提交、沟通、转办
				submitButtonName = (String)map.get("submitName");
				forwardButtonName = (String)map.get("forwardName");// 转发
			} else if(isremark == 1 || isremark == 8 || isremark == 9) {//提交
				submitButtonName = (String)map.get("submitName");//提交
			}
		} else if(nodetype.equals("3")){//归档节点
			if(isremark == 0) {
				submitButtonName = (String)map.get("submitName");//提交
				forwardButtonName = (String)map.get("forwardName");// 转发
			} else if(isremark == 1 || isremark == 8 || isremark == 9) {
				submitButtonName = (String)map.get("submitName");// 已阅
			}
		}
		*/
		wri.setSubmitButtonName((String)map.get("submitName"));
		wri.setSubnobackButtonName((String)map.get("subnobackName"));
		wri.setSubbackButtonName((String)map.get("subbackName"));
		wri.setRejectButtonName((String)map.get("rejectName"));
		wri.setForwardButtonName((String)map.get("forwardName"));
		
		rs.executeSql("select * from workflow_nodebase where id = " + nodeid);
		if (rs.next())
			nodename = rs.getString("nodename");
		wri.setCurrentNodeName(nodename);
		wri.setCurrentNodeId(nodeid+"");
		
		String requestid = "";
		String status = "";
		requestid = wri.getRequestId();
		rs.executeSql("select * from workflow_requestbase where requestid = " + requestid);
		if (rs.next())
			status = rs.getString("status");
		wri.setStatus(status);

		WorkflowMainTableInfo wmti = getWorkflowMainTableInfo(ri.getWorkflowid(), ri.getRequestid(), user, wri);
		wri.setWorkflowMainTableInfo(wmti);

		WorkflowDetailTableInfo[] wdtis = getWorkflowDetailTableInfos(wri, user);
		wri.setWorkflowDetailTableInfos(wdtis);

		//WorkflowRequestLog[] workflowRequestLogs = getWorkflowRequestLogs(ri,user);//换用新分页方法
		WorkflowRequestLog[] workflowRequestLogs = getWorkflowRequestLogs(ri.getWorkflowid(), ri.getRequestid(), userid, pagesize, 0);
		wri.setWorkflowRequestLogs(workflowRequestLogs);
		wri.setMustInputRemark(requestService.whetherMustInputRemark(Util.getIntValue(wri.getRequestId(), 0), Util.getIntValue(ri.getWorkflowid(), 0), nodeid, userid, 1));
		//流程短语
		wri.setWorkflowPhrases(getWorkflowPhrases(user));

		wri = getWorkflowRequestInfoHTMLTemplete(wri, user);
		
		//是否需要确认
	    String needAffirmance = "";
	    rs.executeSql("select needAffirmance from workflow_base where id="+ri.getWorkflowid());
	    if (rs.next()) {
	    	needAffirmance = rs.getString("needAffirmance");
	    }
	    if ("1".equals(needAffirmance)) {
	    	wri.setNeedAffirmance(true);
	    } else {
	    	wri.setNeedAffirmance(false);
	    }
	    
	    //签字意见
	    char flag1 = Util.getSeparator();
	    int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
	    String myremark = "" ;
	    rs.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
        if(rs.next()){
           myremark = Util.null2String(rs.getString("remark"));
           myremark = splitAndFilterString(myremark,10000);
           myremark = myremark.replaceAll("initFlashVideo;", "");
        }
        wri.setRemark(myremark);
		
		return wri;
	}

	private User getUser(int userid) {
		User user=new User();
		try {
			ResourceComInfo rc = new ResourceComInfo();
			user.setUid(userid);
			user.setLoginid(rc.getLoginID("" + userid));
			user.setFirstname(rc.getFirstname("" + userid));
			user.setLastname(rc.getLastname("" + userid));
			user.setLogintype("1");
			// user.setAliasname(rc.getAssistantID(""+userid));
			// user.setTitle(rs.getString("title"));
			// user.setTitlelocation(rc.getLocationid(""+userid));
			user.setSex(rc.getSexs("" + userid));
			user.setLanguage(7);
			// user.setTelephone(rc);
			// user.setMobile(rc.getm);
			// user.setMobilecall(rs.getString("mobilecall"));
			user.setEmail(rc.getEmail("" + userid));
			// user.setCountryid();
			user.setLocationid(rc.getLocationid("" + userid));
			user.setResourcetype(rc.getResourcetype("" + userid));
			// user.setStartdate(rc.gets);
			// user.setEnddate(rc.gete);
			// user.setContractdate(rc.getc);
			user.setJobtitle(rc.getJobTitle("" + userid));
			// user.setJobgroup(rs.getString("jobgroup"));
			// user.setJobactivity(rs.getString("jobactivity"));
			user.setJoblevel(rc.getJoblevel("" + userid));
			user.setSeclevel(rc.getSeclevel("" + userid));
			user.setUserDepartment(Util.getIntValue(rc.getDepartmentID("" + userid), 0));
			// user.setUserSubCompany1(Util.getIntValue(rc.get,0));
			// user.setUserSubCompany2(Util.getIntValue(rs.getString("subcompanyid2"),0));
			// user.setUserSubCompany3(Util.getIntValue(rs.getString("subcompanyid3"),0));
			// user.setUserSubCompany4(Util.getIntValue(rs.getString("subcompanyid4"),0));
			user.setManagerid(rc.getManagerID("" + userid));
			user.setAssistantid(rc.getAssistantID("" + userid));
			// user.setPurchaselimit(rc.getPropValue(""+userid));
			// user.setCurrencyid(rc.getc);
			// user.setLastlogindate(rc.get);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	/**
	 * 取得流程主表信息
	 * 
	 * @param RequestInfo
	 * @return WorkflowMainTableInfo
	 * @throws Exception
	 */
	private WorkflowMainTableInfo getWorkflowMainTableInfo(String wid, String rid, User user, WorkflowRequestInfo wri) throws Exception {
		WorkflowBillComInfo workflowBillComInfo = new WorkflowBillComInfo();
		WorkflowJspBean workflowJspBean = new WorkflowJspBean();
		WFLinkInfo wfLinkInfo = new WFLinkInfo();
		FieldComInfo fieldComInfo = new FieldComInfo();
		weaver.workflow.field.SpecialFieldInfo specialFieldInfo = new weaver.workflow.field.SpecialFieldInfo();

		//WFNodeFieldMainManager wfNodeFieldMainManager = new WFNodeFieldMainManager();

		RecordSet rs = new RecordSet();

		int workflowid = Util.getIntValue(wid, 0);
		int requestid = Util.getIntValue(rid, 0);
		String currentnodetype = "";
		int currentnodeid = 0;
		int billid = 0;
		int formid = 0;
		String isbill = "";
		int isremark = -1;

		int nodeid = -1;
		String nodetype = "";

		if(requestid>0) {
			nodeid = wfLinkInfo.getCurrentNodeid(requestid, user.getUID(), Util.getIntValue(user.getLogintype(), 1)); // 节点id
			nodetype = wfLinkInfo.getNodeType(nodeid); // 节点类型 0:创建 1:审批 2:实现 3:归档
			
			rs.executeProc("workflow_Requestbase_SByID", requestid + "");
			if (rs.next()) {
				currentnodeid = Util.getIntValue(rs.getString("currentnodeid"), 0);
				if (nodeid < 1)
					nodeid = currentnodeid;
				currentnodetype = Util.null2String(rs.getString("currentnodetype"));
				if (nodetype.equals(""))
					nodetype = currentnodetype;
			}
		} else {
			rs.executeProc("workflow_CreateNode_Select",workflowid+"");
			if(rs.next()){
				nodeid = Util.getIntValue(Util.null2String(rs.getString(1)),0) ;
				nodetype = wfLinkInfo.getNodeType(nodeid);
			}
		}
		rs.executeProc("workflow_Workflowbase_SByID", workflowid + "");
		if (rs.next()) {
			formid = Util.getIntValue(rs.getString("formid"), 0);
			isbill = "" + Util.getIntValue(rs.getString("isbill"), 0);
		}
		if(requestid>0){
			if (isbill.equals("1")) {
				rs.executeProc("workflow_form_SByRequestid", requestid + "");
				if (rs.next()) {
					formid = Util.getIntValue(rs.getString("billformid"), 0);
					billid = Util.getIntValue(rs.getString("billid"));
				}
			}
		}
		if(requestid>0){
			rs.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid=" + requestid + " and userid=" + user.getUID() + " and usertype=0" + " order by isremark,id");
			while (rs.next()) {
				isremark = Util.getIntValue(rs.getString("isremark"), -1);
				int tmpnodeid = Util.getIntValue(rs.getString("nodeid"));
				if (isremark == 1 || isremark == 5 || isremark == 7 || isremark == 9 || (isremark == 0 && !nodetype.equals("3"))) {
					nodeid = tmpnodeid;
					nodetype = wfLinkInfo.getNodeType(nodeid);
					break;
				}
			}
		}
		WorkflowMainTableInfo wmti = new WorkflowMainTableInfo();
		if (isbill.equals("1"))
			wmti.setTableDBName(workflowBillComInfo.getTablename(formid + ""));
		
		boolean editflag = true;//流程的处理人可以编辑流程的优先级和是否短信提醒
		if(isremark==1||isremark==2||isremark==8||isremark==9||isremark==7) editflag = false;//被转发人或被抄送人不能编辑
		
		workflowJspBean.setBillid(billid);
		workflowJspBean.setFormid(formid);
		workflowJspBean.setIsbill(isbill);
		workflowJspBean.setNodeid(nodeid);
		workflowJspBean.setRequestid(requestid);
		workflowJspBean.setUser(user);
		workflowJspBean.setWorkflowid(workflowid);
		workflowJspBean.getWorkflowFieldInfo();
		
		List fieldids = workflowJspBean.getFieldids(); // 字段队列
		List fieldorders = workflowJspBean.getFieldorders(); // 字段显示顺序队列 (单据文件不需要)
		List languageids = workflowJspBean.getLanguageids(); // 字段显示的语言(单据文件不需要)
		List fieldlabels = workflowJspBean.getFieldlabels(); // 单据的字段的label队列
		List fieldhtmltypes = workflowJspBean.getFieldhtmltypes(); // 单据的字段的html type队列
		List fieldtypes = workflowJspBean.getFieldtypes(); // 单据的字段的type队列
		List fieldnames = workflowJspBean.getFieldnames(); // 单据的字段的表字段名队列
		List fieldvalues = workflowJspBean.getFieldvalues(); // 字段的值
		List fieldviewtypes = workflowJspBean.getFieldviewtypes(); // 单据是否是detail表的字段1:是 0:否(如果是,将不显示)
		
		int fieldlen = 0; // 字段类型长度
		List fieldrealtype = workflowJspBean.getFieldrealtype();
		String fielddbtype = ""; // 字段数据类型
		String textheight = "4";// xwj for @td2977 20051111
		//workflowJspBean.getWorkflowFieldViewAttr();
		
		// 确定字段是否显示，是否可以编辑，是否必须输入
		List isfieldids = new ArrayList();//workflowJspBean.getIsfieldids(); // 字段队列
		List isviews = new ArrayList();//workflowJspBean.getIsviews(); // 字段是否显示队列
		List isedits = new ArrayList();//workflowJspBean.getIsedits(); // 字段是否可以编辑队列
		List ismands = new ArrayList();//workflowJspBean.getIsmands(); // 字段是否必须输入队列

		int mode = 0;
		String ismode = "";
		rs.executeSql("select ismode from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
		if(rs.next()) ismode=rs.getString("ismode");
		if(ismode!=null&&ismode.equals("1")){
			String nodemodeid = "";
			rs.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid=" + nodeid);
			if(rs.next()&&Util.getIntValue(rs.getString("id"),0)>0){
				mode = 1;
			} else {
				rs.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
				if(rs.next()&&Util.getIntValue(rs.getString("id"),0)>0){
					mode = 2;
				}
			}
		}
		
		boolean havehtmltemplete = false;
		
		rs.executeSql(" select * from workflow_nodehtmllayout where type=2 and workflowid = " + workflowid + " and nodeid = " + nodeid);
		if(rs.next()){
			havehtmltemplete = true;
		}
		
		if(mode>0&&!havehtmltemplete){
			//设置为图形化模板模式
            int nodeid_mode = 0;
            if(mode == 1) nodeid_mode = nodeid;
			try {
				if(isbill.equals("1")) {
					rs.executeSql("select distinct a.*, b.dsporder from workflow_modeview a, workflow_billfield b where a.fieldid = b.id and a.formid = "+formid+" and a.nodeid = "+nodeid_mode+" and a.isbill=1 order by b.dsporder");
				} else {
					rs.executeSql("select distinct a.*, b.fieldorder from workflow_modeview a, workflow_formfield b where a.fieldid = b.fieldid and a.formid="+formid+" and a.nodeid="+nodeid_mode+" and a.isbill=0 order by b.fieldorder");
				}
			} catch(Exception e){
				e.printStackTrace();
				writeLog(e);
			}
		} else {
			//设置为普通模式/HTML模板模式
			try {
				if(isbill.equals("1")) {
					rs.executeSql("SELECT distinct a.*, b.dsporder from workflow_nodeform a, workflow_billfield b where a.fieldid = b.id and nodeid = "+nodeid+" order by b.dsporder");
				} else {
					rs.executeSql("SELECT * from workflow_nodeform where nodeid = "+nodeid+" order by fieldid");
				}
			} catch(Exception e){
				e.printStackTrace();
				writeLog(e);
			}
		}
		while(rs.next()){
		    isfieldids.add(rs.getString("fieldid"));
		    isviews.add(rs.getString("isview"));
			isedits.add(rs.getString("isedit"));
			ismands.add(rs.getString("ismandatory"));
		}

		HashMap specialfield = specialFieldInfo.getFormSpecialField();

		WorkflowRequestTableRecord wrtr = new WorkflowRequestTableRecord();
		List workflowRequestTableFields = new ArrayList();
		
		//取得流程标题,紧急程度,是否短信提醒等表头字段信息
		List workflowHeadFields = getWorkflowHeadFields(wri,user,editflag);
		if(workflowHeadFields!=null) workflowRequestTableFields.addAll(workflowHeadFields);
		
		//读取流程正文
		String docAttachments = "";
		List docfieldids = new ArrayList();
		rs.executeSql("select * from workflow_createdoc where status='1' and workflowId="+workflowid);
		while(rs.next()){
			String flowDocField = Util.null2String(rs.getString("flowDocField"));
			docfieldids.add(flowDocField);
		}
		
		// 得到每个字段的信息并在页面显示
		for (int i = 0; i < fieldids.size(); i++) { // 循环开始
			int tmpindex = i;
			if (isbill.equals("0"))
				tmpindex = fieldorders.indexOf("" + i); // 如果是表单, 得到表单顺序对应的 i

			String fieldid = (String) fieldids.get(tmpindex); // 字段id

			if (isbill.equals("1")) {
				String viewtype = (String) fieldviewtypes.get(tmpindex); // 如果是单据的从表字段,不显示
				if (viewtype.equals("1"))
					continue;
			}

			String isview = "0"; // 字段是否显示
			String isedit = "0"; // 字段是否可以编辑
			String ismand = "0"; // 字段是否必须输入

			int isfieldidindex = isfieldids.indexOf(fieldid);
			if (isfieldidindex != -1) {
				isview = (String) isviews.get(isfieldidindex); // 字段是否显示
				isedit = (String) isedits.get(isfieldidindex); // 字段是否可以编辑
				ismand = (String) ismands.get(isfieldidindex); // 字段是否必须输入
			}
			if (isremark == 5 || isremark == 9) {
				isedit = "0";// 抄送(需提交)不可编辑
				ismand = "0";
			}
			String fieldname = ""; // 字段数据库表中的字段名
			String fieldhtmltype = ""; // 字段的页面类型
			String fieldtype = ""; // 字段的类型
			String fieldlable = ""; // 字段显示名
			int languageid = 0;

			if (isbill.equals("0")) {
				languageid = Util.getIntValue((String) languageids.get(tmpindex), 0); // 需要更新
				fieldhtmltype = fieldComInfo.getFieldhtmltype(fieldid);
				fieldtype = fieldComInfo.getFieldType(fieldid);
				fieldlable = (String) fieldlabels.get(tmpindex);
				fieldname = fieldComInfo.getFieldname(fieldid);
				fielddbtype = fieldComInfo.getFielddbtype(fieldid);
			} else {
				languageid = user.getLanguage();
				fieldname = (String) fieldnames.get(tmpindex);
				fieldhtmltype = (String) fieldhtmltypes.get(tmpindex);
				fieldtype = (String) fieldtypes.get(tmpindex);
				fielddbtype = (String) fieldrealtype.get(tmpindex);
				fieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue((String) fieldlabels.get(tmpindex), 0), languageid);
			}

			String fieldvalue = "";
			if(fieldvalues!=null&&fieldvalues.size()>0) fieldvalue = (String) fieldvalues.get(tmpindex);

			String fieldformname = "field" + fieldid;
			
			WorkflowRequestTableField wrtf = WorkflowServiceUtil.getWorkflowRequestField(wid, fieldid, fieldname, fieldvalue, fieldhtmltype, fieldtype, fielddbtype, fieldlable, fieldformname, tmpindex, languageid, isview, isedit, ismand, user, specialfield, docfieldids, requestid==0);
			workflowRequestTableFields.add(wrtf);
		}
		
		WorkflowRequestTableField[] wrtfs = new WorkflowRequestTableField[workflowRequestTableFields.size()];
		for (int p = 0; p < workflowRequestTableFields.size(); p++)
			wrtfs[p] = (WorkflowRequestTableField) workflowRequestTableFields.get(p);

		wrtr.setWorkflowRequestTableFields(wrtfs);
		wmti.setRequestRecords(new WorkflowRequestTableRecord[] { wrtr });

		return wmti;
	}
	
	
	/**
	 * 取得流程标题,紧急程度,是否短信提醒等表头字段信息
	 * 
	 * @return List
	 * @throws Exception
	 */
	private List getWorkflowHeadFields(WorkflowRequestInfo wri,User user,boolean editflag) throws Exception {
		List result = new ArrayList();
		
		RecordSet rs = new RecordSet();
		
		WFNodeFieldMainManager wfNodeFieldMainManager = new WFNodeFieldMainManager();
		weaver.workflow.request.WFLinkInfo wfLinkInfo = new weaver.workflow.request.WFLinkInfo();
		String nodetype=wfLinkInfo.getNodeType(Util.getIntValue(wri.getCurrentNodeId()));

		//流程标题
		WorkflowRequestTableField requestnamefield = new WorkflowRequestTableField();
		requestnamefield.setFieldId("-1");
		requestnamefield.setFieldName("requestname");
		requestnamefield.setFieldShowName(SystemEnv.getHtmlLabelName(21192,user.getLanguage()));
		requestnamefield.setFieldFormName("requestname");
		requestnamefield.setFieldOrder(-1);
		requestnamefield.setFieldValue(wri.getRequestName());
		requestnamefield.setFieldShowValue(wri.getRequestName());
		requestnamefield.setFieldType("");
		requestnamefield.setFiledHtmlShow("");
		requestnamefield.setFieldDBType("");
		requestnamefield.setFieldHtmlType("1");//文本框
		
		requestnamefield.setView(true);
		requestnamefield.setEdit(false);
		requestnamefield.setMand(true);
		
		wfNodeFieldMainManager.resetParameter();
		wfNodeFieldMainManager.setNodeid(Util.getIntValue(wri.getCurrentNodeId()));
		wfNodeFieldMainManager.setFieldid(-1);//"流程标题"字段在workflow_nodeform中的fieldid 定为 "-1"
		wfNodeFieldMainManager.selectWfNodeField();
		if(wfNodeFieldMainManager.getIsedit().equals("1")||"0".equals(nodetype))
			requestnamefield.setEdit(true);
		
		
		//紧急程度
		WorkflowRequestTableField requestlevelfield = new WorkflowRequestTableField();
		
		requestlevelfield.setFieldId("-2");
		requestlevelfield.setFieldName("requestlevel");
		requestlevelfield.setFieldShowName("");
		requestlevelfield.setFieldFormName("requestlevel");
		requestlevelfield.setFieldOrder(-2);
		requestlevelfield.setFieldValue(wri.getRequestLevel());
		if("0".equals(wri.getRequestLevel()))
		requestlevelfield.setFieldShowValue(SystemEnv.getHtmlLabelName(225,user.getLanguage()));
		else if("1".equals(wri.getRequestLevel()))
		requestlevelfield.setFieldShowValue(SystemEnv.getHtmlLabelName(15533,user.getLanguage()));
		else if("2".equals(wri.getRequestLevel()))
		requestlevelfield.setFieldShowValue(SystemEnv.getHtmlLabelName(2087,user.getLanguage()));
			
		requestlevelfield.setFieldType("");
		requestlevelfield.setFiledHtmlShow("");
		requestlevelfield.setFieldDBType("");
		requestlevelfield.setFieldHtmlType("5");//选择框
		
		requestlevelfield.setSelectnames(new String[]{SystemEnv.getHtmlLabelName(225,user.getLanguage()),SystemEnv.getHtmlLabelName(15533,user.getLanguage()),SystemEnv.getHtmlLabelName(2087,user.getLanguage())});
		requestlevelfield.setSelectvalues(new String[]{"0","1","2"});
		
		requestlevelfield.setView(true);
		requestlevelfield.setEdit(false);
		requestlevelfield.setMand(false);
		
		wfNodeFieldMainManager.resetParameter();
		wfNodeFieldMainManager.setNodeid(Util.getIntValue(wri.getCurrentNodeId()));
		wfNodeFieldMainManager.setFieldid(-2);//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
		wfNodeFieldMainManager.selectWfNodeField();
		if(wfNodeFieldMainManager.getIsedit().equals("1")||"0".equals(nodetype))
			requestlevelfield.setEdit(true);
		
		//是否短信提醒
		WorkflowRequestTableField messagetypefield = new WorkflowRequestTableField();
		
		messagetypefield.setFieldId("-3");
		messagetypefield.setFieldName("messageType");
		messagetypefield.setFieldShowName(SystemEnv.getHtmlLabelName(17586,user.getLanguage()));
		messagetypefield.setFieldFormName("messageType");
		messagetypefield.setFieldOrder(-3);
		messagetypefield.setFieldValue(wri.getMessageType());
		if("0".equals(wri.getMessageType()))
		messagetypefield.setFieldShowValue(SystemEnv.getHtmlLabelName(17583,user.getLanguage()));
		else if("1".equals(wri.getMessageType()))
		messagetypefield.setFieldShowValue(SystemEnv.getHtmlLabelName(17584,user.getLanguage()));
		else if("2".equals(wri.getMessageType()))
		messagetypefield.setFieldShowValue(SystemEnv.getHtmlLabelName(17585,user.getLanguage()));
		
		messagetypefield.setFieldType("");
		messagetypefield.setFiledHtmlShow("");
		messagetypefield.setFieldDBType("");
		messagetypefield.setFieldHtmlType("5");//选择框
		
		messagetypefield.setSelectnames(new String[]{SystemEnv.getHtmlLabelName(17583,user.getLanguage()),SystemEnv.getHtmlLabelName(17584,user.getLanguage()),SystemEnv.getHtmlLabelName(17585,user.getLanguage())});
		messagetypefield.setSelectvalues(new String[]{"0","1","2"});
		
		messagetypefield.setView(false);
		messagetypefield.setEdit(false);
		messagetypefield.setMand(false);
		
		wfNodeFieldMainManager.resetParameter();
		wfNodeFieldMainManager.setNodeid(Util.getIntValue(wri.getCurrentNodeId()));
		wfNodeFieldMainManager.setFieldid(-3);//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
		wfNodeFieldMainManager.selectWfNodeField();
		if(wfNodeFieldMainManager.getIsedit().equals("1")||"0".equals(nodetype))
			messagetypefield.setEdit(true);
		if(wfNodeFieldMainManager.getIsmandatory().equals("1"))
			messagetypefield.setMand(true);
		
		if((!editflag&&!"0".equals(nodetype))||!wri.isCanEdit()){
			requestnamefield.setEdit(false);
			requestlevelfield.setEdit(false);
			messagetypefield.setEdit(false);
		}

	    String sqlWfMessage = "select messageType from workflow_base where id="+wri.getWorkflowBaseInfo().getWorkflowId();
	    int wfMessageType=0;
	    rs.executeSql(sqlWfMessage);
	    if (rs.next()) {
	    	wfMessageType=rs.getInt("messageType");
	    }
	    if(wfMessageType == 1 && wri.isCanView()){
			messagetypefield.setView(true);
		} else {
			messagetypefield.setView(false);
		}
	    
	    String requestnamehtmlshow = "";
    	if(requestnamefield.isView()) {
	    	if(requestnamefield.isEdit()) {
	    		requestnamehtmlshow = "<table style=\"width:100%;\"><tr><td style=\"width:99%;white-space:normal;\" align=\"left\">" +
		    	"<input type=\"text\" name=\""+requestnamefield.getFieldFormName()+"\" id=\""+requestnamefield.getFieldName()+"\" value=\""+requestnamefield.getFieldValue()+"\" />"+
		    	"</td>";
		    	if(requestnamefield.isMand()) requestnamehtmlshow += 
		    		"<td><span id=\""+requestnamefield.getFieldName()+"_ismandspan\" class=\"ismand\">" +
		    		"!"+
		    		"</span>" +
		    		"<input type=\"hidden\" id=\"ismandfield\" name=\"ismandfield\" value=\""+requestnamefield.getFieldName()+"\"/></td>";
		    	
		    	requestnamehtmlshow += "</tr></table>";
				
	    	} else {
	    		requestnamehtmlshow = requestnamefield.getFieldShowValue();
	    	}
    	}
    	requestnamefield.setFiledHtmlShow(requestnamehtmlshow);
	    
    	String requestlevelhtmlshow = "";
    	if(requestlevelfield.isView()) {
    		if(requestlevelfield.isEdit()) {
    			requestlevelhtmlshow = "<table style=\"width:100%;\"><tr><td style=\"width:99%;white-space:normal;\" align=\"left\">" +
    	    	"<fieldset data-role=\"controlgroup\">" +
		        "<input type=\"radio\" name=\""+requestlevelfield.getFieldFormName()+"\" id=\""+requestlevelfield.getFieldName()+"-0\" value=\"0\" "+("0".equals(requestlevelfield.getFieldValue())?"checked":"") + " />" +
		        "<label for=\""+requestlevelfield.getFieldFormName()+"-0\">"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"</label>" +
		        "<input type=\"radio\" name=\""+requestlevelfield.getFieldFormName()+"\" id=\""+requestlevelfield.getFieldName()+"-1\" value=\"1\" "+("1".equals(requestlevelfield.getFieldValue())?"checked":"") + " />" +
			    "<label for=\""+requestlevelfield.getFieldFormName()+"-1\">"+SystemEnv.getHtmlLabelName(15533,user.getLanguage())+"</label>" +
			    "<input type=\"radio\" name=\""+requestlevelfield.getFieldFormName()+"\" id=\""+requestlevelfield.getFieldName()+"-2\" value=\"2\" "+("2".equals(requestlevelfield.getFieldValue())?"checked":"") + " />" +
			    "<label for=\""+requestlevelfield.getFieldFormName()+"-2\">"+SystemEnv.getHtmlLabelName(2087,user.getLanguage())+"</label>" +
			    "</fieldset>" +
    	    	"</td>";
    	    	if(requestlevelfield.isMand()) requestlevelhtmlshow += 
    	    		"<td><span id=\""+requestlevelfield.getFieldName()+"_ismandspan\" class=\"ismand\">" +
    	    		"!"+
    	    		"</span>" +
    	    		"<input type=\"hidden\" id=\"ismandfield\" name=\"ismandfield\" value=\""+requestlevelfield.getFieldName()+"\"/></td>";
    	    	
    	    	requestlevelhtmlshow += "</tr></table>";
    			
    		} else {
    			requestlevelhtmlshow = requestlevelfield.getFieldShowValue();
    		}
    	}
    	requestlevelfield.setFiledHtmlShow(requestlevelhtmlshow);
    	
	    String messagetypehtmlshow = "";
    	if(messagetypefield.isView()) {
    		if(messagetypefield.isEdit()) {
    			messagetypehtmlshow = "<table style=\"width:100%;\"><tr><td style=\"width:99%;white-space:normal;\" align=\"left\">" +
    	    	"<fieldset data-role=\"controlgroup\">" +
		        "<input type=\"radio\" name=\""+messagetypefield.getFieldFormName()+"\" id=\""+messagetypefield.getFieldName()+"-0\" value=\"0\" "+("0".equals(messagetypefield.getFieldValue())?"checked":"") + " />" +
		        "<label for=\""+messagetypefield.getFieldFormName()+"-0\">"+SystemEnv.getHtmlLabelName(17583,user.getLanguage())+"</label>" +
		        "<input type=\"radio\" name=\""+messagetypefield.getFieldFormName()+"\" id=\""+messagetypefield.getFieldName()+"-1\" value=\"1\" "+("1".equals(messagetypefield.getFieldValue())?"checked":"") + " />" +
			    "<label for=\""+messagetypefield.getFieldFormName()+"-1\">"+SystemEnv.getHtmlLabelName(17584,user.getLanguage())+"</label>" +
			    "<input type=\"radio\" name=\""+messagetypefield.getFieldFormName()+"\" id=\""+messagetypefield.getFieldName()+"-2\" value=\"2\" "+("2".equals(messagetypefield.getFieldValue())?"checked":"") + " />" +
			    "<label for=\""+messagetypefield.getFieldFormName()+"-2\">"+SystemEnv.getHtmlLabelName(17585,user.getLanguage())+"</label>" +
			    "</fieldset>" +
    	    	"</td>";
    	    	if(messagetypefield.isMand()) messagetypehtmlshow += 
    	    		"<td><span id=\""+messagetypefield.getFieldName()+"_ismandspan\" class=\"ismand\">" +
    	    		"!"+
    	    		"</span>" +
    	    		"<input type=\"hidden\" id=\"ismandfield\" name=\"ismandfield\" value=\""+messagetypefield.getFieldName()+"\"/></td>";
    	    	
    	    	messagetypehtmlshow += "</tr></table>";
    			
    		} else {
    			messagetypehtmlshow = messagetypefield.getFieldShowValue();
    			messagetypehtmlshow = "<input type=\"hidden\" name=\""+messagetypefield.getFieldFormName()+"\" value=\""+messagetypefield.getFieldValue()+"\"/>";
    		}
    	}
    	messagetypefield.setFiledHtmlShow(messagetypehtmlshow);
    	
    	result.add(requestnamefield);
		result.add(requestlevelfield);
		result.add(messagetypefield);
		
		return result;
	}
	
	
	/**
	 * 取得流程主表HTML模板信息
	 * 
	 * @param WorkflowMainTableInfo
	 * @return WorkflowMainTableInfo
	 * @throws Exception
	 */
	private WorkflowRequestInfo getWorkflowRequestInfoHTMLTemplete(WorkflowRequestInfo wri, User user) throws Exception {
		RecordSet rs = new RecordSet();

		int workflowid = Util.getIntValue(wri.getWorkflowBaseInfo().getWorkflowId(), 0);
		int requestid = Util.getIntValue(wri.getRequestId(), 0);
		int nodeid = Util.getIntValue(wri.getCurrentNodeId(), 0);
		int formid = 0;
		int billid = 0;
		String isbill = "";
		
		rs.executeProc("workflow_Workflowbase_SByID", workflowid + "");
		if (rs.next()) {
			formid = Util.getIntValue(rs.getString("formid"), 0);
			isbill = "" + Util.getIntValue(rs.getString("isbill"), 0);
		}
		if(requestid>0){
			if (isbill.equals("1")) {
				rs.executeProc("workflow_form_SByRequestid", requestid + "");
				if (rs.next()) {
					formid = Util.getIntValue(rs.getString("billformid"), 0);
					billid = Util.getIntValue(rs.getString("billid"));
				}
			}
		}

		
		String ismode = "";
		rs.executeSql("select ismode from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
		if(rs.next()) ismode=rs.getString("ismode");
		if(Util.getIntValue(ismode,0)>0){ //非普通模式
		
	    	String[] workflowHtmlTemplete = new String[]{null,null};
	    	String[] workflowHtmlShow = new String[]{null,null};
	    	
	    	WFNodeFieldManager wFNodeFieldManager = new WFNodeFieldManager();
			String syspath = "";
			rs.executeSql(" select * from workflow_nodehtmllayout where type=2 and workflowid = " + workflowid + " and nodeid = " + nodeid);
			while(rs.next()){
				syspath = Util.null2String(rs.getString("syspath"));
				String htmlLayout = "";
				String htmlShow = "";
				try {
					htmlLayout = wFNodeFieldManager.readHtmlFile(syspath);//取得模板
					htmlShow = getWorkflowHtmlShow(htmlLayout,wri,user);//解析模板
				} catch(Exception e) {
					writeLog(e);
					e.printStackTrace();
				}
				workflowHtmlTemplete[0] = htmlLayout;
				workflowHtmlShow[0] = htmlShow;
			}
	
		   	wri.setWorkflowHtmlShow(workflowHtmlShow);
		    wri.setWorkflowHtmlTemplete(workflowHtmlTemplete);

		}

	    return wri;
	}

	private String getWorkflowHtmlShow(String htmlLayout, WorkflowRequestInfo wri, User user) {
		Document doc = Jsoup.parse(htmlLayout,"gbk");
		Elements inputs = doc.getElementsByTag("input");
		for (Iterator it = inputs.iterator();it.hasNext();) {
			Element input = (Element) it.next();
			Element parent = input.parent();
			
			String inputid = input.attr("id");
			String inputname = input.attr("name");
			String inputvalue = input.attr("value");
			
			int index = 5;
			if(inputname.startsWith("node")) index = 4;
			String fieldid = inputname.substring(index);
			
			WorkflowRequestTableRecord wrtr = wri.getWorkflowMainTableInfo().getRequestRecords()[0];
			WorkflowRequestTableField[] wrtfs = wrtr.getWorkflowRequestTableFields();
			WorkflowRequestTableField wrtf = null;
			for(int i=0;i<wrtfs.length;i++){
				if(wrtfs[i].getFieldId().equals(fieldid)){
					wrtf = wrtfs[i];
					break;
				}
			}
			
			//字段名称显示
			String fieldshowname = inputvalue;
			
			if(wrtf!=null&&wrtf.getFieldShowName()!=null&&!"".equals(wrtf.getFieldShowName())) fieldshowname = wrtf.getFieldShowName();
			
			//字段显示内容
			String fieldshowhtml = "";
			
			if(wrtf!=null&&wrtf.getFiledHtmlShow()!=null&&!"".equals(wrtf.getFiledHtmlShow())) fieldshowhtml = wrtf.getFiledHtmlShow();
			
			if(inputname.startsWith("label")) { //字段名称
				input.remove();
				parent.append("<span style=\"white-space:normal;\">"+fieldshowname+"</span>");
			}
			if(inputname.startsWith("field")) { //字段
				input.remove();
				parent.append(fieldshowhtml);
			}
			if(inputname.startsWith("node")){ //节点
				input.remove();
				FieldInfo fieldinfo = new FieldInfo();
				fieldinfo.setRequestid(Util.getIntValue(wri.getRequestId(), 0));
				String nodeRemark = fieldinfo.GetNodeRemark(Util.getIntValue(wri.getWorkflowBaseInfo().getWorkflowId(), 0), Util.getIntValue(fieldid, 0), Util.getIntValue(wri.getCurrentNodeId(), 0));
				if(nodeRemark!=null) parent.append(Util.null2String(nodeRemark));
			}
		} 
		Elements tables = doc.getElementsByTag("table");
		Element table = tables.first();
		return (table!=null)?table.outerHtml():"";
		
		//return doc.outerHtml();
	}

	private WorkflowDetailTableInfo[] getWorkflowDetailTableInfos(WorkflowRequestInfo wri, User user) throws Exception {
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		WorkflowDetailTableInfo[] result = null;
		BillManager billManager = null;
		String managepage = "";
		int formid = 0;
		String isbill = "0";
		int workflowid = Util.getIntValue(wri.getWorkflowBaseInfo().getWorkflowId(), 0);
		int requestid = Util.getIntValue(wri.getRequestId(), 0);
		
		rs.executeProc("workflow_Workflowbase_SByID", workflowid + "");
		if (rs.next()) {
			formid = Util.getIntValue(rs.getString("formid"), 0);
			isbill = "" + Util.getIntValue(rs.getString("isbill"), 0);
		}

		if("1".equals(isbill)&&formid>0) {
			try {
				rs.executeProc("bill_includepages_SelectByID",formid+"");
				if(rs.next()) {
					if (requestid <= 0) {
						managepage = Util.null2String(rs.getString("createpage")).trim();
					} else {
						int groupdetailid = 0;
						String isremark = "";
						int nodeid = -1;
						int wfcurrrid = -1;
						boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
						int usertype = Util.getIntValue(user.getLogintype(),1)-1;
						
						String nodetype = "";
						rs1.executeProc("workflow_Requestbase_SByID",requestid+"");
	                	if(rs1.next()){
	                		nodetype = Util.null2String(rs1.getString("currentnodetype"));
	                	}
						
						rs1.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+user.getUID()+" and usertype="+usertype+" order by isremark,id");
						while(rs1.next())	{
							wfcurrrid = rs1.getInt("id");
						    isremark = Util.null2String(rs1.getString("isremark")) ;
						    groupdetailid = Util.getIntValue(rs1.getString("groupdetailid"), 0);
						    nodeid = Util.getIntValue(rs1.getString("nodeid"));
						    //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
						    if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
						      //modify by xhheng @20041217 for TD 1438
						      istoManagePage=true;
						      break;
						    }
						    if(isremark.equals("8")){
						        break;
						    }
						}
						
						//参照managerequestNoform.jsp
						WFForwardManager wfm = new WFForwardManager();
		                wfm.init();
		                wfm.setWorkflowid(workflowid);
		                wfm.setNodeid(nodeid);
		                wfm.setIsremark("" + isremark);
		                wfm.setRequestid(requestid);
		                wfm.setBeForwardid(wfcurrrid);
		                wfm.getWFNodeInfo();
		                String IsPendingForward = wfm.getIsPendingForward();
		                String IsBeForward = wfm.getIsBeForward();
		                String IsSubmitForward=wfm.getIsSubmitForward();
		                boolean IsCanSubmit = wfm.getCanSubmit();
		                WFCoadjutantManager wfcm = new WFCoadjutantManager();
		                wfcm.getCoadjutantRights(groupdetailid);
		                String coadsigntype = wfcm.getSigntype();
		                String coadisforward = wfcm.getIsforward();
		                boolean coadCanSubmit = wfcm.getCoadjutantCanSubmit(requestid, wfcurrrid, "" + isremark, coadsigntype);
						
						if((isremark.equals("1")&&!IsCanSubmit)||("7".equals(isremark)&&!coadCanSubmit)){
						    istoManagePage=false;
						}
						
						if(isremark.equals("0")&&!IsCanSubmit) {
							istoManagePage=false;
						}
						
						if(istoManagePage) {
							managepage = Util.null2String(rs.getString("managepage")).trim();
						} else {
							managepage = Util.null2String(rs.getString("viewpage")).trim();
						}
					}
			    }
				
				if(managepage != null && !"".equals(managepage) && managepage.indexOf(".jsp") >= 0) {
					managepage = managepage.substring(0, managepage.indexOf(".jsp"));
				}
				
				if (managepage != null && !"".equals(managepage)) {
					managepage = "weaver.soa.workflow.bill."+managepage;
					Class operationClass = Class.forName(managepage);
					billManager = (BillManager)operationClass.newInstance();
				}
			}catch (Exception e) {
				writeLog(e);
				billManager = null;
			}
		}
		
		if(billManager != null) {
			//特殊处理
			result = billManager.getWorkflowDetailTableInfos(wri, user);
		} else {
			result = WorkflowServiceUtil.getWorkflowDetailTableInfos4default(wri, user);
		}
		
		return result;
	}
	
	/**
	 * 取得流程签字意见信息
	 * 
	 * @param RequestInfo
	 * @return WorkflowRequestLog[]
	 * @throws Exception
	 */
	public WorkflowRequestLog[] getWorkflowRequestLogs(String workflowId, String requestId, int userid, int pagesize, int endId) throws Exception {
		RequestService requestService = new RequestService();
		DepartmentComInfo dci = new DepartmentComInfo();
		ResourceComInfo rci = new ResourceComInfo();
		CustomerInfoComInfo cici = new CustomerInfoComInfo();
		WFLinkInfo wfli = new WFLinkInfo();
		RecordSet rsCheckUserCreater = new RecordSet();
		
		boolean isOldWf = false;
		RecordSet rs = new RecordSet();
		rs.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestId);
		while(rs.next()){
			if(rs.getString("nodeid") == null || "".equals(rs.getString("nodeid")) || "-1".equals(rs.getString("nodeid"))){
					isOldWf = true;
			}
		}
		
		String creatorNodeId = "-1";
		rs.executeSql("select nodeid from workflow_flownode where workflowid = "+workflowId+" and nodetype = '0'");
		if (rs.next()) {
			creatorNodeId = rs.getString("nodeid");
		}
		
		User user = getUser(userid);
		
		Log[] logs = requestService.getRequestLogs(requestId, pagesize, endId);
		
		List wrls = new ArrayList();
		
		for (int m=0; logs != null && m < logs.length;m++) {
			Log log = logs[m];
			WorkflowRequestLog wrl = new WorkflowRequestLog();
			wrl.setId(log.getId());
			wrl.setNodeId(log.getNodeid());
			wrl.setNodeName(log.getNode());
			wrl.setOperateDate(log.getOpdate());
			wrl.setOperateTime(log.getOptime());
			//wrl.setOperatorDept(log.getOperatordept());
			String returnValue = log.getOptype();
			returnValue = new RequestLogOperateName().getOperateName(workflowId, requestId, log.getNodeid(), log.getOptype(), log.getOperatorid(), user.getLanguage(), log.getOpdate(), log.getOptime());
			if(returnValue == null || "".equals(returnValue)) {
				continue;
			}
            wrl.setOperateType(returnValue);
			
            wrl.setOperatorId(log.getOperatorid());
            
            //获取代理关系
            String log_operatorDept = log.getOperatordept();
            String log_operator = log.getOperatorid();
            String log_nodeid = log.getNodeid();
            String log_operatortype = log.getOperatortype();
            String log_agentorbyagentid = log.getAgentorbyagentid();
            String log_agenttype = log.getAgenttype();
            if(isOldWf) {
            	if(log_operatortype.equals("0")){
            		if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            			wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            		}
            		wrl.setOperatorName(rci.getLastname(log_operator));
            	}else if(log_operatortype.equals("1")){
            		wrl.setOperatorName(cici.getCustomerInfoname(log_operator));
            	}else{
            		wrl.setOperatorName(SystemEnv.getHtmlLabelName(468,user.getLanguage()));
            	}
            } else {
            	if(log_operatortype.equals("0")) {
            		if(!log_agenttype.equals("2")){
            			if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            				wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            			}
            			wrl.setOperatorName(rci.getLastname(log_operator));
            		} else if(log_agenttype.equals("2")){
            			if(!(""+log_nodeid).equals(creatorNodeId) || ((""+log_nodeid).equals(creatorNodeId) && !wfli.isCreateOpt(Util.getIntValue(log.getId()),Util.getIntValue(requestId)))){//非创建节点log,必须体现代理关系
            				if(!"0".equals(Util.null2String(rci.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(rci.getDepartmentID(log_agentorbyagentid)))){
            					wrl.setAgentorDept(dci.getDepartmentname(rci.getDepartmentID(log_agentorbyagentid)));
            				}
            				wrl.setAgentor(rci.getResourcename(log_agentorbyagentid) + SystemEnv.getHtmlLabelName(24214,user.getLanguage()));
            				if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            					wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            				}
            				wrl.setOperatorName(rci.getLastname(log_operator)+SystemEnv.getHtmlLabelName(24213,user.getLanguage()));
            			} else{//创造节点log, 如果设置代理时选中了代理流程创建,同时代理人本身对该流程就具有创建权限,那么该代理人创建节点的log不体现代理关系
            				String agentCheckSql = " select * from workflow_Agent where workflowId="+ workflowId +" and beagenterId=" + log_agentorbyagentid +
												 " and agenttype = '1' " +
												 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
												 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
												 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
												 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
												 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
												 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)";
            				rs.executeSql(agentCheckSql);
            				if(!rs.next()){
            					if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            						wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            					}
            					wrl.setOperatorName(rci.getLastname(log_operator));
            				} else {
            					String isCreator = rs.getString("isCreateAgenter");
            					if(!isCreator.equals("1")){
            						if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            							wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            						}
            						wrl.setOperatorName(rci.getLastname(log_operator));
            					} else{
            						int userLevelUp = -1;
            						int uesrLevelTo = -1;
            						int secLevel = -1;
            						rsCheckUserCreater.executeSql("select seclevel from HrmResource where id= " + log_operator);
            						if(rsCheckUserCreater.next()){
            							secLevel = rsCheckUserCreater.getInt("seclevel");
            						} else {
            							rsCheckUserCreater.executeSql("select seclevel from HrmResourceManager where id= " + log_operator);
            							if(rsCheckUserCreater.next()){
            								secLevel = rsCheckUserCreater.getInt("seclevel");
            							}
            						}
            						
            						//是否有此流程的创建权限
                                    boolean haswfcreate = new ShareManager().hasWfCreatePermission(user, Integer.parseInt(workflowId));
            						
            						if(haswfcreate){
            							if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            								wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            							}
            							wrl.setOperatorName(rci.getLastname(log_operator));
            						} else {
            							if(!"0".equals(Util.null2String(rci.getDepartmentID(log_agentorbyagentid)))&&!"".equals(Util.null2String(rci.getDepartmentID(log_agentorbyagentid)))){
            								wrl.setAgentorDept(dci.getDepartmentname(rci.getDepartmentID(log_agentorbyagentid)));
            							}
            							wrl.setAgentor(rci.getResourcename(log_agentorbyagentid) + SystemEnv.getHtmlLabelName(24214,user.getLanguage()));
            							if(!"0".equals(Util.null2String(log_operatorDept))&&!"".equals(Util.null2String(log_operatorDept))){
            								wrl.setOperatorDept(dci.getDepartmentname(log_operatorDept));
            							}
            							wrl.setOperatorName(rci.getLastname(log_operator)+SystemEnv.getHtmlLabelName(24213,user.getLanguage()));
            						}
            					}
            				}
            			}
            		}
            	} else if(log_operatortype.equals("1")){
            		wrl.setOperatorName(cici.getCustomerInfoname(log_operator));
            	}else{
            		wrl.setOperatorName(SystemEnv.getHtmlLabelName(468,user.getLanguage()));
            	}
            }
            
			//wrl.setOperatorName(log.getOperator());
			wrl.setReceivedPersons(log.getReceiver());
			
			String remark = log.getComment();
			
			String mobileSuffix = getMobileSuffix(remark);
			
			if (mobileSuffix != null && !"".equals(mobileSuffix)) {
				remark = remark.substring(0, remark.lastIndexOf(mobileSuffix));
			}
			
			remark = splitAndFilterString(remark,5000);
			
			remark = remark.replaceAll("initFlashVideo;", "");
			
			remark = Util.toHtml2(remark);
			
			if (mobileSuffix != null && !"".equals(mobileSuffix)) {
				remark += mobileSuffix;
			}
			
			//抄送时不显示签字意见
			if(log.getOptype().equals("t")) remark = "";
			
			wrl.setRemark(remark);
			
			StringBuffer annexDocHtmls = new StringBuffer();
			String annexdocids = log.getAnnexdocids();
			if (annexdocids!=null&&!"".equals(annexdocids)) {
				//流程流转意见特殊处理
				annexdocids = annexdocids.startsWith(",")?annexdocids.substring(1):annexdocids;
				annexdocids = annexdocids.endsWith(",")?annexdocids.substring(0, annexdocids.length()-1):annexdocids;
		    	//读取流程流转对应文档的附件
				rs.executeSql("select i.imagefileid,i.imagefilename,i.imagefiletype,i.fileSize from docimagefile di,imagefile i where di.imagefileid = i.imagefileid and di.docid in ("+annexdocids+") ");
				int curIndex = 0;
				while(rs.next()){
					curIndex++;
					String docImagefileid = Util.null2String(rs.getString("imagefileid"));
					String docImagefilename = Util.null2String(rs.getString("imagefilename"));
					int docImagefileSize = Util.getIntValue(Util.null2String(rs.getString("fileSize")),0);
					
					annexDocHtmls.append("<span style='text-decoration:underline;color:blue;");
					if (curIndex > 1) annexDocHtmls.append("padding-left:54px;");
					annexDocHtmls.append("' onclick=\"toURL('/news/download.do?fileid=");
					annexDocHtmls.append(docImagefileid);
					annexDocHtmls.append("',false);\" style=\"cursor:hand;\">" + docImagefilename + "(" + (new BigDecimal((docImagefileSize / 1000)+"").setScale(1, BigDecimal.ROUND_HALF_UP)) + "K)</span><br/><br/>");
				}
			}
			
			wrl.setAnnexDocHtmls(annexDocHtmls.toString());
			
			//取得流程签章
			int tempImageFileId=0;
			int tempRequestLogId=Util.getIntValue(log.getRequestLogId());
			if(tempRequestLogId>0){
				rs.executeSql("select imageFileId from Workflow_FormSignRemark where requestLogId="+tempRequestLogId);
				if(rs.next()){
					tempImageFileId=Util.getIntValue(rs.getString("imageFileId"),0);
				}
			}

			if(!log.getOptype().equals("t")){
				if(tempRequestLogId>0&&tempImageFileId>0){
					wrl.setRemarkSign(tempImageFileId+"");
				}
			}
			
			//取得个人签章
			weaver.workflow.mode.FieldInfo fieldInfo = new weaver.workflow.mode.FieldInfo();
            BaseBean wfsbean=fieldInfo.getWfsbean();
            int showimg = Util.getIntValue(wfsbean.getPropValue("WFSignatureImg","showimg"),0);
            rs.execute("select * from DocSignature  where hrmresid=" + log.getOperatorid() + "order by markid");
            String userimg = "";
            if (showimg == 1 && rs.next()) {
                // 获取签章图片并显示
            	userimg = Util.null2String(rs.getString("markPath"));
            }
            if(!userimg.equals("")){
            	wrl.setOperatorSign(userimg);
            }
            
            //取得相关流程//log.getSignworkflowids()
            weaver.workflow.workflow.WorkflowRequestComInfo workflowRequestComInfo = new weaver.workflow.workflow.WorkflowRequestComInfo();
            String tempshowvalue = "";
            String log_signworkflowids = log.getSignworkflowids();
            ArrayList tempwflists=Util.TokenizerString(log_signworkflowids,",");
            for(int k=0;k<tempwflists.size();k++){
            	String signwfid = (String)tempwflists.get(k);
            	
				tempshowvalue += "<span style='text-decoration:underline;color:blue;";
				if (k > 0) tempshowvalue += "padding-left:54px;";
				tempshowvalue += "' onclick='toRequest(" + signwfid + ");'>" + workflowRequestComInfo.getRequestName(signwfid) + "</span><br/><br/>";
            }
            wrl.setSignWorkFlowHtmls(tempshowvalue);
            
			// 取得相关文档//log.getSigndocids()
			tempshowvalue = "";
			String log_signdocids = log.getSigndocids();
			if (log_signdocids!= null && !log_signdocids.equals("")) {
				rs.executeSql("select id,docsubject,accessorycount,SecCategory from docdetail where id in("	+ log_signdocids + ") order by id asc");
				int curIndex = 0;
				while (rs.next()) {
					curIndex++;
					String tempshowid = Util.null2String(rs.getString(1));
					String tempshowname = Util.toScreen(rs.getString(2),user.getLanguage());
					
					tempshowvalue += "<span style='text-decoration:underline;color:blue;";
					if (curIndex > 1) tempshowvalue += "padding-left:54px;";
					tempshowvalue += "' onclick='toDocument(" + tempshowid + ");'>" + tempshowname + "</span><br/><br/>";
				}
			}
            wrl.setSignDocHtmls(tempshowvalue);

			wrls.add(wrl);
		}

		WorkflowRequestLog[] result = new WorkflowRequestLog[wrls.size()];
		wrls.toArray(result);
		return result;
	}

	private String splitAndFilterString(String input, int length) {   
        if (input == null || input.trim().equals("")) {   
            return "";   
        }   
        // 去掉所有html元素,   
        String str = input.replaceAll("\\&[a-zA-Z]{1,10};", "").replaceAll(   
                "<[^>]*>", "");   
        str = str.replaceAll("[(/>)<]", "");   
        int len = str.length();   
        if (len <= length) {   
            return str;   
        } else {   
            str = str.substring(0, length);   
            str += "......";   
        }   
        return str;   
    }	
	
	private String getMobileSuffix(String input) {
		if (input == null || input.trim().equals("")) {   
            return "";   
        }
		
		String[] suffixs = new String[]{"<br/><br/><span style=\"font-size:11px;color:#666;\">来自iPhone客户端</span>",
				"<br/><br/><span style=\"font-size:11px;color:#666;\">来自iPad客户端</span>",
				"<br/><br/><span style=\"font-size:11px;color:#666;\">来自Android客户端</span>",
				"<br/><br/><span style=\"font-size:11px;color:#666;\">来自Web手机版客户端</span>"};
		
		for(int i=0; i<suffixs.length; i++) {
			if(input.endsWith(suffixs[i])) {
				return suffixs[i];
			}
		}
		
		return "";
	}

	public String getLeaveDays(String fromDate, String fromTime, String toDate, String toTime, String resourceId) {
		String result = "0.00";
		try {
			ResourceComInfo rci = new ResourceComInfo();
			DepartmentComInfo dci = new DepartmentComInfo();
			RecordSet rs = new RecordSet();
			HrmScheduleDiffUtil hsdu = new HrmScheduleDiffUtil();
			
			String departmentId=rci.getDepartmentID(""+resourceId);
			String subCompanyId=dci.getSubcompanyid1(departmentId);
	
			//String totalWorkingDays=HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime);
		    String sqlHrmResource = "select locationid from HrmResource where id ="+resourceId;
			rs.executeSql(sqlHrmResource);
			String locationid = "";
			if (rs.next()){
			   locationid=rs.getString("locationid");
			}
			String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
			rs.executeSql(sqlHrmLocations);
			String countryId = "";
			if (rs.next()){
			   countryId =  rs.getString("countryid");
			}
			User user1 = new User();
			user1.setCountryid(countryId);
			hsdu.setUser(user1);
			String totalWorkingDays=hsdu.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,Util.getIntValue(subCompanyId,0));
			if(totalWorkingDays==null||totalWorkingDays.trim().equals("")){
				totalWorkingDays="0.00";
			}
		
			result=totalWorkingDays;
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return result;
	}
	
	/**
	 * @author liu zheng yang
	 * @param workflowid
	 * @param nodeid
	 * @param requestid
	 * @param isremark
	 * @param user
	 * @param nodetype
	 * @return
	 */
	private Map getCustomeButtonMenu(String workflowid ,int nodeid,String requestid,int isremark,User user,String nodetype){
		Map map=new HashMap();
		RecordSet recordSet=new RecordSet();
		String submitname = "" ; // 提交按钮的名称 : 创建, 审批, 实现
		String forwardName = "";//转发
		String saveName = "";//保存
		String rejectName = "";//退回
		String forsubName = "";//转发提交
		String ccsubName = "";//抄送提交
		String newWFName = "";//新建流程按钮
		String newSMSName = "";//新建短信按钮
		String haswfrm = "";//是否使用新建流程按钮
		String hassmsrm = "";//是否使用新建短信按钮
		int t_workflowid = 0;//新建流程的ID
		String subnobackName = "";//提交不需反馈
		String subbackName = "";//提交需反馈
		String hasnoback = "";//使用提交不需反馈按钮
		String hasback = "";//使用提交需反馈按钮
		String forsubnobackName = "";//转发批注不需反馈
		String forsubbackName = "";//转发批注需反馈
		String hasfornoback = "";//使用转发批注不需反馈按钮
		String hasforback = "";//使用转发批注需反馈按钮
		String ccsubnobackName = "";//抄送批注不需反馈
		String ccsubbackName = "";//抄送批注需反馈
		String hasccnoback = "";//使用抄送批注不需反馈按钮
		String hasccback = "";//使用抄送批注需反馈按钮
		String newOverTimeName=""; //超时设置按钮
		String hasovertime="";    //是否使用超时设置按钮
		String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
		if(isremark != 0){
			recordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+user.getUID()+" and c.usertype="+user.getType()+" and c.isremark='"+isremark+"' ");
			String tmpnodeid="";
			if(recordSet.next()){
				tmpnodeid = Util.null2String(recordSet.getString("nodeid"));
			}
			sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
		}
		recordSet.executeSql(sqlselectName);

		if(recordSet.next()){
			if(user.getLanguage() == 7){
				submitname = Util.null2String(recordSet.getString("submitname7"));
				forwardName = Util.null2String(recordSet.getString("forwardName7"));
				saveName = Util.null2String(recordSet.getString("saveName7"));
				rejectName = Util.null2String(recordSet.getString("rejectName7"));
				forsubName = Util.null2String(recordSet.getString("forsubName7"));
				ccsubName = Util.null2String(recordSet.getString("ccsubName7"));
				newWFName = Util.null2String(recordSet.getString("newWFName7"));
				newSMSName = Util.null2String(recordSet.getString("newSMSName7"));
				subnobackName = Util.null2String(recordSet.getString("subnobackName7"));
				subbackName = Util.null2String(recordSet.getString("subbackName7"));
				forsubnobackName = Util.null2String(recordSet.getString("forsubnobackName7"));
				forsubbackName = Util.null2String(recordSet.getString("forsubbackName7"));
				ccsubnobackName = Util.null2String(recordSet.getString("ccsubnobackName7"));
				ccsubbackName = Util.null2String(recordSet.getString("ccsubbackName7"));
		        newOverTimeName = Util.null2String(recordSet.getString("newOverTimeName7"));
			}
			else if(user.getLanguage() == 9){
				submitname = Util.null2String(recordSet.getString("submitname9"));
				forwardName = Util.null2String(recordSet.getString("forwardName9"));
				saveName = Util.null2String(recordSet.getString("saveName9"));
				rejectName = Util.null2String(recordSet.getString("rejectName9"));
				forsubName = Util.null2String(recordSet.getString("forsubName9"));
				ccsubName = Util.null2String(recordSet.getString("ccsubName9"));
				newWFName = Util.null2String(recordSet.getString("newWFName9"));
				newSMSName = Util.null2String(recordSet.getString("newSMSName9"));
				subnobackName = Util.null2String(recordSet.getString("subnobackName9"));
				subbackName = Util.null2String(recordSet.getString("subbackName9"));
				forsubnobackName = Util.null2String(recordSet.getString("forsubnobackName9"));
				forsubbackName = Util.null2String(recordSet.getString("forsubbackName9"));
				ccsubnobackName = Util.null2String(recordSet.getString("ccsubnobackName9"));
				ccsubbackName = Util.null2String(recordSet.getString("ccsubbackName9"));
		        newOverTimeName = Util.null2String(recordSet.getString("newOverTimeName9"));
			}
			else{
				submitname = Util.null2String(recordSet.getString("submitname8"));
				forwardName = Util.null2String(recordSet.getString("forwardName8"));
				saveName = Util.null2String(recordSet.getString("saveName8"));
				rejectName = Util.null2String(recordSet.getString("rejectName8"));
				forsubName = Util.null2String(recordSet.getString("forsubName8"));
				ccsubName = Util.null2String(recordSet.getString("ccsubName8"));
				newWFName = Util.null2String(recordSet.getString("newWFName8"));
				newSMSName = Util.null2String(recordSet.getString("newSMSName8"));
				subnobackName = Util.null2String(recordSet.getString("subnobackName8"));
				subbackName = Util.null2String(recordSet.getString("subbackName8"));
				forsubnobackName = Util.null2String(recordSet.getString("forsubnobackName8"));
				forsubbackName = Util.null2String(recordSet.getString("forsubbackName8"));
				ccsubnobackName = Util.null2String(recordSet.getString("ccsubnobackName8"));
				ccsubbackName = Util.null2String(recordSet.getString("ccsubbackName8"));
		        newOverTimeName = Util.null2String(recordSet.getString("newOverTimeName8"));
			}
			haswfrm = Util.null2String(recordSet.getString("haswfrm"));
			hassmsrm = Util.null2String(recordSet.getString("hassmsrm"));
			hasnoback = Util.null2String(recordSet.getString("hasnoback"));
			hasback = Util.null2String(recordSet.getString("hasback"));
			hasfornoback = Util.null2String(recordSet.getString("hasfornoback"));
			hasforback = Util.null2String(recordSet.getString("hasforback"));
			hasccnoback = Util.null2String(recordSet.getString("hasccnoback"));
			hasccback = Util.null2String(recordSet.getString("hasccback"));
			t_workflowid = Util.getIntValue(recordSet.getString("workflowid"), 0);
		    hasovertime = Util.null2String(recordSet.getString("hasovertime"));
		}


		if(isremark == 1){
			submitname = forsubName;
			subnobackName = forsubnobackName;
			subbackName = forsubbackName;
		}
		if(isremark == 9||isremark == 7){
			submitname = ccsubName;
			subnobackName = ccsubnobackName;
			subbackName =  ccsubbackName;
		}
		if("".equals(submitname)){
			if(nodetype.equals("0") || isremark == 1 || isremark == 9||isremark == 7){
				submitname = SystemEnv.getHtmlLabelName(615,user.getLanguage());      // 创建节点或者转发, 为提交
			}else if(nodetype.equals("1")){
				submitname = SystemEnv.getHtmlLabelName(142,user.getLanguage());  // 审批
			}else if(nodetype.equals("2")){
				submitname = SystemEnv.getHtmlLabelName(725,user.getLanguage());  // 实现
			}
		}
		if("".equals(subbackName)){
				if(nodetype.equals("0") || isremark == 1 || isremark == 9||isremark == 7)	{
					if((nodetype.equals("0") && ("1".equals(hasnoback)||"1".equals(hasback))) || (isremark==1 && ("1".equals(hasfornoback)||"1".equals(hasforback))) || (isremark==9 && ("1".equals(hasccnoback)||"1".equals(hasccback)))){
						subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";      // 创建节点或者转发, 为提交
					}else{
						subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
					}
				}else if(nodetype.equals("1")){
					if("1".equals(hasnoback)||"1".equals(hasback)){
						subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";  // 审批
					}else{
						subbackName = SystemEnv.getHtmlLabelName(142,user.getLanguage());
					}
				}else if(nodetype.equals("2")){
					if("1".equals(hasnoback)||"1".equals(hasback)){
						subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";  // 实现
					}else{
						subbackName = SystemEnv.getHtmlLabelName(725,user.getLanguage());
					}
				}
		}
		if("".equals(subnobackName)){
			if(nodetype.equals("0") || isremark == 1 || isremark == 9 ||isremark == 7)	{
				subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";      // 创建节点或者转发, 为提交
			}else if(nodetype.equals("1")){
				subnobackName = SystemEnv.getHtmlLabelName(142,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";  // 审批
			}else if(nodetype.equals("2")){
				subnobackName = SystemEnv.getHtmlLabelName(725,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";  // 实现
			}
		}
		if("".equals(forwardName)){
			forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
		}
		if("".equals(saveName)){
			saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
		}
		if("".equals(rejectName)){
			rejectName = SystemEnv.getHtmlLabelName(236,user.getLanguage());
		}
		if("".equals(submitname)){
			if(!"".equals(subbackName)) submitname = subbackName;
			else if(!"".equals(subnobackName)) submitname = subnobackName;
		}
		map.put("submitName", submitname);
		map.put("rejectName", rejectName);
		map.put("forwardName",forwardName);
		return map;
	}
	
	public String[] getWorkflowNewFlag(String[] requestids, String resourceid) {
		if(requestids==null || requestids.length <= 0) return new String[]{};
		String[] result = new String[requestids.length];
		try {
			RecordSet rs = new RecordSet();
			
			String requestidstr = "";
			
			for(int i=0;i<requestids.length;i++) requestidstr+=","+requestids[i];
			requestidstr=requestidstr.startsWith(",")?requestidstr.substring(1):requestidstr;
			
			boolean[] isprocessed=new boolean[requestids.length];
			for(int i=0;i<isprocessed.length;i++) isprocessed[i] = false;
			
		    rs.executeSql("select requestid,isprocessed from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3'))  or isremark='5') and requestid in (" + requestidstr + ") ");
		    while(rs.next()){
		    	String tmprequestid = rs.getString("requestid");
		        for(int i=0;i<requestids.length;i++){
		        	if(requestids[i].equals(tmprequestid))
		        		isprocessed[i] = true;
		        }
		    }
		    
		    String[] viewtype=new String[requestids.length];
		    for(int i=0;i<viewtype.length;i++) viewtype[i] = "";
		    
		    rs.executeSql("select distinct t1.requestid,t2.viewtype from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.userid = " + resourceid + " and t2.viewtype = 0 and t1.requestid in (" + requestidstr + ") ");
		    while(rs.next()){
		    	String tmprequestid = rs.getString("requestid");
		    	String tmpviewtype = rs.getString("viewtype");
		        for(int i=0;i<requestids.length;i++){
		        	if(requestids[i].equals(tmprequestid)){
		        		viewtype[i] = tmpviewtype;
		        		break;
		        	}
		        }
		    }

		    for(int i=0;i<result.length;i++) result[i] = "0";
		    for(int i=0;i<requestids.length;i++){
			    if (viewtype[i].equals("0")) { 
			        if(!isprocessed[i]){
			        	result[i] = "1";
			        }
			    }
		    }
	
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
		return result;
	}
	
	
	public void writeWorkflowReadFlag(String requestid, String userid) {
		try {
			RecordSet rs = new RecordSet();
			
			//获得当前的日期和时间
			Calendar today = Calendar.getInstance();
			String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

			String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			                     Util.add0(today.get(Calendar.SECOND), 2) ;
			
			String sql = "update workflow_currentoperator set viewtype=-2,operatedate='"+currentdate+"',operatetime='"+currenttime+"' where requestid="+requestid+" and userid= "+userid;
		
			rs.executeSql(sql);
			
		} catch (Exception e) {
			e.printStackTrace();
			writeLog(e);
		}
	}
	
	/**
	 * 取得右键菜单
	 * @param workflowid
	 * @param nodeid
	 * @param requestid
	 * @param isremark
	 * @param user
	 * @param nodetype
	 * @param isrequest
	 * @return
	 * @throws Exception
	 */
	public Map getRightMenu(String workflowid ,int nodeid,String requestid,int isremark,User user,String nodetype, boolean isrequest) throws Exception {
		Map result = new HashMap();
		boolean getsuccess = true;
		try {
			String submitName = "";
			String subnobackName = "";
			String subbackName = "";
			String forwardName = "";
			String rejectName = "";
			//返回格式:0,提交|0,提交不需反馈|0,提交需反馈|0,转发|0,退回|0,保存
			String menu = requestService.getRightMenu(Util.getIntValue(requestid, 0), user.getUID(), Util.getIntValue(user.getLogintype(),1), user.getLanguage(), Util.getIntValue(workflowid, 0), isrequest);
			if(menu!=null&&!"".equals(menu)) {
				List tmpmenustrs = Util.TokenizerString(menu, "|");
				for(int i=0;tmpmenustrs!=null&&i<tmpmenustrs.size();i++){
					String tmpmenustr = (String) tmpmenustrs.get(i);
					if(tmpmenustr!=null||!"".equals(tmpmenustr)){
						List tmpmenus = Util.TokenizerString(tmpmenustr, ",");
						if(tmpmenus!=null&&tmpmenus.size()>0){
							String tmpmenu1 = "";
							String tmpmenu2 = "";
							if(tmpmenus.size()>=1) tmpmenu1 =(String) tmpmenus.get(0);
							if(tmpmenus.size()>=2) tmpmenu2 =(String) tmpmenus.get(1);
							if(tmpmenu1!=null&&"0".equals(tmpmenu1)) {
								if(i==0) {//提交
									submitName="";
								} else if(i==1) {//提交不需反馈
									subnobackName="";
								} else if(i==2) {//提交需反馈
									subbackName="";
								} else if(i==3) {//转发
									forwardName="";
								} else if(i==4) {//退回
									rejectName="";
								} else if(i==5) {//保存
								}
							} else if(tmpmenu1!=null&&"1".equals(tmpmenu1)) {
								if(i==0) {//提交
									submitName=tmpmenu2;
								} else if(i==1) {//提交不需反馈
									subnobackName=tmpmenu2;
								} else if(i==2) {//提交需反馈
									subbackName=tmpmenu2;
								} else if(i==3) {//转发
									forwardName=tmpmenu2;
								} else if(i==4) {//退回
									rejectName=tmpmenu2;
								} else if(i==5) {//保存
								}
							} else {
								getsuccess = false;
								writeLog("error:requestService.getRightMenu("+requestid+","+user.getUID()+","+Util.getIntValue(user.getLogintype(),0)+","+user.getLanguage()+"):"+menu);
								System.out.println("error:requestService.getRightMenu("+requestid+","+user.getUID()+","+Util.getIntValue(user.getLogintype(),0)+","+user.getLanguage()+"):"+menu);
							}
						}
					}
				}			
			}

			if(getsuccess) {
				result.put("submitName", submitName);
				result.put("subnobackName", subnobackName);
				result.put("subbackName", subbackName);
				result.put("rejectName", rejectName);
				result.put("forwardName",forwardName);
			}
		} catch(Exception e) {
			writeLog(e);
			e.printStackTrace();
		}
		if(result.size()==0){
			result = getCustomeButtonMenu(workflowid, nodeid, requestid, isremark, user, nodetype);
		}
		return result;
	}
	
	private String[][] getWorkflowPhrases(User user) {
		String[][] phraseList = null;
		
		try {
			RecordSet rs = new RecordSet();
			List phrases = new ArrayList();
			rs.executeSql("select phraseShort,phraseDesc from sysPhrase where hrmid ="+user.getUID()+" order by id ");
		    while(rs.next()){
		    	String[] phrase = new String[2];
		    	phrase[0] = rs.getString("phraseShort");
		    	phrase[1] = rs.getString("phraseDesc");
		    	phrases.add(phrase);
		    }
		    
		    if (phrases.size() > 0) {
		    	phraseList = new String[phrases.size()][2];
				for(int i=0;i<phrases.size();i++) {
					phraseList[i] = (String[]) phrases.get(i);
				}
		    }		    
		} catch (Exception e) {
			writeLog(e);
			e.printStackTrace();
		}
	    
		return phraseList;
	}
	
	/**
	 * 将签字意见信息更新到流程的最新签字意见信息中
	 * @param requestid
	 * @param userid
	 */
	public void updateWorkflowLog(String requestid, String log){
		BaseBean bb = new BaseBean();
		bb.writeLog("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
		RecordSet rs = new RecordSet();
		rs.executeSql("select LOGID from workflow_requestlog where requestid="+requestid+" order by LOGID desc");
		bb.writeLog("select LOGID from workflow_requestlog where requestid="+requestid+" order by LOGID desc");
		if(rs.next()){
			String logid = rs.getString("LOGID");
			rs.executeSql(" update workflow_requestlog set remark='"+log+"' where LOGID= "+logid);
			bb.writeLog(" update workflow_requestlog set remark='"+log+"' where LOGID= "+logid);
		}
	}
	
	public void updateOaHrpkcode(String oaHrmId, String nkHrmId){
		RecordSet rs = new RecordSet();
		rs.executeSql("update HrmResource set hrpkcode='"+nkHrmId+"' where id='"+oaHrmId+"'");
	}
	public void updateOaDeptpkcode(String oaDeptId, String nkDeptId){
		RecordSet rs = new RecordSet();
		rs.executeSql("update HrmDepartment set hrpkcode='"+nkDeptId+"' where id='"+oaDeptId+"'");
	}
	public void updateOaSubCompkcode(String oaSubComId,String nkSubComId){
		RecordSet rs = new RecordSet();
		rs.executeSql("update HrmSubCompany set hrpkcode='"+nkSubComId+"' where id='"+oaSubComId+"'");
	}
	public void updateOaJobTitlepkcode(String oaJobTitleId, String nkJobTitleId){
		RecordSet rs = new RecordSet();
		rs.executeSql("update Hrmjobtitles set hrpkcode='"+nkJobTitleId+"' where id='"+oaJobTitleId+"'");
	}

}

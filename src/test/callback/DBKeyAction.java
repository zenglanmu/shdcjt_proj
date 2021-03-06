package test.callback;

import java.util.Calendar;

import weaver.conn.RecordSet;
import weaver.createWorkflow.SAP.conn.SAPConnPool;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.request.RequestManager;

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;

/**
 * @Title: ContractApprovalAction.java
 * @Package weaver.createWorkflow.SAP.action
 * @Description: 招标申请审批反写SAP数据Action
 * @author JYY
 * @date 2016-8-1
 */

public class DBKeyAction implements Action
{
	private RequestManager requestManager;
	private BaseBean logBean = new BaseBean();
	private String requestName;

	public String getRequestName()
	{
		return requestName;
	}

	public void setRequestName(String requestName)
	{
		this.requestName = requestName;
	}

	Calendar today = Calendar.getInstance();
	String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2)
			+ "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

	@Override
	public String execute(RequestInfo request)
	{
		return executeDBKeyRollback(requestManager, logBean, request);
	}

	private String executeDBKeyRollback(RequestManager requestManager, BaseBean logBean, RequestInfo request)
	{
		RecordSet res = new RecordSet();
		this.requestManager = request.getRequestManager();
		String requestid = Util.null2String(request.getRequestid());
		logBean.writeLog("调用" + requestName + "的formid = " + requestManager.getFormid() + "||RequestId = " + requestid);
		String sql = "select tablename from workflow_bill where id ='" + requestManager.getFormid() + "'";
		logBean.writeLog("==================取主表表名===========" + sql);
		String tablename = "";
		res.executeSql(sql);
		if (res.next())
		{
			tablename = Util.null2String(res.getString("tablename"));
		}

		String errorMessage = "";
		// 传输给SAP数据
		String DBkey = "";
		String IV_APPSTATUS = "";

		// SAP返回信息
		String ET_RETYPE = "";
		String ET_REMESG = "";

		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		String getRemarkSQL = "select DB_KEY from " + tablename + "  where requestid = '" + requestid + "'";
		rs.executeSql(getRemarkSQL);
		logBean.writeLog("getRemarkSQL=" + getRemarkSQL);
		if (rs.next())
		{
			DBkey = Util.null2String(rs.getString("DB_KEY"));
			System.out.println("DB_KEY=" + DBkey);
		}

		// 获取SAP连接
		SAPConnPool SAPConn = new SAPConnPool();
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive())
		{
			logBean.writeLog("====== SAP connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); // 活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate(requestName);// 从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			// 获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();// 输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();// 输入表的处理
			IV_APPSTATUS = "04";
			logBean.writeLog("IV_APPSTATUS=" + IV_APPSTATUS);
			input.setValue(DBkey, "IV_DB_KEY");
			input.setValue(IV_APPSTATUS, "IV_APPSTATUS");
			myConnection.execute(function);// 执行函数
		} else
		{
			logBean.writeLog("======SAP connection fail======");
			errorMessage = "OA与SAP连接错误，请联系系统管理员";
		}

		if (!"".equals(errorMessage))
		{
			request.getRequestManager().setMessageid("10008011");
			request.getRequestManager().setMessagecontent(errorMessage);
		}

		SAPConn.releaseC(myConnection);
		return Action.SUCCESS;
	}

}

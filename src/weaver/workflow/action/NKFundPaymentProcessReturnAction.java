package weaver.workflow.action;

import nk.webservice.pay.PayServiceProxy;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.request.RequestManager;

/**
 * NK系统集成-资金支付流程--归档退回创建节点Action
 * @author Administrator
 *
 */
public class NKFundPaymentProcessReturnAction extends BaseBean implements Action {
	private RequestManager requestManager;
	private String WebServiceURL = getPropValue("NKFundpayment", "webServiceURL");
	private String HTBHFieldName = getPropValue("NKFundpayment", "HTBHFieldName");

	public String execute(RequestInfo request) {
		PayServiceProxy payService = new PayServiceProxy(WebServiceURL);
		int cid = 0;//合同编号 htbh
		
		RecordSet rs= new RecordSet();
		this.requestManager = request.getRequestManager();
		String requestid = Util.null2String(request.getRequestid());
		rs.writeLog("当前调用NKFundPaymentProcessReturnAction的表单ID = " + requestManager.getFormid() + "||RequestId = " + requestid);
		//获取主表表名
		String sql="select tablename from workflow_bill where id ='" + requestManager.getFormid() + "'";
		writeLog("获取主表表名==" + sql);
		String tablename="";
		rs.executeSql(sql);
		if(rs.next()){
			tablename = Util.null2String(rs.getString("tablename"));
		}
		
		try{
			sql="select " + HTBHFieldName + " from " + tablename + " where requestid = '" + requestid + "' ";
			writeLog("获取流程中的主表数据==" + sql);
			rs.executeSql(sql);
			if(rs.next()){
				cid = Util.getIntValue(rs.getString(HTBHFieldName),cid);
				writeLog("获取的合同编号=" + cid + "||流程ID=" + requestid);
			}
			if(cid > 0) {
				//和NK开发确认不需处理调用接口后的返回值
				payService.getResultFromOA(cid+"", false);
			} else {
				writeLog("资金支付-法务集成流程退回创建节点回写NK系统失败！合同编号获取失败");
				request.getRequestManager().setMessageid("10001002");
				request.getRequestManager().setMessagecontent("资金支付-法务集成流程退回创建节点回写NK系统失败！合同编号获取失败！请联系管理员！");
			}
		} catch(Exception e) {
			e.printStackTrace();
			writeLog("资金支付-法务集成流程退回创建节点回写NK系统失败！代码级异常");
			request.getRequestManager().setMessageid("10001001");
			request.getRequestManager().setMessagecontent("资金支付-法务集成流程退回创建节点回写NK系统失败！请联系管理员！");
		}
		return Action.SUCCESS;
	}
}

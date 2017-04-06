package weaver.createWorkflow.SAP.conn;

import weaver.general.BaseBean;

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;

/**
 * SAP连接池
 * @author Administrator
 *
 */
public class SAPConnPool extends BaseBean {
	private BaseBean logBean = new BaseBean();
	
	final static String POOL_NAME = "SAPPoolJYY";
	private static String sapclient = "";
	private static String userid = "";
	private static String password = "";
	private static String hostname = "";
	private static String systemnumber = "";
	private static String Language = "";
	private JCO.Pool pool = null;
	/*
	 * 初始化连接
	 */
	private void init() {
		try {
			sapclient = getPropValue("SAPConnPool", "sapclient");
			userid = getPropValue("SAPConnPool", "userid");
			password = getPropValue("SAPConnPool", "password");
			hostname = getPropValue("SAPConnPool", "hostname");
			systemnumber = getPropValue("SAPConnPool", "systemnumber");
			Language = getPropValue("SAPConnPool", "Language");
			pool = JCO.getClientPoolManager().getPool(POOL_NAME);
			logBean.writeLog("SAP连接池信息 = "+sapclient+"||"+userid+"||"+password+"||"+hostname);
			if (pool == null) {
				JCO.addClientPool(POOL_NAME, 20,sapclient, userid, password, Language, hostname,systemnumber);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/*
	 * 释放连接
	 */
	public void releaseC(JCO.Client Client) {
		if (Client != null){
			JCO.releaseClient(Client);
		}
	}
	/*
	 * 获取连接
	 */
	public JCO.Client getConnection() {
		//判断连接池是否为NULL
		if(pool==null){
			init();
		}
		JCO.Client Client = null; 
		try{ 
			Client = JCO.getClient(POOL_NAME);
		}catch(Exception e){
			e.printStackTrace();
		}
		return Client;
	}

	/*
	*执行Bapi
	*/
	public JCO.Function excuteBapi(String s) {
		SAPConnPool SAPConn = new SAPConnPool();
		JCO.Client sapconnection = SAPConn.getConnection();
		JCO.Repository mRepository;
		JCO.Function jcoFunction = null;
		if(sapconnection==null){
			return jcoFunction;
		}
		try {
			mRepository = new JCO.Repository("Repository", sapconnection);
			IFunctionTemplate ft = mRepository.getFunctionTemplate(s);
			jcoFunction = new JCO.Function(ft);
			SAPConn.releaseC(sapconnection);
			return jcoFunction;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			SAPConn.releaseC(sapconnection);
		}
	}
}

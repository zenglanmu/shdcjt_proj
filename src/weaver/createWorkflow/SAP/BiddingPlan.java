package weaver.createWorkflow.SAP;



import java.util.ArrayList;
import java.util.List;

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.createWorkflow.SAP.conn.SAPConnPool;
import weaver.general.BaseBean;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.interfaces.schedule.BaseCronJob;
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.DetailTableInfo;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.RequestService;
import weaver.soa.workflow.request.Row;

/**
 * 
 * @Title: BiddingPlan.java
 * @Package weaver.createWorkflow.SAP
 * @Description: 招标计划
 * @author JYY
 * @date 2016-7-28 下午5:14:14
 */
public class BiddingPlan extends  BaseCronJob{
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();
	
	public void execute(){
		List<String>  detialList = new ArrayList<String>();
		//SAPConnPool SAPConn = new SAPConnPool();
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			logBean.writeLog("======招标计划开始======");
			logBean.writeLog("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); //活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZPO_PLAN");//从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			//获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();//输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();//输入表的处理
			myConnection.execute(function);//执行函数
			ParameterList output = function.getExportParameterList();//输出参数和结构处理(未使用)
			ParameterList outputTable = function.getTableParameterList();// 输出表的处理
			Table out = outputTable.getTable("ET_PLAN_HEAD"); //head表
			Table outD = outputTable.getTable("ET_PLAN_ITEM");//明细表
			//主表字段
			String  POSID = "";
			String ZEMPLOYEE = "";
			
			
			
			//明细表字段
			String POSIDD = "";
			String ZZBJHH = "";
			String POST1 = "";
			String ZECCMC = "";
			String BUTXT = "";
			String ZZBNAME = "";
			String ZSFZC = "";
			String ZYDSP2 = "";
			String ZCBTYPE = "";
			String ZJHDATE = "";
			String EDATE = "";
			String ZCGGCL = "";
			String ZJLDW = "";
			String ZHBLX = "";
			String ZHTDATE = "";
			String UNAME = "";
			String ERDAT = "";
			String ZXGDATE = "";
			String ZBZ = "";
			String ZJHLX = "";
			//新生成流程的requestid
			String returnStr = "";
			int requestid =0;
			String tablename = "";
			if(out.getNumRows() > 0) {
				for (int i = 0; i < out.getNumRows(); i++) {
					out.setRow(i);
					POSID = out.getString("POSID");
					ZEMPLOYEE = out.getString("ZEMPLOYEE"); 
					
					//ZEMPLOYEE = "1494"; 中星测试
					//ZEMPLOYEE = "3123"; //集团本部
					returnStr = createWorkflow(POSID,ZEMPLOYEE);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0],0);
					tablename = str[1];
					logBean.writeLog("招标计划 new requestid =" +returnStr);
					if(outD.getNumRows()>0){
						for (int j = 0; j < outD.getNumRows(); j++) {
							outD.setRow(j);
							POSIDD = outD.getString("POSID");
							if(POSID.equals(POSIDD) ){
								ZZBJHH = outD.getString("ZZBJHH");
								POST1 = outD.getString("POST1");
								ZECCMC = outD.getString("ZECCMC");
								BUTXT = outD.getString("BUTXT");
								ZZBNAME = outD.getString("ZZBNAME");
								ZSFZC = outD.getString("ZSFZC");
								ZYDSP2 = outD.getString("ZYDSP2");
								ZCBTYPE = outD.getString("ZCBTYPE");
								ZJHDATE = outD.getString("ZJHDATE");
								EDATE = outD.getString("EDATE");
								ZCGGCL = outD.getString("ZCGGCL");
								ZJLDW = outD.getString("ZJLDW");
								ZHBLX = outD.getString("ZHBLX");
								ZHTDATE = outD.getString("ZHTDATE");
								UNAME = outD.getString("UNAME");
								ERDAT = outD.getString("ERDAT");
								ZXGDATE = outD.getString("ZXGDATE");
								ZBZ = outD.getString("ZBZ");
								ZJHLX = outD.getString("ZJHLX");
								
								String detialInfo = requestid+","+ZZBJHH+","+POST1+","+ZECCMC+","+BUTXT
												+","+ZZBNAME+","+ZSFZC+","+ZYDSP2+","+ZCBTYPE+","+ZJHDATE
												+","+EDATE+","+ZCGGCL+","+ZJLDW+","+ZHBLX+","+ZHTDATE
												+","+UNAME+","+ERDAT+","+ZXGDATE+","+ZBZ+","+POSIDD
												+","+ZJHLX;
								logBean.writeLog("OA明细表1数据信息 = "+detialInfo);
								detialList.add(detialInfo);
							}	
						}
					}

				}
			}
			SAPConn.releaseC(myConnection);
			RecordSet rs1 = new RecordSet();
			RecordSet rs = new RecordSet();
			for(int k=0;k<detialList.size();k++){
			String[] detialParam = detialList.get(k).split(",");
			//for(int n=0;n<detialParam.length;n++){
				//System.out.println("detialParam["+n+"]="+detialParam[n]);
			//}
			//获取主表id
				String sql = "select id from "+tablename+" where requestid = '"+detialParam[0]+"'";
				logBean.writeLog(sql);
				rs1.executeSql(sql);
				while(rs1.next()){
				String mainid = Util.null2String(rs1.getString("id"));
				System.out.println("mainid = "+mainid);
				String insertSQL = "insert into  "+tablename+"_dt1(" +
						"mainid,POSIDD,ZZBJHH,POST1,ZECCMC," +
						"BUTXT,ZZBNAME,ZSFZC,ZYDSP2,CCBTYPE," +
						"ZJHDATE,EDATE,ZCGGCL,ZJLDW,ZHBLX," +
						"ZHTDATE,UNAME,ERDAT,ZXGDATE,ZBZ,ZJHLX) " +
						"values ('"
						+mainid+"','"+detialParam[19]+"','"+detialParam[1]+"','"+detialParam[2]+"','"+detialParam[3]+
						"','"+detialParam[4]+"','"+detialParam[5]+"','"+detialParam[6]+"','"+detialParam[7]+"','"+detialParam[8]+
						"','"+detialParam[9]+"','"+detialParam[10]+"','"+detialParam[11]+"','"+detialParam[12]+"','"+detialParam[13]+
						"','"+detialParam[14]+"','"+detialParam[15]+"','"+detialParam[16]+"','"+detialParam[17]+"','"+detialParam[18]+
						"','"+detialParam[19]+
						"')";
				logBean.writeLog("插入明细表1SQL="+insertSQL);
				rs.executeSql(insertSQL);				
				}
			}
			logBean.writeLog("======招标计划结束======");
		}else{
			logBean.writeLog("SAP connection fail");
		}	
	}

/**
 * 
* @Title: createWorkflow
* @Description: TODO
* @param @param POSID
* @param @param ZEMPLOYEE
* @param @return    
* @return int    
* @throws
 */

	//public int createWorkflow(String POSID, String ZEMPLOYEE,String POSIDD,String ZZBJHH,String POST1,String ZECCMC,String BUTXT,String ZZBNAME,String ZSFZC,String ZYDSP2,String ZCBTYPE,String ZJHDATE,String EDATE,String ZCGGCL,String ZJLDW,String ZHBLX,String ZHTDATE,String UNAME,String ERDAT,String ZXGDATE,String ZBZ,int rowid ) {
	public String createWorkflow(String POSID, String ZEMPLOYEE){	
		String newRequestid = "-1000";
		String resourceid = ZEMPLOYEE;
		//String workflowid = "2663";
		BaseBean baseBean = new BaseBean();
		String TODAY = TimeUtil.getCurrentDateString();

		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		RecordSet rs3 = new RecordSet();

		String tablename="";
		String subcompanyid ="";
		String lastname = "";
		String workflowid ="";
		String description ="";
		String departmentid="";
		String subcompanyid_1 ="";
		rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
		rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
		while(rs.next()){
			subcompanyid_1 = Util.null2String(rs.getString("subcompanyid1"));
			lastname =  Util.null2String(rs.getString("lastname"));
			logBean.writeLog("当前公司id="+subcompanyid_1);
			String getSubCompantid = " select id from " +
					"(select  id,supsubcomid from hrmsubcompany hb " +
					"connect by prior hb.supsubcomid=hb.id " +
					"start with hb.id= (select subcompanyid1 from hrmresource where id ='"+ZEMPLOYEE+"' ) ) " +
					"where  supsubcomid=0";
			rs2.executeSql(getSubCompantid);
			rs2.writeLog("人员顶层公司id="+getSubCompantid);
			while(rs2.next()){
				subcompanyid = Util.null2String(rs2.getString("id"));
				rs2.writeLog("人员顶层公司id="+subcompanyid);
			}
			//=======add by jyy 20160819=========
			//================start=======================
			String getDepartmentidSQL = "select * from (select id,supdepid,departmentname from hrmdepartment hb "
										+"connect by prior hb.supdepid=hb.id "
										+"start with hb.id= (select departmentid from hrmresource where id ='"+ZEMPLOYEE+"'  ) ) "
										+"where  supdepid=0 ";
			rs3.writeLog("人员顶层部门="+getDepartmentidSQL);
			rs3.execute(getDepartmentidSQL);
			while(rs3.next()){
				departmentid = Util.null2String(rs3.getString("id"));
			}
			//================end========================================
		}
		if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGXING","subcompanyid"))){
			workflowid = baseBean.getPropValue("SAPZHONGXING","PlanWorkflowid");//中星招标计划流程的workflowid
			description = "中星集团招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
			logBean.writeLog("========zhongxing=====中星招标计划=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPBEITOU","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPBEITOU","PlanWorkflowid");//招标申请流程的workflowid
			 description = "北投招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============北投招标计划=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPSANLIN","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPSANLIN","PlanWorkflowid");//招标申请流程的workflowid
			 description = "三林招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============三林招标计划=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGHUA","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHONGHUA","PlanWorkflowid");//招标申请流程的workflowid
			 description = "中华招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============中华招标计划=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHUBAO","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHUBAO","PlanWorkflowid");//招标申请流程的workflowid
			 description = "住保招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============住保招标计划=================="+workflowid);
		}
//		else if(subcompanyid.equals(baseBean.getPropValue("SAPJTBB","subcompanyid"))){
//			 workflowid = baseBean.getPropValue("SAPJTBB","PlanWorkflowid");//招标申请流程的workflowid
//			 description = "集团本部招标计划"+"-"+lastname+"-"+TODAY.replace("-", "");
//			 logBean.writeLog("=============集团本部招标计划=================="+workflowid);
//		}
		
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where  wb.formid = wbi.id and wb.id = '"+workflowid+"'";
		rs1.executeSql(SQL);
		while(rs1.next()){
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		
		RequestService requestService = new RequestService();
		RequestInfo requestInfo = new RequestInfo();
		
		requestInfo.setWorkflowid(workflowid); 
		requestInfo.setCreatorid(resourceid);
		requestInfo.setDescription(description); 
		requestInfo.setRequestlevel("1"); 
		requestInfo.setIsNextFlow("1");
		requestInfo.setRemindtype("2");
		
		//主表数据
		MainTableInfo mainTableInfo = new MainTableInfo();
		List<Property> fields = new ArrayList<Property>();
		Property field = null;
		
		field = new Property();
		field.setName("POSID");
		field.setValue(POSID);
		fields.add(field);
		
		field = new Property();
		field.setName("ZEMPLOYEE");
		field.setValue(ZEMPLOYEE);
		fields.add(field);
		
		//===========start===========
		field = new Property();
		field.setName("SSGS");
		field.setValue(subcompanyid_1);
		fields.add(field);
		
		field = new Property();
		field.setName("SSBM");
		field.setValue(departmentid);
		fields.add(field);
		//=============end=========
		
		
		Property[] fieldarray = (Property[]) fields.toArray(new Property[fields.size()]);
		mainTableInfo.setProperty(fieldarray);
		requestInfo.setMainTableInfo(mainTableInfo);		
		try {
			newRequestid = requestService.createRequest(requestInfo);
			logBean.writeLog("============="+newRequestid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logBean.writeLog("插入失败！！！");
			e.printStackTrace();
		}
		return newRequestid+","+tablename;
	}
}

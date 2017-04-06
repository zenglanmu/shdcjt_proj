package weaver.createWorkflow.SAP;

import java.util.ArrayList;
import java.util.List;



import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;

import weaver.conn.RecordSet;
import weaver.createWorkflow.SAP.conn.SAPConnPool;
import weaver.general.BaseBean;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.interfaces.schedule.BaseCronJob;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.RequestService;

/**
 * 
 * @Title: BiddingFile.java
 * @Package weaver.createWorkflow.SAP
 * @Description: 招标文件
 * @author JYY
 * @date 2016-8-1 下午4:39:01
 */
public class BiddingFile extends  BaseCronJob{
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();

	
	public void execute(){
		
		List<String>  detialList = new ArrayList<String>();
		
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			logBean.writeLog("==========招标文件数据同步开始===========");
			logBean.writeLog("connect success !");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); //活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZPO_FILE");//从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			//获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();//输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();//输入表的处理	
			myConnection.execute(function);//执行函数
			
			ParameterList output = function.getExportParameterList();//输出参数和结构处理(未使用)
			ParameterList outputTable = function.getTableParameterList();// 输出表的处理
			Table out = outputTable.getTable("ET_FILE_HEAD");
			Table outD = outputTable.getTable("ET_FILE_ITEM");
			
			//System.out.println("out.getNumRows()==" + out.getNumRows());
			//System.out.println("outD.getNumRows()==" + outD.getNumRows());
			
			//主表字段
			String BANFN = "";
			String ZEMPLOYEE = "";
			
			//20160824 add by jyy 
			String ZJHLX = "";

			//明细表字段
			String	BANFND = "";
			String	ZFILE_NO = "";
			String	ZWJMC = "";
			String	ZFILE_PATH = "";
			String	UNAME = "";
			String	DATUM = "";
			String	ZBZ = "";//新增字段ZBZ 备注
			
			String WZLJ = ""; //a标签路径
			//新生成的requestid
			String returnStr = "";
			int requestid =0;
			String tablename = "";
			
			if(out.getNumRows() > 0) {
				for (int i = 0; i < out.getNumRows(); i++) {
					out.setRow(i);
					BANFN = out.getString("BANFN");
					ZEMPLOYEE = out.getString("ZEMPLOYEE"); 
					
					ZJHLX = out.getString("ZJHLX"); 
					ZBZ = out.getString("ZBZ"); 
					//ZEMPLOYEE = "25";
					//ZEMPLOYEE = "3110";
					returnStr = createWorkflow(BANFN,ZEMPLOYEE,ZJHLX,ZBZ);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0],0);
					tablename = str[1];
					logBean.writeLog("招标文件 new requestid =" +returnStr);
					//System.out.println("new requestid =" +requestid);
					if(outD.getNumRows()>0){
						for (int j = 0; j < outD.getNumRows(); j++) {
							outD.setRow(j);
							BANFND = outD.getString("BANFN");
							if(BANFND.equals(BANFN) ){
								//BANFND = outD.getString("BANFN");
								ZFILE_NO = outD.getString("ZFILE_NO");
								ZWJMC = outD.getString("ZWJMC");			//文件名称
								ZFILE_PATH = outD.getString("ZFILE_PATH");  //文件路径
								UNAME = outD.getString("UNAME");
								DATUM = outD.getString("DATUM");
								//ZWJMC+"||"+ZFILE_PATH 名称+路径
								WZLJ = "<a href="+ZFILE_PATH+">"+ZWJMC+"</a>";
								String detialInfo = requestid+","+BANFND+","+ZFILE_NO+","+ZWJMC+","+ZFILE_PATH
										+","+UNAME+","+DATUM+","+WZLJ;
								logBean.writeLog("OA明细表1数据  = "+detialInfo);
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
				//获取主表id
				String sql = "select id from "+tablename+" where requestid = '"+detialParam[0]+"'";
				logBean.writeLog(sql);
				rs1.executeSql(sql);
				while(rs1.next()){
				String mainid = Util.null2String(rs1.getString("id"));
				System.out.println("mainid = "+mainid);
				String insertSQL = "insert into "+tablename+"_dt1(" +
						"mainid,BANFN,ZFILE_NO,ZWJMC,ZFILE_PATH," +
						"UNAME,DATUM,WZLJ) " +
						"values ('"
						+mainid+"','"+detialParam[1]+"','"+detialParam[2]+"','"+detialParam[3]+"','"+detialParam[4]+
						"','"+detialParam[5]+"','"+detialParam[6]+"','"+detialParam[7]+
						"')";
				logBean.writeLog("insertSql="+insertSQL);
				rs.executeSql(insertSQL);				
				}
			}
			logBean.writeLog("==========招标文件数据同步结束===========");
		}else{
			logBean.writeLog("SAP connection fail");
		}
	}


	public String createWorkflow(String BANFN, String ZEMPLOYEE,String ZJHLX,String ZBZ){	
		String newRequestid = "-1000";
		String resourceid = ZEMPLOYEE;
		String TODAY = TimeUtil.getCurrentDateString();

		BaseBean baseBean = new BaseBean();
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();
		RecordSet rs2 = new RecordSet();
		RecordSet rs3 = new RecordSet();

		String lastname = "";
		String tablename="";
		String subcompanyid ="";
		String workflowid ="";
		String description ="";
		String subcompanyid_1 = "";
		String departmentid ="";
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
			workflowid = baseBean.getPropValue("SAPZHONGXING","FileWorkflowid");//中星招标文件流程的workflowid
			description = "中星集团招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
			logBean.writeLog("=============中星招标文件=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPBEITOU","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPBEITOU","FileWorkflowid");//招标文件流程的workflowid
			 description = "北投招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============北投招标文件=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPSANLIN","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPSANLIN","FileWorkflowid");//招标文件流程的workflowid
			 description = "三林招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============三林招标文件=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGHUA","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHONGHUA","FileWorkflowid");//招标文件流程的workflowid
			 description = "中华招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============中华招标文件=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHUBAO","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHUBAO","FileWorkflowid");//招标文件流程的workflowid
			 description = "住保招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
			 logBean.writeLog("=============住保招标文件=================="+workflowid);
		}
//		else if(subcompanyid.equals(baseBean.getPropValue("SAPJTBB","subcompanyid"))){
//			 workflowid = baseBean.getPropValue("SAPJTBB","FileWorkflowid");//招标文件流程的workflowid
//			 description = "集团本部招标文件"+"-"+lastname+"-"+TODAY.replace("-", "");
//			 logBean.writeLog("=============集团本部招标文件=================="+workflowid);
//		}
//		
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where  wb.formid = wbi.id and wb.id = '"+workflowid+"'";
		rs1.executeSql(SQL);
		while(rs1.next()){
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		//String workflowid = "2665"; //招标文件流程workflowid
		
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
		field.setName("BANFN");
		field.setValue(BANFN);
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
		
		//add by jyy 20160824
		field = new Property();
		field.setName("ZJHLX");
		field.setValue(ZJHLX);
		fields.add(field);
		
		field = new Property();
		field.setName("ZBZ");
		field.setValue(ZBZ);
		fields.add(field);
		
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

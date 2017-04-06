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
import weaver.workflow.request.RequestManager;

/**
 * 
 * @Title: BiddingResult.java
 * @Package weaver.createWorkflow.SAP
 * @Description: 招标结果
 * @author JYY
 * @date 2016-8-3 下午12:43:44
 */
public class BiddingResult extends  BaseCronJob{
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();
	
	public void execute(){
		List<String> dt1List = new ArrayList<String>();
		List<String> dt2List = new ArrayList<String>();
		List<String> dt3List = new ArrayList<String>();


		//SAPConnPool SAPConn = new SAPConnPool();
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			logBean.writeLog("======招标结果数据同步开始======");
			logBean.writeLog("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); //活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZPO_RESULT");//从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			//获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();//输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();//输入表的处理
			myConnection.execute(function);//执行函数
			ParameterList output = function.getExportParameterList();//输出参数和结构处理(未使用)
			ParameterList outputTable = function.getTableParameterList();// 输出表的处理
			Table out = outputTable.getTable("ET_PO_RESULT"); //head表
			Table outD_1 = outputTable.getTable("ET_ZD");//明细表ET_ZD
			Table outD_2 = outputTable.getTable("ET_ZCBPBJ");//明细表ET_ZCBPBJ
			Table outD_3 = outputTable.getTable("ET_FILE");//明细表ET_FILE
			//主表字段
			String	BANFN = "";
			String	ZZBNAME = "";
			String	ZHBLX = "";
			String	NAME1 = "";
			String	ZZHBJ = "";
			String	ZZBDATE = "";
			String	ZEMPLOYEE = "";
			String  ZBZ = "";

			//明细表ET_ZD字段
			String	BANFN_1 = "";
			String	ZITEM_1 = "";
			String	ZZBNAME_1 = "";
			String	ZYDSP2_1 = "";
			String	ZYDSP3_1 = "";
			String	ZCGGCL_1 = "";
			String	ZJLDW_1 = "";
			String	ZHBLX_1 = "";
			String	ZBZ_1 = "";
			
			//明细表ET_ZCBPBJ字段
			String	BANFN_2 = "";
			String ZBPBJ_2 = "";
			String ZYDSP2_2 = "";
			String ZYDSP3_2 = "";
			String ZCGGCL_2 = "";
			String ZJLDW_2 = "";
			String ZHBLX_2 = "";
			String ZPPSP4_2 = "";
			String ZBZ_2 = "";
			
			//明细表ET_FILE字段
			String	BANFN_3 = "";
			String	ZFILE_NO_3 = "";
			String	ZWJMC_3 = "";
			String	ZFILE_PATH_3 = "";
			String	UNAME_3 = "";
			String	DATUM_3= "";
			String  WZLJ = "";
			//新生成的requestid
			String returnStr = "";
			int requestid =0;
			String tablename = "";
			
			if(out.getNumRows() > 0) {
				for (int i = 0; i < out.getNumRows(); i++) {
					out.setRow(i);
					BANFN = out.getString("BANFN");
					ZZBNAME = out.getString("ZZBNAME");
					ZHBLX = out.getString("ZHBLX");
					NAME1 = out.getString("NAME1");
					ZZHBJ = out.getString("ZZHBJ");
					ZZBDATE = out.getString("ZZBDATE");
					ZEMPLOYEE = out.getString("ZEMPLOYEE");
					ZBZ = out.getString("ZBZ");
					//ZEMPLOYEE = "3110";
					returnStr = createWorkflow(BANFN,ZZBNAME,ZHBLX,NAME1,ZZHBJ,ZZBDATE,ZEMPLOYEE,ZBZ);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0],0);
					tablename = str[1];
					logBean.writeLog("new requestid =" +returnStr);
					
					//System.out.println("new requestid =" +requestid);
					
					//明细表ET_ZD循环
					if(outD_1.getNumRows()>0){
						for (int j = 0; j < outD_1.getNumRows(); j++) {
							outD_1.setRow(j);
							BANFN_1 = outD_1.getString("BANFN");
							if(BANFN.equals(BANFN_1) ){
								//BANFN_1= outD_1.getString("BANFN");
								ZITEM_1=outD_1.getString("ZITEM");
								ZZBNAME_1=outD_1.getString("ZZBNAME");
								ZYDSP2_1=outD_1.getString("ZYDSP2");
								ZYDSP3_1=outD_1.getString("ZYDSP3");
								ZCGGCL_1=outD_1.getString("ZCGGCL");
								ZJLDW_1=outD_1.getString("ZJLDW");
								ZHBLX_1=outD_1.getString("ZHBLX");
								ZBZ_1=outD_1.getString("ZBZ");
								String detialInfo = requestid+","+BANFN_1+","+ZITEM_1+","+ZZBNAME_1+","+ZYDSP2_1
										+","+ZYDSP3_1+","+ZCGGCL_1+","+ZJLDW_1+","+ZHBLX_1+","+ZBZ_1;
								logBean.writeLog("detialInfo = "+detialInfo);
								dt1List.add(detialInfo);
							}
						}
					}
					
					//明细表ET_ZCBPBJ循环
					if(outD_2.getNumRows()>0){
						for (int j = 0; j < outD_2.getNumRows(); j++) {
							outD_2.setRow(j);
							BANFN_2 = outD_2.getString("BANFN");
							if(BANFN.equals(BANFN_2) ){
								//BANFN_2 = outD_2.getString("BANFN");
								ZBPBJ_2 = outD_2.getString("ZBPBJ");
								ZYDSP2_2 = outD_2.getString("ZYDSP2");
								ZYDSP3_2 = outD_2.getString("ZYDSP3");
								ZCGGCL_2 = outD_2.getString("ZCGGCL");
								ZJLDW_2 = outD_2.getString("ZJLDW");
								ZHBLX_2 = outD_2.getString("ZHBLX");
								ZPPSP4_2 = outD_2.getString("ZPPSP4");
								ZBZ_2 = outD_2.getString("ZBZ");
								String detialInfo_2 = requestid+","+BANFN_2+","+ZBPBJ_2+","+ZYDSP2_2+","+ZYDSP3_2
										+","+ZCGGCL_2+","+ZJLDW_2+","+ZHBLX_2+","+ZPPSP4_2+","+ZBZ_2;
								logBean.writeLog("detialInfo = "+detialInfo_2);
								dt2List.add(detialInfo_2);
							}
						}
					}
					//明细表ET_FILE字段循环
					if(outD_3.getNumRows()>0){
						for (int j = 0; j < outD_3.getNumRows(); j++) {
							outD_3.setRow(j);
							BANFN_3 = outD_3.getString("BANFN");
							if(BANFN.equals(BANFN_3) ){
								//BANFN_3 = outD_3.getString("BANFN");
								ZFILE_NO_3 = outD_3.getString("ZFILE_NO");
								ZWJMC_3 = outD_3.getString("ZWJMC");
								ZFILE_PATH_3 = outD_3.getString("ZFILE_PATH");
								UNAME_3 = outD_3.getString("UNAME");
								DATUM_3 = outD_3.getString("DATUM");
								WZLJ= "<a href="+ZFILE_PATH_3+">"+ZWJMC_3+"</a>";
								String detialInfo_3 = requestid+","+BANFN_3+","+ZFILE_NO_3+","+ZWJMC_3+","+ZFILE_PATH_3
										+","+UNAME_3+","+DATUM_3+","+WZLJ;
								logBean.writeLog("detialInfo = "+detialInfo_3);
								dt3List.add(detialInfo_3);
							}
						}
					}
				}
			}
					SAPConn.releaseC(myConnection);
					
					RecordSet rs = new RecordSet();
					RecordSet rs1 = new RecordSet();
					RecordSet rs2 = new RecordSet();
					RecordSet rs3= new RecordSet();
					RecordSet rs4 = new RecordSet();
					RecordSet rs5= new RecordSet();		
					//写入OA明细表1
					if(dt1List.size()>0){
						for(int m=0;m<dt1List.size();m++){
						String[] dt1Param = dt1List.get(m).split(",",-1);
//						for(int n=0;n<dt1Param.length;n++){
//							System.out.println("detialParam["+n+"]="+dt1Param[n]);
//						}
							//获取主表id
							String sql = "select id from "+tablename+" where requestid = '"+dt1Param[0]+"'";
							logBean.writeLog(sql);
							rs.executeSql(sql);
							while(rs.next()){
								String mainid = Util.null2String(rs.getString("id"));
								//System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt1(" +
										"mainid,BANFN,ZITEM,ZZBNAME,ZYDSP2," +
										"ZYDSP3,ZCGGCL,ZJLDW,ZHBLX,ZBZ) " +
										"values ('"
										+mainid+"','"+dt1Param[1]+"','"+dt1Param[2]+"','"+dt1Param[3]+"','"+dt1Param[4]
										+"','"+dt1Param[5]+"','"+dt1Param[6]+"','"+dt1Param[7]+"','"+dt1Param[8]+"','"+dt1Param[9]+
										"')";
								logBean.writeLog("写入OA明细表1数据="+insertSQL);
								rs1.executeSql(insertSQL);		
								}
						}
					}
					
					//写入OA明细表2
					if(dt2List.size()>0){
						for(int n=0;n<dt2List.size();n++){
						String[] dt2Param = dt2List.get(n).split(",",-1);
//						for(int n=0;n<dt2Param.length;n++){
//							System.out.println("detialParam["+n+"]="+dt2Param[n]);
//						}
							//获取主表id
							String sql = "select id from "+tablename+" where requestid = '"+dt2Param[0]+"'";
							logBean.writeLog(sql);
							rs2.executeSql(sql);
							while(rs2.next()){
								String mainid = Util.null2String(rs2.getString("id"));
								//System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt2(" +
										"mainid,BANFN,ZBPBJ,ZYDSP2,ZYDSP3," +
										"ZCGGCL,ZJLDW,ZHBLX,ZPPSP4,ZBZ) " +
										"values ('"
										+mainid+"','"+dt2Param[1]+"','"+dt2Param[2]+"','"+dt2Param[3]+"','"+dt2Param[4]
										+"','"+dt2Param[5]+"','"+dt2Param[6]+"','"+dt2Param[7]+"','"+dt2Param[8]+"','"+dt2Param[9]+
										"')";
								logBean.writeLog("写入OA明细表2数据="+insertSQL);
								rs3.executeSql(insertSQL);		
								}
						}
					}
					
					//写入OA明细表3
					if(dt3List.size()>0){
						for(int l=0;l<dt3List.size();l++){
						String[] dt3Param = dt3List.get(l).split(",");
//						for(int n=0;n<dt3Param.length;n++){
//							System.out.println("detialParam["+n+"]="+dt3Param[n]);
//						}
							//获取主表id
							String sql = "select id from "+tablename+" where requestid = '"+dt3Param[0]+"'";
							logBean.writeLog(sql);
							rs4.executeSql(sql);
							while(rs4.next()){
								String mainid = Util.null2String(rs4.getString("id"));
								//System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt3(" +
										"mainid,BANFN,ZFILE_NO,ZWJMC,ZFILE_PATH," +
										"UNAME,DATUM,WZLJ) " +
										"values ('"
										+mainid+"','"+dt3Param[1]+"','"+dt3Param[2]+"','"+dt3Param[3]+"','"+dt3Param[4]
										+"','"+dt3Param[5]+"','"+dt3Param[6]+"','"+dt3Param[7]+
										"')";
								logBean.writeLog("写入OA明细表数据3="+insertSQL);
								rs5.executeSql(insertSQL);		
								}
						}
					}	
		}else{
			logBean.writeLog("SAP connection fail");
		}
	}


	private String createWorkflow(String BANFN, String ZZBNAME, String ZHBLX,
			String NAME1, String ZZHBJ, String ZZBDATE, String ZEMPLOYEE, String ZBZ) {
					String newRequestid = "-1000";
					String resourceid = ZEMPLOYEE;
					String TODAY = TimeUtil.getCurrentDateString();

					BaseBean baseBean = new BaseBean();
					RecordSet rs = new RecordSet();
					RecordSet rs1 = new RecordSet();
					RecordSet rs2 = new RecordSet();
					RecordSet rs3 = new RecordSet();
					
					String tablename="";
					String subcompanyid ="";
					String lastname = "";
					String workflowid ="";
					String description ="";
					String subcompanyid_1="";
					String departmentid="";
					rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
					rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
					while(rs.next()){
						subcompanyid_1 = Util.null2String(rs.getString("subcompanyid1"));
						lastname = Util.null2String(rs.getString("lastname"));
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
						workflowid = baseBean.getPropValue("SAPZHONGXING","ResultWorkflowid");//中星招标结果流程的workflowid
						description = "中星集团招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
						logBean.writeLog("=============中星招标结果=================="+workflowid);
					}else if(subcompanyid.equals(baseBean.getPropValue("SAPBEITOU","subcompanyid"))){
						 workflowid = baseBean.getPropValue("SAPBEITOU","ResultWorkflowid");//招标结果流程的workflowid
						 description = "北投招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
						 logBean.writeLog("=============北投招标结果=================="+workflowid);
					}else if(subcompanyid.equals(baseBean.getPropValue("SAPSANLIN","subcompanyid"))){
						 workflowid = baseBean.getPropValue("SAPSANLIN","ResultWorkflowid");//招标结果流程的workflowid
						 description = "三林招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
						 logBean.writeLog("=============三林招标结果=================="+workflowid);
					}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGHUA","subcompanyid"))){
						 workflowid = baseBean.getPropValue("SAPZHONGHUA","ResultWorkflowid");//招标结果流程的workflowid
						 description = "中华招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
						 logBean.writeLog("=============中华招标结果=================="+workflowid);
					}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHUBAO","subcompanyid"))){
						 workflowid = baseBean.getPropValue("SAPZHUBAO","ResultWorkflowid");//招标结果流程的workflowid
						 description = "住保招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
						 logBean.writeLog("=============住保招标结果=================="+workflowid);
					}
//					else if(subcompanyid.equals(baseBean.getPropValue("SAPJTBB","subcompanyid"))){
//						 workflowid = baseBean.getPropValue("SAPJTBB","ResultWorkflowid");//招标结果流程的workflowid
//						 description = "集团本部招标结果"+"-"+lastname+"-"+TODAY.replace("-", "");
//						 logBean.writeLog("=============集团本部招标结果=================="+workflowid);
//					}
					
					String SQL = "select tablename from workflow_base wb,workflow_bill wbi where  wb.formid = wbi.id and wb.id = '"+workflowid+"'";
					rs1.executeSql(SQL);
					while(rs1.next()){
						tablename = Util.null2String(rs1.getString("tablename"));
					}
					//String workflowid = "2666";//招标申请流程的workflowid
			
					RequestService requestService = new RequestService();
					RequestInfo requestInfo = new RequestInfo();
					
					requestInfo.setWorkflowid(workflowid); 
					requestInfo.setCreatorid(resourceid);
					requestInfo.setDescription(description); 
					requestInfo.setRequestlevel("1"); 
					requestInfo.setIsNextFlow("1");
					requestInfo.setRemindtype("2");
					
					//主表信息
					MainTableInfo mainTableInfo = new MainTableInfo();
					List<Property> fields = new ArrayList<Property>();
					Property field = null;
					
					field = new Property();
					field.setName("BANFN");
					field.setValue(BANFN);
					fields.add(field);
					
					field = new Property();
					field.setName("ZZBNAME");
					field.setValue(ZZBNAME);
					fields.add(field);
					
					field = new Property();
					field.setName("ZHBLX");
					field.setValue(ZHBLX);
					fields.add(field);
					
					field = new Property();
					field.setName("NAME1");
					field.setValue(NAME1);
					fields.add(field);
					
					field = new Property();
					field.setName("ZZHBJ");
					field.setValue(ZZHBJ);
					fields.add(field);
					
					field = new Property();
					field.setName("ZZBDATE");
					field.setValue(ZZBDATE);
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

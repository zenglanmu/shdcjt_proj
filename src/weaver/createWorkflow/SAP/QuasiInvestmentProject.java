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
 * @Title: QuasiInvestmentProject.java
 * @Package weaver.createWorkflow.SAP
 * @Description: 拟投项目初审会签
 * @author JYY
 * @date 2016-8-3
 */
public class QuasiInvestmentProject extends  BaseCronJob{
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();
	@Override
	public void execute() {
		
		List<String> dt1List = new ArrayList<String>();
		List<String> dt2List = new ArrayList<String>();
		List<String> dt3List = new ArrayList<String>();
		logBean.writeLog("==================拟投项目初审会签开始==========================");
		//SAPConnPool SAPConn = new SAPConnPool();
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			logBean.writeLog("connect success !");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); //活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZNT_CHUS");//从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			//获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();//输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();//输入表的处理	
			myConnection.execute(function);//执行函数
			ParameterList output = function.getExportParameterList();//输出参数和结构处理(未使用)
			ParameterList outputTable = function.getTableParameterList();// 输出表的处理
			Table out = outputTable.getTable("ET_NT_H");
			Table outD_1 = outputTable.getTable("ET_NT_TD");
			Table outD_2 = outputTable.getTable("ET_NT_TD_I");
			Table outD_3 = outputTable.getTable("ET_NT_FILES");
			//System.out.println("out.getNumRows()==" + out.getNumRows());
			//System.out.println("outD_1.getNumRows()==" + outD_1.getNumRows());
			//System.out.println("outD_2.getNumRows()==" + outD_2.getNumRows());

			//表ZNT_TO_OA_H字段
				String	ZNTXMBH = "";
				String	ZYT = "";
				String	ZBL = "";
				String	ZNBSYL = "";
				String	ZNHSYL = "";
				String	ZXJLHZZQ = "";
				String	ZXSMLL = "";
				String	ZSQR = "";
				String	ZXMMC = "";
				String	ZXMLX = "";
				String	ZJRMJ = "";
				String	ZZJZMJ = "";
				String	ZKFZQ = "";
				String	ZJYMS = "";
				String	ZSSZZ = "";
				String	ZXMGS = "";
				String	ZGSJZC = "";
				String	ZZTZ = "";
				String	ZQYTZJE = "";
				String	ZWFTZZB = "";
				String	ZXMSZD = "";
				String	ZHZF = "";
				String	ZHZHBMC = "";
				String	ZHZFTZB = "";
				String	ZXMJJ = "";
				String	ZSBGSSM = "";
				String	ZJLBZJZ = "";
				//20160805后加字段
				String	ZYT1 = "";
				String	ZBL1 = "";
				String	ZNBSYL1 = "";
				String	ZNHSYL1 = "";
				String	ZXJLHZZQ1 = "";
				String	ZXSMLL1 = "";
				String  ZJXRZJE =""; 
				
				
			//明细表ZNT_TO_OA_TD字段
				String	ZNTXMBH_1 = "";
				String ZTDXTBH_1 = "";
				String ZDKMC_1 = "";
				String ZDKLB_1 = "";
				String ZZDH_1 = "";
				String ZDKZT_1 = "";
				String ZHQFS_1 = "";
				String ZSSZZ_1 = "";
				String BLAND_1 = "";
				String ZSZFW_1 = "";
			
			//明细表ZNT_TO_OA_TD字段
				String ZTDXTBH_2 = "";
				String ZTDYTHXM_2 = "";
				String ZTDYTBM_2 = "";
				String ZCRMJ_2 = "";
				String ZRJL_2 = "";
				String ZJZMD_2 = "";
				String ZLHL_2 = "";
				String ZSYNX_2 = "";
			
			//明细表ET_NT_FILES字段
				String	ZNTXMBH_3 = "";
				String	ZFILE_NO_3 = "";
				String	ZWJMC_3 = "";
				String	ZFILE_PATH_3 = "";
				String	UNAME_3 = "";
				String	DATUM_3 = "";
				String  WZLJ = "";
					
			//新建流程的requestid
				String returnStr = "";
				int requestid =0;
				String tablename = "";
			
			if(out.getNumRows() > 0) {
				for (int i = 0; i < out.getNumRows(); i++) {
					int count_1 = 0;
					int count_2 = 0;
					out.setRow(i);
					ZNTXMBH = out.getString("ZNTXMBH"); //拟投项目编号
					//System.out.println("main ZNTXMBH = "+ZNTXMBH);
					//ZNTXMBH = out.getString("ZNTXMBH");
					ZYT = out.getString("ZYT");
					ZBL = out.getString("ZBL");
					ZNBSYL = out.getString("ZNBSYL");
					ZNHSYL = out.getString("ZNHSYL");
					ZXJLHZZQ = out.getString("ZXJLHZZQ");
					ZXSMLL = out.getString("ZXSMLL");
					ZSQR = out.getString("ZSQR");
					//ZSQR = "25";
					ZXMMC = out.getString("ZXMMC");
					ZXMLX = out.getString("ZXMLX");
					ZJRMJ = out.getString("ZJRMJ");
					ZZJZMJ = out.getString("ZZJZMJ");
					ZKFZQ = out.getString("ZKFZQ");
					ZJYMS = out.getString("ZJYMS");
					ZSSZZ = out.getString("ZSSZZ");
					ZXMGS = out.getString("ZXMGS");
					ZGSJZC = out.getString("ZGSJZC");
					ZZTZ = out.getString("ZZTZ");
					ZQYTZJE = out.getString("ZQYTZJE");
					ZWFTZZB = out.getString("ZWFTZZB");
					ZXMSZD = out.getString("ZXMSZD");
					ZHZF = out.getString("ZHZF");
					ZHZHBMC = out.getString("ZHZHBMC");
					ZHZFTZB = out.getString("ZHZFTZB");
					ZXMJJ = out.getString("ZXMJJ");
					ZSBGSSM = out.getString("ZSBGSSM");
					ZJLBZJZ = out.getString("ZJLBZJZ");
					
					ZYT1 = out.getString("ZYT1");
					ZBL1 = out.getString("ZBL1");
					ZNBSYL1 = out.getString("ZNBSYL1");
					ZNHSYL1 = out.getString("ZNHSYL1");
					ZXJLHZZQ1 = out.getString("ZXJLHZZQ1");
					ZXSMLL1 = out.getString("ZXSMLL1");
					ZJXRZJE = out.getString("ZJXRZJE");
					
					returnStr = createWorkflow(ZNTXMBH,ZYT,ZBL,ZNBSYL,ZNHSYL,
							ZXJLHZZQ,ZXSMLL,ZSQR,ZXMMC,ZXMLX,
							ZJRMJ,ZZJZMJ,ZKFZQ,ZJYMS,ZSSZZ,
							ZXMGS,ZGSJZC,ZZTZ,ZQYTZJE,ZWFTZZB,
							ZXMSZD,ZHZF,ZHZHBMC,ZHZFTZB,ZXMJJ,
							ZSBGSSM,ZJLBZJZ,ZYT1,ZBL1,ZNBSYL1,
							ZNHSYL1,ZXJLHZZQ1,ZXSMLL1,ZJXRZJE);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0],0);
					tablename = str[1];
					System.out.println("new requestid =" +returnStr+"||"+tablename);
					//System.out.println("newrequestid = "+requestid);
					//明细表ZNT_TO_OA_TD字段循环 通过拟投项目编号关联
				if(outD_1.getNumRows()>0){
					for (int j = 0; j < outD_1.getNumRows(); j++) {
						outD_1.setRow(j);
						ZNTXMBH_1 = outD_1.getString("ZNTXMBH");
						if(ZNTXMBH_1.equals(ZNTXMBH) ){
							++count_1;
							//ZNTXMBH_1=outD_1.getString("ZNTXMBH");
							ZTDXTBH_1=outD_1.getString("ZTDXTBH");  //土地系统编号
							ZDKMC_1=outD_1.getString("ZDKMC");
							ZDKLB_1=outD_1.getString("ZDKLB");
							ZZDH_1=outD_1.getString("ZZDH");
							ZDKZT_1=outD_1.getString("ZDKZT");
							ZHQFS_1=outD_1.getString("ZHQFS");
							ZSSZZ_1=outD_1.getString("ZSSZZ");
							BLAND_1=outD_1.getString("BLAND");
							ZSZFW_1=outD_1.getString("ZSZFW");
							//System.out.println(ZNTXMBH_1+"||DETIAL_1 POSID = "+ZTDXTBH_1+"||"+ZDKMC_1+"||"+ZDKLB_1+"||"+ZZDH_1+
									//"||"+ZDKZT_1+"||"+ZHQFS_1+"||"+ZSSZZ_1+"||"+BLAND_1+"||"+ZSZFW_1+"||"+count_1);
							String detialInfo = requestid+","+ZNTXMBH_1+","+ZTDXTBH_1+","+ZDKMC_1+","+ZDKLB_1
									+","+ZZDH_1+","+ZDKZT_1+","+ZHQFS_1+","+ZSSZZ_1+","+BLAND_1
									+","+ZSZFW_1;
							logBean.writeLog("detialInfo = "+detialInfo);
							dt1List.add(detialInfo);
							if(outD_2.getNumRows()>0){
								for (int m = 0; m < outD_2.getNumRows(); m++) {
									outD_2.setRow(m);
									ZTDXTBH_2=outD_2.getString("ZTDXTBH");  //土地系统编号
									if(ZTDXTBH_1.equals(ZTDXTBH_2) ){ //通过土地编号
										++count_2;
										//ZTDXTBH_2=outD_2.getString("ZTDXTBH");
										ZTDYTHXM_2=outD_2.getString("ZTDYTHXM");
										ZTDYTBM_2=outD_2.getString("ZTDYTBM");
										ZCRMJ_2=outD_2.getString("ZCRMJ");
										ZRJL_2=outD_2.getString("ZRJL");
										ZJZMD_2=outD_2.getString("ZJZMD");
										ZLHL_2=outD_2.getString("ZLHL");
										ZSYNX_2=outD_2.getString("ZSYNX");
										logBean.writeLog(ZTDXTBH_1+"====明细表2==== "+ZTDXTBH_2+"||"+ZTDYTBM_2+"||"+ZCRMJ_2+"||"+ZRJL_2+
												"||"+ZJZMD_2+"||"+ZLHL_2+"||"+ZSYNX_2+count_2);
										String detialInfo_2 = requestid+","+ZTDXTBH_2+","+ZTDYTHXM_2+","+ZTDYTBM_2+","+ZCRMJ_2
												+","+ZRJL_2+","+ZJZMD_2+","+ZLHL_2+","+ZSYNX_2;
										logBean.writeLog("detialInfo_2 = "+detialInfo_2);
										dt2List.add(detialInfo_2);
									}
								}
							}
								
						}
					}
				}
				//明细表ET_NT_FILES字段循环 通过拟投项目编号关联
				if(outD_3.getNumRows()>0){
					for (int n = 0; n < outD_3.getNumRows(); n++) {
						outD_3.setRow(n);
						ZNTXMBH_3 = outD_3.getString("ZNTXMBH"); //拟投项目编号
						if(ZNTXMBH_3.equals(ZNTXMBH) ){
							//ZNTXMBH = outD_3.getString("ZNTXMBH");
							ZFILE_NO_3 = outD_3.getString("ZFILE_NO");
							ZWJMC_3 = outD_3.getString("ZWJMC");
							ZFILE_PATH_3 = outD_3.getString("ZFILE_PATH");
							UNAME_3 = outD_3.getString("UNAME");
							DATUM_3 = outD_3.getString("DATUM");
							WZLJ = "<a href="+ZFILE_PATH_3+">"+ZWJMC_3+"</a>";
							//"||"+ZDKZT_1+"||"+ZHQFS_1+"||"+ZSSZZ_1+"||"+BLAND_1+"||"+ZSZFW_1+"||"+count_1);
							String detialInfo = requestid+","+ZNTXMBH_3+","+ZFILE_NO_3+","+ZWJMC_3+","+ZFILE_PATH_3
									+","+UNAME_3+","+DATUM_3+","+WZLJ;
							logBean.writeLog("detialInfo = "+detialInfo);
							dt3List.add(detialInfo);
						}
					}
					
				}
			}
		}
	
				SAPConn.releaseC(myConnection);
				RecordSet rs1 = new RecordSet();
				RecordSet rs = new RecordSet();
				RecordSet rs2 = new RecordSet();
				RecordSet rs3= new RecordSet();
				RecordSet rs4 = new RecordSet();
				RecordSet rs5= new RecordSet();
				String mainid ="";
				logBean.writeLog("======================对OA明细表处理 start ============= ");
				if(dt1List.size()>0){
					for(int m=0;m<dt1List.size();m++){
						String[] dt1Param = dt1List.get(m).split(",");
						//获取mainid
						String SQL ="select * from "+tablename+" where requestid = '"+dt1Param[0]+"'";
						logBean.writeLog(SQL);
						rs.executeSql(SQL);
						while(rs.next()){
								mainid = Util.null2String(rs.getString("id"));
								System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt1(" +
										"mainid,ZNTXMBH,ZTDXTBH,ZDKMC,ZDKLB," +
										"ZZDH,ZDKZT,ZHQFS,ZSSZZ,BLAND," +
										"ZSZFW) " +
										"values ('"
										+mainid+"','"+dt1Param[1]+"','"+dt1Param[2]+"','"+dt1Param[3]+"','"+dt1Param[4]+
										"','"+dt1Param[5]+"','"+dt1Param[6]+"','"+dt1Param[7]+"','"+dt1Param[8]+"','"+dt1Param[9]+
										"','"+dt1Param[10]+"')";
								logBean.writeLog("insertSql="+insertSQL);
								rs1.executeSql(insertSQL);
						}
					}
				}
				
				if(dt2List.size()>0){
					for(int m=0;m<dt2List.size();m++){
						String[] dt2Param = dt2List.get(m).split(",");
						//获取mainid
						String SQL ="select * from "+tablename+" where requestid = '"+dt2Param[0]+"'";
						logBean.writeLog(SQL);
						rs2.executeSql(SQL);
						while(rs2.next()){
								mainid = Util.null2String(rs2.getString("id"));
								System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt2(" +
										"mainid,ZTDXTBH,ZTDYTHXM,ZTDYTBM,ZCRMJ," +
										"ZRJL,ZJZMD,ZLHL,ZSYNX) " +
										"values ('"
										+mainid+"','"+dt2Param[1]+"','"+dt2Param[2]+"','"+dt2Param[3]+"','"+dt2Param[4]+
										"','"+dt2Param[5]+"','"+dt2Param[6]+"','"+dt2Param[7]+"','"+dt2Param[8]+"')";
								logBean.writeLog("明细表2="+insertSQL);
								rs3.executeSql(insertSQL);
						}
					}
				}
				
				if(dt3List.size()>0){
					for(int m=0;m<dt3List.size();m++){
						String[] dt3Param = dt3List.get(m).split(",");
						//获取mainid
						String SQL ="select * from "+tablename+" where requestid = '"+dt3Param[0]+"'";
						logBean.writeLog(SQL);
						rs4.executeSql(SQL);
						while(rs4.next()){
								mainid = Util.null2String(rs4.getString("id"));
								System.out.println("mainid = "+mainid);
								String insertSQL = "insert into  "+tablename+"_dt3(" +
										"mainid,ZNTXMBH,ZFILE_NO,ZWJMC,ZFILE_PATH," +
										"UNAME,DATUM,WZLJ) " +
										"values ('"
										+mainid+"','"+dt3Param[1]+"','"+dt3Param[2]+"','"+dt3Param[3]+"','"+dt3Param[4]+
										"','"+dt3Param[5]+"','"+dt3Param[6]+"','"+dt3Param[7]+"')";
								logBean.writeLog("insertSql="+insertSQL);
								rs5.executeSql(insertSQL);
						}
					}
				}
				logBean.writeLog("=================OA明细表处理结束===================");
				logBean.writeLog("==================拟投项目初审会签结束=========================");
	}else{
		System.out.println("connect fail !");				
	}
}


	private String createWorkflow(String ZNTXMBH, String ZYT, String ZBL,String ZNBSYL, String ZNHSYL, 
							   String ZXJLHZZQ, String ZXSMLL,String ZSQR, String ZXMMC, String ZXMLX, 
							   String ZJRMJ,String ZZJZMJ, String ZKFZQ, String ZJYMS, String ZSSZZ,
							   String ZXMGS, String ZGSJZC, String ZZTZ, String ZQYTZJE,String ZWFTZZB, 
							   String ZXMSZD, String ZHZF, String ZHZHBMC,String ZHZFTZB, String ZXMJJ, 
							   String ZSBGSSM, String ZJLBZJZ,String ZYT1,String ZBL1,String ZNBSYL1,
							   String ZNHSYL1,String ZXJLHZZQ1,String ZXSMLL1,String ZJXRZJE) {
		
			String newRequestid = "-1000";
			String resourceid = ZSQR;
			String TODAY = TimeUtil.getCurrentDateString();

			BaseBean baseBean = new BaseBean();
			RecordSet rs = new RecordSet();
			RecordSet rs1 = new RecordSet();
			String tablename="";
			String lcbt = "";
			String subcompanyid ="";
			String lastname = "";
			String workflowid ="";
			String description ="";
			rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '"+ZSQR+"'");
			rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '"+ZSQR+"'");
			while(rs.next()){
				subcompanyid = Util.null2String(rs.getString("subcompanyid1"));
				lastname = Util.null2String(rs.getString("lastname"));
			}
			
				workflowid = baseBean.getPropValue("QuasiInvestmentProject","QuasiInvestmentProjectWorkflowid");//中星拟投项目流程的workflowid
				lcbt = baseBean.getPropValue("QuasiInvestmentProject","QuasiInvestmentProjectWorkflowname");//中星拟投项目流程的workflowid
				description = lcbt+"-"+lastname+"-"+TODAY.replace("-", "");
			
			
			String SQL = "select tablename from workflow_base wb,workflow_bill wbi where  wb.formid = wbi.id and wb.id = '"+workflowid+"'";
			rs1.executeSql(SQL);
			while(rs1.next()){
				tablename = Util.null2String(rs1.getString("tablename"));
			}
			//String workflowid = "2682";//拟投项目初审会签流程的workflowid
	
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
			//String ZNTXMBH, String ZYT, String ZBL,String ZNBSYL, String ZNHSYL,
			field = new Property();
			field.setName("ZNTXMBH");
			field.setValue(ZNTXMBH);
			fields.add(field);
			
			field = new Property();
			field.setName("ZYT");
			field.setValue(ZYT);
			fields.add(field);
			
			field = new Property();
			field.setName("ZBL");
			field.setValue(ZBL);
			fields.add(field);
			
			field = new Property();
			field.setName("ZNBSYL");
			field.setValue(ZNBSYL);
			fields.add(field);
			
			field = new Property();
			field.setName("ZNHSYL");
			field.setValue(ZNHSYL);
			fields.add(field);
			// String ZXJLHZZQ, String ZXSMLL,String ZSQR, String ZXMMC, String ZXMLX, 
			field = new Property();
			field.setName("ZXJLHZZQ");
			field.setValue(ZXJLHZZQ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZXSMLL");
			field.setValue(ZXSMLL);
			fields.add(field);
			
			field = new Property();
			field.setName("ZSQR");
			field.setValue(ZSQR);
			fields.add(field);
			
			field = new Property();
			field.setName("ZXMMC");
			field.setValue(ZXMMC);
			fields.add(field);
			
			field = new Property();
			field.setName("ZXMLX");
			field.setValue(ZXMLX);
			fields.add(field);
			
			// String ZJRMJ,String ZZJZMJ, String ZKFZQ, String ZJYMS, String ZSSZZ,
			field = new Property();
			field.setName("ZJRMJ");
			field.setValue(ZJRMJ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZZJZMJ");
			field.setValue(ZZJZMJ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZNTXMBH");
			field.setValue(ZNTXMBH);
			fields.add(field);
			
			field = new Property();
			field.setName("ZKFZQ");
			field.setValue(ZKFZQ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZJYMS");
			field.setValue(ZJYMS);
			fields.add(field);
			
			field = new Property();
			field.setName("ZSSZZ");
			field.setValue(ZSSZZ);
			fields.add(field);
			// String ZXMGS, String ZGSJZC, String ZZTZ, String ZQYTZJE,String ZWFTZZB, 
			field = new Property();
			field.setName("ZXMGS");
			field.setValue(ZXMGS);
			fields.add(field);
			
			field = new Property();
			field.setName("ZGSJZC");
			field.setValue(ZGSJZC);
			fields.add(field);
			
			field = new Property();
			field.setName("ZZTZ");
			field.setValue(ZZTZ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZQYTZJE");
			field.setValue(ZQYTZJE);
			fields.add(field);
			
			field = new Property();
			field.setName("ZWFTZZB");
			field.setValue(ZWFTZZB);
			fields.add(field);
			
			//   String ZXMSZD, String ZHZF, String ZHZHBMC,String ZHZFTZB, String ZXMJJ, 
			field = new Property();
			field.setName("ZXMSZD");
			field.setValue(ZXMSZD);
			fields.add(field);
			
			field = new Property();
			field.setName("ZHZF");
			field.setValue(ZHZF);
			fields.add(field);
			
			field = new Property();
			field.setName("ZHZHBMC");
			field.setValue(ZHZHBMC);
			fields.add(field);
			
			field = new Property();
			field.setName("ZHZHBMC");
			field.setValue(ZHZHBMC);
			fields.add(field);
			
			field = new Property();
			field.setName("ZHZFTZB");
			field.setValue(ZHZFTZB);
			fields.add(field);
			
			field = new Property();
			field.setName("ZXMJJ");
			field.setValue(ZXMJJ);
			fields.add(field);
			// String ZSBGSSM, String ZJLBZJZ
			field = new Property();
			field.setName("ZSBGSSM");
			field.setValue(ZSBGSSM);
			fields.add(field);
			
			field = new Property();
			field.setName("ZJLBZJZ");
			field.setValue(ZJLBZJZ);
			fields.add(field);
			
			field = new Property();
			field.setName("ZYT1");
			field.setValue(ZYT1);
			fields.add(field);
			
			field = new Property();
			field.setName("ZBL1");
			field.setValue(ZBL1);
			fields.add(field);
			
			field = new Property();
			field.setName("ZNBSYL1");
			field.setValue(ZNBSYL1);
			fields.add(field);
			
			field = new Property();
			field.setName("ZNHSYL1");
			field.setValue(ZNHSYL1);
			fields.add(field);
			// String ZXJLHZZQ, String ZXSMLL,String ZSQR, String ZXMMC, String ZXMLX, 
			field = new Property();
			field.setName("ZXJLHZZQ1");
			field.setValue(ZXJLHZZQ1);
			fields.add(field);
			
			field = new Property();
			field.setName("ZXSMLL1");
			field.setValue(ZXSMLL1);
			fields.add(field);
			
			field = new Property();
			field.setName("ZJXRZJE");
			field.setValue(ZJXRZJE);
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

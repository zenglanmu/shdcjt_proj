package test.undo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import test.Column;
import weaver.conn.RecordSet;
import weaver.createWorkflow.SAP.conn.SAPConnPool;
import weaver.general.BaseBean;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.RequestService;

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;

/**
 * 合同审批
 * 
 * @author Administrator
 * 
 */
public class testConn {
	private static final String REQUEST_ID = "requestid";
	private static final String CONTRACT_NO = "CONTRACTNO";
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();

	public void testconn() {
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			System.out.println("==========合同审批=============");
			System.out.println("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); // 活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZDC_CO_CONT"); // 获取合同审批模板
			JCO.Function function = ft.getFunction();
			
			// 获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();
			JCO.ParameterList inputtable = function.getTableParameterList();
			myConnection.execute(function);
			
			ParameterList outputTable = function.getTableParameterList(); // 输出表的处理
			Table basicContract = outputTable.getTable("ET_CO_CONT"); // 合同基本信息（主表）
			Table bidInfoDetail = outputTable.getTable("ET_CO_POITEM"); // 中标信息（明细表）
			Table contractFileDetail = outputTable.getTable("ET_CO_CON_FILE"); // 合同附件（明细表）
//			Table divideAmoutDetail = outputTable.getTable("ET_CO_CON_SPLIT"); // 拆分金额（明细表）
		}
	}
	public void execute() {
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			System.out.println("==========合同审批=============");
			System.out.println("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); // 活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZDC_CO_CONT"); // 获取合同审批模板
			JCO.Function function = ft.getFunction();

			// 获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();
			JCO.ParameterList inputtable = function.getTableParameterList();
			myConnection.execute(function);

			ParameterList outputTable = function.getTableParameterList(); // 输出表的处理
			Table basicContract = outputTable.getTable("ET_CO_CONT"); // 合同基本信息（主表）
			Table bidInfoDetail = outputTable.getTable("ET_CO_POITEM"); // 中标信息（明细表）
			Table contractFileDetail = outputTable.getTable("ET_CO_CON_FILE"); // 合同附件（明细表）
//			Table divideAmoutDetail = outputTable.getTable("ET_CO_CON_SPLIT"); // 拆分金额（明细表）

			// 合同基本信息（主表）字段与值
			List<Column> basicContractColLs = Arrays.asList(new Column[] {
					new Column(CONTRACT_NO, ""), new Column("CONTCATE", ""),
					new Column("CONTFCLASS", ""),
					new Column("CONTSCLASS", ""), new Column("BIDPLANNO", ""),
					new Column("ZZBNAME", ""), new Column("ZCBTYPE", ""),
					new Column("JZCGKG", ""), new Column("ACONTNO", ""),
					new Column("CONTRACTNAME", ""),
					new Column("CONTTCURR", ""), new Column("FORECASTAMT", ""),
					new Column("AGGAMT", ""), new Column("NEW_AMT", ""),
					new Column("PCONTNO", ""), new Column("PLANCON_DES", ""),
					new Column("PSPID", ""), new Column("PSNAM", ""),
					new Column("BUKRS", ""), new Column("BUTXT", ""),
					new Column("LIFNR", ""), new Column("VENDNAME", ""),
					new Column("CONTACT", ""), new Column("VENDORTELF", ""),
					new Column("OFFICE", ""), new Column("LIFNR_B", ""),
					new Column("VENDNAME_B", ""), new Column("BANK_ACC", ""),
					new Column("BANK_ACC_NAM", ""),
					new Column("LIFNR_3RD", ""),
					new Column("VENDNAME_3RD", ""), new Column("VALTYPE", ""),
					new Column("ISZB", ""), new Column("VAUTYPE", ""),
					new Column("CONSTATUS", ""), new Column("APPSTATUS", ""),
					new Column("DELFLAG", ""), new Column("CUNAME", ""),
					new Column("CDEPT_DESC", ""), new Column("CREA_DATE", ""),
					new Column("CREA_TIME", ""), new Column("JDTK", ""),
					new Column("WYTK", ""), new Column("FKTK", ""),
					new Column("ZEMPLOYEE", "") });

			Map<String, Column> basicContractColMap = new HashMap<String, Column>();
			for (Column column : basicContractColLs) {
				if (!basicContractColMap.containsKey(column.getName())) {
					basicContractColMap.put(column.getName(), column);
				}
			}

			// 中标信息（明细表）
//			List<Column> bidInfoDetailColLs = Arrays.asList(new Column[] {
//					new Column(CONTRACT_NO, ""), new Column("SELECTED", ""),
//					new Column("SEG_NAME", ""), new Column("LIFNR", ""),
//					new Column("NAME1", ""), new Column("JE_HB", ""),
//					new Column("BUZEI", "") });
//
//			Map<String, Column> bidInfoDetailColMap = new HashMap<String, Column>();
//			for (Column column : bidInfoDetailColLs) {
//				if (!bidInfoDetailColMap.containsKey(column.getName())) {
//					bidInfoDetailColMap.put(column.getName(), column);
//				}
//			}

			// 合同附件（明细表）--SAP逻辑中暂时删除不用
			List<Column> contractFileDetailColLs = Arrays.asList(new Column[] {
					new Column(CONTRACT_NO, ""), new Column("ZFILE_NO", ""),
					new Column("ZWJMC", ""), new Column("ZFILE_PATH", ""),
					new Column("UNAME", ""), new Column("DATUM", "") });

			Map<String, Column> contractFileDetailColMap = new HashMap<String, Column>();
			for (Column column : contractFileDetailColLs) {
				if (!contractFileDetailColMap.containsKey(column.getName())) {
					contractFileDetailColMap.put(column.getName(), column);
				}
			}

//			// 拆分金额（明细表）--SAP逻辑中暂时删除不用
//			List<Column> divideAmoutDetailColLs = Arrays.asList(new Column[] {
//					new Column(CONTRACT_NO, ""), new Column("COACCOUNT", ""),
//					new Column("COACCOUNT_TEXT", ""), new Column("YTNAM", ""),
//					new Column("FQNAM", ""), new Column("AREA_VAL", ""),
//					new Column("AREA_VAL08", ""), new Column("SPLIT_TYPE", ""),
//					new Column("SPLITAMT2", ""),
//					new Column("FORECASTAMT2", ""), new Column("NEW_AMT", ""),
//					new Column("CHG_AMT", ""), });
//
//			Map<String, Column> divideAmoutDetailColMap = new HashMap<String, Column>();
//			for (Column column : divideAmoutDetailColLs) {
//				if (!divideAmoutDetailColMap.containsKey(column.getName())) {
//					divideAmoutDetailColMap.put(column.getName(), column);
//				}
//			}

			String returnStr = "";
			int requestid = 0;
			String tablename = "";
			Map<String, Object> bidInfoSqlMap = null;
			Map<String, Object> contractFileSqlMap = null;
			Map<String, Object> divideAmoutSqlMap = null;

			if (basicContract.getNumRows() > 0) {
				for (int i = 0; i < basicContract.getNumRows(); i++) {
					String ZEMPLOYEE = "-1";
					basicContract.setRow(i);
					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					for (Entry<String, Column> kv : basicContractColMap.entrySet()) {
						String colValue = basicContract.getString(kv.getKey()).trim();
						if("ZEMPLOYEE".equals(kv.getKey())) {
							ZEMPLOYEE = colValue;
						}
						kv.getValue().setValue(colValue);
					}
					
					for (Entry<String, Column> kv : basicContractColMap.entrySet()) {
						logBean.writeLog("basicContractColMap==" + kv.getKey() + "||" + kv.getValue());
					}

					//returnStr = "-999,tablename";
					returnStr = createWorkflow(basicContractColMap, ZEMPLOYEE);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0], 0);
					tablename = str[1];
					logBean.writeLog("ET_CO_CONT new requestid =" + requestid + "||tablename=" + tablename);

					logBean.writeLog("bidInfoDetail.getNumRows() =" + bidInfoDetail.getNumRows());
//					//中标信息明细表循环
//					if (bidInfoDetail.getNumRows() > 0) {
//						bidInfoSqlMap = new HashMap<String, Object>();
//						for (int j = 0; j < bidInfoDetail.getNumRows(); j++) {
//							bidInfoDetail.setRow(j);
//							// 比对合同系统编号是否相同，在对明细表复制比对值分别从主表获取
//							Column basicContractCol = basicContractColMap.get(CONTRACT_NO);
//							String contractNo = bidInfoDetail.getString(CONTRACT_NO).trim();
//							if (basicContractCol.getValue().equals(contractNo)) {
//								// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
//								StringBuilder sb = new StringBuilder();
//								sb.append("requestid=" + requestid + ", ");
//								bidInfoSqlMap.put(REQUEST_ID, requestid);
//								for (Entry<String, Column> kv : bidInfoDetailColMap.entrySet()) {
//									String colValue = bidInfoDetail.getString(kv.getKey()).trim();
//									kv.getValue().setValue(colValue);
//									sb.append(kv.getKey() + "=" + kv.getValue() + ", ");
//									bidInfoSqlMap.put(kv.getKey(), kv.getValue().getValue());
//								}
//								String detialInfo = sb.toString();
//								logBean.writeLog("ET_CO_POITEM中标信息明细表插入数据 = " + detialInfo);
//							}
//						}
//					} else if (bidInfoDetail.getNumRows() == 0) {
//						String detialInfo = "";
//						logBean.writeLog("ET_CO_POITEM = " + detialInfo);
//						bidInfoSqlMap = new HashMap<String, Object>();
//					}
					
					logBean.writeLog("contractFileDetail.getNumRows() =" + contractFileDetail.getNumRows());
					// 合同附件明细表循环
					if (contractFileDetail.getNumRows() > 0) {
						contractFileSqlMap = new HashMap<String, Object>();
						for (int j = 0; j < contractFileDetail.getNumRows(); j++) {
							contractFileDetail.setRow(j);
							// 比对合同系统编号是否相同，在对明细表复制比对值分别从主表获取
							Column basicContractCol = basicContractColMap.get(CONTRACT_NO);
							String contractNo = contractFileDetail.getString(CONTRACT_NO).trim();
							if (basicContractCol.getValue().equals(contractNo)) {
								// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
								StringBuilder sb = new StringBuilder();
								sb.append("requestid=" + requestid + ", ");
								contractFileSqlMap.put(REQUEST_ID, requestid);
								for (Entry<String, Column> kv : contractFileDetailColMap.entrySet()) {
									String colValue = contractFileDetail.getString(kv.getKey()).trim();
									kv.getValue().setValue(colValue);
									sb.append(kv.getKey() + "=" + kv.getValue() + ", ");
									contractFileSqlMap.put(kv.getKey(), kv.getValue().getValue());
								}

								String detialInfo = sb.toString();
								logBean.writeLog("ET_CO_CON_FILE合同附件明细表插入数据 = " + detialInfo);

							}
						}
					} else if (contractFileDetail.getNumRows() == 0) {
						String detialInfo = "";
						logBean.writeLog("ET_CO_CON_FILE = " + detialInfo);
						contractFileSqlMap = new HashMap<String, Object>();
					}
					
					// 拆分金额明细表循环
//					if (divideAmoutDetail.getNumRows() > 0) {
//						divideAmoutSqlMap = new HashMap<String, Object>();
//						for (int j = 0; j < divideAmoutDetail.getNumRows(); j++) {
//							contractFileDetail.setRow(j);
//							// 比对合同系统编号是否相同，在对明细表复制比对值分别从主表获取
//							Column basicContractCol = basicContractColMap.get(CONTRACT_NO);
//							String contractNo = divideAmoutDetail.getString(CONTRACT_NO);
//							if (basicContractCol.getValue().equals(contractNo)) {
//								// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
//								StringBuilder sb = new StringBuilder();
//								sb.append("requestid=" + requestid + ", ");
//								divideAmoutSqlMap.put(REQUEST_ID, requestid);
//								for (Entry<String, Column> kv : divideAmoutDetailColMap.entrySet()) {
//									String colValue = divideAmoutDetail.getString(kv.getKey());
//									kv.getValue().setValue(colValue);
//									sb.append(kv.getKey() + "=" + kv.getValue() + ", ");
//									divideAmoutSqlMap.put(kv.getKey(), kv.getValue().getValue());
//								}
//								String detialInfo = sb.toString();
//								logBean.writeLog("ET_CO_CON_SPLIT拆分金额明细表插入数据 = " + detialInfo);
//							}
//						}
//					} else if (divideAmoutDetail.getNumRows() == 0) {
//						String detialInfo = "";
//						logBean.writeLog("ET_CO_CON_SPLIT = " + detialInfo);
//						divideAmoutSqlMap = new HashMap<String, Object>();
//					}

					logBean.writeLog("===========合同审批结束=============");
				}
			}
			SAPConn.releaseC(myConnection);
			
			// 中标信息明细表
//			String logtitleBid = "插入OA中标信息明细表SQL=";
//			RecordSet rsBid = new RecordSet();
//			RecordSet rsBidAdd = new RecordSet();

			// 合同附件明细表
			String logtitleCf = "插入OA合同附件明细表SQL=";
			RecordSet rsContractFile = new RecordSet();
			RecordSet rsContractFileAdd = new RecordSet();

			// 拆分金额明细表
//			String logtitleDa = "插入OA拆分金额明细表SQL=";
//			RecordSet rsdivideAmout = new RecordSet();
//			RecordSet rsdivideAmoutAdd = new RecordSet();

//			executeSQLforDetail(tablename, "_dt1", bidInfoSqlMap, rsBid, rsBidAdd, logtitleBid);
			executeSQLforDetail(tablename, "_dt2", contractFileSqlMap, rsContractFile, rsContractFileAdd, logtitleCf);
//			executeSQLforDetail(tablename, "_dt3", divideAmoutSqlMap, rsdivideAmout, rsdivideAmoutAdd, logtitleDa);
			logBean.writeLog("===========合同审批结束=============");
		} else {
			logBean.writeLog("SAP connection fail");
		}
	}
		

	private void executeSQLforDetail(String tablename,String dtName, Map<String, Object> sqlMap, RecordSet mainRs, RecordSet insertRs, String logtitle) {
		if (sqlMap.size() > 0) {
			// 获取主表id
			String sql = "select id from " + tablename + " where requestid = '" + sqlMap.get(REQUEST_ID) + "'";//dt表中没有requestid，只有mainid
			logBean.writeLog(sql);
			mainRs.executeSql(sql);
			while (mainRs.next()) {
				String mainid = Util.null2String(mainRs.getString("id"));
				logBean.writeLog("mainid = " + mainid);

				StringBuilder insertSqlSb = new StringBuilder();
				insertSqlSb.append("insert into ");
				insertSqlSb.append(tablename + dtName + "(mainid,");
				int ci = 0;
				int csize = sqlMap.size();
				Set<String> colNames = sqlMap.keySet();
				for (String colname : colNames) {
					if(!REQUEST_ID.equals(colname)) {
						// 拼接sql最后一个不需要添加,号，此处因为没有工具类暂时先这么实现
						if (ci == csize - 2) {
							insertSqlSb.append(colname);
						} else {
							insertSqlSb.append(colname + ",");
						}
						ci++;
					}
				}
				insertSqlSb.append(") values ('" + mainid + "',");
				int vi = 0;
				int vsize = sqlMap.size();
				for (String colname : colNames) {
					if(!REQUEST_ID.equals(colname)) {
						// 拼接sql最后一个不需要添加,号，此处因为没有工具类暂时先这么实现
						if (sqlMap.containsKey(colname)) {
							if (vi == vsize - 2) {
								insertSqlSb.append("'" + sqlMap.get(colname) + "'");
							} else {
								insertSqlSb.append("'" + sqlMap.get(colname) + "',");
							}
						} else {
							insertSqlSb.append("''"); // 字段值不存在插入空字符串，防止列不对应报错
						}
						vi++;
					}
				}
				insertSqlSb.append(")");
				String insertSQL = insertSqlSb.toString();
				logBean.writeLog(logtitle + insertSQL);
				insertRs.executeSql(insertSQL);
			}
		}
	}

	private String createWorkflow(Map<String, Column> mainTableMap, String ZEMPLOYEE) {
		String newRequestid = "-1000";
		String resourceid = ZEMPLOYEE;

		String TODAY = TimeUtil.getCurrentDateString();
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();

		String tablename = "";
		String lastname = "";
		rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '" + ZEMPLOYEE + "'");
		rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '" + ZEMPLOYEE + "'");
		while (rs.next()) {
			lastname = Util.null2String(rs.getString("lastname"));
		}

		String workflowid = "3762";//合同审批流程workflowid
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where wb.formid = wbi.id and wb.id = '" + workflowid + "'";
		rs1.executeSql(SQL);
		rs1.writeLog("gettablenamesql=" + SQL);
		while (rs1.next()) {
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		logBean.writeLog("合同审批流程的workflowid=" + workflowid + "||resourceid=" + resourceid);

		RequestService requestService = new RequestService();
		RequestInfo requestInfo = new RequestInfo();
		requestInfo.setWorkflowid(workflowid);
		requestInfo.setCreatorid(resourceid);
		requestInfo.setDescription("合同审批流程-" + lastname + "-" + TODAY.replace("-", ""));
		requestInfo.setRequestlevel("1");
		requestInfo.setIsNextFlow("0");

		// 主表信息
		MainTableInfo mainTableInfo = new MainTableInfo();
		List<Property> fields = new ArrayList<Property>();
		Property field = null;

		for (Entry<String, Column> kv : mainTableMap.entrySet()) {
			field = new Property();
			field.setName(kv.getKey());
			field.setValue(kv.getValue().getValue());
			fields.add(field);
		}

		Property[] fieldarray = (Property[]) fields.toArray(new Property[fields.size()]);
		mainTableInfo.setProperty(fieldarray);
		requestInfo.setMainTableInfo(mainTableInfo);

		try {
			newRequestid = requestService.createRequest(requestInfo);
			logBean.writeLog("======创建流程时新生成的id=======" + newRequestid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logBean.writeLog("流程创建失败！！！");
			e.printStackTrace();
		}
		return newRequestid + "," + tablename;
	}
}

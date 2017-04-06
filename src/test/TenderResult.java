package test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import org.apache.commons.lang3.StringUtils;

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

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Client;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;

/**
 * 招标结果
 * 
 * @author Administrator
 * 
 */
public class TenderResult  extends BaseCronJob
{
	private static final String REQUEST_ID = "requestid";
	private static final String BANFN = "BANFN";
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();

	public void execute()
	{
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive())
		{
			System.out.println("==========招标结果=============");
			System.out.println("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); // 活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZPO_RESULT_NEW"); // 获取招标结果模板
			JCO.Function function = ft.getFunction();

			// 获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();
			JCO.ParameterList inputtable = function.getTableParameterList();
			myConnection.execute(function);

			ParameterList outputTable = function.getTableParameterList(); // 输出表的处理
			Table basicContract = outputTable.getTable("ET_PO"); // 结算基本信息（主表）

			// 明细表数据以excel表的顺序来决定tb1, tb2, tb3
			Table tb1Detail = outputTable.getTable("ET_VENDOR"); // ET_VENDOR信息（明细表）
			Table tb2Detail = outputTable.getTable("ET_ZD"); // ET_ZD信息（明细表）
			Table tb3Detail = outputTable.getTable("ET_ZCBPBJ"); // ET_ZCBPBJ信息（明细表）
			Table tb4Detail = outputTable.getTable("ET_FILE"); // ET_FILE信息（明细表）

			// IS_PO信息（主表）字段与值
			List<Column> basicContractColLs = Arrays.asList(new Column[] { new Column(BANFN, ""),
					new Column("ZZBNAME", ""), new Column("POST1", ""), new Column("ZHBLX", ""),
					new Column("ZEMPLOYEE", ""), new Column("ZBZ", ""), new Column("ZCUSER", "") });

			// 此处都是为了构建IS_PO主表表结构HashMap，对应的主表table结构hash，key-字段名，value-字段实体相当于主表的单条记录
			Map<String, Column> basicContractColMap = new HashMap<String, Column>();
			for (Column column : basicContractColLs)
			{
				if (!basicContractColMap.containsKey(column.getName()))
				{
					basicContractColMap.put(column.getName(), column);
				}
			}

			// ET_VENDOR信息（明细表）
			List<Column> tb1DetailColLs = Arrays.asList(new Column[] { new Column(BANFN, ""), new Column("NAME1", ""),
					new Column("PLANCON", ""), new Column("PLANCON_DES", ""), new Column("CON_TAMT", ""),
					new Column("CON_LAMT", ""), new Column("ZZHBJ", ""), new Column("ZZBDATE", "") });

			// 此处都是为了构建ET_VENDOR信息明细表结构HashMap，对应的主表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb1DetailColMap = new HashMap<String, Column>();
			for (Column column : tb1DetailColLs)
			{
				if (!tb1DetailColMap.containsKey(column.getName()))
				{
					tb1DetailColMap.put(column.getName(), column);
				}
			}

			logBean.writeLog("+++++++++" + tb1DetailColMap);
			// ET_ZD（明细表）
			List<Column> tb2DetailColLs = Arrays
					.asList(new Column[] { new Column(BANFN, ""), new Column("ZZBNAME", ""), new Column("ZYDSP2", ""),
							new Column("ZYDSP3", ""), new Column("ZCGGCL", ""), new Column("ZJLDW", ""),
							new Column("ZHBLX", ""), new Column("ZBZ", "") });
			// 此处都是为了构建ET_ZD结构HashMap，对应的明细表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb2DetailColMap = new HashMap<String, Column>();
			for (Column column : tb2DetailColLs)
			{
				if (!tb2DetailColMap.containsKey(column.getName()))
				{
					tb2DetailColMap.put(column.getName(), column);
				}
			}

			logBean.writeLog("+++++++++" + tb2DetailColMap);
			// ET_ZCBPBJ信息（明细表）
			List<Column> tb3DetailColLs = Arrays.asList(new Column[] { new Column(BANFN, ""), new Column("ZYDSP2", ""),
					new Column("ZYDSP3", ""), new Column("ZCGGCL", ""), new Column("ZJLDW", ""),
					new Column("ZHBLX", ""), new Column("ZPPSP4", ""), new Column("ZBZ", "") });

			// 此处都是为了ET_ZCBPBJ信息细表结构HashMap，对应的明细表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb3DetailColMap = new HashMap<String, Column>();
			for (Column column : tb3DetailColLs)
			{
				if (!tb3DetailColMap.containsKey(column.getName()))
				{
					tb3DetailColMap.put(column.getName(), column);
				}
			}
			logBean.writeLog("+++++++++" + tb3DetailColMap);

			// ET_FILE（明细表）
			List<Column> tb4DetailColLs = Arrays.asList(new Column[] { new Column(BANFN, ""), new Column("ZWJMC", ""),
					new Column("ZWJNR", ""), new Column("UNAME", ""), new Column("DATUM", "") });

			Map<String, Column> tb4DetailColMap = new HashMap<String, Column>();
			for (Column column : tb4DetailColLs)
			{
				if (!tb4DetailColMap.containsKey(column.getName()))
				{
					tb4DetailColMap.put(column.getName(), column);
				}
			}

			System.out.println("=======0=======");
			String returnStr = "";
			int requestid = 0;
			String tablename = "";

			/*
			 * 开始构建从sap table获取到的主表与明细表关联关系M-N M为主表的实际dbkey数量，dictinct dbkey
			 * count N为主表对应的所有明细表详情，明细表详情里面他每个明细表所含的记录数可能不同都是以BANFN做关联
			 * 例如个人信息为主表，电话表为明细表1，地址表为明细表2 则个人信息只会出现张三一条，李四一条
			 * 对应的张三所属电话表记录为3条，地址为2条 对应的李四所属电话表记录为2条，地址为起跳
			 */
			System.out.println("开始构建从sap table获取到的主表与明细表关联关系N-N");

			// 结算基本信息以key-DB_KEY，value是结算基本信息记录数据，多个流程会有多条不同的DB_KEY
			Map<String, SAPRecord> mainTableMap = new HashMap<String, SAPRecord>();

			// 明细表详情，以BANFN为key对应的每个明细表集合
			Map<String, List<SAPRecord>> tb1SqlMap = null;
			Map<String, List<SAPRecord>> tb2SqlMap = null;
			Map<String, List<SAPRecord>> tb3SqlMap = null;
			Map<String, List<SAPRecord>> tb4SqlMap = null;

			System.out.println("=======1=======");
			if (basicContract.getNumRows() > 0)
			{
				// 创建IS_PO信息对应主流程中的，记录BANFN所生成的request_id记录下来
				for (int i = 0; i < basicContract.getNumRows(); i++)
				{
					String ZEMPLOYEE = "-1";
					basicContract.setRow(i); // 设置当前行记录索引，获取的为当前索引的一条记录数据

					// 循环map总所有的key,将记录数据转换为basicContractColMap数据
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : basicContractColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(basicContract.getString(kv.getKey())) ? "" : StringUtils
								.trim(basicContract.getString(kv.getKey()));
						if ("ZEMPLOYEE".equals(kv.getKey()))
						{
							ZEMPLOYEE = colValue;
						}
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}

					for (Entry<String, Column> kv : sapRecord.getColumnMap().entrySet())
					{
						logBean.writeLog("sapRecord.getColumnMap()==" + kv.getKey() + "||" + kv.getValue());
					}

					// returnStr = "-999,tablename";
					returnStr = createWorkflow(sapRecord.getColumnMap(), ZEMPLOYEE); // 创建一个结算基本信息流程
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0], 0);
					tablename = str[1];
					logBean.writeLog("IS_PO new requestid =" + requestid + "||tablename=" + tablename);
					System.out.println("IS_PO new requestid =" + requestid + "||tablename=" + tablename);

					// 插入IS_PO信息数据
					if (!basicContractColMap.containsKey(BANFN))
					{
						throw new IllegalArgumentException("basicContractColMap不包含BANFN字段");
					}

					// 转换为我们自己的SAP记录数据实体把结算基本信息所生成requestid全部记录了
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, String.valueOf(requestid)));
					logBean.writeLog("sapRecord==" + sapRecord);
					Column dbkey = sapRecord.getColumnMap().get(BANFN);
					if (!mainTableMap.containsKey(dbkey))
					{
						mainTableMap.put(dbkey.getValue(), sapRecord);
					}
				}

			}

			// ET_VENDOR信息明细表循环
			logBean.writeLog("tb1Detail.getNumRows() =" + tb1Detail.getNumRows());
			if (tb1Detail.getNumRows() > 0)
			{
				tb1SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb1Detail.getNumRows(); j++)
				{
					tb1Detail.setRow(j);
					String dbk = tb1Detail.getString(BANFN).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";
					logBean.writeLog("dbk & reqid = " + dbk + "||reqid=" + reqid);

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");
					// 获取明细表列数据为hashmap结构体复制，然后转换为SAPRecord
					logBean.writeLog("tb1DetailColMap.keySet() = " + tb1DetailColMap.keySet());
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb1DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb1Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb1Detail.getString(kv.getKey()));

						logBean.writeLog("tb1DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_VENDOR招标结果信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_VENDOR招标结果信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb1SqlMap.containsKey(dbk))
					{
						tb1SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb1SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb1SqlMap.get(dbk).add(sapRecord);
					}
				}
				logBean.writeLog("ET_VENDOR招标结果信息明细表插入数据 = tb1SqlMap" + tb1SqlMap);
			} else if (tb1Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_VENDOR = " + detialInfo);
				tb1SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 补充协议信息明细表循环
			logBean.writeLog("tb2Detail.getNumRows() =" + tb2Detail.getNumRows());
			if (tb2Detail.getNumRows() > 0)
			{
				tb2SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb2Detail.getNumRows(); j++)
				{
					tb2Detail.setRow(j);
					String dbk = tb2Detail.getString(BANFN).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 获取明细表列数据为hashmap结构体复制，然后转换为SAPRecord
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb2DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb2Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb2Detail.getString(kv.getKey()));
						logBean.writeLog("tb2DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_ZD招标结果信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_ZD招标结果信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb2SqlMap.containsKey(dbk))
					{
						tb2SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb2SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb2SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_ZD招标结果审核信息明细表插入数据 = tb2SqlMap" + tb2SqlMap);
				}
			} else if (tb2Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_ZD = " + detialInfo);
				tb2SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 设计变更实际影响方信息明细表循环
			logBean.writeLog("tb3Detail.getNumRows() =" + tb3Detail.getNumRows());
			if (tb3Detail.getNumRows() > 0)
			{
				tb3SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb3Detail.getNumRows(); j++)
				{
					tb3Detail.setRow(j);
					String dbk = tb3Detail.getString(BANFN).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb3DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb3Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb3Detail.getString(kv.getKey()));
						logBean.writeLog("tb3DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_ZCBPBJ设计变更实际影响方信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_ZCBPBJ设计变更实际影响方信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb3SqlMap.containsKey(dbk))
					{
						tb3SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb3SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb3SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_ZCBPBJ设计变更实际影响方信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb3Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_ZCBPBJ = " + detialInfo);
				tb3SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 设计变更责任方信息循环
			logBean.writeLog("tb4Detail.getNumRows() =" + tb4Detail.getNumRows());
			if (tb4Detail.getNumRows() > 0)
			{
				tb4SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb4Detail.getNumRows(); j++)
				{
					tb4Detail.setRow(j);
					String dbk = tb4Detail.getString(BANFN).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb4DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb4Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb4Detail.getString(kv.getKey()));
						logBean.writeLog("tb4DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_FILES设计变更责任方信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_FILES设计变更责任方信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb4SqlMap.containsKey(dbk))
					{
						tb4SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb4SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb4SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_FILES设计变更责任方信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb4Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_FILES = " + detialInfo);
				tb4SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			SAPConn.releaseC(myConnection);

			System.out.println("=======2=======");

			// ET_VENDOR信息明细表
			String logtitleTb1 = "插入OA招标结果ET_VENDOR明细表SQL=";
			RecordSet rsTb1 = new RecordSet();
			RecordSet rsTb1Add = new RecordSet();

			// ET_ZD信息明细表
			String logtitleTb2 = "插入OA招标结果ET_ZD明细表SQL=";
			RecordSet rsTb2 = new RecordSet();
			RecordSet rsTb2Add = new RecordSet();

			// ET_ZCBPBJ信息明细表
			String logtitleTb3 = "插入OA招标结果ET_ZCBPBJ明细表SQL=";
			RecordSet rsTb3 = new RecordSet();
			RecordSet rsTb3Add = new RecordSet();

			// ET_FILE信息明细表
			String logtitleTb4 = "插入OA招标结果ET_FILE明细表SQL=";
			RecordSet rsTb4 = new RecordSet();
			RecordSet rsTb4Add = new RecordSet();

			executeSQLforDetail(tablename, "_dt1", tb1SqlMap, rsTb1, rsTb1Add, logtitleTb1);
			executeSQLforDetail(tablename, "_dt2", tb2SqlMap, rsTb2, rsTb2Add, logtitleTb2);
			executeSQLforDetail(tablename, "_dt3", tb3SqlMap, rsTb3, rsTb3Add, logtitleTb3);
			executeSQLforDetail(tablename, "_dt4", tb4SqlMap, rsTb4, rsTb4Add, logtitleTb4);

			logBean.writeLog("===========招标结果结束=============");
		} else
		{
			logBean.writeLog("SAP connection fail");
		}
	}

	private void executeSQLforDetail(String tablename, String dtName, Map<String, List<SAPRecord>> rsMap,
			RecordSet mainRs, RecordSet insertRs, String logtitle)
	{
		// 循环不同dbkey下的明细数据
		for (String dbkey : rsMap.keySet())
		{
			for (SAPRecord sapRecord : rsMap.get(dbkey))
			{
				Map<String, Column> sqlMap = sapRecord.getColumnMap();
				if (sqlMap.size() > 0)
				{
					// 获取结算基本信息id
					String sql = "select id from " + tablename + " where requestid = '"
							+ sqlMap.get(REQUEST_ID).getValue() + "'";// dt表中没有requestid，只有mainid
					logBean.writeLog(sql);
					mainRs.executeSql(sql);
					while (mainRs.next())
					{
						String mainid = Util.null2String(mainRs.getString("id"));
						logBean.writeLog("mainid = " + mainid);

						StringBuilder insertSqlSb = new StringBuilder();
						insertSqlSb.append("insert into ");
						insertSqlSb.append(tablename + dtName + "(mainid,");
						int ci = 0;
						int csize = sqlMap.size();
						Set<String> colNames = sqlMap.keySet();
						for (String colname : colNames)
						{
							if (!REQUEST_ID.equals(colname))
							{
								// 拼接sql最后一个不需要添加,号，此处因为没有工具类暂时先这么实现
								if (ci == csize - 2)
								{
									insertSqlSb.append(colname);
								} else
								{
									insertSqlSb.append(colname + ",");
								}
								ci++;
							}
						}
						insertSqlSb.append(") values ('" + mainid + "',");
						int vi = 0;
						int vsize = sqlMap.size();
						for (String colname : colNames)
						{
							if (!REQUEST_ID.equals(colname))
							{
								// 拼接sql最后一个不需要添加,号，此处因为没有工具类暂时先这么实现
								if (sqlMap.containsKey(colname))
								{
									if (vi == vsize - 2)
									{
										insertSqlSb.append("'" + sqlMap.get(colname).getValue() + "'");
									} else
									{
										insertSqlSb.append("'" + sqlMap.get(colname).getValue() + "',");
									}
								} else
								{
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
		}

	}

	private String createWorkflow(Map<String, Column> mainTableMap, String ZEMPLOYEE)
	{
		String newRequestid = "-1000";
		String resourceid = ZEMPLOYEE;

		String TODAY = TimeUtil.getCurrentDateString();
		RecordSet rs = new RecordSet();
		RecordSet rs1 = new RecordSet();

		String tablename = "";
		String lastname = "";
		rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '" + ZEMPLOYEE + "'");
		rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '" + ZEMPLOYEE + "'");
		while (rs.next())
		{
			lastname = Util.null2String(rs.getString("lastname"));
		}

		String workflowid = "3809";// 招标结果流程workflowid
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where wb.formid = wbi.id and wb.id = '"
				+ workflowid + "'";
		rs1.executeSql(SQL);
		rs1.writeLog("gettablenamesql=" + SQL);
		while (rs1.next())
		{
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		logBean.writeLog("招标结果流程的workflowid=" + workflowid + "||resourceid=" + resourceid);

		RequestService requestService = new RequestService();
		RequestInfo requestInfo = new RequestInfo();
		requestInfo.setWorkflowid(workflowid);
		requestInfo.setCreatorid(resourceid);
		requestInfo.setDescription("招标结果流程-" + lastname + "-" + TODAY.replace("-", ""));
		requestInfo.setRequestlevel("1");
		requestInfo.setIsNextFlow("0");

		// 招标结果信息
		MainTableInfo mainTableInfo = new MainTableInfo();
		List<Property> fields = new ArrayList<Property>();
		Property field = null;

		for (Entry<String, Column> kv : mainTableMap.entrySet())
		{
			field = new Property();
			field.setName(kv.getKey());
			field.setValue(kv.getValue().getValue());
			fields.add(field);
		}

		Property[] fieldarray = (Property[]) fields.toArray(new Property[fields.size()]);
		mainTableInfo.setProperty(fieldarray);
		requestInfo.setMainTableInfo(mainTableInfo);

		try
		{
			newRequestid = requestService.createRequest(requestInfo);
			logBean.writeLog("======创建流程时新生成的id=======" + newRequestid);
		} catch (Exception e)
		{
			// TODO Auto-generated catch block
			logBean.writeLog("流程创建失败！！！");
			e.printStackTrace();
		}
		return newRequestid + "," + tablename;
	}
}

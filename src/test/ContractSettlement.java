package test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

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
 * 合同结算
 * 
 * @author David.dai
 * 
 */
public class ContractSettlement  extends BaseCronJob
{
	private static final String REQUEST_ID = "requestid";
	private static final String DB_KEY = "DB_KEY";
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();

	public void execute()
	{
		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive())
		{
			System.out.println("==========合同结算=============");
			System.out.println("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); // 活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZDC_CO_SET_ROOT"); // 获取合同结算模板
			JCO.Function function = ft.getFunction();

			// 获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();
			JCO.ParameterList inputtable = function.getTableParameterList();
			myConnection.execute(function);

			ParameterList outputTable = function.getTableParameterList(); // 输出表的处理
			Table basicContract = outputTable.getTable("ET_CO_SET_ROOT"); // 结算基本信息（主表）

			// 明细表数据以excel表的顺序来决定tb1, tb2, tb3
			Table tb1Detail = outputTable.getTable("ET_CO_SET_SHINF"); // 合同结算审核信息（明细表）
			Table tb2Detail = outputTable.getTable("ET_CO_SET_SIDAG"); // 合同结算信息（明细表）
			Table tb3Detail = outputTable.getTable("ET_CO_SET_REVI"); // 设计变更实际影响方信息（明细表）
			Table tb4Detail = outputTable.getTable("ET_CO_REV_RPS"); // 设计变更责任方信息（明细表）
			Table tb5Detail = outputTable.getTable("ET_CO_SET_REVI1"); // 工程签证实际影响方信息（明细表）
			Table tb6Detail = outputTable.getTable("ET_CO_REV_RPS1"); // 责任方减扣信息（明细表）
			Table tb7Detail = outputTable.getTable("ET_CO_CON_FILE"); // 合同附件（明细表）

			// 结算基本信息（主表）字段与值
			List<Column> basicContractColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SETID", ""), new Column("SETTYPE", ""), new Column("SETLOUT", ""),
					new Column("CONTRACTNO", ""), new Column("CONTRACTNAME", ""), new Column("ACONTNO", ""),
					new Column("VENDNAME", ""), new Column("BUTXT", ""), new Column("WAERS", ""),
					new Column("CONTTCURR_NT", ""), new Column("AGGAMT", ""), new Column("KGTIME", ""),
					new Column("JGTIME", ""), new Column("CNAREA", ""), new Column("STRTYPE", ""),
					new Column("TLEVELS", ""), new Column("FHEIGHT", ""), new Column("SSTIME", ""),
					new Column("SSZJ", ""), new Column("HZJJE", ""), new Column("SDDATUM", ""), new Column("SDZJ", ""),
					new Column("NTSDZJ", ""), new Column("HSFZR", ""), new Column("WSDW", ""), new Column("WSFZR", ""),
					new Column("FDJS_LAST", ""), new Column("JSQK", ""), new Column("CREA_UNAME", ""),
					new Column("LDEPT", ""), new Column("LDIVISION", ""), new Column("CREA_DATE", ""),
					new Column("CREA_TIME", ""), new Column("APPSTATUS", ""), new Column("SETLSTA", ""),
					new Column("ZEMPLOYEE", "") });

			// 此处都是为了构建主表表结构HashMap，对应的主表table结构hash，key-字段名，value-字段实体相当于主表的单条记录
			Map<String, Column> basicContractColMap = new HashMap<String, Column>();
			for (Column column : basicContractColLs)
			{
				if (!basicContractColMap.containsKey(column.getName()))
				{
					basicContractColMap.put(column.getName(), column);
				}
			}

			// 合同结算审核信息（明细表）
			List<Column> tb1DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""), new Column("SHJD", ""),
					new Column("SHJR", ""), new Column("SHCD", ""), new Column("WHDW", ""), new Column("WHRES", ""),
					new Column("WAERS", "") });

			// 此处都是为了构建合同结算审核信息明细表结构HashMap，对应的主表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb1DetailColMap = new HashMap<String, Column>();
			for (Column column : tb1DetailColLs)
			{
				if (!tb1DetailColMap.containsKey(column.getName()))
				{
					tb1DetailColMap.put(column.getName(), column);
				}
			}

			logBean.writeLog("+++++++++" + tb1DetailColMap);
			// 补充协议信息（明细表）
			List<Column> tb2DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SELECTED", ""), new Column("ACONTNO", ""), new Column("CONTRACTNO", ""),
					new Column("CONTRACTNAME", ""), new Column("CONTTCURR", ""), new Column("WAERS", ""),
					new Column("SOURCE", "") });
			// 此处都是为了构建补充协议信息明细表结构HashMap，对应的明细表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb2DetailColMap = new HashMap<String, Column>();
			for (Column column : tb2DetailColLs)
			{
				if (!tb2DetailColMap.containsKey(column.getName()))
				{
					tb2DetailColMap.put(column.getName(), column);
				}
			}

			logBean.writeLog("+++++++++" + tb2DetailColMap);
			// 设计变更实际影响方信息（明细表）
			List<Column> tb3DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SELECTED", ""), new Column("REVISIONNO", ""), new Column("EXREVINNO", ""),
					new Column("ESTICURR", ""), new Column("REVICURR", ""), new Column("CREA_DATE", ""),
					new Column("OVSFLAG", "") });

			// 此处都是为了构建设计变更实际影响方信息细表结构HashMap，对应的明细表table结构hash，key-字段名，value-字段实体
			Map<String, Column> tb3DetailColMap = new HashMap<String, Column>();
			for (Column column : tb3DetailColLs)
			{
				if (!tb3DetailColMap.containsKey(column.getName()))
				{
					tb3DetailColMap.put(column.getName(), column);
				}
			}
			logBean.writeLog("+++++++++" + tb3DetailColMap);

			// 设计变更责任方信息（明细表）
			List<Column> tb4DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SELECTED", ""), new Column("SETSTATUS", ""), new Column("REVISIONNO", ""),
					new Column("EXREVINNO", ""), new Column("DEDAMT", ""), new Column("CREA_DATE", ""),
					new Column("WAERS", "") });

			Map<String, Column> tb4DetailColMap = new HashMap<String, Column>();
			for (Column column : tb4DetailColLs)
			{
				if (!tb4DetailColMap.containsKey(column.getName()))
				{
					tb4DetailColMap.put(column.getName(), column);
				}
			}

			// 工程签证实际影响方信息（明细表）
			List<Column> tb5DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SELECTED", ""), new Column("OSVID", ""), new Column("OSVNO", ""),
					new Column("AUDITCURR", ""), new Column("REVICURR", ""), new Column("CREA_DATE", "") });

			Map<String, Column> tb5DetailColMap = new HashMap<String, Column>();
			for (Column column : tb5DetailColLs)
			{
				if (!tb5DetailColMap.containsKey(column.getName()))
				{
					tb5DetailColMap.put(column.getName(), column);
				}
			}

			// 责任方减扣信息（明细表）
			List<Column> tb6DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("SELECTED", ""), new Column("OSVID", ""), new Column("OSVNO", ""),
					new Column("AUDITCURR", ""), new Column("REVICURR", ""), new Column("CREA_DATE", "") });

			Map<String, Column> tb6DetailColMap = new HashMap<String, Column>();
			for (Column column : tb6DetailColLs)
			{
				if (!tb6DetailColMap.containsKey(column.getName()))
				{
					tb6DetailColMap.put(column.getName(), column);
				}
			}

			// 合同附件（明细表）
			List<Column> tb7DetailColLs = Arrays.asList(new Column[] { new Column(DB_KEY, ""),
					new Column("ZFILE_NO", ""), new Column("ZWJMC", ""), new Column("ZFILE_PATH", ""),
					new Column("UNAME", ""), new Column("DATUM", "") });

			Map<String, Column> tb7DetailColMap = new HashMap<String, Column>();
			for (Column column : tb7DetailColLs)
			{
				if (!tb7DetailColMap.containsKey(column.getName()))
				{
					tb7DetailColMap.put(column.getName(), column);
				}
			}

			System.out.println("=======0=======");
			String returnStr = "";
			int requestid = 0;
			String tablename = "";

			/*
			 * 开始构建从sap table获取到的主表与明细表关联关系M-N M为主表的实际dbkey数量，dictinct dbkey
			 * count N为主表对应的所有明细表详情，明细表详情里面他每个明细表所含的记录数可能不同都是以dbkey做关联
			 * 例如个人信息为主表，电话表为明细表1，地址表为明细表2 则个人信息只会出现张三一条，李四一条
			 * 对应的张三所属电话表记录为3条，地址为2条 对应的李四所属电话表记录为2条，地址为起跳
			 */
			System.out.println("开始构建从sap table获取到的主表与明细表关联关系N-N");

			// 结算基本信息以key-DB_KEY，value是结算基本信息记录数据，多个流程会有多条不同的DB_KEY
			Map<String, SAPRecord> mainTableMap = new HashMap<String, SAPRecord>();

			// 明细表详情，以dbkey为key对应的每个明细表集合
			Map<String, List<SAPRecord>> tb1SqlMap = null;
			Map<String, List<SAPRecord>> tb2SqlMap = null;
			Map<String, List<SAPRecord>> tb3SqlMap = null;
			Map<String, List<SAPRecord>> tb4SqlMap = null;
			Map<String, List<SAPRecord>> tb5SqlMap = null;
			Map<String, List<SAPRecord>> tb6SqlMap = null;
			Map<String, List<SAPRecord>> tb7SqlMap = null;

			System.out.println("=======1=======");
			if (basicContract.getNumRows() > 0)
			{
				// 创建所有结算基本信息对应主流程中的，记录DB_KEY所生成的request_id记录下来
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
					logBean.writeLog("ET_CO_SET_ROOT new requestid =" + requestid + "||tablename=" + tablename);
					System.out.println("ET_CO_SET_ROOT new requestid =" + requestid + "||tablename=" + tablename);

					// 插入结算基本信息数据
					if (!basicContractColMap.containsKey(DB_KEY))
					{
						throw new IllegalArgumentException("basicContractColMap不包含DB_KEY字段");
					}

					// 转换为我们自己的SAP记录数据实体把结算基本信息所生成requestid全部记录了
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, String.valueOf(requestid)));
					logBean.writeLog("sapRecord==" + sapRecord);
					Column dbkey = sapRecord.getColumnMap().get(DB_KEY);
					if (!mainTableMap.containsKey(dbkey))
					{
						mainTableMap.put(dbkey.getValue(), sapRecord);
					}
				}

			}

			// 合同结算审核信息明细表循环
			logBean.writeLog("tb1Detail.getNumRows() =" + tb1Detail.getNumRows());
			if (tb1Detail.getNumRows() > 0)
			{
				tb1SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb1Detail.getNumRows(); j++)
				{
					tb1Detail.setRow(j);
					String dbk = tb1Detail.getString(DB_KEY).trim();
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
					logBean.writeLog("ET_CO_SET_SHINF合同结算审核信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_SET_SHINF合同结算审核信息明细表插入数据 = " + detialInfo);

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
				logBean.writeLog("ET_CO_SET_SHINF合同结算审核信息明细表插入数据 = tb1SqlMap" + tb1SqlMap);
			} else if (tb1Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_SET_SHINF = " + detialInfo);
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
					String dbk = tb2Detail.getString(DB_KEY).trim();
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
					logBean.writeLog("ET_CO_SET_SIDAG合同结算信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_SET_SIDAG合同结算信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb2SqlMap.containsKey(dbk))
					{
						tb2SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb2SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb2SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_SET_SIDAG合同结算审核信息明细表插入数据 = tb2SqlMap" + tb2SqlMap);
				}
			} else if (tb2Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_SET_SIDAG = " + detialInfo);
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
					String dbk = tb3Detail.getString(DB_KEY).trim();
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
					logBean.writeLog("ET_CO_SET_REVI设计变更实际影响方信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_SET_REVI设计变更实际影响方信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb3SqlMap.containsKey(dbk))
					{
						tb3SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb3SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb3SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_SET_REVI设计变更实际影响方信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb3Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_SET_REVI = " + detialInfo);
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
					String dbk = tb4Detail.getString(DB_KEY).trim();
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
					logBean.writeLog("ET_CO_REV_RPS设计变更责任方信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_REV_RPS设计变更责任方信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb4SqlMap.containsKey(dbk))
					{
						tb4SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb4SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb4SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_REV_RPS设计变更责任方信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb4Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_REV_RPS = " + detialInfo);
				tb4SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 工程签证实际影响方信息循环
			logBean.writeLog("tb5Detail.getNumRows() =" + tb5Detail.getNumRows());
			if (tb5Detail.getNumRows() > 0)
			{
				tb5SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb5Detail.getNumRows(); j++)
				{
					tb5Detail.setRow(j);
					String dbk = tb5Detail.getString(DB_KEY).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb5DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb5Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb5Detail.getString(kv.getKey()));
						logBean.writeLog("tb5DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_CO_SET_REVI1设计变更责任方信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_SET_REVI1设计变更责任方信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb5SqlMap.containsKey(dbk))
					{
						tb5SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb5SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb5SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_SET_REVI1设计变更责任方信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb5Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_SET_REVI1 = " + detialInfo);
				tb5SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 责任方减扣信息循环
			logBean.writeLog("tb6Detail.getNumRows() =" + tb6Detail.getNumRows());
			if (tb6Detail.getNumRows() > 0)
			{
				tb6SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb6Detail.getNumRows(); j++)
				{
					tb6Detail.setRow(j);
					String dbk = tb6Detail.getString(DB_KEY).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb6DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb6Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb6Detail.getString(kv.getKey()));
						logBean.writeLog("tb6DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_CO_REV_RPS1责任方减扣信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_REV_RPS1责任方减扣信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb6SqlMap.containsKey(dbk))
					{
						tb6SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb6SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb6SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_REV_RPS1责任方减扣信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb6Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_REV_RPS1 = " + detialInfo);
				tb6SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			// 合同附件信息循环
			logBean.writeLog("tb7Detail.getNumRows() =" + tb7Detail.getNumRows());
			if (tb7Detail.getNumRows() > 0)
			{
				tb7SqlMap = new HashMap<String, List<SAPRecord>>();
				for (int j = 0; j < tb7Detail.getNumRows(); j++)
				{
					tb7Detail.setRow(j);
					String dbk = tb7Detail.getString(DB_KEY).trim();
					String reqid = mainTableMap.containsKey(dbk) ? mainTableMap.get(dbk).getValueByKey(REQUEST_ID) : "";

					StringBuilder sb = new StringBuilder();
					sb.append("requestid=" + reqid + ", ");

					// 循环map总所有的key,相当于去除这些字段复制到的对应的column实体
					SAPRecord sapRecord = new SAPRecord();
					for (Entry<String, Column> kv : tb7DetailColMap.entrySet())
					{
						String colValue = StringUtils.isBlank(tb7Detail.getString(kv.getKey())) ? "" : StringUtils
								.trim(tb7Detail.getString(kv.getKey()));
						logBean.writeLog("tb7DetailColMap colValue = " + colValue);
						sapRecord.putKeyValue(kv.getKey(), new Column(kv.getKey(), colValue));
					}
					sapRecord.putKeyValue(REQUEST_ID, new Column(REQUEST_ID, reqid));
					logBean.writeLog("ET_CO_CON_FILE合同附件信息明细表插入数据 sapRecord = " + sapRecord.getColumnMap());
					String detialInfo = sb.toString();
					logBean.writeLog("ET_CO_CON_FILE合同附件信息明细表插入数据 = " + detialInfo);

					// 在循环所有
					if (!tb7SqlMap.containsKey(dbk))
					{
						tb7SqlMap.put(dbk, new ArrayList<SAPRecord>());
						tb7SqlMap.get(dbk).add(sapRecord);
					} else
					{
						tb7SqlMap.get(dbk).add(sapRecord);
					}
					logBean.writeLog("ET_CO_CON_FILE合同附件信息明细表插入数据 = tb3SqlMap" + tb3SqlMap);
				}
			} else if (tb7Detail.getNumRows() == 0)
			{
				String detialInfo = "";
				logBean.writeLog("ET_CO_CON_FILE = " + detialInfo);
				tb7SqlMap = new HashMap<String, List<SAPRecord>>();
			}

			SAPConn.releaseC(myConnection);

			System.out.println("=======2=======");

			// 合同结算审核信息明细表
			String logtitleTb1 = "插入OA合同结算审核信息明细表SQL=";
			RecordSet rsTb1 = new RecordSet();
			RecordSet rsTb1Add = new RecordSet();

			// 合同结算信息明细表
			String logtitleTb2 = "插入OA合同结算信息明细表SQL=";
			RecordSet rsTb2 = new RecordSet();
			RecordSet rsTb2Add = new RecordSet();

			// 设计变更实际影响方信息明细表
			String logtitleTb3 = "插入OA设计变更实际影响方信息明细表SQL=";
			RecordSet rsTb3 = new RecordSet();
			RecordSet rsTb3Add = new RecordSet();

			// 设计变更责任方信息明细表
			String logtitleTb4 = "插入OA设计变更责任方信息明细表SQL=";
			RecordSet rsTb4 = new RecordSet();
			RecordSet rsTb4Add = new RecordSet();

			// 工程签证实际影响方信息明细表
			String logtitleTb5 = "工程签证实际影响方信息明细表SQL=";
			RecordSet rsTb5 = new RecordSet();
			RecordSet rsTb5Add = new RecordSet();

			// 责任方减扣信息明细表
			String logtitleTb6 = "责任方减扣信息明细表SQL=";
			RecordSet rsTb6 = new RecordSet();
			RecordSet rsTb6Add = new RecordSet();

			// 合同附件信息明细表
			String logtitleTb7 = "合同附件信息明细表SQL=";
			RecordSet rsTb7 = new RecordSet();
			RecordSet rsTb7Add = new RecordSet();

			executeSQLforDetail(tablename, "_dt1", tb1SqlMap, rsTb1, rsTb1Add, logtitleTb1);
			executeSQLforDetail(tablename, "_dt2", tb2SqlMap, rsTb2, rsTb2Add, logtitleTb2);
			executeSQLforDetail(tablename, "_dt3", tb3SqlMap, rsTb3, rsTb3Add, logtitleTb3);
			executeSQLforDetail(tablename, "_dt4", tb4SqlMap, rsTb4, rsTb4Add, logtitleTb4);
			executeSQLforDetail(tablename, "_dt5", tb5SqlMap, rsTb5, rsTb5Add, logtitleTb5);
			executeSQLforDetail(tablename, "_dt6", tb6SqlMap, rsTb6, rsTb6Add, logtitleTb6);
			executeSQLforDetail(tablename, "_dt7", tb7SqlMap, rsTb7, rsTb7Add, logtitleTb7);

			logBean.writeLog("===========合同结算结束=============");
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

		String workflowid = "3804";// 合同结算流程workflowid
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where wb.formid = wbi.id and wb.id = '"
				+ workflowid + "'";
		rs1.executeSql(SQL);
		rs1.writeLog("gettablenamesql=" + SQL);
		while (rs1.next())
		{
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		logBean.writeLog("合同结算流程的workflowid=" + workflowid + "||resourceid=" + resourceid);

		RequestService requestService = new RequestService();
		RequestInfo requestInfo = new RequestInfo();
		requestInfo.setWorkflowid(workflowid);
		requestInfo.setCreatorid(resourceid);
		requestInfo.setDescription("合同结算流程-" + lastname + "-" + TODAY.replace("-", ""));
		requestInfo.setRequestlevel("1");
		requestInfo.setIsNextFlow("0");

		// 结算基本信息信息
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

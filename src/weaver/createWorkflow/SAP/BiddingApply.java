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
 * @Title: BiddingApply.java
 * @Package weaver.createWorkflow.SAP
 * @Description: 招标申请
 * @author JYY
 * @date 2016-7-28 上午10:50:46
 */
public class BiddingApply extends  BaseCronJob{
	private BaseBean logBean = new BaseBean();
	private SAPConnPool SAPConn = new SAPConnPool();

	
	public void execute(){
		
		List<String> dt1List = new ArrayList<String>();
		List<String> dt2List = new ArrayList<String>();
		List<String> dt3List = new ArrayList<String>();

		Client myConnection = SAPConn.getConnection();
		myConnection.connect();
		if (myConnection != null && myConnection.isAlive()) {
			logBean.writeLog("===========招标申请同步开始=============");
			logBean.writeLog("======connection success======");
			JCO.Repository myRepository = new JCO.Repository("Repository", myConnection); //活动的连接
			IFunctionTemplate ft = myRepository.getFunctionTemplate("ZPO_ITEM");//从“仓库”中获得一个指定函数名的函数模板
			JCO.Function function = ft.getFunction();
			//获得函数的import参数列表
			JCO.ParameterList input = function.getImportParameterList();//输入参数和结构处理(未使用)
			JCO.ParameterList inputtable = function.getTableParameterList();//输入表的处理
			myConnection.execute(function);//执行函数
			ParameterList output = function.getExportParameterList();//输出参数和结构处理(未使用)
			ParameterList outputTable = function.getTableParameterList();// 输出表的处理
			Table out = outputTable.getTable("ET_PO"); //head表
			Table outD_1 = outputTable.getTable("ET_ZD");//明细表ET_ZD
			Table outD_2 = outputTable.getTable("ET_ZCBPBJ");//明细表ET_ZCBPBJ
			Table outD_3 = outputTable.getTable("ET_FILES");//明细表ET_FILES
			//主表字段
			String	BANFN = "";
			String	ZZBNAME = "";
			String	BUTXT = "";
			String	POST1 = "";
			String	ZJZLX = "";
			String	ZCGGCL = "";
			String	ZJLDW = "";
			String	ZHBLX = "";
			String	ZCBTYPE = "";
			String	CDATE = "";
			String	UNAME = "";
			String	ZNFDATE = "";
			String	ZJHDATE = "";
			String	ZEDATE = "";
			String	ZZBNR = "";
			String	ZCOMMENT = "";
			String	ZKC = "";
			String	ZSJ = "";
			String	ZSGJL = "";
			String	ZZYFB = "";
			String	ZZGCLSB = "";
			String	ZXSDL = "";
			String	ZZBDL = "";
			String	ZTZJL = "";
			String	ZWYGS = "";
			String	ZZB = "";
			String	ZZLCGSB = "";
			String	ZOTHER = "";
			String	ZEMPLOYEE = "";
			
			//add by jyy 20160824
			String ZZBDLNR = "";
			String ZTZJLNR = "";
			String ZBXGYS = "";
			String ZPBXZ = "";
			String ZJHLX = "";
			
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
			String	ZBPBJ_2 = "";
			String	ZYDSP2_2 = "";
			String	ZYDSP3_2 = "";
			String	ZCGGCL_2 = "";
			String	ZJLDW_2 = "";
			String	ZHBLX_2 = "";
			String	ZPPSP4_2 = "";
			String	ZBZ_2 = "";
			
			//明细表ET_FILES字段
			String	BANFN_3 = "";//招标编号
			String	ZFILE_NO_3 = "";//文件编号
			String	ZWJMC_3 = "";//附件名称
			String	ZFILE_PATH_3 = "";//文件路径
			String	UNAME_3 = "";//用户名
			String	DATUM_3 = "";//日期
			
			//新生成的requestid
			String returnStr = "";
			int requestid =0;
			String tablename = "";
			
			if(out.getNumRows()>0){
				for (int i = 0; i < out.getNumRows(); i++) {
					out.setRow(i);
					BANFN = out.getString("BANFN");
					ZZBNAME = out.getString("ZZBNAME");
					BUTXT = out.getString("BUTXT");
					POST1 = out.getString("POST1");
					ZJZLX = out.getString("ZJZLX");
					ZCGGCL = out.getString("ZCGGCL");
					ZJLDW = out.getString("ZJLDW");
					ZHBLX = out.getString("ZHBLX");
					ZCBTYPE = out.getString("ZCBTYPE");
					CDATE = out.getString("CDATE");
					UNAME = out.getString("UNAME");
					ZNFDATE = out.getString("ZNFDATE");
					ZJHDATE = out.getString("ZJHDATE");
					ZEDATE = out.getString("ZEDATE");
					ZZBNR = out.getString("ZZBNR");
					ZCOMMENT = out.getString("ZCOMMENT");
					ZKC = out.getString("ZKC");
					ZSJ = out.getString("ZSJ");
					ZSGJL = out.getString("ZSGJL");
					ZZYFB = out.getString("ZZYFB");
					ZZGCLSB = out.getString("ZZGCLSB");
					ZXSDL = out.getString("ZXSDL");
					ZZBDL = out.getString("ZZBDL");
					ZTZJL = out.getString("ZTZJL");
					ZWYGS = out.getString("ZWYGS");
					ZZB = out.getString("ZZB");
					ZZLCGSB = out.getString("ZZLCGSB");
					ZOTHER = out.getString("ZOTHER");
					ZEMPLOYEE = out.getString("ZEMPLOYEE");
					//add by jyy 20160824
					ZZBDLNR = out.getString("ZZBDLNR"); 
					ZTZJLNR = out.getString("ZTZJLNR"); 
					ZBXGYS = out.getString("ZBXGYS"); 
					ZPBXZ = out.getString("ZPBXZ"); 
					ZJHLX = out.getString("ZJHLX"); 
					logBean.writeLog("初始接收到的sap参数：BANFN=" + BANFN + "||ZZBNAME=" + ZZBNAME + "||BUTXT=" + BUTXT + "||POST1=" + POST1
							+ "||ZJZLX=" + ZJZLX + "||ZCGGCL=" + ZCGGCL + "||ZJLDW=" + ZJLDW + "||ZHBLX=" + ZHBLX + "||ZCBTYPE=" + ZCBTYPE + "||CDATE=" + CDATE
							+ "||UNAME=" + UNAME + "||ZNFDATE=" + ZNFDATE + "||ZJHDATE=" + ZJHDATE + "||ZEDATE=" + ZEDATE + "||ZZBNR=" + ZZBNR + "||ZCOMMENT=" + ZCOMMENT
							+ "||ZKC=" + ZKC + "||ZSJ=" + ZSJ + "||ZSGJL=" + ZSGJL + "||ZZYFB=" + ZZYFB + "||ZZGCLSB=" + ZZGCLSB + "||ZXSDL=" + ZXSDL
							+ "||ZZBDL=" + ZZBDL + "||ZTZJL=" + ZTZJL + "||ZWYGS=" + ZWYGS + "||ZZB=" + ZZB + "||ZZLCGSB=" + ZZLCGSB + "||ZOTHER=" + ZOTHER
							+ "||ZEMPLOYEE=" + ZEMPLOYEE + "||ZZBDLNR=" + ZZBDLNR + "||ZTZJLNR=" + ZTZJLNR + "||ZBXGYS=" + ZBXGYS + "||ZPBXZ=" + ZPBXZ + "||ZJHLX=" + ZJHLX
							);
					/*
					 * 初始接收到的sap参数：BANFN=2000000103||ZZBNAME=DRVDER||BUTXT=上海地产北部投资发展有限公司||POST1=宝山顾村大型居住社区拓展基地征地工程房屋及土地征收||ZJZLX=商业||ZCGGCL=32500.00
					 * ||ZJLDW=立方米||ZHBLX=324540900.00||ZCBTYPE=公开招标||CDATE=2016-11-18||UNAME=WANGHT||ZNFDATE=0000-00-00||ZJHDATE=2016-08-24||ZEDATE=2016-08-30||ZZBNR=||ZCOMMENT=||ZKC=
					 * ||ZSJ=||ZSGJL=||ZZYFB=||ZZGCLSB=||ZXSDL=||ZZBDL=||ZTZJL=||ZWYGS=||ZZB=是||ZZLCGSB=||ZOTHER=||ZEMPLOYEE=1324||ZZBDLNR=||ZTZJLNR=||ZBXGYS=||ZPBXZ=||ZJHLX=9
					 */
					//ZEMPLOYEE = "40";
					//ZEMPLOYEE = "3110";
					returnStr = createWorkflow(BANFN,ZZBNAME,BUTXT,POST1,ZJZLX,
											   ZCGGCL,ZJLDW,ZHBLX,ZCBTYPE,CDATE,
											   UNAME,ZNFDATE,ZJHDATE,ZEDATE,ZZBNR,
											   ZCOMMENT,ZKC,ZSJ,ZSGJL,ZZYFB,
											   ZZGCLSB,ZXSDL,ZZBDL,ZTZJL,ZWYGS,
											   ZZB,ZZLCGSB,ZOTHER,ZEMPLOYEE,ZZBDLNR,ZTZJLNR,ZBXGYS,ZPBXZ,ZJHLX);
					String[] str = returnStr.split(",");
					requestid = Util.getIntValue(str[0],0);
					tablename = str[1];
					logBean.writeLog("biddingApply new requestid =" +returnStr);
					//明细表1循环
					if(outD_1.getNumRows()>0){
						for (int j = 0; j < outD_1.getNumRows(); j++) {
							outD_1.setRow(j);
							BANFN_1 = outD_1.getString("BANFN");
							if(BANFN.equals(BANFN_1) ){
								ZITEM_1 = outD_1.getString("ZITEM");
								ZZBNAME_1 = outD_1.getString("ZZBNAME");
								ZYDSP2_1 = outD_1.getString("ZYDSP2");
								ZYDSP3_1 = outD_1.getString("ZYDSP3");
								ZCGGCL_1 = outD_1.getString("ZCGGCL");
								ZJLDW_1 = outD_1.getString("ZJLDW");
								ZHBLX_1 = outD_1.getString("ZHBLX");
								ZBZ_1 = outD_1.getString("ZBZ");
								
								String detialInfo = requestid+","+BANFN_1+","+ZITEM_1+","+ZZBNAME_1+","+ZYDSP2_1
												+","+ZYDSP3_1+","+ZCGGCL_1+","+ZJLDW_1+","+ZHBLX_1+","+ZBZ_1+",";
								logBean.writeLog("OA明细表1插入数据信息 = "+detialInfo);
								dt1List.add(detialInfo);
							}	
						}			
					}else if (outD_1.getNumRows()==0){
						String detialInfo = "";
						logBean.writeLog("outD_1.detial1Info = "+detialInfo);
						dt1List.add(detialInfo);
					}
					
					//明细表2循环
					if(outD_2.getNumRows()>0){
						for (int k = 0; k < outD_2.getNumRows(); k++) {
							outD_2.setRow(k);
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
								
								String detialInfo = requestid+","+BANFN_2+","+ZBPBJ_2+","+ZYDSP2_2+","+ZYDSP3_2
												+","+ZCGGCL_2+","+ZJLDW_2+","+ZHBLX_2+","+ZPPSP4_2+","+ZBZ_2;
								logBean.writeLog("OA明细表2插入数据信息 = "+detialInfo);
								dt2List.add(detialInfo);
							}	
						}			
					}else if (outD_2.getNumRows()==0){
						String detialInfo = "";
						logBean.writeLog("outD_2.detialInfo = "+detialInfo);
						dt2List.add(detialInfo);
					}
					
					//明细表3循环
					if(outD_3.getNumRows()>0){
						for (int k = 0; k < outD_3.getNumRows(); k++) {
							outD_3.setRow(k);
							BANFN_3 = outD_3.getString("BANFN");
							if(BANFN.equals(BANFN_3) ){
								ZFILE_NO_3 = outD_3.getString("ZFILE_NO");
								ZWJMC_3 = outD_3.getString("ZWJMC");
								ZFILE_PATH_3 = outD_3.getString("ZFILE_PATH");
								UNAME_3 = outD_3.getString("UNAME");
								DATUM_3 = outD_3.getString("DATUM");
								String WZLJ = "<a href="+ZFILE_PATH_3+">"+ZWJMC_3+"</a>";
								logBean.writeLog("ZWJMC_3=" + ZWJMC_3 + "||ZFILE_PATH_3=" + ZFILE_PATH_3);
								String detialInfo = requestid+","+BANFN_3+","+ZFILE_NO_3+","+ZWJMC_3+","+WZLJ
										+","+UNAME_3+","+DATUM_3;
								logBean.writeLog("OA明细表3插入数据信息 = "+detialInfo);
								dt3List.add(detialInfo);
							}	
						}			
					}else if (outD_3.getNumRows()==0){
						String detialInfo = "";
						logBean.writeLog("outD_3.detialInfo = "+detialInfo);
						dt3List.add(detialInfo);
					}
				}

			}
			SAPConn.releaseC(myConnection);
			
			RecordSet rs1 = new RecordSet();
			RecordSet rs = new RecordSet();
			RecordSet rs2 = new RecordSet();
			RecordSet rs3= new RecordSet();
			RecordSet rs4= new RecordSet();
			//明细表1
			if(dt1List.size()>0){
				for(int m=0;m<dt1List.size();m++){
				String[] dt1Param = dt1List.get(m).split(",",-1);
//				for(int n=0;n<dt1Param.length;n++){
//					System.out.println("detialParam["+n+"]="+dt1Param[n]);
//				}
					//获取主表id
					String sql = "select id from "+tablename+" where requestid = '"+dt1Param[0]+"'";
					logBean.writeLog(sql);
					rs1.executeSql(sql);
					while(rs1.next()){
						String mainid = Util.null2String(rs1.getString("id"));
						System.out.println("mainid = "+mainid);
						String insertSQL = "insert into  "+tablename+"_dt1(" +
								"mainid,BANFN1,ZITEM,ZZBNAME,ZYDSP2," +
								"ZYDSP3,ZCGGCL,ZJLDW,ZHBLX,ZBZ) " +
								"values ('"
								+mainid+"','"+dt1Param[1]+"','"+dt1Param[2]+"','"+dt1Param[3]+"','"+dt1Param[4]
								+"','"+dt1Param[5]+"','"+dt1Param[6]+"','"+dt1Param[7]+"','"+dt1Param[8]+"','"+dt1Param[9]
								+"')";
						logBean.writeLog("插入OA明细表1SQL="+insertSQL);
						rs.executeSql(insertSQL);		
					}
				}
			}
			
			//明细表2
			if(dt2List.size()>0){
				for(int n=0;n<dt2List.size();n++){
				String[] dt2Param = dt2List.get(n).split(",",-1);
//				for(int m1=0;m1<dt2Param.length;m1++){
//					System.out.println("dt2Param["+m1+"]="+dt2Param[m1]);
//				}
					//获取主表id
					String sql = "select id from "+tablename+" where requestid = '"+dt2Param[0]+"'";
					logBean.writeLog(sql);
					rs2.executeSql(sql);
					while(rs2.next()){
						String mainid = Util.null2String(rs2.getString("id"));
						System.out.println("mainid = "+mainid);
						String insertSQL = "insert into  "+tablename+"_dt2(" +
								"mainid,BANFN2,ZBPBJ,ZYDSP22,ZYDSP32," +
								"ZCGGCL2,ZJLDW2,ZHBLX2,ZPPSP4,ZBZ2) " +
								"values ('"
								+mainid+"','"+dt2Param[1]+"','"+dt2Param[2]+"','"+dt2Param[3]+"','"+dt2Param[4]+
								"','"+dt2Param[5]+"','"+dt2Param[6]+"','"+dt2Param[7]+"','"+dt2Param[8]+"','"+dt2Param[9]+
								"')";
						logBean.writeLog("插入OA明细表2SQL="+insertSQL);
						rs3.executeSql(insertSQL);
					}
				}
			}
				
			//明细表3
			if(dt3List.size()>0){
				for(int n=0;n<dt3List.size();n++){
					String[] dt3Param = dt3List.get(n).split(",",-1);
					//获取主表id
					String sql = "select id from "+tablename+" where requestid = '"+dt3Param[0]+"'";
					logBean.writeLog(sql);
					rs3.executeSql(sql);
					while(rs3.next()){
						String mainid = Util.null2String(rs3.getString("id"));
						System.out.println("mainid = "+mainid);
						String insertSQL = "insert into  "+tablename+"_dt3(" +
								"mainid,BANFN,ZFILE_NO,ZWJMC,ZFILE_PATH," +
								"UNAME,DATUM) " +
								"values ('"
								+mainid+"','"+dt3Param[1]+"','"+dt3Param[2]+"','"+dt3Param[3]+"','"+    dt3Param[4]+"','"+dt3Param[5]+"','"+dt3Param[6]+
								"')";
						logBean.writeLog("插入OA明细表3SQL="+insertSQL);
						rs4.executeSql(insertSQL);
					}
				}
			}
			logBean.writeLog("===========招标申请同步结束=============");
		}else{
			logBean.writeLog("SAP connection fail");
		}
		
	}


	/**
	 * 
	* @Title: createWorkflow
	* @Description: TODO
	* @param @param BANFN
	* @param @param ZZBNAME
	* @param @param BUTXT
	* @param @param POST1
	* @param @param ZJZLX
	* @param @param ZCGGCL
	* @param @param ZJLDW
	* @param @param ZHBLX
	* @param @param ZCBTYPE
	* @param @param CDATE
	* @param @param UNAME
	* @param @param ZNFDATE
	* @param @param ZJHDATE
	* @param @param ZEDATE
	* @param @param ZZBNR
	* @param @param ZCOMMENT
	* @param @param ZKC
	* @param @param ZSJ
	* @param @param ZSGJL
	* @param @param ZZYFB
	* @param @param ZZGCLSB
	* @param @param ZXSDL
	* @param @param ZZBDL
	* @param @param ZTZJL
	* @param @param ZWYGS
	* @param @param ZZB
	* @param @param ZZLCGSB
	* @param @param ZOTHER
	* @param @param ZEMPLOYEE
	* @param @param ZZBDLNR
	* @param @param ZTZJLNR
	* @param @param ZBXGYS
	* @param @param ZPBXZ
	* @param @param ZJHLX
	* @param @return    
	* @return String    
	* @throws
	 */
	
	private String createWorkflow(String BANFN, String ZZBNAME, String BUTXT,String POST1, String ZJZLX,
								String ZCGGCL, String ZJLDW,String ZHBLX, String ZCBTYPE, String CDATE, 
								String UNAME,String ZNFDATE, String ZJHDATE, String ZEDATE, String ZZBNR,
								String ZCOMMENT, String ZKC, String ZSJ, String ZSGJL,String ZZYFB, 
								String ZZGCLSB, String ZXSDL, String ZZBDL,String ZTZJL, String ZWYGS, 
								String ZZB, String ZZLCGSB,String ZOTHER, String ZEMPLOYEE,String ZZBDLNR,
								String ZTZJLNR,String ZBXGYS,String ZPBXZ,String ZJHLX) {
		String newRequestid = "-1000";
		String resourceid = ZEMPLOYEE;
		
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
		String subcompanyid_1 = "";
		String departmentid = "";
		rs.executeSql("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
		rs.writeLog("select lastname,subcompanyid1 from hrmresource where id = '"+ZEMPLOYEE+"'");
		while(rs.next()){
			subcompanyid_1 = Util.null2String(rs.getString("subcompanyid1")); //所属公司取值
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
			lastname =  Util.null2String(rs.getString("lastname"));
		}
		
		if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGXING","subcompanyid"))){
			workflowid = baseBean.getPropValue("SAPZHONGXING","ApplyWorkflowid");//中星招标申请流程的workflowid
			description = "中星集团招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");
			logBean.writeLog("=============中星招标申请=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPBEITOU","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPBEITOU","ApplyWorkflowid");//招标申请流程的workflowid
			 description = "北投招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");;
			 logBean.writeLog("=============北投招标申请招标=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPSANLIN","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPSANLIN","ApplyWorkflowid");//招标申请流程的workflowid
			 description = "三林招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");;
			 logBean.writeLog("=============三林招标申请招标申请=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHONGHUA","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHONGHUA","ApplyWorkflowid");//招标申请流程的workflowid
			 description = "中华招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");;
			 logBean.writeLog("=============中华招标申请=================="+workflowid);
		}else if(subcompanyid.equals(baseBean.getPropValue("SAPZHUBAO","subcompanyid"))){
			 workflowid = baseBean.getPropValue("SAPZHUBAO","ApplyWorkflowid");//招标申请流程的workflowid
			 description = "住保招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");;
			 logBean.writeLog("=============住保招标申请=================="+workflowid);
		}
//		else if(subcompanyid.equals(baseBean.getPropValue("SAPJTBB","subcompanyid"))){
//		 workflowid = baseBean.getPropValue("SAPJTBB","ApplyWorkflowid");//招标申请流程的workflowid
//		 description = "集团本部招标申请"+"-"+lastname+"-"+TODAY.replace("-", "");;
//		 logBean.writeLog("=============集团本部招标申请=================="+workflowid);
//	}
		
		String SQL = "select tablename from workflow_base wb,workflow_bill wbi where  wb.formid = wbi.id and wb.id = '"+workflowid+"'";
		rs1.executeSql(SQL);
		while(rs1.next()){
			tablename = Util.null2String(rs1.getString("tablename"));
		}
		//String workflowid = "2664";//招标申请流程的workflowid
		//logBean.writeLog("=============jituanbenbu招标申请流程的workflowid=================="+workflowid);

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
		
		//String BANFN, String ZZBNAME, String BUTXT,String POST1, String ZJZLX,
		field = new Property();
		field.setName("BANFN");
		field.setValue(BANFN);
		fields.add(field);
		
		field = new Property();
		field.setName("ZZBNAME");
		field.setValue(ZZBNAME);
		fields.add(field);
		
		field = new Property();
		field.setName("BUTXT");
		field.setValue(BUTXT);
		fields.add(field);
		
		field = new Property();
		field.setName("POST1");
		field.setValue(POST1);
		fields.add(field);
		
		field = new Property();
		field.setName("ZJZLX");
		field.setValue(ZJZLX);
		fields.add(field);
		
		//String ZCGGCL, String ZJLDW,String ZHBLX, String ZCBTYPE, String CDATE, 
		field = new Property();
		field.setName("ZCGGCL");
		field.setValue(ZCGGCL);
		fields.add(field);
		
		field = new Property();
		field.setName("ZJLDW");
		field.setValue(ZJLDW);
		fields.add(field);
		
		field = new Property();
		field.setName("ZHBLX");
		field.setValue(ZHBLX);
		fields.add(field);
		
		field = new Property();
		field.setName("ZCBTYPE");
		field.setValue(ZCBTYPE);
		fields.add(field);
		
		field = new Property();
		field.setName("CDATE");
		field.setValue(CDATE);
		fields.add(field);
		
		//String UNAME,String ZNFDATE, String ZJHDATE, String ZEDATE, String ZZBNR,
		field = new Property();
		field.setName("UNAME");
		field.setValue(UNAME);
		fields.add(field);

		field = new Property();
		field.setName("ZNFDATE");
		field.setValue(ZNFDATE);
		fields.add(field);
		
		field = new Property();
		field.setName("ZJHDATE");
		field.setValue(ZJHDATE);
		fields.add(field);

		field = new Property();
		field.setName("ZEDATE");
		field.setValue(ZEDATE);
		fields.add(field);
		
		field = new Property();
		field.setName("ZZBNR");
		field.setValue(ZZBNR);
		fields.add(field);
		
		//String ZCOMMENT, String ZKC, String ZSJ, String ZSGJL,String ZZYFB, 
		field = new Property();
		field.setName("ZCOMMENT");
		field.setValue(ZCOMMENT);
		fields.add(field);
		
		field = new Property();
		field.setName("ZKC");
		field.setValue(ZKC);
		fields.add(field);
		
		field = new Property();
		field.setName("ZSJ");
		field.setValue(ZSJ);
		fields.add(field);
		
		field = new Property();
		field.setName("ZSGJL");
		field.setValue(ZSGJL);
		fields.add(field);
		
		field = new Property();
		field.setName("ZZYFB");
		field.setValue(ZZYFB);
		fields.add(field);
		
		//String ZZGCLSB, String ZXSDL, String ZZBDL,String ZTZJL, String ZWYGS, 

		field = new Property();
		field.setName("ZZGCLSB");
		field.setValue(ZZGCLSB);
		fields.add(field);
		
		field = new Property();
		field.setName("ZXSDL");
		field.setValue(ZXSDL);
		fields.add(field);
		
		field = new Property();
		field.setName("ZZBDL");
		field.setValue(ZZBDL);
		fields.add(field);
		
		field = new Property();
		field.setName("ZTZJL");
		field.setValue(ZTZJL);
		fields.add(field);
		
		field = new Property();
		field.setName("ZWYGS");
		field.setValue(ZWYGS);
		fields.add(field);
		
		//String ZZB, String ZZLCGSB,String ZOTHER, String ZEMPLOYEE	
		field = new Property();
		field.setName("ZZB");
		field.setValue(ZZB);
		fields.add(field);
		
		field = new Property();
		field.setName("ZZLCGSB");
		field.setValue(ZZLCGSB);
		fields.add(field);
		
		field = new Property();
		field.setName("ZOTHER");
		field.setValue(ZOTHER);
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
				field.setName("ZZBDLNR");
				field.setValue(ZZBDLNR);
				fields.add(field);

				field = new Property();
				field.setName("ZTZJLNR");
				field.setValue(ZTZJLNR);
				fields.add(field);

				field = new Property();
				field.setName("ZBXGYS");
				field.setValue(ZBXGYS);
				fields.add(field);

				field = new Property();
				field.setName("ZPBXZ");
				field.setValue(ZPBXZ);
				fields.add(field);

				field = new Property();
				field.setName("ZJHLX");
				field.setValue(ZJHLX);
				fields.add(field);
		
		
		Property[] fieldarray = (Property[]) fields.toArray(new Property[fields.size()]);
		mainTableInfo.setProperty(fieldarray);
		requestInfo.setMainTableInfo(mainTableInfo);
		
		try {
			newRequestid = requestService.createRequest(requestInfo);
			logBean.writeLog("======创建流程时新生成的id======="+newRequestid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logBean.writeLog("插入失败！！！");
			e.printStackTrace();	
		}
		return newRequestid+","+tablename;
	}
}

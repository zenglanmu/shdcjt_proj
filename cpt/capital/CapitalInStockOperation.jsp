<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%--<%@ page import="weaver.cpt.capital.InsertWorker" %>--%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="temprs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="CodeBuild" class="weaver.system.code.CodeBuild" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%

char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;
String lastmoderid = ""+user.getUID();

//--------------
String Id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
//String Invoice = Util.fromScreen(request.getParameter("Invoice"),user.getLanguage());
String BuyerID = Util.fromScreen(request.getParameter("BuyerID"),user.getLanguage());
String supplierid = Util.fromScreen(request.getParameter("customerid"),user.getLanguage());
String checkerid = Util.fromScreen(request.getParameter("CheckerID"),user.getLanguage());
String stockindate = Util.fromScreen(request.getParameter("StockInDate"),user.getLanguage());
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);

	String para1 = "";
	para1 =Id;
    para1 +=separator+stockindate;
    para1 +=separator+BuyerID;
    para1 +=separator+supplierid;
    para1 +=separator+checkerid;
    para1 +=separator+"";
	para1 +=separator+"1";
    RecordSet.executeProc("CptStockInMain_Update",para1);

	String detailid="";
	String cpttype="";
	String innumber="";
	String price="";
    String customerid="";
    String capitalspec="";
    String location="";
    String Invoice="";
	String sptcount1="";
	String contractno="";
	int i=0;
	int j=0;
	int v=0;

for (i=0;i<totaldetail;i++){
	detailid =request.getParameter("node_"+i+"_id");
	cpttype = request.getParameter("node_"+i+"_cptid");
	innumber = request.getParameter("node_"+i+"_innumber");
	price = request.getParameter("node_"+i+"_unitprice");
    customerid = request.getParameter("node_"+i+"_customerid");
    capitalspec = request.getParameter("node_"+i+"_capitalspec");
    location = request.getParameter("node_"+i+"_location");
    Invoice = request.getParameter("node_"+i+"_Invoice");
	contractno = request.getParameter("node_"+i+"_contractno");
    String tempselectdate=request.getParameter("node_"+i+"_stockindate");

	RecordSetInner.executeProc("CptCapital_SelectByID",cpttype);
    if(RecordSetInner.next()){
    	sptcount1 = RecordSetInner.getString("sptcount");
    }

	if(sptcount1.equals("1")){ //单独核算根据实际入库的数量每个资产单独为一条记录（先删除原来的记录）
        para1 =detailid;
        RecordSet.executeProc("CptStockInDetail_Delete",para1);

        for (j=1,v=(int)Util.getFloatValue(innumber,0);j<=v;j++){
            para1 = Id;
            para1 +=separator+cpttype;
            para1 +=separator+"1";
            para1 +=separator+"1";
            para1 +=separator+price;
            para1 +=separator+customerid;
            para1 +=separator+tempselectdate;
            para1 +=separator+capitalspec;
            para1 +=separator+location;
            para1 +=separator+Invoice;

            RecordSet.executeProc("CptStockInDetail_Insert",para1);
			if(RecordSet.next()){
				String tempdetailid = Util.null2String(RecordSet.getString(1));
				if(!tempdetailid.equals("")&&!tempdetailid.equals("0")){
					RecordSet.executeSql("update CptStockInDetail set contractno = '" + contractno + "' where id = " + tempdetailid);
				}			
			}
        }
	}else{  //非单独核算根据实际入库的数量直接更新实际入库的数据
        para1 = detailid;
        para1 +=separator+innumber;
    	RecordSet.executeProc("CptStockInDetail_Update",para1);
	}
}


String departmentid = "" + Util.getIntValue(request.getParameter("CptDept_to"),0);  //入库部门
String requestid 	= "0";     //该工作流的相关工作流

String resourceid = "0";		//申购人
String stateid  = "1";

String capitalid = "";
String tempmark = "";
String isinner = "";
String startdate = "";
String enddate = "";
String deprestartdate = "";
String depreenddate = "";
String manudate = "";
//String location = "";
String num = "";
String tempid = "";
String tempstr = "";
String para = "";
String sptcount = "";
String rltid = "";
String relatefee = "";//流转相关金额
String capitalgroupid = "";
//String capitalspec = "";
String selectdate ="";//购置日期
String counttype = "";
String capitaltypeid = "";//资产类型
String blongsubcompany = "";//所属分部
String blongdepartment = "";//所属部门


ArrayList ids = new ArrayList();

RecordSet.executeProc("CptStockInDetail_SByStockid",Id);
out.print("正在资产入库，请稍候..."+"<BR>");
while(RecordSet.next()){
//从从表中获得
	tempid = RecordSet.getString("id");
	capitalid = RecordSet.getString("cpttype");
	num = RecordSet.getString("innumber");
    double innum = Util.getDoubleValue(num);
    BigDecimal inprice = new BigDecimal(RecordSet.getString("price"));
    customerid=RecordSet.getString("customerid");
    capitalspec=RecordSet.getString("capitalspec");
    location=RecordSet.getString("location");
    Invoice=RecordSet.getString("Invoice");
    //stockindate=RecordSet.getString("selectDate");
	selectdate=RecordSet.getString("selectDate");
	contractno=RecordSet.getString("contractno");

	relatefee = inprice.multiply(new BigDecimal(num)).toString();
	
	RecordSetInner.executeProc("CptCapital_SelectByID",capitalid);
    if(RecordSetInner.next()){
    	tempmark = RecordSetInner.getString("mark");
    	sptcount = RecordSetInner.getString("sptcount");
    	//capitalspec = RecordSetInner.getString("capitalspec");
    	capitalgroupid = RecordSetInner.getString("capitalgroupid");
		capitaltypeid = RecordSetInner.getString("capitaltypeid");
    }

    //判断是否固资或低耗1:固资2:低耗
    String tempstr2 = "2,3,4,5,6,7,8,9";
    String rootgroupid = capitalgroupid;
    while(true){
		if((CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid)).equals("0")){
			break;
		}
		rootgroupid = CapitalAssortmentComInfo.getSupAssortmentId(rootgroupid);
	}
	
    if(inprice.compareTo(new BigDecimal("2000"))==1){   //单独核算的资产(固资或低耗)
        counttype = "1";
    }else{
        counttype = "2";
    }

	/**	
	//自动生成编号
	String	markstr = "";
	int markint = 0;
    int len=5;
    //流水号长度默认为5位当超过最大值自动扩展一位.
    RecordSetInner.executeProc("CptCapital_SCountByDataType",capitalid);
    if(RecordSetInner.next()){
		markstr = Util.null2String(RecordSetInner.getString(1));
		if (!markstr.equals("")  && markstr.length()>tempmark.length()) {
            markstr = markstr.substring(tempmark.length());
            markint = Util.getIntValue(markstr,0);
		}
    }
    if(len<String.valueOf(markint+1).length()){
        len=String.valueOf(markint+1).length();
    }
    tempmark = tempmark+Util.add0(markint+1,len);
	**/

	blongsubcompany = DepartmentComInfo.getSubcompanyid1(departmentid);
	blongdepartment = departmentid;
	
	//获得资产编号
	if(sptcount.equals("1")){
		tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
	}
	
	RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
    if(!sptcount.equals("1") && RecordSetInner.next()){
        tempmark = RecordSetInner.getString("mark");
    }else if(!sptcount.equals("1")){
    	tempmark = CodeBuild.getCurrentCapitalCode(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid,capitaltypeid,selectdate,stockindate,capitalid);
    }
	
	//如果是非单独核算并且部门有此资产那么编号不变

	para = stockindate;//入库日期
	para +=separator+"";//流转至部门
	para +=separator+resourceid; //流转至人
	para +=separator+checkerid; //入库人
	para +=separator+num; //流转数量
	para +=separator+location;
	para +=separator+requestid;
	para +=separator+"";//相关公司(入库无)
	para +=separator+relatefee;//相关金额
	para +=separator+stateid;//流转后的状态(使用或库存)
	para +=separator+"";//流转原因(暂空)
	para +=separator+tempmark;//自动生成的资产编号
	para +=separator+capitalid;//datetype
	para +=separator+startdate;
	para +=separator+enddate;
	para +=separator+deprestartdate;
	para +=separator+depreenddate;
	para +=separator+manudate;
	para += separator+lastmoderid;
	para += separator+currentdate;
	para += separator+currenttime;

	//复制卡片
    if(sptcount.equals("1")){
        //单独核算
        //复制一项
        para1 =capitalid;
        para1 +=separator+customerid;
        para1 +=separator+""+inprice;
        para1 +=separator+capitalspec;
        para1 +=separator+location;
        para1 +=separator+Invoice;
        para1 +=separator+stockindate;//入库日期
        para1 +=separator+selectdate;//购置日期

        RecordSetInner.executeProc("CptCapital_Duplicate",para1);
        RecordSetInner.next();
        rltid =RecordSetInner.getString(1);

        para = rltid+separator+para;
        para += separator+""+inprice;
        para += separator+customerid;
        para += separator+counttype;
        para += separator+isinner;
        //更新信息,加入入库信息
        RecordSetInner.executeProc("CptUseLogInStock_Insert",para);

        RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"',contractno='"+contractno+"' where id = " + rltid);
		
		String sqlstr = "select * from cptcapitalparts where cptid = " + capitalid;
		//new BaseBean().writeLog(sqlstr);
		temprs.executeSql(sqlstr);
		while(temprs.next()){
		  sqlstr = "insert into cptcapitalparts (cptid,partsname,partsspec,partssum,partsweight,partssize) select " +rltid+",partsname,partsspec,partssum,partsweight,partssize from cptcapitalparts where id = " + temprs.getString("id");
		  rs.executeSql(sqlstr);
		  //new BaseBean().writeLog(sqlstr);
		}
		sqlstr = "select * from cptcapitalequipment where cptid = " + capitalid;
		temprs.executeSql(sqlstr);
		//new BaseBean().writeLog(sqlstr);
		while(temprs.next()){
		  sqlstr = "insert into cptcapitalequipment (cptid,equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage) select "+rltid+",equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage from cptcapitalequipment where id = " + temprs.getString("id");
		  rs.executeSql(sqlstr);
		  //new BaseBean().writeLog(sqlstr);
		}
		
		
        //给资产加上权限未经测试
        String ProcPara ="";
        String sharetype="";
        String seclevel="";
        String rolelevel="";
        String sharelevel= "";
        String userid= "";
        String sharedepartmentid="";
        String roleid= "";
        String foralluser= "";

        //判断资产的跟类rootgroupid的权限
        RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
        while (RecordSetInner.next()){
            sharetype= RecordSetInner.getString("sharetype");
            seclevel= RecordSetInner.getString("seclevel");
            rolelevel= RecordSetInner.getString("rolelevel");
            sharelevel= RecordSetInner.getString("sharelevel");
            userid= RecordSetInner.getString("userid");
            sharedepartmentid= RecordSetInner.getString("departmentid");
            roleid= RecordSetInner.getString("roleid");
            foralluser= RecordSetInner.getString("foralluser");

            ProcPara = rltid;
            ProcPara += separator+sharetype;
            ProcPara += separator+seclevel;
            ProcPara += separator+rolelevel;
            ProcPara += separator+sharelevel;
            ProcPara += separator+userid;
            ProcPara += separator+sharedepartmentid;
            ProcPara += separator+roleid;
            ProcPara += separator+foralluser;

            RecordSet1.executeProc("CptCapitalShareInfo_Insert",ProcPara);//把资产加入到CptCapitalShareInfo表里
        }
        CptShare.setCptShareByCpt(rltid);//更新detail表

        ids.add(rltid);
    }else{
        //非单独核算
        RecordSetInner.executeProc("CptCapital_SelectByDataType",capitalid+separator+departmentid);
        if(RecordSetInner.next()){
            //该部门已有该资产
            //费用平均
            rltid = RecordSetInner.getString("id");
            BigDecimal oldprice = new BigDecimal(RecordSetInner.getString("startprice"));
            BigDecimal oldnum   = new BigDecimal(RecordSetInner.getString("capitalnum"));
            inprice = inprice.multiply(new BigDecimal(num));
            inprice = inprice.add(oldprice.multiply(oldnum));
            inprice = inprice.divide(oldnum.add(new BigDecimal(num)),2,BigDecimal.ROUND_UP);
            //inprice = (oldprice*oldnum+inprice*Util.getDoubleValue(num))/(oldnum+innum);

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);

            //修改资产卡片的参考价格为入库价格
            para1 =rltid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+customerid;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;
            RecordSetInner.executeProc("CptCapital_UpdatePrice",para1);  
        }else{
            //该部门没有该资产
            //复制一项
            para1 =capitalid;
            para1 +=separator+customerid;
            para1 +=separator+""+inprice;
            para1 +=separator+capitalspec;
            para1 +=separator+location;
            para1 +=separator+Invoice;
            para1 +=separator+stockindate;//入库日期
            para1 +=separator+selectdate;//购置日期

            RecordSetInner.executeProc("CptCapital_Duplicate",para1);
            RecordSetInner.next();
            rltid =RecordSetInner.getString(1);

            para = rltid+separator+para;
            para += separator+""+inprice;
            para += separator+customerid;
            para += separator+counttype;
            para += separator+isinner;

            //更新信息,加入入库信息
            RecordSetInner.executeProc("CptUseLogInStock_Insert",para);

            RecordSetInner.executeSql("update cptcapital set olddepartment = " + departmentid + ",blongsubcompany='"+ blongsubcompany +"', blongdepartment='"+ blongdepartment +"',contractno='"+contractno+"' ,capitalnum='"+innum+"'  where id = " + rltid);

			String sqlstr = "select * from cptcapitalparts where cptid = " + capitalid;
			//new BaseBean().writeLog(sqlstr);
			temprs.executeSql(sqlstr);
			while(temprs.next()){
			  sqlstr = "insert into cptcapitalparts (cptid,partsname,partsspec,partssum,partsweight,partssize) select " +rltid+",partsname,partsspec,partssum,partsweight,partssize from cptcapitalparts where id = " + temprs.getString("id");
			  rs.executeSql(sqlstr);
			  //new BaseBean().writeLog(sqlstr);
			}
			sqlstr = "select * from cptcapitalequipment where cptid = " + capitalid;
			temprs.executeSql(sqlstr);
			//new BaseBean().writeLog(sqlstr);
			while(temprs.next()){
			  sqlstr = "insert into cptcapitalequipment (cptid,equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage) select "+rltid+",equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage from cptcapitalequipment where id = " + temprs.getString("id");
			  rs.executeSql(sqlstr);
			  //new BaseBean().writeLog(sqlstr);
			}

            //给资产加上权限未经测试
            String ProcPara ="";
            String sharetype="";
            String seclevel="";
            String rolelevel="";
            String sharelevel= "";
            String userid= "";
            String sharedepartmentid="";
            String roleid= "";
            String foralluser= "";
            //判断资产的跟类rootgroupid的权限
            RecordSetInner.executeSql("select * from CptAssortmentShare where assortmentid="+rootgroupid);
            while (RecordSetInner.next()){
                sharetype= RecordSetInner.getString("sharetype");
                seclevel= RecordSetInner.getString("seclevel");
                rolelevel= RecordSetInner.getString("rolelevel");
                sharelevel= RecordSetInner.getString("sharelevel");
                userid= RecordSetInner.getString("userid");
                sharedepartmentid= RecordSetInner.getString("departmentid");
                roleid= RecordSetInner.getString("roleid");
                foralluser= RecordSetInner.getString("foralluser");

                ProcPara = rltid;
                ProcPara += separator+sharetype;
                ProcPara += separator+seclevel;
                ProcPara += separator+rolelevel;
                ProcPara += separator+sharelevel;
                ProcPara += separator+userid;
                ProcPara += separator+sharedepartmentid;
                ProcPara += separator+roleid;
                ProcPara += separator+foralluser;

                RecordSet1.executeProc("CptCapitalShareInfo_Insert",ProcPara);//把资产加入到CptCapitalShareInfo表里                
            }
            CptShare.setCptShareByCpt(rltid);//更新detail表

            ids.add(rltid);
        }
    }

}//end while

CapitalComInfo.addCapitalCache(ids);

//update by fanggsh 20060511 TD4308 begin
PoppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(),11,"0",Util.getIntValue(Id));
//update by fanggsh 20060511 TD4308 end

response.sendRedirect("/cpt/search/CptInstockSearch.jsp");

%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
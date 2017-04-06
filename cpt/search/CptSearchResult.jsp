<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<%
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
}
String CurrentUser = ""+user.getUID();
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

//添加判断权限的内容--new

String tempsearchsql = CptSearchComInfo.FormatSQLSearch();
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	rightStr = "Capital:Maintenance";
}
String blonsubcomid = "";
int userId = user.getUID();
int belid = user.getUserSubCompany1();
String isdata = CptSearchComInfo.getIsData();
//权限条件 modify by ds Td:9699
if(detachable == 1 && userId!=1){
	if(isdata.endsWith("2")){
		String sqltmp = "";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
		while(rs2.next()){
		    blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);

				tempsearchsql += " and blongsubcompany in ("+sqltmp+") ";
		}else{
				tempsearchsql += " and blongsubcompany in ("+belid+") ";		
		}
	}
}
String type= Util.fromScreen(request.getParameter("type"),user.getLanguage()) ;

String strData="";
String strURL="";
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String titlename = "";
if(CptSearchComInfo.getIsData().equals("1")){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage());
}else{
	titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage());
}


String imagefilename = "/images/hdDOC.gif";
titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage())+" - "+titlename;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(type.equals("mycpt")){ 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(15362,user.getLanguage())+",/cpt/search/CptMyCapital.jsp?addorsub=3,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearchMycpt(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+"Excel,javascript:_xtable_getAllExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<%if(!isfromtab) {%>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

        <TABLE width="100%">
                <tr>
                  <td valign="top">
                      <%


                        //String backfields = "t1.id,t1.mark,t1.fnamark,t1.location,t1.name,t1.capitalspec,t1.capitalgroupid,t1.resourceid,t1.departmentid,t1.stateid,t1.stockindate,t1.sptcount,t1.depreyear,t1.deprerate,t1.selectdate";
                        String backfields = "t1.id";
                        String fromSql  = "";
                        String sqlWhere = "";
                        int resourceLabel =0;
                        if (CptSearchComInfo.getIsData().equals("1")){
                            fromSql  = " from CptCapital  t1 ";
                            sqlWhere =  tempsearchsql;
                            resourceLabel= 1507;
                        } else{
                            fromSql  = " from CptCapital  t1  , CptShareDetail  t2 ";
                            sqlWhere =  tempsearchsql+" and t1.id = t2.cptid and t2.userid="+ CurrentUser + " and t2.usertype = "+logintype;
							if(type.equals("mycpt")||type.equals("mycptdetail")) sqlWhere += " and t1.stateid <> 1 ";
                            resourceLabel= 1508;
                        }
                        String orderby = "t1.id" ;
                        String temptableString = "";
                        rs.executeSql("select * from CptSearchDefinition where istitle = 1 and mouldid = -1 order by displayorder asc");
						
                        while(rs.next()){
                        	String fieldname = rs.getString("fieldname");
                        	if(fieldname.equals("isdata")) continue;
                        	backfields = backfields + ",t1." + fieldname;
							
							if(fieldname.equals("mark")){//编号
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"mark\" orderkey=\"mark\" />";	
							}
							
							if(fieldname.equals("fnamark")){//财务编号
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15293,user.getLanguage())+"\" column=\"fnamark\" orderkey=\"fnamark\" />";	
					 		} 
							
							if(fieldname.equals("contractno")){//合同号
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21282,user.getLanguage())+"\" column=\"contractno\" orderkey=\"contractno\" />";
					 		}
							
							if(fieldname.equals("Invoice")){//发票号码
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(900,user.getLanguage())+"\" column=\"Invoice\" orderkey=\"Invoice\" />";
					 		}

							if(fieldname.equals("name")){//名称
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/cpt/capital/CptCapital.jsp\" target=\"_fullwindow\" />";
					 		}
 							
 							if(fieldname.equals("barcode")){//条形码
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1362,user.getLanguage())+"\" column=\"barcode\" orderkey=\"barcode\" />";
					 		}

							if(fieldname.equals("depreyear")){//折旧年限
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19598,user.getLanguage())+"\" column=\"depreyear\" orderkey=\"depreyear\" />";
					 		}

							if(fieldname.equals("deprerate")){//残值率
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1390,user.getLanguage())+"\" column=\"deprerate\" orderkey=\"deprerate\" />";
					 		}

							if(fieldname.equals("issupervision")){//是否海关监管
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22339,user.getLanguage())+"\" column=\"issupervision\" orderkey=\"issupervision\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.search.CapitalProperties.getIssupervision\" />";
					 		}

							if(fieldname.equals("capitalgroupid")){//资产组
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(831,user.getLanguage())+"\" column=\"capitalgroupid\" orderkey=\"capitalgroupid\"  transmethod=\"weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName\" />";
					 		}

							if(fieldname.equals("currencyid")){//币种
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(406,user.getLanguage())+"\" column=\"currencyid\" orderkey=\"currencyid\" transmethod=\"weaver.fna.maintenance.CurrencyComInfo.getCurrencyname\"/>";
					 		}
 							
 							if(fieldname.equals("startprice")){//价格/参考价格
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(726,user.getLanguage())+"\" column=\"startprice\" orderkey=\"startprice\" />";
					 		}
 							
 							if(fieldname.equals("amountpay")){//已付金额
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22338,user.getLanguage())+"\" column=\"amountpay\" orderkey=\"amountpay\" />";
					 		}
				 		
					 		if(fieldname.equals("capitaltypeid")){//资产类型
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(703,user.getLanguage())+"\" column=\"capitaltypeid\" orderkey=\"capitaltypeid\" transmethod=\"weaver.cpt.maintenance.CapitalTypeComInfo.getCapitalTypename\" />";
							}
					 		
					 		if(fieldname.equals("sptcount")){//单独核算
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1363,user.getLanguage())+"\" column=\"sptcount\" orderkey=\"sptcount\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.capital.CapitalComInfo.getIsSptCount\"/>";
							}
					 		
					 		if(fieldname.equals("relatewfid")){//相关工作流
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15295,user.getLanguage())+"\" column=\"relatewfid\" orderkey=\"relatewfid\" transmethod=\"weaver.cpt.search.CapitalProperties.getRequestName\"/>";
							}
					 		
					 		if(fieldname.equals("purchasestate")){//采购状态
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22333,user.getLanguage())+"\" column=\"purchasestate\" orderkey=\"purchasestate\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.search.CapitalProperties.getPurchasestate\" />";
							}
					 		
					 		if(fieldname.equals("isinner")){//帐内或帐外
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15297,user.getLanguage())+"\" column=\"isinner\" orderkey=\"isinner\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.search.CapitalProperties.getIsinner\" />";
							}
					 		
					 		if(fieldname.equals("startdate")){//生效日
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(717,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate\" />";
							}
					 		
					 		if(fieldname.equals("enddate")){//生效至
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(718,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\" />";
							}
					 		
					 		if(fieldname.equals("departmentid")){//使用部门
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21030,user.getLanguage())+"\" column=\"departmentid\"  orderkey=\"departmentid\" linkkey=\"id\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" target=\"_fullwindow\" />";
							}
					 		
					 		if(fieldname.equals("blongsubcompany")){//所属分部
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"blongsubcompany\" orderkey=\"blongsubcompany\" linkkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" href=\"/hrm/company/HrmDepartment.jsp\" target=\"_fullwindow\" />";
							}
					 		
					 		if(fieldname.equals("blongdepartment")){//所属部门
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15393,user.getLanguage())+"\" column=\"blongdepartment\" orderkey=\"blongdepartment\" linkkey=\"id\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/company/HrmDepartmentDsp.jsp\" target=\"_fullwindow\" />";
							}
					 		
					 		if(fieldname.equals("resourceid")){//人力资源/使用人/管理员
								temptableString +=   "<col width=\"7%\"   text=\""+SystemEnv.getHtmlLabelName(resourceLabel,user.getLanguage())+"\" column=\"resourceid\"  orderkey=\"resourceid\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />";
							}
					 		
					 		if(fieldname.equals("unitid")){//计量单位
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(705,user.getLanguage())+"\" column=\"unitid\" orderkey=\"unitid\" transmethod=\"weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname\" />";
							}
					 		
					 		if(fieldname.equals("capitalnum")){//数量
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"\" column=\"capitalnum\" orderkey=\"capitalnum\" />";
							}
					 		
					 		if(fieldname.equals("currentnum")){//当前数量
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1451,user.getLanguage())+"\" column=\"currentnum\" orderkey=\"currentnum\" />";
							}
					 		
					 		if(fieldname.equals("capitalspec")){//规格型号
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(904,user.getLanguage())+"\" column=\"capitalspec\" orderkey=\"capitalspec\" />";
							}
					 		
					 		if(fieldname.equals("capitallevel")){//等级
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(603,user.getLanguage())+"\" column=\"capitallevel\" orderkey=\"capitallevel\" />";
							}
					 		
					 		if(fieldname.equals("manufacturer")){//制造厂商
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1364,user.getLanguage())+"\" column=\"manufacturer\" orderkey=\"manufacturer\" />";
							}
					 		
					 		if(fieldname.equals("manudate")){//出厂日期
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1365,user.getLanguage())+"\" column=\"manudate\" orderkey=\"manudate\" />";
							}
					 		
					 		if(fieldname.equals("customerid")){//供应商
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(138,user.getLanguage())+"\" column=\"customerid\" orderkey=\"customerid\" transmethod=\"weaver.cpt.search.CapitalProperties.getCrmName\"/>";
							}
					 		
 							if(fieldname.equals("attribute")){//属性
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(713,user.getLanguage())+"\" column=\"attribute\" orderkey=\"attribute\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.search.CapitalProperties.getAttribute\" />";
							}
					 		
 							
 							if(fieldname.equals("stateid")){//状态
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"stateid\"  orderkey=\"stateid\" transmethod=\"weaver.cpt.maintenance.CapitalStateComInfo.getCapitalStatename\" />";
							}
					 		
 							if(fieldname.equals("StockInDate")){//入库日期
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(753,user.getLanguage())+"\" column=\"stockindate\" orderkey=\"stockindate\" />";
							}
					 		
 							if(fieldname.equals("SelectDate")){//购置日期
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"SelectDate\" orderkey=\"SelectDate\" />";
							}
					 		
 							if(fieldname.equals("replacecapitalid")){//替代
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1371,user.getLanguage())+"\" column=\"replacecapitalid\" orderkey=\"replacecapitalid\" transmethod=\"weaver.cpt.capital.CapitalComInfo.getCapitalname\" />";
							}
					 		
 							//if(fieldname.equals("itemid")){//物品
								//temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(145,user.getLanguage())+"\" column=\"itemid\" orderkey=\"itemid\" />";
							//}
					 		
 							if(fieldname.equals("location")){//存放地点
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1387,user.getLanguage())+"\" column=\"location\" orderkey=\"location\" />";
							}
					 		
 							if(fieldname.equals("version")){//版本
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"version\" orderkey=\"version\" />";
							}
					 		
 							if(fieldname.equals("deprestartdate")){//领用日期
								temptableString +=   "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1412,user.getLanguage())+"\" column=\"deprestartdate\" orderkey=\"deprestartdate\" />";
							}
					 		
					
					RecordSet.executeProc("Base_FreeField_Select","cp");
					boolean hasFF = true;
					if(RecordSet.getCounts()<=0)
						hasFF = false;
					else
						RecordSet.first();
					
					if(hasFF)
					{
						for(int i=1;i<=5;i++)
						{//日期
							if(RecordSet.getString(i*2+1).equals("1")&&fieldname.equals("datefield"+i)){
								String labelname = RecordSet.getString(i*2);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"datefield"+i+"\" orderkey=\"datefield"+i+"\" />";
							}
						}
						for(int i=1;i<=5;i++)
						{//数字
							if(RecordSet.getString(i*2+11).equals("1")&&fieldname.equals("numberfield"+i)){
							  	String labelname = RecordSet.getString(i*2+10);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"numberfield"+i+"\" orderkey=\"numberfield"+i+"\" />";
							}
						}
						for(int i=1;i<=5;i++)
						{//文本
							if(RecordSet.getString(i*2+21).equals("1")&&fieldname.equals("textfield"+i))
							{
								String labelname = RecordSet.getString(i*2+20);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"textfield"+i+"\" orderkey=\"textfield"+i+"\" />";
							}
						}

						for(int i=1;i<=5;i++)
						{//checkbox
							if(RecordSet.getString(i*2+31).equals("1")&&fieldname.equals("tinyintfield"+i))
							{
								String labelname = RecordSet.getString(i*2+30);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"tinyintfield"+i+"\" orderkey=\"tinyintfield"+i+"\"  otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.search.CapitalProperties.getCheckboxStatus\" />";
							}
						}

						for(int i=1;i<=5;i++)
						{//多文档
							if(RecordSet.getString(i*2+41).equals("1")&&fieldname.equals("docff0"+i+"name"))
							{
								String labelname = RecordSet.getString(i*2+40);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"docff0"+i+"name\" orderkey=\"docff0"+i+"name\" transmethod=\"weaver.cpt.search.CapitalProperties.getDocName\" />";
							}
						}

						for(int i=1;i<=5;i++)
						{//多部门
							if(RecordSet.getString(i*2+51).equals("1")&&fieldname.equals("depff0"+i+"name"))
							{
								String labelname = RecordSet.getString(i*2+50);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"depff0"+i+"name\" orderkey=\"depff0"+i+"name\" transmethod=\"weaver.cpt.search.CapitalProperties.getDepartmentName\" />";
							}
						}

						for(int i=1;i<=5;i++)
						{//多客户
							if(RecordSet.getString(i*2+61).equals("1")&&fieldname.equals("crmff0"+i+"name"))
							{
								String labelname = RecordSet.getString(i*2+60);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"crmff0"+i+"name\" orderkey=\"crmff0"+i+"name\" transmethod=\"weaver.cpt.search.CapitalProperties.getCrmName\"/>";
							}
						}

						for(int i=1;i<=5;i++)
						{//多请求
							if(RecordSet.getString(i*2+71).equals("1")&&fieldname.equals("reqff0"+i+"name"))
							{
								String labelname = RecordSet.getString(i*2+70);
								temptableString +=   "<col width=\"10%\"  text=\""+labelname+"\" column=\"reqff0"+i+"name\" orderkey=\"reqff0"+i+"name\" transmethod=\"weaver.cpt.search.CapitalProperties.getRequestName\"/>";
							}
						}
					}

                        }
						
						
						String tableString = " <table instanceid=\"cptcapitalDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>";
                        
                        tableString += temptableString;
                        tableString += "			</head>"+
                                                 "</table>";
                        
                        
                     %>

                     <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
                  </td>
                </tr>
              </TABLE>


		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script language="javascript">
function onReSearch(){
	location.href="/cpt/search/CptSearch.jsp?isdata=<%=isdata%>";
}
function onReSearchMycpt(){
	location.href="/cpt/search/CptSearch.jsp?isdata=2&resourceid=<%=CurrentUser%>&type=mycpt";
}
</script>

</body>
</html>

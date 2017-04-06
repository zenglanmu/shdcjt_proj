<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCO" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%
    String CurrentUser = "" + user.getUID();
    String logintype = "" + user.getLogintype();
    String ProcPara = "";
    char flag = 2;
    ProcPara = CurrentUser;
    ProcPara += flag+logintype;
    RecordSet.executeProc("CRM_Customize_SelectByUid",ProcPara);

    boolean hasCustomize = true;
    if(RecordSet.getCounts()<=0){
        hasCustomize = false;
    }else
    {
        RecordSet.first();
    }

    int i = 0;
    int j = 0;
    int options[][] = new int[3][6];
    for(i=0;i<3;i++) {
        for (j = 0; j < 6; j++) {
            if (hasCustomize) {
                options[i][j] = Util.getIntValue(RecordSet.getString(i * 6 + j + 2),0);
            } else {
                switch (i * 10 + j) {
                    case 0:
                        options[i][j] = 101;
                        break;
                    case 1:
                        options[i][j] = 203;
                        break;
                    default:
                        options[i][j] = 0;
                }
            }
        }
    }

    boolean rows[] = new boolean[3];
    rows[0]=rows[1]=rows[2]=false;
    int nMaxCols = 0;
    for(i=0;i<3;i++){
        for (j = 0; j < 6; j++) {
            if (options[i][j] != 0) {
                rows[i] = true;
                nMaxCols = j + 1 > nMaxCols ? j + 1 : nMaxCols;
            }
        }
    }

    //添加判断权限的内容--new--begin
    String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String CRM_SearchSql = "";

    if(RecordSet1.getDBType().equals("oracle")){
        if (logintype.equals("1")) {
            CRM_SearchSql = "select distinct t1.* from CRM_CustomerInfo  t1,"+leftjointable+"  t2 " + CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) + " and t1.id = t2.relateditemid order by t1.id ";
        } else {
            CRM_SearchSql = "select t1.* from CRM_CustomerInfo t1  " + CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) + " and agent=" + CurrentUser + " order by id ";
        }

    }else{
        if (logintype.equals("1")) {
            CRM_SearchSql = "select distinct t1.* from CRM_CustomerInfo  t1,"+leftjointable+"  t2 " + CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) + " and t1.id = t2.relateditemid order by t1.id ";
        } else {
            CRM_SearchSql = "select * from CRM_CustomerInfo t1  " + CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) + " and agent=" + CurrentUser + " order by id ";
        }
    }


    //System.out.println("CRM_SearchSql = " + CRM_SearchSql);
    RecordSet1.executeSql(CRM_SearchSql);

    String strData = "";

    ExcelSheet es = new ExcelSheet();
    String temStr = "";

    for(i=0;i<3;i++)
    {
        if (!rows[i]) {
            continue;
        }
        ExcelRow er = es.newExcelRow();
        for (j = 0; j < nMaxCols; j++) {
            if (options[i][j] == 0) {
                continue;
            }
            RecordSetCO.executeProc("CRM_CustomizeOption_SelectByID", "" + options[i][j]);
            if (RecordSetCO.getCounts() <= 0)
                response.sendRedirect("/CRM/DBError.jsp?type=FindData_SRD_4");
            RecordSetCO.first();
            temStr = ((RecordSetCO.getInt("tabledesc") == 1) ? SystemEnv.getHtmlLabelName(136, user.getLanguage()) : SystemEnv.getHtmlLabelName(572, user.getLanguage())) + SystemEnv.getHtmlLabelName(RecordSetCO.getInt("labelid"), user.getLanguage());
            er.addStringValue(temStr);
        }
    }

    if(RecordSet1.last()){
        do {
            boolean CRM_CustomerContacter_SMain = false;
            RecordSet2.executeProc("CRM_CustomerContacter_SMain", RecordSet1.getString("id"));
            if (RecordSet2.next()) {
                CRM_CustomerContacter_SMain = true;
            }
            for (i = 0; i < 3; i++) {
                if (!rows[i])
                    continue;

                ExcelRow er = es.newExcelRow();

                for (j = 0; j < nMaxCols; j++) {
                    if (options[i][j] == 0) {
                        continue;
                    }
                    RecordSetCO.executeProc("CRM_CustomizeOption_SelectByID", "" + options[i][j]);
                    if (RecordSetCO.getCounts() <= 0)
                        response.sendRedirect("/CRM/DBError.jsp?type=FindData_SRD_4");
                    RecordSetCO.first();

                    if (RecordSetCO.getInt("tabledesc") == 1) {
                        strData = RecordSet1.getString(RecordSetCO.getString("fieldname"));
                    } else {
                        if (CRM_CustomerContacter_SMain)
                            strData = RecordSet2.getString(RecordSetCO.getString("fieldname"));
                        else
                            strData = "-";
                    }

                    switch(options[i][j]){
                        case 102:
                        case 202://需要把相应数据转换成 语言
                            strData = Util.toScreen(LanguageComInfo.getLanguagename(strData),user.getLanguage());
                            break;
                        case 106://需要把相应数据转换成 城市
                            strData = Util.toScreen(CityComInfo.getCityname(strData),user.getLanguage());
                            break;
                        case 107://需要把相应数据转换成 国家
                            strData = Util.toScreen(CountryComInfo.getCountryname(strData),user.getLanguage());
                            break;
                        case 108://需要把相应数据转换成 省份
                            strData = Util.toScreen(ProvinceComInfo.getProvincename(strData),user.getLanguage());
                            break;
                        case 114://需要把相应数据转换成 联系方法
                            strData = Util.toScreen(ContactWayComInfo.getContactWayname(strData),user.getLanguage());
                            break;
                        case 115://需要把相应数据转换成 行业
                            strData = Util.toScreen(SectorInfoComInfo.getSectorInfoname(strData),user.getLanguage());
                            break;
                        case 116://需要把相应数据转换成 规模
                            strData = Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(strData),user.getLanguage());
                            break;
                        case 117://需要把相应数据转换成 类型
                            strData = Util.toScreen(CustomerTypeComInfo.getCustomerTypename(strData),user.getLanguage());
                            break;
                        case 119://需要把相应数据转换成 描述
                            strData = Util.toScreen(CustomerDescComInfo.getCustomerDescname(strData),user.getLanguage());
                            break;
                        case 120://需要把相应数据转换成 状态
                            strData = Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(strData),user.getLanguage());
                            break;
                        case 121://需要把相应数据转换成 级别
                            strData = Util.toScreen(CustomerRatingComInfo.getCustomerRatingname(strData),user.getLanguage());
                            break;
                        case 122://需要把相应数据转换成 合同金额
                            strData = Util.toScreen(TradeInfoComInfo.getTradeInfoname(strData),user.getLanguage());
                            break;
                        case 123://需要把相应数据转换成 信用等级
                            strData = Util.toScreen(CreditInfoComInfo.getCreditInfoname(strData),user.getLanguage());
                            break;

                        case 201://需要把相应数据转换成 联系人称呼
                            strData = Util.toScreen(ContacterTitleComInfo.getContacterTitlename(strData),user.getLanguage());
                            break;

                        case 124:
                        case 212://需要把相应数据转换成 员工信息 并制作超级链接
                            strData = Util.toScreen(ResourceComInfo.getResourcename(strData),user.getLanguage());
                            break;

                        case 125://需要把相应数据转换成 部门信息 并制作超级链接
                            strData = Util.toScreen(DepartmentComInfo.getDepartmentname(strData),user.getLanguage());
                            break;

                        case 126:
                        case 127://需要把相应数据转换成 客户信息 并制作超级链接
                            if(!strData.equals("0"))
                            {
                                strData = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(strData),user.getLanguage());
                            }
                            else
                            {
                                strData = "no";
                            }
                            break;

                        case 101://制作超级链接
                            strData = Util.toScreen(RecordSet1.getString("name"),user.getLanguage());
                            break;

                        case 203:
                        case 204:
                        case 205://制作超级链接

                        case 213://客户门户状态
                              if(strData.equals("") || strData.equals("0")){
                                 strData = Util.toScreen(SystemEnv.getHtmlLabelName(1241,user.getLanguage()),user.getLanguage());
                              }else if(strData.equals("1")) {
                                 strData = Util.toScreen(SystemEnv.getHtmlLabelName(1242,user.getLanguage()),user.getLanguage());
                              }else if(strData.equals("2")) {
                                 strData = Util.toScreen(SystemEnv.getHtmlLabelName(1280,user.getLanguage()),user.getLanguage());
                              }else if(strData.equals("3")) {
                                 strData = Util.toScreen(SystemEnv.getHtmlLabelName(1232,user.getLanguage()),user.getLanguage());
                              }
                            break;

                        default:break;
                    }
                    er.addStringValue(strData);
                }
            }

        } while (RecordSet1.previous());
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("客户资料") ;
    ExcelFile.addSheet("客户", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>
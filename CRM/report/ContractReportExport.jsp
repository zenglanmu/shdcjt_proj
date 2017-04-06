<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%
    String sqlwhere=(String)session.getAttribute("sqlwhere");
    String orderStr=(String)session.getAttribute("orderStr");
    String orderStr1=(String)session.getAttribute("orderStr1");
    String sqlstr="";

    if(RecordSet.getDBType().equals("oracle")){
      if(user.getLogintype().equals("1")){
            sqlstr = " select t1.* from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 ,CRM_CustomerInfo  t3 "+ sqlwhere +"  and t1.crmId = t3.id and t1.id = t2.contractid " + orderStr ;

      }else{
            sqlstr = "select t1.* from CRM_Contract  t1 ,CRM_CustomerInfo  t3  "+ sqlwhere +" and t1.crmId = t3.id  and t1.crmId="+user.getUID() + orderStr ;
      }
    }else{
      if(user.getLogintype().equals("1")) {
            sqlstr = "select t1.* from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2,CRM_CustomerInfo  t3  "+ sqlwhere +"  and t1.crmId = t3.id and t1.id = t2.contractid " + orderStr ;
      }else{
            sqlstr = "select t1.* from CRM_Contract t1 ,CRM_CustomerInfo  t3 "+ sqlwhere +" and t1.crmId = t3.id and t1.crmId="+user.getUID() + orderStr ;
      }
    }

    RecordSet.executeSql(sqlstr);

    ExcelSheet es = new ExcelSheet();

    ExcelRow er = es.newExcelRow();
    er.addStringValue(SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(6083,user.getLanguage())); er.addStringValue(SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(2097,user.getLanguage()));
		er.addStringValue(SystemEnv.getHtmlLabelName(1936,user.getLanguage()));
    
    while(RecordSet.next()){
      er = es.newExcelRow();
      er.addStringValue(RecordSet.getString("name"));
      er.addStringValue(Util.toScreen(ContractTypeComInfo.getContractTypename(RecordSet.getString("TypeId")),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("price"),user.getLanguage()));
      String statusStr = "";
      switch (RecordSet.getInt("status")){
        case 0 : statusStr=SystemEnv.getHtmlLabelName(615,user.getLanguage()); break;
        case 1 : statusStr=SystemEnv.getHtmlLabelName(359,user.getLanguage()); break;
        case 2 : statusStr=SystemEnv.getHtmlLabelName(6095,user.getLanguage()); break;
        case 3 : statusStr=SystemEnv.getHtmlLabelName(555,user.getLanguage()); break;
        default: break;
      }
      er.addStringValue(statusStr);
      er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage()));
      er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("startDate"),user.getLanguage()));
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("合同报表") ;
    ExcelFile.addSheet("合同", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>
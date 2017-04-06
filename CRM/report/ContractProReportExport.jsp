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
         sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr;

	}else{
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr;
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
         sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid and t1.crmId = t4.id and t3.contractId = t1.id "+ orderStr;
    }else{
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr;
    }
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select t3.*  , t1.name , t1.crmId,t1.manager  from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr ;
	}else{
        sqlstr = "select t3.* , t1.name , t1.crmId,t1.manager   from CRM_Contract t1 , CRM_ContractProduct t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr ;
	}
}
    
    
    RecordSet.executeSql(sqlstr);

    ExcelSheet es = new ExcelSheet();
    
    ExcelRow erTitle = es.newExcelRow();//added by xwj td1554 on 2005-05-25
    ExcelRow erEmpty = es.newExcelRow();//added by xwj td1554 on 2005-05-25
	  ExcelRow er = es.newExcelRow();
	  
	   /*----------------added by xwj td1554 on 2005-05-25 ---------------begin--------*/
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("合同产品报表");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
    erTitle.addStringValue("");
   
    
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
    erEmpty.addStringValue("");
   /*----------------added by xwj td1554 on 2005-05-25 ---------------end-------------*/
   
    er.addStringValue(SystemEnv.getHtmlLabelName(6161,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15115,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15228,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15229,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(15230,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1050,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(534,user.getLanguage()));
    er.addStringValue(SystemEnv.getHtmlLabelName(1268,user.getLanguage()));
      
  
  
  
    while(RecordSet.next()){
   
      er = es.newExcelRow();
      er.addStringValue(RecordSet.getString("name"));
      er.addStringValue(Util.toScreen(AssetComInfo.getAssetName(RecordSet.getString("productId")),user.getLanguage()));
      er.addStringValue(RecordSet.getString("number_n"));
      er.addStringValue(RecordSet.getString("factnumber_n"));
      er.addStringValue(String.valueOf(Util.getIntValue(RecordSet.getString("number_n"),0) - Util.getIntValue(RecordSet.getString("factnumber_n"),0)));
      er.addStringValue(Util.toScreen(RecordSet.getString("planDate"),user.getLanguage()));
      er.addStringValue(Util.toScreen(RecordSet.getString("sumPrice"),user.getLanguage()));
      er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage()));
    
     
    }

    ExcelFile.init() ;
    ExcelFile.setFilename("合同产品报表") ;
    ExcelFile.addSheet("合同产品", es) ;
%>
success
<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>
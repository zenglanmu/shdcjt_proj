
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%
String Id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
//String Invoice = Util.fromScreen(request.getParameter("Invoice"),user.getLanguage());
String BuyerID = Util.fromScreen(request.getParameter("BuyerID"),user.getLanguage());
//String customerid = Util.fromScreen(request.getParameter("customerid"),user.getLanguage());
String CheckerID = Util.fromScreen(request.getParameter("CheckerID"),user.getLanguage());
String StockInDate = Util.fromScreen(request.getParameter("StockInDate"),user.getLanguage());
String Method = Util.fromScreen(request.getParameter("method"),user.getLanguage());
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);


char separator = Util.getSeparator() ;
String para = "";
String sql = "";

if (Method.equals("add")) {

    para = "";
    para +=separator+BuyerID;
    para +=separator+"";
    para +=separator+CheckerID;
    para +=separator+StockInDate;
	para +=separator+"0";
    RecordSet.executeProc("CptStockInMain_Insert",para);

	RecordSet.next();
	String cptstockinid=""+RecordSet.getInt(1);
	String cpttype="";
	String plannumber="";
	String price="";
    String Invoice="";
    String customerid_dtl="";
    String StockInDate_dtl="";
    String capitalspec="";
    String location="";
	String contractno="";//合同号

	int i=0;
	int j=1;
	for (i=0;i<totaldetail;i++)
	{
		cpttype = Util.null2String(request.getParameter("node_"+i+"_cptid"));
		plannumber = Util.null2String(request.getParameter("node_"+i+"_number"));
		price = Util.null2String(request.getParameter("node_"+i+"_unitprice"));
        Invoice= Util.null2String(request.getParameter("node_"+i+"_Invoice"));
        customerid_dtl= Util.null2String(request.getParameter("node_"+i+"_customerid"));
        StockInDate_dtl= Util.null2String(request.getParameter("node_"+i+"_StockInDate"));
        capitalspec= Util.null2String(request.getParameter("node_"+i+"_capitalspec"));
        location= Util.null2String(request.getParameter("node_"+i+"_location"));
		contractno= Util.null2String(request.getParameter("node_"+i+"_contractno"));
        if(!cpttype.equals("")){
        if(customerid_dtl.equals("")){
            String customertext_dtl=request.getParameter("node_"+i+"_customertext");
            if(!customertext_dtl.equals("")){
                sql= "select id from CRM_CustomerInfo where deleted<>1 and name='" + customertext_dtl +"'" ;
                RecordSet.executeSql(sql);
                if(RecordSet.next()){
                    customerid_dtl=RecordSet.getString("id");
                }else{
                    char flag = 2;
                    String sqlstr = "select * from CRM_CustomerCredit" ;
                    String CreditAmount = "" ;
                    String CreditTime = "";
                    RecordSet.executeSql(sqlstr);
                    if (RecordSet.next()) {
                        CreditAmount = RecordSet.getString("CreditAmount");
                        CreditTime = RecordSet.getString("CreditTime");
                    }
                    String ProcPara = customertext_dtl+flag+BuyerID+flag+CreditAmount+flag+CreditTime;
                    boolean insertSuccess =false;
                    //新建供应商
                    insertSuccess = RecordSet.executeProc("CRM_CustomerInfo_InsertByCpt",ProcPara);
                    if(insertSuccess){
                        RecordSet.next();
                        customerid_dtl=""+RecordSet.getInt(1);
                        CustomerInfoComInfo.addCustomerInfoCache(customerid_dtl);
                        //设置客户经理的经理共享
                        String operators = ResourceComInfo.getManagerID(BuyerID);
                        RecordSet.executeProc("CRM_ShareEditToManager", customerid_dtl + flag + operators);
                        //设置共享
                        RecordSet.executeProc("CRM_ShareInfo_Update","2"+flag+customerid_dtl);
                        //设置共享
                        CrmViewer.setCrmShareByCrm(""+customerid_dtl);
                        //插入联系人
                        RecordSet.executeSql("INSERT INTO CRM_CustomerContacter(customerid,main) VALUES ( "+customerid_dtl+",1)");
                    }
                }
            }
        }

		para = cptstockinid;
		para +=separator+cpttype;
		para +=separator+plannumber;
		para +=separator+"0";
		para +=separator+price;
        para +=separator+customerid_dtl;
        para +=separator+StockInDate_dtl;
        para +=separator+capitalspec;
        para +=separator+location;
        para +=separator+Invoice;
		RecordSet.executeProc("CptStockInDetail_Insert",para);
		if(RecordSet.next()){
			String detailid = Util.null2String(RecordSet.getString(1));
			if(!detailid.equals("")&&!detailid.equals("0")){
				RecordSet.executeSql("update CptStockInDetail set contractno = '" + contractno + "' where id = " + detailid);
			}			
		}
        }

	}
//update by fanggsh 20060511 TD4308 begin
    PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue(CheckerID),11,"0",Util.getIntValue(cptstockinid));
//update by fanggsh 20060511 TD4308 end

	response.sendRedirect("CptCapitalInstock1.jsp");
}
else 
if (Method.equals("delete")) {
	sql = "update CptStockInMain set ischecked = -1 where id = " + Id ;
	RecordSet.executeSql(sql);
//update by fanggsh 20060511 TD4308 begin
    PoppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(),11,"0",Util.getIntValue(Id));
//update by fanggsh 20060511 TD4308 end
	response.sendRedirect("/cpt/search/CptInstockSearch.jsp");
}
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
    //只有内部用户可以修改客户的等级
    if(!user.getLogintype().equals("1")){
        return;
    }
    String CRM_SearchWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
    String customerids = Util.null2String(request.getParameter("customerids"));
    String oper = Util.null2String(request.getParameter("oper"));

    String CRM_SearchSql =  "";
    String updateSql = "";
    String temStr = "";
    String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    if(oper.equals("1")){
        if(!customerids.equals("")){
            CRM_SearchSql = "select t1.id from CRM_CustomerInfo  t1,"+leftjointable+" t2  "+ CRM_SearchWhere +" and t1.status>=1 and t1.status<8 and t1.id in("+ customerids +") and t1.id = t2.relateditemid";
        }

        RecordSet.executeSql(CRM_SearchSql);

        while(RecordSet.next()){
            temStr +=","+RecordSet.getString(1);
        }
        if(!temStr.equals("")){
            temStr = temStr.substring(1);
        }
        updateSql = "update CRM_CustomerInfo set status=status+1 where id in("+temStr+")";
        if(!temStr.equals(""))
        RecordSet.executeSql(updateSql);
    }else if(oper.equals("2")){
        if(!customerids.equals("")){
            CRM_SearchSql = "select t1.id from CRM_CustomerInfo  t1,"+leftjointable+" t2  "+ CRM_SearchWhere +" and t1.status>1 and t1.status<=8 and t1.id in("+ customerids +") and t1.id = t2.relateditemid";
        }

        RecordSet.executeSql(CRM_SearchSql);

        while(RecordSet.next()){
            temStr +=","+RecordSet.getString(1);
        }
        if(!temStr.equals("")){
            temStr = temStr.substring(1);
        }
        updateSql = "update CRM_CustomerInfo set status=status-1 where id in("+temStr+")";
        if(!temStr.equals(""))
        RecordSet.executeSql(updateSql);
    }
    response.sendRedirect("/CRM/data/ChangeLevelCustomerList.jsp");
%>
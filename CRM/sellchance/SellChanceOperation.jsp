<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%
char flag=2;
String para="";
String method = request.getParameter("method");


String chanceid = Util.null2String(request.getParameter("chanceid"));//当edit和delete时候有值
String subject = request.getParameter("subject");
String Creater = Util.null2String(request.getParameter("Creater"));
String CustomerID = Util.null2String(request.getParameter("customer"));
String Comefrom =Util.null2String(request.getParameter("Comefrom"));
String sellstatusid =Util.null2String(request.getParameter("sellstatusid"));
String endtatusid =Util.null2String(request.getParameter("endtatusid"));
String preselldate =Util.null2String(request.getParameter("preselldate"));
String preyield =Util.null2String(request.getParameter("preyield"));
String probability =Util.null2String(request.getParameter("probability"));
String content =Util.null2String(request.getParameter("Agent"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
if(content.trim().equals(""))content="0";

String sufactorid =Util.null2String(request.getParameter("sufactorid"));//成功关键因素
String defactorid =Util.null2String(request.getParameter("defactorid"));//失败关键因素

String departmentId = ResourceComInfo.getDepartmentID(Creater);//客户经理的部门ID
String subCompanyId = DepartmentComInfo.getSubcompanyid1(departmentId);//客户经理的分部ID

String currencyid="";
if(preyield.equals("")) preyield="0";
if(probability.equals("")) probability="0";
int rownum = Util.getIntValue(request.getParameter("rownum"),user.getLanguage()) ;//行数

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

 
//以下是给相应的人员触发工作流
/*=================================================*/
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();


String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";

String thesql="select managerid from HrmResource where id = "+CurrentUser;
RecordSetM.executeSql(thesql);
RecordSetM.next();
String managerid=RecordSetM.getString("managerid"); //通知上级
/*================================================*/


if(method.equals("add")){

    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
    para= ""+Creater;
    para += flag + subject;
    para += flag + CustomerID;
    para += flag + Comefrom;
    para += flag + sellstatusid; 
    para += flag + endtatusid;
    para += flag + preselldate;
    para += flag + preyield;
    para += flag + currencyid;
    para += flag + probability;
    para += flag + currentdate;
    para += flag + currenttime;
    para += flag + content;
    para += flag + sufactorid;
    para += flag + defactorid;
    
		para += flag + departmentId;
		para += flag + subCompanyId;
		
    rs.executeProc("CRM_SellChance_insert",para);  

    rs.executeProc("CRM_SellChance_SMAXID","");  
    rs.next();
    String sellchanceid = rs.getString("sellchanceid");

    if(!sellchanceid.equals("0")){    
        for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
               currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
        para = ""+sellchanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
        rs.executeProc("CRM_ProductTable_insert",para);  
        }
        }
    }

if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流

/*添加客户销售机会触发工作流*/
    Subject=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
    Subject+=":"+subject;

    SWFAccepter=managerid;
    SWFTitle=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
    SWFTitle += ":"+subject;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+currentdate;
    SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+sellchanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;

    SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
/*workflow _ end*/
}

response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID);
}


if(method.equals("edit")){

    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
    para= ""+Creater;
    para += flag + subject;
    para += flag + CustomerID;
    para += flag + Comefrom;
    para += flag + sellstatusid; 
    para += flag + endtatusid;
    para += flag + preselldate;
    para += flag + preyield;
    para += flag + currencyid;
    para += flag + probability;
    para += flag + content;
    para += flag + chanceid;//比insert多一个参数
    para += flag + sufactorid;
    para += flag + defactorid;

		para += flag + departmentId;
		para += flag + subCompanyId;
		
    rs.executeProc("CRM_SellChance_Update",para);
    
    //对于产品表，先删除原先的，再做insert即可
    rs.executeProc("CRM_Product_Delete",chanceid);
    for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
               currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
        para = ""+chanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
        rs.executeProc("CRM_ProductTable_insert",para);  
        }
    }

  
 if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流

/*编辑客户销售机会触发工作流*/
    Subject=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
    Subject+=":"+subject;

    SWFAccepter=managerid;
    SWFTitle=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
    SWFTitle += ":"+subject;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+currentdate;
    SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;
    SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
/*workflow _ end*/    
 }

response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID);
}
if(method.equals("del")){
    rs.executeProc("CRM_SellChance_Delete",chanceid);
    rs.executeProc("CRM_Product_Delete",chanceid);
response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"");

}
if(method.equals("reopen")){
	String sqlStr = "Update CRM_SellChance set endtatusid = 0 where id = " + chanceid;
	RecordSet.executeSql(sqlStr);
response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID);
}
%>
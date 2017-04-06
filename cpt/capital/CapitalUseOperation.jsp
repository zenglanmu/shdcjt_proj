
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
char flag=2;
String para = "";

String capitalid = "";
String capitalnum = "";
String resourceid = "";
String departmentid = "";
String remark = "";
String sptcount = "";
String location="";
boolean isoracle = RecordSet.getDBType().equals("oracle");
String sqltemp="";
String useddate = "";

int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);

for(int i=0;i<totaldetail;i++){
    capitalid = Util.fromScreen(request.getParameter("node_"+i+"_capitalid"),user.getLanguage());
    capitalnum = Util.fromScreen(request.getParameter("node_"+i+"_capitalnum"),user.getLanguage());
    resourceid = Util.fromScreen(request.getParameter("node_"+i+"_hrmid"),user.getLanguage());
    departmentid = ResourceComInfo.getDepartmentID(resourceid);
    remark = Util.null2String(request.getParameter("node_"+i+"_remark"));
    sptcount = Util.fromScreen(request.getParameter("node_"+i+"_sptcount"),user.getLanguage());
    location = Util.fromScreen(request.getParameter("node_"+i+"_location"),user.getLanguage());
    useddate = Util.fromScreen(request.getParameter("node_"+i+"_StockInDate"),user.getLanguage());
    
    if(!capitalid.equals("")){
    if(sptcount.equals("1")){
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+"1";
        //para +=flag+userequest;
        para +=flag+"";
        para +=flag+"0";
        para +=flag+"2";
        para +=flag+remark;
        para +=flag+location;
        para +=flag+sptcount;

        RecordSet.executeProc("CptUseLogUse_Insert",para);
    }else{ 
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+capitalnum;
        // para +=separator+userequest; 
        para +=flag+"";    
        para +=flag+"0";  
        para +=flag+"2";
        para +=flag+remark;
        para +=flag+location;
        para +=flag+"0";

        RecordSet.executeProc("CptUseLogUse_Insert",para);
        RecordSet.next();
        String rtvalue = RecordSet.getString(1);    
        //数量错误
        if(rtvalue.equals("-1")){
           response.sendRedirect("CptCapitalUse.jsp?capitalid="+capitalid+"&msgid=1"); 
        } 
    }

    RecordSet.executeProc("HrmInfoStatus_UpdateCapital",""+resourceid);
    CapitalComInfo.removeCapitalCache();
    CptShare.setCptShareByCpt(capitalid);//更新detail表
    
    if(!location.equals("")){
        RecordSet.executeSql("update CptCapital set location='"+location+"' where id="+capitalid);
    }

    //更新折旧开始时间

    if(!isoracle){
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and (deprestartdate is null or deprestartdate='')";
    }else{
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and deprestartdate is null";
    }
    RecordSet.executeSql(sqltemp);
    }
}

if(!capitalid.equals("")){
    response.sendRedirect("CptCapital.jsp?id="+capitalid);  
}else{
    response.sendRedirect("CptCapitalUse.jsp");
}
%>

<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="SMSXML" class="weaver.servicefiles.SMSXML" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("datasource")){
    String method = Util.null2String(request.getParameter("method"));
    int dsnums = Util.getIntValue(Util.null2String(request.getParameter("dsnums")),0);
    if(method.equals("add")){
        Hashtable dataHST = new Hashtable();
        String pointid = Util.null2String(request.getParameter("datasource"));
        if(pointid.equals("")){
            response.sendRedirect("datasourcesetting.jsp");
            return;
        }
    
        String dbtype = Util.null2String(request.getParameter("dbtype"));
        String HostIP = Util.null2String(request.getParameter("HostIP"));
        String Port = Util.null2String(request.getParameter("Port"));
        String DBname = Util.null2String(request.getParameter("DBname"));
        String username = Util.null2String(request.getParameter("user"));
        String password = Util.null2String(request.getParameter("password"));
        String minconn = Util.null2String(request.getParameter("minconn"));
        String maxconn = Util.null2String(request.getParameter("maxconn"));
        dataHST.put("type",dbtype);
        dataHST.put("host",HostIP);
        dataHST.put("port",Port);
        dataHST.put("dbname",DBname);
        dataHST.put("user",username);
        dataHST.put("password",password);
        dataHST.put("minconn",minconn);
        dataHST.put("maxconn",maxconn);
        
        DataSourceXML.writeToDataSourceXMLAdd(pointid,dataHST);
    }else if(method.equals("edit")){
        ArrayList dspointids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<dsnums;i++){
            Hashtable dataHST = new Hashtable();
            String pointid = Util.null2String(request.getParameter("datasource_"+i));
            if(pointid.equals("")) continue;
    
            String dbtype = Util.null2String(request.getParameter("dbtype_"+i));
            String HostIP = Util.null2String(request.getParameter("HostIP_"+i));
            String Port = Util.null2String(request.getParameter("Port_"+i));
            String DBname = Util.null2String(request.getParameter("DBname_"+i));
            String username = Util.null2String(request.getParameter("user_"+i));
            String password = Util.null2String(request.getParameter("password_"+i));
            String minconn = Util.null2String(request.getParameter("minconn_"+i));
            String maxconn = Util.null2String(request.getParameter("maxconn_"+i));
            dataHST.put("type",dbtype);
            dataHST.put("host",HostIP);
            dataHST.put("port",Port);
            dataHST.put("dbname",DBname);
            dataHST.put("user",username);
            dataHST.put("password",password);
            dataHST.put("minconn",minconn);
            dataHST.put("maxconn",maxconn);
            
            dspointids.add(pointid);
            dataHSTArr.add(dataHST);
        }
        DataSourceXML.writeToDataSourceXMLEdit(dspointids,dataHSTArr);
    }else if(method.equals("delete")){
        ArrayList dspointids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<dsnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String pointid = Util.null2String(request.getParameter("datasource_"+i));
            if(pointid.equals("")) continue;
    
            Hashtable dataHST = new Hashtable();
            String dbtype = Util.null2String(request.getParameter("dbtype_"+i));
            String HostIP = Util.null2String(request.getParameter("HostIP_"+i));
            String Port = Util.null2String(request.getParameter("Port_"+i));
            String DBname = Util.null2String(request.getParameter("DBname_"+i));
            String username = Util.null2String(request.getParameter("user_"+i));
            String password = Util.null2String(request.getParameter("password_"+i));
            String minconn = Util.null2String(request.getParameter("minconn_"+i));
            String maxconn = Util.null2String(request.getParameter("maxconn_"+i));
            dataHST.put("type",dbtype);
            dataHST.put("host",HostIP);
            dataHST.put("port",Port);
            dataHST.put("dbname",DBname);
            dataHST.put("user",username);
            dataHST.put("password",password);
            dataHST.put("minconn",minconn);
            dataHST.put("maxconn",maxconn);
            
            dspointids.add(pointid);
            dataHSTArr.add(dataHST);
        }
        DataSourceXML.writeToDataSourceXMLEdit(dspointids,dataHSTArr);
    }
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("datasourcesetting.jsp");
}else if(operation.equals("sms")){
    String interfacetype = Util.null2String(request.getParameter("interfacetype"));
    String constructclass = Util.null2String(request.getParameter("constructclass"));
    ArrayList propertyArr = new ArrayList();
    ArrayList valueArr = new ArrayList();
    if(interfacetype.equals("1")){//通用短信接口
        constructclass = "weaver.sms.JdbcSmsService";
        String type = Util.null2String(request.getParameter("type"));
        String host = Util.null2String(request.getParameter("host"));
        String port = Util.null2String(request.getParameter("port"));
        String dbname = Util.null2String(request.getParameter("dbname"));
        String username = Util.null2String(request.getParameter("username"));
        String password = Util.null2String(request.getParameter("password"));
        String sql = Util.null2String(request.getParameter("sql"));
        propertyArr.add("type");
        propertyArr.add("host");
        propertyArr.add("port");
        propertyArr.add("dbname");
        propertyArr.add("username");
        propertyArr.add("password");
        propertyArr.add("sql");
        
        valueArr.add(type);
        valueArr.add(host);
        valueArr.add(port);
        valueArr.add(dbname);
        valueArr.add(username);
        valueArr.add(password);
        valueArr.add(sql);
        
    }else{//自定义短信接口
        int propertynum = Util.getIntValue(Util.null2String(request.getParameter("propertynum")),0);
        for(int i=1;i<=propertynum;i++){
            String propertyS = Util.null2String(request.getParameter("property_"+i));
            if(propertyS.equals("")) continue;
            String valueS = Util.null2String(request.getParameter("value_"+i));
            propertyArr.add(propertyS);
            valueArr.add(valueS);
        }
    }
    
    SMSXML.writeToSMSXML(constructclass,propertyArr,valueArr);
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("smssetting.jsp");
}else if(operation.equals("action")){
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String actionid = Util.null2String(request.getParameter("actionid"));
        if(actionid.equals("")){
            response.sendRedirect("actionsetting.jsp");
            return;
        }
    
        String classname = Util.null2String(request.getParameter("classname"));
        
        ActionXML.writeToActionXMLAdd(actionid,classname);
    }else if(method.equals("edit")){
        int atnums = Util.getIntValue(Util.null2String(request.getParameter("atnums")),0);
        ArrayList actionids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<atnums;i++){
            String actionid = Util.null2String(request.getParameter("actionid_"+i));
            if(actionid.equals("")) continue;
            String classname = Util.null2String(request.getParameter("classname_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("classname",classname);
            
            actionids.add(actionid);
            dataHSTArr.add(dataHST);
        }
        ActionXML.writeToActionXMLEdit(actionids,dataHSTArr);
    }else if(method.equals("delete")){
        int atnums = Util.getIntValue(Util.null2String(request.getParameter("atnums")),0);
        ArrayList actionids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<atnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String actionid = Util.null2String(request.getParameter("actionid_"+i));
            if(actionid.equals("")) continue;
            String classname = Util.null2String(request.getParameter("classname_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("classname",classname);
            
            actionids.add(actionid);
            dataHSTArr.add(dataHST);
        }
        ActionXML.writeToActionXMLEdit(actionids,dataHSTArr);
    }
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("actionsetting.jsp");
}else if(operation.equals("browser")){
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String browserid = Util.null2String(request.getParameter("browserid"));
        if(browserid.equals("")){
            response.sendRedirect("browsersetting.jsp");
            return;
        }
        String ds = "datasource."+Util.null2String(request.getParameter("ds"));
        String search = Util.null2String(request.getParameter("search"));
        String searchById = Util.null2String(request.getParameter("searchById"));
        String searchByName = Util.null2String(request.getParameter("searchByName"));
        String nameHeader = Util.null2String(request.getParameter("nameHeader"));
        String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader"));
        String outPageURL = Util.null2String(request.getParameter("outPageURL"));
        String from = Util.null2String(request.getParameter("from"));
        String href = Util.null2String(request.getParameter("href"));
    
        Hashtable dataHST = new Hashtable();
        dataHST.put("ds",ds);
        dataHST.put("search",search);
        dataHST.put("searchById",searchById);
        dataHST.put("searchByName",searchByName);
        dataHST.put("nameHeader",nameHeader);
        dataHST.put("descriptionHeader",descriptionHeader);
        dataHST.put("outPageURL",outPageURL);
        dataHST.put("from",from);
        dataHST.put("href",href);
        
        BrowserXML.writeToBrowserXMLAdd(browserid,dataHST);
    }else if(method.equals("edit")){
        int bsnums = Util.getIntValue(Util.null2String(request.getParameter("bsnums")),0);
        ArrayList browserids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<bsnums;i++){
            String browserid = Util.null2String(request.getParameter("browserid_"+i));
            if(browserid.equals("")) continue;
            String ds = Util.null2String(request.getParameter("ds_"+i));
            String search = Util.null2String(request.getParameter("search_"+i));
            String searchById = Util.null2String(request.getParameter("searchById_"+i));
            String searchByName = Util.null2String(request.getParameter("searchByName_"+i));
            String nameHeader = Util.null2String(request.getParameter("nameHeader_"+i));
            String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader_"+i));
            String outPageURL = Util.null2String(request.getParameter("outPageURL_"+i));
            String from = Util.null2String(request.getParameter("from_"+i));
            String href = Util.null2String(request.getParameter("href_"+i));
    
            Hashtable dataHST = new Hashtable();
            dataHST.put("ds",ds);
            dataHST.put("search",search);
            dataHST.put("searchById",searchById);
            dataHST.put("searchByName",searchByName);
            dataHST.put("nameHeader",nameHeader);
            dataHST.put("descriptionHeader",descriptionHeader);
            dataHST.put("outPageURL",outPageURL);
            dataHST.put("from",from);
            dataHST.put("href",href);
            
            browserids.add(browserid);
            dataHSTArr.add(dataHST);
        }
        BrowserXML.writeToBrowserXMLEdit(browserids,dataHSTArr);
    }else if(method.equals("delete")){
        int bsnums = Util.getIntValue(Util.null2String(request.getParameter("bsnums")),0);
        ArrayList browserids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<bsnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String browserid = Util.null2String(request.getParameter("browserid_"+i));
            if(browserid.equals("")) continue;
            String ds = Util.null2String(request.getParameter("ds_"+i));
            String search = Util.null2String(request.getParameter("search_"+i));
            String searchById = Util.null2String(request.getParameter("searchById_"+i));
            String searchByName = Util.null2String(request.getParameter("searchByName_"+i));
            String nameHeader = Util.null2String(request.getParameter("nameHeader_"+i));
            String descriptionHeader = Util.null2String(request.getParameter("descriptionHeader_"+i));
            String outPageURL = Util.null2String(request.getParameter("outPageURL_"+i));
            String from = Util.null2String(request.getParameter("from_"+i));
            String href = Util.null2String(request.getParameter("href_"+i));
    
            Hashtable dataHST = new Hashtable();
            dataHST.put("ds",ds);
            dataHST.put("search",search);
            dataHST.put("searchById",searchById);
            dataHST.put("searchByName",searchByName);
            dataHST.put("nameHeader",nameHeader);
            dataHST.put("descriptionHeader",descriptionHeader);
            dataHST.put("outPageURL",outPageURL);
            dataHST.put("from",from);
            dataHST.put("href",href);
            
            browserids.add(browserid);
            dataHSTArr.add(dataHST);
        }
        BrowserXML.writeToBrowserXMLEdit(browserids,dataHSTArr);
    }
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("browsersetting.jsp");
}else if(operation.equals("schedule")){
    String method = Util.null2String(request.getParameter("method"));
    if(method.equals("add")){
        String scheduleid = Util.null2String(request.getParameter("scheduleid"));
        if(scheduleid.equals("")){
            response.sendRedirect("schedulesetting.jsp");
            return;
        }
        String ClassName = Util.null2String(request.getParameter("ClassName"));
        String CronExpr = Util.null2String(request.getParameter("CronExpr"));
        Hashtable dataHST = new Hashtable();
        dataHST.put("construct",ClassName);
        dataHST.put("cronExpr",CronExpr);
        
        ScheduleXML.writeToScheduleXMLAdd(scheduleid,dataHST);
    }else if(method.equals("edit")){
        int sdnums = Util.getIntValue(Util.null2String(request.getParameter("sdnums")),0);
        ArrayList scheduleids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<sdnums;i++){
            String scheduleid = Util.null2String(request.getParameter("scheduleid_"+i));
            if(scheduleid.equals("")) continue;
            String ClassName = Util.null2String(request.getParameter("ClassName_"+i));
            String CronExpr = Util.null2String(request.getParameter("CronExpr_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("construct",ClassName);
            dataHST.put("cronExpr",CronExpr);
            
            scheduleids.add(scheduleid);
            dataHSTArr.add(dataHST);
        }
        ScheduleXML.writeToScheduleXMLEdit(scheduleids,dataHSTArr);
    }else if(method.equals("delete")){
        int sdnums = Util.getIntValue(Util.null2String(request.getParameter("sdnums")),0);
        ArrayList scheduleids = new ArrayList();
        ArrayList dataHSTArr = new ArrayList();
        for(int i=0;i<sdnums;i++){
            String isdel = Util.null2String(request.getParameter("del_"+i));
            if(isdel.equals("1")) continue;
            String scheduleid = Util.null2String(request.getParameter("scheduleid_"+i));
            if(scheduleid.equals("")) continue;
            String ClassName = Util.null2String(request.getParameter("ClassName_"+i));
            String CronExpr = Util.null2String(request.getParameter("CronExpr_"+i));
            Hashtable dataHST = new Hashtable();
            dataHST.put("construct",ClassName);
            dataHST.put("cronExpr",CronExpr);
            
            scheduleids.add(scheduleid);
            dataHSTArr.add(dataHST);
        }
        ScheduleXML.writeToScheduleXMLEdit(scheduleids,dataHSTArr);
    }
    
    ResetXMLFileCache.resetCache();
    
    response.sendRedirect("schedulesetting.jsp");
}

%>



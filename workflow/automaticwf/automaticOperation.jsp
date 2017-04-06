<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operate = Util.null2String(request.getParameter("operate"));

if(operate.equals("add")){
    String setname = Util.null2String(request.getParameter("setname"));//名称
    String workFlowId = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    String outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
    String successback = Util.null2String(request.getParameter("successback"));//流程触发成功时回写设置
    String failback = Util.null2String(request.getParameter("failback"));//流程触发失败时回写设置
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + ",";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    outermainwhere = Util.replace(outermainwhere,"'","''",0);
    successback = Util.replace(successback,"'","''",0);
    failback = Util.replace(failback,"'","''",0);
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    outerdetailwheres = Util.replace(outerdetailwheres,"'","''",0);
    String insertSql = "insert into outerdatawfset("+
                       "setname,"+
                       "workflowid,"+
                       "outermaintable,"+
                       "outermainwhere,"+
                       "successback,"+
                       "failback,"+
                       "outerdetailtables,"+
                       "outerdetailwheres,"+
                       "datasourceid) values("+
                       "'"+setname+"',"+
                       ""+workFlowId+","+
                       "'"+outermaintable+"',"+
                       "'"+outermainwhere+"',"+
                       "'"+successback+"',"+
                       "'"+failback+"',"+
                       "'"+outerdetailtables+"',"+
                       "'"+outerdetailwheres+"',"+
                       "'"+datasourceid+"'"+
                       ")";
    //System.out.println("insertSql=="+insertSql);
    RecordSet.executeSql(insertSql);
    String viewid = "";
    RecordSet.executeSql("select max(id) from outerdatawfset");
    if(RecordSet.next()) viewid = RecordSet.getString(1);
    response.sendRedirect("automaticsettingView.jsp?viewid="+viewid);
}else if(operate.equals("edit")){
    String viewid = Util.null2String(request.getParameter("viewid"));//keyid
    
    String setname = Util.null2String(request.getParameter("setname"));//名称
    String workflowid = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    String outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
    String successback = Util.null2String(request.getParameter("successback"));//流程触发成功时回写设置
    String failback = Util.null2String(request.getParameter("failback"));//流程触发失败时回写设置
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + ",";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
    
    String oldworkflowid = "";
    RecordSet.executeSql("select workflowid from outerdatawfset where id="+viewid);
    if(RecordSet.next()){
        oldworkflowid = RecordSet.getString("workflowid");
        if(!oldworkflowid.equals(workflowid)){
             //流程已变更，删除详细设置内容。
             RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+viewid);
        }
    }
    
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    outermainwhere = Util.replace(outermainwhere,"'","''",0);
    successback = Util.replace(successback,"'","''",0);
    failback = Util.replace(failback,"'","''",0);
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    outerdetailwheres = Util.replace(outerdetailwheres,"'","''",0);
    String updateSql = "update outerdatawfset set "+
                       "setname='"+setname+"',"+
                       "workflowid='"+workflowid+"',"+
                       "outermaintable='"+outermaintable+"',"+
                       "outermainwhere='"+outermainwhere+"',"+
                       "successback='"+successback+"',"+
                       "failback='"+failback+"',"+
                       "outerdetailtables='"+outerdetailtables+"',"+
                       "outerdetailwheres='"+outerdetailwheres+"',"+
                       "datasourceid='"+datasourceid+"' "+
                       "where id="+viewid;
    //System.out.println("updateSql=="+updateSql);
    RecordSet.executeSql(updateSql);                  
    response.sendRedirect("automaticsettingView.jsp?viewid="+viewid);
}else if(operate.equals("adddetail")){
    String viewid = Util.null2String(request.getParameter("viewid"));//keyid 
    int fieldscount = Util.getIntValue(Util.null2String(request.getParameter("fieldscount")),0);//字段总数
    
    RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+viewid);//先删除
    for(int i=1;i<=fieldscount;i++){
        int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid_index_"+i)),-1);
        String wffieldname = Util.null2String(request.getParameter("fieldname_index_"+i));
        int wffieldhtmltype = Util.getIntValue(Util.null2String(request.getParameter("fieldhtmltype_index_"+i)),-1);
        int wffieldtype = Util.getIntValue(Util.null2String(request.getParameter("fieldtype_index_"+i)),-1);
        String wffielddbtype = Util.null2String(request.getParameter("fielddbtype_index_"+i));
        String outerfieldname = Util.null2String(request.getParameter("outerfieldname_index_"+i));
        int iswriteback = Util.getIntValue(Util.null2String(request.getParameter("iswriteback_"+i)),0);
        
        int changetype = 0;
        if( wffieldhtmltype==3&&(wffieldtype==1||wffieldtype==4||wffieldtype==164) ){
            //单人力资源浏览框，单部门浏览框，单分部浏览框才有转换规则
            changetype = Util.getIntValue(Util.null2String(request.getParameter("rulesopt_"+i)),0);
            if(changetype==5){//选择了固定的创建人
                outerfieldname = Util.null2String(request.getParameter("hrmid"));
            }
        }
        String insertSql = "insert into outerdatawfsetdetail("+
                           "mainid,"+
                           "wffieldid,"+
                           "wffieldname,"+
                           "wffieldhtmltype,"+
                           "wffieldtype,"+
                           "wffielddbtype,"+
                           "outerfieldname,"+
                           "changetype,"+
                           "iswriteback) values("+
                           viewid+","+
                           wffieldid+","+
                           "'"+wffieldname+"',"+
                           wffieldhtmltype+","+
                           wffieldtype+","+
                           "'"+wffielddbtype+"',"+
                           "'"+outerfieldname+"',"+
                           changetype+","+
                           iswriteback+")";
                           
         RecordSet.executeSql(insertSql);
    }
    
    response.sendRedirect("automaticsettingView.jsp?viewid="+viewid);
}

%>
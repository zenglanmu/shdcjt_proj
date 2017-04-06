<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />


<%
  int userid = user.getUID();
  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
  
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String topic = Util.fromScreen(request.getParameter("topic"),user.getLanguage());  
  String principalid = Util.fromScreen(request.getParameter("principalid"),user.getLanguage());
  String oldprincipalid = Util.fromScreen(request.getParameter("oldprincipalid"),user.getLanguage());

  String informmanid = Util.fromScreen(request.getParameter("informmanid"),user.getLanguage());
  String oldinformmanid = Util.fromScreen(request.getParameter("oldinformmanid"),user.getLanguage());
  String emailmould = Util.fromScreen(request.getParameter("emailmould"),user.getLanguage());
  String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());

  String budget = Util.fromScreen(request.getParameter("budget"),user.getLanguage());
  String memo = Util.fromScreen(request.getParameter("memo"),user.getLanguage());
  int budgettype = Util.getIntValue(request.getParameter("budgettype"),0); 
  int rownum = Util.getIntValue(request.getParameter("rownum"),0); 

  String fare = Util.fromScreen(request.getParameter("fare"),user.getLanguage());  
  String faretype = Util.fromScreen(request.getParameter("faretype"),user.getLanguage());  
  String advice = Util.fromScreen(request.getParameter("advice"),user.getLanguage());  
  
  String operation  = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  String sql = "";
  String para = "";
  char separator = Util.getSeparator() ; 
  
  if(operation.equals("add")){
        para = topic +separator+ principalid + separator+
                informmanid+ separator+ emailmould  +separator+ startdate   + separator+ 
                budget     + separator+ budgettype  +separator+ memo;  
        rs.executeProc("HrmCareerPlan_Insert",para);
        rs.next();
        id = ""+rs.getInt(1);
        for(int i = 0;i<rownum;i++){
            String stepname = Util.fromScreen(request.getParameter("stepname_"+i),user.getLanguage()) ; 
            String stepstartdate = Util.fromScreen(request.getParameter("stepstartdate_"+i),user.getLanguage()) ; 
            String stependdate = Util.fromScreen(request.getParameter("stependdate_"+i),user.getLanguage()) ;           
            String info = stepname+stepstartdate+stependdate;    
            if(!info.trim().equals("")){
                para = ""+id+separator+stepname+separator+stepstartdate +separator+stependdate;

                rs.executeProc("HrmCareerPlanStep_Insert",para);
            }
        }
            /* Commented by Huang Yu On May 9th ,2004
        if( ! principalid.equals(""+user.getUID())) {

            String accepter="";
            String title="";
            String remark="";
            String submiter="";
            
            accepter = principalid;
            title = SystemEnv.getHtmlLabelName(15743,user.getLanguage());
            title += ":"+topic;
            remark="<a href=/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+id+">"+Util.fromScreen2(title,7)+"</a>";
            submiter=""+user.getUID();
            srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
        }

        if( ! informmanid.equals(""+user.getUID())) {

            String accepter="";
            String title="";
            String remark="";
            String submiter="";
            
            accepter = informmanid;
            title = SystemEnv.getHtmlLabelName(15743,user.getLanguage());
            title += ":"+topic;
            remark="<a href=/hrm/career/HrmCareerPlanEdit.jsp?id="+id+">"+Util.fromScreen2(title,7)+"</a>";
            submiter=""+user.getUID();
            srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
        }
      */

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(topic);
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Insert,"+para);
        SysMaintenanceLog.setOperateItem("70");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
          
        response.sendRedirect("HrmCareerPlan.jsp");
        return;
  }
  
  if(operation.equals("edit")){
        para = ""+id + separator+ topic +separator+ principalid + separator+
               informmanid+ separator+ emailmould  +separator+ startdate   + separator+ 
               budget     + separator+ budgettype  +separator+ memo;    
        rs.executeProc("HrmCareerPlan_Update",para);

        sql = "delete from HrmCareerPlanStep where planid = "+id;
        rs.executeSql(sql);    
        for(int i = 0;i<rownum;i++){
            String stepname = Util.fromScreen(request.getParameter("stepname_"+i),user.getLanguage()) ; 
            String stepstartdate = Util.fromScreen(request.getParameter("stepstartdate_"+i),user.getLanguage()) ; 
            String stependdate = Util.fromScreen(request.getParameter("stependdate_"+i),user.getLanguage()) ;           
            String info = stepname+stepstartdate+stependdate;    
            if(!info.trim().equals("")){
                para = ""+id+separator+stepname+separator+stepstartdate +separator+stependdate;
                   
                rs.executeProc("HrmCareerPlanStep_Insert",para);
            }
        }
          /* Commented BY Charoes Huang
        if( ! principalid.equals(""+user.getUID()) && ! principalid.equals(oldprincipalid)) {

            String accepter="";
            String title = "";
            String remark="";
            String submiter="";
            
            accepter = principalid ;
            title = SystemEnv.getHtmlLabelName(15743,user.getLanguage());
            title += ":"+topic;
            remark="<a href=/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+id+">"+Util.fromScreen2(title,7)+"</a>";
            submiter=""+user.getUID();
            srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
        }

        if( ! informmanid.equals(""+user.getUID()) && ! informmanid.equals(oldinformmanid)) {

            String accepter="";
            String title="";
            String remark="";
            String submiter="";
            
            accepter = informmanid;
            title = SystemEnv.getHtmlLabelName(15743,user.getLanguage());
            title += ":"+topic;
            remark="<a href=/hrm/career/HrmCareerPlanEdit.jsp?id="+id+">"+Util.fromScreen2(title,7)+"</a>";
            submiter=""+user.getUID();
            srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
        }
             */
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(topic);
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Update,"+para);
        SysMaintenanceLog.setOperateItem("70");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
          
        response.sendRedirect("HrmCareerPlanEdit.jsp?id="+id);
        return;
  }
  
  if(operation.equals("delete")){
    para = ""+id;    
    rs.executeProc("HrmCareerPlan_Delete",para);
    
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(topic);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCareerPlan_Delete,"+para);
      SysMaintenanceLog.setOperateItem("70");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    response.sendRedirect("HrmCareerPlan.jsp");
    return;
  }
  
  if(operation.equals("finish")){
    para = ""+id+separator+today+separator+fare+separator+faretype+separator+advice;    
    rs.executeProc("HrmCareerPlan_Finish",para);
    response.sendRedirect("HrmCareerPlanEdit.jsp?id="+id);
    return;
  }
%>
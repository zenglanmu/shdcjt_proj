<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<!--<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>-->
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
    char flag=Util.getSeparator();
    String ProcPara = "";

    String customerids = Util.null2String(request.getParameter("customerids"));
    int rownum = Util.getIntValue(request.getParameter("rownum"),0);

    String userid = "0" ;
    String departmentid = "0" ;
    String roleid = "0" ;
    String foralluser = "0" ;

    String subcompanyid1="";
    int seccategoryid=0;
    int departmentid2=0;
    int ownerid=0;

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
    String CurrentUser = ""+user.getUID();
    String ClientIP = request.getRemoteAddr();
    String SubmiterType = ""+user.getLogintype();


    StringTokenizer stk = new StringTokenizer(customerids,",");
    while(stk.hasMoreTokens()){
        String crmid = stk.nextToken();
        if(!crmid.trim().equals("")){

            /*
            RecordSet.executeProc("CRM_ShareInfo_SbyRelateditemid",crmid);
            while(RecordSet.next()){
                RecordSet2.executeProc("CRM_ShareInfo_Delete",RecordSet.getString("id"));

                ProcPara = crmid;
                ProcPara += flag+"ds";
                ProcPara += flag+"0";
                ProcPara += flag+RecordSet.getString("id");
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                ProcPara += flag+CurrentUser;
                ProcPara += flag+SubmiterType;
                ProcPara += flag+ClientIP;
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                //CrmViewer.setCrmShareByCrm(""+crmid);
            }
            */

            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
                if(sharetype != null){
                    String relatedshareid = Util.null2String(request.getParameter("relatedshareid_"+i));
                    String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
                    String seclevel = Util.null2String(request.getParameter("seclevel_"+i));
                    String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));

                    //System.out.println("crmid="+crmid+";relatedshareid:"+relatedshareid+";rolelevel:"+rolelevel+";seclevel:"+seclevel+";sharelevel:"+sharelevel);

                    if(sharetype.equals("1")) userid = relatedshareid ;
                    if(sharetype.equals("2")) departmentid = relatedshareid ;
                    if(sharetype.equals("3")) roleid = relatedshareid ;
                    if(sharetype.equals("4")) foralluser = "1" ;

                    ProcPara = crmid;
                    ProcPara += flag+sharetype;
                    ProcPara += flag+seclevel;
                    ProcPara += flag+rolelevel;
                    ProcPara += flag+sharelevel;
                    ProcPara += flag+userid;
                    ProcPara += flag+departmentid;
                    ProcPara += flag+roleid;
                    ProcPara += flag+foralluser;
                    String tempcontents="";
                    if(sharetype.equals("1")) tempcontents = userid ;
                    if(sharetype.equals("2")) tempcontents = departmentid ;
                    if(sharetype.equals("3")) tempcontents = roleid ;
                    if(sharetype.equals("4")) tempcontents = "1" ;
                    ProcPara += flag+tempcontents;

                    String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"rolelevel:"+rolelevel+"sharelevel:"+sharelevel+"userid:"+userid+"departmentid:"+departmentid+"roleid:"+roleid+"foralluser:"+foralluser;

                    RecordSet.executeProc("CRM_ShareInfo_Insert",ProcPara);
                    
                    //当前客户的客户联系共享给新的共享对象
                    RecordSet.executeSql("select max(id) as shareobjid from CRM_ShareInfo");
                    RecordSet.next();
                    String shareobjid = RecordSet.getString("shareobjid");
                    if(sharetype.equals("3")){
                	    String crm_manager = "";
                	    RecordSet.executeSql("select manager from crm_customerinfo where id="+crmid);
                	    if(RecordSet.next()) crm_manager = RecordSet.getString("manager");
                	    int crm_manager_dept = Util.getIntValue(ResourceComInfo.getDepartmentID(crm_manager),-1);//部门id
                	    int crm_manager_com = Util.getIntValue(ResourceComInfo.getSubCompanyID(crm_manager),-1);//分部id
                	    if(rolelevel.equals("0"))
                	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_dept+" where relateditemid="+crmid+" and id="+shareobjid);
                	    else if(rolelevel.equals("1"))
                	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_com+" where relateditemid="+crmid+" and id="+shareobjid);
                	}
                    CrmShareBase.setCRM_WPShare_newCRMShare(crmid,shareobjid);

                    /*
                    ProcPara = crmid;
                    ProcPara += flag+"ns";
                    ProcPara += flag+"0";
                    ProcPara += flag+Remark;
                    ProcPara += flag+CurrentDate;
                    ProcPara += flag+CurrentTime;
                    ProcPara += flag+CurrentUser;
                    ProcPara += flag+SubmiterType;
                    ProcPara += flag+ClientIP;
                    RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                    CrmViewer.setCrmShareByCrm(""+crmid);
                    */

                }
            }
        }
    }
    response.sendRedirect("ShareMutiCustomerList.jsp?isstart=1");
%>

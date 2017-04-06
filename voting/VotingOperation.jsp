<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<%
    Date newdate = new Date();
    long datetime = newdate.getTime();
    Timestamp timestamp = new Timestamp(datetime);
    String CurrentDate = (timestamp.toString()).substring(0, 4) + "-" + (timestamp.toString()).substring(5, 7) + "-" + (timestamp.toString()).substring(8, 10);
    String CurrentTime = (timestamp.toString()).substring(11, 13) + ":" + (timestamp.toString()).substring(14, 16) + ":" + (timestamp.toString()).substring(17, 19);
    String userid = user.getUID() + "";


    String method = Util.null2String(request.getParameter("method"));
    String votingid = Util.null2String(request.getParameter("votingid"));
    String subject = Util.null2String(request.getParameter("subject"));
    String detail = Util.fromScreenVoting(request.getParameter("detail"), 7);
    String createrid = Util.null2String(request.getParameter("createrid"));
    String begindate = Util.null2String(request.getParameter("begindate"));
    String begintime = Util.null2String(request.getParameter("begintime"));
    String enddate = Util.null2String(request.getParameter("enddate"));
    String endtime = Util.null2String(request.getParameter("endtime"));
    String isanony = Util.null2String(request.getParameter("isanony"));
    String docid = Util.null2String(request.getParameter("docid"));
    String crmid = Util.null2String(request.getParameter("crmid"));
    String projectid = Util.null2String(request.getParameter("projectid"));
    String requestid = Util.null2String(request.getParameter("requestid"));
    String votingcount = Util.null2String(request.getParameter("votingcount"));
    String status = Util.null2String(request.getParameter("status"));
    
    int votingtype = Util.getIntValue(request.getParameter("votingtype"));//调查类型
    
    String isSeeResult = Util.null2String(request.getParameter("isSeeResult"));//投票后是否可以查看结果

    String approverid = "";
    RecordSet.executeSql("select approverid from votingmaintdetail where createrid=" + createrid);
    if (RecordSet.next()) {
        approverid = RecordSet.getString("approverid");
        if (approverid.equals("0")) approverid = createrid;
    } else {
        approverid = createrid;
    }

    char flag = 2;
    String Procpara = "";

    if (method.equals("add")) {
        Procpara = subject + flag + detail + flag + createrid + flag + CurrentDate + flag + CurrentTime +
                flag + approverid + flag + "" + flag + "" + flag + begindate + flag + begintime +
                flag + enddate + flag + endtime + flag + isanony + flag + docid +
                flag + crmid + flag + projectid + flag + requestid + flag + votingcount + flag + status + flag + isSeeResult;
        RecordSet.executeProc("Voting_Insert", Procpara);
        RecordSet.next();
        votingid = RecordSet.getString(1);
        RecordSet1.executeSql("update Voting set votingtype = "+votingtype+" where id ="+votingid);//更新调查类型
       
        response.sendRedirect("VotingView.jsp?votingid=" + votingid);
        return;
    }

    if (method.equals("edit")) {
        Procpara = votingid + flag + subject + flag + detail + flag + createrid + flag + CurrentDate + flag + CurrentTime +
                flag + approverid + flag + "" + flag + "" + flag + begindate + flag + begintime +
                flag + enddate + flag + endtime + flag + isanony + flag + docid +
                flag + crmid + flag + projectid + flag + requestid + flag + isSeeResult;
        RecordSet.executeProc("Voting_Update", Procpara);
        RecordSet.executeSql("update Voting set votingtype = "+votingtype+" where id ="+votingid);//更新调查类型
        response.sendRedirect("VotingView.jsp?votingid=" + votingid);
        return;
    }
    if (method.equals("submit")) {
        RecordSet.executeSql("select * from voting where id=" + votingid);
        RecordSet.next();
        createrid = RecordSet.getString("createrid");
        approverid = RecordSet.getString("approverid");
        subject = RecordSet.getString("subject");
        votingtype = Util.getIntValue(RecordSet.getString("votingtype"));

        if (!createrid.equals(approverid)) {/*发出请求审批的通知给审批人*/
            String SWFAccepter = approverid;
            String SWFTitle = "网上调查审批";
            SWFTitle += ":" + subject;
            SWFTitle += "-" + ResourceComInfo.getResourcename(createrid);
            SWFTitle += "-" + CurrentDate;
            String SWFRemark = "<a href=/voting/VotingView.jsp?votingid=" + votingid + ">" + subject + "</a>";
            String SWFSubmiter = createrid;
            SysRemindWorkflow.setPrjSysRemind(SWFTitle, 0, Util.getIntValue(SWFSubmiter), SWFAccepter, SWFRemark);
        }
        
        if(votingtype > 0){
        	RecordSet.executeSql("select * from voting_type where id ="+votingtype);
        	if(RecordSet.next()) {
        		int approvewfid = Util.getIntValue(RecordSet.getString("approver"),-1);
        		if(approvewfid > 0) {
        			
        			RecordSet1.executeSql("update Voting set status = '3' where id ="+votingid);//更新调查状态为审批状态
        			
		        	response.sendRedirect("/workflow/request/BillVotingApproveOperation.jsp?src=submit&iscreate=1&votingid="+votingid+"&approvewfid="+approvewfid+"&viewvoting=1");
		        	return;
        		}
        	}
        }
        response.sendRedirect("VotingList.jsp");
        return;
    }
    if (method.equals("delete")) {
        RecordSet.executeProc("Voting_Delete", votingid);
        response.sendRedirect("VotingList.jsp");
        return;
    }
    if (method.equals("approve")) {
        //增加相关文档,项目,客户,流程共享 added by mackjoe at 2007-01-23 td5558
        int docids = 0;
        int crmids = 0;
        int projids = 0;
        RecordSet.executeSql("select a.docid,a.crmid,a.projid,a.requestid,b.* from voting a,votingshare b where a.id=b.votingid and a.id=" + votingid);
        while (RecordSet.next()) {
            docids = Util.getIntValue(RecordSet.getString("docid"));
            crmids = Util.getIntValue(RecordSet.getString("crmid"));
            projids = Util.getIntValue(RecordSet.getString("projid"));
            String sharetype = Util.null2String(RecordSet.getString("sharetype"));
            String seclevel = Util.null2String(RecordSet.getString("seclevel"));
            String rolelevel = Util.null2String(RecordSet.getString("rolelevel"));
            String resourceid = Util.null2String(RecordSet.getString("resourceid"));
            String subcompanyid = Util.null2String(RecordSet.getString("subcompanyid"));
            String departmentid = Util.null2String(RecordSet.getString("departmentid"));
            String roleid = Util.null2String(RecordSet.getString("roleid"));
            String foralluser = Util.null2String(RecordSet.getString("foralluser"));
            String ProcPara = "";
            if (docids > 0) {
                ProcPara = docids + "";
                ProcPara += flag + sharetype;
                ProcPara += flag + seclevel;
                ProcPara += flag + rolelevel;
                ProcPara += flag + "1";
                ProcPara += flag + resourceid;
                ProcPara += flag + subcompanyid;
                ProcPara += flag + departmentid;
                ProcPara += flag + roleid;
                ProcPara += flag + foralluser;
                ProcPara += flag + "0";              //  crmid

                RecordSet1.executeProc("DocShare_IFromDocSecCategory", ProcPara);
            }
            if (crmids > 0 && !sharetype.equals("2")) {
                if(sharetype.equals("3"))  sharetype="2";
                if(sharetype.equals("4"))  sharetype="3";
                if(sharetype.equals("5"))  sharetype="4";
                ProcPara = crmids+"";
                ProcPara += flag+sharetype;
                ProcPara += flag+seclevel;
                ProcPara += flag+rolelevel;
                ProcPara += flag+"1";
                ProcPara += flag+resourceid;
                ProcPara += flag+departmentid;
                ProcPara += flag+roleid;
                ProcPara += flag+foralluser;

                RecordSet1.executeProc("CRM_ShareInfo_Insert",ProcPara);
            }
            if (projids > 0 && !sharetype.equals("2")) {
                if(sharetype.equals("3"))  sharetype="2";
                if(sharetype.equals("4"))  sharetype="3";
                if(sharetype.equals("5"))  sharetype="4";
                ProcPara = projids+"";
                ProcPara += flag+sharetype;
                ProcPara += flag+seclevel;
                ProcPara += flag+rolelevel;
                ProcPara += flag+"1";
                ProcPara += flag+resourceid;
                ProcPara += flag+departmentid;
                ProcPara += flag+roleid;
                ProcPara += flag+foralluser;

                RecordSet1.executeProc("Prj_ShareInfo_Insert",ProcPara);
            }
        }
        if (docids > 0) DocViewer.setDocShareByDoc(""+docids);
        if (crmids > 0) CrmViewer.setCrmShareByCrm(""+crmids);
        if (projids > 0) PrjViewer.setPrjShareByPrj(""+projids);
        //added end
        RecordSet.executeProc("Voting_UpdateStatus", votingid + flag + "1");
        String sql = "update voting set approverid=" + userid + ",approvedate='" + CurrentDate + "',approvetime='" + CurrentTime + "' where id=" + votingid;
        RecordSet.executeSql(sql);
        response.sendRedirect("VotingView.jsp?votingid=" + votingid);
        return;
    }
    if (method.equals("finish")) {
        RecordSet.executeProc("Voting_UpdateStatus", votingid + flag + "2");
        response.sendRedirect("VotingView.jsp?votingid=" + votingid);
        return;
    }
%>
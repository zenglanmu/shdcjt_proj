<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

char flag=Util.getSeparator();
String sql = "";
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String wtid = Util.null2String(request.getParameter("wtid")); 

if(method.equals("addMutil")){   
	String[] shareValues = request.getParameterValues("txtShareDetail"); 
	if (shareValues!=null) {       
		for (int i=0;i<shareValues.length;i++){
			String[] paras = Util.TokenizerString2(shareValues[i],"_");
			String sharetype = paras[0];
			String seclevel=paras[3];
			String roleid="0";
			String rolelevel="0";
			String userid = "0";
			String departmentid = "0" ;
			String subcompanyid="0";
			String foralluser = "0";
			if(sharetype.equals("4")){
				roleid = paras[1];
				rolelevel = paras[2];
			}
			if(sharetype.equals("5")){
				foralluser = "1";
			}
			if ("1".equals(sharetype)||"3".equals(sharetype)||"9".equals(sharetype)||sharetype.equals("2")){  //1:多人力资源    3:多部门...2:多分部
				String tempStrs[]=Util.TokenizerString2(paras[1],",");
				for(int k=0;k<tempStrs.length;k++){
					String tempStr = tempStrs[k];
					if ("1".equals(sharetype)) userid=tempStr;
					if ("3".equals(sharetype)) departmentid=tempStr;
					if ("2".equals(sharetype))  subcompanyid =tempStr;
					// end
					ProcPara = wtid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+userid;
					ProcPara += flag+subcompanyid;
					ProcPara += flag+departmentid;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
					//System.out.println("ProcPara for = " + ProcPara);
					RecordSet.executeProc("WorkTaskCreateShare_Insert",ProcPara);
				}
			}else{
				ProcPara = wtid;
				ProcPara += flag+sharetype;
				ProcPara += flag+seclevel;
				ProcPara += flag+rolelevel;
				ProcPara += flag+userid;
				ProcPara += flag+subcompanyid;
				ProcPara += flag+departmentid;
				ProcPara += flag+roleid;
				ProcPara += flag+foralluser;
				//System.out.println("ProcPara = " + ProcPara);
				RecordSet.executeProc("WorkTaskCreateShare_Insert",ProcPara);
			}
		}
	}
	String delids = Util.null2String(request.getParameter("delids"));
	if(!"".equals(delids)){
		delids = delids.substring(0, delids.length()-1);
		sql = "delete from worktaskcreateshare where id in ("+delids+")";
		//System.out.println("sql = " + sql);
		RecordSet.execute(sql);
	}
	response.sendRedirect("worktaskCreateRight.jsp?para=1_"+wtid);
	return;
}
if(method.equals("delMShare")){
	String[] delShareIds = request.getParameterValues("chkShareId");
	if (delShareIds!=null){
		for(int i=0;i<delShareIds.length;i++){
			RecordSet.executeProc("WorkTaskCreateShare_Delete",delShareIds[i]);
		}
	}
	response.sendRedirect("worktaskCreateRight.jsp?para=1_"+wtid);
	return;
}
%>

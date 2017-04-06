<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%	
	if(!HrmUserVarify.checkUserRight("newstype:maint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
	String method = Util.null2String(request.getParameter("txtMethod"));
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.convertInput2DB(Util.null2String(request.getParameter("txtName")));
	String DocTypeName = Util.convertInput2DB(Util.null2String(request.getParameter("DocTypeName")));
	String desc = Util.convertInput2DB(Util.null2String(request.getParameter("txtDesc")));
	String dspNum = Util.null2String(request.getParameter("txtDspNum"));
	String sql="";
	if("add".equals(method)){
		sql="insert into newstype (typename,typedesc,dspNum) values('"+name+"','"+desc+"',"+dspNum+")";		
		rs.executeSql(sql);
		CheckItemComInfo.removeCheckCache() ;
	  SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("insert into newstype (typename,typedesc,dspNum) values('"+name+"','"+desc+"',"+dspNum+")");
      SysMaintenanceLog.setOperateItem("100");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("newstypeList.jsp");
	} else if ("edit".equals(method)){
		sql="update  newstype set typename='"+name+"',typedesc='"+desc+"',dspNum="+dspNum+" where id="+id;	
		//out.println(sql);
		rs.executeSql(sql);
		CheckItemComInfo.removeCheckCache() ;
	  SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("update  newstype set typename='"+name+"',typedesc='"+desc+"',dspNum="+dspNum+" where id="+id);
      SysMaintenanceLog.setOperateItem("100");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("newstypeList.jsp");
	} else if ("del".equals(method)){
		rs.executeSql("select count(0) from DocFrontpage where newstypeid="+id);
		if(rs.next()&&Util.getIntValue(rs.getString(1))>0){
			response.sendRedirect("newstypeAdd.jsp?id="+id+"&type=edit&msg="+"21089");
			return;
		} else {
			sql="delete  newstype  where id="+id;		
			rs.executeSql(sql);
		/*
		sql="update DocFrontpage set newstypeid=0,typeordernum=0  where newstypeid="+id;		
		rs.executeSql(sql);
		*/
		CheckItemComInfo.removeCheckCache() ;
	  SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(DocTypeName);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("delete  newstype  where id="+id);
      SysMaintenanceLog.setOperateItem("100");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("newstypeList.jsp");
		}
	}
%>
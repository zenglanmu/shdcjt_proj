<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" language="javascript">
    function delSendUrl(){
        parent.location.href="/cpt/maintenance/CptAssortment.jsp";
    }
    function addEditSendUrl(paraid){
        location.href="/cpt/maintenance/CptAssortmentView.jsp?paraid="+paraid;
        parent.treeFrame.treeFrame.location.href="/cpt/maintenance/CptAssortmentTree.jsp?paraid="+paraid;
    }
</script>
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addassortment")||operation.equals("editassortment")){
	String assortmentname = Util.fromScreen(request.getParameter("assortmentname"),user.getLanguage());
	String assortmentmark = Util.fromScreen(request.getParameter("assortmentmark"),user.getLanguage());
	String supassortmentid = Util.null2String(request.getParameter("supassortmentid"));
	String supassortmentstr = Util.null2String(request.getParameter("supassortmentstr"));
	String assortmentremark=Util.fromScreen(request.getParameter("Remark"),user.getLanguage());


 if(operation.equals("addassortment")){
	String para = "";

	para  = assortmentname;
	para += separator+assortmentmark;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;


	/*判断是否编号重复*/
	RecordSet.executeProc("CptCapitalAssortment_SelectAll","");
	while(RecordSet.next()){
		String 	tempmark = RecordSet.getString("assortmentmark");
		String  tempsupassortmentstr = RecordSet.getString("supassortmentstr");
		if(assortmentmark.equals(tempmark)&&supassortmentstr.equals(tempsupassortmentstr)){
			response.sendRedirect("CptAssortmentAdd.jsp?msgid=31&paraid="+supassortmentid);
			return;
		}
	}
		/*判断统计资产组是否重名*/
	String sql = "select assortmentname from CptCapitalAssortment where assortmentname='"+assortmentname+"' and supassortmentid="+supassortmentid;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		response.sendRedirect("CptAssortmentAdd.jsp?msgid=162&paraid="+supassortmentid);
		return;
	}
	RecordSet.executeProc("CptCapitalAssortment_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("CptAssortmentAdd.jsp?msgid=34&paraid="+supassortmentid);
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(assortmentname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("CptCapitalAssortment_Insert,"+para);
	SysMaintenanceLog.setOperateItem("43");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
	//response.sendRedirect("CptAssortmentView.jsp?paraid="+id);
    if(1==1){%>
        <script type="text/javascript" language="javascript">
            addEditSendUrl("<%=id%>");
        </script>
    <%    }
    return;
} //end (operation.equals("addassortment"))
 else if(operation.equals("editassortment")){
  	String assortmentid = Util.null2String(request.getParameter("assortmentid"));

	String para = "";
	para = assortmentid;
	para += separator+assortmentname;
	para += separator+assortmentmark;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;


	/*判断是否编号重复*/
	RecordSet.executeProc("CptCapitalAssortment_SelectAll","");
	while(RecordSet.next()){
		String  tempid = RecordSet.getString("id");
		String 	tempmark = RecordSet.getString("assortmentmark");
		String  tempsupassortmentstr = RecordSet.getString("supassortmentstr");
		if(assortmentmark.equals(tempmark)&&supassortmentstr.equals(tempsupassortmentstr)&&!assortmentid.equals(tempid)){
			response.sendRedirect("CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=31");
			return;
		}
	}
	/*判断资产组是否重名*/
	String sql = "select assortmentname from CptCapitalAssortment where assortmentname='"+assortmentname+"' and supassortmentid="+supassortmentid+"and id<>"+assortmentid;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		response.sendRedirect("/cpt/maintenance/CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=162");
		return;
	}
	//更新
	RecordSet.executeProc("CptCapitalAssortment_Update",para);


	if(RecordSet.next()) {

		response.sendRedirect("CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=13");
		return ;
	}
	
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(assortmentid));
	SysMaintenanceLog.setRelatedName(assortmentname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("CptCapitalAssortment_Update,"+para);
	SysMaintenanceLog.setOperateItem("43");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
	//response.sendRedirect("CptAssortmentView.jsp?paraid="+assortmentid);
    if(1==1){%>
        <script type="text/javascript" language="javascript">
            addEditSendUrl("<%=assortmentid%>");
        </script>
    <%    }
 }//end if (operation.equals("editassortment"))
}//end if (operation.equals("addassortment")||operation.equals("editassortment"))
 else if(operation.equals("deleteassortment")){
  	int assortmentid = Util.getIntValue(request.getParameter("assortmentid"));

	String para = ""+assortmentid;
	RecordSet.executeProc("CptCapitalAssortment_Delete",para);

	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("CptAssortmentView.jsp?paraid="+assortmentid+"&msgid=20");
		return ;
	}

    CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
    if(1==1){%>
    <script type="text/javascript" language="javascript">
        delSendUrl();
    </script>
<%    }
 }
%>


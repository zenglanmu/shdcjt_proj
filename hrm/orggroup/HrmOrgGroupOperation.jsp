<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%

    if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("AddSave")){

	int id = 0;

    String orgGroupName=Util.null2String(request.getParameter("orgGroupName"));
	orgGroupName=Util.toHtml100(orgGroupName);
    String orgGroupDesc=Util.null2String(request.getParameter("orgGroupDesc"));
	orgGroupDesc=Util.toHtml100(orgGroupDesc);
    double showOrder=Util.getDoubleValue(request.getParameter("showOrder"),0);

    RecordSet.executeSql(" insert into HrmOrgGroup(orgGroupName,orgGroupDesc,showOrder,isDelete) values('"+orgGroupName+"','"+orgGroupDesc+"',"+showOrder+",'0') ");
	
    RecordSet.executeSql("select max(id) from HrmOrgGroup where orgGroupName='"+orgGroupName+"' and showOrder="+showOrder);
	if(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString(1),0);
	}

    HrmOrgGroupComInfo.removeHrmOrgGroupCache();

	if(id<=0){
		out.write("<script>try{opener._table.reLoad();window.close();}catch(e){}</script>");
	}else{
		response.sendRedirect("HrmOrgGroupEdit.jsp?id="+id);
	}
}else if(operation.equals("EditSave")){    

	int id = Util.getIntValue(request.getParameter("id"),0);

    String orgGroupName=Util.null2String(request.getParameter("orgGroupName"));
	orgGroupName=Util.toHtml100(orgGroupName);
    String orgGroupDesc=Util.null2String(request.getParameter("orgGroupDesc"));
	orgGroupDesc=Util.toHtml100(orgGroupDesc);
    double showOrder=Util.getDoubleValue(request.getParameter("showOrder"),0);

    RecordSet.executeSql("update HrmOrgGroup set orgGroupName='"+orgGroupName+"',orgGroupDesc='"+orgGroupDesc+"',showOrder="+showOrder+" where id =  "+id);

    HrmOrgGroupComInfo.removeHrmOrgGroupCache();

    out.write("<script>try{opener._table.reLoad();window.close();}catch(e){}</script>");

}else if(operation.equals("Delete")){
	int id = Util.getIntValue(request.getParameter("id"),0);
    RecordSet.executeSql("update HrmOrgGroup set isDelete='1' where id = "+id);
    
    HrmOrgGroupComInfo.removeHrmOrgGroupCache();

    out.write("<script>try{opener._table.reLoad();window.close();}catch(e){}</script>");
}
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">
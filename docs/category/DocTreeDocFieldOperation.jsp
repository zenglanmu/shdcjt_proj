<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%

String operation=Util.null2String(request.getParameter("operation"));

String treeDocFieldId=Util.null2String(request.getParameter("id"));
String treeDocFieldName = Util.fromScreen(request.getParameter("treeDocFieldName"),user.getLanguage());
String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
String showOrder=Util.null2String(request.getParameter("showOrder"));

String treeDocFieldDesc=Util.null2String(request.getParameter("treeDocFieldDesc"));
String mangerids=Util.null2String(request.getParameter("mangerids"));

String allSuperiorFieldId="";
String level="0";
String isLast="0";

if(superiorFieldId.equals("")||superiorFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){
	superiorFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
    allSuperiorFieldId=superiorFieldId;
	level="1";
}else{
    allSuperiorFieldId=DocTreeDocFieldComInfo.getAllSuperiorFieldId(superiorFieldId)+","+superiorFieldId;
	level=String.valueOf(Integer.parseInt(DocTreeDocFieldComInfo.getLevel(superiorFieldId))+1);
}

if(treeDocFieldName!=null){
	treeDocFieldName=treeDocFieldName.trim();
}


if(operation.equals("RootEditSave")){

	RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"'  where id="+treeDocFieldId);

    DocTreeDocFieldComInfo.updateDocTreeDocFieldInfoCache(treeDocFieldId);
    response.sendRedirect("DocTreeDocFieldFrame.jsp");
	return;
 }
 else if(operation.equals("AddSave")){
    //将上级的是否末级改为否
	DocTreeDocFieldManager.updateDataOfNewSuperiorField(superiorFieldId);

    //插入数据
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  begin
	//RecordSet.executeSql("insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,level,isLast,showOrder) values('"+treeDocFieldName+"',"+superiorFieldId+",'"+allSuperiorFieldId+"',"+level+",'1',"+showOrder+")");
	RecordSet.executeSql("insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,fieldLevel,isLast,showOrder,treeDocFieldDesc,mangerids) values('"+treeDocFieldName+"',"+superiorFieldId+",'"+allSuperiorFieldId+"',"+level+",'1',"+showOrder+",'"+treeDocFieldDesc+"','"+mangerids+"')");
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  end

    //获得记录的id
	RecordSet.executeSql(" select max(id) from DocTreeDocField ");

	if(RecordSet.next()){
		treeDocFieldId=Util.null2String(RecordSet.getString(1));
	}

    //清除缓存中的内容
    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
    response.sendRedirect("DocTreeDocFieldFrame.jsp?treeDocFieldId="+treeDocFieldId);
	return;
 }
 else if(operation.equals("EditSave")){

    String hisSuperiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
    //在上级改变的情况下,更新原来的上级的值,所有下级的“级别”和“所有上级”字段的值
    if(!superiorFieldId.equals(hisSuperiorFieldId)){
		DocTreeDocFieldManager.updateDataOfNewSuperiorField(superiorFieldId);//将上级的是否末级改为否
		DocTreeDocFieldManager.updateDataOfHisSuperiorField(treeDocFieldId,hisSuperiorFieldId);
		DocTreeDocFieldManager.updateDataOfAllSubTreeDocField(treeDocFieldId,allSuperiorFieldId,level);
	}

    //更新记录的值
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  begin
	//RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"',superiorFieldId="+superiorFieldId+",allSuperiorFieldId='"+allSuperiorFieldId+"',level="+level+",showOrder="+showOrder+" where id="+treeDocFieldId);
	RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"',superiorFieldId="+superiorFieldId+",allSuperiorFieldId='"+allSuperiorFieldId+"',fieldLevel="+level+",showOrder="+showOrder+",treeDocFieldDesc='"+treeDocFieldDesc+"',mangerids='"+mangerids+"' where id="+treeDocFieldId);
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  end

    //清除缓存中的内容
    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
    response.sendRedirect("DocTreeDocFieldFrame.jsp?treeDocFieldId="+treeDocFieldId);
	return;
 } else if(operation.equals("Delete")){  
    String hisSuperiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
	DocTreeDocFieldManager.updateDataOfHisSuperiorField(treeDocFieldId,hisSuperiorFieldId);

	RecordSet.executeSql("delete from DocTreeDocField where id="+treeDocFieldId);
	
    superiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(""+treeDocFieldId);

    //清除缓存中的内容
    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
    response.sendRedirect("DocTreeDocFieldFrame.jsp?treeDocFieldId="+superiorFieldId);
	return;
 }
%>

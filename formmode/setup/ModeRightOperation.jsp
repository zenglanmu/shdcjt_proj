<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%
String MaxShare = Util.null2String(request.getParameter("MaxShare"));
if(MaxShare.equals("")){
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}
%>
<%
String method = Util.null2String(request.getParameter("method"));
int modeId = Util.getIntValue(request.getParameter("modeId"),0);

if(method.equals("addNew")){//新增权限
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	if(txtShareDetail != null){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];
			//System.out.println("txtSD="+txtSD);
			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			modeRightInfo.init();
			modeRightInfo.setModeId(modeId);
			modeRightInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			modeRightInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			modeRightInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
			modeRightInfo.setShowlevel(Util.getIntValue((String)txtSDList.get(3),0));
			modeRightInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			modeRightInfo.insertAddRight();
		}
	}
}else if(method.equals("delete")){//删除权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		modeRightInfo.init();
		modeRightInfo.setModeId(modeId);
		modeRightInfo.delShareByIds(mainids);
	}
}else if(method.equals("saveForCreator")){//保存默认权限(创建人相关)
	int creator = Util.getIntValue(request.getParameter("creator"),99);
	int creatorleader = Util.getIntValue(request.getParameter("creatorleader"),99);
	int creatorSub = Util.getIntValue(request.getParameter("creatorSub"),99);
	int creatorSubsl = Util.getIntValue(request.getParameter("creatorSubsl"),10);
	int creatorDept = Util.getIntValue(request.getParameter("creatorDept"),99);
	int creatorDeptsl = Util.getIntValue(request.getParameter("creatorDeptsl"),99);
	
	modeRightInfo.init();
	modeRightInfo.setModeId(modeId);
	modeRightInfo.setCreator(creator);
	modeRightInfo.setCreatorleader(creatorleader);
	modeRightInfo.setCreatorSub(creatorSub);
	modeRightInfo.setCreatorSubsl(creatorSubsl);
	modeRightInfo.setCreatorDept(creatorDept);
	modeRightInfo.setCreatorDeptsl(creatorDeptsl);
	modeRightInfo.updateShareCreator();
	
}else if(method.equals("addShare")){//前台设置权限
	String oldIds = Util.null2String(request.getParameter("oldIds"));
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	int billid  = Util.getIntValue(request.getParameter("billid"),0);
	if(!oldIds.equals(""))
		rs.executeSql("delete from modeDataShare_"+modeId+" where id in ("+oldIds+")");
	if(txtShareDetail != null && txtShareDetail.length >0){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];
			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			modeRightInfo.init();
			modeRightInfo.setModeId(modeId);
			modeRightInfo.setSourceid(billid);
			modeRightInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			modeRightInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			modeRightInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
			modeRightInfo.setShowlevel(Util.getIntValue((String)txtSDList.get(3),0));
			modeRightInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			modeRightInfo.insertAddRightView();
		}
	}
	response.sendRedirect("/formmode/view/ModeShare.jsp?ajax=2&modeId="+modeId+"&billid="+billid+"&MaxShare="+MaxShare);
}
response.sendRedirect("ModeRightEdit.jsp?ajax=1&modeId="+modeId);
%>
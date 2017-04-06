<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<html>
  <head>
  </head>
  <body>
  <%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
  %>
  <%
  String operate = Util.null2String(request.getParameter("operate"));
  
  String modeId = Util.null2String(request.getParameter("modeId"));
  String modeName = Util.null2String(request.getParameter("modeName"));
  String modeDesc = Util.null2String(request.getParameter("modeDesc"));
  String typeId = Util.null2String(request.getParameter("typeId"));
  String formId = Util.null2String(request.getParameter("formId"));
  String maincategory = Util.null2String(request.getParameter("maincategory"));
  String subcategory = Util.null2String(request.getParameter("subcategory"));
  String seccategory = Util.null2String(request.getParameter("seccategory"));
  String isImportDetail = Util.null2String(request.getParameter("isImportDetail"));
	  
  String customerValue = Util.null2String(request.getParameter("customerValue"));
  String isloadleft = "0";
  String sql = "";
  if(operate.equals("AddMode")){	//新增模板
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setTypeId(typeId);
	  ModeSetUtil.setModeName(modeName);
	  ModeSetUtil.setModeDesc(modeDesc);
	  ModeSetUtil.setMaincategory(maincategory);
	  ModeSetUtil.setSubcategory(subcategory);
	  ModeSetUtil.setSeccategory(seccategory);
	  ModeSetUtil.setIsImportDetail(isImportDetail);
	  ModeSetUtil.addMode();
	  modeId = String.valueOf(ModeSetUtil.getModeId());
	  isloadleft = "1";
  }else if(operate.equals("EditMode")){	//编辑模板
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setModeName(modeName);
	  ModeSetUtil.setModeDesc(modeDesc);
	  ModeSetUtil.setTypeId(typeId);
	  ModeSetUtil.setModeId(Util.getIntValue(modeId,0));
	  ModeSetUtil.setMaincategory(maincategory);
	  ModeSetUtil.setSubcategory(subcategory);
	  ModeSetUtil.setSeccategory(seccategory);
	  ModeSetUtil.setIsImportDetail(isImportDetail);
	  ModeSetUtil.editMode();
	  isloadleft = "1";
  }else if(operate.equals("DefaultValue")){
	  String selfieldId[] = Util.null2String(request.getParameter("fieldid")).split("_");
	  int fieldId = 0;
	  if(selfieldId.length>1) fieldId = Util.getIntValue(selfieldId[1],0);
	  
	  ModeSetUtil.setModeId(Util.getIntValue(modeId,0));
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setFieldId(fieldId);
	  ModeSetUtil.setCustomerValue(customerValue);
	  ModeSetUtil.saveDefualtValue();
	  response.sendRedirect("/formmode/setup/DefaultValueSet.jsp?ajax=1&modeId="+modeId);
  }else if(operate.equals("delDefaultValue")){
	  String selfieldId[] = request.getParameterValues("check_mode");
	  ModeSetUtil.setDefaultValueId(selfieldId);
	  ModeSetUtil.deleteDefualtValue();
	  response.sendRedirect("/formmode/setup/DefaultValueSet.jsp?ajax=1&modeId="+modeId);
  }else if(operate.equals("linkageattr")){
	  System.out.println(operate);
	  modeLinkageInfo.setModeId(Util.getIntValue(modeId,0));
	  System.out.println("modeId="+modeId);
	  boolean fly = modeLinkageInfo.LinkageSave(request);
	  System.out.println("fly="+fly);
	  response.sendRedirect("/formmode/setup/LinkageAttr.jsp?ajax=1&modeId="+modeId);
  }
  response.sendRedirect("/formmode/setup/ModeBasic.jsp?ajax=1&modeId="+modeId+"&typeId="+typeId+"&isloadleft="+isloadleft);
  %>
  </body>
</html>

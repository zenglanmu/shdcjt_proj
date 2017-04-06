
<jsp:useBean id="BaseBeanOfPDF417ManagerConf" class="weaver.general.BaseBean" scope="page" />

<%
//	String PDF417ManagerClientName="PDF417Manager.dll#version=6.0.0.28";
//	String PDF417ManagerClassId="CLSID:8AA64ECD-DFCB-4B88-A2B0-6A5C465D3F15";
//	String PDF417ManagerCopyRight="金格科技PDF417公文二维条码中间件[演示版]www.goldgrid.com";

	String PDF417ManagerClientName=Util.null2String(BaseBeanOfPDF417ManagerConf.getPropValue("weaver_obj","PDF417ManagerClientName"));
    if(PDF417ManagerClientName==null||PDF417ManagerClientName.trim().equals("")){
		PDF417ManagerClientName="PDF417Manager.dll#version=6,0,0,30";
	}

	String PDF417ManagerClassId=Util.null2String(BaseBeanOfPDF417ManagerConf.getPropValue("weaver_obj","PDF417ManagerClassId"));
    if(PDF417ManagerClassId==null||PDF417ManagerClassId.trim().equals("")){
		PDF417ManagerClassId="CLSID:8AA64ECD-DFCB-4B88-A2B0-6A5C465D3F15";
	}

	String PDF417ManagerCopyRight=Util.null2String(BaseBeanOfPDF417ManagerConf.getPropValue("weaver_obj","PDF417ManagerCopyRight"));
	if(!PDF417ManagerCopyRight.trim().equals("")){
		PDF417ManagerCopyRight = (new String(PDF417ManagerCopyRight.getBytes("ISO8859_1"),"GBK")) ;
	}
    if(PDF417ManagerCopyRight.trim().equals("")){
		PDF417ManagerCopyRight="金格公文二维条码中间件[演示版]";
	}
%>


<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docs.DocUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="dci" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
    String operation=Util.null2String(request.getParameter("operation"));
    String otype=Util.null2String(request.getParameter("otype"));
    String ifrepeatedname = Util.null2String(request.getParameter("ifrepeatedname"));
    int srcmainid=0;
    int srcsubid=0;
    int srcsecid=0;
    int objmainid=0;
    int objsubid=0; 
    int objsecid=0;
    
    String[] selectedPropertyMapping = request.getParameterValues("selectedPropertyMapping");
    
    String docStrs = Util.null2String(request.getParameter("docStrs"));
    String docids[]= Util.TokenizerString2(docStrs,",");
    srcmainid=Util.getIntValue(request.getParameter("srcmainid"),0);
    srcsubid=Util.getIntValue(request.getParameter("srcsubid"),0);
    srcsecid=Util.getIntValue(request.getParameter("srcsecid"),0);
    objmainid=Util.getIntValue(request.getParameter("objmainid"),0);
    objsubid=Util.getIntValue(request.getParameter("objsubid"),0);
    objsecid=Util.getIntValue(request.getParameter("objsecid"),0);
    AclManager am = new AclManager();

	if(operation.equalsIgnoreCase("move") && docids != null){
		if(!HrmUserVarify.checkUserRight("DocCopyMove:Move", user)) {
		    if (!am.hasPermission(srcsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_MOVEDOC)) {
    		    response.sendRedirect("/notice/noright.jsp");
    		    return;
    		}
		}
		for(int i=0;i<docids.length;i++){
			int docid=0;
			String subject="";
			docid=Util.getIntValue(docids[i],0);
			subject=Util.null2String(dci.getDocname(docids[i]));
			//如果目标子目录允许文件名重复
			DocUtil docUtil = new DocUtil();
			if("yes".equals(ifrepeatedname) || ("no".equals(ifrepeatedname) && !docUtil.ifRepeatName(objsecid,subject))){
			DocManager.setId(docid);
            DocManager.setUserid(user.getUID());
            DocManager.setUsertype(user.getLogintype());
			DocManager.setDocsubject(subject);
            DocManager.setClientAddress(request.getRemoteAddr());
			DocManager.setMaincategory(objmainid);
			DocManager.setSubcategory(objsubid);
			DocManager.setSeccategory(objsecid);
			
			DocManager.setCustomDataIdMapping(selectedPropertyMapping);
			
			DocManager.moveDoc();
			}
		}
	}
	if(operation.equalsIgnoreCase("copy")  && docids != null){
		if(!HrmUserVarify.checkUserRight("DocCopyMove:Copy", user)) {
		    if (!am.hasPermission(srcsecid, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_COPYDOC)) {
    		    response.sendRedirect("/notice/noright.jsp");
    		    return;
    		}
		}
		for(int i=0;i<docids.length;i++){
			int docid=0;
			String subject="";
			docid=Util.getIntValue(docids[i],0);
            subject=Util.null2String(dci.getDocname(docids[i]));
			//如果目标子目录允许文件名重复
			DocUtil docUtil = new DocUtil();
			if("yes".equals(ifrepeatedname) || ("no".equals(ifrepeatedname) && !docUtil.ifRepeatName(objsecid,subject))){
			DocManager.setId(docid);
            DocManager.setUserid(user.getUID());
            DocManager.setUsertype(user.getLogintype());
            DocManager.setDocsubject(subject);
            DocManager.setClientAddress(request.getRemoteAddr());
			DocManager.setMaincategory(objmainid);
			DocManager.setSubcategory(objsubid);
			DocManager.setSeccategory(objsecid);

			DocManager.setCustomDataIdMapping(selectedPropertyMapping);

			DocManager.copyDoc();
			}
		}
	}
	response.sendRedirect("DocCopyMove.jsp?srcmainid="+srcmainid+"&srcsubid="+srcsubid+"&srcsecid="+srcsecid+"&objmainid="+objmainid+"&objsubid="+objsubid+"&objsecid="+objsecid+"&otype="+otype);

%>
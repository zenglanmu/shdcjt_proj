<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<%
    FileUpload fu = new FileUpload(request);

	String type = Util.null2String(fu.getParameter("type"));
	String coworkids = Util.null2String(fu.getParameter("coworkid"));
	ArrayList coworkidList = Util.TokenizerString(coworkids,",");
	String flag="";
	if("createLabel".equals(type)){
		flag = CoworkItemMarkOperation.createLabel(user.getUID()+"",fu)+"";
		response.sendRedirect("/cowork/labelSetting.jsp");
	}else if("isExist".equals(type)){
		String name = Util.null2String(fu.getParameter("name"));
		flag = CoworkItemMarkOperation.isExistLabel(user.getUID()+"",name)+"";
		out.println(flag);
	}else if("getLabel".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabels(user.getUID()+"",user.getLanguage());
		out.println(flag);
	}else if("addLabel".equals(type)){
		String labelids = Util.null2String(fu.getParameter("labelids"));
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			flag+=CoworkItemMarkOperation.addItemLabels(coworkid,user.getUID()+"",labelids)+",";
		}
	}else if("getLabelForManage".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabelsForManage(user.getUID()+"", user.getLanguage());
	}else if("deleteLabel".equals(type)){
		String id = Util.null2String(fu.getParameter("id"));
		flag = CoworkItemMarkOperation.deleteLabel(id)+""; 
	}else if("editLabel".equals(type)){
		flag = CoworkItemMarkOperation.updateLabel(fu)+"";
		response.sendRedirect("/cowork/labelSetting.jsp");
	}else if("setLabel".equals(type)){
		flag = CoworkItemMarkOperation.updateLabel(fu)+"";
		response.sendRedirect("/cowork/coworkview.jsp");
	}else if("getLabelsForTab".equals(type)){
		flag = CoworkItemMarkOperation.getUserLabelsForTab(user.getUID()+"");
	}else{
		CoworkDAO dao=new CoworkDAO();
		for(int i=0;i < coworkidList.size(); i++){
			String coworkid = (String)coworkidList.get(i);
			flag+= CoworkItemMarkOperation.markItemAsType(user.getUID()+"",coworkid,type)+",";
			//Ìí¼ÓÒÑ¶Á¼ÇÂ¼
			if(type.equals("read"))
				dao.addCoworkLog(Integer.parseInt(coworkid),2,user.getUID(),fu);
		}	 
	}
%>
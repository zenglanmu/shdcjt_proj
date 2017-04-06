<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ page import = "weaver.formmode.tree.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "weaver.general.*" %>
<%@ page import = "net.sf.json.JSONArray" %>
<%@ page import = "net.sf.json.JSONObject" %>
<%
	String id = Util.null2String(request.getParameter("id"));
	String init = Util.null2String(request.getParameter("init"));
	String pid = Util.null2String(request.getParameter("pid"));
	//System.out.println("id:"+id+"	init:"+init+"	pid:"+pid);
	//String supid = Util.null2String(request.getParameter("supid"));
	//System.out.println("supid:"+supid);
	//System.out.println(request.getQueryString());
    CustomTreeData CustomTreeData = new CustomTreeData();
    List<TreeNode> tlist = CustomTreeData.getTreeData(init,id,pid);

    try {
        JSONArray jsonArray = JSONArray.fromObject(tlist);
        response.getWriter().write(jsonArray.toString());    
    } catch (Exception e) {   
        new BaseBean().writeLog("/formmode/tree/CustomTreeAjax.jsp");
        new BaseBean().writeLog(e);
    }
%>


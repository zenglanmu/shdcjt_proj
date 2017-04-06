<%@ page language="java" contentType="application/x-json;charset=GBK" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>

<%
	int viewType = Util.getIntValue(request.getParameter("viewType")); //1:为待办事宜
	int eid = Util.getIntValue(request.getParameter("eid"));
	String node = Util.null2String(request.getParameter("node"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	if (tabId.equals("")) {
		tabId = "1";
	}
	String arrNode[] = Util.TokenizerString2(node, "_");
	String type = arrNode[0];
	String value = arrNode[1];

	//System.out.println(type);
	//System.out.println(value);

	String typeids = "";
	String flowids = "";
	String nodeids = "";
	ArrayList typeidList = new ArrayList();
	ArrayList flowidList = new ArrayList();
	ArrayList nodeidList = new ArrayList();

	rs.executeSql("select * from hpsetting_wfcenter where eid=" + eid+ " and tabId='" + tabId + "'");

	if (rs.next()) {
		typeids = Util.null2String(rs.getString("typeids"));
		flowids = Util.null2String(rs.getString("flowids"));
		nodeids = Util.null2String(rs.getString("nodeids"));

		typeidList = Util.TokenizerString(typeids, ",");
		flowidList = Util.TokenizerString(flowids, ",");
		nodeidList = Util.TokenizerString(nodeids, ",");
	} else {
		if (session.getAttribute(eid + "_Add") != null) {
			Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
			if (tabAddList.containsKey(tabId)) {
				Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
				typeids = Util.null2String((String) tabInfo.get("typeids"));
				flowids = Util.null2String((String) tabInfo.get("flowids"));
				nodeids = Util.null2String((String) tabInfo.get("nodeids"));
		
				typeidList = Util.TokenizerString(typeids, ",");
				flowidList = Util.TokenizerString(flowids, ",");
				nodeidList = Util.TokenizerString(nodeids, ",");
			}
		}
	}

	
	
	
	
	
	JSONArray jsonArrayReturn = new JSONArray();
	
	if ("root".equals(type)) { //主目录下的数据
		ArrayList rootExpandList=new ArrayList();
		if(!"".equals(nodeids)){
			rs.execute("select distinct t3.id from workflow_flownode t1, workflow_base t2,workflow_type t3 where t3.id=t2.workflowtype and t2.id = t1.workflowid and t1.nodeid in ("+nodeids+")");
			while(rs.next()){
				rootExpandList.add(rs.getString("id"));
			}
		}else if(!"".equals(flowids)){
			rs.execute("select distinct t3.id from  workflow_base t2,workflow_type t3 where t3.id=t2.workflowtype and t2.id  in ("+flowids+")");
			while(rs.next()){
				rootExpandList.add(rs.getString("id"));
			}
		}
		WorkTypeComInfo wftc = new WorkTypeComInfo();
		while (wftc.next()) {
			JSONObject jsonTypeObj = new JSONObject();
			String wfTypeId = wftc.getWorkTypeid();
			String wfTypeName = wftc.getWorkTypename();
			//if("1".equals(wfTypeId)) continue; 
			jsonTypeObj.put("id", "wftype_" + wfTypeId);
			jsonTypeObj.put("text", wfTypeName);
			if (!typeidList.contains(wfTypeId)) {
				jsonTypeObj.put("checked", false);
			} else {
				jsonTypeObj.put("checked", true);
			}
			if(rootExpandList.contains(wfTypeId)){
				jsonTypeObj.put("expanded", true);
			}
			jsonTypeObj.put("draggable", false);
			jsonTypeObj.put("leaf", false);
			jsonArrayReturn.put(jsonTypeObj);
		}
	} else if ("wftype".equals(type)) {
		ArrayList typeExpandList=new ArrayList();
		if(!"".equals(nodeids)){
			rs.execute("select distinct t2.id from workflow_flownode t1, workflow_base t2,workflow_type t3 where t2.workflowtype="+value+" and t2.id = t1.workflowid and t1.nodeid in ("+nodeids+")");
			while(rs.next()){
				typeExpandList.add(rs.getString("id"));
			}
		}
		rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+ value);

		while (rs.next()) {

			JSONObject jsonWfObj = new JSONObject();
			String wfId = Util.null2String(rs.getString("id"));
			String wfName = Util.null2String(rs.getString("workflowname"));
			jsonWfObj.put("id", "wf_" + wfId);
			jsonWfObj.put("text", wfName);
			jsonWfObj.put("draggable", false);

			if (!flowidList.contains(wfId)) {
				jsonWfObj.put("checked", false);
			} else {
				jsonWfObj.put("checked", true);
			}
			if(typeExpandList.contains(wfId)){
				jsonWfObj.put("expanded", true);
			}
			if (viewType == 1 || viewType == 2 || viewType == 4) {
				jsonWfObj.put("leaf", false);
			} else {
				jsonWfObj.put("leaf", true);
			}
			jsonArrayReturn.put(jsonWfObj);
		}
	} else {
		rsIn.executeSql("select a.nodeId,b.nodeName,a.nodeType from  workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id  and a.workflowId="+ value + " order by nodetype");

		JSONArray jsonNodeArrayObj = new JSONArray();
		while (rsIn.next()) {
			int nodeType = Util.getIntValue(rsIn.getString("nodeType"));
			if (viewType == 2 && nodeType == 3)
		continue; //如果是办结事宜并且节点是 process的将不会显示出来

			JSONObject jsonNodeObj = new JSONObject();
			String nodeId = Util.null2String(rsIn.getString("nodeId"));
			String nodeName = Util.null2String(rsIn
			.getString("nodeName"));
			jsonNodeObj.put("id", "node_" + nodeId);
			jsonNodeObj.put("text", nodeName);
			jsonNodeObj.put("leaf", true);
			jsonNodeObj.put("draggable", false);

			if (!nodeidList.contains(nodeId)) {
				jsonNodeObj.put("checked", false);
			} else {
				jsonNodeObj.put("checked", true);
				jsonNodeObj.put("expanded", true);
			}
			jsonNodeObj.put("leaf", true);

			jsonArrayReturn.put(jsonNodeObj);
		}
	}
	out.println(jsonArrayReturn.toString());
%>

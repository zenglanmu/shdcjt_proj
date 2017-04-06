<%@ page language="java" contentType="text/html; charset=GBK" %>
<%-- 本页面专用于Mobile版的字段联动 --%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Hashtable" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsObj" class="weaver.conn.RecordSet" scope="page" />
<%
String workflowId = request.getParameter("id");
String strTrgFieldNames = request.getParameter("trg");
WorkflowComInfo wfComInfo = new WorkflowComInfo();
String fformid = wfComInfo.getFormId(workflowId);
String isbill = wfComInfo.getIsBill(workflowId);
String nodeid = request.getParameter("node");

//获取当前节点所有可见字段的类型信息。
Map<String, String[]> mapFieldInfos = DynamicDataInput.getFieldInfos(workflowId, nodeid, isbill);
//用于设值的字段(字段id号 字段值)列表
List lstValues = new ArrayList();
//用于设置前端显示的(浏览按钮)字段(字段id号 字段值)列表
List lstDisplays = new ArrayList();

ArrayList arrTrgFieldNames = Util.TokenizerString(strTrgFieldNames, ",");
for(int temp=0; temp<arrTrgFieldNames.size(); temp++){
	String trgFieldName = Util.null2String((String)arrTrgFieldNames.get(temp));
	if(trgFieldName != null && !trgFieldName.trim().equals("") ){
		DynamicDataInput DDI = new DynamicDataInput(workflowId,trgFieldName,isbill);

		//查询将当前字段作为取值参数的所有联动信息
		String sql="select id from Workflow_DataInput_entry where WorkFlowID="+workflowId+" and TriggerFieldName='"+trgFieldName+"'";
		rs.executeSql(sql);
		String entryid = "";
		String datainputid = "";
		Hashtable outdatahash = new Hashtable();
		while(rs.next()){
			entryid = rs.getString("id");
			rsObj.executeSql("select id,IsCycle,WhereClause from Workflow_DataInput_main where entryID="+entryid+" order by orderid");

			ArrayList outdatasList=new ArrayList();
			ArrayList outfieldnamelist=new ArrayList();
			while(rsObj.next()){
				datainputid = rsObj.getString("id");
				
				//获取联动信息中的 所有取值字段名称 及 取值字段值。
				ArrayList infieldnamelist = DDI.GetInFieldName(datainputid);
				for(int i=0;i<infieldnamelist.size();i++){
					DDI.SetInFields((String)infieldnamelist.get(i),Util.null2String(request.getParameter(datainputid+"|"+(String)infieldnamelist.get(i))));
				}
				//获取联动信息中的 所有条件字段名称 及 条件字段值。
				ArrayList conditionfieldnameList = DDI.GetConditionFieldName(datainputid);
				for(int j=0;j<conditionfieldnameList.size();j++){
					DDI.SetConditonFields((String)conditionfieldnameList.get(j),Util.null2String(request.getParameter(datainputid+"|"+(String)conditionfieldnameList.get(j))));
				}
		        DDI.GetOutData(datainputid);
		        outfieldnamelist = DDI.GetOutFieldNameList();
		        outdatasList = DDI.GetOutDataList();
		        
		      	//赋值字段为主表字段的更新
				if(DDI.GetIsCycle().equals("1")){
					//当赋值字段为主表字段时， outdatasList仅包含一个元素。
				 	for(int i=0;i<outdatasList.size();i++){
				 		outdatahash = (Hashtable)outdatasList.get(i);
				 		
				 		List tempObj = new ArrayList();
				 		//对赋值字段进行循环。
				 		for(int j=0; j<outfieldnamelist.size(); j++){
				 			String fieldName = (String)outfieldnamelist.get(j);
				 		    String fieldValue = (String)outdatahash.get(fieldName);
				 		   	fieldValue = Util.toExcelData(fieldValue);
				 		   	
				 		   	//判断当前字段是否支持编辑
				 		   	String[] fieldType = DynamicDataInput.getFieldType(fieldName, mapFieldInfos);
				 		   	if(fieldType != null){
					 		   	Map map = new HashMap();
					 		   	map.put("fieldId", fieldName);
					 		   	map.put("fieldValue", fieldValue);
					 		   	tempObj.add(map);
				 		   	}
				 		}
				 		lstValues.add(tempObj);
	       			}
					
					//获取此次取值所需要设置前端值的列表
					List tempObj = DynamicDataInput.getBrowserButtonValue(outfieldnamelist, outdatasList, mapFieldInfos);
					if(tempObj != null){
						lstDisplays.add(tempObj);
					}
		       	} 
			}
		}
	}
}

String[] inputChecks = DynamicDataInput.getIsMandatoryField(workflowId, nodeid);
Map mapResult = new HashMap();
mapResult.put("values",lstValues);
mapResult.put("mandField",inputChecks);
mapResult.put("displays", lstDisplays);

JSONObject jsonObj = JSONObject.fromObject(mapResult);
String strResult = jsonObj.toString();
out.println(strResult);
%>
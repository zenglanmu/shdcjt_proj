<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />



<%
  String ajax=Util.null2String(request.getParameter("ajax"));
  String src = Util.null2String(request.getParameter("src"));
////得到标记信息
  if(src.equalsIgnoreCase("editoperatorgroup")){
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
	String oldids=Util.null2String(request.getParameter("oldids"));
  	char flag = 2;
	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	for(int i=0;i<rowsum;i++) {
		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
        int objid = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_id")),0);
        int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
		String oldid=Util.null2String(request.getParameter("group_"+i+"_oldid"));
		if(!type.equals("")){
		    if (oldid.equals(""))
                RecordSet.executeSql("Insert into workflow_urgerdetail(workflowid,utype,objid,level_n,level2_n,conditions,conditioncn) "
                    +"values("+wfid+","+type+","+objid+","+level+","+level2+",'"+conditions+"','"+conditioncn+"')");
			else
			{
                RecordSet.executeSql("update workflow_urgerdetail set objid="+objid+" , utype="+type+", level_n="+level+", level2_n="+level2+", conditions='"+conditions+"', conditioncn='"+conditioncn+"' where id="+oldid);
			    oldids=Util.StringReplace(oldids,","+oldid+",",",-1,");
			}
		}

	}
	//删除
	if (!oldids.equals(",")&&!oldids.equals(""))
	{
	oldids="-1"+oldids+"-1";
    RecordSet.execute("delete from workflow_urgerdetail where id in ("+oldids+") ");
	}
    response.sendRedirect("WFUrger.jsp?ajax="+ajax+"&wfid="+wfid);
    return;

  }
%>

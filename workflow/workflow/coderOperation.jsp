<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canEdit=true;
if(!HrmUserVarify.checkUserRight("FLOWCODE:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

%>
<%int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
 
  String formid=  Util.null2String(request.getParameter("formid"));
  String isBill=  Util.null2String(request.getParameter("isBill"));
  String selectField=  Util.null2String(request.getParameter("selectField"));
  if(selectField.equals("")){
	  selectField="-1";
  }
  String postValue=  Util.null2String(request.getParameter("postValue"));
  String fieldSequenceAlone=  Util.null2String(request.getParameter("fieldSequenceAlone"));
  String workflowSeqAlone=  Util.null2String(request.getParameter("workflowSeqAlone"));
  String dateSeqAlone=  Util.null2String(request.getParameter("dateSeqAlone"));
  String dateSeqSelect=  Util.null2String(request.getParameter("dateSeqSelect"));
  String struSeqAlone=  Util.null2String(request.getParameter("struSeqAlone"));
  String struSeqSelect=  Util.null2String(request.getParameter("struSeqSelect"));
  if(struSeqAlone.equals("1")){
	  if(struSeqSelect.equals("")){
		  struSeqSelect="1";
	  }
  }
  
  int txtUserUse=  Util.getIntValue(request.getParameter("txtUserUse"),0);

if("1".equals(workflowSeqAlone)){

    rs.executeSql("select * from  workflow_code  where flowId="+wfid);
    if (rs.next()){
		rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"',fieldSequenceAlone='"+fieldSequenceAlone+"',workflowSeqAlone='"+workflowSeqAlone+"',dateSeqAlone='"+dateSeqAlone+"',dateSeqSelect='"+dateSeqSelect+"',struSeqAlone='"+struSeqAlone+"',struSeqSelect='"+struSeqSelect+"' where flowId="+wfid);
    }else{
		rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId,isBill,fieldSequenceAlone,workflowSeqAlone,dateSeqAlone,dateSeqSelect,struSeqAlone,struSeqSelect) values(-1,"+wfid+",'"+txtUserUse+"',"+selectField+",'0','"+fieldSequenceAlone+"','"+workflowSeqAlone+"','"+dateSeqAlone+"','"+dateSeqSelect+"','"+struSeqAlone+"','"+struSeqSelect+"')");
    }

    rs.executeSql("delete workflow_codeDetail where workflowId="+wfid);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String type = memberAttibutes[2];

      String insertStr = "insert into workflow_codeDetail (mainId,showId,codeValue,codeOrder,isBill,workflowId) values (-1,"+text+",'"+value+"',"+i+",'0',"+wfid+")";	  
      rs.executeSql(insertStr);          
    }
}else{
	rs.executeSql("update workflow_Code set workflowSeqAlone='0' where flowId="+wfid);
    //rs.executeSql("select * from  workflow_code  where formId="+formid);
    rs.executeSql("select * from  workflow_code  where formId="+formid+" and isBill='"+isBill+"'");
    if (rs.next())
    {
     //rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"' where formId="+formid);
     //rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"' where formId="+formid+" and isBill='"+isBill+"'");
     rs.executeSql("update  workflow_code  set codeFieldId="+selectField+",isUse='"+txtUserUse+"',fieldSequenceAlone='"+fieldSequenceAlone+"',workflowSeqAlone='"+workflowSeqAlone+"',dateSeqAlone='"+dateSeqAlone+"',dateSeqSelect='"+dateSeqSelect+"',struSeqAlone='"+struSeqAlone+"',struSeqSelect='"+struSeqSelect+"' where formId="+formid+" and isBill='"+isBill+"'");
    }
    else
    {
    //rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId) values("+formid+","+wfid+",'"+txtUserUse+"',"+selectField+")");
    //rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId,isBill) values("+formid+","+wfid+",'"+txtUserUse+"',"+selectField+",'"+isBill+"')");
    rs.executeSql("insert into  workflow_code (formId,flowId,isUse,codeFieldId,isBill,fieldSequenceAlone,workflowSeqAlone,dateSeqAlone,dateSeqSelect,struSeqAlone,struSeqSelect) values("+formid+",-1,'"+txtUserUse+"',"+selectField+",'"+isBill+"','"+fieldSequenceAlone+"','"+workflowSeqAlone+"','"+dateSeqAlone+"','"+dateSeqSelect+"','"+struSeqAlone+"','"+struSeqSelect+"')");
    }

    //rs.executeSql("delete workflow_codeDetail where mainId="+formid);
    rs.executeSql("delete workflow_codeDetail where mainId="+formid+" and isBill='"+isBill+"'");
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];
      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String type = memberAttibutes[2];

      //String insertStr = "insert into workflow_codeDetail (mainId,showId,codeValue,codeOrder) values ("+formid+","+text+",'"+value+"',"+i+")";
      //String insertStr = "insert into workflow_codeDetail (mainId,showId,codeValue,codeOrder,isBill) values ("+formid+","+text+",'"+value+"',"+i+",'"+isBill+"')";
      String insertStr = "insert into workflow_codeDetail (mainId,showId,codeValue,codeOrder,isBill,workflowId) values ("+formid+","+text+",'"+value+"',"+i+",'"+isBill+"',-1)";	  
      rs.executeSql(insertStr);          
    }
}
     response.sendRedirect("WFCode.jsp?ajax=1&wfid="+wfid);

%>



<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="EvaluationComInfo" class="weaver.crm.Maint.EvaluationComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<% 
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

if(!"".equals(CustomerID)){
	boolean canedit=false;
	//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();
	//RecordSet.executeSql(ViewSql);
	//if(RecordSet.next()){
	//	 if(RecordSet.getString("sharelevel").equals("2")){
	//		canedit=true;
	//	 }else if (RecordSet.getString("sharelevel").equals("3") || RecordSet.getString("sharelevel").equals("4")){
	//		canedit=true;
	//	 }
	//}
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1) canedit=true;
	if(!canedit){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
	}
}

String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String proportion = Util.fromScreen(request.getParameter("proportion"),user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_Insert",name+flag+proportion);

	EvaluationComInfo.removeEvaluationCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_Update",id+flag+name+flag+proportion);

	EvaluationComInfo.removeEvaluationCache();
}
else if (method.equals("delete"))
{	String CRM_EvaluationIDs[]=request.getParameterValues("CRM_EvaluationIDs");
	String ProcPara = "";
	if(CRM_EvaluationIDs != null)
	{
		for(int i=0;i<CRM_EvaluationIDs.length;i++)
		{
			ProcPara = CRM_EvaluationIDs[i];
            RecordSet.executeProc("CRM_Evaluation_Delete",ProcPara);

		} 
	}
	EvaluationComInfo.removeEvaluationCache();
}
else if (method.equals("getvalue")) {	
	String level[] = request.getParameterValues("level");
	String proportionstr[] = request.getParameterValues("proportion");
	String evaluationID[] = request.getParameterValues("evaluationID");
	
	String ProcPara = "";
	char flag=2;
	double totallevel = 0;
	double tempvalue = 0;
	boolean checkLevel = false;
	String evaId = "";
	if (!CustomerID.equals("")) {
		for (int i = 0; i < level.length; i++) {   
		    RecordSet.executeSql("select id from CRM_Evaluation_LevelDetail where customerID = "+CustomerID+ " and evaluationID = "+evaluationID[i]);		  
		    if(RecordSet.next()){
		        checkLevel = true;		    
		    }else{
		        checkLevel = false;
		    } 
		    if(checkLevel){
		      rs.executeSql("update CRM_Evaluation_LevelDetail set levelID = "+level[i]+" where customerID = "+CustomerID+" and evaluationID = "+evaluationID[i]);
		    }else{
		      rs.executeSql("insert into CRM_Evaluation_LevelDetail (customerID,evaluationID,levelID) values ('"+CustomerID+ "','"+evaluationID[i]+"','"+level[i]+"')");
		    }
			tempvalue = Util.getDoubleValue(level[i],0)*(Util.getDoubleValue(proportionstr[i],0)/100);	
			totallevel += tempvalue; 
		}

        //boolean exist = false;
		double levelint = 0;
		while (EvaluationLevelComInfo.next()) {
			levelint = Util.getDoubleValue(EvaluationLevelComInfo.getEvaluationLevellevelvalue(),0);
			if (totallevel <= levelint) {
                evaId = EvaluationLevelComInfo.getEvaluationLevelid();
                //exist = true;
				break;
			}
		}

        //if (!exist)
		ProcPara = CustomerID;
		ProcPara += flag + ""+evaId;
		RecordSet.executeProc("CRM_CustomerEvaluationUpdate",ProcPara);
	}
	
	if(!isfromtab){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	}else{
		response.sendRedirect("/CRM/data/GetEvaluation.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/EvaluationList.jsp");
%>
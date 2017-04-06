<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowCodeSeqReservedManager" class="weaver.workflow.workflow.WorkflowCodeSeqReservedManager" scope="page" />


<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int userid=user.getUID();                   //当前用户id

String operation=Util.null2String(request.getParameter("operation"));
String ismand=Util.null2String(request.getParameter("ismand"));

String returnCodeStr="";

if(operation.equals("CreateCodeAgain")){

	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());
	String workflowSeqAlone=cb.getWorkflowSeqAlone();

	ArrayList memberList = cb.getMemberList();


	int departmentFieldId=-1;
	int subCompanyFieldId=-1;
	int supSubCompanyFieldId=-1;

			
	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if("22753".equals(codeMemberName)){
			supSubCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("141".equals(codeMemberName)){
			subCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("124".equals(codeMemberName)){
			departmentFieldId=Util.getIntValue(codeMemberValue,-1);
		}
	}



	int yearId = Util.getIntValue(request.getParameter("yearId"),0);
	int monthId = Util.getIntValue(request.getParameter("monthId"),0);
	int dateId = Util.getIntValue(request.getParameter("dateId"),0);
	int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
	int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),-1);
	int supSubCompanyId = Util.getIntValue(request.getParameter("supSubCompanyId"),0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);

    WorkflowCodeSeqReservedManager.setYearIdDefault(yearId);
    WorkflowCodeSeqReservedManager.setMonthIdDefault(monthId);
    WorkflowCodeSeqReservedManager.setDateIdDefault(dateId);
    WorkflowCodeSeqReservedManager.setFieldIdDefault(fieldId);
    WorkflowCodeSeqReservedManager.setFieldValueDefault(fieldValue);
    WorkflowCodeSeqReservedManager.setSupSubCompanyIdDefault(supSubCompanyId);
    WorkflowCodeSeqReservedManager.setSubCompanyIdDefault(subCompanyId);
    WorkflowCodeSeqReservedManager.setDepartmentIdDefault(departmentId);


	int recordId = Util.getIntValue(request.getParameter("recordId"),0);
	int sequenceId=1;
	if(recordId<=0){
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		int tempYearId=-1;
		int tempMonthId=-1;
		int tempDateId=-1;
	
		int tempFieldId=-1;
		int tempFieldValue=-1;
	
		int tempSupSubCompanyId=-1;
		int tempSubCompanyId=-1;
		int tempDepartmentId=-1;
	
		int tempRecordId=-1;
		int tempSequenceId=1;
	
		String dateSeqAlone=cb.getDateSeqAlone();
		String dateSeqSelect=cb.getDateSeqSelect();
		String fieldSequenceAlone=cb.getFieldSequenceAlone();
		String struSeqAlone=cb.getStruSeqAlone();
		String struSeqSelect=cb.getStruSeqSelect();
	
		if("1".equals(workflowSeqAlone)){
			tempWorkflowId=workflowId;
		}else{
			tempFormId=formId;
		    tempIsBill=isBill;
		}
	
		if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
			tempYearId=yearId;
		}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
			tempYearId=yearId;
			tempMonthId=monthId;						
		}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
			tempYearId=yearId;						
			tempMonthId=monthId;	
			tempDateId=dateId;							
		}
					
		if("1".equals(fieldSequenceAlone)&&fieldId>0 ){
			tempFieldId=fieldId;
			tempFieldValue=fieldValue;
		}
					
		if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
			tempSupSubCompanyId=supSubCompanyId;
			tempSubCompanyId=-1;
			tempDepartmentId=-1;						
		}
		if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
			tempSupSubCompanyId=-1;
			tempSubCompanyId=subCompanyId;
			tempDepartmentId=-1;						
		}
		if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
			tempSupSubCompanyId=-1;
			tempSubCompanyId=-1;
			tempDepartmentId=departmentId;						
		}

		RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

		if(RecordSet.next()){
			tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}

	    if(tempRecordId>0){
			recordId = tempRecordId;
			sequenceId = tempSequenceId;
		}else{
			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId)" +
			" values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");
			RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

			if(RecordSet.next()){
			    tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			    tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
			}
			if(tempRecordId>0){
			    recordId = tempRecordId;
			    sequenceId = tempSequenceId;
			}
		}
	}else{
		RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

		if(RecordSet.next()){
			sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}
	}

    //先将现有流程编号记入预留编号表
	int reservedId=-1;
	int codeSeqReservedId=-1;
	RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
	if(RecordSet.next()){
		reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		codeSeqReservedId=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
	}

	if(reservedId>=1){
		if(codeSeqReservedId>=1){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedId);
		}else{
		    List hisReservedIdList=new ArrayList();
		    StringBuffer hisReservedIdSb=new StringBuffer();
		    hisReservedIdSb.append(" select reservedId ")
		                   .append("   from workflow_codeSeqReserved ")
		                   .append("  where codeSeqId=").append(recordId)
		                   .append("    and (hasDeleted is null or hasDeleted='0') ")
		                   .append("  order by reservedId asc,id asc ")		               
		                   ;
		    RecordSet.executeSql(hisReservedIdSb.toString());
		    while(RecordSet.next()){
		    	hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
		    }
		    if(hisReservedIdList.indexOf(""+reservedId)==-1){
		    	hisReservedIdList.add(""+reservedId);
		    	String  reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
		    	reservedCode=Util.toHtml100(reservedCode);
		    	RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','','0','0')");
		    }
		}
	}


			String tablename="workflow_form";
			String fieldName="";
			
			
			if (!fieldCode.equals("")){
				String sql="select fieldName  from workflow_formdict where id="+fieldCode;
				if (isBill.equals("1")) {
					sql="select fieldName  from workflow_billfield where id="+fieldCode;
					RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
					if (RecordSet.next()){
						tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
					}
				}
			    RecordSet.executeSql(sql);
			    if (RecordSet.next()){ 
			    	fieldName=Util.null2String(RecordSet.getString(1));
			    }	
            }


			int tempStruValue=0;
			String tempAbbr =null;
			
			Map subComAbbrDefMap=new HashMap();
			RecordSet.executeSql("select * from workflow_subComAbbrDef");
			while(RecordSet.next()){
				tempStruValue=Util.getIntValue(RecordSet.getString("subCompanyId"));
				tempAbbr=Util.null2String(RecordSet.getString("abbr"));
				subComAbbrDefMap.put(""+tempStruValue,tempAbbr);
			}

			Map deptAbbrDefMap=new HashMap();
			RecordSet.executeSql("select * from workflow_deptAbbrDef");
			while(RecordSet.next()){
				tempStruValue=Util.getIntValue(RecordSet.getString("departmentId"));
				tempAbbr=Util.null2String(RecordSet.getString("abbr"));
				deptAbbrDefMap.put(""+tempStruValue,tempAbbr);
			}
			
			for (int i=0;i<memberList.size();i++){
				String[] members = (String[])memberList.get(i);
				String text = members[0];
				String value = members[1];
				
				if ("18729".equals(text)){
					returnCodeStr+=value;
				}else if("20571".equals(text)){
					returnCodeStr+=value;					
				}else if("20572".equals(text)){
					returnCodeStr+=value;					
				}else if("20573".equals(text)){
					returnCodeStr+=value;					
				}else if("20574".equals(text)){
					returnCodeStr+=value;					
				}else if("20575".equals(text)){
					returnCodeStr+=value;					
				}else if("20770".equals(text)){
					returnCodeStr+=value;					
				}else if("20771".equals(text)){
					returnCodeStr+=value;					
				}else if ("445".equals(text)){
					if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&yearId>0){
						returnCodeStr+=Util.add0(yearId,4);
					} 
				}else if ("6076".equals(text)){
					if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&monthId>0){
						returnCodeStr+=Util.add0(monthId,2);
					}
				} else if ("390".equals(text)||"16889".equals(text)){
					if (("-2".equals(value)||Util.getIntValue(value,-1)>0)&&dateId>0){
						returnCodeStr+=Util.add0(dateId,2);
					}
				} else if ("22755".equals(text)){
					String shortNameSettingSql=null;
					String shortNameSetting="";
					if("1".equals(workflowSeqAlone)){
						shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where workflowId="+workflowId+" and fieldId="+fieldId+" and fieldValue="+fieldValue;
					}else{
						shortNameSettingSql="select shortNameSetting from workflow_shortNameSetting  where formId="+formId+" and isBill="+isBill+" and fieldId="+fieldId+" and fieldValue="+fieldValue;
					}
					RecordSet.executeSql(shortNameSettingSql);
					if(RecordSet.next()){
						shortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));
					}
					
					if("".equals(shortNameSetting)){
						RecordSet.executeSql("select selectName from workflow_selectitem where fieldId="+fieldId+" and isBill='"+isBill+"' and selectValue="+fieldValue);
						if(RecordSet.next()){
							shortNameSetting=Util.null2String(RecordSet.getString("selectName"));
						}						
					}
					returnCodeStr+=shortNameSetting;
				} else if ("22753".equals(text)&&!"-1".equals(value)&&supSubCompanyId!=subCompanyId){//上级分部
					String abbrSql=null;
					String abbr="";
					if("1".equals(workflowSeqAlone)){
						abbrSql="select abbr from workflow_supSubComAbbr  where workflowId="+workflowId+" and fieldId="+supSubCompanyFieldId+" and fieldValue="+supSubCompanyId;
					}else{
						abbrSql="select abbr from workflow_supSubComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+supSubCompanyFieldId+" and fieldValue="+supSubCompanyId;
					}
					RecordSet.executeSql(abbrSql);
					if(RecordSet.next()){
						abbr=Util.null2String(RecordSet.getString("abbr"));
					}
					
					if("".equals(abbr)){
						abbr=Util.null2String((String)subComAbbrDefMap.get(""+supSubCompanyId));						
					}
					if("".equals(abbr)){
						abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+supSubCompanyId));						
					}					
					returnCodeStr+=abbr;
				} else if ("141".equals(text)&&!"-1".equals(value)){//分部
					String abbrSql=null;
					String abbr="";
					if("1".equals(workflowSeqAlone)){
						abbrSql="select abbr from workflow_subComAbbr  where workflowId="+workflowId+" and fieldId="+subCompanyFieldId+" and fieldValue="+subCompanyId;
					}else{
						abbrSql="select abbr from workflow_subComAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+subCompanyFieldId+" and fieldValue="+subCompanyId;
					}
					RecordSet.executeSql(abbrSql);
					if(RecordSet.next()){
						abbr=Util.null2String(RecordSet.getString("abbr"));
					}
					
					if("".equals(abbr)){
						abbr=Util.null2String((String)subComAbbrDefMap.get(""+subCompanyId));						
					}
					if("".equals(abbr)){
						abbr=Util.null2String(SubCompanyComInfo.getSubCompanyname(""+subCompanyId));						
					}
					returnCodeStr+=abbr;
				} else if ("124".equals(text)&&!"-1".equals(value)){//部门
					String abbrSql=null;
					String abbr="";
					if("1".equals(workflowSeqAlone)){
						abbrSql="select abbr from workflow_deptAbbr  where workflowId="+workflowId+" and fieldId="+departmentFieldId+" and fieldValue="+departmentId;
					}else{
						abbrSql="select abbr from workflow_deptAbbr  where formId="+formId+" and isBill="+isBill+" and fieldId="+departmentFieldId+" and fieldValue="+departmentId;
					}
					RecordSet.executeSql(abbrSql);
					if(RecordSet.next()){
						abbr=Util.null2String(RecordSet.getString("abbr"));
					}
					
					if("".equals(abbr)){
						abbr=Util.null2String((String)deptAbbrDefMap.get(""+departmentId));						
					}
					if("".equals(abbr)){
						abbr=Util.null2String(DepartmentComInfo.getDepartmentname(""+departmentId));						
					}
					returnCodeStr+=abbr;
				}else if ("18811".equals(text)){
					int tempRecordId=recordId;
					int tempSequenceId=sequenceId;					
	

					if(tempRecordId>0){
						List reservedIdList=new ArrayList();
						StringBuffer reservedIdSb=new StringBuffer();
						reservedIdSb.append(" select reservedId  ")
						            .append("   from workflow_codeSeqReserved  ")
						            .append("  where codeSeqId=").append(tempRecordId)
						            .append("    and (hasDeleted is null or hasDeleted='0') ")
						            .append("  order by reservedId asc,id asc ")					            
						            ;
						RecordSet.executeSql(reservedIdSb.toString());
						while(RecordSet.next()){
							reservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
						}
						
						while(reservedIdList.indexOf(""+tempSequenceId)>-1){//跳过预留号
							tempSequenceId++;
						}
					}					
					
					if(Util.getIntValue(value)<=(""+tempSequenceId).length())
						returnCodeStr += tempSequenceId;
					else{
						for(int j=0;j<(Util.getIntValue(value)-(""+tempSequenceId).length());j++){
							returnCodeStr += "0";
						}
						returnCodeStr += tempSequenceId;
					}
					
					sequenceId=tempSequenceId;
					tempSequenceId++;
					
					if(tempRecordId>0){
						RecordSet.executeSql("update workflow_codeSeq set sequenceId="+tempSequenceId+" where id="+tempRecordId);
						recordId=tempRecordId;
					}
					
				}
			}
			if (!fieldCode.equals("")){
				RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
                RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
                
                RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
                		"values("+requestId+","+recordId+","+sequenceId+",-1,'"+Util.toHtml100(returnCodeStr)+"')");
			    session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);
                
            }

}else if(operation.equals("chooseReservedCode")){
	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());

    String codeSeqReservedIdAndCode=Util.null2String(request.getParameter("codeSeqReservedIdAndCode"));

	int codeSeqReservedId=0;
	String reservedCode="";
	ArrayList codeSeqReservedIdAndCodeList=Util.TokenizerString(codeSeqReservedIdAndCode,"_") ;
	if(codeSeqReservedIdAndCodeList.size()>=2){
		codeSeqReservedId=Util.getIntValue((String)codeSeqReservedIdAndCodeList.get(0),-1);
		reservedCode=Util.null2String((String)codeSeqReservedIdAndCodeList.get(1));
	}
	if(codeSeqReservedId>0){
		returnCodeStr=reservedCode;
		if(!returnCodeStr.equals("")){
			session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);

			String tablename="workflow_form";
			String fieldName="";
			
			
			if (!fieldCode.equals("")){
				String sql="select fieldName  from workflow_formdict where id="+fieldCode;
				if (isBill.equals("1")) {
					sql="select fieldName  from workflow_billfield where id="+fieldCode;
					RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
					if (RecordSet.next()){
						tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
					}
				}
			    RecordSet.executeSql(sql);
			    if (RecordSet.next()){ 
			    	fieldName=Util.null2String(RecordSet.getString(1));
			    }	
            }

			if (!fieldCode.equals("")){
				RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
                RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
                
            }

		}

		int recordId=-1;
		int sequenceId=-1;
		RecordSet.executeSql("select codeSeqId,reservedId from workflow_codeSeqReserved where id="+codeSeqReservedId);
		if(RecordSet.next()){
			recordId=Util.getIntValue(RecordSet.getString("codeSeqId"),-1);
			sequenceId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
		}

		//先将现有流程编号记入预留编号表
		int reservedId=-1;
		int codeSeqReservedIdHis=-1;
		RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
		if(RecordSet.next()){
		    reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		    codeSeqReservedIdHis=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
		}

		if(reservedId>=1){
			if(codeSeqReservedIdHis>=1){
				RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedIdHis);
			}else{
				List hisReservedIdList=new ArrayList();
			    StringBuffer hisReservedIdSb=new StringBuffer();
			    hisReservedIdSb.append(" select reservedId ")
		                       .append("   from workflow_codeSeqReserved ")
		                       .append("  where codeSeqId=").append(recordId)
		                       .append("    and (hasDeleted is null or hasDeleted='0') ")
		                       .append("  order by reservedId asc,id asc ")		               
		                       ;
			    RecordSet.executeSql(hisReservedIdSb.toString());
			    while(RecordSet.next()){
				    hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
			    }
			    if(hisReservedIdList.indexOf(""+reservedId)==-1){
				    hisReservedIdList.add(""+reservedId);
				    reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
			        reservedCode=Util.toHtml100(reservedCode);
			        RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','','0','0')");
			    }	
			}
		}

        //在将记录存放在当前编号表
		RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='1' where id="+codeSeqReservedId);


		if(recordId>=1&&sequenceId>=1){
			RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
                		      "values("+requestId+","+recordId+","+sequenceId+","+codeSeqReservedId+",'"+Util.toHtml100(returnCodeStr)+"')");
		}
	}
//手动变更编号(TD18867)
} else if(operation.equals("ChangeCode")){

	int requestId = Util.getIntValue(request.getParameter("requestId"),0);

	int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
	int formId = Util.getIntValue(request.getParameter("formId"),0);
	String isBill = Util.null2String(request.getParameter("isBill"));

	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	String fieldCode=Util.null2String(cb.getCodeFieldId());
	String workflowSeqAlone=cb.getWorkflowSeqAlone();

	ArrayList memberList = cb.getMemberList();

	int departmentFieldId=-1;
	int subCompanyFieldId=-1;
	int supSubCompanyFieldId=-1;

	for (int i=0;i<memberList.size();i++){
		String[] codeMembers = (String[])memberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		if("22753".equals(codeMemberName)){
			supSubCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("141".equals(codeMemberName)){
			subCompanyFieldId=Util.getIntValue(codeMemberValue,-1);
		}else if("124".equals(codeMemberName)){
			departmentFieldId=Util.getIntValue(codeMemberValue,-1);
		}
	}

	int yearId = Util.getIntValue(request.getParameter("yearId"),0);
	int monthId = Util.getIntValue(request.getParameter("monthId"),0);
	int dateId = Util.getIntValue(request.getParameter("dateId"),0);
	int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
	int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),-1);
	int supSubCompanyId = Util.getIntValue(request.getParameter("supSubCompanyId"),0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);

    WorkflowCodeSeqReservedManager.setYearIdDefault(yearId);
    WorkflowCodeSeqReservedManager.setMonthIdDefault(monthId);
    WorkflowCodeSeqReservedManager.setDateIdDefault(dateId);
    WorkflowCodeSeqReservedManager.setFieldIdDefault(fieldId);
    WorkflowCodeSeqReservedManager.setFieldValueDefault(fieldValue);
    WorkflowCodeSeqReservedManager.setSupSubCompanyIdDefault(supSubCompanyId);
    WorkflowCodeSeqReservedManager.setSubCompanyIdDefault(subCompanyId);
    WorkflowCodeSeqReservedManager.setDepartmentIdDefault(departmentId);

	int recordId = Util.getIntValue(request.getParameter("recordId"),0);
	int sequenceId=1;
	if(recordId<=0){
		int tempWorkflowId=-1;
		int tempFormId=-1;
		String tempIsBill="0";
		int tempYearId=-1;
		int tempMonthId=-1;
		int tempDateId=-1;
	
		int tempFieldId=-1;
		int tempFieldValue=-1;
	
		int tempSupSubCompanyId=-1;
		int tempSubCompanyId=-1;
		int tempDepartmentId=-1;
	
		int tempRecordId=-1;
		int tempSequenceId=1;
	
		String dateSeqAlone=cb.getDateSeqAlone();
		String dateSeqSelect=cb.getDateSeqSelect();
		String fieldSequenceAlone=cb.getFieldSequenceAlone();
		String struSeqAlone=cb.getStruSeqAlone();
		String struSeqSelect=cb.getStruSeqSelect();
	
		if("1".equals(workflowSeqAlone)){
			tempWorkflowId=workflowId;
		}else{
			tempFormId=formId;
		    tempIsBill=isBill;
		}
	
		if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
			tempYearId=yearId;
		}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
			tempYearId=yearId;
			tempMonthId=monthId;						
		}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
			tempYearId=yearId;						
			tempMonthId=monthId;	
			tempDateId=dateId;							
		}
					
		if("1".equals(fieldSequenceAlone)&&fieldId>0 ){
			tempFieldId=fieldId;
			tempFieldValue=fieldValue;
		}
					
		if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
			tempSupSubCompanyId=supSubCompanyId;
			tempSubCompanyId=-1;
			tempDepartmentId=-1;						
		}
		if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
			tempSupSubCompanyId=-1;
			tempSubCompanyId=subCompanyId;
			tempDepartmentId=-1;						
		}
		if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
			tempSupSubCompanyId=-1;
			tempSubCompanyId=-1;
			tempDepartmentId=departmentId;						
		}

		RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

		if(RecordSet.next()){
			tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}

	    if(tempRecordId>0){
			recordId = tempRecordId;
			sequenceId = tempSequenceId;
		}else{
			RecordSet.executeSql("insert into workflow_codeSeq(yearId,sequenceId,formId,isBill,monthId,dateId,workflowId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId)" +
			" values("+tempYearId+","+tempSequenceId+","+tempFormId+",'"+tempIsBill+"',"+tempMonthId+","+tempDateId+","+tempWorkflowId+","+tempFieldId+","+tempFieldValue+","+tempSupSubCompanyId+","+tempSubCompanyId+","+tempDepartmentId+")");
			RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

			if(RecordSet.next()){
			    tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
			    tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
			}
			if(tempRecordId>0){
			    recordId = tempRecordId;
			    sequenceId = tempSequenceId;
			}
		}
	}else{
		RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

		if(RecordSet.next()){
			sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
		}
	}

    //先将现有流程编号记入预留编号表
	int reservedId=-1;
	int codeSeqReservedId=-1;
	RecordSet.executeSql("select sequenceId,codeSeqReservedId from workflow_codeSeqRecord where requestId="+requestId+" and codeSeqId="+recordId+" order by id desc");
	if(RecordSet.next()){
		reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
		codeSeqReservedId=Util.getIntValue(RecordSet.getString("codeSeqReservedId"),-1);
	}

	if(reservedId>=1){
		if(codeSeqReservedId>=1){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0',hasDeleted='0' where id="+codeSeqReservedId);
		}else{
		    List hisReservedIdList=new ArrayList();
		    StringBuffer hisReservedIdSb=new StringBuffer();
		    hisReservedIdSb.append(" select reservedId ")
		                   .append("   from workflow_codeSeqReserved ")
		                   .append("  where codeSeqId=").append(recordId)
		                   .append("    and (hasDeleted is null or hasDeleted='0') ")
		                   .append("  order by reservedId asc,id asc ")		               
		                   ;
		    RecordSet.executeSql(hisReservedIdSb.toString());
		    while(RecordSet.next()){
		    	hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
		    }
		    if(hisReservedIdList.indexOf(""+reservedId)==-1){
		    	hisReservedIdList.add(""+reservedId);
		    	String  reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
		    	reservedCode=Util.toHtml100(reservedCode);
		    	RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','','0','0')");
		    }
		}
	}

	//修改前后的编号是否在预留号中,存在则更新
	String oldCodeStr = Util.null2String(request.getParameter("oldCodeStr"));
	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='0' where id in (select id from workflow_codeSeqReserved where codeSeqId= " + recordId + " and hasUsed='1' and (hasDeleted is null or hasDeleted='0') and reservedcode ='" + oldCodeStr + "')");
	returnCodeStr = Util.null2String(request.getParameter("returnCodeStr"));
	RecordSet.executeSql("update workflow_codeSeqReserved set hasUsed='1' where id in (select id from workflow_codeSeqReserved where codeSeqId= " + recordId + " and (hasUsed is null or hasUsed='0') and (hasDeleted is null or hasDeleted='0') and reservedcode ='" + returnCodeStr + "')");

	String tablename="workflow_form";
	String fieldName="";
	
	if (!fieldCode.equals("")){
		String sql="select fieldName  from workflow_formdict where id="+fieldCode;
		if (isBill.equals("1")) {
			sql="select fieldName  from workflow_billfield where id="+fieldCode;
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formId); // 查询工作流单据表的信息
			if (RecordSet.next()){
				tablename = Util.null2String(RecordSet.getString("tablename"));          // 获得单据的主表
			}
		}
	    RecordSet.executeSql(sql);
	    if (RecordSet.next()){ 
	    	fieldName=Util.null2String(RecordSet.getString(1));
	    }	
    }

	if (!fieldCode.equals("")){
		RecordSet.executeSql("update "+tablename+" set "+fieldName+"='"+returnCodeStr+"' where requestid="+requestId);
        RecordSet.executeSql("update workflow_requestbase set requestmark='"+returnCodeStr+"' where requestid="+requestId);
        
        RecordSet.executeSql("insert into workflow_codeSeqRecord(requestId,codeSeqId,sequenceId,codeSeqReservedId,workflowCode) " +
        		"values("+requestId+","+recordId+","+sequenceId+",-1,'"+Util.toHtml100(returnCodeStr)+"')");
	    session.setAttribute(userid+"_"+requestId+"requestmark",returnCodeStr);
        
    }
}

%>
<script language="javascript">

<%if(operation.equals("CreateCodeAgain") || operation.equals("ChangeCode")){%>

window.parent.onCreateCodeAgainReturn("<%=returnCodeStr%>","<%=ismand%>");

<%}else if(operation.equals("chooseReservedCode")){%>

window.parent.onCreateCodeAgainReturn("<%=returnCodeStr%>","<%=ismand%>");

<%}%>
</script>
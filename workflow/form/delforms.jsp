<%@ page import="weaver.general.Util" %>
<jsp:useBean id="forminfo" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="FormMainManager" class="weaver.workflow.form.FormMainManager" scope="page"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String[] delete_form_id_Array = request.getParameterValues("delete_form_id");
	String[] delete_newform_id_Array = request.getParameterValues("delete_newform_id");
	
	if(delete_newform_id_Array!=null){//新表单删除
		for (int i = 0; i < delete_newform_id_Array.length; i++){
			int formid = Util.getIntValue(delete_newform_id_Array[i], 0);
			RecordSet.executeSql("select tablename from workflow_bill where id="+formid);
			if(RecordSet.next()){//删除主表
				String tablename = RecordSet.getString("tablename");
				RecordSet.executeSql("drop table "+tablename);
				if((RecordSet.getDBType()).equals("oracle")){
				    //RecordSet.executeSql("drop trigger "+tablename+"_Id_Trigger");
				    RecordSet.executeSql("select * from user_triggers where upper(trigger_name)=upper('"+tablename+"_Id_Trigger')");
				    if(RecordSet.next()){
						RecordSet.executeSql("drop trigger "+tablename+"_Id_Trigger");
					}
				    RecordSet.executeSql("drop sequence "+tablename+"_Id");
				}
			}
			
			RecordSet.executeSql("delete from workflow_bill where id="+formid);//基本信息删除
			RecordSet.executeSql("select id from workflow_billfield where fieldhtmltype=5 and billid="+formid);
			while(RecordSet.next()){//选择框字段关联表删除
				int fieldid = RecordSet.getInt("id");
				RecordSet.executeSql("delete from workflow_SelectItem where fieldid="+fieldid);
			}
			RecordSet.executeSql("delete from workflow_billfield where billid="+formid);//字段删除
			
			RecordSet.executeSql("select id,tablename from Workflow_billdetailtable where billid="+formid);
			while(RecordSet.next()){//删除明细表
				String tablename = RecordSet.getString("tablename");
				RecordSet.executeSql("drop table "+tablename);
				RecordSet.executeSql("delete from Workflow_billdetailtable where id="+RecordSet.getInt("id"));//明细表删除
			}
		}
	}
	
  if(delete_form_id_Array!=null){//旧表单删除
	  FormMainManager.DeleteForm(request.getParameterValues("delete_form_id"));
	  FormComInfo.removeFormCache();
  }
  String ajax=Util.null2String(request.getParameter("ajax"));
  response.sendRedirect("/workflow/form/manageform.jsp?ajax="+ajax);

%>

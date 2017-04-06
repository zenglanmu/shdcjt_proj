<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.* "%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
  	return;
	}
%>
<%	
	int modeId = Util.getIntValue(Util.null2String(request.getParameter("modeId")),0);//模块id
	int entryID = Util.getIntValue(Util.null2String(request.getParameter("entryID")),0);//联动id
	String srcfrom = Util.null2String(request.getParameter("srcfrom"));//来源
	int modeformid = 0;
	rs1.executeSql("select formid from modeinfo where id="+modeId);
	if(rs1.next()) modeformid = Util.getIntValue(rs1.getString("formid"),0);
	String errormsg = "";
	if(modeId!=0){
		ConnStatement statement = null;
		try
		{
			if("entry".equals(srcfrom))
			{
				ModeLinkageInfo.deleteEntryById(entryID,modeId,rs1);
				
				statement = new ConnStatement();
				//再添加
				String txtUserUse = Util.null2String(request.getParameter("txtUserUse"));//启动字段联动
				if(txtUserUse.equals("1"))
				{
					int triggerNum = Util.getIntValue(Util.null2String(request.getParameter("triggerNum")),0);
					for(int i=0;i<triggerNum;i++){
						String triggerName = Util.null2String(request.getParameter("triggerName"+i));//触发字段
						String triggerField = Util.null2String(request.getParameter("triggerField"+i));//触发字段
						
						if(triggerField.equals("")) continue;
						String triggerFieldType = Util.null2String(request.getParameter("triggerFieldType"+i));//触发字段类型
						statement.setStatementSql("insert into modeDataInputentry(modeid,triggerName,triggerfieldname,type) values(?,?,?,?)");
						statement.setInt(1,modeId);
						statement.setString(2,triggerName);
						statement.setString(3,"field"+triggerField);
						statement.setString(4,triggerFieldType);
						statement.executeUpdate();
						int entryId = 0;
						statement.setStatementSql("select max(id) as entryId from modeDataInputentry");
						statement.executeQuery();
						if(statement.next()) entryId = statement.getInt("entryId");
						int triggerSettingRows = Util.getIntValue(Util.null2String(request.getParameter("triggerSettingRows_"+i)),0);
						for(int j=0;j<triggerSettingRows;j++){
							if(null==request.getParameter("tabletype"+i+j))
							{
								continue;
							}
							String tabletype = Util.null2String(request.getParameter("tabletype"+i+j));//联动字段所属表类型
							String tableralations = Util.null2String(request.getParameter("tableralations"+i+j));//表之间关联条件
							String datasourcename = Util.null2String(request.getParameter("datasource"+i+j));//数据源
							statement.setStatementSql("insert into modeDataInputmain(entryID,WhereClause,IsCycle,OrderID,datasourcename) values(?,?,?,?,?)");
							statement.setInt(1,entryId);
							statement.setString(2,tableralations);
							statement.setInt(3,1);
							statement.setInt(4,(i+1));
							statement.setString(5,datasourcename);
							statement.executeUpdate();
							
							int DataInputID = 0;
							statement.setStatementSql("select max(id) as DataInputID from modeDataInputmain");	
							statement.executeQuery();
							if(statement.next()) DataInputID = statement.getInt("DataInputID");
							int tableTableRows = Util.getIntValue(Util.null2String(request.getParameter("tableTableRowsNum_"+i+"_"+j)),0);
							for(int m=1;m<=tableTableRows;m++){
								String tableTableName = Util.null2String(request.getParameter("tablename"+i+j+m));//引用数据库表名
								String tableTableByName = Util.null2String(request.getParameter("tablebyname"+i+j+m));//别名
								String formid = Util.null2String(request.getParameter("formid"+i+j+m));//表单id
								if(!tableTableName.equals("")||!tableTableByName.equals(""))
								{
								    statement.setStatementSql("insert into modeDataInputtable(DataInputID,TableName,Alias,FormId) values(?,?,?,?)");
									statement.setInt(1,DataInputID);
									statement.setString(2,tableTableName);
									statement.setString(3,tableTableByName);
									statement.setString(4,formid);
									statement.executeUpdate();
								}
							}
							
							int parameterTableRows = Util.getIntValue(Util.null2String(request.getParameter("parameterTableRowsNum_"+i+"_"+j)),0);
							for(int m=1;m<parameterTableRows;m++){
								String parafieldname = Util.null2String(request.getParameter("parafieldname"+i+j+m));//取值参数-〉参数字段
								String parawfField = Util.null2String(request.getParameter("parawfField"+i+j+m));//取值参数-〉流程字段
								if(parafieldname.equals("")||parawfField.equals("")) continue;
								String parafieldtablename = Util.null2String(request.getParameter("parafieldtablename"+i+j+m));//字段所属表名
								int TableID = 0;
								rs1.executeSql("select id from modeDataInputtable where DataInputID="+DataInputID+" and TableName='"+parafieldtablename+"'");	
								if(rs1.next()) TableID = rs1.getInt("id");
								rs1.executeSql("insert into modeDataInputfield(DataInputID,TableID,Type,DBFieldName,PageFieldName) values("+DataInputID+","+TableID+",1,"+"'"+parafieldname+"'"+",'field"+parawfField+"'"+")");
							}
							
							String evaluatewfFields = "";
							int evaluateTableRows = Util.getIntValue(Util.null2String(request.getParameter("evaluateTableRowsNum_"+i+"_"+j)),0);
							for(int m=1;m<evaluateTableRows;m++){
								String evaluatefieldname = Util.null2String(request.getParameter("evaluatefieldname"+i+j+m));//取值参数-〉参数字段
								String evaluatewfField = Util.null2String(request.getParameter("evaluatewfField"+i+j+m));//取值参数-〉流程字段
								if(evaluatefieldname.equals("")||evaluatewfField.equals("")) continue;
								evaluatewfFields += evaluatewfField + ",";
								String evaluatefieldtablename = Util.null2String(request.getParameter("evaluatefieldtablename"+i+j+m));//字段所属表名
								//System.out.println("evaluatefieldtablename"+i+j+m+"="+evaluatefieldtablename);
								int TableID = 0;
								rs1.executeSql("select id from modeDataInputtable where DataInputID="+DataInputID+" and TableName='"+evaluatefieldtablename+"'");
								//System.out.println("select id from modeDataInputtable where DataInputID="+DataInputID+" and TableName='"+evaluatefieldtablename+"'");
								if(rs1.next()) TableID = rs1.getInt("id");
								rs1.executeSql("insert into modeDataInputfield(DataInputID,TableID,Type,DBFieldName,PageFieldName) values("+DataInputID+","+TableID+",2,"+"'"+evaluatefieldname+"'"+",'field"+evaluatewfField+"'"+")");
							}
							if(!evaluatewfFields.equals("")){//判断在一个触发设置中，触发字段和被触发字段是否属于同组（同为主字段或为同一明细）
							    evaluatewfFields += triggerField;
							    rs1.executeSql("select distinct groupId from workflow_formfield where formid="+modeformid+" and fieldid in ("+evaluatewfFields+")");
							    if(rs1.getCounts()>1)
							    {
							    	ModeLinkageInfo.deleteEntryById(entryID,modeId,rs1);
							    	errormsg = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
							    }
							}
							
						}
					}
				}
			}
			else
			{
				String entryIDs = "0";
				String[] fieldEntryIDs = request.getParameterValues("fieldEntryID");
				if(null!=fieldEntryIDs&&fieldEntryIDs.length>0)
				{
					for(int i = 0;i<fieldEntryIDs.length;i++)
					{
						entryID =  Util.getIntValue(fieldEntryIDs[i],0);
						if(entryID>0)
						{
							entryIDs += entryIDs.equals("")?(""+entryID):(","+entryID);
						}
					}
				}
				if(!"".equals(entryIDs))
				{
					String delEntryIDs = "";
					//删除
					rs1.executeSql("select id from modeDataInputentry where modeId="+modeId+" and id not in ("+entryIDs+")");
					while(rs1.next()){
						delEntryIDs += delEntryIDs.equals("")?(""+rs1.getInt("id")):(","+rs1.getInt("id"));
					}
					if(!"".equals(delEntryIDs))
					{
						rs1.executeSql("delete from modeDataInputentry where modeId="+modeId+" and id in ("+delEntryIDs+")");
						
						ArrayList entryIDsArr = Util.TokenizerString(delEntryIDs,",");
						String DataInputIDs = ",";
						for(int i=0;i<entryIDsArr.size();i++)
						{
							entryID = Util.getIntValue((String)entryIDsArr.get(i),0);
							rs1.executeSql("select id from modeDataInputmain where entryID="+entryID);
							while(rs1.next())
							{
								DataInputIDs += rs1.getInt("id")+",";
							}
							rs1.executeSql("delete from modeDataInputmain where entryID="+entryID);
						}
						
						ArrayList DataInputIDsArr = Util.TokenizerString(DataInputIDs,",");
						for(int i=0;i<DataInputIDsArr.size();i++)
						{
							String DataInputID = (String)DataInputIDsArr.get(i);
							rs1.executeSql("delete from modeDataInputtable where DataInputID="+DataInputID);
							rs1.executeSql("delete from modeDataInputfield where DataInputID="+DataInputID);
						}
					}
				}
			}
		}catch(Exception exception){
		}finally{
			if(null!=statement){
				try{
					statement.close();
					statement = null;
				}catch(Exception e){
					
				}
			}
		}
	}
	if(!"entry".equals(srcfrom)){
		response.sendRedirect("fieldTrigger.jsp?ajax=1&modeId="+modeId);
	}else{
		if(!"".equals(errormsg)){
			out.println("<script language=javascript>alert('"+errormsg+"');</script>");
		}
		out.println("<script language=javascript>window.parent.close();</script>");
	}
%>



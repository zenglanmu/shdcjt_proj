<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet6" class="weaver.conn.RecordSet" scope="page" />
<%

	String currentdate = "";	   // 当前日期
	String currenttime = "";	   // 当前时间
	Calendar today = Calendar.getInstance();
	currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			Util.add0(today.get(Calendar.SECOND), 2);
		
	String votingIds = Util.null2String(request.getParameter("ids"));
	//votingIds = votingIds.substring(0,votingIds.lastIndexOf(","));
	//System.out.println(votingIds);
	boolean isOracle = RecordSet1.getDBType().equals("oracle");
	String[] ids = votingIds.split(",");
	for(int i=0;i<ids.length;i++){
		String id = ids[i];
		String insertSql = "";
		if(isOracle){
			insertSql=" insert into voting (id,subject,detail,createrid,createdate,createtime,approverid,begindate,begintime,enddate,endtime,isanony,status,isSeeResult,votingtype) "
				 +" (select voting_id.nextval,subject,detail,"+user.getUID()+",'"+currentdate+"','"+currenttime+"',approverid,begindate,begintime,enddate,endtime,isanony,0,isSeeResult,votingtype from voting where id = "+id+")";
		}else{    
			insertSql=" insert into voting (subject,detail,createrid,createdate,createtime,approverid,begindate,begintime,enddate,endtime,isanony,status,isSeeResult,votingtype) "
				 +" (select subject,detail,"+user.getUID()+",'"+currentdate+"','"+currenttime+"',approverid,begindate,begintime,enddate,endtime,isanony,0,isSeeResult,votingtype from voting where id = "+id+")";
		}
		RecordSet1.execute(insertSql);
		
		String idsSql = "select id from voting where createrid="+user.getUID()+" and createdate='"+currentdate+"' and createtime='"+currenttime+"' order by id desc ";
		RecordSet2.executeSql(idsSql);
		if(RecordSet2.next()){
			String votingId = RecordSet2.getString("id");
			String insertQuestionSql = "";
			if(isOracle){
				insertQuestionSql=" insert into votingquestion (id,description,votingid,ismulti,isother,questioncount,ismultino,subject,showorder) "
					 +" ( select votingquestion_id.nextval,description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder "
					 +" from ( select description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder from votingquestion where votingid = "+id+" order by id))";
			}else{    
				insertQuestionSql = "insert into votingquestion (description,votingid,ismulti,isother,questioncount,ismultino,subject,showorder)"
					 +" select description,"+votingId+",ismulti,isother,questioncount,ismultino,subject,showorder from votingquestion where votingid="+id+" order by id ";
			}
			RecordSet3.execute(insertQuestionSql);
			//System.out.println(insertQuestionSql);
			//new question id
			String questionIdsSql = "select id from votingquestion where votingid="+votingId+" order by id";
			RecordSet4.executeSql(questionIdsSql);
			
			//old question id
			String oldQuestionIdsSql = "select id from votingquestion where votingid="+id+" order by id";
			RecordSet5.executeSql(oldQuestionIdsSql);
			while(RecordSet4.next() && RecordSet5.next()){
				String newQuestionId = RecordSet4.getString("id");
				String oldQuestionId = RecordSet5.getString("id");
				String insertOptionSql = "";
				if(isOracle){
					insertOptionSql = "insert into votingoption (id,votingid,questionid,description,optioncount,showorder)"
						 +" (select votingoption_id.nextval,"+votingId+","+newQuestionId+",description,optioncount,showorder "
						 +" from ( select "+votingId+","+newQuestionId+",description,optioncount,showorder from votingoption where votingid="+id+" and questionid="+oldQuestionId+" order by id))";				
				}else{    
					insertOptionSql = "insert into votingoption (votingid,questionid,description,optioncount,showorder)"
						 +" (select "+votingId+","+newQuestionId+",description,optioncount,showorder from votingoption where votingid="+id+" and questionid="+oldQuestionId+")";
				}
				RecordSet6.execute(insertOptionSql);
			}
		}
	}
	response.sendRedirect("VotingList.jsp");
	return;  
%>
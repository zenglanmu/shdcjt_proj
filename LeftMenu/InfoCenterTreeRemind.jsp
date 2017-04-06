<%@ page language="java" contentType="text/xml; charset=GBK" %><%@ page import="java.util.ArrayList,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");response.setDateHeader("Expires",0);%><%User user = HrmUserVarify.getUser(request,response);%><?xml version="1.0" encoding="gbk"?><tree><%

if(user == null)  return ;
String s = "", sql="";
int userid=user.getUID();
int usertype= Util.getIntValue(user.getLogintype(),1)-1;   
//Remind
//sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" group by a.type";
if(rs.getDBType().equals("oracle")){
sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1  ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1  and (dbms_lob.instr(t1.coworkers,',"+userid+",',1,1)>0 or t1.creater="+userid+") and dbms_lob.instr(t1.isnew,',"+userid+",',1,1)<=0))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
}
else
{
sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1  ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1 and (t1.coworkers like '%,"+userid+",%' or t1.creater="+userid+") and t1.isnew not like '%,"+userid+",%'))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
}
rs.executeSql(sql);

while(rs.next()){
	if(rs.getString("statistic").equals("y"))
	{   
	   int count=rs.getInt("count");

		s += "<tree text=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"("+count+")"+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3.gif\" action=\""+rs.getString("link")+"\" />";
	}
	else
		s += "<tree text=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3.gif\" action=\""+rs.getString("link")+"\" />";
}

out.print(s+"</tree>");
%>


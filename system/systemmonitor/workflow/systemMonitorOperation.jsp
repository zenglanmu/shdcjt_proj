<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
int userid=user.getUID();

int wfid = 0;
boolean flag = true;
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String[] value;
String[] value1;
char separ = Util.getSeparator();
String Procpara = "";

    String  actionKey = request.getParameter("actionKey");//added by xwj for td2903 20051020
    int monitorhrmid = Util.getIntValue(request.getParameter("monitorhrmid"),0);
    int monitortypeid = Util.getIntValue(request.getParameter("monitortypeid"),0);
    int temptypeid = Util.getIntValue(request.getParameter("typeid"),0);
    int oldmonitortypeid = Util.getIntValue(request.getParameter("oldmonitortypeid"),0);
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    int oldsubcompanyid = Util.getIntValue(request.getParameter("oldsubcompanyid"),0);
    int ischeckall = Util.getIntValue(request.getParameter("checkall"),0);
    int viewcheckall = Util.getIntValue(request.getParameter("viewcheckall"),0);
    int intervenorcheckall = Util.getIntValue(request.getParameter("intervenorcheckall"),0);
    int detachable = Util.getIntValue(request.getParameter("detachable"),0);
    int isview=0;
    int isintervenor=0;
    ArrayList isviewlist=new ArrayList();
    ArrayList isintervenorlist=new ArrayList();
    int delcheckall = Util.getIntValue(request.getParameter("delcheckall"),0);
    int fbcheckall = Util.getIntValue(request.getParameter("fbcheckall"),0);
    int focheckall = Util.getIntValue(request.getParameter("focheckall"),0);
    int socheckall = Util.getIntValue(request.getParameter("socheckall"),0);
    int isdelete=0;
    int isfb=0;
    int isfo=0;
    int isso = 0;
    ArrayList isdellist=new ArrayList();
    ArrayList isfblist=new ArrayList();
    ArrayList isfolist=new ArrayList();
    ArrayList issolist = new ArrayList();
    if("add".equals(actionKey)){//added by xwj for td2903 20051020
    try{
	String typeid="-1";
	String typeidtemp="-1";
	String wfids="-1";
    if(ischeckall==0){
     for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("VW")==0){
                     isviewlist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("IW")==0){
                     isintervenorlist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("DW")==0){
                     isdellist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("BW")==0){
                     isfblist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("OW")==0){
                     isfolist.add(value1[i].substring(2));
                 }
                 if(value1[i].indexOf("SW")==0){
                     issolist.add(value1[i].substring(2));
                 }
             }
         }
         if(elementname.indexOf("t")==0)
		 { wfids+=","+elementname.substring(1,elementname.length());
		 String wname="w"+elementname.substring(1,elementname.length());
		 //没有展开的不编辑
		 
         String[] valuet=request.getParameterValues(wname);
		 //System.out.print("wname"+wname +":"+"valuet"+valuet);
		 if (valuet!=null)
			 {
		   typeid=typeid+","+elementname.substring(1,elementname.length());  
			 }
			 else
			 {
			typeidtemp=typeidtemp+","+elementname.substring(1,elementname.length()); 
			 }
		 }
		 
	  }
	  //System.out.println("delete from workflow_monitor_bound where  monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where workflowtype in ("+typeid+") or workflowtype not in ("+wfids+"))");
	  if(detachable==1)
	  {
	  	if(rs.getDBType().equals("oracle"))
	  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where (workflowtype in ("+typeid+") or workflowtype not in ("+wfids+")) and nvl(subcompanyid,0) = "+subcompanyid+") and nvl(monitortype,0)="+oldmonitortypeid);
	  	else
	  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where (workflowtype in ("+typeid+") or workflowtype not in ("+wfids+")) and isnull(subcompanyid,0) = "+subcompanyid+") and isnull(monitortype,0)="+oldmonitortypeid);
	  }
	  else
	  {
	  	if(rs.getDBType().equals("oracle"))
	  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where workflowtype in ("+typeid+") or workflowtype not in ("+wfids+")) and nvl(monitortype,0)="+oldmonitortypeid);
	  	else
	  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where workflowtype in ("+typeid+") or workflowtype not in ("+wfids+")) and isnull(monitortype,0)="+oldmonitortypeid);
	  }
	  // out.print("delete from workflow_monitor_bound where  monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where workflowtype in ("+typeid+") or workflowtype not in ("+wfids+"))");
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
			//out.print((String) En.nextElement()+"<br>");
            value=request.getParameterValues((String) En.nextElement());
             for(int i=0;i<value.length;i++){
              value[i]=Util.null2String(value[i]);
              if(value[i].indexOf("W")==0){
                 wfid = Integer.parseInt(value[i].substring(1,value[i].length()));
                 isview=(isviewlist.indexOf(""+wfid)==-1)?0:1;
                 isintervenor=(isintervenorlist.indexOf(""+wfid)==-1)?0:1;
                 isdelete=(isdellist.indexOf(""+wfid)==-1)?0:1;
                 isfb=(isfblist.indexOf(""+wfid)==-1)?0:1;
                 isfo=(isfolist.indexOf(""+wfid)==-1)?0:1;
                 isso=(issolist.indexOf(""+wfid)==-1)?0:1;
                 
                 rs.executeSql("insert into workflow_monitor_bound(monitorhrmid,workflowid,operatordate,operatortime,isview,isintervenor,isdelete,isForceDrawBack,isForceOver,issooperator,operator,monitortype,subcompanyid) values ("+monitorhrmid+","+wfid+",'"+currentDate+"','"+currentTime+"',"+isview+",'"+isintervenor+"','"+isdelete+"','"+isfb+"','"+isfo+"','"+isso+"',"+userid+","+monitortypeid+","+subcompanyid+")");
               }
             }
           }
          if(detachable==1)
		  {
		  	if(rs.getDBType().equals("oracle"))
		  		rs.executeSql("update workflow_monitor_bound set monitortype="+monitortypeid+" where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where nvl(subcompanyid,0) = "+subcompanyid+") and nvl(monitortype,0)="+oldmonitortypeid);
		  	else
		  		rs.executeSql("update workflow_monitor_bound set monitortype="+monitortypeid+" where monitorhrmid = " + monitorhrmid+" and workflowid in (select id from workflow_base where isnull(subcompanyid,0) = "+subcompanyid+") and isnull(monitortype,0)="+oldmonitortypeid);
		  }
		  else
		  {
		  	if(rs.getDBType().equals("oracle"))
		  		rs.executeSql("update workflow_monitor_bound set monitortype="+monitortypeid+" where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+oldmonitortypeid);
		  	else
		  		rs.executeSql("update workflow_monitor_bound set monitortype="+monitortypeid+" where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+oldmonitortypeid);
		  }
    }else{
        if(viewcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("VW")==0){
                     isviewlist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(intervenorcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("IW")==0){
                     isintervenorlist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(delcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("DW")==0){
                     isdellist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(fbcheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("BW")==0){
                     isfblist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(focheckall==0){
        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
		 String elementname=(String)En.nextElement();
	     value1=request.getParameterValues(elementname);
		 if(value1!=null){
             for(int i=0;i<value1.length;i++){
                 if(value1[i].indexOf("OW")==0){
                     isfolist.add(value1[i].substring(2));
                 }
             }
         }
	  }
        }
        if(socheckall==0){
	        for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
			 String elementname=(String)En.nextElement();
		     value1=request.getParameterValues(elementname);
			 if(value1!=null){
	             for(int i=0;i<value1.length;i++){
	                 if(value1[i].indexOf("SW")==0){
	                     issolist.add(value1[i].substring(2));
	                 }
	             }
	         }
		  }
        }
        if(detachable==1)
        {
        	if(rs.getDBType().equals("oracle"))
		  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and exists (select workflow_base.id from workflow_base where nvl(workflow_base.subcompanyid,0) = "+subcompanyid+" and workflow_base.id=workflow_monitor_bound.workflowid) and nvl(monitortype,0)="+oldmonitortypeid);
		  	else
		  		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and exists (select workflow_base.id from workflow_base where isnull(workflow_base.subcompanyid,0) = "+subcompanyid+" and workflow_base.id=workflow_monitor_bound.workflowid) and isnull(monitortype,0)="+oldmonitortypeid);
        }
        else
        {
        	if(rs.getDBType().equals("oracle"))
        		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+oldmonitortypeid);
        	else
        		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+oldmonitortypeid);
        }
        
        //rs.executeSql("select * from workflow_base where isvalid='1'  and subcompanyid in ("+subid+") order by id");
        
        if(detachable==1)
        {
        	if(rs.getDBType().equals("oracle"))
		  		rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') and nvl(subcompanyid,0) = "+subcompanyid+" order by id");
		  	else
		  		rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') and isnull(subcompanyid,0) = "+subcompanyid+" order by id");
        }
        else
        {
        	rs.executeSql("select * from workflow_base where (isvalid='1' or isvalid='2') order by id");
        }
        
        //WorkflowComInfo.setTofirstRow();
        while(rs.next()){
            wfid=Integer.parseInt(rs.getString("id"));
            if(viewcheckall==1) isview=1;
            else{
                isview=(isviewlist.indexOf(""+wfid)==-1)?0:1;
            }
            if(intervenorcheckall==1) isintervenor=1;
            else{
                isintervenor=(isintervenorlist.indexOf(""+wfid)==-1)?0:1;
            }
            if(delcheckall==1) isdelete=1;
            else{
                isdelete=(isdellist.indexOf(""+wfid)==-1)?0:1;
            }
            if(fbcheckall==1) isfb=1;
            else{
                isfb=(isfblist.indexOf(""+wfid)==-1)?0:1;
            }
            if(focheckall==1) isfo=1;
            else{
                isfo=(isfolist.indexOf(""+wfid)==-1)?0:1;
            }
            if(socheckall==1) isso=1;
            else{
                isso=(issolist.indexOf(""+wfid)==-1)?0:1;
            }
            rs.executeSql("insert into workflow_monitor_bound(monitorhrmid,workflowid,operatordate,operatortime,isview,isintervenor,isdelete,isForceDrawBack,isForceOver,issooperator,operator,monitortype,subcompanyid) values ("+monitorhrmid+","+wfid+",'"+currentDate+"','"+currentTime+"',"+isview+",'"+isintervenor+"','"+isdelete+"','"+isfb+"','"+isfo+"','"+isso+"',"+userid+","+monitortypeid+","+subcompanyid+")");
        }
    }
    //rs.executeSql("update workflow_monitor_bound set monitortype="+monitortypeid+",subcompanyid=(select subcompanyid from workflow_base where id = workflow_monitor_bound.workflowid) where monitorhrmid="+monitorhrmid);
   }
   catch(Exception e){
    flag = false;
	//out.print(e.toString());
   }
if(flag){
 response.sendRedirect("systemMonitorStatic.jsp?infoKey=1&typeid="+monitortypeid+"&subcompanyid="+subcompanyid);
 return;
}
else{
response.sendRedirect("systemMonitorStatic.jsp?infoKey=2&typeid="+monitortypeid+"&subcompanyid="+subcompanyid);
 return;
}


/* -------- xwj for td2903 20051020 begin ---------*/
}
else if("del".equals(actionKey)){
	
    //rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid);
    if(detachable==1)
    {
    	if(rs.getDBType().equals("oracle"))
			rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and nvl(monitortype,0)="+temptypeid);
		else
			rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid);
    }
    else
    {
    	if(rs.getDBType().equals("oracle"))
    		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid);
    	else
    		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid);
    }
    response.sendRedirect("systemMonitorStatic.jsp?typeid="+monitortypeid+"&subcompanyid="+subcompanyid);
    return;
}
else if("delflow".equals(actionKey))
{
    int flowid = Util.getIntValue(request.getParameter("flowid"),0);
    if(detachable==1)
    {
    	if(rs.getDBType().equals("oracle"))
			rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and  nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
		else
			rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
    }
    else
    {
    	if(rs.getDBType().equals("oracle"))
    		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
    	else
    		rs.executeSql("delete from workflow_monitor_bound where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
    }
    response.sendRedirect("systemMonitorDetail.jsp?monitorhrmid="+monitorhrmid+"&subcompanyid="+subcompanyid+"&typeid="+temptypeid);
    return;
}
else if("upview".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isview = Util.getIntValue(request.getParameter("isview"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set isview="+isview+" where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and  nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set isview="+isview+" where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set isview="+isview+" where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set isview="+isview+" where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}else if("upintervenor".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isintervenor = Util.getIntValue(request.getParameter("isintervenor"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set isintervenor='"+isintervenor+"' where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and  nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set isintervenor='"+isintervenor+"' where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set isintervenor='"+isintervenor+"' where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set isintervenor='"+isintervenor+"' where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}else if("updel".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isdelete = Util.getIntValue(request.getParameter("isdelete"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set isdelete='"+isdelete+"' where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set isdelete='"+isdelete+"' where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set isdelete='"+isdelete+"' where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set isdelete='"+isdelete+"' where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}else if("upfb".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isfb = Util.getIntValue(request.getParameter("isForceDrawBack"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set isForceDrawBack='"+isfb+"' where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and   nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set isForceDrawBack='"+isfb+"' where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set isForceDrawBack='"+isfb+"' where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set isForceDrawBack='"+isfb+"' where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}else if("upfo".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isfo = Util.getIntValue(request.getParameter("isForceOver"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set isForceOver='"+isfo+"' where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and  nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set isForceOver='"+isfo+"' where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set isForceOver='"+isfo+"' where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set isForceOver='"+isfo+"' where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}
else if("upso".equals(actionKey))
{
 int flowid = Util.getIntValue(request.getParameter("flowid"),0);
 isso = Util.getIntValue(request.getParameter("issooperator"),0);
 if(detachable==1)
 {
  	if(rs.getDBType().equals("oracle"))
		rs.executeSql("update workflow_monitor_bound set issooperator='"+isso+"' where monitorhrmid = " + monitorhrmid+" and nvl(subcompanyid,0)="+subcompanyid+" and  nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
	else
		rs.executeSql("update workflow_monitor_bound set issooperator='"+isso+"' where monitorhrmid = " + monitorhrmid+" and isnull(subcompanyid,0)="+subcompanyid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
  else
  {
  	if(rs.getDBType().equals("oracle"))
  		rs.executeSql("update workflow_monitor_bound set issooperator='"+isso+"' where monitorhrmid = " + monitorhrmid+" and nvl(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  	else
  		rs.executeSql("update workflow_monitor_bound set issooperator='"+isso+"' where monitorhrmid = " + monitorhrmid+" and isnull(monitortype,0)="+temptypeid+" and workflowid="+flowid);
  }
}
%>
/* -------- xwj for td2903 20051020 end ---------*/
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}  
String fromid=Util.null2String(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));
String todeptid=ResourceComInfo.getDepartmentID(toid);
char separator = Util.getSeparator() ;
String procedurepara="";

//for CRM
String crmidstr=Util.null2String(request.getParameter("crmidstr"));
String crmall=Util.null2String(request.getParameter("crmall"));
int crmallnum=Util.getIntValue(request.getParameter("crmallnum"),0);
int crmnum=0;
if(crmall.equals("1"))	crmnum=crmallnum;
ArrayList crmids=new ArrayList();
if(!crmidstr.equals("")){
	crmids=Util.TokenizerString(crmidstr,",");
	crmnum=crmids.size();
}


//for project
String projectidstr=Util.null2String(request.getParameter("projectidstr"));
String projectall=Util.null2String(request.getParameter("projectall"));
int projectallnum=Util.getIntValue(request.getParameter("projectallnum"),0);
int projectnum=0;
if(projectall.equals("1"))	projectnum=projectallnum;
ArrayList projectids= new ArrayList();
if(!projectidstr.equals("")){
	projectids=Util.TokenizerString(projectidstr,",");
	projectnum=projectids.size();
}

//for event
String eventIDStr=Util.null2String(request.getParameter("eventIDStr"));
String eventAll=Util.null2String(request.getParameter("eventAll"));
int eventAllNum=Util.getIntValue(request.getParameter("eventAllNum"),0);
int eventNum=0;
if(eventAll.equals("1"))  eventNum=eventAllNum;
ArrayList eventIDs = new ArrayList();
if(!eventIDStr.equals("")){
    eventIDs=Util.TokenizerString(eventIDStr,",");
    eventNum=eventIDs.size();
}

//for cowork
String coworkIDStr=Util.null2String(request.getParameter("coworkIDStr"));
String coworkAll=Util.null2String(request.getParameter("coworkAll"));
int coworkAllNum=Util.getIntValue(request.getParameter("coworkAllNum"),0);
int coworkNum=0;
if(coworkAll.equals("1"))  coworkNum=coworkAllNum;
ArrayList coworkIDs = new ArrayList();
if(!coworkIDStr.equals("")){
    coworkIDs=Util.TokenizerString(coworkIDStr,",");
    coworkNum=coworkIDs.size();
}

//for resource
String resourceidstr=Util.null2String(request.getParameter("resourceidstr"));
String resourceall=Util.null2String(request.getParameter("resourceall"));
int resourceallnum=Util.getIntValue(request.getParameter("resourceallnum"),0);
int resourcenum=0;
if(resourceall.equals("1"))	resourcenum=resourceallnum;
ArrayList resourceids=new ArrayList();
if(!resourceidstr.equals("")){
	resourceids=Util.TokenizerString(resourceidstr,",");
	resourcenum=resourceids.size();
}

//for doc  begin
String docidstr=Util.null2String(request.getParameter("docidstr"));
String docall=Util.null2String(request.getParameter("docall"));
int docallnum=Util.getIntValue(request.getParameter("docallnum"),0);

String sqlDocOwner="";
String sqlDocShare="";
String sqlDocShareOwner="";
String sqlDocShare1="";
String sqlDocShareOwner1="";
String sqlDocShare2="";
String sqlDocShareOwner2="";
String sqlDocSubscribe1="";
String sqlDocSubscribe2="";
int docnum=0;
 
if("1".equals(docall)){
    docnum=docallnum;
    
	docidstr="";
	RecordSet.executeSql("select id from docdetail  where ownerid="+fromid+" and  maincategory!=0  and subcategory!=0 and seccategory!=0");
	while(RecordSet.next()){
		docidstr+=","+Util.null2String(RecordSet.getString("id"));
	}
	if(!docidstr.equals("")){
		docidstr=docidstr.substring(1);
	}

    //
    sqlDocOwner="update docdetail set ownerid="+toid+" where ownerid="+fromid+" and  maincategory!=0  and subcategory!=0 and seccategory!=0";

    sqlDocShare1="update docshare set userid = "+toid+" where userid="+fromid+" and sharetype = 86 and docid in (select id from docdetail where ownerid="+fromid+" ) ";
	    
   	sqlDocShare2=" insert into docshare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,isSecDefaultShare) ( "
			    +" select docid,86,seclevel,rolelevel,sharelevel,"+toid+",subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,isSecDefaultShare from docshare "
			    +" where userid = "+fromid+" and sharetype = 80 and docid in (select id from docdetail where ownerid="+fromid+" ) "
			    +" and not exists ( select 1 from docshare where userid = "+toid+" and sharetype = 86 and docid in (select id from docdetail where ownerid="+fromid+" ) ) "
			    +" ) ";
    
    sqlDocShareOwner1="update shareinnerdoc set content="+toid+" where content="+fromid+" and srcfrom=86 and sourceid in (select id from docdetail  where ownerid="+fromid+" ) ";
    
	sqlDocShareOwner2=" insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) ( "
					 +" select sourceid,type,"+toid+",seclevel,sharelevel,86,opuser,sharesource from shareinnerdoc "
					 +" where content="+fromid+" and srcfrom = 80 and sourceid in (select id from docdetail  where ownerid="+fromid+" ) "
					 +" and not exists ( select 1 from shareinnerdoc where content="+toid+" and srcfrom=86 and sourceid in (select id from docdetail where ownerid="+fromid+" ) ) "
					 +" ) ";
	sqlDocSubscribe1="update docsubscribe set hrmId="+toid+" where hrmId="+fromid;
	sqlDocSubscribe2="update docsubscribe set ownerId="+toid+" where ownerId="+fromid;    
} else {  
    if(!"".equals(docidstr)){
       docnum=Util.TokenizerString(docidstr,",").size();
       
       //update by alan on 2009-08-17 for td:11539
       sqlDocOwner="update docdetail set ownerid="+toid+" where parentids in(select parentids from docdetail where id in("+docidstr+"))";
       
       sqlDocShare1="update docshare set userid = "+toid+" where userid="+fromid+" and sharetype = 86 and docid in ("+docidstr+" ) ";
	    
       sqlDocShare2=" insert into docshare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,isSecDefaultShare) ( "
		   		   +" select docid,86,seclevel,rolelevel,sharelevel,"+toid+",subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,isSecDefaultShare from docshare "
		   		   +" where userid = "+fromid+" and sharetype = 80 and docid in ("+docidstr+" ) "
		   		   +" and not exists ( select 1 from docshare where userid = "+toid+" and sharetype = 86 and docid in ("+docidstr+" ) ) "
		   		   +" ) ";
       
       sqlDocShareOwner1="update shareinnerdoc set content="+toid+" where content="+fromid+" and srcfrom=86 and sourceid in ("+docidstr+" ) ";
       
	   sqlDocShareOwner2=" insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) ( "
	   				    +" select sourceid,type,"+toid+",seclevel,sharelevel,86,opuser,sharesource from shareinnerdoc "
	   				    +" where content="+fromid+" and srcfrom = 80 and sourceid in ("+docidstr+" ) "
	   				    +" and not exists ( select 1 from shareinnerdoc where content="+toid+" and srcfrom=86 and sourceid in ("+docidstr+" ) ) "
	   				    +" ) ";
       sqlDocSubscribe1="update docsubscribe set hrmId="+toid+" where hrmId="+fromid+" and docId in("+docidstr+")";
       sqlDocSubscribe2="update docsubscribe set ownerId="+toid+" where ownerId="+fromid+" and docId in("+docidstr+")";    
    }
}
if(!sqlDocShareOwner2.equals("")) RecordSet.executeSql(sqlDocShareOwner2);
if(!sqlDocShareOwner1.equals("")) RecordSet.executeSql(sqlDocShareOwner1);
if(!sqlDocShare2.equals("")) RecordSet.executeSql(sqlDocShare2);
if(!sqlDocShare1.equals("")) RecordSet.executeSql(sqlDocShare1);
if(!sqlDocOwner.equals("")) RecordSet.executeSql(sqlDocOwner);
if(!sqlDocSubscribe1.equals("")) RecordSet.executeSql(sqlDocSubscribe1);
if(!sqlDocSubscribe2.equals("")) RecordSet.executeSql(sqlDocSubscribe2);

//if("1".equals(docall)){
//	RecordSet.executeSql("select id from docdetail  where ownerid="+fromid);
//	while(RecordSet.next()){
//		DocComInfo.updateDocInfoCache(Util.null2String(RecordSet.getString(1)));
//	}
//} else {
	ArrayList doclist = Util.TokenizerString(docidstr,",");
	for(Iterator it=doclist.iterator();it.hasNext();)
		DocComInfo.updateDocInfoCache((String)it.next());
//}

//for doc  end

int i=0;
String id="";
//For CRM
	if(crmall.equals("1")||(crmnum==crmallnum&&crmnum>0)){
		procedurepara=fromid+separator+toid+separator+"0";
        CustomerModifyLog.modifyAll(fromid,toid);
        RecordSet.executeSql("update CRM_CustomerInfo set department = (select departmentid from hrmresource where id = "+toid+") where manager = "+fromid);		
		
		ArrayList crmidsArr = new ArrayList();
		RecordSet.executeSql("select id from CRM_CustomerInfo where manager="+fromid);
		while(RecordSet.next()){
		    crmidsArr.add(RecordSet.getString("id"));
		}
		
		RecordSet.executeProc("HrmRightTransfer_CRM",procedurepara);
		
		for(int j=0;j<crmidsArr.size();j++){
		    String tempcrmid = (String)crmidsArr.get(j);
		    CrmShareBase.setDefaultShare(tempcrmid);
		    CrmShareBase.setCRM_WPShare_newCRMManager(tempcrmid);
		}		

	}
	else{
		if(crmnum>0){
		for(i=0;i<crmids.size();i++){
			id=(String)crmids.get(i);
			procedurepara=fromid+separator+toid+separator+id;
            CustomerModifyLog.modify(id,fromid,toid);
			RecordSet.executeProc("HrmRightTransfer_CRM",procedurepara);
            RecordSet.executeSql("update CRM_CustomerInfo set department = (select departmentid from hrmresource where id = "+toid+") where id = "+id);
            
            //添加客户的默认共享
            //CrmShareBase.setDefaultShare(id);
            CrmShareBase.setCRM_WPShare_newCRMManager(id);
		}
		}
	}

//For Project
	if(projectall.equals("1")||(projectnum==projectallnum&&projectnum>0)){
		procedurepara=fromid+separator+toid+separator+"0";
		RecordSet.executeProc("HrmRightTransfer_Project",procedurepara);
		PrjViewer.setPrjShareByHrm(fromid);
		PrjViewer.setPrjShareByHrm(toid);
	}
	else{
		if(projectnum>0){
			for(i=0;i<projectids.size();i++){
				id=(String)projectids.get(i);
				procedurepara=fromid+separator+toid+separator+id;
				RecordSet.executeProc("HrmRightTransfer_Project",procedurepara);
			}
			PrjViewer.setPrjShareByHrm(fromid);
			PrjViewer.setPrjShareByHrm(toid);
		}
	}
	
	//For cowork
	if(coworkAll.equals("1")||(coworkNum==coworkAllNum&&coworkNum>0)){
		RecordSet.executeSql("update cowork_items set coworkmanager="+toid+" where coworkmanager="+fromid);
	}else	if(coworkNum>0){
			for(i=0;i<coworkIDs.size();i++){
				id=(String)coworkIDs.get(i);
				RecordSet.executeSql("update cowork_items set coworkmanager="+toid+" where coworkmanager="+fromid+" and id="+id);
			}		
	}
    
    //For Event
    int eventFinishNum = 0;
    session.removeAttribute("showTransferMessage");
    if(eventAll.equals("1")||(eventNum==eventAllNum&&eventNum>0))
    {
        //判断是否有流程同时归档于被转移人和转移人
        RecordSet.execute("SELECT 1 FROM WorkFlow_CurrentOperator a, WorkFlow_CurrentOperator b WHERE a.requestId = b.requestId AND a.userId = " + fromid + " AND a.isRemark in ('2', '4') AND a.isComplete = 1 AND a.isLastTimes = 1 AND b.userId = " + toid + " AND b.isRemark in ('2', '4') AND b.isComplete = 1 AND b.isLastTimes = 1");
        if(RecordSet.next())
        {
            session.setAttribute("showTransferMessage", "show");
        }
        
        //办结事宜转移数量
        RecordSet.execute("select count(distinct(a.requestId)) AS eventFinishNum from workflow_currentoperator a where a.userid = " + fromid + " AND a.isRemark in ('2', '4') AND a.isComplete = 1 AND a.isLastTimes = 1 and not exists(select 1 from workflow_currentoperator b where b.userid = " + toid + "  AND b.isRemark in ('2', '4') AND b.isComplete = 1 AND b.isLastTimes = 1 and a.requestid = b.requestid)");
        if(RecordSet.next())
        {
            eventFinishNum = RecordSet.getInt("eventFinishNum");
        }
        
		//办结事宜转移
       RecordSet.execute("update workflow_currentoperator set userid = " + toid + " where userid = " + fromid + " AND isRemark in ('2', '4') AND isComplete = 1 AND isLastTimes = 1 and not exists(select 1 from workflow_currentoperator b where b.userid = " + toid + " AND b.isRemark in ('2', '4') AND b.isComplete = 1 AND b.isLastTimes = 1 and workflow_currentoperator.requestid = b.requestid)");
                
    }
    else
    {
        if(eventNum>0)
        {
			//判断是否有流程同时归档于被转移人和转移人
            RecordSet.execute("SELECT 1 FROM WorkFlow_CurrentOperator a, WorkFlow_CurrentOperator b WHERE a.requestId = b.requestId AND a.userId = " + fromid + " AND a.isRemark in ('2', '4') AND a.isComplete = 1 AND a.isLastTimes = 1 AND b.userId = " + toid + " AND b.isRemark in ('2', '4') AND b.isComplete = 1 AND b.isLastTimes = 1 AND a.requestId IN (" + eventIDStr + ") AND b.requestId IN (" + eventIDStr + ")");
            if(RecordSet.next())
            {
                session.setAttribute("showTransferMessage", "show");
            }
            
            for(i=0;i<eventIDs.size();i++)
            {
                id=(String)eventIDs.get(i);
                RecordSet.execute("select 1 from workflow_currentoperator where userid = " + toid + " and requestid = " + id + " AND isRemark in ('2', '4') AND isComplete = 1 AND isLastTimes = 1");

                if(false == RecordSet.next())
                {                
                    RecordSet.execute("update workflow_currentoperator set userid = " + toid + " where userid = " + fromid + " AND isRemark in ('2', '4') AND isComplete = 1 AND isLastTimes = 1 and requestid = " + id);
                    eventFinishNum++;
                }
            }            
        }
    }
    session.setAttribute("eventFinishNum", new Integer(eventFinishNum));

//For Resource
	if(resourceall.equals("1")||(resourcenum==resourceallnum&&resourcenum>0)){
		procedurepara=fromid+separator+toid+separator+"0";
		RecordSet.executeProc("HrmRightTransfer_Resource",procedurepara);
		//managerstr盲禄炉

		//get fromid's all manager
		String sql = "select managerstr from HrmResource where id = "+ fromid;
		RecordSet.executeSql(sql);
		RecordSet.next();
		String frommanagerstr = Util.null2String(RecordSet.getString("managerstr"));
		frommanagerstr +=fromid+",";
		//get toid's all manager
		sql = "select managerstr from HrmResource where id = "+ toid;
		RecordSet.executeSql(sql);
		RecordSet.next();
		String tomanagerstr = Util.null2String(RecordSet.getString("managerstr"));
		tomanagerstr += toid+",";
		//update all underling's managerstr
		sql = "select id,managerstr from HrmResource where managerstr like '"+frommanagerstr +"%'";
                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    String nowmanagerstr = Util.null2String(RecordSet.getString("managerstr"));
                    String resourceid = RecordSet.getString("id");
                    nowmanagerstr = Util.StringReplaceOnce(nowmanagerstr,frommanagerstr ,tomanagerstr);
                    procedurepara = resourceid + separator + nowmanagerstr ;
                    RecordSet.executeProc("HrmResource_UpdateManagerStr",procedurepara);
               }
	}
	else{
		if(resourcenum>0){
			//get fromid's all manager
			String sql = "select managerstr from HrmResource where id = "+ fromid;
			RecordSet.executeSql(sql);
			RecordSet.next();
			String frommanagerstr = Util.null2String(RecordSet.getString("managerstr"));
			frommanagerstr +=fromid+",";
			//get toid's all manager
			sql = "select managerstr from HrmResource where id = "+ toid;
			RecordSet.executeSql(sql);
			RecordSet.next();
			String tomanagerstr = Util.null2String(RecordSet.getString("managerstr"));
			tomanagerstr += toid+",";

			for(i=0;i<resourceids.size();i++){
				id=(String)resourceids.get(i);
				procedurepara=fromid+separator+toid+separator+id;
				RecordSet.executeProc("HrmRightTransfer_Resource",procedurepara);
				//managerstr盲禄炉

				//update selected id's managerstr
				procedurepara = id + separator + tomanagerstr ;
		                RecordSet.executeProc("HrmResource_UpdateManagerStr",procedurepara);
				//update managerstr of all underling of this id
				sql = "select id,managerstr from HrmResource where managerstr like '"+frommanagerstr+id+",%'";
		                RecordSet.executeSql(sql);
		                while(RecordSet.next()){
		                    String nowmanagerstr = Util.null2String(RecordSet.getString("managerstr"));
		                    String resourceid = RecordSet.getString("id");
		                    nowmanagerstr = Util.StringReplaceOnce(nowmanagerstr,frommanagerstr ,tomanagerstr);
		                    procedurepara = resourceid + separator + nowmanagerstr ;
		                    RecordSet.executeProc("HrmResource_UpdateManagerStr",procedurepara);
		               }
			}
		}
	}
//CustomerInfoComInfo.removeCustomerInfoCache();
ProjectInfoComInfo.removeProjectInfoCache();
ResourceComInfo.removeResourceCache();


String numberstr=crmallnum + "," + crmnum + "," + projectallnum + "," + projectnum + "," +
	resourceallnum + "," + resourcenum + "," + docallnum + "," + docnum + "," + eventAllNum + "," + eventNum + "," + coworkAllNum + "," + coworkNum+","+eventFinishNum;
response.sendRedirect("HrmRightTransferInfo.jsp?fromid="+fromid+"&toid="+toid+"&numberstr="+numberstr);
%>
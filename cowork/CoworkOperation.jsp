<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.cowork.CoworkDiscussVO"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.cowork.CoworkDAO" %>
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CoworkDao" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="workPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="sysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<%

FileUpload fu = new FileUpload(request);
int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);
String operation = Util.fromScreen(fu.getParameter("method"),user.getLanguage());
String id = Util.null2String(fu.getParameter("id"));                                  //协作id
String from = Util.null2String(fu.getParameter("from"));//用来表示从哪个页面进入的，从协作区进入from="cowork"，从其他地方进入from="other"

String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());
String typeid = Util.fromScreen(fu.getParameter("typeid"),user.getLanguage());
String levelvalue = Util.fromScreen(fu.getParameter("levelvalue"),user.getLanguage());
String creater = Util.fromScreen(fu.getParameter("creater"),user.getLanguage());
String coworkers = Util.fromScreen(fu.getParameter("coworkers"),user.getLanguage());
String begindate = Util.fromScreen(fu.getParameter("begindate"),user.getLanguage());
String beingtime = Util.fromScreen(fu.getParameter("beingtime"),user.getLanguage());
String enddate = Util.fromScreen(fu.getParameter("enddate"),user.getLanguage());
String endtime = Util.fromScreen(fu.getParameter("endtime"),user.getLanguage());
String relatedprj = Util.fromScreen(fu.getParameter("relatedprj"),user.getLanguage()); //相关项目任务
String relatedcus = Util.fromScreen(fu.getParameter("relatedcus"),user.getLanguage()); //相关客户
String relatedwf = Util.fromScreen(fu.getParameter("relatedwf"),user.getLanguage());   //相关流程
String relateddoc = Util.fromScreen(fu.getParameter("relateddoc"),user.getLanguage()); //相关文档
if("0".equals(relateddoc)) relateddoc="";
String relatedacc =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件

String remark = Util.null2String(fu.getParameter("remark"));                           //评论

String projectIDs = Util.null2String(fu.getParameter("projectIDs"));//td11838          //相关项目

String principal = Util.null2String(fu.getParameter("txtPrincipal"));                  //协作负责人

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String createdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String createtime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String status ="1";

Calendar current = Calendar.getInstance();
String currentDate = Util.add0(current.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(current.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(current.get(Calendar.DAY_OF_MONTH), 2) ;

char flag = 2;
String Proc="";
String userId =""+user.getUID();
boolean isoracle = (RecordSet.getDBType()).equals("oracle");
String disType=Util.null2String((String)session.getAttribute("disType")); //协作讨论显示方式，tree为树形
int floorNum=0;

if(operation.equals("add")){ //添加协作
	
	if(name.equals("")  || begindate.equals("")  || enddate.equals("") ){
		response.sendRedirect("/cowork/AddCoWork.jsp");
		return;
	}
	String tempdocids = "";
	ArrayList docids = new ArrayList();
	docids = Util.TokenizerString(relateddoc,",");
	for(int i=0;i<docids.size();i++){
		tempdocids =tempdocids+docids.get(i).toString()+"|"+userId+",";
	}
	//添加事务控制，创建异常回滚数据
    RecordSetTrans rst=new RecordSetTrans();
	rst.setAutoCommit(false);
	try{
		 Proc=name+flag+typeid+flag+levelvalue+flag+creater+flag+principal+flag+
	          createdate+flag+createtime+flag+begindate+flag+beingtime+flag+enddate+flag+
	          endtime+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+tempdocids+flag+
	          remark+flag+status+flag+relatedacc+flag+projectIDs+flag+creater;
		 rst.executeProc("cowork_items_insert",Proc);
		 
		//获取当前协作id
		 while(rst.next()){
		     id = rst.getString(1);
		 }
		 rst.commit();
	}catch(Exception e){
		rst.rollback();
		e.printStackTrace();
	}
	//判断协作是否创建成功不为空表示创建成功
	if(!id.equals("")){
	
		//添加协作参与人共享表	     
	    csm.addShare(id,creater,principal,fu);
		
	    //附件共享
	    if(!"".equals(relatedacc)){
	       csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal);
	    }
		
		//将创建者添加到已读
		RecordSet.execute("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
		
		//log here 1-new;2-view;3-edit  协作创建日志
		String ProcPara = id+flag+"1"+flag+createdate+flag+createtime+flag+userId+flag+fu.getRemoteAddr();
		RecordSet.executeProc("cowork_log_insert",ProcPara);
		
		//协作提醒
		//List parterList=csm.getShareList("parter",id);
		//for(int i=0;i<parterList.size();i++){
		//    if(((String)parterList.get(i)).equals(userId)) continue;
	    //      PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue((String)parterList.get(i)),9,"0",Util.getIntValue(id));	
		//}
		response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
  }else
	response.sendRedirect("/cowork/AddCoWork.jsp?from="+from+"&message=error"); //协作创建失败，返回协作创建页面
}
else if(operation.equals("addtoplan")) //添加日程
//添加到日程安排
{
	ConnStatement statement = new ConnStatement();
	String sqlselect = "SELECT * FROM CoWork_Items WHERE id = " + id;
	try 
	{
		statement.setStatementSql(sqlselect);
		statement.executeQuery();
		if(statement.next())
		{
			name = statement.getString("name");
			typeid = statement.getString("typeid");
			levelvalue = statement.getString("levelvalue");
			creater = statement.getString("creater");
			
			begindate = statement.getString("begindate");
			beingtime = statement.getString("beingtime");
			enddate = statement.getString("enddate");
			endtime = statement.getString("endtime");
			relatedprj = statement.getString("relatedprj");
			relatedcus = statement.getString("relatedcus");
			relatedwf = statement.getString("relatedwf");
			relateddoc = statement.getString("relateddoc");
			remark = statement.getString("remark");
		}
	}
	finally
	{
		statement.close();
	}
	
    WorkPlanHandler workPlanHandler = new WorkPlanHandler();
    WorkPlanLogMan logMan = new WorkPlanLogMan();
    
    String[] logParams;
    WorkPlan workPlan = new WorkPlan();

    workPlan.setCreaterId(user.getUID());
    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_Plan));        
    workPlan.setWorkPlanName(name);    
    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
    
    //协作参与人
    List parterList=csm.getShareList("parter",id);
    
    String resourceids="";
    for(int i=0;i<parterList.size();i++){
        resourceids=resourceids+(String)parterList.get(i)+",";
    }
    workPlan.setResourceId(resourceids);
    workPlan.setBeginDate(begindate);

    if(null != beingtime && !"".equals(beingtime.trim()))
    {
        workPlan.setBeginTime(beingtime);  //开始时间
    }
    else
    {
        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
    }	    
    workPlan.setEndDate(enddate);
    if(null != enddate && !"".equals(enddate.trim()) && (null == endtime || "".equals(endtime.trim())))
    {
        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
    }
    else
    {
        workPlan.setEndTime(endtime);  //结束时间
    }
    
    String workPlanDescription = Util.null2String(remark);
    workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
    workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
    workPlan.setDescription(workPlanDescription);
    
    workPlan.setCustomer(relatedcus);
    String docIds ="";
    ArrayList relatedDocs = Util.TokenizerString(relateddoc, ",");
    for(int i=0;i<relatedDocs.size();i++)
    {
        String tempDocId = (String)relatedDocs.get(i);
        int flagIndex = tempDocId.indexOf("|");
        if(flagIndex!=-1)
        {
            if(i!=relatedDocs.size())
            {
                docIds+=tempDocId.substring(0,flagIndex)+",";
            }
            else
            {
                docIds+=tempDocId.substring(0,flagIndex);
            }
        }
        else
        {
            if(i!=relatedDocs.size())
            {
                docIds+=tempDocId+",";
            }
            else
            {
                docIds+=tempDocId;
            }
        }
    }
    workPlan.setDocument(docIds);
    workPlan.setProject(CoworkDao.getAllProjsByTaskIds(relatedprj));
    workPlan.setWorkflow(relatedwf);
    workPlan.setTask(relatedprj);

    workPlanService.insertWorkPlan(workPlan);  //插入日程

	logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, ""+userId, request.getRemoteAddr()};
	logMan.writeViewLog(logParams);

	//response.sendRedirect("/cowork/ViewCoWork.jsp?needfresh=2&id=" + id);
}
else if(operation.equals("edit")){ //编辑协作
	String oldcoworkers = ","+Util.fromScreen(fu.getParameter("oldcoworkers"),user.getLanguage())+",";
	if(name.equals("") ||begindate.equals("")  || enddate.equals("") ){
		response.sendRedirect("/cowork/EditCoWork.jsp?id="+id);
		return;
	}
	String tempdocids = "";
	ArrayList docids = new ArrayList();
	docids = Util.TokenizerString(relateddoc,",");//多个doc
	for(int i=0;i<docids.size();i++){
		tempdocids =tempdocids+docids.get(i).toString()+"|"+userId+",";
	}
   
   String delrelatedacc =Util.fromScreen(fu.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
   
   String newrelatedacc =Util.fromScreen(fu.getParameter("newrelatedacc"),user.getLanguage());  //新添加相关附件id
   
   String isChangeCoworker =Util.fromScreen(fu.getParameter("isChangeCoworker"),user.getLanguage());  //是否改变了协作参与者
   
   relatedacc=relatedacc+newrelatedacc;//新附件id
   
   if(isChangeCoworker.equals("1")){
	   //csm.deleteShare(id); //删除原有参与条件
	   csm.addShare(id,creater,principal,fu);//添加的新的参与条件
	   CoworkDAO dao = new CoworkDAO(Integer.parseInt(id));
	   ArrayList accList=dao.getRelatedAccs();//获得该协作的所有附件id
	   String accStr=accList.toString();
	   accStr=accStr.substring(1,accStr.length()-1);
	   accStr=accStr+","+newrelatedacc;
	   csm.addCoworkDocShare(userId,accStr,typeid,id,principal);//添加新的附件权限
   }else{
	   if(!"".equals(relatedacc))
          csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal);
   }
  
   //删除相关附件
   if(!"".equals(delrelatedacc)) 
      RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
   
   //更新协作
   // String sql = "update cowork_items set name='"+name+"',typeid="+typeid+",levelvalue="+levelvalue+","+
   //	    	"begindate='"+begindate+"',beingtime='"+beingtime+"',enddate='"+enddate+"',endtime='"+endtime+"',"+"relatedprj='"+relatedprj+
   //		    	"',relatedcus='"+relatedcus+"',relatedwf='"+relatedwf+"',relateddoc='"+tempdocids+"',mutil_prjs='"+projectIDs+"',remark='"+remark+
   //		    	"',principal="+principal+",accessory='"+relatedacc+"' where id="+id;
   
   //RecordSet.execute(sql);
   
   Proc=id+flag+name+flag+typeid+flag+levelvalue+flag+principal+flag+
        projectIDs+flag+begindate+flag+beingtime+flag+enddate+flag+endtime+flag+
        relatedprj+flag+relatedcus+flag+relatedwf+flag+tempdocids+flag+remark+flag+
        relatedacc;
   RecordSet.executeProc("cowork_items_update",Proc);     
        
   
   
	//将当前操作者者添加到已读者中
	RecordSet.executeSql("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
	
	//log here 1-new;2-view;3-edit
	String ProcPara = ""+id+flag+"3"+flag+createdate+flag+createtime+flag+userId+flag+fu.getRemoteAddr();
	RecordSet.executeProc("cowork_log_insert",ProcPara);
	
	response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
}else if(operation.equals("doremark")){ //回复讨论
	
	if(!"".equals(relatedacc)){
	   csm.addCoworkDocShare(userId,relatedacc,typeid,id,principal); //添加附件共享
	}
    
    int replayid=Util.getIntValue(fu.getParameter("replayid"),0);
    
    //获取当前最大楼数
    String sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
    RecordSet.execute(sql);
    if(RecordSet.next())
    	floorNum=RecordSet.getInt("floorNum");
    if(floorNum==-1)
		floorNum=0;
    floorNum=floorNum+1;
	
    //添加讨论
	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+relatedprj+flag+relatedcus+flag+relatedwf+flag+relateddoc+flag+relatedacc+flag+projectIDs+flag+floorNum+flag+replayid;
	
    RecordSet.executeProc("cowork_discuss_insert",Proc);
	
	//协作提醒
	//List parterList=csm.getShareList("parter",id);
	//for(int i=0;i<parterList.size();i++){
	//    if(((String)parterList.get(i)).equals(userId)) continue;
    //    PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue((String)parterList.get(i)),9,"0",Util.getIntValue(id));	
	//}
	
	//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的意境查看者
	sql="delete from cowork_read where coworkid="+id;
	RecordSet.executeSql(sql);
	
	//将当前回复者添加到已读者中
	sql="insert into cowork_read(coworkid,userid) values("+id+","+userId+")";
	RecordSet.executeSql(sql);
	
	if(disType.equals("tree")&&replayid!=0){
		sql="select max(id) as max_id from cowork_discuss where coworkid="+id+" and replayid="+replayid+" and discussant="+userId;
		
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		   out.println(RecordSet.getString("max_id"));
		}
	}
}else if(operation.equals("end")){ //关闭协作
	
    //获取当前最大楼数
    String sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
    RecordSet.execute(sql);
    if(RecordSet.next())
    	floorNum=RecordSet.getInt("floorNum");
    if(floorNum==-1)
		floorNum=0;
    floorNum=floorNum+1;

 	remark = SystemEnv.getHtmlLabelName(19076,user.getLanguage());
 	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+floorNum+flag+"0";
	RecordSet.executeProc("cowork_discuss_insert",Proc);
	
	//协作提醒
	//List parterList=csm.getShareList("parter",id);
	//for(int i=0;i<parterList.size();i++){
	//    if(((String)parterList.get(i)).equals(userId)) continue;
    //    PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue((String)parterList.get(i)),9,"0",Util.getIntValue(id));	
	//}
		
	String sqlupdate = " update cowork_items set status=2 where id = "+id;

	RecordSet.executeSql(sqlupdate);
	
	response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id=0");
}else if(operation.equals("open")){ //打开协作

    //获取当前最大楼数
    String sql="select max(floorNum) as floorNum  from cowork_discuss where coworkid="+id;
    RecordSet.execute(sql);
    if(RecordSet.next())
    	floorNum=RecordSet.getInt("floorNum");
    if(floorNum==-1)
		floorNum=0;
    floorNum=floorNum+1;
	
 	remark = SystemEnv.getHtmlLabelName(19077,user.getLanguage());
 	Proc=id+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+floorNum+flag+"0";
 	RecordSet.executeProc("cowork_discuss_insert",Proc);

	String sqlupdate = " update cowork_items set status=1 where id = "+id;
	RecordSet.executeSql(sqlupdate);
	
	response.sendRedirect("/cowork/ViewCoWork.jsp?from="+from+"&needfresh=1&id="+id);
}else if(operation.equals("editdiscuss")){   //编辑评论
	String discussid=fu.getParameter("discussid"); //讨论记录id
	
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date nowdate=new Date();
	boolean result=true;
	long timePass=100L;
	
	CoworkDiscussVO vo2=(CoworkDiscussVO)CoworkDao.getCoworkDiscussVO(discussid);
	String coworkid=vo2.getCoworkid();
	String discussant = Util.null2String(vo2.getDiscussant());
	
	createdate = Util.null2String(vo2.getCreatedate());
	createtime = Util.null2String(vo2.getCreatetime());
	
	String maxdiscussid=CoworkDao.getMaxDiscussid(""+coworkid);//最大讨论记录id
	
	String dateStr="";
	if(createtime.length()==5)
		dateStr=createdate+" "+createtime+":00";
	else
		dateStr=createdate+" "+createtime;
	Date discussDate=dateFormat.parse(dateStr);  //回复时间
	timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
    if(!maxdiscussid.equals(discussid)){
		out.println("1");
	    result=false;
	}else if(timePass>10){
		out.println("2");
	    result=false;
	}
    if(result){
	String edit_relatedprj = Util.fromScreen(fu.getParameter("edit_relatedprj"),user.getLanguage());  //相关项目任务
	String edit_relatedcus = Util.fromScreen(fu.getParameter("edit_relatedcus"),user.getLanguage());  //相关客户
	String edit_relatedwf = Util.fromScreen(fu.getParameter("edit_relatedwf"),user.getLanguage());    //相关流程
	String edit_relateddoc = Util.fromScreen(fu.getParameter("edit_relateddoc"),user.getLanguage());  //相关文档
	if(edit_relateddoc.equals("0")) relateddoc="";
	
	//String edit_remark = Util.null2String(fu.getParameter("edit_remark"));                            //评论   
	String edit_remark = Util.null2String(fu.getParameter("remark"));

	String edit_projectIDs = Util.null2String(fu.getParameter("edit_projectIDs"));                    //相关任务
	
    String edit_relatedacc=Util.null2String(fu.getParameter("edit_relatedacc"));                      //相关附件
    
	String delrelatedacc=Util.null2String(fu.getParameter("delrelatedacc"));                          //需要删除的相关附件  
	
	String newrelatedacc=Util.null2String(fu.getParameter("newrelatedacc"));                          //新上传的相关附件
	
	//删除需要删除的附件
	if(!delrelatedacc.equals(""))
	    RecordSet.executeSql("delete DocDetail where id in(" + delrelatedacc+")");
	
	
	//新添加附件共享
    if(!"".equals(newrelatedacc)){
       csm.addCoworkDocShare(userId,newrelatedacc,typeid,id,principal);
    }
    //新附件id
    edit_relatedacc=edit_relatedacc+newrelatedacc;
	
	String sql="update cowork_discuss set createdate=?, createtime=?,remark=?"+
			    ",relatedprj=?,relatedcus=?,relatedwf=?"+
			    ",relateddoc=?,ralatedaccessory=?,mutil_prjs=? where id=?";
	cs.setStatementSql(sql);
	cs.setString(1,createdate);
	cs.setString(2,createtime);
	cs.setString(3,edit_remark);
	cs.setString(4,edit_relatedprj);
	cs.setString(5,edit_relatedcus);
	cs.setString(6,edit_relatedwf);
	cs.setString(7,edit_relateddoc);
	cs.setString(8,edit_relatedacc);
	cs.setString(9,edit_projectIDs);
	cs.setString(10,discussid);
	
	cs.executeUpdate();
	cs.close();
		
	//所有看过协作的参与者，都会记录到cowork_read，协作更新后就要删除cowork_read中的意境查看者
	RecordSet.executeSql("delete from cowork_read where coworkid="+id);
	
	//将当前操作者者添加到已读者中
	RecordSet.executeSql("insert into cowork_read(coworkid,userid) values("+id+","+userId+")");
    }
}else if(operation.equals("delete")){  //删除讨论记录
	
	String discussid=Util.fromScreen(fu.getParameter("discussid"),user.getLanguage());
	
	CoworkDAO dao=new CoworkDAO();
    CoworkDiscussVO vo2=(CoworkDiscussVO)dao.getCoworkDiscussVO(discussid);
	String coworkid=vo2.getCoworkid();
	String discussant = Util.null2String(vo2.getDiscussant());
		
	createdate = Util.null2String(vo2.getCreatedate());
	createtime = Util.null2String(vo2.getCreatetime());
		
	String maxdiscussid=dao.getMaxDiscussid(""+coworkid);//最大讨论记录id
        
	Date nowdate=new Date();
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	boolean result=true;
	long timePass=100L;
		
	String dateStr="";
	if(createtime.length()==5)
		dateStr=createdate+" "+createtime+":00";
	else
		dateStr=createdate+" "+createtime;
	Date discussDate=dateFormat.parse(dateStr);  //回复时间
	timePass=(nowdate.getTime()-discussDate.getTime())/(60*1000);
	
	if(!discussant.equals(userId))
		result=false;
	if(!maxdiscussid.equals(discussid)){
		out.println("1");
		result=false;
    }else if(timePass>10){
		out.println("2");
		result=false;
	}	
	if(result){
       String sql="delete from cowork_discuss where id="+discussid;
	   RecordSet.execute(sql);
	   out.println("0");
    }
}else if(operation.equals("showHead")){
	String isCoworkHead=fu.getParameter("isCoworkHead");
	HrmUserSettingComInfo settingComInfo=new HrmUserSettingComInfo();
	String hrmSettingid=settingComInfo.getId(userId);
	if(hrmSettingid.equals("")){
		RecordSet.execute("insert into HrmUserSetting(resourceid,rtxOnload,isCoworkHead,skin,cutoverWay,transitionTime,transitionWay) values("+userId+",0,1,'','','','')");
		settingComInfo.removeHrmUserSettingComInfoCache();
		settingComInfo=new HrmUserSettingComInfo();
		hrmSettingid =settingComInfo.getId(userId);
	}
	RecordSet.execute("update HrmUserSetting set isCoworkHead="+isCoworkHead+" where id="+hrmSettingid);
	settingComInfo.removeHrmUserSettingComInfoCache();
}
%>
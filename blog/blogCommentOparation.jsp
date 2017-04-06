<%@page import="weaver.general.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=GBK"pageEncoding="GBK"%>
<%@ page import="weaver.conn.*" %>
<%@page import="java.util.HashMap"%> 
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	request.setCharacterEncoding("UTF-8");
	HashMap result=new HashMap();
	if(user==null){
    	result.put("status","2"); //超时
    	JSONObject json=JSONObject.fromObject(result);
		out.println(json);
		return ;
    }
	Date today=new Date();
	String userid=""+user.getUID();
	String curDate=new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
	String curTime=new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
	
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");
	
	String content=Util.null2String(request.getParameter("content"));//日志内容
	String discussid=Util.null2String(request.getParameter("discussid"));//被评论的日志id
	String replyid=Util.null2String(request.getParameter("replyid"));//被评论的评论的id
	String tempreplyid=Util.null2String(request.getParameter("replyid")); //被评论的评论的id
	
	String relatedid=Util.null2String(request.getParameter("relatedid")); //评论中相关人id
	
	String commentType=Util.null2String(request.getParameter("commentType"));//被评论的日志id
	String workdate=Util.null2String(request.getParameter("workdate"));//被评论的评论的id
	String bediscussantid=Util.null2String(request.getParameter("bediscussantid"));//被评论的评论的id

	String action=Util.null2String(request.getParameter("action")).trim();
	
	HashMap backData=new HashMap();
	ArrayList array=new ArrayList();
	String remindSql="";
	if("add".equals(action)){
	 try{
		String sql="insert into blog_reply (userid, discussid, createdate, createtime, content,comefrom,workdate,bediscussantid,commentType,relatedid)"+
			"VALUES (?, ?,?,?,?,?,?,?,?,?)";
		cs.setStatementSql(sql);
		cs.setString(1,""+userid);
		cs.setString(2,""+discussid);
		cs.setString(3,""+curDate);
		cs.setString(4,""+curTime);
		cs.setString(5,""+content);
		cs.setString(6,"0");
		cs.setString(7,""+workdate);
		cs.setString(8,""+bediscussantid);
		cs.setString(9,""+commentType);
		cs.setString(10,""+relatedid);
		if(cs.executeUpdate()>0){ 
			cs.close();
			sql="select max(id) maxid from blog_reply where userid="+userid;
			rs.execute(sql);
			rs.next();
			replyid=rs.getString("maxid");
			result.put("status","1");
			backData.put("id",replyid);
			backData.put("discussid",discussid);
			backData.put("createDate",curDate);
			backData.put("createTime",curTime);
			backData.put("createTime",curTime);
			
			String createdatetime=dateFormat3.format(dateFormat.parse(curDate+" "+curTime));
			backData.put("createdatetime",createdatetime);
			
			backData.put("userid",new Integer(user.getUID()));
			backData.put("username",user.getLastname());
			
			backData.put("commentType",commentType);
			
			result.put("backdata",backData);
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
		}else{
			result.put("status","0");
			result.put("backdata","内部错误");
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
		}
		}catch(Exception e){}
		finally{
			cs.close();
		}
		BlogDao blogdao=new BlogDao();
		if(!"0".equals(tempreplyid)){
			
			if(!bediscussantid.equals(userid))
				blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
			
			if(!relatedid.equals(userid)&&!bediscussantid.equals(relatedid))
			    blogdao.addRemind(relatedid,userid,"9",discussid+"|"+tempreplyid+"|"+replyid,"0");
		}else{ 
			
			if(!bediscussantid.equals(userid))
				   blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
		}
	}else if("del".equals(action)){
		replyid=Util.null2String(request.getParameter("replyid"));    //评论的id
		String sql="select * from blog_reply where id='"+replyid+"' and discussid="+discussid;
		RecordSet recordSet=new RecordSet();
		recordSet.execute(sql);
		recordSet.next();
		String discussant=recordSet.getString("userid");
		String createdate=recordSet.getString("createdate");
		String createtime=recordSet.getString("createtime");
		
		Date nowdate=new Date();
		long sepratorTime=(nowdate.getTime()-dateFormat.parse(createdate+" "+createtime).getTime())/(1000*60);
		
		sql="select max(id) maxid from blog_reply where discussid="+discussid;
		recordSet.execute(sql);
		String maxReplayid="0";
		if(recordSet.next())
			maxReplayid=recordSet.getString("maxid");
		
		boolean flag=true;
		String status="1";
		if(!userid.equals(discussant))
			flag=false;
		else if(!replyid.equals(maxReplayid)){
			status="-1";
			flag=false;
		}else if(sepratorTime>10){
			status="-2";
			flag=false;
		}
			
        if(flag){
        	//删除评论
        	sql="delete from blog_reply where id="+replyid;
        	recordSet.execute(sql);
        	//删除评论提醒
        	sql="delete from blog_remind where relatedid="+userid+" and remindType=9 and remindValue like '"+discussid+"|%%|"+replyid+"'";
        	recordSet.execute(sql);
        }
        
		result.put("status",status);
		JSONObject json=JSONObject.fromObject(result);
		out.println(json);
		
	}else{
		result.put("status","-4");
		result.put("backdata","未知操作");
		JSONObject json=JSONObject.fromObject(result);
		out.println(json);
	}
%>
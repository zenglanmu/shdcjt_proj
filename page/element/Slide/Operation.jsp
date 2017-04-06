<%@ include file="/page/element/operationCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	
     String 	slide_AutoChangeTime=request.getParameter("slide_t_AutoChangeTime");
     String 	slide_changeStyle=request.getParameter("slide_t_changeStyle");
     String 	slide_changeTime=request.getParameter("slide_t_changeTime");
     String 	slide_changeStyleBar=request.getParameter("slide_t_changeStyleBar");
     String 	slide_position=request.getParameter("slide_t_position");
     String strSettingSql = "select count(*) maxId from slideElement " ;
     rs_Setting.execute(strSettingSql);
	int maxid=0;
	if (rs_Setting.next())
	{
		maxid = rs_Setting.getInt("maxId");
	}
	maxid++;
		
     ArrayList nameList=new ArrayList();
     ArrayList valueList=new ArrayList();
     nameList.add("slide_t_AutoChangeTime");
     nameList.add("slide_t_changeStyle");
     nameList.add("slide_t_changeTime");
     nameList.add("slide_t_changeStyleBar");
     nameList.add("slide_t_position");
     
     valueList.add(slide_AutoChangeTime);
     valueList.add(slide_changeStyle);
     valueList.add(slide_changeTime);
     valueList.add(slide_changeStyleBar);
     valueList.add(slide_position);
	
     String sql1="delete from hpelementsetting where eid="+eid;
	 System.out.println(sql1);
     rs_Setting.execute(sql1);
     String sql2="";
	 try{
 	for(int i=0;i<nameList.size();i++){
    	sql2=" insert into hpelementsetting(id,eid,name,value) values("+(maxid+1)+","+eid+",'"+nameList.get(i)+"','"+valueList.get(i)+"')";
		System.out.println(sql2);
		 rs_Setting.execute(sql2);
 	}
	}catch(Exception e){
		System.out.println(e);
	}
     
%>
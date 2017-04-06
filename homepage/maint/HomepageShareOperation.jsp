<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
 <jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageCominfo" scope="page" />
 <jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 <jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
 <jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	String method = Util.null2String(request.getParameter("method"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

	/*
	 权限判断
	*/
  
   boolean canEdit=false;
   boolean isDetachable=hpu.isDetachable(request);
   int operatelevel=0;

   if(isDetachable){
	   operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
	   if(subCompanyId==-1) operatelevel=2;
   }else{
		if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
   }  
   if(operatelevel>0) canEdit=true;
   if(!(user.getLogintype()).equals("1")) canEdit=false;

   if(!canEdit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
   }


	
	String strSql="";
	if(method.equals("addMutil")){
        String[] shareValues = request.getParameterValues("txtShareDetail"); 
        if (shareValues!=null) {       
			String sharetype="1";
			String content="1";
            for (int i=0;i<shareValues.length;i++){               
                //out.println(shareValues[i]+"<br>");
                String[] paras = Util.TokenizerString2(shareValues[i],"_");
                sharetype = paras[0];
				
                if(sharetype.equals("5")) content = "1" ;
               
                if ("1".equals(sharetype)||"2".equals(sharetype)||"3".equals(sharetype)){  //1:多人力资源 2:多分部    3:多部门  
                    String tempStrs[]=Util.TokenizerString2(paras[1],",");
                    for(int k=0;k<tempStrs.length;k++){
                        strSql="insert into shareinnerhp (hpid,type,content) values ("+hpid+","+sharetype+","+tempStrs[k]+")";
						rs.executeSql(strSql);
                    }                       
                } else {    
					strSql="insert into shareinnerhp (hpid,type,content) values ("+hpid+","+sharetype+","+content+")";
                    rs.executeSql(strSql);
                }
            }
        }
        response.sendRedirect("HomepageShare.jsp?hpid="+hpid);
       return;
} else if(method.equals("delMShare")) {    
    String[] delShareIds = request.getParameterValues("chkShareId");
    if (delShareIds!=null) {
        for (int i=0;i<delShareIds.length;i++){
            String delShareId = delShareIds[i];
            rs.executeSql("delete shareinnerhp where id="+delShareId);
        }
    }
    response.sendRedirect("HomepageShare.jsp?hpid="+hpid);
	return;
}
%>
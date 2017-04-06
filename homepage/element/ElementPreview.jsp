<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>  
<jsp:useBean id="hpsb" class="weaver.homepage.style.HomepageStyleBean" scope="page"/>
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="cscr" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo" scope="page"/>
<jsp:useBean id="eu" class="weaver.page.element.ElementUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<%	
	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String styleid=Util.null2String(request.getParameter("styleid"));
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String layoutflag=Util.null2String(request.getParameter("layoutflag"));
	String addType = Util.null2String(request.getParameter("addType"));
    boolean isSystemer=false;
    //System.out.println(addType);
	//int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
    if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
    
    ArrayList list = pu.getShareMaintListByUser(user.getUID()+"");
    if(list.indexOf(hpid)!=-1){
    	isSystemer=true;
    }
    //if(opreateLevel>0&&subCompanyId!=-1)  isSystemer=true;
	
	int maxEid=0;
	String managerStr="0";
	if(isSystemer)  managerStr="1";

	//求用户的ID与分部ID
	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid =1;
		usertype=0;
	}
 
	//添加元素
	String strSql="insert into hpElement(title,logo,islocked,ebaseid,isSysElement,hpid,styleid,marginTop,shareuser,scrolltype) values('"+ebc.getTitle(ebaseid)+"','"+ebc.getIcon(ebaseid)+"','0','"+ebaseid+"','"+managerStr+"',"+hpid+",'"+pc.getStyleid(hpid)+"','10','5_1','None' )";
	rs.executeSql(strSql);
	//System.out.println(strSql);

	rs.executeSql("select max(id) from hpElement");		
	if(rs.next()){
		maxEid=Util.getIntValue(rs.getString(1));
	}
	//System.out.println(maxEid);
	hpec.addHpElementCache(""+maxEid);

    String strUpdateSql="";
    if("".equals(addType)){
	    if (rs.getDBType().equals("sqlserver"))
	        strUpdateSql="update hplayout set areaElements='"+maxEid+",'+areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
	    else
	        strUpdateSql="update hplayout set areaElements='"+maxEid+",' || areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
    }else{
    	if (rs.getDBType().equals("sqlserver"))
	        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",'+areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
	    else
	        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",' || areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
    }
    
    rs.executeSql(strUpdateSql);
    
    //添加共享信息
	//String strInsertSql="insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) select "+hpid+","+maxEid+","+userid+","+usertype+",perpage,linkmode,'2'  from hpBaseElement where id="+ebaseid;
    //String strInsertSql="insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) select "+hpid+","+maxEid+","+userid+","+usertype+","+5+","+2+",'2'  from hpBaseElement where id="+ebaseid;
	String strInsertSql = "insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) values("+hpid+","+maxEid+","+userid+","+usertype+","+ebc.getPerpage(ebaseid)+","+ebc.getLinkMode(ebaseid)+",'2')";
	//System.out.println(strInsertSql);
	rs.executeSql(strInsertSql);
	 out.println("<STYLE TYPE=\"text/css\">");
	 out.println(pu.getElementCss(hpid,""+maxEid));
	 out.println("</STYLE>");
	 if("".equals(addType)){
		 out.println(eu.getContainer(ebaseid,""+maxEid,hpid,styleid,"0","2",user,subCompanyId,userid,usertype,true));
		 //System.out.println(eu.getContainer(ebaseid,""+maxEid,hpid,styleid,"0","2",user,subCompanyId,userid,usertype,true));
	 }else{
		 out.println(eu.getContainer(ebaseid,""+maxEid,hpec.getStyleid(""+maxEid),user,true));
	 }
%>	
    
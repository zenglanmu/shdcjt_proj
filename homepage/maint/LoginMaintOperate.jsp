<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rslayout" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />

<%
	String method = Util.null2String(request.getParameter("method"));
	String opt = Util.null2String(request.getParameter("opt"));
	int creatorid = user.getUID();
	creatorid = 1;//登陆前页面所有设置操作都等同与管理员
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	/*
	 权限判断
	 */
	if ("save".equals(method))
	{
        String areaResult=Util.null2String(request.getParameter("areaResult"));
        ArrayList resultList=Util.TokenizerString(areaResult,"||");
        for (int i=0;i<resultList.size();i++)
        {
            String result=(String)resultList.get(i);
            String[] paras = Util.TokenizerString2(result,"_");
            String sql="update hpinfo set isuse='"+paras[1]+"',islocked='"+paras[2]+"' where id="+paras[0];
            rs.executeSql(sql);
        }
        pc.reloadHpCache();	
		response.sendRedirect("LoginPageContent.jsp");
	}
	else if ("ref".equals(method))
	{
		String srchpid = Util.null2String(request.getParameter("srchpid"));
		int creatortype = 0;
		//插入主页信息
		rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,creatortype,creatorid,islocked) select '','',styleid,layoutid,-1,'0','" + creatortype + "'," + creatorid + ",1 from hpinfo where id=" + srchpid);
		int maxHpid = hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='" + maxHpid + "' where id=" + maxHpid);

		String strSql = "insert into hplayout (hpid,layoutbaseid,areaflag,areasize,userid,usertype) " + "select  " + maxHpid
				+ ",layoutbaseid,areaflag,areasize," + creatorid + ",0 from hplayout where hpid=" + srchpid + " "
				+ "and userid=" + creatorid + " and usertype=0";

		rs.executeSql(strSql);

		/*插入共享信息*/
		String strShareSql = "insert into shareinnerhp(hpid,type,content,seclevel,sharelevel) values (" + maxHpid + ",2,-1,0,1)";
		rs.executeSql(strShareSql);
		
		response.sendRedirect("/homepage/base/LoginBase.jsp?hpid=" + maxHpid);

	}
	else if ("savestyleid".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleStyleid = Util.null2String(request.getParameter("seleStyleid"));
		rs.executeSql("update hpinfo set styleid='" + seleStyleid + "' where id=" + hpid);
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/style/HomepageStyleList.jsp?hpid=" + hpid + "&seleStyleid=" + seleStyleid);
	}
	else if ("savelayoutid".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleLayoutid = Util.null2String(request.getParameter("seleLayoutid"));
		rs.executeSql("update hpinfo set layoutid=" + seleLayoutid + " where id=" + hpid);
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/layout/HomepageLayoutSele.jsp?hpid=" + hpid + "&seleLayoutid=" + seleLayoutid);
	}
	else if ("savebase".equals(method))
	{
		String onlyOnSave = Util.null2String(request.getParameter("txtOnlyOnSave"));
		String hpid = Util.null2String(request.getParameter("hpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));

		rs.executeSql("update hpinfo set infoname='"+infoname+"',infodesc='"+infodesc+"',styleid='"+styleid+"',layoutid="+layoutid+" where id="+hpid );
		if(pc.isHaveThisHp(hpid))  
			pc.updateHpCache(hpid);
        else 
        	pc.addHpCache(hpid);

		//修改布局信息
		ArrayList dataFlagList=new ArrayList();
		rslayout.executeSql("select areaflag from hplayout where hpid="+hpid+" and userid="+creatorid+" and usertype=0");

		while(rslayout.next()) 
			dataFlagList.add(Util.null2String(rslayout.getString(1)));

		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");

		//先改值
		for(int i=0;i<pageFlagList.size();i++)
		{
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=Util.null2String(request.getParameter("txtArea_"+pageFlag));
			String strSql="";

			if(dataFlagList.contains(pageFlag)) 
			{
                //暂时修改BUG4977               
                strSql="update  hplayout set areasize='"+pageFlagSize+"' where hpid="+hpid+" and areaflag='"+pageFlag+"'";
            } 
			else 
            {
				strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+creatorid+",0)";
			}
			rslayout.executeSql(strSql);
		}
		//再删值

		for(int i=0;i<dataFlagList.size();i++)
		{
			String dataFlag=(String)dataFlagList.get(i);
			String strSql="";

			if(!pageFlagList.contains(dataFlag)) 
			{
				strSql="delete  hplayout  where hpid="+hpid+" and areaflag='"+dataFlag+"' and  userid="+creatorid+" and usertype=0";
			    rslayout.executeSql(strSql);
            }
			
		}
        if("true".equals(onlyOnSave))
        {
    		response.sendRedirect("/homepage/maint/LoginPageContent.jsp?hpid="+hpid);
        } 
        else 
        {
            response.sendRedirect("/homepage/Homepage.jsp?isSetting=true&opt="+opt+"&hpid="+hpid+"&pagetype=loginview");
        }
	}
	else if ("delhp".equals(method))
	{
		String hpid = Util.null2String(request.getParameter("hpid"));
		//如果此首页被指定或被用户选择那么将不能被删除
		rs.executeSql("select * from menucustom where menuhref='/homepage/LoginHomepage.jsp?hpid=" + hpid+"'");
		if (rs.next())
		{
			response.sendRedirect("/homepage/maint/LoginPageContent.jsp?message=noDel");
			return;
		}
		//删除首页信息表
		String strSql = "delete hpinfo where id=" + hpid;
		rs.executeSql(strSql);
		pc.deleteHpCache(hpid);

		//用户选择首页表
		strSql = "delete hpuserselect where infoid=" + hpid;
		rs.executeSql(strSql);

		//布局信息表
		strSql = "delete hpLayout where hpid=" + hpid;
		rs.executeSql(strSql);

		//元素设置明细表
		strSql = "delete hpElementSettingDetail where hpid=" + hpid;
		rs.executeSql(strSql);

		//元素字段字数长度表
		strSql = "select id from  hpElement where hpid=" + hpid;
		rs.executeSql(strSql);
		while (rs.next())
		{
			String tempEid = Util.null2String(rs.getString(1));
			rs1.executeSql("delete hpFieldLength where eid=" + tempEid);
		}

		//元素表
		strSql = "delete  hpElement where hpid=" + hpid;
		rs.executeSql(strSql);

		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if ("synihp".equals(method))
	{
		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
	else if ("tran".equals(method))
	{
		response.sendRedirect("/homepage/maint/LoginPageContent.jsp");
	}
%>
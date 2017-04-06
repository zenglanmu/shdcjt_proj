<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rslayout" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="SpopForHomepage" class="weaver.splitepage.operate.SpopForHomepage" scope="page"/>

<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	String method=Util.null2String(request.getParameter("method"));
	String opt=Util.null2String(request.getParameter("opt"));
	//int rdiInfoAppointId = Util.getIntValue(request.getParameter("rdiInfoAppoint"),-1);
	/*
	 权限判断
	*/
  		
   boolean canEdit=false;
   boolean isDetachable=hpu.isDetachable(request);
   int operatelevel=0;
   ArrayList shareList = hpu.getShareMaintListByUser(user.getUID()+"");
   String areaResult=Util.null2String(request.getParameter("areaResult"));
   ArrayList resultList=Util.TokenizerString(areaResult,"||");
   if(isDetachable){
	   operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
       if(subCompanyId==-1) operatelevel=2;
   }else{
		if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
   }  
   
   if(operatelevel==0&&("save".equals(method)||"synihp".equals(method)||"savebase".equals(method))){
	   
	   if(shareList.indexOf(request.getParameter("hpid"))!=-1){
			 operatelevel=2;
	   }else{
		   int size = resultList.size(); 
		   for (int i=0;i<resultList.size();i++){
	           String result=(String)resultList.get(i);
	           String[] paras = Util.TokenizerString2(result,"_");
	           //if(shareList.indexOf(paras[0])==-1){
	        	//   resultList.remove(i);
	        	   //i--;
	          // }
	       }
		   if(resultList.size()==size){
			   operatelevel=2;
		   }
	   }
   }
   canEdit=true;
   if(!(user.getLogintype()).equals("1")) canEdit=false;

   boolean canPopEdit=false;
   boolean canPopDel=false;
   boolean canPopSetting=false;
   //System.out.println(canEdit);
   if(canEdit){
	    String infoid = Util.null2String(request.getParameter("hpid"));
		ArrayList popeList=SpopForHomepage.getModiDefaultPope(infoid,""+user.getUID(),""+subCompanyId);
		canPopEdit="true".equals((String)popeList.get(0))?true:false;
		canPopDel="true".equals((String)popeList.get(1))?true:false;
		canPopSetting="true".equals((String)popeList.get(3))?true:false;
   } else {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
   }
    String[] isUses =request.getParameterValues("chkUse");
    String[] isLockeds =request.getParameterValues("chkLocked");
    if("save".equals(method)){
		//if(!canPopEdit&&false) {
		//	response.sendRedirect("/notice/noright.jsp") ;
		//	return ;
		//}

        //String areaResult=Util.null2String(request.getParameter("areaResult"));
       // ArrayList resultList=Util.TokenizerString(areaResult,"||");
        for (int i=0;i<resultList.size();i++){
            String result=(String)resultList.get(i);
            String[] paras = Util.TokenizerString2(result,"_");
            String sql="update hpinfo set isuse='"+paras[1]+"',islocked='"+paras[2]+"' where id="+paras[0];
            rs.executeSql(sql);
        }
        pc.reloadHpCache();

//        ArrayList isUseForPageList = new ArrayList();
//        ArrayList isUseForDataList= new ArrayList();
//		String strSql="";
//        if(isUses!=null) for(int i=0;i<isUses.length;i++)  isUseForPageList.add(isUses[i]);
//
//        strSql="select id from hpinfo where subcompanyid="+subCompanyId+" and isUse='1'";
//        rs.executeSql(strSql);
//        while(rs.next()) isUseForDataList.add(Util.null2String(rs.getString(1)));
//
//        //循环页面List如果页面list的数据数据库list中没有则需要修改数据库 isuse=1
//        for (int j=0;j<isUseForPageList.size();j++){
//            String hpidForpage=(String)isUseForPageList.get(j);
//            if(!isUseForDataList.contains(hpidForpage)){
//                rs.executeSql("update hpinfo set isuse='1' where id="+hpidForpage);
//            }
//        }
//        //循环数据库list如果数据库list的数据页面list中没有则需要修改数据库 isuse=0 并且删除相关的用户选择
//        for (int j=0;j<isUseForDataList.size();j++){
//            String hpidFordata=(String)isUseForDataList.get(j);
//            if(!isUseForPageList.contains(hpidFordata)){
//                rs.executeSql("update hpinfo set isuse='0' where id="+hpidFordata);
//                rs.executeSql("delete hpuserselect where infoid="+hpidFordata);
//            }
//        }


		//strSql="delete hpsubcompanyappiont where subcompanyid="+subCompanyId;
		//rs.executeSql(strSql);
		//if(rdiInfoAppointId!=-1) {

			//System.out.println(strSql);
			//strSql="insert into hpsubcompanyappiont (subcompanyid,infoid) values ("+subCompanyId+","+rdiInfoAppointId+")";
			//rs.executeSql(strSql);
			//System.out.println(strSql);getMaxHpinfoid
		//}
	    response.sendRedirect("HomepageRight.jsp?subCompanyId="+subCompanyId);
	} else if("ref".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}


		String srchpid = Util.null2String(request.getParameter("srchpid"));
        int creatorid=subCompanyId;
        int creatortype=3;
        //插入主页信息
        rs.executeSql("insert into hpinfo (infoname,infodesc,styleid,layoutid,subcompanyid,isuse,creatortype,creatorid,menustyleid) select '','',styleid,layoutid,"+subCompanyId+",'0','"+creatortype+"',"+creatorid+", menustyleid from hpinfo where id="+srchpid);
		int maxHpid=hpu.getMaxHpinfoid();
		rs.executeSql("update hpinfo set ordernum='"+maxHpid+"' where id="+maxHpid);

		int srchpCreatorId=Util.getIntValue(pc.getCreatorid(srchpid));
        int srchpCreatorType=Util.getIntValue(pc.getCreatortype(srchpid));

		String strSql="insert into hplayout (hpid,layoutbaseid,areaflag,areasize,userid,usertype) " +
                "select  "+maxHpid+",layoutbaseid,areaflag,areasize,"+creatorid+"," +
                ""+creatortype+" from hplayout where hpid="+srchpid+" " +
                "and userid="+srchpCreatorId+" and usertype="+srchpCreatorType;

		//System.out.println(strSql);

        rs.executeSql(strSql);

        /*插入共享信息*/
		String strShareSql="insert into shareinnerhp(hpid,type,content,seclevel,sharelevel) values ("+maxHpid+",2,"+subCompanyId+",0,1)";
		rs.executeSql(strShareSql);

		//out.println(maxHpid);
        //response.sendRedirect("HomepageConfig.jsp?hpid="+maxHpid);
		response.sendRedirect("/homepage/base/HomepageBase.jsp?subCompanyId="+subCompanyId+"&hpid="+maxHpid);


	}else if("savestyleid".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}



		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleStyleid = Util.null2String(request.getParameter("seleStyleid"));
		String seleMenuStyleid = Util.null2String(request.getParameter("seleMenuStyleid"));
		rs.executeSql("update hpinfo set styleid='"+seleStyleid+"', menustyleid='"+seleMenuStyleid+"' where id="+hpid );
		
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/style/HomepageStyleList.jsp?hpid="+hpid+"&seleStyleid="+seleStyleid);
	}else if("savelayoutid".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}


		String hpid = Util.null2String(request.getParameter("hpid"));
		String seleLayoutid = Util.null2String(request.getParameter("seleLayoutid"));
		rs.executeSql("update hpinfo set layoutid="+seleLayoutid+" where id="+hpid );
		pc.updateHpCache(hpid);
		response.sendRedirect("/homepage/layout/HomepageLayoutSele.jsp?hpid="+hpid+"&seleLayoutid="+seleLayoutid);
	}else if("savebase".equals(method)){

		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}


        String onlyOnSave = Util.null2String(request.getParameter("txtOnlyOnSave"));
		String hpid = Util.null2String(request.getParameter("hpid"));
		String infoname = Util.null2String(request.getParameter("infoname"));
		String infodesc = Util.null2String(request.getParameter("infodesc"));
		String styleid = Util.null2String(request.getParameter("seleStyleid"));
		String layoutid = Util.null2String(request.getParameter("seleLayoutid"));
		String txtLayoutFlag = Util.null2String(request.getParameter("txtLayoutFlag"));
		String menuStyleid = Util.null2String(request.getParameter("seleMenuStyleid"));

		rs.executeSql("select styleid,layoutid,menustyleid from hpinfo where id = "+hpid);
		rs.next();
		String oldstyleid = Util.null2String(rs.getString("styleid"));
		String oldlayoutid = Util.null2String(rs.getString("layoutid"));
		String oldmenuStyleid = Util.null2String(rs.getString("menustyleid"));
		
		if(!oldstyleid.equals(styleid)||!oldlayoutid.equals(layoutid)||!oldmenuStyleid.equals(menuStyleid)){
			rs.executeSql("update hpinfo set infoname='"+infoname+"',infodesc='"+infodesc+"',styleid='"+styleid+"',layoutid="+layoutid+", menustyleid='"+menuStyleid+"' where id="+hpid );
		}else{
			rs.executeSql("update hpinfo set infoname='"+infoname+"',infodesc='"+infodesc+"' where id="+hpid );
		}
		if(!oldstyleid.equals(styleid)){
			rs.executeSql("update hpelement set styleid='"+styleid+"' where hpid="+hpid );
		}
		//System.out.println("update hpelement set styleid='"+styleid+"' where hpid="+hpid );
		hpec.reloadHpElementCache();
		if(pc.isHaveThisHp(hpid))  pc.updateHpCache(hpid);
        else pc.addHpCache(hpid);

		//修改布局信息
		ArrayList dataFlagList=new ArrayList();
		rslayout.executeSql("select areaflag from hplayout where hpid="+hpid+" and userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user));

		while(rslayout.next()) dataFlagList.add(Util.null2String(rslayout.getString(1)));

		ArrayList pageFlagList=Util.TokenizerString(txtLayoutFlag,",");

		//先改值
		for(int i=0;i<pageFlagList.size();i++){
			String pageFlag=(String)pageFlagList.get(i);
			String pageFlagSize=Util.null2String(request.getParameter("txtArea_"+pageFlag));
			String strSql="";

			if(dataFlagList.contains(pageFlag)) {
                //暂时修改BUG4977
                //strSql="update  hplayout set areasize='"+pageFlagSize+"' where hpid="+hpid+" and areaflag='"+pageFlag+"' and  userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user);
                strSql="update  hplayout set areasize='"+pageFlagSize+"' where hpid="+hpid+" and areaflag='"+pageFlag+"'";
            } else {
				strSql="insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+layoutid+",'"+pageFlag+"','"+pageFlagSize+"','',"+hpu.getHpUserId(hpid,""+subCompanyId,user)+","+hpu.getHpUserType(hpid,""+subCompanyId,user)+")";
			}
			rslayout.executeSql(strSql);
		}
		//再删值

		for(int i=0;i<dataFlagList.size();i++){
			String dataFlag=(String)dataFlagList.get(i);
			String strSql="";

			if(!pageFlagList.contains(dataFlag)) {
				strSql="delete  hplayout  where hpid="+hpid+" and areaflag='"+dataFlag+"' and  userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user);
			    rslayout.executeSql(strSql);
            }
			
		}
        if("true".equals(onlyOnSave)){
    		response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+subCompanyId+"&hpid="+hpid);
        } else {
            response.sendRedirect("/homepage/Homepage.jsp?isSetting=true&opt="+opt+"&subCompanyId="+subCompanyId+"&hpid="+hpid);
        }
	}else if("delhp".equals(method)||"suboperdelhp".equals(method)){

		if(!canPopDel) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}



		String hpid = Util.null2String(request.getParameter("hpid"));
		//如果此首页被指定或被用户选择那么将不能被删除
        rs.executeSql("select id from hpuserselect where infoid="+hpid);
        if(rs.next()) {
            response.sendRedirect("/homepage/maint/HomepageRight.jsp?message=noDel&subCompanyId="+subCompanyId);
            return ;
        }

        //rs.executeSql("select id from hpsubcompanyappiont where infoid="+hpid);
        //if(rs.next()){
        //    response.sendRedirect("/homepage/maint/HomepageRight.jsp?message=noDel&subCompanyId="+subCompanyId);
        //    return ;
        //}
		//删除首页信息表
		String strSql="delete hpinfo where id="+hpid;
		rs.executeSql(strSql);
		pc.deleteHpCache(hpid);

		//删除首页分部指定表
		//strSql="delete hpsubcompanyappiont where infoid="+hpid;
		//rs.executeSql(strSql);

		//用户选择首页表
		strSql="delete hpuserselect where infoid="+hpid;
		rs.executeSql(strSql);

		//布局信息表
		strSql="delete hpLayout where hpid="+hpid;
		rs.executeSql(strSql);

		//元素设置明细表
		strSql="delete hpElementSettingDetail where hpid="+hpid;
		rs.executeSql(strSql);

		//元素字段字数长度表
		strSql="select id from  hpElement where hpid="+hpid;
		rs.executeSql(strSql);
		while(rs.next()){
			String tempEid=Util.null2String(rs.getString(1));
			rs1.executeSql("delete hpFieldLength where eid="+tempEid);
		}

		//元素表
		strSql="delete  hpElement where hpid="+hpid;
		rs.executeSql(strSql);
		if("suboperdelhp".equals(method)){
			response.sendRedirect("/homepage/maint/HomepageRight.jsp");
		}else{
			response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+subCompanyId);
		}
	}else if("synihp".equals(method)){
		if(!canPopSetting) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

		String hpid = Util.null2String(request.getParameter("hpid"));
        int nodelUserid=hpu.getHpUserId(hpid,""+subCompanyId,user);
        int nodelUsertype=hpu.getHpUserType(hpid,""+subCompanyId,user);
        String strDel1="delete hpElementSettingDetail where hpid="+hpid+" and not (userid="+nodelUserid+" and usertype="+nodelUsertype+")";
        String strDel2="delete hpLayout where  hpid="+hpid+" and   not (userid="+nodelUserid+" and usertype="+nodelUsertype+")";
        //out.println(strDel1);
        //out.println(strDel2);
        //System.out.println(strDel1);
        //System.out.println(strDel2);

        rs.executeSql(strDel1);
        rs.executeSql(strDel2);

        String strDel3="";
        RecordSet rsElement=new RecordSet();
        rsElement.executeSql("select id from hpelement where hpid="+hpid);
        while(rsElement.next()){
          strDel3="delete hpFieldLength where  eid="+rsElement.getString(1)+" and   not (userid="+nodelUserid+" and usertype="+nodelUsertype+")";
          rs.executeSql(strDel3);
        }

    }else if("synihpnormal".equals(method)){
		String hpid = Util.null2String(request.getParameter("hpid"));
        int nodelUserid=hpu.getHpUserId(hpid,""+subCompanyId,user);
        int nodelUsertype=hpu.getHpUserType(hpid,""+subCompanyId,user);
        String strDel1="delete hpElementSettingDetail where hpid="+hpid+" and userid="+nodelUserid+" and usertype="+nodelUsertype+"";
        String strDel2="delete hpLayout where  hpid="+hpid+" and userid="+nodelUserid+" and usertype="+nodelUsertype+"";
        //System.out.println(strDel1);
       // System.out.println(strDel2);

        rs.executeSql(strDel1);
        rs.executeSql(strDel2);

        String strDel3="";
        RecordSet rsElement=new RecordSet();
        rsElement.executeSql("select id from hpelement where hpid="+hpid);
        while(rsElement.next()){
          strDel3="delete hpFieldLength where  eid="+rsElement.getString(1)+" and  userid="+nodelUserid+" and usertype="+nodelUsertype+"";
          rs.executeSql(strDel3);
        }
    	
    } else if("tran".equals(method)){
		if(!canPopEdit) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		}

		String srcSubid = Util.null2String(request.getParameter("srcSubid"));
		String targetSubid = Util.null2String(request.getParameter("targetSubid"));
		String tranHpid = Util.null2String(request.getParameter("tranHpid"));
		String fromSubid = Util.null2String(request.getParameter("fromSubid"));


		String strSql1="update hpinfo set subcompanyid="+targetSubid+",creatortype=3,creatorid="+targetSubid+" where id="+tranHpid;
        String strSql2="update hplayout set usertype=3,userid="+targetSubid+" where  hpid="+tranHpid+" and usertype=3 and userid="+srcSubid;
        String strSql3="update hpElementSettingDetail set usertype=3,userid="+targetSubid+" where  hpid="+tranHpid+" and usertype=3 and userid="+srcSubid;

		


        //out.println(strSql1);
        //out.println(strSql2);

        rs.executeSql(strSql1);
        rs.executeSql(strSql2);
        rs.executeSql(strSql3);
        
        pc.updateHpCache(tranHpid);



		response.sendRedirect("/homepage/maint/HomepageRight.jsp?subCompanyId="+fromSubid);	

	}else if("delMaint".equals(method)){
		String[] delMaintIds = request.getParameterValues("chkMaintId");
		String hpid = Util.null2String(request.getParameter("hpid"));
		
		String maintainer = pc.getMaintainer(hpid);
		ArrayList maintainerList = Util.TokenizerString(maintainer,",");
		
	    if (delMaintIds!=null) {
	        for (int i=0;i<delMaintIds.length;i++){
	            String delMaintId = delMaintIds[i];
	            int index = maintainerList.indexOf(delMaintId);
	            maintainerList.remove(index);
	        }
	        maintainer="";
	        for(int i=0;i<maintainerList.size();i++){
	        	maintainer+=maintainerList.get(i)+",";
	        }
	        maintainer = maintainer.length()<=0?"":maintainer.substring(0,maintainer.length()-1);            //屏蔽maintainer为空值   TD20705
	        rs.execute("update hpinfo set maintainer ='"+maintainer+"' where id="+hpid);
	        pc.updateHpCache(hpid);
	    }
	    response.sendRedirect("HomepageMaint.jsp?hpid="+hpid);
		return;
	}else if("addMaint".equals(method)){
		String[] addMaintIds = request.getParameterValues("txtMaintDetail"); 
		String hpid = Util.null2String(request.getParameter("hpid"));
		String maintainer = pc.getMaintainer(hpid);
		ArrayList maintainerList = Util.TokenizerString(maintainer,",");
	
        if (addMaintIds!=null) {       

			String  strSql="";
            for (int i=0;i<addMaintIds.length;i++){      

	            String tempStrs[]=Util.TokenizerString2(addMaintIds[i],",");
	            for(int k=0;k<tempStrs.length;k++){
	         	  if(maintainerList.indexOf(tempStrs[k])==-1){
	         		  maintainerList.add(tempStrs[k]);
	         	  }
	            }                       
	       
            }
            maintainer="";
	        for(int i=0;i<maintainerList.size();i++){
	        	maintainer+=maintainerList.get(i)+",";
	        }
	        maintainer = maintainer.substring(0,maintainer.length()-1);
	        rs.execute("update hpinfo set maintainer ='"+maintainer+"' where id="+hpid);
	        pc.updateHpCache(hpid);
	        
        }
        response.sendRedirect("HomepageMaint.jsp?hpid="+hpid);
		return;
	}
%>

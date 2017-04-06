<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>

<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpefc" class="weaver.homepage.cominfo.HomepageElementFieldCominfo" scope="page"/>
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page"/>
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />

<jsp:useBean id="rsCommon" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	 /*
	 基本信息
	 --------------------------------------
	 hpid:表首页ID
	 subCompanyId:首页所属分部的分部ID
	 eid:元素ID
	 ebaseid:基本元素ID
	 styleid:样式ID
	 
	 条件信息
	 --------------------------------------
	 String strsqlwhere 格式为 条件1^,^条件2...
	 int perpage  显示页数
	 String linkmode 查看方式  1:当前页 2:弹出页

	 
	 字段信息
	 --------------------------------------
	 fieldIdList
	 fieldColumnList
	 fieldIsDate
	 fieldTransMethodList
	 fieldWidthList
	 linkurlList
	 valuecolumnList
	 isLimitLengthList

	 样式信息
	 ----------------------------------------
	 String hpsb.getEsymbol() 列首图标
	 String hpsb.getEsparatorimg()   行分隔线 
	 */
%>
<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request
			.getParameter("subCompanyId"), -1);
	String eid = Util.null2String(request.getParameter("eid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String styleid = Util.null2String(request.getParameter("styleid"));
	int perpage = 0;
	int userid = pu.getHpUserId(hpid, "" + subCompanyId, user);
	int usertype = pu.getHpUserType(hpid, "" + subCompanyId, user);
	//判断当前用户是否有权限查看该元素
	
	boolean hasRight =true;
	User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	// 先取消权限判断
	if(loginuser != null)  {
		hasRight =  ec.isHasRight(eid,loginuser.getUID()+"");
	}
	if(!hasRight){
		response.sendRedirect("/page/element/noright.jsp");
	}
	//HomepageStyleBean hpsb = hpsu.getHpsb(styleid);

	//得到需要显示的字段
	ArrayList fieldIdList = new ArrayList();
	ArrayList fieldColumnList = new ArrayList();
	ArrayList fieldIsDate = new ArrayList();
	ArrayList fieldTransMethodList = new ArrayList();
	ArrayList fieldWidthList = new ArrayList();
	ArrayList linkurlList = new ArrayList();
	ArrayList valuecolumnList = new ArrayList();
	ArrayList isLimitLengthList = new ArrayList();

	
	rsCommon.executeSql("select 1 from hpinfo where id="+hpid+" and isLocked=1");
	if (rsCommon.next()) {
		rsCommon.executeSql("select creatorid,creatortype from hpinfo where id="+hpid);
		if(rsCommon.next())
		{
			userid =Util.getIntValue(rsCommon.getString("creatorid"));
			usertype = Util.getIntValue(rsCommon.getString("creatortype"));
		}
	}

	String fields = "";
	String linkmode = "";
	String currenttab="";

	String strsqlwhere = hpec.getStrsqlwhere(eid);

	String strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid="
			+ eid
			+ " and userid="
			+ userid
			+ " and usertype="
			+ usertype;
	rsCommon.executeSql(strSql);
	if (rsCommon.next()) {
		fields = Util.null2String(rsCommon.getString("showfield"));
		perpage = Util.getIntValue(rsCommon.getString("perpage"));
		linkmode = Util.null2String(rsCommon.getString("linkmode"));
	}
	rsCommon.execute("select currenttab from hpcurrenttab where eid="+eid
			+ " and userid="
			+ user.getUID()
			+ " and usertype="
			+ user.getType());
	if(rsCommon.next()){
		currenttab = Util.null2String(rsCommon.getString("currenttab"));
	}else{
		rsCommon.execute("insert into hpcurrenttab (currenttab,eid,userid,usertype) values ( null,"+eid+","+user.getUID()+","+user.getType()+")");
	}
	if (!"".equals(fields)) {
		ArrayList tempFieldList = Util.TokenizerString(fields, ",");
		for (int i = 0; i < tempFieldList.size(); i++) {
			String tempId = (String) tempFieldList.get(i);
			fieldIdList.add(tempId);
			fieldColumnList.add(hpefc.getFieldcolumn(tempId));
			fieldIsDate.add(hpefc.getIsdate(tempId));
			fieldTransMethodList.add(hpefc.getTransmethod(tempId));
			fieldWidthList.add(hpefc.getFieldWidth(tempId));
			linkurlList.add(hpefc.getLinkurl(tempId));
			valuecolumnList.add(hpefc.getValuecolumn(tempId));
			isLimitLengthList.add(hpefc.getIsLimitLength(tempId));
		}
	}
	String isFixationRowHeight="0";
	String background="";
	strSql = "select isFixationRowHeight,background from hpelement where id="+ eid;
	rsCommon.executeSql(strSql);
	if (rsCommon.next()) {
		isFixationRowHeight = Util.null2String(rsCommon.getString("isFixationRowHeight"));
		background = Util.null2String(rsCommon.getString("background"));
	}
	
	String eStyleid=hpec.getStyleid(eid);
%>
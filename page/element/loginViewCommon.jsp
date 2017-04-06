<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean"%>

<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo"
	scope="page" />
<jsp:useBean id="hpec"
	class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="hpefc"
	class="weaver.homepage.cominfo.HomepageElementFieldCominfo"
	scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil"
	scope="page" />
<jsp:useBean id="rsCommon" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ebc" class="weaver.page.element.ElementBaseCominfo"
	scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"
	scope="page" />
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow"
	scope="page" />	
<jsp:useBean id="ec" class="weaver.page.element.ElementUtil" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>
<%@ include file="/page/maint/common/initLoginNoCache.jsp"%>
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
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
	String eid = Util.null2String(request.getParameter("eid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String styleid = Util.null2String(request.getParameter("styleid"));
	String ePath = ebc.getPath(ebaseid);
	//HomepageStyleBean hpsb = hpsu.getHpsb(styleid);

	//判断当前用户是否有权限查看该元素
	
	boolean hasRight =true;
	User loginuser = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	// 先取消权限判断
	if(loginuser != null)  {
		System.out.println("eid:"+eid);
		hasRight =  ec.isHasRight(eid,loginuser.getUID()+"");
	}
	if(!hasRight){
		response.sendRedirect("/page/element/noright.jsp");
	}
	//得到需要显示的字段
	ArrayList fieldIdList = new ArrayList();
	ArrayList fieldColumnList = new ArrayList();
	ArrayList fieldIsDate = new ArrayList();
	ArrayList fieldTransMethodList = new ArrayList();
	ArrayList fieldWidthList = new ArrayList();
	ArrayList linkurlList = new ArrayList();
	ArrayList valuecolumnList = new ArrayList();
	ArrayList isLimitLengthList = new ArrayList();

	int perpage = 0;
	int userid = 1;
	int usertype = 0;
	/*if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid =1;
		usertype=0;
	}else{
		userid=pu.getHpUserId(hpid,""+subCompanyId,user);
		usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	}*/
	
	String fields = "";
	String linkmode = "";

	String strsqlwhere = hpec.getStrsqlwhere(eid);
	
	String strSql = "select perpage,linkmode,showfield from hpElementSettingDetail where eid=" + eid + " and userid=" + userid
			+ " and usertype=" + usertype;
	
	rsCommon.executeSql(strSql);
	if (rsCommon.next())
	{
		fields = Util.null2String(rsCommon.getString("showfield"));
		perpage = Util.getIntValue(rsCommon.getString("perpage"));
		linkmode = Util.null2String(rsCommon.getString("linkmode"));
	}

	if (!"".equals(fields))
	{
		ArrayList tempFieldList = Util.TokenizerString(fields, ",");
		for (int i = 0; i < tempFieldList.size(); i++)
		{
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
	String isFixationRowHeight = "0";
	String background = "";
	strSql = "select isFixationRowHeight,background from hpelement where id=" + eid;
	rsCommon.executeSql(strSql);
	if (rsCommon.next())
	{
		isFixationRowHeight = Util.null2String(rsCommon.getString("isFixationRowHeight"));
		background = Util.null2String(rsCommon.getString("background"));
	}
%>
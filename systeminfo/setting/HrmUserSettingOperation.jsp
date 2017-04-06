<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingHandler" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSetting" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ include file="/systeminfo/init.jsp" %>
<%

int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
String rtxOnload = Util.null2String(request.getParameter("rtxOnload"));
String isCoworkHead = Util.null2String(request.getParameter("isCoworkHead"));

cutoverWay = Util.null2String(request.getParameter("cutoverWay"));
transitionTime = Util.null2String(request.getParameter("TransitionTime"));
transitionWay = Util.null2String(request.getParameter("TransitionWay"));

rtxOnload=rtxOnload.equals("1")?"1":"0";
isCoworkHead=isCoworkHead.equals("1")?"1":"0";

String sql="update HrmUserSetting set rtxOnload="+rtxOnload+",isCoworkHead="+isCoworkHead + ", cutoverWay='" + cutoverWay + "', transitionTime='" + transitionTime + "', transitionWay='" + transitionWay + "' where id="+id;

RecordSet recordSet=new RecordSet();
recordSet.execute(sql);

//É¾³ý»º´æ
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
userSetting.removeHrmUserSettingComInfoCache();

response.sendRedirect("HrmUserSetting.jsp");
%>

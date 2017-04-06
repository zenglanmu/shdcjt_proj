<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
    String userid =""+user.getUID();
    /*权限判断,人力资产管理员以及其所有上级*/
    boolean canView = false;
    ArrayList allCanView = new ArrayList();
    String tempsql ="select resourceid from HrmRoleMembers where resourceid>1 and roleid in (select roleid from SystemRightRoles where rightid=22)";
    RecordSet.executeSql(tempsql);
    while(RecordSet.next()){
        String tempid = RecordSet.getString("resourceid");
        allCanView.add(tempid);
        AllManagers.getAll(tempid);
        while(AllManagers.next()){
            allCanView.add(AllManagers.getManagerID());
        }
    }// end while

    for (int i=0;i<allCanView.size();i++){
        if(userid.equals((String)allCanView.get(i))){
            canView = true;
        }
    }
    if(!canView) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
    /*权限判断结束*/

    int scopeId = Util.getIntValue(request.getParameter("scopeid"),0);

    ArrayList ids = new ArrayList();
    ArrayList colnames = new ArrayList();
    ArrayList opts = new ArrayList();
    ArrayList values = new ArrayList();
    ArrayList names = new ArrayList();
    ArrayList opt1s = new ArrayList();
    ArrayList value1s = new ArrayList();
    ids.clear();
    colnames.clear();
    opt1s.clear();
    names.clear();
    value1s.clear();
    opts.clear();
    values.clear();

%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/report/resource/HrmRpSubSearchDefine.jsp?scopeid="+scopeId+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmRpSubSearchResult.jsp" method="post">
<input type="hidden" value="<%=scopeId%>" name="scopeId">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

    <table width=100% class=viewform>
        <COLGROUP>
            <COL width="4%">
            <COL width="20%">
            <COL width="20%">
            <COL width="18%">
            <COL width="20%">
            <COL width="18%">
    <TR class=title>
        <TH colSpan=6><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
    <TR >
        <TD class=line colspan=6></TD>
    </TR>
    <TR class=title>
        <td></td>
        <td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
        <td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
    </tr>
    <TR >
        <TD class=line1 colspan=6></TD>
    </TR>
<%
    int linecolor=0;
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    int tmpcount = 0;
    while(cfm.next()){
        tmpcount += 1;
        String id = String.valueOf(cfm.getId());
%>
    <tr class=title >
    <td>
        <input type='checkbox' name='check_con'  value="<%=id%>" <%if(ids.indexOf(""+id)!=-1){%> checked <%}%>>
    </td>
    <td>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_ismain" value="1">
<%
        String name = "field"+id;
        String label = cfm.getLable();
%>
      <%=Util.toScreen(label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </td>
<%
        String htmltype = cfm.getHtmlType();
        String type = String.valueOf(cfm.getType());
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
<%
        if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <td>
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
            <option value="3" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            <option value="4" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
        <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
<%
        }else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <td>
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
            <option value="3" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
            <option value="4" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
            <option value="5" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="6" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td >
        <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
    </td>
    <td>
        <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
            <option value="3" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
            <option value="4" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
            <option value="5" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="6" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </td>
<%
        }else if(htmltype.equals("4")){
%>
    <td colspan=4>
        <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&(values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </td>
<%
        }else if(htmltype.equals("5")){
%>
    <td>
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
        <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
<%
            cfm.getSelectItem(cfm.getId());
            while(cfm.nextSelect()){

                String tmpselectvalue = cfm.getSelectValue();
                String tmpselectname = cfm.getSelectName();
%>
            <option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&(values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%
            }
%>
        </select>
    </td>
<%
        }else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37")){
%>
    <td>
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
<%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4")) {
                browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }
%>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
        <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
<%
            if(ids.indexOf(""+id)!=-1){
%>
        <%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
<%
        } else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
    <td >
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
            <option value="3" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
            <option value="4" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
            <option value="5" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="6" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
        <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
<%
            if(ids.indexOf(""+id)!=-1){
%>
            <%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
    <td >
        <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
            <option value="3" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
            <option value="4" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
            <option value="5" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="6" <%if((ids.indexOf(""+id)!=-1)&&(opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        </select>
    </td>
    <td >
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
        <input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
<%
            if(ids.indexOf(""+id)!=-1){
%>
            <%=(value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
<%
        }else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
        <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
<%
            if(ids.indexOf(""+id)!=-1){
%>
            <%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
<%
        } else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
        <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
<%
            if(ids.indexOf(""+id)!=-1){
%>
            <%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
<%
        } else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含）
%>
    <td >
        <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            <option value="2" <%if((ids.indexOf(""+id)!=-1)&&(opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
        </select>
    </td>
    <td colspan=3>
        <button class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
        <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
        <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
        <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
<%
            if(ids.indexOf(""+id)!=-1){
%>
            <%=(names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
<%
            }
%>
        </span>
    </td>
<%
        }
%>
    </tr>
	<tr><td colspan=6 class=line></td></tr>
<%
        if(linecolor==0)
            linecolor=1;
        else
            linecolor=0;
    }
%>

    </table>

  	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</FORM>
<SCRIPT LANGUAGE=VBS>

sub onShowBrowser(id,url)
		id1 = window.showModalDialog(url&"?selectedids="&document.all("con"+id+"_value").value)

		if NOT isempty(id1) then
		    if id1(0)<> "" and id1(0)<> "0" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub
sub onShowBrowser1(id,url,type1)
	if type1= 1 then
	    spanname = "con"+id+"_valuespan"
        inputname = "con"+id+"_value"
		onHrCrpShowDate spanname,inputname
	elseif type1=2 then
	    spanname = "con"+id+"_value1span"
		inputname = "con"+id+"_value1"
        onHrCrpShowDate spanname,inputname
	end if
end sub

sub changelevel(tmpindex)
		document.SearchForm.check_con(tmpindex-1).checked = true

end sub

</script>
<script language="javascript">
   function onHrCrpShowDate(spanname,inputname){
      WdatePicker({el:spanname,onpicked:function(dp){
			$dp.$(inputname).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$(inputname).value = ''}});
   }
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>

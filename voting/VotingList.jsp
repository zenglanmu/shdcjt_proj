<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";

int viewResult = Util.getIntValue(Util.null2String(request.getParameter("viewResult")),0);

String userid = user.getUID()+"";

boolean canview = false;

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean cancreate=false ;
//boolean canapprove = false ;
RecordSet.executeSql("select id from votingmaintdetail where createrid="+userid+" or approverid="+userid);
if(RecordSet.next())  cancreate=true ;
if(canmaint)  cancreate=true ;
//if(!"".equals(userid)) cancreate=true;
//RecordSet.executeSql("select id from votingmaintdetail where approverid="+userid);
//if(RecordSet.next())  canapprove=true ;

RecordSet.executeSql("select votingid from votingsharedetail where resourceid="+userid+" union select votingid from votingviewerdetail where resourceid="+userid);
if(RecordSet.next()) canview=true ;

if(canmaint||cancreate) canview = true;

if(viewResult==1){
    if(canmaint){
        canmaint = false;
        canview = true;
    }
    if(cancreate){
        cancreate = false;
        canview = true;
    }
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<script type="text/javascript">
function onCopy(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>!");
		return;
	}
    document.frmSubscribleHistory.ids.value = _xtable_CheckedCheckboxId();
    document.frmSubscribleHistory.action = "VotingCopyOperation.jsp";
    document.frmSubscribleHistory.submit();
}
</script>
<%

    if(cancreate) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/voting/VotingAdd.jsp',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onCopy(),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }

    if(canmaint) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18599,user.getLanguage())+",javascript:location='/voting/VotingMaint.jsp',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
/*
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
	*/
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

  <TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="10">
          <col width="">
            <col width="10">
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">
                <form name="frmSubscribleHistory" method="post" action="">
                
                <input type="hidden" name="ids" />
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
                        <%
                        if(!canmaint&&!cancreate){
                        %>
						<TABLE class="ViewForm">
							<colgroup>
								<col width="15%">
								<col width="30%">
								<col width="10%">
								<col width="15%">
								<col width="30%">
							</colgroup>
							<TBODY>
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(23143,user.getLanguage()) %></TD>
									<TD class="field">
										<select id="chiefType">
											<option value=""><%=SystemEnv.getHtmlLabelName(23144,user.getLanguage()) %></option>
											<option value="com"><%=SystemEnv.getHtmlLabelName(23145,user.getLanguage()) %></option>
											<option value="quarters"><%=SystemEnv.getHtmlLabelName(23146,user.getLanguage()) %></option>
										</select>
									</TD>
									<TD>
										&nbsp;
									</TD>
									<TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %></TD>
									<TD class="field">
										<button type="button" class=Browser onclick="onShowBrowser()"></button>
										<input type=hidden id="conidvalue" name="conidvalue" value="">
										<input type=hidden id="conidname" name="conidname" value="">
										<span name="convaluespan" id="convaluespan"></span>
										
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class=Line colSpan=5></TD>
								</TR>
							</TBODY>
						</TABLE>

	                  <!--列表部分-->
	               <%
                       }
	                     //得到pageNum 与 perpage
	                     int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
	                     int perpage = UserDefaultManager.getNumperpage();
	                     if(perpage <2) perpage=15;
	                     
	                     //设置好搜索条件
	                     String backFields =" id,subject,begindate,begintime,createrid,approverid,status,createdate ,createtime ";
	                     String fromSql = " voting ";
	                     String sqlWhere = "";
	                     if(canmaint){
	                         sqlWhere = " where 1=1 ";
	                     } else if(cancreate){
	                         sqlWhere = " where createrid="+userid+" or approverid="+userid;
	                     } else {
	                    	 String sqltmp = "";
	                    	 if(!canmaint) sqltmp = " and status in ('1','2') ";//当员工查看调查时,如果是调查的参与者,而此调查又是创建状态,侧此调查不显示
	                         sqlWhere = " where exists ( " +
	                                    " select 1 from ( " +
	                                    " select votingid from votingsharedetail where resourceid=" + userid + " union select votingid from votingviewerdetail where resourceid=" + userid +
	                                    " ) a where a.votingid = id " +sqltmp+
	                                    " ) " +
	                                    " or createrid="+userid+" or approverid="+userid;
	                     }
	                     String orderBy="";
	                     if(canmaint){
	                         orderBy = " begindate ,begintime  ";
	                     } else {
	                         orderBy = " createdate ,createtime  ";
	                     }
	                     
	                     String linkstr = "";
	                     if(canmaint||cancreate){
	                         linkstr = "/voting/VotingView.jsp+column:id";
	                     } else {
	                         linkstr = "/voting/VotingPollResult.jsp+column:id";
	                     }

	                     String tableString = "";
	                     if(viewResult==1){
	                    	 tableString=""+
	                            "<table pagesize=\""+perpage+"\" tabletype=\"none\">";
	                     }else{
	                    	 tableString=""+
	                            "<table pagesize=\""+perpage+"\" tabletype=\"checkbox\">";
	                     }
	                      tableString +=
	                            "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
	                            "<head>"+
	                                  "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+linkstr+"\" transmethod=\"weaver.voting.VotingManager.getVotingLink\"/>"+
	                                  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" otherpara=\""+linkstr+"\" transmethod=\"weaver.voting.VotingManager.getVotingLink\"/>"+
	                                  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" orderkey=\"createrid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
	                                  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"begindate\" orderkey=\"begindate\" />"+
	                                  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.voting.VotingManager.getStatus\"/>"+
	                            "</head>"+
	                            "</table>";
	                   %>
	                     <TABLE width="100%" height="100%">
	                         <TR>
	                             <TD valign="top">
	                                 <wea:SplitPageTag isShowTopInfo="true" tableString="<%=tableString%>"  mode="run"/>
	                             </TD>
	                         </TR>
	                     </TABLE>



                       </td>
                    </tr>
                  </TABLE>  
                  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
</BODY></HTML>
<script language="javaScript">

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}
function forwardVotingResult(link)
{
	if(link=="")
	{
		return false;
	}
	var chiefType = document.getElementById("chiefType");
	var conidvalue = document.getElementById("conidvalue");
	
	if(chiefType)
	{
		chiefType = chiefType.value;
		if(chiefType=="com")
		{
			link =link+"&chiefType=com";
		}
		else if(chiefType=="quarters")
		{
			if(conidvalue)
			{
				conidvalue = conidvalue.value;
				if(""==conidvalue)
				{
					reply=confirm("<%=SystemEnv.getHtmlLabelName(23147,user.getLanguage()) %>?")
					if(reply==true)
					{
					  	link =link+"&chiefType=quarters";
					}
					else
					{
						return false;
					}
				}
				else
				{
					link =link+"&chiefType=quarters&chiefId="+conidvalue;
				}
			}
		}
	}
  	window.open(link,"mainFrame","") ;
}
</script>
<SCRIPT language="javascript">
function btnok_onclick(){
	document.all("haspost").value="1"
     document.SearchForm.submit();
}

function btnclear_onclick(){
     document.all("isclear").value="1"
     document.SearchForm.submit()
}
function titleBrowerBeforeShow(opts){
	opts._url=opts._url+$('#conidvalue').val();
}

function onShowBrowser(){
	var results=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?jobtitles="+$GetEle("conidvalue").value);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	      jQuery("#convaluespan").html(doReturnSpanHtml(wuiUtil.getJsonValueByIndex(results,1)));
	      $GetEle("conidvalue").value=wuiUtil.getJsonValueByIndex(results,0);
	   }else{
	      jQuery("#convaluespan").html("");
		  $GetEle("conidvalue").value=""
	   }
	}
}

</SCRIPT>
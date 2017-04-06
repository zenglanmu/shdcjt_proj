<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int templetId = Util.getIntValue(request.getParameter("templetId"));
%>
                    <!--任务列表-->
                    <TABLE  CLASS="viewForm"  valign="top">
                        <TR CLASS="title">
                            <TH  WIDTH="80%"><%=SystemEnv.getHtmlLabelName(18505,user.getLanguage())%></TH>
                            <TD WIDTH="20%">
                                <div align="right">                                   
                                    <img src="/images/up.jpg" style="cursor:pointer" onclick="onHiddenImgClick(divTaskList,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
                                <div>
                            </TD>
                         </TR>
                        <TR style="height:1px;">
                        <TD CLASS="line1" colspan="2"></TD></TR>                
                     </TABLE>                     
                        <!--得到隐藏的层,等此form提交的时候不要忘了清除里的的数据-->   
                        <div id="divTaskList" style="display:''">
                        <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="tblTask">
                            <colgroup>                           
                            <col width="20%">
                            <col width="5%">
                            <col width="12%">                       
                            <col width="12%">
                            <col width="15%">
                            <col width="8%">
                            <col width="10%">                                                                               
                            <TR class="Header">                                
																<TD align='left'><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(1298,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>     
                                <TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
                                <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>                              
                            </TR>
                            <tr class="Line"><td colspan="7" style="padding:0;"></td></tr>   
                            <%out.println(ProjTempletUtil.getViewTaskListStr(templetId));%>
                        </TABLE>
                    </div>

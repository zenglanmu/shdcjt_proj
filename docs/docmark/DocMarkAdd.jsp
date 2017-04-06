<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="DocMark" class="weaver.docs.docmark.DocMark" scope="page" />
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>
<%
//判断当前目录是否允许打分
String secId = Util.null2String(request.getParameter("secId"));
if (!DocMark.isAllowMark(secId)) return ;
session.putValue("secId",secId);

String docId = Util.null2String(request.getParameter("docId"));
String fromUrl = Util.null2String(request.getParameter("fromUrl"));
if("".equals(fromUrl)){
	fromUrl = "/docs/docmark/DocMarkAdd.jsp"+"?docId="+docId+"&secId="+secId;
} else {
	fromUrl = fromUrl+"?id="+docId;
}

int trHeight = 80;

int docMarkCount = DocMark.getDocMarkCount(docId); //打分的个数
int docMarkSum = DocMark.getDocMarkSum(docId);   //总分

double docMarkAve =MathUtil.round(DocMark.getDocMarkAve(docId),2);  //平均分

int markTypeCount1 =  DocMark.getMarkTypeCount(1,docId);
int markTypeCount2 =  DocMark.getMarkTypeCount(2,docId);
int markTypeCount3 =  DocMark.getMarkTypeCount(3,docId);
int markTypeCount4 =  DocMark.getMarkTypeCount(4,docId);
int markTypeCount5 =  DocMark.getMarkTypeCount(5,docId);
%>

<TABLE class ="ViewForm" height="80">
<colgroup>
<col width="48%">
<col width="4%">
<col width="48%">
<%--
<TR><TD class=Line1 colspan=3></TD></TR>
--%>
    <TR>
        <TD>
           <FORM   name="frmMark" action="/docs/docmark/DocMarkOperate.jsp">         
           <input type="hidden" name="fromUrl" value="<%=fromUrl%>">
           <input type="hidden" name="docId" value="<%=docId%>">
            <input type="hidden" name="operate" value="add">
            <TABLE>
                <TR><TD><%=SystemEnv.getHtmlLabelName(18991,user.getLanguage())%></TD></TR>
                <TR>
                    <TD>                       
                            <TABLE  height="100%">
                                  <TR> 
                                    <TD>&nbsp;</TD>
                                    <TD align="center">1</TD>
                                    <TD align="center">2</TD>
                                    <TD align="center">3</TD>
                                    <TD align="center">4</TD>
                                    <TD align="center">5</TD>
                                    <TD align="center">&nbsp;</TD>
                                 </TR>
                                  <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18992,user.getLanguage())%></TD>
                                    <TD><input name="rdoMark" type="radio" value="1"></TD>
                                    <TD><input name="rdoMark" type="radio" value="2"></TD>
                                    <TD><input name="rdoMark" type="radio" value="3"></TD>
                                    <TD><input name="rdoMark" type="radio" value="4"></TD>
                                    <TD><input name="rdoMark" type="radio" value="5"></TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18993,user.getLanguage())%></TD>
                                 </TR>
                            </TABLE> 
                    </TD>
                </TR>
                <TR>
                    <TD>
                        <%=SystemEnv.getHtmlLabelName(18994,user.getLanguage())%><br>
                        <br>
                        <TEXTAREA NAME="remark" ROWS="3" COLS="70" style="InputStyle"></TEXTAREA> 
                        <br>
                    </TD>
                </TR>
                <TR>
                    <TD>
                    <button type="button" class=BtnSave  accesskey=S onClick="onMarkSubmit()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
                      
                    </TD>
                </TR>
                <TR><TD height="10">&nbsp;</TD></TR>
            </TABLE>
            </FORM>
        </TD>
        <TD height="95%"><Table  bgcolor="#808080" height="100%"   border="0" width="1" cellspacing="0" cellpadding="0"><tr><td></td></tr></Table></TD>
        <TD>
            <TABLE width="100%" height="100%">
                <TR><TD align="left"><%=SystemEnv.getHtmlLabelName(18995,user.getLanguage())%>:<%=docMarkSum%> <%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%>　<%=SystemEnv.getHtmlLabelName(18996,user.getLanguage())%>:<%=docMarkAve%> <%=SystemEnv.getHtmlLabelName(18928,user.getLanguage())%></TD></TR>
                <TR rowspan="2">
                    <TD align="left" >
                        <Table>
                            <tr  valign="bottom" height="<%=trHeight%>">
                                <td>
                                <Table border="0" width="20" cellspacing="0" cellpadding="0">                                
                                <tr><td><font color="#FF0099"><%=markTypeCount1%></font></td></tr>
                                <tr height="<%=trHeight*((double)markTypeCount1/docMarkCount)%>" bgcolor="#66CC99"><td></td></tr>
                                </Table>
                                </td>
                                <td width="1">&nbsp;<td>

                                <td>                                
                                <Table border="0" width="20" cellspacing="0" cellpadding="0">                                
                                <tr><td><font color="#FF0099"><%=markTypeCount2%></font></td></tr>
                                <tr height="<%=trHeight*((double)markTypeCount2/docMarkCount)%>" bgcolor="#66CC99"><td></td></tr>
                                </Table>
                                </td>
                                <td width="1">&nbsp;<td>

                                <td>                                
                                <Table border="0" width="20" cellspacing="0" cellpadding="0">                                
                                <tr><td><font color="#FF0099"><%=markTypeCount3%></font></td></tr>
                                <tr height="<%=trHeight*((double)markTypeCount3/docMarkCount)%>" bgcolor="#66CC99"><td></td></tr>
                                </Table>
                                </td>
                                <td width="1">&nbsp;<td>


                                <td>                                
                                <Table border="0" width="20" cellspacing="0" cellpadding="0">                                
                                <tr><td><font color="#FF0099"><%=markTypeCount4%></font></td></tr>
                                <tr height="<%=trHeight*((double)markTypeCount4/docMarkCount)%>" bgcolor="#66CC99"><td></td></tr>
                                </Table>
                                </td>
                                <td width="1">&nbsp;<td>


                                <td>                                
                                <Table border="0" width="20" cellspacing="0" cellpadding="0">                                
                                <tr><td><font color="#FF0099"><%=markTypeCount5%></font></td></tr>
                                <tr height="<%=trHeight*((double)markTypeCount5/docMarkCount)%>" bgcolor="#66CC99"><td></td></tr>
                                </Table>
                                </td>
                                <td width="1">&nbsp;<td>
                               

                            </tr>
                            <tr align="center">
                                <td>1</td>
                                <td width="1">&nbsp;<td>
                                <td>2</td>
                                <td width="1">&nbsp;<td>
                                <td>3</td>
                                <td width="1">&nbsp;<td>
                                <td>4</td>
                                <td width="1">&nbsp;<td>
                                <td>5</td>
                                <td width="1">&nbsp;<td>
                            </tr>
                        </Table>
                    </TD>
                </TR>               
                <TR><TD align="left"><%=SystemEnv.getHtmlLabelName(18998,user.getLanguage())%> <%=docMarkCount%> <%=SystemEnv.getHtmlLabelName(18999,user.getLanguage())%></TD></TR>
                <TR><TD><div align="center"><a href="#" onclick="openLogView()"><%=SystemEnv.getHtmlLabelName(18997,user.getLanguage())%>>>></a><div></TD></TR>
            </TABLE>
        </TD>
	</TR>
<%--
   <TR><TD class=Line1 colspan=3></TD></TR> 
--%>
</TABLE>
</BODY>
</HTML>

 <SCRIPT LANGUAGE="JavaScript">
    <!--  
     function openLogView(){
        window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docmark/DocMarkLogView.jsp?docId=<%=docId%>");         
     }  
    
     function onMarkSubmit(){
         if (!frmMark.rdoMark[0].checked&&!frmMark.rdoMark[1].checked&&!frmMark.rdoMark[2].checked&&!frmMark.rdoMark[3].checked&&!frmMark.rdoMark[4].checked) {
            alert("<%=SystemEnv.getHtmlLabelName(19000,user.getLanguage())%>");
         } else {
            frmMark.submit();
         }
     }
     //-->
 </SCRIPT>
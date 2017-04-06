<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<%
    String checkpeopleid = Util.null2String(request.getParameter("id")) ;
    String checkid = "" ;
    String checktypeid = "" ;
    String resourceid = "" ;
    String result = "" ;
    String startdate = "" ;
    String enddate = "" ;
    Calendar todaycal = Calendar.getInstance ();
    String nowdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
    String sql="select checkid,resourceid from HrmByCheckPeople where id="+ checkpeopleid ;
    rs.executeSql(sql) ;
    if(rs.next()) {
        checkid = Util.null2String(rs.getString("checkid"));
        resourceid = Util.null2String(rs.getString("resourceid"));
    }

    sql="select checktypeid,startdate,enddate from HrmCheckList where id="+ checkid ;
    rs.executeSql(sql) ;
    if(rs.next()) {
        checktypeid = Util.null2String(rs.getString("checktypeid"));
        startdate =  Util.null2String(rs.getString("startdate"));
        enddate = Util.null2String(rs.getString("enddate"));
    }
    
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6106,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
%>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(nowdate.compareTo(enddate) <=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=HrmCheckMark id=hrmcheckkind action="HrmCheckMarkOperation.jsp" method=POST >
<input class=inputstyle type=hidden name=checkpeopleid value="<%=checkpeopleid%>">
<input class=inputstyle type=hidden name=checktypeid value="<%=checktypeid%>">
<input class=inputstyle type=hidden name=operation value="AddCheck">
   
            <TABLE width="100%"  class=ListStyle cellspacing=1 >
                
                <TBODY> 
                    <TR class=Header> 
                    <TH colspan=3>
			
                    <%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%>: <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></TH>

                    </TR>
                        <tr class=header>
                        <td width=50><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></td>
                        <td width=25%><%=SystemEnv.getHtmlLabelName(15657,user.getLanguage())%></td>
                        <td width=25%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
                    </tr>
                    <TR class=Line><TD colspan="3" ></TD></TR> 

                    <%      
                            String checkitemid="" ;
                            ArrayList results = new ArrayList();
                            ArrayList checkitemids = new ArrayList();
                            sql="select result,checkitemid from HrmCheckGrade where checkpeopleid="+ checkpeopleid ;
                            rs2.executeSql(sql) ;
                            while(rs2.next()){
                                results.add(Util.null2String(rs2.getString("result")));
                                checkitemids.add(Util.null2String(rs2.getString("checkitemid")));
                            }
                            
                                                   
                            sql = "select checkitemid , checkitemproportion from HrmCheckKindItem where checktypeid="+checktypeid;
         
                            rs.executeSql(sql) ;
                            boolean isLight = false;
                            while(rs.next()){  
                                checkitemid = Util.null2String(rs.getString("checkitemid"));
                                String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
                               
                                isLight = !isLight ; 
                       
                        %>
                   
                    
                    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
                        <TD class=Field width=100> 
                        <%=Util.toScreen(CheckComInfo.getCheckName(checkitemid),user.getLanguage())%>
                        </TD>
                        <%
                        int checkitemidindex = checkitemids.indexOf( checkitemid ) ;
                        if(checkitemidindex != -1) 
                        result = (String)results.get( checkitemidindex ) ;

                        
                       if(nowdate.compareTo(enddate) <=0) {
                        %>
                            
                        <TD class=Field>
                        <select class=inputstyle name='result_<%=checkitemid%>' style='width:50%'>
                            <option value="5" <%if(result.equals("5")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
                            <option value="4" <%if(result.equals("4")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15658,user.getLanguage())%></option>
                            <option value="3" <%if(result.equals("3")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15659,user.getLanguage())%></option>
                            <option value="2" <%if(result.equals("2")){%>selected 
                            <%}%>><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%></option>
                            <option value="1" <%if(result.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%></option>
                        </select>
                        </TD>
                        <%
                        }else{
                        %>
                        <TD class=Field>
                        <% if(result.equals("1")){ %><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%>
                        <% } else if(result.equals("2")){%><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>
                        <% } else if(result.equals("3")){%><%=SystemEnv.getHtmlLabelName(15659,user.getLanguage())%>
                        <% } else if(result.equals("4")){%><%=SystemEnv.getHtmlLabelName(15658,user.getLanguage())%>
                        <% } else if(result.equals("5")){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>    
                        <% } %>
                        
                        </TD>
                        <%
                        }
                        %>
                        <TD>
                            <%=checkitemproportion%>%
                        </TD>
                    </tr> 
                    <%       
                       }
                           
                    %>  
                </tbody>
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
 </form>
<script language=javascript>
function onDelete(){
if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
document.HrmCheckMark.operation.value="delete";
document.HrmCheckMark.submit();
}
}

function doBack(){
	location ="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>";
}

function submitData() {
 if(check_form(HrmCheckMark,'result')){
 HrmCheckMark.submit();
 }
}
</script>
</BODY>
</HTML>
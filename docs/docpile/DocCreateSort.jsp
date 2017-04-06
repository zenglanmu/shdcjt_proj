<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.docpile.DocPile" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String userId = request.getParameter("hrmid");
//分页

int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
int perpage = UserDefaultManager.getNumperpage();
if(perpage <2) perpage=10;
%>
 <BODY>   

	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%   
        RCMenu += "{关闭,javascript:window.close()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
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
                  <TABLE class="Shadow">
                    <tr>
                      <td valign="top">
                        <TABLE  class ="ListStyle">                    
                        <colgroup>
                        <col width="30%">
                        <col width="40%">
                        <col width="30%"> 
                        <TR class=Header>
                            <TH>创建人</TH>
                            <TH>创建文档数</TH>
                            <TH>名次</TH>                      
                        </TR>
                        <%
                        int baseLeve = (pagenum-1) * perpage ;
                        int rows = 0; 
                        
                        String backFields="usertype,doccreaterid,count(id) as doccount";
                        String sqlFrom=" from docdetail";	
                        String sqlwhere = "";
                        String orderby  = "doccount,doccreaterid";
                        String groupby="doccreaterid,usertype";
                        
                        SplitPageParaBean spb=new SplitPageParaBean();
                        spb.setPrimaryKey("doccreaterid");
                        spb.setBackFields(backFields);
                        spb.setSqlFrom(sqlFrom);
                        spb.setSqlWhere(sqlwhere);
                        spb.setSqlOrderBy(orderby);
                        spb.setSqlGroupBy(groupby);
                        spb.setSortWay(spb.DESC);
                        
                        SplitPageUtil spu=new SplitPageUtil();
                        spu.setSpp(spb);
                        
                        int recordSize=spu.getRecordCount();
                        RecordSet rs=spu.getCurrentPageRs(pagenum, perpage);
                       
                       
                        while(rs.next()) {
                        		   String usertype=Util.null2String(rs.getString("usertype"));
                        		   String doccreaterid=Util.null2String(rs.getString("doccreaterid"));                        		   
                        		   String doccount=Util.null2String(rs.getString("doccount"));

                                   rows++;
                                   if (!userId.equals(doccreaterid)) {
                               %>                      
                                     <TR class="<%=rows%2==0?"datadark":"datalight"%>"> 
                                <%} else {%>
                                    <TR Style="color:#FF0000">
                                <%}%>
										<TD><%
										  if (usertype.equals("1")) {
                                              out.println(ResourceComInfo.getResourcename(doccreaterid));
                                          } else {
                                              out.println(CustomerInfo.getCustomerInfoname(doccreaterid));
                                          }     
										%></TD>
										<TD><%=doccount%></TD>                                        
                                        <TD><%=baseLeve+rows%></TD>
                                    </TR>
                               <%}%>
                      </TABLE>

                      <!--分页状态栏部分-->                               
                      <TABLE width="100%" border="0">                                
                        <TR>
                            <TD noWrap>
                             <% 
                                String linkstr = "DocCreateSort.jsp?hrmid="+userId;
                             %>
                             <%=Util.makeNavbar2(pagenum,recordSize,perpage,linkstr)%>
                            </TD>
                        </TR>
                      </TABLE>

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
          </BODY>
        </HTML>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<%@ include file="/docs/common.jsp" %>
<%	 
 
	int dummyId=Util.getIntValue(request.getParameter("dummyId"),1);
	String superDummys=DocTreeDocFieldComInfo.getAllSuperiorFieldName(""+dummyId);

	String imagefilename = "/images/hdDOC.gif";
	String titlename = "&nbsp;"+superDummys;
	String needfav ="1";
	String needhelp =""; 

    //以下得搜索时的变量值
    String docTxt = Util.null2String(request.getParameter("docTxt"));
    String owenerTxt = Util.null2String(request.getParameter("owenerTxt")); 	
    String subscribeDateFrom = Util.null2String(request.getParameter("subscribeDateFrom"));
    String subscribeDateTo = Util.null2String(request.getParameter("subscribeDateTo"));

    //构建where语句
    String andSql="";
    if (!"".equals(docTxt)) andSql+=" and docsubject like '%"+docTxt+"%'";
    if (!"".equals(owenerTxt)) andSql+=" and ownerid="+owenerTxt;

	String andSql1="";
    if (!"".equals(subscribeDateFrom)) andSql1+=" and importdate>='"+subscribeDateFrom+"'";

    if (!"".equals(subscribeDateTo)) andSql1+=" and importdate<='"+subscribeDateTo+"'";

	//判断是不是此虚拟目录的管理员
	boolean isManager=DocTreeDocFieldManager.getIsManager(user.getUID(),dummyId);
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%

	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	if(isManager) {
   
		RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopy(-1)',_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:doMove(-1)',_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doRemove(-1)',_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-2)',_top} " ;
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
                <form name="frmSubscribleHistory" method="post" action="">					
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
                         <!--搜索部分-->
                        	 <input type=hidden name="dummyId" value="<%=dummyId%>" >
                            <TABLE  class ="ViewForm">
                                <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="15%">
                                <col width="30%">
                                </colgroup>
                                 <TBODY>
                                <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></TD>
                                    <TD class="field">                                      
                                        <INPUT type=text id="docTxt" name="docTxt" class="inputStyle" value="<%=docTxt%>">
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%=SystemEnv.getHtmlLabelName(18656,user.getLanguage())%></TD>
                                    <TD class="field">
                                        
                                        <input type="hidden" id="owenerTxt" name="owenerTxt" class="wuiBrowser" value="<%=owenerTxt%>"  _displayText="<%=ResourceComInfo.getResourcename(owenerTxt)%>" 
                                        	_url="/docs/DocBrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
                                        />
                                    </TD>
                                </TR>
                                 <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                 <TR>
                                    <TD><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
                                    <TD class="field">
                                        <button type="button"   class=calendar  onclick="gettheDummyDate(subscribeDateFrom,subscribeDateFromSpan)"></BUTTON>
                                         <SPAN id=subscribeDateFromSpan ><%=subscribeDateFrom%></SPAN> -&nbsp;                                      
                                         <button type="button"   class=calendar onclick="gettheDummyDate1(subscribeDateTo,subscribeDateToSpan)"></BUTTON>
                                         <SPAN id=subscribeDateToSpan ><%=subscribeDateTo%></SPAN>

                                         <input type="hidden" name="subscribeDateFrom" id="subscribeDateFrom" value="<%=subscribeDateFrom%>">
                                         <input type="hidden" name="subscribeDateTo" id="subscribeDateTo" value="<%=subscribeDateTo%>">
                                    </TD>
                                    <TD>&nbsp;</TD>
                                    <TD><%//=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TD>
                                    <TD class="field">
                                    </TD>
                                </TR>
                                <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
                                </TBODY>
                            </TABLE>  
                         <!--列表部分-->
                          <%
                                //得到pageNum 与 perpage
                                int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
                                int perpage = UserDefaultManager.getNumperpage();
                                if(perpage <2) perpage=15;
                                
                                //设置好搜索条件
                                String backFields ="id,ownerid,doclastmoddate,doclastmodtime,docextendname,usertype,docsubject,ishistory,docstatus,doccreaterid";
                                //String fromSql = " docsubscribe";
								 //String sqlWhere = " where hrmid ="+user.getUID()+andSql;
								String fromSql="";	
								String strSubject="";
								String invalidStr = "";
								if(isManager){
									fromSql="from (select distinct "+backFields+" from docdetail t1  where 0=0  "+ andSql + ") a right outer join (select distinct docid,importdate,importtime  from DocDummyDetail where catelogid="+dummyId+ " "+ andSql1 + " ) b on a.id=b.docid ";	

									strSubject="<col  width=\"35%\" name=\"id\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getNameByShare\" href=\"/docs/docs/DocDsp.jsp\"  otherpara=\"column:usertype\"  linkkey=\"id\"/>";
									invalidStr = " or a.docstatus ='7' ";
								} else {	
									
									backFields+=",sharelevel";

									fromSql="from (select distinct "+backFields+" from docdetail t1,"+tables+" t2   where t1.id=t2.sourceid   "+ andSql + ") a right outer join (select distinct docid,importdate,importtime  from DocDummyDetail where catelogid="+dummyId+ " "+ andSql1 + " ) b on a.id=b.docid ";		
									
									String userID=""+user.getUID();
								    String ownerid=userID;


									invalidStr = " or a.docstatus = 7 and  (sharelevel>1" + ((userID!=null&&!"".equals(userID))?" or (a.doccreaterid=" + userID + ((ownerid!=null&&!"".equals(ownerid))?" or a.ownerid=" + ownerid:"") + ")":"") + ") ";
								}

								
								
								String sqlWhere=" where a.id is not null and (a.ishistory is null or a.ishistory = 0)  and (a.docstatus ='1' or a.docstatus ='2' or a.docstatus='5'   "+invalidStr+" )  ";                               
                                String orderBy="importdate,importtime";

								String strOperation="";
								if(isManager){
									strOperation="<operates width=\"15%\">"+
													"<operate href=\"javascript:doCopy()\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(77,user.getLanguage())+"\" />"+
													"<operate href=\"javascript:doMove()\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(78,user.getLanguage())+"\" />"+
												    "<operate href=\"javascript:doRemove()\" linkkey=\"id\" linkvaluecolumn=\"id\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" />"+
										         "</operates>";
								}
                                String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\">"+
                                       "<sql backfields=\"*\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"  />"+
                                       "<head>"+
											"<col  width=\"5%\" name=\"id\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>"+
											"<col  width=\"35%\" name=\"id\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" otherpara=\"column:docSubject\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameByDocIdAndDocSubject\" orderkey=\"docsubject\" target=\"_fullwindow\" href=\"/docs/docs/DocDsp.jsp\"   linkkey=\"id\"  linkvaluecolumn=\"id\"/>"+
											"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\"   otherpara=\"column:usertype\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" />"+		
											"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>"+
											"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(20515,user.getLanguage())+"\" column=\"importdate\" orderkey=\"importdate,importtime\"/>"+
                                       "</head>"+strOperation+
                                       "</table>";                                             
										                											                
                              %>
                                <TABLE  width="100%">		
                                    <TR>
                                        <TD valign="top">                
                                            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/> 
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
          </BODY>
		  <SCRIPT language="javascript" src="/js/datetime.js"></script>
		 <SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
        </HTML>
         <SCRIPT LANGUAGE="javascript">
            function onShowDoc(inputname,spanname){
                data = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
                if (id) {
                    if(data.id!=""){
	                    $("#"+inputname).val(data.id);
	                    $("#"+spanname).html(data.name);
                    }else{
                    	$("#"+inputname).val("");
                        $("#"+spanname).html("");
                    }	
                }
            }

           
        </SCRIPT>

         <SCRIPT LANGUAGE="JavaScript">
        <!--           

              function onSearch() {
                frmSubscribleHistory.submit();
              }              
              

			 function doCopy(docid) {
				
				if (docid=="-1")   {
					var selectDocids=_xtable_CheckedCheckboxId();
					if(selectDocids=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					txtDocs.value=selectDocids;
					oMoth.value="copy";
					initToDummy()
					//doUrl("edit",selectDocids);
				} else {
					if(docid=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					txtDocs.value=docid;
					oMoth.value="copy";
					initToDummy()
					//doUrl("edit",docid);
				}
              }


			   function doMove(docid){

				 if (docid=="-1")   {
					var selectDocids=_xtable_CheckedCheckboxId();
					if(selectDocids=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					txtDocs.value=selectDocids;
					oMoth.value="move";
					initToDummy()
					//doUrl("edit",selectDocids);
				} else {
					if(docid=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					txtDocs.value=docid;
					oMoth.value="move";
					initToDummy()
					//doUrl("edit",docid);
				}

			  }




              function doRemove(docid) {			
				if (docid=="-1")   {
					var selectDocids=_xtable_CheckedCheckboxId();
					if(selectDocids=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					if(isdel()) {
						doUrl("remove",selectDocids);
						initToDummy();
					}
				} else {
					if(docid=="") {
						alert("<%=SystemEnv.getHtmlLabelName(20551,user.getLanguage())%>");
						return false;		
					}
					
					if(isdel()) {					
						doUrl("remove",docid);
						initToDummy();
					}
				}
              }

			 

               function onBack(){
                   window.history.go(-1);
              }

			  function onShowImort(){				   
				   divDummy.style.display='';
			   }


  		       function onCloseImport(){				   
				   tblSetting.style.display='inline';
				   tblUploading.style.display='none';
				   divDummy.style.display='none';
			   }

			   function initToDummy(){
				   var pTop= document.body.offsetHeight/2+document.body.scrollTop-100;
				   var pLeft= document.body.offsetWidth/2-180;
					divDummy.style.position="absolute"
					divDummy.style.top=pTop+"px";
					divDummy.style.left=pLeft+"px";
					divDummy.style.display="inline";

			   }
			   function showMsg(txt){		
					tdUploading.innerHTML=txt;
			   }

			  function doUrl(method,docid){		
				    tblSetting.style.display='none';
				    tblUploading.style.display='inline';

					var doHttp = XmlHttp.create();
					var url="/docs/search/DocUpToDummy.jsp?txtDummy=<%=dummyId%>";
					if(method=="remove"){						
						url=url+"&method=remove&txtDocs="+docid;
					} else if(method=="copy") {
						url=url+"&method=copy&txtDocs="+txtDocs.value+"&tdummy="+tdummy.value;
					}	 else if(method=="move") {
						url=url+"&method=move&txtDocs="+txtDocs.value+"&tdummy="+tdummy.value;
					}					
					
					doHttp.open("get",url, true);					
					doHttp.onreadystatechange = function () {	
						switch (doHttp.readyState) {			   
						   case 4 : 
								var txt=doHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
								//this.showMsg(txt)

								if(txt=="success") {
									onCloseImport();
									_table.reLoad();
								} else {
									showMsg(txt)
								}					 
						} 
					}		
					doHttp.setRequestHeader("Content-Type","text/xml")	
					doHttp.send(null);		
					
			   }

			   function isdel(){
				var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
			   if(!confirm(str)){
				   return false;
			   }
				   return true;
			   } 

        //-->
        </SCRIPT>
		
		<input type="hidden" id="oMoth"  name="oMoth">

		<input type="hidden" id="txtDocs"  name="txtDocs">
		<Div id="divDummy" width="300px" height="160px" style='border:1px solid #CDCDCD;display:none;width:300px;height:160px;background-color:#FFFFFF;overflow:auto'>
		<TABLE  style='width:100%;' cellspacing='0' cellpadding='0' valign='top'>
					<TR>
						<TD  style='background-color:#999999;color:#FFFFFF;height:24px'><div style='width:87%;float:left'>&nbsp;<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%></div> <div><a href='javaScript:onCloseImport()'>[<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>]</a></div></TD>
				   </TR>	
					<TR><TD id='tdContent'>
					 <table class='viewform' width="100%" id='tblSetting' cellspacing='0' cellpadding='0' class='ViewForm' valign='top'>
							 <TR >
							  <TD  style='height:20px;width:30%;valign:top'>&nbsp;<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%></TD>
							  <TD class='field' style='height:20px;width:70%'><button type="button"   class=Browser onClick="onShowMutiDummy(document.getElementById('tdummy'),document.getElementById('spanDummy'))"></button> <input type="hidden" id="tdummy"  name="tdummy"><span id="spanDummy"></span></TD>
							</TR>
							<TR colspan='2' style="height:1px;"><TD  CLASS='line'></TD></TR>						
						</table>
						<br>


						<table class='viewform' id='tblUploading' cellspacing='0' cellpadding='0' valign='top' style='display:none;text-align:center'>
						 <TR>
							<TD id="tdUploading">
								<img src="/images/loading.gif">&nbsp;<%=SystemEnv.getHtmlLabelName(19819,user.getLanguage())%>...	
							</TD>				   
						 </TR>
					 </table>
					
					</TD></TR>
			</TABLE>
		</TD>  
		</TR>      
		</TABLE>
		</Div>

	<script language="javascript">
		function onShowMutiDummy(input,span){
			var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;	
			datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

			if (datas) {
				if (datas.id!= ""){
					dummyidArray=datas.id.split(",");
					dummynames=datas.name.split(",");
					dummyLen=dummyidArray.length;
					sHtml="";
					for(var k=0;k<dummyLen;k++){
						sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a><br>"
					}
					if (sHtml!=""){
						sHtml=sHtml+"<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%>' onclick=doUrl('"+$("#oMoth").val()+"','')>";
					}
					input.value=datas.id;
					$(span).html(sHtml);
				}
				else{			
					input.value="";
					span.innerHTML="";
				}
			}
		}	
	</script>
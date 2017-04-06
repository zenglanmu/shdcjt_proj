<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="ResourceComInfo2" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo2" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo2" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo2" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo2" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo2" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo2" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo2" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo2" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<%WFNodeDtlFieldManager.resetParameter();%>



 <iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%
String selectInitJsStr = "";
    int detailsum=Util.getIntValue(request.getParameter("detailsum"),0);
    String isbill=Util.null2String(request.getParameter("isbill"));
    String needcheck="";
    String formid=Util.null2String(request.getParameter("formid"));
    String nodeid=Util.null2String(request.getParameter("nodeid"));
    String prjid=Util.null2String(request.getParameter("prjid"));
    String docid=Util.null2String(request.getParameter("docid"));
    String hrmid=Util.null2String(request.getParameter("hrmid"));
    String workflowid=Util.null2String(request.getParameter("workflowid"));
    String crmid=Util.null2String(request.getParameter("crmid"));
    String currentdate=Util.null2String(request.getParameter("currentdate"));
    String currenttime=Util.null2String(request.getParameter("currenttime"));
    int detailno=0;
    String textheight = "4";
ArrayList seldefieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
ArrayList changedefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),1);
//TD10029
ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
int fieldop1id=0;
requestPreAddM.setCreater(user.getUID());
requestPreAddM.setOptor(user.getUID());
requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
requestPreAddM.setNodeid(Util.getIntValue(nodeid));
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");
//System.out.println("inoperatefields="+inoperatefields); 
//System.out.println("inoperatevalues="+inoperatevalues);    
    ArrayList defieldids=new ArrayList();             //字段队列
    ArrayList defieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
    ArrayList delanguageids=new ArrayList();          //字段显示的语言(单据文件不需要)
    ArrayList defieldlabels=new ArrayList();          //单据的字段的label队列
    ArrayList defieldhtmltypes=new ArrayList();       //单据的字段的html type队列
    ArrayList defieldtypes=new ArrayList();           //单据的字段的type队列
    ArrayList defieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList defieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
	ArrayList fieldrealtype=new ArrayList();
	ArrayList childfieldids = new ArrayList();			//子字段id队列
    // 确定字段是否显示，是否可以编辑，是否必须输入
    ArrayList isdefieldids=new ArrayList();              //字段队列
    ArrayList isdeviews=new ArrayList();              //字段是否显示队列
    ArrayList isdeedits=new ArrayList();              //字段是否可以编辑队列
    ArrayList isdemands=new ArrayList();              //字段是否必须输入队列
	ArrayList colCalAry = new ArrayList();
	boolean defshowsum=false;
	int fieldlen=0;  //字段类型长度
    String isdeview="0" ;    //字段是否显示
    String isdeedit="0" ;    //字段是否可以编辑
    String isdemand="0" ;    //字段是否必须输入
    String defieldid="";
    String defieldname = "" ;                         //字段数据库表中的字段名
    String defieldhtmltype = "" ;                     //字段的页面类型
    String defieldtype = "" ;                         //字段的类型
    String defieldlable = "" ;                        //字段显示名
	String fielddbtype="";                              //字段数据类型
    int delanguageid = 0 ;
    int colcount1 = 0;
    int colwidth1 = 0;
    String rowCalItemStr1,colCalItemStr1,mainCalStr1;
	rowCalItemStr1 = new String("");
	colCalItemStr1 = new String("");
    mainCalStr1 = new String("");
    //获得触发字段名
	DynamicDataInput ddidetail=new DynamicDataInput(workflowid+"");
	String trrigerdetailfield=ddidetail.GetEntryTriggerDetailFieldName();

    RecordSet billrs=new RecordSet();
    if(isbill.equals("1")){       //单据        支持多明细
              RecordSet.execute("select * from workflow_formdetailinfo where formid="+formid);
				while(RecordSet.next()){
					rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
					mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
                    //System.out.println("colCalItemStr1 = " + colCalItemStr1);
				}
			  StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
              while(stk.hasMoreTokens()){
                colCalAry.add(stk.nextToken());
              }
              billrs.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
              //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
              while(billrs.next()){
                String tablename=billrs.getString("tablename");
                String tabletitle=billrs.getString("title");
                defieldids.clear() ;
                defieldlabels.clear() ;
                defieldhtmltypes.clear() ;
                defieldtypes.clear() ;
                defieldnames.clear() ;
                defieldviewtypes.clear() ;
				fieldrealtype.clear() ;
				childfieldids.clear();
				defshowsum=false;
				colcount1 = 0;

                rs.execute("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"' ORDER BY dsporder");
                //System.out.println("select * from workflow_billfield where viewtype='1' and billid="+formid+" and detailtable='"+tablename+"'");
                while(rs.next()){
                    //String theviewtype = Util.null2String(rs.getString("viewtype")) ;
                    defieldids.add(Util.null2String(rs.getString("id")));
                    defieldlabels.add(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("fieldlabel")),user.getLanguage()));
                    defieldhtmltypes.add(Util.null2String(rs.getString("fieldhtmltype")));
                    defieldtypes.add(Util.null2String(rs.getString("type")));
                    defieldnames.add(Util.null2String(rs.getString("fieldname")));
					fieldrealtype.add(Util.null2String(rs.getString("fielddbtype")));
					childfieldids.add(""+Util.getIntValue(rs.getString("childfieldid"), 0));
                    //defieldviewtypes.add(theviewtype);
                }

                // 确定字段是否显示，是否可以编辑，是否必须输入
                isdefieldids.clear() ;              //字段队列
                isdeviews.clear() ;              //字段是否显示队列
                isdeedits.clear() ;              //字段是否可以编辑队列
                isdemands.clear() ;              //字段是否必须输入队列

                //RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
                rs.execute("SELECT DISTINCT a.*, b.dsporder FROM workflow_nodeform a ,workflow_billfield b where a.fieldid = b.id and b.billid ="+formid+" and a.nodeid="+nodeid+" and b.detailtable='"+tablename+"' ORDER BY b.dsporder");
                while(rs.next()){
                    String thedefieldid = Util.null2String(rs.getString("fieldid")) ;
                    int thefieldidindex = defieldids.indexOf( thedefieldid ) ;
                    if( thefieldidindex == -1 ) continue ;
                    String theisdeview = Util.null2String(rs.getString("isview")) ;
                    if( theisdeview.equals("1") ) {
						colcount1 ++ ;
						if(defshowsum==false){
                        if(colCalAry.indexOf("detailfield_"+thedefieldid)>-1){
                            defshowsum=true;
                        }
						}
					}
                    isdefieldids.add(thedefieldid);
                    isdeviews.add(theisdeview);
                    isdeedits.add(Util.null2String(rs.getString("isedit")));
                    isdemands.add(Util.null2String(rs.getString("ismandatory")));
                }
                
                //获取明细表设置
                WFNodeDtlFieldManager.setNodeid(Integer.parseInt(nodeid));
                WFNodeDtlFieldManager.setGroupid(detailno);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
                String dtldefault = WFNodeDtlFieldManager.getIsdefault();
                String dtlneed = WFNodeDtlFieldManager.getIsneed();
                
                if(colcount1>0){   //明细字段宽度
                    colwidth1 = 97 / colcount1;
					detailsum++;
%>
                <table class=form style="LEFT: 0px; WIDTH: 100%;WORD-WRAP: break-word">

                        <tr><td height=15 colspan=2></td></tr>
                        <tr>
                            <td align="left"><font style="font-size:10pt;"><b><%=tabletitle%></b></font></td>
                            <td align="right">
                            <%if(dtladd.equals("1")){%>
                            <button type=button Class=BtnFlow type=button accessKey=A onclick="addRow<%=detailno%>(<%=detailno%>)"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
                            <%}%>
                            <%if(dtladd.equals("1")||dtldelete.equals("1")){%>
                            <button type=button Class=BtnFlow type=button accessKey=E onclick="deleteRow1(<%=detailno%>);"><U>E</U>-<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></BUTTON>
                            <%}%>

                            </td>
                        </tr>
                        <tr>
                            <td colspan=2>
<div id="workflowDetailArea">
                            <table Class=ListStyle id="oTable<%=detailno%>" >
                              <COLGROUP>
                              <TBODY>
                              <tr class=header>
                                <td width="3%">　</td>
								<td width="3%"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
                   <%
                       ArrayList viewfieldnames = new ArrayList();

                       // 得到每个字段的信息并在页面显示

                       int detailfieldcount = -1;
					   int isfieldidindex = -1;
                       for (int i = 0; i < defieldids.size(); i++) {         // 循环开始

                           defieldid=(String)defieldids.get(i);  //字段id
                           isfieldidindex = isdefieldids.indexOf(defieldid) ;
                           if( isfieldidindex != -1 ) {
                        	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                        	   isdeedit=(String)isdeedits.get(isfieldidindex);    //字段是否可以编辑
                        	   isdemand=(String)isdemands.get(isfieldidindex);    //字段是否必须输入
                           }
                		   defieldlable =(String)defieldlabels.get(i);
                		   defieldname = (String)defieldnames.get(i);
                		   defieldhtmltype = (String) defieldhtmltypes.get(i);

                		  if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环


                           viewfieldnames.add(defieldname);
                   %>
                                <td width="<%=colwidth1%>%" nowrap align="center"><%=defieldlable%></td>
                           <%
                       }
                    %>
                              </tr>
                              </TBODY>
							  <%if(defshowsum){%>
                              <TFOOT>
                              <TR class=header>
						        <TD ></TD>
                                <TD ><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
                <%
                    for (int i = 0; i < defieldids.size(); i++) {
						isfieldidindex = isdefieldids.indexOf((String)defieldids.get(i)) ;
                        if ((isfieldidindex != -1 && !isdeviews.get(isfieldidindex).equals("1")) || isfieldidindex == -1) {
                %>
                                <td width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="display:none"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                            <%
                        } else {
                            %>
                                <td align="right" width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="color:red"></td>
                                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                                    <%
                        }
                    }
                                    %>
                              </TR>
                              </TFOOT>
							  <%}%>
                            </table>
</div>
                            </td>
                        </tr>

                </table>
                <input type='hidden' id="nodesnum<%=detailno%>" name="nodesnum<%=detailno%>" value="0">
                <input type='hidden' id="indexnum<%=detailno%>" name="indexnum<%=detailno%>" value="0">
                <input type='hidden' id="rowneed<%=detailno%>" name="rowneed<%=detailno%>" value="<%=dtlneed %>">
				<input type='hidden' id="submitdtlid<%=detailno%>" name="submitdtlid<%=detailno%>" value="">
                <script language=javascript>
                function addRow<%=detailno%>(obj)
                {
                        var oTable=$GetEle('oTable'+obj);
                        var initDetailfields="";
                        curindex = parseInt($G('nodesnum'+obj).value);
                        rowindex = parseInt($G('indexnum'+obj).value);
                        if($G('submitdtlid' + obj).value == ''){
                            $G('submitdtlid' + obj).value = rowindex;
                        }else{
                            $G('submitdtlid' + obj).value += "," + rowindex;
                        }
                        
                        //oRow = oTable.insertRow(curindex + 1);
                        oRow = document.createElement("TR");
                        jQuery(oTable).append(oRow);
                        //oCell = oRow.insertCell();
                        oCell = document.createElement("TD");
                        jQuery(oRow).append(oCell);
                        jQuery(oCell).css("height", 24);
                        //oCell.style.background= "#E7E7E7";
                        //oCell.style.word-wrap= "normal";
						jQuery(oCell).css("word-wrap", "break-word");
						jQuery(oCell).css("wordBreak", "break-all");

                        var oDiv = document.createElement("div");
                        var sHtml = "<input type='checkbox' name='check_node" + obj + "' value='" + rowindex + "'>";

                        oDiv.innerHTML = sHtml;
                        jQuery(oCell).append(oDiv);
						//oCell = oRow.insertCell();
						oCell = document.createElement("TD");
						jQuery(oRow).append(oCell);
						jQuery(oCell).css("height", 24);
						jQuery(oCell).css("background", "#E7E7E7");
						//oCell.style.word-wrap= "normal";
						jQuery(oCell).css("word-wrap", "break-word");
						jQuery(oCell).css("wordBreak", "break-all");

						var oDivxh = document.createElement("div");
					 
						//var sHtmlxh = curindex+1;
					   
						oDivxh.innerHTML = curindex + 1;
						jQuery(oCell).append(oDivxh);


                <%
                try{
                	selectInitJsStr = "";
                	isfieldidindex = -1;
                    for (int i = 0; i < defieldids.size(); i++) {         // 循环开始

                        String fieldhtml = "";
                         defieldid = (String) defieldids.get(i);  //字段id
                         //System.out.println("fieldid:"+defieldid);

                         isfieldidindex = isdefieldids.indexOf(defieldid) ;
                         if( isfieldidindex != -1 ) {
                      	   isdeview=(String)isdeviews.get(isfieldidindex);    //字段是否显示
                      	   isdeedit=(String)isdeedits.get(isfieldidindex);    //字段是否可以编辑
                      	   isdemand=(String)isdemands.get(isfieldidindex);    //字段是否必须输入
                         }


                        if (!isdeview.equals("1")) continue;           //不显示即进行下一步循环

String preAdditionalValue = "";
boolean isSetFlag = false;
//明细字段如果有节点前附加操作，取初始值 myq 2007.12.28 start
int inoperateindex=inoperatefields.indexOf(defieldid);
if(inoperateindex>-1){
	isSetFlag = true;
	preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
}
//明细字段如果有节点前附加操作，取初始值 myq 2007.12.28 end
						
                         defieldname = "";                         //字段数据库表中的字段名
                         defieldhtmltype = "";                     //字段的页面类型
                        defieldtype = "";                         //字段的类型
                         defieldlable = "";                        //字段显示名
						 defieldlable =(String)defieldlabels.get(i);
                        delanguageid = user.getLanguage();
                        defieldname = (String) defieldnames.get(i);
                        defieldhtmltype = (String) defieldhtmltypes.get(i);
                        defieldtype = (String) defieldtypes.get(i);
						fielddbtype=(String)fieldrealtype.get(i);
						  fieldlen=0;
							if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
							{
							   fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

							}

                        if (isdemand.equals("1"))
                          needcheck += ",field" + defieldid + "_\"+rowindex+\"";   //如果必须输入,加入必须输入的检查中

                        // 下面开始逐行显示字段
						String trrigerdetailStr = "";
						if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
							trrigerdetailStr = "datainputd(field" + defieldid + "_\"+rowindex+\")";
						}
                        if (defieldhtmltype.equals("1")) {                          // 单行文本框
                            if (defieldtype.equals("1")) {                          // 单行文本框中的文本
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {


                                        fieldhtml = "<input class=inputstyle zdatatype='text' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=15 onChange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle datatype='text' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\" type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='' size=15><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    //fieldhtml += "<input class=inputstyle datatype='text' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                                }
                            } else if (defieldtype.equals("2")) {              // 单行文本框中的整型
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {

                                        fieldhtml = "<input class=inputstyle datatype='int' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=5 onKeyPress='ItemCount_KeyPress()' onChange='checkcount1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {

                                        fieldhtml = "<input class=inputstyle datatype='int' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' datatype='float' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=5 onKeyPress='ItemCount_KeyPress()' onChange='checkcount1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    //fieldhtml += "<input class=inputstyle datatype='int' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle datetype='int' type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                                }
                            } else if (defieldtype.equals("3")||defieldtype.equals("5")) {                     // 单行文本框中的浮点型
                            	int decimaldigits_t = 2;
                		    	if(defieldtype.equals("3")){
                		    		int digitsIndex = fielddbtype.indexOf(",");
                		        	if(digitsIndex > -1){
                		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
                		        	}else{
                		        		decimaldigits_t = 2;
                		        	}
                		    	}
                		    	String datavaluetype = "";
										    	if(defieldtype.equals("5")){
										    		datavaluetype = " datavaluetype='5'";
										    	}
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input class=inputstyle datetype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += datavaluetype +" onfocus='changeToNormalFormat(this.name)' onblur='changeToThousands(this.name)' ";
                                        fieldhtml += " onChange='checknumber1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");".concat(trrigerdetailStr).concat("'><span id='field") + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle datetype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += datavaluetype +" onfocus='changeToNormalFormat(this.name)' onblur='changeToThousands(this.name)' ";
                                        fieldhtml += " onChange='checknumber1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    //fieldhtml += "<input class=inputstyle datetype='float' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle "+ datavaluetype +" datetype='float' type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                                }
                            }else if (defieldtype.equals("4")) {                     // 单行文本框中的金额转换型
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input class=inputstyle value='"+preAdditionalValue+"' datetype='float' type=text id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemNum_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"')\\\"  onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" onBlur=\\\"numberToChinese('" + defieldid + "_\"+rowindex+\"');calSum("+detailno+")\\\" onChange='checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));"+trrigerdetailStr+"'>";
                                        //if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        //fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle value='"+preAdditionalValue+"' datetype='float' type=text id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemNum_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"')\\\"  onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" onBlur=\\\"numberToChinese('" + defieldid + "_\"+rowindex+\"');calSum("+detailno+")\\\" onChange='checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));"+trrigerdetailStr+"'>";
                                    }
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if(isdemand.equals("1")&&"".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                    fieldhtml += "</span><input class=inputstyle datetype='float' viewtype='"+isdemand+"' type=hidden temptitle='"+defieldlable+"' value='"+preAdditionalValue+"' id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    fieldhtml += "<input class=inputstyle size=30 value='"+preAdditionalValue+"' datetype='float' type=text  disabled='true' id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'></span><input class=inputstyle datetype='float' type=hidden value='"+preAdditionalValue+"' id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            }
                        }                                                       // 单行文本框条件结束
                        else if (defieldhtmltype.equals("2")) {                     // 多行文本框
                            if (isdeedit.equals("1")) {
                            	if(isbill.equals("0")){
                      				rscount.executeSql("select * from workflow_formdictdetail where id = " + defieldid);
                      				if(rscount.next()){
                      					textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
                      				}
                       			}else{
                        			rscount.executeSql("select * from workflow_billfield where viewtype=1 and id = " + defieldid+" and billid="+formid);
                        			if(rscount.next()){
                        				textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
                        			}
                        		}
                                if (isdemand.equals("1")) {
                                    fieldhtml = "<textarea class=inputstyle viewtype='"+isdemand+"' value='"+preAdditionalValue+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' onChange=\\\"checkinput3(field" +defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype); checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" rows='"+textheight+"' cols='150' style='width:100%'>"+preAdditionalValue+"</textarea><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                    fieldhtml += "</span>";
                                } else {
                                    fieldhtml = "<textarea class=inputstyle viewtype='"+isdemand+"' value='"+preAdditionalValue+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" +defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" name='field" + defieldid + "_\"+rowindex+\"' rows='"+textheight+"' cols='150' style='width:100%'>"+preAdditionalValue+"</textarea><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                }
                                if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                            } else {
                                //fieldhtml = "<textarea class=inputstyle name='field" + defieldid + "_\"+rowindex+\"' rows='4' cols='150' style='width:100%' readonly></textarea>";
                                fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle type=hidden name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                            }
                        }                                                           // 多行文本框条件结束
                        else if (defieldhtmltype.equals("3")) {                         // 浏览按钮 (涉及workflow_broswerurl表)
                            String url = BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                            String linkurl = BrowserComInfo2.getLinkurl(defieldtype);    // 浏览值点击的时候链接的url
                            String showname = "";                                   // 新建时候默认值显示的名称
                            String showid = "";                                     // 新建时候默认值

                            if ((defieldtype.equals("8") || defieldtype.equals("135")) && !prjid.equals("")) {       //浏览按钮为项目,从前面的参数中获得项目默认值
                                showid = "" + Util.getIntValue(prjid, 0);
                            } else if ((defieldtype.equals("9") || defieldtype.equals("37")) && !docid.equals("")) { //浏览按钮为文档,从前面的参数中获得文档默认值
                                showid = "" + Util.getIntValue(docid, 0);
                            } else if ((defieldtype.equals("1") || defieldtype.equals("17")|| defieldtype.equals("165")|| defieldtype.equals("166")) && !hrmid.equals("")) { //浏览按钮为人,从前面的参数中获得人默认值
                                showid = "" + Util.getIntValue(hrmid, 0);
                            } else if ((defieldtype.equals("7") || defieldtype.equals("18")) && !crmid.equals("")) { //浏览按钮为CRM,从前面的参数中获得CRM默认值
                                showid = "" + Util.getIntValue(crmid, 0);
                            } else if ((defieldtype.equals("4") || defieldtype.equals("57") || defieldtype.equals("167") || defieldtype.equals("168")) && !hrmid.equals("")) { //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                                showid = "" + Util.getIntValue(ResourceComInfo2.getDepartmentID(hrmid), 0);
                            } else if (defieldtype.equals("24") && !hrmid.equals("")) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                showid = "" + Util.getIntValue(ResourceComInfo2.getJobTitle(hrmid), 0);
                            } else if (defieldtype.equals("32") && !hrmid.equals("")) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"), 0);
                            }else if((defieldtype.equals("164") || defieldtype.equals("169") || defieldtype.equals("170")) && !hrmid.equals("")){ //浏览按钮为分部,		从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
								showid = "" + Util.getIntValue(ResourceComInfo2.getSubCompanyID(hrmid),0);
						    }else if(defieldtype.equals("226")||defieldtype.equals("227")){
								//zzl普通模板解析主表字段的"集成浏览按钮"
								//拼接?type=browser.267|11266
								url+="?type="+fielddbtype+"|"+defieldid;	
							}

                            if (showid.equals("0")) showid = "";
            if(isSetFlag){
	            showid = preAdditionalValue;
	           }
                            if (!showid.equals("")) {       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                                if(defieldtype.equals("8") || defieldtype.equals("135")){
                                    //项目，多项目
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("1") ||defieldtype.equals("17")||defieldtype.equals("165")||defieldtype.equals("166")){
                                    //人员，多人员
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                          	{
                                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                          	}
                                        	else
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                    //客户，多客户
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                    //部门，多部门
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo2.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=DepartmentComInfo2.getDepartmentname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("9") || defieldtype.equals("37")){
                                    //文档，多文档
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo2.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=DocComInfo2.getDocname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("23")){
                                    //资产
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("16")){
                                    //相关请求
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("161")||defieldtype.equals("162")){
									Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
				                    for(int k=0;k<tempshowidlist.size();k++){
										try{
				                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
				                            String desc=Util.null2String(bb.getDescription());
				                            String name=Util.null2String(bb.getName());							
				                            String href=Util.null2String(bb.getHref());
				                            if(href.equals("")){
				                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
				                            }else{
				                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
				                            }
										}catch (Exception e){
										}
				                    }
                                }else if(defieldtype.equals("226")||defieldtype.equals("227")){
											 //zzl--集成字段新建的时候赋予默认值
											showname+=preAdditionalValue;
                                }
                                
                                else{
                                    String tablename2 = BrowserComInfo2.getBrowsertablename(defieldtype);
                                    String columname = BrowserComInfo2.getBrowsercolumname(defieldtype);
                                    String keycolumname = BrowserComInfo2.getBrowserkeycolumname(defieldtype);
                                    if(!tablename2.equals("")&&!columname.equals("")&&!keycolumname.equals("")){
                                    String sql = "select " + columname + " from " + tablename2 + " where " + keycolumname + "=" + showid;

                                    RecordSet.executeSql(sql);
                                    if (RecordSet.next()) {
                                        if (!linkurl.equals(""))
                                            showname = "<a href='" + linkurl + showid + "'  target='_new'>" + RecordSet.getString(1) + "</a>&nbsp";
                                        else
                                            showname = RecordSet.getString(1);
                                    }
                                    }
                                }
                            }

                            if (defieldtype.equals("2")) {                              // 浏览按钮为日期
                                //showname = currentdate;
                                //showid = currentdate;
                                if(!isSetFlag){
                                    showname = currentdate;
                                    showid = currentdate;
                                }else{
                                    showname=preAdditionalValue;
                                    showid=preAdditionalValue;
                                }
                            }
							if (defieldtype.equals("19")) {                              // 浏览按钮为时间
                              //showname = currenttime.substring(0,5);
                              //showid = currenttime.substring(0,5);
                              if(!isSetFlag){
                                  showname = currenttime.substring(0,5);
                                  showid = currenttime.substring(0,5);
                              }else{
                                  showname=preAdditionalValue;
                                  showid=preAdditionalValue;
                              }
                            }
							if (defieldtype.equals("161")||defieldtype.equals("162")) {                              //自定义浏览框
				                                url+="?type="+fielddbtype;
				               }
                            if (isdeedit.equals("1")) {
                                //System.out.println("url = " + url);
                                if (!defieldtype.equals("37")) {    //  多文档特殊处理
                                    if (trrigerdetailfield.indexOf("field"+defieldid)>=0)
									{
                                    fieldhtml = "<button type=button class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));datainputd('field" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									}
									else
									{ 
									if(defieldtype.equals("2")){
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowFlowDate('" + defieldid + "_\"+rowindex+\"','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									}else if(defieldtype.equals("19")){
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowFlowTime(field" + defieldid + "_\"+rowindex+\"span, field" + defieldid + "_\"+rowindex+\" ,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									 }else{
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									 }
								    }
                                } else {                         // 如果是多文档字段,加入新建文档按钮
                                    fieldhtml = "<button type=button class=AddDocFlow onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>&nbsp;&nbsp<button type=button class=AddDocFlow onclick=\\\"onNewDoc('" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                                }
                            }
                            fieldhtml += "<input type=hidden viewtype='"+isdemand+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' value='" + showid + "' ";
                            if(trrigerdetailfield.indexOf("field"+defieldid)>=0){
                            	fieldhtml += " onpropertychange=\\\"datainputd('field" + defieldid + "_\"+rowindex+\"');\\\" ";
                            }
                            fieldhtml += "><span id='field" + defieldid + "_\"+rowindex+\"span'>" + Util.toScreen(showname, user.getLanguage());

                            if (isdemand.equals("1") && showname.equals("")) {
                                fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                            }
                            fieldhtml += "</span>";
                            if(defieldtype.equals("87")){
                                fieldhtml += "&nbsp;&nbsp;<A href='/meeting/report/MeetingRoomPlan.jsp' target='blank'>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>";
                            }
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                        }                                                       // 浏览按钮条件结束
                        else if (defieldhtmltype.equals("4")) {                    // check框
                            if("1".equals(isdemand)){
                                fieldhtml += "<input class=inputstyle viewtype='"+isdemand+"' type=checkbox name='field" + defieldid + "_\"+rowindex+\"' value=1 onclick='checkboxCheck(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span)' ";
                                if("1".equals(preAdditionalValue)) fieldhtml += " checked ";
                                fieldhtml +="><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                if(!"1".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                fieldhtml += "</span>";
                            }else{
                                fieldhtml += "<input class=inputstyle type=checkbox name='field" + defieldid + "_\"+rowindex+\"' value=1";
                                if("1".equals(preAdditionalValue)) fieldhtml += " checked ";
	
                                if (isdeedit.equals("0")) fieldhtml += " DISABLED ";
	
                                fieldhtml += ">";
                            }
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                            }
                        }                                                       // check框条件结束
                        else if (defieldhtmltype.equals("5")) {                     // 选择框   select
                        	//处理select字段联动
                         	String onchangeAddStr = "";
                        	int childfieldid_tmp = Util.getIntValue((String)childfieldids.get(i), 0);
                        	if(childfieldid_tmp != 0){
            	        		onchangeAddStr = ";changeChildFieldDetail(this,"+defieldid+","+childfieldid_tmp+",\"+rowindex+\")";
            	        	}
                        	boolean hasPfield = false;
                        	int firstPfieldid_tmp = 0;
                        	if(childfieldids.contains(defieldid)){
                        		firstPfieldid_tmp = Util.getIntValue((String)defieldids.get(childfieldids.indexOf(defieldid)), 0);
                        		hasPfield = true;
                        	}
                            if("1".equals(isdemand)){
                                fieldhtml += "<select class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"'";
                            }else{
                                fieldhtml += "<select class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"'";
                            }
                            if(seldefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);changeshowattr('"+defieldid+"_1',this.value,\"+rowindex+\","+workflowid+","+nodeid+");"+trrigerdetailStr+onchangeAddStr+" ";
                            }else{
                                fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);"+trrigerdetailStr+onchangeAddStr+" ";
                            }
                            if (isdeedit.equals("0")){
                                fieldhtml += " name='disfield" + defieldid + "_\"+rowindex+\"' DISABLED ";
                            }else{
                                fieldhtml += " name='field" + defieldid + "_\"+rowindex+\"' ";
                            }
                            fieldhtml += ">";
                            fieldhtml += "<option value=''></option>";//added by xwj for td3297 20051130
                            // 查询选择框的所有可以选择的值
                            char flag = Util.getSeparator();
                            boolean checkemptydetail = true;
                            String finalvaluedetail = "";
                            if(hasPfield==false || isdeedit.equals("0")){
                            	rs.executeProc("workflow_selectitembyid_new", "" + defieldid + flag + isbill);
	                            while (rs.next()) {
	                                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
	                            
	                                String tmpselectname = Util.toScreen(rs.getString("selectname"), user.getLanguage());
	                            
	                                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());
	                                if("".equals(preAdditionalValue)){
	                                    if("y".equals(isdefault)){
	                                        checkemptydetail = false;
	                                        finalvaluedetail = tmpselectvalue;
	                                        fieldhtml += "<option value='" + tmpselectvalue + "' selected>" + tmpselectname + "</option>";
	                                    }else{
	                                        fieldhtml += "<option value='" + tmpselectvalue + "'>" + tmpselectname + "</option>";
	                                    }
	                                }
	                                else{
	                                    checkemptydetail = false;
	                                    fieldhtml += "<option value='" + tmpselectvalue + "'";
	                                    if(tmpselectvalue.equals(preAdditionalValue)) fieldhtml += "selected";
	                                    fieldhtml += ">" + tmpselectname + "</option>";
	                                }
	                            
	                            }
                            }else{
                	            rs.executeProc("workflow_SelectItemSelectByid", "" + defieldid + flag + isbill);
                	            while (rs.next()) {
                	                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                	//                System.out.println("tmpselectvalue="+tmpselectvalue);
                	                String tmpselectname = Util.toScreen(rs.getString("selectname"), user.getLanguage());
                	                /* -------- xwj for td2977 20051107 begin ----*/
                	                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());
                	                if("".equals(preAdditionalValue)){
                		                if("y".equals(isdefault)){
                			                checkemptydetail = false;
                			                finalvaluedetail = tmpselectvalue;
                			              }
                	                }else{
                	                	checkemptydetail = false;
                	                	finalvaluedetail = preAdditionalValue;
                	                }
                	            }
                            	selectInitJsStr += "doInitDetailchildSelect("+defieldid+","+firstPfieldid_tmp+",rowindex,\""+finalvaluedetail+"\");";
                            }
                            fieldhtml += "</select><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                            if(isdemand.equals("1") && checkemptydetail){
                                fieldhtml +="<img src='/images/BacoError.gif' align=absmiddle>";
                            }
                            fieldhtml +="</span>";
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                            }
                            if (isdeedit.equals("0")){
                                fieldhtml += "<input type=hidden name='field" + defieldid + "_\"+rowindex+\"' value='" + preAdditionalValue + "'>";
                            }
                            
                        }                                          // 选择框条件结束 所有条件判定结束
                %>


                        //oCell = oRow.insertCell();
                        oCell = document.createElement("TD");
                        jQuery(oRow).append(oCell);
                        jQuery(oCell).css("height", 24);
                        jQuery(oCell).css("background", "#E7E7E7");
                        jQuery(oCell).css("word-wrap", "break-word");
                        jQuery(oCell).css("word-break", "break-all");

                        var oDiv = document.createElement("div");
                        var sHtml = "<%=fieldhtml%>" ;
                        //alert(sHtml);
                        oDiv.innerHTML = sHtml;
                        jQuery(oCell).append(oDiv);
                        <%
                        if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
                        %>
                        //datainputd("field<%=defieldid%>_"+rowindex);
                        initDetailfields += "field<%=defieldid%>_"+rowindex+",";
                        <%
                        }
                        if(seldefieldsadd.indexOf(defieldid)>=0){
                        %>
                        changeshowattr('<%=defieldid%>_1',$G('field<%=defieldid%>_'+rowindex).value,rowindex,'<%=workflowid%>','<%=nodeid%>');
                        <%
                        }
                			//System.out.println("field type:"+fieldtype);
                    }       // 循环结束
                    }catch(Exception e){}
                %>
                	try
                	{
	                    if ("<%=needcheck%>" != ""){
	                    	$GetEle("needcheck").value += "<%=needcheck%>";
	                    }
	                    datainputd(initDetailfields);
						<%=selectInitJsStr%>
					}
					catch(e)
					{
						
					}
                    rowindex = rowindex*1 +1;
                    curindex = curindex*1 +1;
                    $GetEle("nodesnum"+obj).value = curindex ;
                    $GetEle('indexnum'+obj).value = rowindex;
                    calSum(obj);
                }
                <%
				if(dtldefault.equals("1"))
				{
				%>
				jQuery(document).ready(function () {
					addRow<%=detailno%>(<%=detailno%>);
				});
				<%	
				}
				%>
              </script>
<%
                }   //if end
                detailno++;
              }     //多明细循环结束
%>
<script language=javascript>
function deleteRow1(obj)
{
    var flag = false;
	var ids = document.getElementsByName('check_node'+obj);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            var oTable=$GetEle('oTable'+obj);
            curindex=parseInt($G("nodesnum"+obj).value);
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj)
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj){
                    if(document.forms[0].elements[i].checked==true) {
                    	var delid;
                        if(oTable.rows[rowsum1].cells[0].children.length>1){
                            delid=oTable.rows[rowsum1].cells[0].children[0].value;
                        }else{
                            delid=oTable.rows[rowsum1].children[1].value;
                        }
                        var submitdtlidArray=$G("submitdtlid"+obj).value.split(',');
                        $G("submitdtlid"+obj).value="";
                        var k;
                        for(k=0; k<submitdtlidArray.length; k++){
                            if(submitdtlidArray[k]!=delid){
                                if($G("submitdtlid"+obj).value=='')
                                    $G("submitdtlid"+obj).value = submitdtlidArray[k];
                                else
                                    $G("submitdtlid"+obj).value += ","+submitdtlidArray[k];
                            }
                        }
                        oTable.deleteRow(rowsum1);
                        curindex--;
                    }
                    rowsum1 -=1;

                }
            }
            var rows = oTable.rows.length ;
            for(i=1; i < rows;i++){
                if(oTable.rows(i).cells(1).innerText!="<%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>"){
                    oTable.rows(i).cells(1).children(0).innerText=i;
                }
            }

            $G("nodesnum"+obj).value=curindex;
            calSum(obj);
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }

}

</script>
<%
    }           //单据结束
    else{       //表单    支持多明细
                //得到计算公式的字符串
                detailno=0;
				RecordSet.executeProc("Workflow_formdetailinfo_Sel",formid+"");
				while(RecordSet.next()){
					rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
					colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
					mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
                    //System.out.println("rowCalItemStr1 = " + rowCalItemStr1);
				}
				StringTokenizer stk = new StringTokenizer(colCalItemStr1,";");
                while(stk.hasMoreTokens()){
                    colCalAry.add(stk.nextToken());
                }
                // 要进行制动获取的字段

                //autoGetIndex[0] = 1;
                //autoGetIndex[1] = 2;
                //autoGetIndex[2] = 3;
                //autoGetIndex[3] = 5;
				//Clone the ArrayList Objects
                int groupId=0;
                RecordSet formrs=new RecordSet();
				formrs.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
                //out.print("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1'");
                while (formrs.next())
                {
                groupId=formrs.getInt(1);

                defieldids.clear();
                defieldlabels.clear();
                defieldhtmltypes.clear();
                defieldtypes.clear();
                defieldnames.clear();
                defieldviewtypes.clear();
                fieldrealtype.clear();
                childfieldids.clear();

				  // 确定字段是否显示，是否可以编辑，是否必须输入
                isdefieldids.clear();              //字段队列
                isdeviews.clear();              //字段是否显示队列
                isdeedits.clear();              //字段是否可以编辑队列
                isdemands.clear();              //字段是否必须输入队列
                defshowsum=false;
                colcount1=0;
				Integer language_id = new Integer(user.getLanguage());
				//System.out.println(formid+Util.getSeparator()+nodeid);


                RecordSet.executeProc("Workflow_formdetailfield_Sel",""+formid+Util.getSeparator()+nodeid+Util.getSeparator()+groupId);
                while (RecordSet.next()) {

					 if(language_id.toString().equals(Util.null2String(RecordSet.getString("langurageid"))))
						{
						defieldids.add(Util.null2String(RecordSet.getString("fieldid")));
						defieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
						defieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
						defieldtypes.add(Util.null2String(RecordSet.getString("type")));
						isdeviews.add(Util.null2String(RecordSet.getString("isview")));
						isdeedits.add(Util.null2String(RecordSet.getString("isedit")));
						isdemands.add(Util.null2String(RecordSet.getString("ismandatory")));
						defieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
						fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
						childfieldids.add(""+Util.getIntValue(RecordSet.getString("childfieldid"), 0));
                        if(Util.null2String(RecordSet.getString("isview")).equals("1")){
                        colcount1 ++ ;
						if(defshowsum==false){
                        if(colCalAry.indexOf("detailfield_"+Util.null2String(RecordSet.getString("fieldid")))>-1){
                            defshowsum=true;
                        }
                        }
                        }
                        }
                }

                //获取明细表设置
                WFNodeDtlFieldManager.setNodeid(Integer.parseInt(nodeid));
                WFNodeDtlFieldManager.setGroupid(groupId);
                WFNodeDtlFieldManager.selectWfNodeDtlField();
                String dtladd = WFNodeDtlFieldManager.getIsadd();
                String dtledit = WFNodeDtlFieldManager.getIsedit();
                String dtldelete = WFNodeDtlFieldManager.getIsdelete();
                String dtldefault = WFNodeDtlFieldManager.getIsdefault();
                String dtlneed = WFNodeDtlFieldManager.getIsneed();

        if(colcount1!=0){
            colwidth1=97/colcount1;
			detailsum++;
%>

<table class=form style="LEFT: 0px; WIDTH: 100%;WORD-WRAP: break-word">

        <tr><td height=15 colspan=2></td></tr>
        <tr>
            <td align="right">
            <%if(dtladd.equals("1")){%>
                <button type=button Class=BtnFlow type=button accessKey=A onclick="addRow<%=detailno%>(<%=detailno%>,<%=groupId%>)"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <%}
            if(dtladd.equals("1") || dtldelete.equals("1")){%>
                <button type=button Class=BtnFlow type=button accessKey=E onclick="deleteRow1(<%=detailno%>,<%=groupId%>);"><U>E</U>-<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></BUTTON>
            <%}%>
            </td>
        </tr>
        <tr>
            <td colspan=2>
<div id="workflowDetailArea">
            <table Class=ListStyle id="oTable<%=detailno%>" >
              <COLGROUP>
              <TBODY>
              <tr class=header>
                <td width="3%">　</td>
				<td width="3%"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
   <%
       ArrayList viewfieldnames = new ArrayList();

       // 得到每个字段的信息并在页面显示

       int detailfieldcount = -1;
       for (int i = 0; i < defieldids.size(); i++) {         // 循环开始

           defieldid=(String)defieldids.get(i);  //字段id
       	   isdeview=(String)isdeviews.get(i);    //字段是否显示
       	   isdeedit=(String)isdeedits.get(i);    //字段是否可以编辑
       	   isdemand=(String)isdemands.get(i);    //字段是否必须输入
		   defieldlable =(String)defieldlabels.get(i);
		   defieldname = (String)defieldnames.get(i);
		   defieldhtmltype = (String) defieldhtmltypes.get(i);
		  if( ! isdeview.equals("1") ) continue;  //不显示即进行下一步循环

           viewfieldnames.add(defieldname);
   %>
                <td width="<%=colwidth1%>%" nowrap align="center"><%=defieldlable%></td>
           <%
       }
    %>
              </tr>
              </TBODY>
		 	  <%if(defshowsum){%>
              <TFOOT>
              <TR class=header>
		       <td></td>
                <TD ><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
<%
    for (int i = 0; i < defieldids.size(); i++) {
        if (!isdeviews.get(i).equals("1")) {
%>
                <td width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="display:none"></td>
                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
            <%
        } else {
            %>
                <td align="right" width="<%=colwidth1%>%" id="sum<%=defieldids.get(i)%>" style="color:red"></td>
                <input type="hidden" name="sumvalue<%=defieldids.get(i)%>" >
                    <%
        }
    }
                    %>
              </TR>
              </TFOOT>
			  <%}%>
            </table>
</div>
            
            </td>
        </tr>

</table>
<input type='hidden' id="nodesnum<%=detailno%>" name="nodesnum<%=detailno%>" value="0">
<input type='hidden' id="indexnum<%=detailno%>" name="indexnum<%=detailno%>" value="0">
<input type='hidden' id="rowneed<%=detailno%>" name="rowneed<%=detailno%>" value="<%=dtlneed %>">
<input type='hidden' id="submitdtlid<%=groupId%>" name="submitdtlid<%=groupId%>" value="">
<input type='hidden' name=colcalnames value="<%=colCalItemStr1%>">

<script language=javascript>
function addRow<%=detailno%>(obj,groupId)
{
        var oTable=$GetEle('oTable'+obj);
        var initDetailfields="";
        curindex=parseInt($G('nodesnum'+obj).value);
        rowindex=parseInt($G('indexnum'+obj).value);
        if($G('submitdtlid'+groupId).value==''){
            $G('submitdtlid'+groupId).value=rowindex;
        }else{
            $G('submitdtlid'+groupId).value+=","+rowindex;
        }
        //alert(curindex+"|"+rowindex);
        oRow = document.createElement("TR");
        //oRow = oTable.insertRow(curindex+1);
		jQuery(oTable).append(oRow);

        //oCell = oRow.insertCell();
        oCell = document.createElement("TD");
        jQuery(oRow).append(oCell);
        oCell.style.height=24;
        //oCell.style.background= "#CCFFCC";
        //oCell.style.word-wrap= "normal";
		oCell.style.wordWrap= "break-word";
		oCell.style.wordBreak= "break-all";

        var oDiv = document.createElement("div");
     
        var sHtml = "<input type='checkbox' name='check_node"+obj+"' value='"+rowindex+"'>";
        sHtml += "<input type='hidden' name='dtl_id_"+obj+"' value=''>";

        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);

        //oCell = oRow.insertCell();
        oCell = document.createElement("TD");
        jQuery(oRow).append(oCell);
        oCell.style.height=24;
        oCell.style.background= "#E7E7E7";
        //oCell.style.word-wrap= "normal";
		oCell.style.wordWrap= "break-word";
		oCell.style.wordBreak= "break-all";

        var oDivxh = document.createElement("div");
     
        //var sHtmlxh = curindex+1;
       

        oDivxh.innerHTML = curindex+1;
        oCell.appendChild(oDivxh);

<%

try{
	selectInitJsStr = "";
    for (int i = 0; i < defieldids.size(); i++) {         // 循环开始
String preAdditionalValue = "";
boolean isSetFlag = false;
        String fieldhtml = "";
         defieldid = (String) defieldids.get(i);  //字段id
         //System.out.println("fieldid:"+defieldid);
		fieldlen=0;
		fielddbtype=(String)fieldrealtype.get(i);
		if ((fielddbtype.toLowerCase()).indexOf("varchar")>-1)
			{
				fieldlen=Util.getIntValue(fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.length()-1));

			}
     	   isdeview=(String)isdeviews.get(i);    //字段是否显示
     	   isdeedit=(String)isdeedits.get(i);    //字段是否可以编辑
     	   isdemand=(String)isdemands.get(i);    //字段是否必须输入


        if (!isdeview.equals("1")) continue;           //不显示即进行下一步循环
//明细字段如果有节点前附加操作，取初始值 myq 2007.12.28 start
int inoperateindex=inoperatefields.indexOf(defieldid);
if(inoperateindex>-1){
	isSetFlag = true;
	preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
}
//明细字段如果有节点前附加操作，取初始值 myq 2007.12.28 end
         defieldname = "";                         //字段数据库表中的字段名
         defieldhtmltype = "";                     //字段的页面类型
        defieldtype = "";                         //字段的类型
         defieldlable = "";                        //字段显示名
		 defieldlable =(String)defieldlabels.get(i);
        delanguageid = user.getLanguage();
        defieldname = (String) defieldnames.get(i);
        defieldhtmltype = (String) defieldhtmltypes.get(i);
        defieldtype = (String) defieldtypes.get(i);

        if (isdemand.equals("1"))
          needcheck += ",field" + defieldid + "_\"+rowindex+\"";   //如果必须输入,加入必须输入的检查中

        // 下面开始逐行显示字段
						String trrigerdetailStr = "";
						if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
							trrigerdetailStr = "datainputd(field" + defieldid + "_\"+rowindex+\")";
						}
        if (defieldhtmltype.equals("1")) {                          // 单行文本框
            if (defieldtype.equals("1")) {                          // 单行文本框中的文本
                if (isdeedit.equals("1")) {
                    if (isdemand.equals("1")) {

                                        fieldhtml = "<input class=inputstyle zdatatype='text' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=15 onChange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\"><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                    } else {
                                        fieldhtml = "<input class=inputstyle datatype='text' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLength('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"');"+trrigerdetailStr+"\\\" type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='' size=15><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                    }
                    if(changedefieldsadd.indexOf(defieldid)>=0){
                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                    }
                } else {
                    //fieldhtml += "<input class=inputstyle datatype='text' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                }
            } else if (defieldtype.equals("2")) {              // 单行文本框中的整型
                if (isdeedit.equals("1")) {
                    if (isdemand.equals("1")) {

                                        fieldhtml = "<input class=inputstyle datatype='int' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=5 onKeyPress='ItemCount_KeyPress()' onChange='checkcount1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                    } else {

                                        fieldhtml = "<input class=inputstyle datatype='int' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' datatype='float' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=5 onKeyPress='ItemCount_KeyPress()' onChange='checkcount1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                    }
                    if(changedefieldsadd.indexOf(defieldid)>=0){
                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                    }
                } else {
                    //fieldhtml += "<input class=inputstyle datatype='int' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle datetype='int' type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                }
            } else if (defieldtype.equals("3")||defieldtype.equals("5")) {                     // 单行文本框中的浮点型
            	int decimaldigits_t = 2;
		    	if(defieldtype.equals("3")){
		    		int digitsIndex = fielddbtype.indexOf(",");
		        	if(digitsIndex > -1){
		        		decimaldigits_t = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
		        	}else{
		        		decimaldigits_t = 2;
		        	}
		    	}
		    	String datavaluetype = "";
										    	if(defieldtype.equals("5")){
										    		datavaluetype = " datavaluetype='5' ";
										    	}
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input class=inputstyle datetype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += datavaluetype +" onfocus='changeToNormalFormat(this.name)' onblur='changeToThousands(this.name)' ";
                                        fieldhtml += " onChange='checknumber1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");".concat(trrigerdetailStr).concat("'><span id='field") + defieldid + "_\"+rowindex+\"span'>";
                                        if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle datetype='float' value='"+preAdditionalValue+"' viewtype='"+isdemand+"' temptitle='"+defieldlable+"' type=text id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' size=10 onKeyPress='ItemDecimal_KeyPress(this.name,15,"+decimaldigits_t+")' ";
                                        if(defieldtype.equals("5")) fieldhtml += datavaluetype +" onfocus='changeToNormalFormat(this.name)' onblur='changeToThousands(this.name)' ";
                                        fieldhtml += " onChange='checknumber1(this);checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);calSum("+detailno+");"+trrigerdetailStr+"'><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                    }
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    //fieldhtml += "<input class=inputstyle datetype='float' type=text readonly name='field" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle "+ datavaluetype +" datetype='float' type=hidden id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                                }
                            }else if (defieldtype.equals("4")) {                     // 单行文本框中的金额转换型
                                if (isdeedit.equals("1")) {
                                    if (isdemand.equals("1")) {
                                        fieldhtml = "<input class=inputstyle value='"+preAdditionalValue+"' datetype='float' type=text id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemNum_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"')\\\"  onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" onBlur=\\\"numberToChinese('" + defieldid + "_\"+rowindex+\"');calSum("+detailno+")\\\" onChange='checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));"+trrigerdetailStr+"'>";
                                        //if("".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                        //fieldhtml += "</span>";
                                    } else {
                                        fieldhtml = "<input class=inputstyle value='"+preAdditionalValue+"' datetype='float' type=text id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"' size=30 onKeyPress=\\\"ItemNum_KeyPress('field_lable" + defieldid + "_\"+rowindex+\"')\\\"  onfocus=\\\"getNumber('" + defieldid + "_\"+rowindex+\"')\\\" onBlur=\\\"numberToChinese('" + defieldid + "_\"+rowindex+\"');calSum("+detailno+")\\\" onChange='checkinput3(field_lable" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));"+trrigerdetailStr+"'>";
                                    }
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if(isdemand.equals("1")&&"".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                    fieldhtml += "</span><input class=inputstyle datetype='float' viewtype='"+isdemand+"' type=hidden temptitle='"+defieldlable+"' value='"+preAdditionalValue+"' id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                    if(changedefieldsadd.indexOf(defieldid)>=0){
                                        fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                                } else {
                                    fieldhtml += "<input class=inputstyle size=30 value='"+preAdditionalValue+"' datetype='float' type=text  disabled='true' id='field_lable" + defieldid + "_\"+rowindex+\"' name='field_lable" + defieldid + "_\"+rowindex+\"'>";
                                    fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'></span><input class=inputstyle datetype='float' type=hidden value='"+preAdditionalValue+"' id='field" + defieldid + "_\"+rowindex+\"' name='field" + defieldid + "_\"+rowindex+\"'>";
                                }
                            }
                        }                                                       // 单行文本框条件结束
                        else if (defieldhtmltype.equals("2")) {                     // 多行文本框
                            if (isdeedit.equals("1")) {
                            	if(isbill.equals("0")){
                      				rscount.executeSql("select * from workflow_formdictdetail where id = " + defieldid);
                      				if(rscount.next()){
                      					textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
                      				}
                       			}else{
                        			rscount.executeSql("select * from workflow_billfield where viewtype=1 and id = " + defieldid+" and billid="+formid);
                        			if(rscount.next()){
                        				textheight = ""+Util.getIntValue(rscount.getString("textheight"), 4);
                        			}
                        		}
                                if (isdemand.equals("1")) {
                                    fieldhtml = "<textarea class=inputstyle viewtype='"+isdemand+"' value='"+preAdditionalValue+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' onChange=\\\"checkinput3(field" +defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype); checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" rows='"+textheight+"' cols='150' style='width:100%'>"+preAdditionalValue+"</textarea><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                    if(preAdditionalValue.equals("")) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                    fieldhtml += "</span>";
                                } else {
                                    fieldhtml = "<textarea class=inputstyle viewtype='"+isdemand+"' value='"+preAdditionalValue+"' temptitle='"+defieldlable+"' onchange=\\\"checkinput3(field" +defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);checkLengthfortext('field" + defieldid + "_\"+rowindex+\"','"+fieldlen+"','"+defieldlable+"','"+SystemEnv.getHtmlLabelName(20246,user.getLanguage())+"','"+SystemEnv.getHtmlLabelName(20247,user.getLanguage())+"')\\\" name='field" + defieldid + "_\"+rowindex+\"' rows='"+textheight+"' cols='150' style='width:100%'>"+preAdditionalValue+"</textarea><span id='field" + defieldid + "_\"+rowindex+\"span'></span>";
                                }
                                if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                            } else {
                                //fieldhtml = "<textarea class=inputstyle name='field" + defieldid + "_\"+rowindex+\"' rows='4' cols='150' style='width:100%' readonly></textarea>";
                                fieldhtml += "<span id='field" + defieldid + "_\"+rowindex+\"span'>"+preAdditionalValue+"</span><input class=inputstyle type=hidden name='field" + defieldid + "_\"+rowindex+\"' value='"+preAdditionalValue+"' >";
                            }
                        }                                                           // 多行文本框条件结束
                        else if (defieldhtmltype.equals("3")) {                         // 浏览按钮 (涉及workflow_broswerurl表)
                            String url = BrowserComInfo2.getBrowserurl(defieldtype);     // 浏览按钮弹出页面的url
                            String linkurl = BrowserComInfo2.getLinkurl(defieldtype);    // 浏览值点击的时候链接的url
                            String showname = "";                                   // 新建时候默认值显示的名称
                            String showid = "";                                     // 新建时候默认值

                            if ((defieldtype.equals("8") || defieldtype.equals("135")) && !prjid.equals("")) {       //浏览按钮为项目,从前面的参数中获得项目默认值
                                showid = "" + Util.getIntValue(prjid, 0);
                            } else if ((defieldtype.equals("9") || defieldtype.equals("37")) && !docid.equals("")) { //浏览按钮为文档,从前面的参数中获得文档默认值
                                showid = "" + Util.getIntValue(docid, 0);
                            } else if ((defieldtype.equals("1") || defieldtype.equals("17")|| defieldtype.equals("165")|| defieldtype.equals("166")) && !hrmid.equals("")) { //浏览按钮为人,从前面的参数中获得人默认值
                                showid = "" + Util.getIntValue(hrmid, 0);
                            } else if ((defieldtype.equals("7") || defieldtype.equals("18")) && !crmid.equals("")) { //浏览按钮为CRM,从前面的参数中获得CRM默认值
                                showid = "" + Util.getIntValue(crmid, 0);
                            } else if ((defieldtype.equals("4") || defieldtype.equals("57") || defieldtype.equals("167") || defieldtype.equals("168")) && !hrmid.equals("")) { //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                                showid = "" + Util.getIntValue(ResourceComInfo2.getDepartmentID(hrmid), 0);
                            } else if (defieldtype.equals("24") && !hrmid.equals("")) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                showid = "" + Util.getIntValue(ResourceComInfo2.getJobTitle(hrmid), 0);
                            } else if (defieldtype.equals("32") && !hrmid.equals("")) { //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"), 0);
                            }else if((defieldtype.equals("164") || defieldtype.equals("169") || defieldtype.equals("170")) && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
								showid = "" + Util.getIntValue(ResourceComInfo2.getSubCompanyID(hrmid),0);
						    }
						    else if(defieldtype.equals("226")||defieldtype.equals("227")){
								//zzl普通模板解析主表字段的"集成浏览按钮"
								//拼接?type=browser.267|11266
								url+="?type="+fielddbtype+"|"+defieldid;	
							}

                            if (showid.equals("0")) showid = "";
            if(isSetFlag){
	            showid = preAdditionalValue;
	           }
                            if (!showid.equals("")) {       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                                if(defieldtype.equals("8") || defieldtype.equals("135")){
                                    //项目，多项目
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=ProjectInfoComInfo2.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("1") ||defieldtype.equals("17")||defieldtype.equals("165")||defieldtype.equals("166")){
                                    //人员，多人员
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                                          	{
                                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                          	}
                                        	else
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"'>"+ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=ResourceComInfo2.getResourcename((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("7") || defieldtype.equals("18")){
                                    //客户，多客户
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=CustomerInfoComInfo2.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("4") || defieldtype.equals("57")){
                                    //部门，多部门
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo2.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=DepartmentComInfo2.getDepartmentname((String)tempshowidlist.get(k))+" ";
                                        }
                                     }
                                 }else if(defieldtype.equals("164")){
                                     //分部
                                     for(int k=0;k<tempshowidlist.size();k++){
                                         if(!linkurl.equals("")){
                                             showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+SubCompanyComInfo2.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                         }else{
                                         showname+=SubCompanyComInfo2.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                                         }
                                     }
                                }else if(defieldtype.equals("9") || defieldtype.equals("37")){
                                    //文档，多文档
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo2.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=DocComInfo2.getDocname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("23")){
                                    //资产
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=CapitalComInfo2.getCapitalname((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("16") || defieldtype.equals("152") || defieldtype.equals("171")){
                                    //相关请求
                                    for(int k=0;k<tempshowidlist.size();k++){
                                        if(!linkurl.equals("")){
                                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                                        }else{
                                        showname+=WorkflowRequestComInfo2.getRequestName((String)tempshowidlist.get(k))+" ";
                                        }
                                    }
                                }else if(defieldtype.equals("161")||defieldtype.equals("162")){
									Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
				                    for(int k=0;k<tempshowidlist.size();k++){
										try{
				                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
				                            String desc=Util.null2String(bb.getDescription());
				                            String name=Util.null2String(bb.getName());							
				                            String href=Util.null2String(bb.getHref());
				                            if(href.equals("")){
				                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
				                            }else{
				                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
				                            }
										}catch (Exception e){
										}
				                    }
                                }else if(defieldtype.equals("226")||defieldtype.equals("227")){
                                	//zzl 赋予默认值
									showname=preAdditionalValue;
                                }
                                
                                else{
                                    String tablename2 = BrowserComInfo2.getBrowsertablename(defieldtype);
                                    String columname = BrowserComInfo2.getBrowsercolumname(defieldtype);
                                    String keycolumname = BrowserComInfo2.getBrowserkeycolumname(defieldtype);
                                    if(!tablename2.equals("")&&!columname.equals("")&&!keycolumname.equals("")){
                                    String sql = "select " + columname + " from " + tablename2 + " where " + keycolumname + "=" + showid;

                                    RecordSet.executeSql(sql);
                                    if (RecordSet.next()) {
                                        if (!linkurl.equals(""))
                                            showname = "<a href='" + linkurl + showid + "'  target='_new'>" + RecordSet.getString(1) + "</a>&nbsp";
                                        else
                                            showname = RecordSet.getString(1);
                                    }
                                    }
                                }
                            }

                            if (defieldtype.equals("2")) {                              // 浏览按钮为日期
                                //showname = currentdate;
                                //showid = currentdate;
                                if(!isSetFlag){
                                    showname = currentdate;
                                    showid = currentdate;
                                }else{
                                    showname=preAdditionalValue;
                                    showid=preAdditionalValue;
                                }
                            }
							if (defieldtype.equals("19")) {                              // 浏览按钮为时间
                              //showname = currenttime.substring(0,5);
                              //showid = currenttime.substring(0,5);
                              if(!isSetFlag){
                                  showname = currenttime.substring(0,5);
                                  showid = currenttime.substring(0,5);
                              }else{
                                  showname=preAdditionalValue;
                                  showid=preAdditionalValue;
                              }
                            }
							if (defieldtype.equals("161")||defieldtype.equals("162")) {                              //自定义浏览框
				                                url+="?type="+fielddbtype;
				               }
                            if (isdeedit.equals("1")) {
                                //System.out.println("url = " + url);
                                if (!defieldtype.equals("37")) {    //  多文档特殊处理
                                    if (trrigerdetailfield.indexOf("field"+defieldid)>=0)
									{
                                    fieldhtml = "<button type=button class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'));datainputd('field" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									}
									else
									{ 
									if(defieldtype.equals("2")){
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowFlowDate('" + defieldid + "_\"+rowindex+\"','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									}else if(defieldtype.equals("19")){
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowFlowTime(field" + defieldid + "_\"+rowindex+\"span, field" + defieldid + "_\"+rowindex+\" ,field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									 }else{
										fieldhtml = "<button type=button class=Browser onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" +defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\" title='" + SystemEnv.getHtmlLabelName(172, user.getLanguage()) + "'></button>";
									 }
								    }
                                } else {                         // 如果是多文档字段,加入新建文档按钮
                                    fieldhtml = "<button type=button class=AddDocFlow onclick=\\\"onShowBrowser2('" + defieldid + "_\"+rowindex+\"','" + url + "','" + linkurl + "','" + defieldtype + "',field" + defieldid + "_\"+rowindex+\".getAttribute('viewtype'))\\\">" + SystemEnv.getHtmlLabelName(611, user.getLanguage()) + "</button>&nbsp;&nbsp<button type=button class=AddDocFlow onclick=\\\"onNewDoc('" + defieldid + "_\"+rowindex+\"')\\\" title='" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "'>" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + "</button>";
                                }
                            }
                            fieldhtml += "<input type=hidden viewtype='"+isdemand+"' temptitle='"+defieldlable+"' name='field" + defieldid + "_\"+rowindex+\"' value='" + showid + "' ";
                            if(trrigerdetailfield.indexOf("field"+defieldid)>=0){
                            	fieldhtml += " onpropertychange=\\\"datainputd('field" + defieldid + "_\"+rowindex+\"');\\\" ";
                            }
                            fieldhtml += "><span id='field" + defieldid + "_\"+rowindex+\"span'>" + Util.toScreen(showname, user.getLanguage());

                            if (isdemand.equals("1") && showname.equals("")) {
                                fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                            }
                            fieldhtml += "</span>";
                            if(defieldtype.equals("87")){
                                fieldhtml += "&nbsp;&nbsp;<A href='/meeting/report/MeetingRoomPlan.jsp' target='blank'>"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>";
                            }
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                    fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                                    }
                        }                                                       // 浏览按钮条件结束
                        else if (defieldhtmltype.equals("4")) {                    // check框
                            if("1".equals(isdemand)){
                                fieldhtml += "<input class=inputstyle viewtype='"+isdemand+"' type=checkbox name='field" + defieldid + "_\"+rowindex+\"' value=1 onclick='checkboxCheck(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span)' ";
                                if("1".equals(preAdditionalValue)) fieldhtml += " checked ";
                                fieldhtml +="><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                                if(!"1".equals(preAdditionalValue)) fieldhtml += "<img src='/images/BacoError.gif' align=absmiddle>";
                                fieldhtml += "</span>";
                            }else{
                                fieldhtml += "<input class=inputstyle type=checkbox name='field" + defieldid + "_\"+rowindex+\"' value=1";
                                if("1".equals(preAdditionalValue)) fieldhtml += " checked ";
	
                                if (isdeedit.equals("0")) fieldhtml += " DISABLED ";
	
                                fieldhtml += ">";
                            }
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                            }
                        }                                                       // check框条件结束
                        else if (defieldhtmltype.equals("5")) {                     // 选择框   select
                        	//处理select字段联动
                         	String onchangeAddStr = "";
                        	int childfieldid_tmp = Util.getIntValue((String)childfieldids.get(i), 0);
                        	if(childfieldid_tmp != 0){
            	        		onchangeAddStr = ";changeChildFieldDetail(this,"+defieldid+","+childfieldid_tmp+",\"+rowindex+\")";
            	        	}
                        	boolean hasPfield = false;
                        	int firstPfieldid_tmp = 0;
                        	if(childfieldids.contains(defieldid)){
                        		firstPfieldid_tmp = Util.getIntValue((String)defieldids.get(childfieldids.indexOf(defieldid)), 0);
                        		hasPfield = true;
                        	}
                            if("1".equals(isdemand)){
                                fieldhtml += "<select class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"'";
                            }else{
                                fieldhtml += "<select class=inputstyle viewtype='"+isdemand+"' temptitle='"+defieldlable+"'";
                            }
                            if(seldefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);changeshowattr('"+defieldid+"_1',this.value,\"+rowindex+\","+workflowid+","+nodeid+");"+trrigerdetailStr+onchangeAddStr+" ";
                            }else{
                                fieldhtml += " onChange=checkinput3(field" + defieldid + "_\"+rowindex+\",field" + defieldid + "_\"+rowindex+\"span,this.viewtype);"+trrigerdetailStr+onchangeAddStr+" ";
                            }
                            if (isdeedit.equals("0")){
                                fieldhtml += " name='disfield" + defieldid + "_\"+rowindex+\"' DISABLED ";
                            }else{
                                fieldhtml += " name='field" + defieldid + "_\"+rowindex+\"' ";
                            }
                            fieldhtml += ">";
                            fieldhtml += "<option value=''></option>";//added by xwj for td3297 20051130
                            // 查询选择框的所有可以选择的值
                            char flag = Util.getSeparator();
                            boolean checkemptydetail = true;
                            String finalvaluedetail = "";
                            if(hasPfield==false){
                            	rs.executeProc("workflow_selectitembyid_new", "" + defieldid + flag + isbill);
	                            while (rs.next()) {
	                                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
	                            
	                                String tmpselectname = Util.toScreen(rs.getString("selectname"), user.getLanguage());
	                            
	                                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());
	                                if("".equals(preAdditionalValue)){
	                                    if("y".equals(isdefault)){
	                                        checkemptydetail = false;
	                                        finalvaluedetail = tmpselectvalue;
	                                        fieldhtml += "<option value='" + tmpselectvalue + "' selected>" + tmpselectname + "</option>";
	                                    }else{
	                                        fieldhtml += "<option value='" + tmpselectvalue + "'>" + tmpselectname + "</option>";
	                                    }
	                                }
	                                else{
	                                    checkemptydetail = false;
	                                    fieldhtml += "<option value='" + tmpselectvalue + "'";
	                                    if(tmpselectvalue.equals(preAdditionalValue)) fieldhtml += "selected";
	                                    fieldhtml += ">" + tmpselectname + "</option>";
	                                }
	                            
	                            }
                            }else{
                	            rs.executeProc("workflow_SelectItemSelectByid", "" + defieldid + flag + isbill);
                	            while (rs.next()) {
                	                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                	//                System.out.println("tmpselectvalue="+tmpselectvalue);
                	                String tmpselectname = Util.toScreen(rs.getString("selectname"), user.getLanguage());
                	                /* -------- xwj for td2977 20051107 begin ----*/
                	                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());
                	                if("".equals(preAdditionalValue)){
                		                if("y".equals(isdefault)){
                			                checkemptydetail = false;
                			                finalvaluedetail = tmpselectvalue;
                			              }
                	                }else{
                	                	checkemptydetail = false;
                	                	finalvaluedetail = preAdditionalValue;
                	                }
                	            }
                            	selectInitJsStr += "doInitDetailchildSelect("+defieldid+","+firstPfieldid_tmp+",rowindex,\""+finalvaluedetail+"\");";
                            }
                            fieldhtml += "</select><span id='field" + defieldid + "_\"+rowindex+\"span'>";
                            if(isdemand.equals("1") && checkemptydetail){
                                fieldhtml +="<img src='/images/BacoError.gif' align=absmiddle>";
                            }
                            fieldhtml +="</span>";
                            if(changedefieldsadd.indexOf(defieldid)>=0){
                                fieldhtml += "<input type=hidden name=oldfieldview" + defieldid + "_\"+rowindex+\" value="+(Util.getIntValue(isdeview,0)+Util.getIntValue(isdeedit,0)+Util.getIntValue(isdemand,0))+" />";
                            }
                            if (isdeedit.equals("0")){
                                fieldhtml += "<input type=hidden name='field" + defieldid + "_\"+rowindex+\"' value='" + preAdditionalValue + "'>";
                            }
                            
                        }                                          // 选择框条件结束 所有条件判定结束
                %>


        //oCell = oRow.insertCell();
        oCell = document.createElement("TD");
        jQuery(oRow).append(oCell);
        oCell.style.height=24;
        oCell.style.background= "#E7E7E7";
		oCell.style.wordWrap= "break-word";
		oCell.style.wordBreak= "break-all";

        var oDiv = document.createElement("div");
        var sHtml = "<%=fieldhtml%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
        <%
        if (trrigerdetailfield.indexOf("field"+defieldid)>=0){
        %>
        //datainputd("field<%=defieldid%>_"+rowindex);
        initDetailfields += "field<%=defieldid%>_"+rowindex+",";
        <%
        }
        if(seldefieldsadd.indexOf(defieldid)>=0){
        %>
        changeshowattr('<%=defieldid%>_1',$G('field<%=defieldid%>_'+rowindex).value,rowindex,'<%=workflowid%>','<%=nodeid%>');
        <%
        }
			//System.out.println("field type:"+fieldtype);
    }       //addrow for循环结束
    }catch(Exception e){}
%>
	try
	{
	    if ("<%=needcheck%>" != ""){
	    	$GetEle("needcheck").value += ",<%=needcheck%>";
	    }
	    datainputd(initDetailfields);
	    <%=selectInitJsStr%>
    }
    catch(e)
    {
    
    }
    rowindex = rowindex*1 +1;
    curindex = curindex*1 +1;
    $G("nodesnum"+obj).value = curindex ;
    $G('indexnum'+obj).value = rowindex;
    calSum(obj);
}

<%
if(dtldefault.equals("1"))
{
%>
addRow<%=detailno%>(<%=detailno%>,<%=groupId%>);
<%	
}
%>
</script>
<%
        }   //if end
        detailno++;
    }
%>

<script language=javascript>
function deleteRow1(obj,groupid)
{
    var flag = false;
	var ids = document.getElementsByName('check_node'+obj);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            var oTable=$GetEle('oTable'+obj);
            curindex=parseInt($G("nodesnum"+obj).value);
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj)
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'+obj){
                    if(document.forms[0].elements[i].checked==true) {
                        //从提交序号串中删除被删除的行
                        var delid;
                        if(oTable.rows(rowsum1).cells(0).children.length>1){
                            delid=oTable.rows(rowsum1).cells(0).children(0).value;
                        }else{
                            delid=oTable.rows(rowsum1).children(0).all(1).value;
                        }
                        var submitdtlidArray=$G("submitdtlid"+groupid).value.split(',');
                        $G("submitdtlid"+groupid).value="";
                        var k;
                        for(k=0; k<submitdtlidArray.length; k++){
                            if(submitdtlidArray[k]!=delid){
                                if($G("submitdtlid"+groupid).value=='')
                                    $G("submitdtlid"+groupid).value = submitdtlidArray[k];
                                else
                                    $G("submitdtlid"+groupid).value += ","+submitdtlidArray[k];
                            }
                        }

                        //删除行
                        oTable.deleteRow(rowsum1);
                        curindex--;
                    }
                    rowsum1 -=1;

                }
            }

            var rows = oTable.rows.length ;
            for(i=1; i < rows;i++){
                if(oTable.rows(i).cells(1).innerText!="<%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>"){
                    oTable.rows(i).cells(1).children(0).innerText=i;
                }
            }

            $G("nodesnum"+obj).value=curindex;
            calSum(obj);
        }
	}else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

</script>
<%

    } //表单结束
    ArrayList rowCalAry = new ArrayList();
    ArrayList rowCalSignAry = new ArrayList();
	ArrayList mainCalAry = new ArrayList();
    ArrayList tmpAry = null;

	StringTokenizer stk2 = new StringTokenizer(rowCalItemStr1,";");
	//out.println(rowCalItemStr1);

	ArrayList newRowCalArray = new ArrayList();

	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		rowCalAry.add(stk2.nextToken(";"));
	}
	stk2 = new StringTokenizer(mainCalStr1,";");
	while(stk2.hasMoreTokens()){
		//out.println(stk2.nextToken(";"));
		mainCalAry.add(stk2.nextToken(";"));
	}
	//out.println(mainCalStr1);

%>

<%--<iframe name=productInfo style="width:100%;height:300;display:none"></iframe>--%>
<script language="javascript">
rowindex = 0;
curindex = 0 ;

<%--added by Charoes Huang FOR Bug 625--%>
function parse_Float(i){
	try{
	    i =parseFloat(i);
		if(i+""=="NaN")
			return 0;
		else
			return i;
	}catch(e){
		return 0;
	}
}

function changeToThousandsVal(sourcevalue){
	sourcevalue = sourcevalue +"";
	if(null != sourcevalue && 0 != sourcevalue){
     if(sourcevalue.indexOf(".")<0)
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    else
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}

function calSumPrice(){

    var temv1;
    var evt = getEvent();
    //alert(rowindex);
<%
    String temStr = "";
    for(int i=0; i<rowCalAry.size(); i++){
        temStr = "";
		String calExp = (String)rowCalAry.get(i);
        ArrayList calExpList=DynamicDataInput.FormatString(calExp);
        //System.out.println("calExpold:"+calExp);
%>

        try{
            var nowobj=(evt.srcElement ? evt.srcElement : evt.target).name.toString();
            var i;
            if(nowobj.indexOf('_')>-1){
                i=nowobj.substr(nowobj.indexOf('_')+1);
                if(i.indexOf('_')>-1)
                    i=i.substr(i.indexOf('_')+1);
            }
			//var i = window.event.srcElement.parentElement.parentElement.parentElement.rowIndex - 1;//只计算当前行的值

        <%
            for(int j=0;j<calExpList.size();j++){
            calExp=(String)calExpList.get(j);
			String targetStr ="";
            //System.out.println("calExp:"+calExp);
       %>
       try {
       <%
            if(calExp.indexOf("innerHTML")>0){
            targetStr=calExp.substring(0,calExp.indexOf("innerHTML")-1);
            //System.out.println("targetStr:"+targetStr);
			//targetStr = targetStr.substring(0,targetStr.indexOf("_"));
			//out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");
			//out.println("if(window.event.srcElement.name.toString().indexOf(tempObjName)==-1)");
            out.println("if("+targetStr+"){");
            if (calExp.indexOf("=") != calExp.length()-1) {
            	out.println(calExp+"; ") ;
            }
						//out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").datatype=='int') "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);else "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,2);}");
						out.println("if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')=='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')!='5'){ ") ;
						out.println(calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,0);");
						out.println("}else if("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datetype')!='int' && "+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").getAttribute('datavaluetype')=='5'){");
            out.println(targetStr+".innerHTML=changeToThousandsVal("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value)+'';");
            out.println("}else{");
            out.println(targetStr+".innerHTML=toPrecision("+calExp.substring(0,calExp.indexOf("innerHTML")-9)+").value,2);");
            out.println("}}");
            }else{
            if(calExp.indexOf("value")>0){
            targetStr=calExp.substring(0,calExp.indexOf("value")-1);
            //out.println("var tempObjName = getObjectName("+targetStr+",\"_\")");
			//out.println("if(window.event.srcElement.name.toString().indexOf(tempObjName)==-1){");
            out.println("if("+targetStr+"){");
            if (calExp.indexOf("=") != calExp.length()-1) {
            	out.println(calExp+"; ") ;
            }
			out.println("if("+calExp.substring(0,calExp.indexOf("value")-1)+".datatype=='int') "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",0);else "+calExp.substring(0,calExp.indexOf("="))+"=toPrecision("+calExp.substring(0,calExp.indexOf("="))+",2);}");
            }
            }
            %>
            }catch(e){}
            <%
            }
	        %>

       }
       catch(e){}
<%
    }
%>
}

function calMainField(obj){
    var rows=0;
    <%for(int i=0;i<detailno;i++){%>
    var temprow=0;
    if($GetEle('indexnum<%=i%>')) temprow=parseInt($GetEle('indexnum<%=i%>').value);
    if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
	<%
		for(int i=0;i<mainCalAry.size();i++){
			String str2 =  mainCalAry.get(i).toString();
		    int idx = str2.indexOf("=");
			String str3 = str2.substring(0,idx);
			str3 = str3.substring(str3.indexOf("_")+1);
			String str4 = str2.substring(idx);
			str4 = str4.substring(str4.indexOf("_")+1);
	%>
               var sum=0;
               var temStr;
                for(i=0; i<rowindex; i++){

                    try{
                        temStr=$GetEle("field<%=str4%>_"+i).value;
                        temStr = temStr.replace(/,/g,"");
                        if(temStr+""!=""){
                            sum+=temStr*1;
                        }
                    }catch(e){;}
                }
                if($GetEle("field<%=str3%>")){
                  if($GetEle("field<%=str3%>").getAttribute("datatype")=="int")
                	  $GetEle("field<%=str3%>").value=toPrecision(sum,0);
                  else
                	  $GetEle("field<%=str3%>").value=toPrecision(sum,3);
                }
                if($GetEle("field<%=str3%>span")){
					if($GetEle("field<%=str3%>")&&$GetEle("field<%=str3%>").type=="text"){
						$GetEle("field<%=str3%>span").innerHTML="";
					}else{
						if($GetEle("field<%=str3%>").getAttribute("datatype") == "int"){
							$GetEle("field<%=str3%>span").innerHTML=toPrecision(sum,0);
						}else if($GetEle("field<%=str3%>").getAttribute("datatype")=="float" && $GetEle("field<%=str3%>").getAttribute("datavaluetype")== "5"){
							$GetEle("field<%=str3%>span").innerHTML=changeToThousandsVal(toPrecision(sum,2));
						}else{
							$GetEle("field<%=str3%>span").innerHTML=toPrecision(sum,3);
						}
					}

                }



	<%
	}
	%>

}
function calSum(obj){
    calSumPrice();
    var rows=0;
    <%for(int i=0;i<detailno;i++){%>
    var temprow=0;
    if($GetEle('indexnum<%=i%>')) temprow=parseInt($GetEle('indexnum<%=i%>').value);
    if(temprow>rows) rows=temprow;
    <%}%>
    if(rowindex<rows)
        rowindex=rows;
    var sum=0;
    var temStr;
<%
    for(int i=0; i<colCalAry.size(); i++){
		String str = colCalAry.get(i).toString();
		str = str.substring(str.indexOf("_")+1);
%>
            sum=0;
            for(i=0; i<rowindex; i++){

                try{
                    temStr=$GetEle("field<%=str%>_"+i).value;
                    temStr = temStr.replace(/,/g,"");
                    if(temStr+""!=""){
                        sum+=temStr*1;
                    }
                }catch(e){;}
            }
            
        var decimalNumber = 3;
        try {
			var targetElement_dt = jQuery($G("field<%=str%>_" + obj)).attr("onkeypress");
			if (targetElement_dt) {
				targetElement_dt = targetElement_dt.toString();
				var decimalNumberstr = targetElement_dt.substring(targetElement_dt.indexOf("ItemDecimal_KeyPress(") + 21,targetElement_dt.length - 3);
				var decimalNumberstrary = decimalNumberstr.split(",");
				decimalNumber = parseInt(decimalNumberstrary[decimalNumberstrary.length - 1]);
			}
		} catch (e) {}
		if (isNaN(decimalNumber)) {
			decimalNumber = 3;
		}
		
        if($GetEle("sum<%=str%>")!=null){
        	$GetEle("sum<%=str%>").innerHTML=toPrecision(sum,decimalNumber)+" ";
        }
        if($GetEle("sumvalue<%=str%>")!=null){
        	$GetEle("sumvalue<%=str%>").value=toPrecision(sum,decimalNumber);
        }
<%
    }
%>
	calMainField(obj);
}

/**
return a number with a specified precision.
*/
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}
/**

从"field142_0" 得到，field142
*/

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}

function datainputd(parfield){                <!--数据导入-->

      //var xmlhttp=XmlHttp.create();\
      //LL for QC46731 start 2012/08/31
	  var tempParfieldArr;
	  var StrData;
	  try{
		  try{
			tempParfieldArr = parfield.split(",");
			StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
			}catch(e){
			tempParfieldArr = parfield.getAttribute("name").split(",")
			StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield.getAttribute("name");
			}
		}catch(e){	
		  tempParfieldArr = $(parfield).attr("id").toString().split(",");
		  StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+$(parfield).attr("id");
		}
	  //LL for QC46731 end 2012/08/31
      for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

      <%
      if(!trrigerdetailfield.trim().equals("")){
          ArrayList Linfieldname=ddidetail.GetInFieldName();
          ArrayList Lcondetionfieldname=ddidetail.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);

      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;

      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          if($GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+$GetEle("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;
      <%
          }
          }
      %>
      }

      $GetEle("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $GetEle("selectChangeDetail").src = "SelectChange.jsp?"+paraStr;
    //alert($GetEle("selectChange").src);
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $GetEle("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $GetEle("field"+fieldid+"_"+rownum);
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
			    $GetEle("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function getNumber(index){
	$GetEle("field_lable"+index).value = $GetEle("field"+index).value;
  }
</script>

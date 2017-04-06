<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="com.weaver.integration.params.ServiceParamModeStatusBean"%>
<%@page import="com.weaver.integration.params.ServiceParamModeDisUtil"%>
<%@page import="com.weaver.integration.params.ServiceParamModeDisBean"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet02" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="inteutil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<jsp:useBean id="ssu" class="com.weaver.integration.util.SAPServcieUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%></title>
	</head>

	
	<!-- 业务逻辑 start-->
	<%
			
			//节点后动作才能有输入表：因为如果在浏览按钮配置输入表的话，哪意味着需要js抓取流程页面表单的明细表数据
			//远程加载参数，可以防止数据库的函数字段变更，而引起这边的函数不能用的情况，及时地更新本地数据
			//本地加载参数，就是直接抓取本地的数据进行读取
			//只有新建的时候加载模板功能才有用，修改的时候暂时不开放。。。。
			//保存为模板什么意思？？
			//后台SAP-ABAP函数名是什么意思??
			//28245
			
			//function addOneFieldObjOA标准 
			//--------------<button> 浏览按钮
			//--------------<input>  隐藏的oa字段name
			//--------------<span>   显示的oa字段name
			//--------------<span>   显示img
			//--------------<input>  记录字段(是否主字段，字段的数据库id,)
			
			//table--id规则
			//第一个table id:sap_01   全选cbox_01                              添加add_01                子tableid chind01
			//第二个table id:sap_02   全选cbox_02_01,cbox_02_02,...cbox_02_n 添加add_02
			//第三个table id:sap_03   全选cbox_03     添加add_03
			//第四个table id:sap_04   全选cbox_04_01,cbox_04_02,...cbox_04_n 添加add_04
			//第五个table id:sap_05   全选cbox_05_01,cbox_05_02,...cbox_05_n 添加add_05
			String baseid=Util.null2String(request.getParameter("baseid"));
			int sap_inParameter=1;//输入参数计数器
			int sap_inStructure=1;//输入结构计数器
			int sap_outParameter=1;
			int sap_outStructure=1;
			int sap_outTable=1;
			int int_authorizeRight=1;
			int sap_inTable=1;
			int ismainfield=0;//是否明细表,0表示是主表,1表示是明细表
			String sql="";
			String srcType=Util.null2String(request.getParameter("srcType"));//这种情况来源于字段管理--新建字段 (detailfield=明细字段,mainfield=主字段)
			String formid=Util.null2String(request.getParameter("formid"));//得到流程表单的formid
			String updateTableName=Util.null2String(request.getParameter("updateTableName"));//得到主表或明显表的name,用于判断当前配置的浏览按钮放置在那张表中
			if(updateTableName.indexOf("_dt")>=0||updateTableName.indexOf("$_$")>=0)
			{
				ismainfield=1;
			}
			String dataauth=Util.null2String(request.getParameter("dataauth"));//得到是否跳到数据授权界面
			String mark=Util.null2String(request.getParameter("mark"));
			String opera=Util.null2String(request.getParameter("opera"));//
			//用于判断是远程获取参数还是本地获取参数，1是本地获取参数，2是远程获取参数
			String  islocal="";
			String regservice=Util.null2String(request.getParameter("regservice"));//注册服务的服务id
			
			//1表示新建的时候change注册服务，2表示修改的时候change注册服务,"0"表示没用进行change操作，"3"表示修改的时候change操作到了初始状态的时候
			String updateChangeService=Util.null2String(request.getParameter("updateChangeService"));
			
			//通过注册服务的id,判断该数据源是否初始化了abap数据
			sql="select count(*) s from int_serviceParams where Servid="+regservice;
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				if(Util.getIntValue(RecordSet.getString("s"),0)>0){
					islocal="1";//如果初始化了数据，就从本地读数据
				}
			}
			String loadmb="0";//前台页面是否”自动初始化模板”
			sql="select loadmb s from sap_service where id="+regservice;
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				loadmb=Util.getIntValue(RecordSet.getString("s"),0)+"";
			}
			String paramModeId="";
			sql="select id from int_serviceParamMode where ServId='"+regservice+"'";
			if(RecordSet.execute(sql)&&	RecordSet.next()){
				paramModeId=Util.getIntValue(RecordSet.getString("id"),-1)+"";
			}
			
			ServiceParamModeStatusBean spmsb =new ServiceParamModeStatusBean();
			if(!"".equals(paramModeId)&&Util.getIntValue(paramModeId, -1)>0){//如果模板的id不为"",并且生成了模板id
					 spmsb =ServiceParamModeDisUtil.getServParModStaBeanById(regservice, paramModeId);
			}
			String w_type=Util.null2String(Util.getIntValue(request.getParameter("w_type"),0)+"");//0-表示是浏览按钮的配置信息，1-表示是节点后动作配置时的信息
			int isbill= Util.getIntValue(request.getParameter("isbill"),0);//0表示老表单,1表示新表单
			//节点id
			int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
			//工作流的id
			int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
			String oldautotypeid=",";//记录修改前的所有的int_authorizeRight表的id
			
			if("".equals(opera)){opera="save";}
			//第一个参数录入tab
			StringBuffer sapinParameter01= new StringBuffer();
			sapinParameter01.append("<TABLE class='ListStyle marginTop0 ' cellspacing=1 id='sap_01' style='table-layout: fixed;'>");
			sapinParameter01.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");
			sapinParameter01.append("<tr>");
			sapinParameter01.append("<td>&nbsp;"+SystemEnv.getHtmlLabelName(28245 ,user.getLanguage())+"</td>");
			sapinParameter01.append("<td><button type='button'  class='btn' id='bath_01' onclick='addBathFieldObj(1,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' id='add_01' onclick='addBathFieldObj(1,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button>");
			sapinParameter01.append("<button type='button' class='btn' id='del_01' onclick='addBathFieldObj(1,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button> <input type='hidden' id='hidden01' value='");
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter01.append(spmsb.getImpstrcount());//模板里面的输入参数总数
			}else{
					sapinParameter01.append(inteutil.getSapInAndOutParameterCount("1",baseid)+"");
			}
			sapinParameter01.append("' name='hidden01' ></td>"); 	
			sapinParameter01.append("</tr>"); 	
			sapinParameter01.append("<tr>");
			sapinParameter01.append("<td colspan='2'>");
				sapinParameter01.append(" <TABLE class=ListStyle cellspacing=1 id='chind01' style='table-layout: fixed;'>");
				sapinParameter01.append(" <colgroup> <col width='60px'/> <col width='80px'/><col width='120px'/><col width='80px'/><col width='120px'/><col width='80px'/><col width='120px'/>  </colgroup>");
				sapinParameter01.append(" <tr class=Header>");
				sapinParameter01.append(" <td><input type='checkbox' id='cbox_01'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='6'>"+SystemEnv.getHtmlLabelName(30605 ,user.getLanguage())+"</td>");
				sapinParameter01.append(" </tr>");
				sapinParameter01.append(" <TR class=Line style='height:1px'><TD colSpan=7 style='padding:0px'></TD></TR>");
					
					//System.out.println("loadmb"+loadmb);
					//System.out.println("opera"+opera);
					//System.out.println("regservice"+regservice);
					//System.out.println("mark"+mark);
					/* 
					//表示新建的时候默认加载模板
					//修改的时候分几种情况，一为实际的修改（没有切换注册服务，那么页面显示的数据要显示该标识的实际数据）
					//二为非实际修改（切换了数据服务，那么页面不需要显示该标识的实际数据）
					if("1".equals(loadmb)&&"save".equals(opera))
					{
						ServiceParamModeStatusBean spmsb = ServiceParamModeDisUtil.getServParModStaBeanById(regservice, paramModeId);
						//表示新建的时候默认加载数据显示,修改的时候就不管了
						List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", "");
							if(list != null) {
								for(int i=0;i<list.size();i++) {
									ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
									String ParamName=spmdb.getParamName();//得到sap参数的名称
									String input01="sap01_"+sap_inParameter;
									String input01Span="sap01_"+sap_inParameter+"Span";
									String input02="oa01_"+sap_inParameter;
									String input02Span="oa01_"+sap_inParameter+"Span";
									String input03="con01_"+sap_inParameter;
									String address="add01_"+sap_inParameter;
									String ismainfield01=RecordSet.getString("ismainfield");
									String fromfieldid01=RecordSet.getString("fromfieldid");
									if("0".equals(w_type))
									{
											sapinParameter01.append(" <tr  class=DataDark>");
											sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
											sapinParameter01.append(" <td>SAP取值字段</td>");
											sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+ParamName+"'/> <span>"+ParamName+"</span><span id='"+input01Span+"'></span></td>");
											sapinParameter01.append(" <td>对应OA字段</td>");
											sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"' /> <span></span> <span id='"+input02Span+"'></span><input type=hidden name='"+address+"' ></td>");
											sapinParameter01.append(" <td>固定值</td>");
											sapinParameter01.append(" <td><input type='text' name='"+input03+"' value='"+RecordSet.getString("constant")+"'></td>");
											sapinParameter01.append(" </tr>");
									}else
									{
											sapinParameter01.append(" <tr  class=DataDark>");
											sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
											sapinParameter01.append(" <td>OA取值字段</td>");
											sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"'  value='"+ParamName+"'/> <span>"+ParamName+"</span> <span id='"+input02Span+"'></span><input type=hidden hidden='"+address+"' ></td>");
											sapinParameter01.append(" <td>SAP赋值字段</td>");
											sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  /> <span></span><span id='"+input01Span+"'></span></td>");
											sapinParameter01.append(" <td>固定值</td>");
											sapinParameter01.append(" <td><input type='text' name='"+input03+"' ></td>");
											sapinParameter01.append(" </tr>");
									}
									sap_inParameter++;
								
								}
							}
					} */
					
					//System.out.println("opera="+opera);
					//	System.out.println("updateChangeService="+updateChangeService);
					//System.out.println("loadmb="+loadmb);
					//System.out.println("w_type="+w_type);
					
					//修改的时候进行change的操作，并且change后的服务配置了模板（需要初始化模板）
				 	if("save".equals(opera)&&"1".equals(loadmb))
					{		
									List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", "");
									if(list != null) {
									for(int i=0;i<list.size();i++) {
													ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
													String input01="sap01_"+sap_inParameter;
													String input01Span="sap01_"+sap_inParameter+"Span";
													String input02="oa01_"+sap_inParameter;
													String input02Span="oa01_"+sap_inParameter+"Span";
													String input03="con01_"+sap_inParameter;
													String address="add01_"+sap_inParameter;
													
													String ParamName=spmdb.getParamName();
													String ParamCons=spmdb.getParamCons();
													
													if("0".equals(w_type))
													{
															sapinParameter01.append(" <tr>");
															sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+ParamName+"'/> <span>"+ParamName+"</span><span id='"+input01Span+"'></span></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"'  value=''/> <span></span> <span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><input type='text' name='"+input03+"' value='"+ParamCons+"'></td>");
															sapinParameter01.append(" </tr>");
													}else
													{
															
															sapinParameter01.append(" <tr>");
															sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"'  value=''/> <span></span> <span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+ParamName+"'/> <span>"+ParamName+"</span><span id='"+input01Span+"'></span></td>");
															sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
															sapinParameter01.append(" <td><input type='text' name='"+input03+"' value='"+ParamCons+"'></td>");
															sapinParameter01.append(" </tr>");
													}
													
													sap_inParameter++;
								
													
													
								}
						}					
					}else  if("update".equals(opera)&&!"2".equals(updateChangeService))
					{
							//依据浏览按钮的id,查出该浏览按钮的输入参数
							sql="select * from sap_inParameter where baseid='"+baseid+"' order by id ";	
							RecordSet.execute(sql);
							while(RecordSet.next())
							{
								String input01="sap01_"+sap_inParameter;
								String input01Span="sap01_"+sap_inParameter+"Span";
								String input02="oa01_"+sap_inParameter;
								String input02Span="oa01_"+sap_inParameter+"Span";
								String input03="con01_"+sap_inParameter;
								String address="add01_"+sap_inParameter;
								String ismainfield01=RecordSet.getString("ismainfield");
								String fromfieldid01=RecordSet.getString("fromfieldid");
								if("0".equals(w_type))
								{
										
										
										sapinParameter01.append(" <tr>");
										sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+RecordSet.getString("sapfield")+"'/> <span>"+RecordSet.getString("sapfield")+"</span><span id='"+input01Span+"'></span></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"'  value='"+RecordSet.getString("oafield")+"'/> <span>"+RecordSet.getString("oafield")+"</span> <span id='"+input02Span+"'></span><input type=hidden name='"+address+"' value='"+ismainfield01+"_"+fromfieldid01+"'></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><input type='text' name='"+input03+"' value='"+RecordSet.getString("constant")+"'></td>");
										sapinParameter01.append(" </tr>");
								}else
								{
										
										sapinParameter01.append(" <tr>");
										sapinParameter01.append(" <td><input type='checkbox' name='cbox1'/></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden'  name='"+input02+"'  value='"+RecordSet.getString("oafield")+"'/> <span>"+RecordSet.getString("oafield")+"</span> <span id='"+input02Span+"'></span><input type=hidden name='"+address+"' value='"+ismainfield01+"_"+fromfieldid01+"'></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+RecordSet.getString("sapfield")+"'/> <span>"+RecordSet.getString("sapfield")+"</span><span id='"+input01Span+"'></span></td>");
										sapinParameter01.append(" <td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
										sapinParameter01.append(" <td><input type='text' name='"+input03+"' value='"+RecordSet.getString("constant")+"'></td>");
										sapinParameter01.append(" </tr>");
								}
								
								sap_inParameter++;
						}	
					}
				sapinParameter01.append(" </TABLE>");
			sapinParameter01.append("</td>");
			sapinParameter01.append("</tr>"); 
			sapinParameter01.append("</table>");
			
			//第二个--输入结构								  	
			StringBuffer sapinParameter02= new StringBuffer();										  	
			sapinParameter02.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_02' style='table-layout: fixed;'>");
			sapinParameter02.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
			sapinParameter02.append(" <tr>");	
			sapinParameter02.append(" <td>&nbsp;"+SystemEnv.getHtmlLabelName(28251 ,user.getLanguage())+"</td>");	
			sapinParameter02.append(" <td><button type='button'  class='btn' id='bath_02' onclick='addBathFieldObj(2,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn'  id='add_02' onclick='addBathFieldObj(2,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' id='del_02' onclick='addBathFieldObj(2,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button> <input type='hidden' id='hidden02' name='hidden02' value='");
			
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter02.append(spmsb.getImpstructcount());//模板里面的输入结构的总数
			}else{
					sapinParameter02.append(inteutil.getSapInAndOutParameterCount("2",baseid));
			}
			sapinParameter02.append("' ></td>");	
			sapinParameter02.append(" </tr>");	
			
					if("save".equals(opera)&&"1".equals(loadmb))
					{
						List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", true, "struct", "");
						if(list != null) {
							for(int i=0;i<list.size();i++) {
								ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
								
								String ParamName=spmdb.getParamName();
								String ParamCons=spmdb.getParamCons();
								
								
								String newstru="stru_"+sap_inStructure;
								String newstruSpan="stru_"+sap_inStructure+"span";
								String newname="cbox2_"+sap_inStructure;
								String bath="bath2_"+sap_inStructure;
								String newtable="sap_02"+"_"+sap_inStructure;//30609
								sapinParameter02.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox2'></td>");	
								sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(2,this,'"+newstru+"')></button><input type='hidden' class='selectmax_width' name='"+newstru+"' id='"+newstru+"' value='"+ParamName+"' ><span>"+ParamName+"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span id='"+newstruSpan+"'></span>");	
								sapinParameter02.append("<input type='hidden' id='"+newname+"' name='"+newname+"'  value='");
								
								sapinParameter02.append(ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "import", ParamName));
								
								sapinParameter02.append("'>");
								sapinParameter02.append("<TABLE class=ListStyle cellspacing=1 id='"+newtable+"' >");	
								sapinParameter02.append("<tr class=Header><td ><input type='checkbox' onclick='checkbox2(this,"+sap_inStructure+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td  colspan='7'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");	
								sapinParameter02.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='8'></TD></TR>");	
								int childstu=1;
								
								List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", ParamName);
								if(listtemp != null) {
									for(int j=0;j<listtemp.size();j++) {
										ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
										//得到子表的对象
			 							String child01="sap02_"+sap_inStructure+"_"+childstu;
			 							String child02="oa02_"+sap_inStructure+"_"+childstu;
			 							String child03="con02_"+sap_inStructure+"_"+childstu;
			 							
			 							String child01Span="sap02_"+sap_inStructure+"_"+childstu+"span";
			 							String child02Span="oa02_"+sap_inStructure+"_"+childstu+"span";
			 							String address="add02_"+sap_inStructure+"_"+childstu;
			 							
			 								String ParamDBName=spmdbtemp.getParamName();
											String ParamDBCons=spmdbtemp.getParamCons();
			 							
										//value='"+ismainfield02+"_"+fromfieldid02+"'
			 							if("0".equals(w_type))
										{
				 							sapinParameter02.append("<tr>");
											sapinParameter02.append("<td><input type='checkbox' name='zibox'></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+newstru+"')></button><input type='hidden' name='"+child01+"' value='"+ParamDBName+"'><span>"+ParamDBName+"</span><span id='"+child01Span+"'></span></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child02+"' value='' ><span></span><span id='"+child02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><input type='text' name='"+child03+"' value='"+ParamDBCons+"' ></td>");
											sapinParameter02.append("<td></td>");
											sapinParameter02.append("</tr>");
										}else
										{
											sapinParameter02.append("<tr>");
											sapinParameter02.append("<td><input type='checkbox' name='zibox'></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child02+"' value='' ><span></span><span id='"+child02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+newstru+"')></button><input type='hidden' name='"+child01+"' value='"+ParamDBName+"'><span>"+ParamDBName+"</span><span id='"+child01Span+"'></span></td>");
											sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
											sapinParameter02.append("<td><input type='text' name='"+child03+"' value='"+ParamDBCons+"' ></td>");
											sapinParameter02.append("<td></td>");
											sapinParameter02.append("</tr>");
										}
										childstu++;
									}
								}
								sapinParameter02.append("</TABLE>");	
								sapinParameter02.append("</td></tr>");	
								sap_inStructure++;
							}
						}
					
					
					
					}else if("update".equals(opera)&&!"2".equals(updateChangeService))
					{	
						
						sql=" select * from sap_complexname where comtype=3 and  baseid='"+baseid+"' ";
						RecordSet.execute(sql);
						while(RecordSet.next())
						{
							//查出有多少个结构
							String newstru="stru_"+sap_inStructure;
							String newstruSpan="stru_"+sap_inStructure+"span";
							String newname="cbox2_"+sap_inStructure;
							String bath="bath2_"+sap_inStructure;
							String newtable="sap_02"+"_"+sap_inStructure;//30609
							sapinParameter02.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox2'></td>");	
							sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(2,this,'"+newstru+"')></button><input type='hidden' class='selectmax_width' name='"+newstru+"' id='"+newstru+"' value='"+RecordSet.getString("name")+"' ><span>"+RecordSet.getString("name")+"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span id='"+newstruSpan+"'></span>");	
							sapinParameter02.append("<input type='hidden' id='"+newname+"' name='"+newname+"' value='"+inteutil.getSapInAndOutParameterCount("1",baseid,RecordSet.getString("id"))+"'><TABLE class=ListStyle cellspacing=1 id='"+newtable+"' >");	
							sapinParameter02.append("<tr class=Header><td ><input type='checkbox' onclick='checkbox2(this,"+sap_inStructure+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td  colspan='7'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+sap_inStructure+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");	
							sapinParameter02.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='8'></TD></TR>");	
							int childstu=1;
							//得到某一个结构的所有项
							sql=" select * from sap_inStructure  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
							RecordSet02.execute(sql);
							while(RecordSet02.next())
							{
									//得到子表的对象
		 							String child01="sap02_"+sap_inStructure+"_"+childstu;
		 							String child02="oa02_"+sap_inStructure+"_"+childstu;
		 							String child03="con02_"+sap_inStructure+"_"+childstu;
		 							
		 							String child01Span="sap02_"+sap_inStructure+"_"+childstu+"span";
		 							String child02Span="oa02_"+sap_inStructure+"_"+childstu+"span";
		 							String address="add02_"+sap_inStructure+"_"+childstu;
		 							String sapfield=RecordSet02.getString("sapfield");
		 							String oafield=RecordSet02.getString("oafield");
		 							String convalue=RecordSet02.getString("constant");
		 							String ismainfield02=RecordSet02.getString("ismainfield");
									String fromfieldid02=RecordSet02.getString("fromfieldid");
									//value='"+ismainfield02+"_"+fromfieldid02+"'
		 							if("0".equals(w_type))
									{
			 							sapinParameter02.append("<tr>");
										sapinParameter02.append("<td><input type='checkbox' name='zibox'></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+newstru+"')></button><input type='hidden' name='"+child01+"' value='"+sapfield+"'><span>"+sapfield+"</span><span id='"+child01Span+"'></span></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child02+"' value='"+oafield+"' ><span>"+oafield+"</span><span id='"+child02Span+"'></span><input type=hidden name='"+address+"' value='"+ismainfield02+"_"+fromfieldid02+"'></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><input type='text' name='"+child03+"' value='"+convalue+"' ></td>");
										sapinParameter02.append("<td></td>");
										sapinParameter02.append("</tr>");
									}else
									{
										sapinParameter02.append("<tr>");
										sapinParameter02.append("<td><input type='checkbox' name='zibox'></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child02+"' value='"+oafield+"' ><span>"+oafield+"</span><span id='"+child02Span+"'></span><input type=hidden name='"+address+"' value='"+ismainfield02+"_"+fromfieldid02+"'></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+newstru+"')></button><input type='hidden' name='"+child01+"' value='"+sapfield+"'><span>"+sapfield+"</span><span id='"+child01Span+"'></span></td>");
										sapinParameter02.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
										sapinParameter02.append("<td><input type='text' name='"+child03+"' value='"+convalue+"' ></td>");
										sapinParameter02.append("<td></td>");
										sapinParameter02.append("</tr>");
									}
									childstu++;
							}
							sapinParameter02.append("</TABLE>");	
							sapinParameter02.append("</td></tr>");	
							sap_inStructure++;
						}
					}
			sapinParameter02.append(" </TABLE>");													
														
			//第三个---输出参数								 
																			  	
			StringBuffer sapinParameter03= new StringBuffer();
			sapinParameter03.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_03' style='table-layout: fixed;'>");
			sapinParameter03.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");
			sapinParameter03.append("<tr>");//28255
			sapinParameter03.append("<td>&nbsp;"+SystemEnv.getHtmlLabelName(28255 ,user.getLanguage())+"</td>");
			sapinParameter03.append("<td><button type='button' class='btn' id='bath_03' onclick='addBathFieldObj(4,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' id='add_03' onclick='addBathFieldObj(4,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button>");
			sapinParameter03.append("<button type='button' class='btn' id='del_03' onclick='addBathFieldObj(4,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button>"); 
			sapinParameter03.append("<input type='hidden' id='hidden03' name='hidden03' value='");
			
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter03.append(spmsb.getExpstrcount());//模板里面的输出参数的总数
			}else{
					sapinParameter03.append(inteutil.getSapInAndOutParameterCount("3",baseid));
			}
			sapinParameter03.append("'></td></tr>"); 	
			sapinParameter03.append("<tr>");
			sapinParameter03.append("<td colspan='2'>");
				sapinParameter03.append(" <TABLE class=ListStyle cellspacing=1 id='chind03'>");
				sapinParameter03.append(" <tr class=Header>");
				sapinParameter03.append(" <td><input type='checkbox' id='cbox_03'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='7'>"+SystemEnv.getHtmlLabelName(30605 ,user.getLanguage())+"</td>");
				sapinParameter03.append(" </tr>");
				sapinParameter03.append(" <TR class=Line style='height:1px'><TD colSpan=8 style='padding:0px'></TD></TR>");
				
					if("save".equals(opera)&&"1".equals(loadmb))
					{
						List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", "");
				 	   if(list != null) {
								   for(int i=0;i<list.size();i++) {
								   		ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
										String input01="sap03_"+sap_outParameter;
										String input01Span="sap03_"+sap_outParameter+"span";
										String input04="setoa3_"+sap_outParameter;
										String address="add03_"+sap_outParameter;
										String input02="show03_"+sap_outParameter;//显示名--文本框
										String input02Span="show03_"+sap_outParameter+"span";//显示名--img
										String input03="dis03_"+sap_outParameter;//是否显示
										
										String ParamName=spmdb.getParamName();
										String ParamDesc=spmdb.getParamDesc();
										//value='"+ismainfield03+"_"+fromfieldid03+"'	
										if("0".equals(w_type))
										{
											sapinParameter03.append(" <tr>");
											sapinParameter03.append(" <td><input type='checkbox' name='cbox3'/></td>");
											sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
											sapinParameter03.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'  value='"+ParamName+"' ><span>"+ParamName+"</span><span id='"+input01Span+"'></span></td>");
											sapinParameter03.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
											sapinParameter03.append(" </td>");
											sapinParameter03.append("<td><input type='text' name='"+input02+"' value='"+ParamDesc+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
											sapinParameter03.append(" <td>");
											sapinParameter03.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
											sapinParameter03.append(" </td>");
											sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
											sapinParameter03.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input04+"' value=''><span></span><span></span><input type=hidden name='"+address+"' value=''></td>");
											sapinParameter03.append(" </tr>");
										}else
										{
											sapinParameter03.append(" <tr>");
											sapinParameter03.append(" <td><input type='checkbox' name='cbox3'/></td>");
											sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
											sapinParameter03.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'  value='"+ParamName+"' ><span>"+ParamName+"</span><span id='"+input01Span+"'></span></td>");
											sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
											sapinParameter03.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input04+"' value=''><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''	></td>");
											sapinParameter03.append(" </tr>");
										}
										
										sap_outParameter++;
									}
					}
							
					}else  if("update".equals(opera)&&!"2".equals(updateChangeService))
					{
						sql=" select * from sap_outParameter  where baseid='"+baseid+"' order by id";
						RecordSet.execute(sql);
						while(RecordSet.next())
						{
							String sapfield=RecordSet.getString("sapfield");
		 					String oafield=RecordSet.getString("oafield");
							String input01="sap03_"+sap_outParameter;
							String input01Span="sap03_"+sap_outParameter+"span";
							String input04="setoa3_"+sap_outParameter;
							String address="add03_"+sap_outParameter;
							String input02="show03_"+sap_outParameter;//显示名--文本框
							String input02Span="show03_"+sap_outParameter+"span";//显示名--img
							String input03="dis03_"+sap_outParameter;//是否显示
							String Display=RecordSet.getString("Display");
							String showname=RecordSet.getString("showname");
							String ismainfield03=RecordSet.getString("ismainfield");
							String fromfieldid03=RecordSet.getString("fromfieldid");
							//value='"+ismainfield03+"_"+fromfieldid03+"'	
							if("0".equals(w_type))
							{
								sapinParameter03.append(" <tr>");
								sapinParameter03.append(" <td><input type='checkbox' name='cbox3'/></td>");
								sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
								sapinParameter03.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'  value='"+sapfield+"' ><span>"+sapfield+"</span><span id='"+input01Span+"'></span></td>");
								sapinParameter03.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
								sapinParameter03.append(" </td>");
								sapinParameter03.append("<td><input type='text' name='"+input02+"' value='"+showname+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
								sapinParameter03.append(" <td>");
								if("1".equals(Display)){
									sapinParameter03.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 checked='checked'>");
								}else{
									sapinParameter03.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
								}
								sapinParameter03.append(" </td>");
								sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
								sapinParameter03.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input04+"' value='"+oafield+"'><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield03+"_"+fromfieldid03+"'></td>");
								sapinParameter03.append(" </tr>");
							}else
							{
								sapinParameter03.append(" <tr>");
								sapinParameter03.append(" <td><input type='checkbox' name='cbox3'/></td>");
								sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
								sapinParameter03.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'  value='"+sapfield+"' ><span>"+sapfield+"</span><span id='"+input01Span+"'></span></td>");
								sapinParameter03.append(" <td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
								sapinParameter03.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input04+"' value='"+oafield+"'><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield03+"_"+fromfieldid03+"'	></td>");
								//sapinParameter03.append(" <td>执行sql</td>");
								//sapinParameter03.append(" <td>");
								//sapinParameter03.append(" <textarea rows='3' cols='30'></textarea> ");
								//sapinParameter03.append(" </td>");
								sapinParameter03.append(" </tr>");
							}
							
							sap_outParameter++;
						}
					}
				sapinParameter03.append(" </TABLE>");
			sapinParameter03.append("</td>");
			sapinParameter03.append("</tr>"); 
			sapinParameter03.append("</table>");																		
																						
																					
			//第四个----输出结构																
																						
			StringBuffer sapinParameter04= new StringBuffer();
			sapinParameter04.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_04' style='table-layout: fixed;'>");
			sapinParameter04.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
			sapinParameter04.append(" <tr>");	
			sapinParameter04.append(" <td>&nbsp;"+SystemEnv.getHtmlLabelName(28256 ,user.getLanguage())+"</td>");	
			sapinParameter04.append(" <td><button type='button'  class='btn' id='bath_04' onclick=addBathFieldObj(5,1)>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' id='add_04' onclick='addBathFieldObj(5,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' id='del_04' onclick='addBathFieldObj(5,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button>");	
			sapinParameter04.append("<input type='hidden' id='hidden04' name='hidden04' value='");
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter04.append(spmsb.getExpstructcount());//模板里面的输出结构的总数
			}else{
					sapinParameter04.append(inteutil.getSapInAndOutParameterCount("4",baseid));
			}
			sapinParameter04.append("'></td>");
			sapinParameter04.append(" </tr>");	
				
				
				if("save".equals(opera)&&"1".equals(loadmb))
				{
						
						
							List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", true, "struct", "");
							if(list != null) {
								for(int i=0;i<list.size();i++) {
									ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
									
											String ParamName=spmdb.getParamName();
											String ParamDesc=spmdb.getParamDesc();
											String ParamCons=spmdb.getParamCons();
											int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId ,"export",ParamName);
											String newstru04="outstru_"+sap_outStructure;
											String bath04="bath4_"+sap_outStructure;
											String newname04="cbox4_"+sap_outStructure;
											String newtable04="sap_04_"+sap_outStructure;
											String newstru04Span="sap_04_"+sap_outStructure+"span";
											sapinParameter04.append(" <tr><td class='tdcenter'><input type='checkbox' name='cbox4'></td>");	
											sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(5,this)></button><input type='hidden' class='selectmax_width' id='"+newstru04+"' name='"+newstru04+"' value='"+ParamName+"' ><span>"+ParamName+"</span><span id='"+newstru04Span+"'></span>&nbsp;&nbsp;&nbsp; <input type='hidden' id='"+newname04+"' name='"+newname04+"' value='"+newchtable+"'>");
											//循环结构下有多少条数据
											sapinParameter04.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable04+"'>");	
											sapinParameter04.append(" <tr class=Header><td><input type='checkbox' id='cbox_04' onclick='checkbox4(this,"+sap_outStructure+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td>"+SystemEnv.getHtmlLabelName(30605 ,user.getLanguage())+"</td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath04+"' onclick=addBathFieldObj(6,1,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(6,2,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(6,3,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
											int childstu=1;
											List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", ParamName);
											if(listtemp != null) {
												for(int j=0;j<listtemp.size();j++) {
													ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
													String ParamDBName=spmdbtemp.getParamName();
													String ParamDBDesc=spmdbtemp.getParamDesc();
													String ParamDBCons=spmdbtemp.getParamCons();
													//得到子表的对象
						 							String child01="sap04_"+sap_outStructure+"_"+childstu;
						 							String address="add04_"+sap_outStructure+"_"+childstu;
			 										String child01Span="sap04_"+sap_outStructure+"_"+childstu+"span";
						 							String child05="setoa4_"+sap_outStructure+"_"+childstu;
			 										String input02="show04_"+sap_outStructure+"_"+childstu;//显示名--文本框
													String input02Span="show04_"+sap_outStructure+"_"+childstu+"span";//显示名--img
													String input03="dis04_"+sap_outStructure+"_"+childstu;//是否显示
													if("0".equals(w_type))
													{
														sapinParameter04.append(" <tr>");
														sapinParameter04.append(" <td><input type='checkbox' name='zibox'></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+newstru04+"')></button><input type='hidden' name='"+child01+"' value='"+ParamDBName+"'/><span>"+ParamDBName+"</span><span id='"+child01Span+"'></span></td>");
														sapinParameter04.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
														sapinParameter04.append("<td><input type='text' name='"+input02+"' value='"+ParamDBDesc+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
														sapinParameter04.append(" <td>");
														sapinParameter04.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
														sapinParameter04.append(" </td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child05+"' value=''/><span></span><span></span><input type=hidden name='"+address+"' value=''></td>");
														sapinParameter04.append(" </tr>");
													}else
													{
														sapinParameter04.append(" <tr>");
														sapinParameter04.append(" <td><input type='checkbox' name='zibox'></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+newstru04+"')></button><input type='hidden' name='"+child01+"' value='"+ParamDBName+"'/><span>"+ParamDBName+"</span><span id='"+child01Span+"'></span></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child05+"' value=''/><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''></td>");
														sapinParameter04.append(" </tr>");
													}
													childstu++;
												}
										}
										sapinParameter04.append(" </TABLE>");		
										sapinParameter04.append(" </td>");	
										sapinParameter04.append(" </tr>");	
										sap_outStructure++;
								}
							}
				}else if("update".equals(opera)&&!"2".equals(updateChangeService))
				{	
					
					sql=" select * from sap_complexname where comtype=4 and   baseid='"+baseid+"' ";
					RecordSet.execute(sql);
					while(RecordSet.next())
					{
							
							String stuname=RecordSet.getString("name");
							String newstru04="outstru_"+sap_outStructure;
							String bath04="bath4_"+sap_outStructure;
							String newname04="cbox4_"+sap_outStructure;
							String newtable04="sap_04_"+sap_outStructure;
							String newstru04Span="sap_04_"+sap_outStructure+"span";
							sapinParameter04.append(" <tr><td class='tdcenter'><input type='checkbox' name='cbox4'></td>");	
							sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(5,this)></button><input type='hidden' class='selectmax_width' id='"+newstru04+"' name='"+newstru04+"' value='"+stuname+"' ><span>"+stuname+"</span><span id='"+newstru04Span+"'></span>&nbsp;&nbsp;&nbsp; <input type='hidden' id='"+newname04+"' name='"+newname04+"' value='"+inteutil.getSapInAndOutParameterCount("2",baseid,RecordSet.getString("id"))+"'>");
											//循环结构下有多少条数据
											sapinParameter04.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable04+"'>");	
											sapinParameter04.append(" <tr class=Header><td><input type='checkbox' id='cbox_04' onclick='checkbox4(this,"+sap_outStructure+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td>"+SystemEnv.getHtmlLabelName(30605 ,user.getLanguage())+"</td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath04+"' onclick=addBathFieldObj(6,1,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(6,2,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(6,3,'"+newstru04+"','"+sap_outStructure+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
												
												int childstu=1;
												sql=" select * from sap_outStructure  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
												RecordSet02.execute(sql);
												while(RecordSet02.next())
												{
													//得到子表的对象
						 							String child01="sap04_"+sap_outStructure+"_"+childstu;
						 							String address="add04_"+sap_outStructure+"_"+childstu;
			 										String child01Span="sap04_"+sap_outStructure+"_"+childstu+"span";
						 							String child05="setoa4_"+sap_outStructure+"_"+childstu;
						 							String oafield=RecordSet02.getString("oafield");
			 										String sapfield=RecordSet02.getString("sapfield");
			 										String Display=RecordSet02.getString("Display");
			 										String input02="show04_"+sap_outStructure+"_"+childstu;//显示名--文本框
													String input02Span="show04_"+sap_outStructure+"_"+childstu+"span";//显示名--img
													String input03="dis04_"+sap_outStructure+"_"+childstu;//是否显示
													String showname=RecordSet02.getString("showname");
													
													String ismainfield04=RecordSet02.getString("ismainfield");
													String fromfieldid04=RecordSet02.getString("fromfieldid");
													//value='"+ismainfield04+"_"+fromfieldid04+"'	
													
													if("0".equals(w_type))
													{
														sapinParameter04.append(" <tr>");
														sapinParameter04.append(" <td><input type='checkbox' name='zibox'></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+newstru04+"')></button><input type='hidden' name='"+child01+"' value='"+sapfield+"'/><span>"+sapfield+"</span><span id='"+child01Span+"'></span></td>");
														sapinParameter04.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
														sapinParameter04.append("<td><input type='text' name='"+input02+"' value='"+showname+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
														sapinParameter04.append(" <td>");
														if("1".equals(Display)){
															sapinParameter04.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 checked='checked'>");
														}else{
															sapinParameter04.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
														}
														sapinParameter04.append(" </td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child05+"' value='"+oafield+"'/><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield04+"_"+fromfieldid04+"'></td>");
														sapinParameter04.append(" </tr>");
													}else
													{
														sapinParameter04.append(" <tr>");
														sapinParameter04.append(" <td><input type='checkbox' name='zibox'></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+newstru04+"')></button><input type='hidden' name='"+child01+"' value='"+sapfield+"'/><span>"+sapfield+"</span><span id='"+child01Span+"'></span></td>");
														sapinParameter04.append(" <td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
														sapinParameter04.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+child05+"' value='"+oafield+"'/><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield04+"_"+fromfieldid04+"'></td>");
														
														//sapinParameter04.append(" <td>执行sql</td>");
														//sapinParameter04.append(" <td>");
														//sapinParameter04.append(" <textarea rows='3' cols='30'></textarea> ");
														//sapinParameter04.append(" </td>");
														
														sapinParameter04.append(" </tr>");
													}
													childstu++;
												}
											sapinParameter04.append(" </TABLE>");		
											
										sapinParameter04.append(" </td>");	
							sapinParameter04.append(" </tr>");	
							sap_outStructure++;
					}	
			}									  	
			sapinParameter04.append(" </TABLE>");																				
																					
																				
																				
			//第五个---输出表																																					
			StringBuffer sapinParameter05= new StringBuffer();
			sapinParameter05.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_05' style='table-layout: fixed;'>");
			sapinParameter05.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
			sapinParameter05.append(" <tr>");	
			sapinParameter05.append(" <td>&nbsp;"+SystemEnv.getHtmlLabelName(28260 ,user.getLanguage())+"</td>");	
			sapinParameter05.append(" <td><button type='button'  class='btn' id='bath_05' onclick='addBathFieldObj(7,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' id='add_05' onclick='addBathFieldObj(7,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' id='del_05' onclick='addBathFieldObj(7,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button>");	
			sapinParameter05.append(" <input type='hidden' id='hidden05' name='hidden05' value='");
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter05.append(spmsb.getExptablecount());//模板里面的输出表的总数
			}else{
				   sapinParameter05.append(inteutil.getSapInAndOutParameterCount("5",baseid));
			}
			sapinParameter05.append("'></td></tr>");
			
			if("save".equals(opera)&&"1".equals(loadmb))
			{
				
				List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", true, "table", "");
				if(list != null) {
					for(int i=0;i<list.size();i++) {
						ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
						
						String ParamName=spmdb.getParamName();
						String ParamDesc=spmdb.getParamDesc();
						String ParamCons=spmdb.getParamCons();
						
						int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "export",ParamName);
											
						String newstru05="outtable_"+sap_outTable;
						String newstru05Span="outtable_"+sap_outTable+"span";
						String bath05="bath5_"+sap_outTable;
						String newname05="cbox5_"+sap_outTable;
						String newtable05="sap_05_"+sap_outTable;
						String newtable05son="sapson_05_"+sap_outTable;//where条件所在的表格
						String newtable05soncount="sapson_05count_"+sap_outTable;//where条件总行数
						String backtable="backtable5_"+sap_outTable;	//回写表
						String backoper="backoper5_"+sap_outTable;	//回写操作
						sapinParameter05.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>");
						sapinParameter05.append("<td> ");
						
						sapinParameter05.append(" <TABLE  cellspacing=1>");
						sapinParameter05.append(" <tr>");
						sapinParameter05.append(" <td>");
						sapinParameter05.append(""+SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru05+"' name='"+newstru05+"' value='"+ParamName+"'><span>"+ParamName+"</span><span id='"+newstru05Span+"'></span>  ");
						if("1".equals(w_type))
						{
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");//30612
							sapinParameter05.append(""+SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())+"<button type='button' class='browser' onclick=backtable(this)></button> ");
							sapinParameter05.append("<input type='hidden' name='"+backtable+"' id='"+backtable+"'  value=''><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span> ");
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");//30614
							sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())+"<select name='"+backoper+"' id='"+backoper+"'>");
							sapinParameter05.append("<option value=0>"+SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())+"</option> ");
							sapinParameter05.append("<option value=1>"+SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())+"</option>");
							sapinParameter05.append("<option value=2>"+SystemEnv.getHtmlLabelName(103 ,user.getLanguage())+"</option>");
							sapinParameter05.append("<option value=3>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</option> ");
							sapinParameter05.append("</select> ");
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");
						}
						
						sapinParameter05.append("");
						sapinParameter05.append(" <input type='hidden' id='"+newname05+"' name='"+newname05+"' value='"+newchtable+"'>");
						sapinParameter05.append(" </td>");
						sapinParameter05.append(" </tr>");
						sapinParameter05.append(" </table>");
						
						sapinParameter05.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable05+"'>");
						sapinParameter05.append("<tr class=Header><td><input type='checkbox' onclick='checkbox5(this,"+sap_outTable+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath05+"' onclick=addBathFieldObj(8,1,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru05+"','"+sap_outTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
						sapinParameter05.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>");
								
						int childstu=1;
							
						
						List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "export", false, "", ParamName);
						if(listtemp != null) {
							for(int j=0;j<listtemp.size();j++) {
								ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
								
								
								String ParamDBName=spmdbtemp.getParamName();
								String ParamDBDesc=spmdbtemp.getParamDesc();
								String ParamDBCons=spmdbtemp.getParamCons();
													
								String input01="sap05_"+sap_outTable+"_"+childstu;
								String input02="show05_"+sap_outTable+"_"+childstu;//显示名--文本框
								String input02Span="show05_"+sap_outTable+"_"+childstu+"span";//显示名--img
								String input03="dis05_"+sap_outTable+"_"+childstu;//是否显示
								String input04="sea05_"+sap_outTable+"_"+childstu;
								String input05="key05_"+sap_outTable+"_"+childstu;
								String input06="setoa5_"+sap_outTable+"_"+childstu;
								String address="add05_"+sap_outTable+"_"+childstu;
								String input01Span="sap05_"+sap_outTable+"_"+childstu+"span";
								if("0".equals(w_type))
								{
									sapinParameter05.append("<tr>");
									sapinParameter05.append("<td><input type='checkbox' name='zibox'></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+newstru05+"')></button><input type='hidden' name='"+input01+"' value='"+ParamDBName+"' ><span>"+ParamDBName+"</span><span id='"+input01Span+"'></span></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><input type='text' name='"+input02+"' value='"+ParamDBDesc+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
									
										sapinParameter05.append(" <td>");
										sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
										sapinParameter05.append("  "+SystemEnv.getHtmlLabelName(20778 ,user.getLanguage())+"<input type='checkbox' name='"+input04+"' value=1 >");
										sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(28277 ,user.getLanguage())+"<input type='checkbox' name='"+input05+"' value=1 >");
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
										sapinParameter05.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input06+"' value=''/><span></span><span></span><input type=hidden name='"+address+"' value=''></td>");
									sapinParameter05.append("</tr>");
								}else
								{
									sapinParameter05.append("<tr>");
									sapinParameter05.append("<td><input type='checkbox' name='zibox'></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+newstru05+"')></button><input type='hidden' name='"+input01+"' value='"+ParamDBName+"' ><span>"+ParamDBName+"</span><span id='"+input01Span+"'></span></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"' value=''/><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''	></td>");
									sapinParameter05.append("</tr>");
								}
								childstu++;
							
							
							}
							
							
						}
						
						
						sapinParameter05.append("</TABLE>");
						if("1".equals(w_type))
						{
							sapinParameter05.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'>");
							sapinParameter05.append(" <tr>");
									sapinParameter05.append(" <td>");//30616
									sapinParameter05.append(""+SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td colspan=4>");
									sapinParameter05.append("");
									sapinParameter05.append(" </td>");
							sapinParameter05.append(" </tr>");
							sapinParameter05.append(" <tr class=Header>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" <input type='checkbox' onclick=checkbox5son(this,"+sap_outTable+")>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td style='text-align:right'>");
									sapinParameter05.append(" <button type='button'  class='btn' onclick=addBathFieldObj(12,1,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(12,2,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(12,3,'"+newstru05+"','"+sap_outTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button><input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='0'>");
									sapinParameter05.append(" </td>");
							sapinParameter05.append(" </tr>");
							sapinParameter05.append(" </TABLE>");
						}
						sapinParameter05.append("</td></tr>");
					    sap_outTable++;
					}
				}
				
			 }else if("update".equals(opera)&&!"2".equals(updateChangeService))
			{
				//查出所有的输出表
				sql=" select * from sap_complexname where comtype=2 and  baseid='"+baseid+"'  ";
				RecordSet.execute(sql);
				while(RecordSet.next())
				{		
						String newstru05="outtable_"+sap_outTable;
						String newstru05Span="outtable_"+sap_outTable+"span";
						String bath05="bath5_"+sap_outTable;
						String newname05="cbox5_"+sap_outTable;
						String newtable05="sap_05_"+sap_outTable;
						String newtable05son="sapson_05_"+sap_outTable;//where条件所在的表格
						String newtable05soncount="sapson_05count_"+sap_outTable;//where条件总行数
						String backtable="backtable5_"+sap_outTable;	//回写表
						String backoper="backoper5_"+sap_outTable;	//回写操作
						String name=RecordSet.getString("name");
						String comid=RecordSet.getString("id");
						
						String backtablename=RecordSet.getString("backtable");
						String backoperate=RecordSet.getString("backoper");
						
						sapinParameter05.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>");
						sapinParameter05.append("<td> ");
						
						sapinParameter05.append(" <TABLE  cellspacing=1>");
						sapinParameter05.append(" <tr>");
						sapinParameter05.append(" <td>");
						sapinParameter05.append(""+SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru05+"' name='"+newstru05+"' value='"+name+"'><span>"+name+"</span><span id='"+newstru05Span+"'></span>  ");
						if("1".equals(w_type))
						{
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");//30612
							sapinParameter05.append(""+SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())+"<button type='button' class='browser' onclick=backtable(this)></button> ");
							sapinParameter05.append("<input type='hidden' name='"+backtable+"' id='"+backtable+"'  value='"+backtablename+"'><span>"+backtablename+"</span><span></span> ");
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");//30614
							sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())+"<select name='"+backoper+"' id='"+backoper+"'>");
							sapinParameter05.append("<option value=0>"+SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())+"</option> ");
							if("1".equals(backoperate))
							{
								
								sapinParameter05.append("<option value=1 selected='selected'>"+SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())+"</option>");
							}else
							{
								sapinParameter05.append("<option value=1>"+SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())+"</option>");
							}
							
							if("2".equals(backoperate))
							{
								sapinParameter05.append("<option value=2 selected='selected'>"+SystemEnv.getHtmlLabelName(103 ,user.getLanguage())+"</option>");
							}else
							{
								sapinParameter05.append("<option value=2>"+SystemEnv.getHtmlLabelName(103 ,user.getLanguage())+"</option>");
							}
							if("3".equals(backoperate))
							{
								sapinParameter05.append("<option value=3 selected='selected'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</option> ");
							}else
							{
								sapinParameter05.append("<option value=3>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</option> ");
							}
							sapinParameter05.append("</select> ");
							sapinParameter05.append(" </td>");
							sapinParameter05.append(" <td>");
						}
						
						sapinParameter05.append("");
						sapinParameter05.append(" <input type='hidden' id='"+newname05+"' name='"+newname05+"' value='"+inteutil.getSapInAndOutParameterCount("3",baseid,RecordSet.getString("id"))+"'>");
						sapinParameter05.append(" </td>");
						sapinParameter05.append(" </tr>");
						sapinParameter05.append(" </table>");
						
						sapinParameter05.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable05+"'>");
						sapinParameter05.append("<tr class=Header><td><input type='checkbox' onclick='checkbox5(this,"+sap_outTable+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath05+"' onclick=addBathFieldObj(8,1,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru05+"','"+sap_outTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
						sapinParameter05.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>");
								
							int childstu=1;
							sql=" select * from sap_outTable  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
							RecordSet02.execute(sql);
							while(RecordSet02.next())
							{
								
								String input01="sap05_"+sap_outTable+"_"+childstu;
								String input02="show05_"+sap_outTable+"_"+childstu;//显示名--文本框
								String input02Span="show05_"+sap_outTable+"_"+childstu+"span";//显示名--img
								String input03="dis05_"+sap_outTable+"_"+childstu;//是否显示
								String input04="sea05_"+sap_outTable+"_"+childstu;
								String input05="key05_"+sap_outTable+"_"+childstu;
								String input06="setoa5_"+sap_outTable+"_"+childstu;
								String address="add05_"+sap_outTable+"_"+childstu;
								String sapfield=RecordSet02.getString("sapfield");
								String showname=RecordSet02.getString("showname");
								String Display=RecordSet02.getString("Display");
								String Search=RecordSet02.getString("Search");
								String Primarykey=RecordSet02.getString("Primarykey");
								String oafield=RecordSet02.getString("oafield");
								String input01Span="sap05_"+sap_outTable+"_"+childstu+"span";
								String ismainfield05=RecordSet02.getString("ismainfield");
								String fromfieldid05=RecordSet02.getString("fromfieldid");
								//value='"+ismainfield05+"_"+fromfieldid05+"'	
								if("0".equals(w_type))
								{
									sapinParameter05.append("<tr>");
									sapinParameter05.append("<td><input type='checkbox' name='zibox'></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+newstru05+"')></button><input type='hidden' name='"+input01+"' value='"+sapfield+"' ><span>"+sapfield+"</span><span id='"+input01Span+"'></span></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(606 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><input type='text' name='"+input02+"' value='"+showname+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'></span></td>");
									
										sapinParameter05.append(" <td>");
										if("1".equals(Display)){
											sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 checked='checked'>");
										}else{
											sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())+"<input type='checkbox' name='"+input03+"' value=1 >");
										}
										if("1".equals(Search)){
											//20778
											sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(20778 ,user.getLanguage())+"<input type='checkbox' name='"+input04+"' value=1 checked='checked'>");
										}else{
											sapinParameter05.append("  "+SystemEnv.getHtmlLabelName(20778 ,user.getLanguage())+"<input type='checkbox' name='"+input04+"' value=1 >");
										}
										if("1".equals(Primarykey)){
										//28277
											sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(28277 ,user.getLanguage())+"<input type='checkbox' name='"+input05+"' value=1 checked='checked'>");
										}else{
											sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(28277 ,user.getLanguage())+"<input type='checkbox' name='"+input05+"' value=1 >");
										}
										
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" <td>"+SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())+"</td>");
										sapinParameter05.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input06+"' value='"+oafield+"'/><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield05+"_"+fromfieldid05+"'></td>");
									sapinParameter05.append("</tr>");
								}else
								{
									sapinParameter05.append("<tr>");
									sapinParameter05.append("<td><input type='checkbox' name='zibox'></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+newstru05+"')></button><input type='hidden' name='"+input01+"' value='"+sapfield+"' ><span>"+sapfield+"</span><span id='"+input01Span+"'></span></td>");
									sapinParameter05.append("<td>"+SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())+"</td>");
									sapinParameter05.append("<td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"' value='"+oafield+"'/><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield05+"_"+fromfieldid05+"'	></td>");
									
									//sapinParameter05.append(" <td>执行sql</td>");
									//sapinParameter05.append(" <td>");
									//sapinParameter05.append(" <textarea rows='3' cols='30'></textarea> ");
									//sapinParameter05.append(" </td>");
									sapinParameter05.append("</tr>");
								}
								childstu++;
							}
							
						sapinParameter05.append("</TABLE>");
						if("1".equals(w_type))
						{
							sapinParameter05.append(" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'>");
							sapinParameter05.append(" <tr>");
									sapinParameter05.append(" <td>");//30616
									sapinParameter05.append(""+SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td colspan=4>");
									sapinParameter05.append("");
									sapinParameter05.append(" </td>");
							sapinParameter05.append(" </tr>");
							sapinParameter05.append(" <tr class=Header>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" <input type='checkbox' onclick=checkbox5son(this,"+sap_outTable+")>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td>");
									sapinParameter05.append(" "+SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())+"");
									sapinParameter05.append(" </td>");
									sapinParameter05.append(" <td style='text-align:right'>");
									sapinParameter05.append(" <button type='button'  class='btn' onclick=addBathFieldObj(12,1,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(12,2,'"+newstru05+"','"+sap_outTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(12,3,'"+newstru05+"','"+sap_outTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button><input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='"+inteutil.getSapInAndOutParameterCount("5",baseid,comid)+"'>");
									sapinParameter05.append(" </td>");
									
									
							sapinParameter05.append(" </tr>");
								int childsonstu=1;
								sql=" select * from sap_outparaprocess  where baseid='"+baseid+"' and nameid='"+comid+"' order by ordernum";
								//System.out.println("页面输出表的查询"+sql);
								RecordSet02.execute(sql);
								while(RecordSet02.next())
								{
										String input01="sap05son_"+sap_outTable+"_"+childsonstu;
										String input02="set05son_"+sap_outTable+"_"+childsonstu;
										String input03="add05son_"+sap_outTable+"_"+childsonstu;
										String input04="con05son_"+sap_outTable+"_"+childsonstu;
										
										String  outsapfield=RecordSet02.getString("sapfield");
										String  outoafield=RecordSet02.getString("oafield");
										String  outconstant=RecordSet02.getString("constant");
										String  outismainfield=RecordSet02.getString("ismainfield");
										String  outfromfieldid=RecordSet02.getString("fromfieldid");
										String  outpingjie=outismainfield+"_"+outfromfieldid;
										sapinParameter05.append(" <tr>");
										sapinParameter05.append(" <td>");
										sapinParameter05.append(" <input type='checkbox' name='zibox'>");
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" <td>");
										sapinParameter05.append(" <button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+newstru05+"')></button><input type='hidden' name='"+input01+"' value='"+outsapfield+"'><span>"+outsapfield+"</span><span ></span>");
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" <td>");
										sapinParameter05.append(" <button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input02+"' value='"+outoafield+"'/><span>"+outoafield+"</span><span></span><input type=hidden name='"+input03+"' value='"+outpingjie+"'>");
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" <td colspan=2>");
										sapinParameter05.append(" <input type='text' name='"+input04+"' value='"+outconstant+"'>");
										
										sapinParameter05.append(" </td>");
										sapinParameter05.append(" </tr>");
										childsonstu++;
								}
							sapinParameter05.append(" </TABLE>");
						}
						
						sapinParameter05.append("</td></tr>");
						
					sap_outTable++;
				}	
			}
			sapinParameter05.append(" </TABLE>");																			
																				
																				
			//第六个输出参数tab																																					
			StringBuffer sapinParameter06= new StringBuffer();
			sapinParameter06.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_06' style='table-layout: fixed;'>");
			sapinParameter06.append(" <colgroup> <col width='110px'/>  <col width='*' /> </colgroup>");										 
			sapinParameter06.append(" <tr>");	//30620
			sapinParameter06.append(" <td>"+SystemEnv.getHtmlLabelName(30620 ,user.getLanguage())+"</td>");	
			sapinParameter06.append(" <td><button type='button' class='btn' id='add_06' onclick='addBathFieldObj(9,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' id='add_06' onclick='addBathFieldObj(9,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' id='del_06' onclick='addBathFieldObj(9,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button><input type='hidden' id='hidden06' name='hidden06' value='"+inteutil.getSapInAndOutParameterCount("6",baseid)+"'></td>");	
			sapinParameter06.append(" </tr>");																	
			sapinParameter06.append(" <tr>");	
			sapinParameter06.append(" <td colspan=2>");																			
								sapinParameter06.append("  <TABLE class=ListStyle cellspacing=1 style='table-layout: fixed;' id='sap_06_son'>");
								sapinParameter06.append(" <colgroup> <col width='30px'/> <col width='30%'/> <col width='*'/> </colgroup>");					
								sapinParameter06.append("  <tr class=Header>");	
								sapinParameter06.append("  <td><input type='checkbox' id='cbox_06'/></td>");	
								sapinParameter06.append("  <td>"+SystemEnv.getHtmlLabelName(28217 ,user.getLanguage())+"</td>");//28217	
								//sapinParameter06.append("  <td >流程类型</td>");	
								sapinParameter06.append("  <td>"+SystemEnv.getHtmlLabelName(19480 ,user.getLanguage())+"</td>");	
								sapinParameter06.append("  </tr>");	
								sapinParameter06.append("  <tr class=Line style='height:1px'>");	
								sapinParameter06.append("  <TD colSpan=3 style='padding:0px'></TD>");	
								sapinParameter06.append("  </tr>");
								
								sql=" select * from int_authorizeRight where baseid='"+baseid+"' order by ordernum";
								RecordSet.execute(sql);
								while(RecordSet.next())
								{	
									
									String autotype="autotype_"+int_authorizeRight;
									String autospan="autospan_"+int_authorizeRight;
									String autodeti="autodeti_"+int_authorizeRight;
									String autowfid="autowfid_"+int_authorizeRight;
									String autouserorwf="autouserorwf_"+int_authorizeRight;
									String autowfidspan="autowfidspan_"+int_authorizeRight;
									
									String	type=RecordSet.getString("type");
									String	resourceids=RecordSet.getString("resourceids");
									String	roleids =RecordSet.getString("roleids");
									String	wfids=RecordSet.getString("wfids");
									String  autotypeid=RecordSet.getString("id");
									oldautotypeid+=autotypeid+",";
									String[] hrmidarr = Util.TokenizerString2(resourceids,",");
									String hrmnames = "";
									for(int i = 0; i<hrmidarr.length; i++){
										hrmnames += ResourceComInfo.getLastname(hrmidarr[i]) + ",";
									}
									if(hrmnames.length() > 0){
										hrmnames = hrmnames.substring(0,hrmnames.length()-1);
									}	
									String[] roleidarr = Util.TokenizerString2(roleids,",");
									String rolenames = "";
									for(int i = 0; i<roleidarr.length; i++){
										rolenames += RolesComInfo.getRolesRemark(roleidarr[i]) + ",";
									}
									if(rolenames.length() > 0){
										rolenames = rolenames.substring(0,rolenames.length()-1);
									}
									String[] wfidarr = Util.TokenizerString2(wfids,",");
									String wfnames = "";
									for(int i = 0; i<wfidarr.length; i++){
										wfnames += WorkflowComInfo.getWorkflowname(wfidarr[i]) + ",";
									}
									if(wfnames.length() > 0){
										wfnames = wfnames.substring(0,wfnames.length()-1);
									}
									sapinParameter06.append("  <tr>");
									sapinParameter06.append(" <td><input type='checkbox' name='autho'></td>");
									sapinParameter06.append(" <td>");
									sapinParameter06.append(" <select name='"+autotype+"' id='"+autotype+"' onchange=changerole('"+autospan+"','"+autouserorwf+"')>");
									sapinParameter06.append("<option value=1>"+SystemEnv.getHtmlLabelName(179 ,user.getLanguage())+"</option>");
									if("2".equals(type))
									{
										sapinParameter06.append("<option value=2 selected>"+SystemEnv.getHtmlLabelName(122 ,user.getLanguage())+"</option>");
									}else
									{
										sapinParameter06.append("<option value=2 >"+SystemEnv.getHtmlLabelName(122 ,user.getLanguage())+"</option>");
									}
									sapinParameter06.append("</select>");
									sapinParameter06.append(" <button type='button' class='browser' onclick=changebrotype(1,'"+autotype+"','"+autospan+"','"+autouserorwf+"')></button>");
									if("1".equals(type))
									{
										sapinParameter06.append(" <span id='"+autospan+"'>"+hrmnames+"</span>");
										sapinParameter06.append(" <input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"' value='"+resourceids+"'>");
									}else if("2".equals(type))
									{
										sapinParameter06.append(" <span id='"+autospan+"'>"+rolenames+"</span>");
										sapinParameter06.append(" <input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"' value='"+roleids+"'>");
									}
									sapinParameter06.append(" </td>");
									//sapinParameter06.append("<td>");
									//sapinParameter06.append(" 工作流程<button type='button' class='browser' onclick=changebrotype(3,'"+autowfid+"','"+autowfidspan+"')></button>");
									//sapinParameter06.append(" <input type='hidden' id='"+autowfid+"' name='"+autowfid+"' value='"+wfids+"'>");
									//sapinParameter06.append(" <span id='"+autowfidspan+"'>"+wfnames+"</span>");
									//sapinParameter06.append("</td>");
									sapinParameter06.append(" <td>");
									sapinParameter06.append(" <button class=btn type=button    onclick=changebrotype(2,'"+autodeti+"','')>详细设置</button>");
									sapinParameter06.append(" <input type='hidden' id='"+autodeti+"' name='"+autodeti+"' value='"+autotypeid+"'>");
									sapinParameter06.append(" </td>");
									sapinParameter06.append("  </tr>");	
									int_authorizeRight++;
								}
								
								sapinParameter06.append("  </table>");	
			sapinParameter06.append(" </td></tr>");	
			sapinParameter06.append(" </TABLE>");	
			
			
			
			//第七个---输入表																																			
			StringBuffer sapinParameter07= new StringBuffer();
			sapinParameter07.append("<TABLE class='ListStyle marginTop0 shownone' cellspacing=1 id='sap_07' style='table-layout: fixed;'>");
			sapinParameter07.append(" <colgroup> <col width='120px'/>  <col width='*' /> </colgroup>");										 
			sapinParameter07.append(" <tr>");	
			sapinParameter07.append(" <td>&nbsp;"+SystemEnv.getHtmlLabelName(30712 ,user.getLanguage())+"</td>");	
			sapinParameter07.append(" <td><button type='button'  class='btn' id='bath_07' onclick='addBathFieldObj(10,1)'>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button><button type='button' class='btn' id='add_07' onclick='addBathFieldObj(10,2)'>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' id='del_07' onclick='addBathFieldObj(10,3)'>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button>");	
			sapinParameter07.append(" <input type='hidden' id='hidden07' name='hidden07' value='");
			if("save".equals(opera)&&"1".equals(loadmb)){
					sapinParameter07.append(spmsb.getImptablecount());//模板里面的输入表的总数
			}else{
					sapinParameter07.append(inteutil.getSapInAndOutParameterCount("7",baseid));
			}
			sapinParameter07.append("'></td></tr>");
			if("save".equals(opera)&&"1".equals(loadmb)&&"1".equals(w_type))
			{
					List list = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", true, "table", "");
					if(list != null) {
						
						for(int i=0;i<list.size();i++) {
								ServiceParamModeDisBean spmdb = (ServiceParamModeDisBean)list.get(i);
								String ParamName=spmdb.getParamName();
								String ParamDesc=spmdb.getParamDesc();
								String ParamCons=spmdb.getParamCons();
								
								int newchtable = ServiceParamModeDisUtil.getCompFieldCountByName(regservice, paramModeId, "import",ParamName);
									
								String newstru07="outtable7_"+sap_inTable;
								String newstru07Span="outtable7_"+sap_inTable+"span";
								String bath07="bath7_"+sap_inTable;
								String newname07="cbox7_"+sap_inTable;
								String newtable07="sap_07_"+sap_inTable;
								String backtable="backtable7_"+sap_inTable;	//写入表
		
								
								sapinParameter07.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox7'></td>");
								sapinParameter07.append("<td>");
								
								sapinParameter07.append("<table  cellspacing=1>");
								sapinParameter07.append("<tr>");
								sapinParameter07.append("<td>");
								sapinParameter07.append(""+SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru07+"' name='"+newstru07+"' value='"+ParamName+"'/><span>"+ParamName+"</span><span id='"+newstru07Span+"'></span>");
								sapinParameter07.append("<input type='hidden' id='"+newname07+"' name='"+newname07+"' value='"+newchtable+"'>");
								sapinParameter07.append("</td>");
								
								sapinParameter07.append("<td>");
								sapinParameter07.append("写入表<button type='button' class='browser' onclick=backtable(this)></button> ");
								sapinParameter07.append("<input type='hidden' name='"+backtable+"' id='"+backtable+"'  value=''><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span> ");
								sapinParameter07.append("</td>");
								
								sapinParameter07.append("</tr>");
								sapinParameter07.append("</table>");
								
								
								sapinParameter07.append("<TABLE class=ListStyle cellspacing=1 id='"+newtable07+"'>");
								sapinParameter07.append("<tr class=Header><td><input type='checkbox' onclick='checkbox7(this,"+sap_inTable+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath07+"' onclick=addBathFieldObj(11,1,'"+newstru07+"','"+sap_inTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(11,2,'"+newstru07+"','"+sap_inTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(11,3,'"+newstru07+"','"+sap_inTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
								sapinParameter07.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>");
										
								int childstu=1;
							
								List listtemp = ServiceParamModeDisUtil.getParamsModeDisById(regservice, paramModeId, "import", false, "", ParamName); 
								if(listtemp != null) {
									for(int j=0;j<listtemp.size();j++) {
													ServiceParamModeDisBean spmdbtemp = (ServiceParamModeDisBean)listtemp.get(j);
													String ParamDBName=spmdbtemp.getParamName();
													String ParamDBDesc=spmdbtemp.getParamDesc();
													String ParamDBCons=spmdbtemp.getParamCons();
													
													String input01="sap07_"+sap_inTable+"_"+childstu;
													String input02="show07_"+sap_inTable+"_"+childstu;//显示名--文本框
													String input02Span="show07_"+sap_inTable+"_"+childstu+"span";//显示名--img
													String input03="con07_"+sap_inTable+"_"+childstu;
													String input06="setoa7_"+sap_inTable+"_"+childstu;
													String address="add07_"+sap_inTable+"_"+childstu;
													String input01Span="sap07_"+sap_inTable+"_"+childstu+"span";
													//value='"+ismainfield07+"_"+fromfieldid07+"'	
													
													sapinParameter07.append("<tr>");
													sapinParameter07.append("<td><input type='checkbox' name='zibox'></td>");
													sapinParameter07.append(" <td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
													sapinParameter07.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"' value=''/><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"' value=''	></td>");
													sapinParameter07.append("<td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
													sapinParameter07.append("<td><button type='button' class='browser' onclick=addOneFieldObj(11,this,'"+newstru07+"')></button><input type='hidden' name='"+input01+"' value='"+ParamDBName+"'/><span>"+ParamDBName+"</span><span id='"+input01Span+"'></span></td>");
													sapinParameter07.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
													sapinParameter07.append("<td><input type='text' name='"+input03+"' value='"+ParamDBCons+"'></td>");
													sapinParameter07.append("</tr>");
													childstu++;
									}
								}
						
						sapinParameter07.append("</TABLE>");
						sapinParameter07.append("</td></tr>");
						sap_inTable++;	
						}
					}
			}else  if("update".equals(opera)&&!"2".equals(updateChangeService)&&"1".equals(w_type))
			{
				//查出所有的输入表
				sql=" select * from sap_complexname where comtype=1 and   baseid='"+baseid+"'  ";
				//System.out.println("输入表页面查询"+sql);
				RecordSet.execute(sql);
				while(RecordSet.next())
				{		
						String newstru07="outtable7_"+sap_inTable;
						String newstru07Span="outtable7_"+sap_inTable+"span";
						String bath07="bath7_"+sap_inTable;
						String newname07="cbox7_"+sap_inTable;
						String newtable07="sap_07_"+sap_inTable;
						String backtable="backtable7_"+sap_inTable;	//写入表
						String name=RecordSet.getString("name");
						String backtablename=RecordSet.getString("backtable");//写入表
						
						sapinParameter07.append("<tr><td class='tdcenter'><input type='checkbox' name='cbox7'></td>");
						sapinParameter07.append("<td>");
						
						sapinParameter07.append("<table  cellspacing=1>");
						sapinParameter07.append("<tr>");
						sapinParameter07.append("<td>");
						sapinParameter07.append(""+SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())+"<button type='button' class='browser' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru07+"' name='"+newstru07+"' value='"+name+"'/><span>"+name+"</span><span id='"+newstru07Span+"'></span>");
						sapinParameter07.append("<input type='hidden' id='"+newname07+"' name='"+newname07+"' value='"+inteutil.getSapInAndOutParameterCount("4",baseid,RecordSet.getString("id"))+"'>");
						sapinParameter07.append("</td>");
						
						sapinParameter07.append("<td>");
						sapinParameter07.append("写入表<button type='button' class='browser' onclick=backtable(this)></button> ");
						sapinParameter07.append("<input type='hidden' name='"+backtable+"' id='"+backtable+"'  value='"+backtablename+"'><span>"+backtablename+"</span><span></span> ");
						sapinParameter07.append("</td>");
						
						sapinParameter07.append("</tr>");
						sapinParameter07.append("</table>");
						
						
						sapinParameter07.append("<TABLE class=ListStyle cellspacing=1 id='"+newtable07+"'>");
						sapinParameter07.append("<tr class=Header><td><input type='checkbox' onclick='checkbox7(this,"+sap_inTable+")'/>"+SystemEnv.getHtmlLabelName(556 ,user.getLanguage())+"</td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath07+"' onclick=addBathFieldObj(11,1,'"+newstru07+"','"+sap_inTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())+"</button> <button type='button' class='btn' onclick=addBathFieldObj(11,2,'"+newstru07+"','"+sap_inTable+"','"+backtable+"')>"+SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+"</button><button type='button' class='btn' onclick=addBathFieldObj(11,3,'"+newstru07+"','"+sap_inTable+"')>"+SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())+"</button></td></tr>");
						sapinParameter07.append("<TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>");
								
							int childstu=1;
							sql=" select * from sap_inTable  where baseid='"+baseid+"' and nameid='"+RecordSet.getString("id")+"' order by id";
							RecordSet02.execute(sql);
							while(RecordSet02.next())
							{
								
								String input01="sap07_"+sap_inTable+"_"+childstu;
								String input02="show07_"+sap_inTable+"_"+childstu;//显示名--文本框
								String input02Span="show07_"+sap_inTable+"_"+childstu+"span";//显示名--img
								String input03="con07_"+sap_inTable+"_"+childstu;
								String input06="setoa7_"+sap_inTable+"_"+childstu;
								String address="add07_"+sap_inTable+"_"+childstu;
								String sapfield=RecordSet02.getString("sapfield");
								String oafield=RecordSet02.getString("oafield");
								String constant7=RecordSet02.getString("constant");
								String input01Span="sap07_"+sap_inTable+"_"+childstu+"span";
								String ismainfield07=RecordSet02.getString("ismainfield");
								String fromfieldid07=RecordSet02.getString("fromfieldid");
								//value='"+ismainfield07+"_"+fromfieldid07+"'	
								
								sapinParameter07.append("<tr>");
								sapinParameter07.append("<td><input type='checkbox' name='zibox'></td>");
								sapinParameter07.append(" <td>"+SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())+"</td>");
								sapinParameter07.append(" <td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"' value='"+oafield+"'/><span>"+oafield+"</span><span></span><input type=hidden name='"+address+"' value='"+ismainfield07+"_"+fromfieldid07+"'	></td>");
								sapinParameter07.append("<td>"+SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())+"</td>");
								sapinParameter07.append("<td><button type='button' class='browser' onclick=addOneFieldObj(11,this,'"+newstru07+"')></button><input type='hidden' name='"+input01+"' value='"+sapfield+"'/><span>"+sapfield+"</span><span id='"+input01Span+"'></span></td>");
								sapinParameter07.append("<td>"+SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())+"</td>");
								sapinParameter07.append("<td><input type='text' name='"+input03+"' value='"+constant7+"'></td>");
								sapinParameter07.append("</tr>");
								childstu++;
							}
							
						sapinParameter07.append("</TABLE>");
						sapinParameter07.append("</td></tr>");
				
					sap_inTable++;
				}	
			}
			sapinParameter07.append(" </TABLE>");																		
													 										  	
	%>
	<!-- 业务逻辑 end-->
	
	
	<body>	
		
	<form  method="post" name="weaver" target="postiframe" action="/integration/browse/integrationBrowerOperation.jsp">
	
					<!--ListStyle 表格start  -->
				    <TABLE  cellspacing=1 style='table-layout: fixed;' id="tableid">
						<COLGROUP>
							<COL width="120px"/>
							<COL width="120px"/>
							<COL width="*"/>
						</COLGROUP>
						<TR class=DataLight>	
							<TD colspan="3">
									<div class="navigation">
								  			<ul>
											    <li class="selectedli" item=1><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(28245 ,user.getLanguage())%></a></li>
											    <li item=2><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(28251 ,user.getLanguage())%></a></li>
												<%
													if("1".equals(w_type))
													{
												%>
											    <li item=7><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(30712 ,user.getLanguage()) %></a></li>
											    <% 
													}
												 %>
											    <li item=3><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(28255 ,user.getLanguage())%></a></li>
												<li item=4><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(28256 ,user.getLanguage())%></a></li>
												<li item=5><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(28260 ,user.getLanguage())%></a></li>
												<%
													if("update".equals(opera)&&"0".equals(w_type))
													{
												%>
													<li item=6 id="dataauthli"><a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(30620 ,user.getLanguage()) %></a></li>
												<% 
													}
												 %>
												
										    </ul>
									</div>
									<!-- 第一个tab页里面的内容table--start -->
									 	<%=sapinParameter01%>
								    <!-- 第一个tab页里面的内容table--end -->
									<!-- 第二个tab页里面的内容-start -->
										<%=sapinParameter02%>
									<!-- 第二个tab页里面的内容--end -->
									<!-- 第三个tab页里面的内容-start -->
										<%=sapinParameter03%>
									<!-- 第三个tab页里面的内容--end -->
									<!-- 第四个tab页里面的内容-start -->
										<%=sapinParameter04%>
									<!-- 第四个tab页里面的内容--end -->
									<!-- 第五个tab页里面的内容-start -->
										<%=sapinParameter05%>
									<!-- 第五个tab页里面的内容--end -->
									<!-- 第六个tab页里面的内容-start -->
										<%=sapinParameter06%>
									<!-- 第六个tab页里面的内容--end -->
									<!-- 第七个tab页里面的内容-start -->
										<%=sapinParameter07%>
									<!-- 第七个tab页里面的内容--end -->
							</TD>
						</TR>
					</TABLE>
					<!--ListStyle 表格end  -->
					
				<input type="hidden" name="islocal" id="islocal" value="<%=islocal%>">	
				<input type="hidden" name="w_enable" id="w_enable">
				<input type="hidden" name="w_actionorder" id="w_actionorder">		
				<input type="hidden" name="isbill" id="isbill" value="<%=isbill%>">
				<input type="hidden" name="ispreoperator" id="ispreoperator">
				<input type="hidden" name="nodelinkid" id="nodelinkid">
				<input type="hidden" name="nodeid" id="nodeid" value="<%=nodeid%>">
				<input type="hidden" name="workflowid" id="workflowid" value="<%=workflowid%>">
				<input type="hidden" name="ismainfield" id="ismainfield" value="<%=ismainfield%>">	
				<input type="hidden" name="updateTableName" id="updateTableName" value="<%=updateTableName%>">	
				<input type="hidden" name="formid" id="formid" value="<%=formid%>">	
				<input type="hidden" name="baseid" value="<%=baseid%>">	
				<input type="hidden" name="opera" value="<%=opera%>">	
				<input type="hidden" name="mark" id="mark" value="<%=mark%>">
				<input type="hidden" name="regservice" id="regservice" value="<%=regservice%>">
				<input type="hidden" name="oldautotypeid" id="oldautotypeid" value="<%=oldautotypeid%>">
				<input type="hidden" name="w_type" id="w_type" value="<%=w_type%>">
				<input type="hidden" name="hpid" id="hpid">
				<input type="hidden" name="authcontorl" id="authcontorl">
				<input type="hidden" name="browsertype" id="browsertype" value="226">
				<input type="hidden" name="poolid" id="poolid">
				<input type="hidden" name="brodesc" id="brodesc">
				<input type="hidden" name="dataauth" id="dataauth">
				<iframe src="" style="display: none;" id="postiframe" name="postiframe"></iframe>
	</form>
	</body>
	
	<script type="text/javascript">
	$(document).ready(function() {  
			$("#cbox_01").click (function(){
					//$("#chind01 tr td:first-child [type=checkbox]").each(function(){ 
						//var flag=$("#cbox_01").attr('checked');
						//$(this).attr('checked',flag);
					//});
					$("#chind01 tr").parent().find("input[type='checkbox']").each(
						function(){
							var flag=$("#cbox_01").attr('checked');
							$(this).attr('checked',flag);
						}
					);
			});
			$("#cbox_03").click (function(){
					//$("#sap_03 tr td:first-child [type=checkbox][name=cbox3]").each(function(){ 
						//var flag=$("#cbox_03").attr('checked');
						//$(this).attr('checked',flag);
					//});

					$("#chind03 tr").parent().find("input[type='checkbox'][name=cbox3]").each(
						function(){
							var flag=$("#cbox_03").attr('checked');
							$(this).attr('checked',flag);
						}
					);
			});
			
			$("#cbox_06").click (function(){
					$("#sap_06 tr td:first-child [type=checkbox][name=autho]").each(function(){ 
						var flag=$("#cbox_06").attr('checked');
						$(this).attr('checked',flag);
					});
			});		
			$("#saveDate").click (function(){
					weaver.submit();
			});
			$(".navigation li").click (function(){
					$(this).parent().children().removeClass("selectedli"); 
					$(this).addClass("selectedli");
					var temp=$(this).attr("item");
					if(temp<=7)
					{
						$("#sap_01").hide();
						$("#sap_02").hide();
						$("#sap_03").hide();
						$("#sap_04").hide();
						$("#sap_05").hide();
						$("#sap_06").hide();
						$("#sap_07").hide();
						$("#sap_0"+temp).show();
					}
					//$(this).blur();//控制失去焦点虚线
			});
			<%
				if("2".equals(dataauth))
				{
			%>
					$("#dataauthli").click();
			<%
				}
			%>
 	}); 

 	function checkbox2(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_02"+"_"+chtable);
		$("#sap_02"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
		});
 	}

 	function checkbox4(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_04"+"_"+chtable);
		$("#sap_04"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
		});
 	}
 	function checkbox5(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_05"+"_"+chtable);
		$("#sap_05"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
		});
 	}
 	function checkbox7(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sap_07"+"_"+chtable);
		$("#sap_07"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
		});
 	}
 	function checkbox5son(obj,chtable)
 	{
 		//得到子表的id
 		var newtable=$("#sapson_05"+"_"+chtable);
		$("#sapson_05"+"_"+chtable+" tr td:first-child [type=checkbox][name=zibox]").each(function(){ 
			var flag=obj.checked;
			$(this).attr('checked',flag);
		});
 	}
 	setInterval(flashText, 500);  
 	function flashText()
 	{
 		//控制iframe自适应内容高度
 		var ifheight=$("#tableid").height();
 		window.parent.document.getElementById("maindiv").style.height=ifheight;
 	}

 	//选择oa字段
 	//wfid流程的id
 	//浏览按钮对象
 	//haveimg是否有img这个span,0没有,1有
 	//backtable回写表对象
 	function addOneFieldObjOA(obj,haveimg,backtable)
 	{
 			
 			var backtablevalue="";
 			if(backtable)//表明里面有值
 			{
 				if(!$("#"+backtable).val())//如果为空
 				{
 					
 					alert("<%=SystemEnv.getHtmlLabelName(30621 ,user.getLanguage()) %>"+"!");
 					return;
 				}
 				backtablevalue=$("#"+backtable).val();
 			}
 			//function addOneFieldObjOA标准 ,即$(obj).next().next()，每个nex()后面的对象是什么
			//--------------<button> 浏览按钮
			//--------------<input>  隐藏的oa字段name
			//--------------<span>   显示的oa字段name
			//--------------<span>   显示img
			//--------------<input>  记录字段(是否主字段，字段的数据库id,)
 			var formid=$("#formid").val();
 			var checkvalue=$(obj).next().val();
 		 	var temp=window.showModalDialog("/integration/browse/integrationBatchOA.jsp?formid="+formid+"&updateTableName=<%=updateTableName%>&w_type=<%=w_type%>&isbill=<%=isbill%>&backtable="+backtablevalue+"&srcType=<%=srcType%>","","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 			if(temp)
		 	{
		 		 if (temp.names!=""&&temp.viewtype!="-1")
		 		 {
					var tempname=temp.name.split(",");
					$(obj).next().val(tempname[1]);
					<%
					if("0".equals(w_type))
					{
					%>
						
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							
							$(obj).next().next().html(tempname[1]);
							$(obj).next().next().next().html("");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
						}else
						{
							$(obj).next().next().html(tempname[1]);
							$(obj).next().next().next().html("");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
						}
						
					<%
					}else
					{
					%>
					
						
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().next().html(tempname[1]);
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().html("");
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
						}else
						{
							$(obj).next().next().html(tempname[1]);
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().html("");
							$(obj).next().next().next().next().val(temp.viewtype.split(",")[1]);
						}
					<%	
					}
					%>
				 }else
				 {
				 	
				 	<%
					if("0".equals(w_type))
					{
					%>
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
				 			$(obj).next().next().next().html("");
				 			$(obj).next().next().next().next().val("");
						}else
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
							$(obj).next().next().next().html("<img src='/images/BacoError.gif' align=absMiddle>");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val("");
						}
					<%
					}else
					{
					%>
					
						if(haveimg=="0")//haveimg是否有img这个span,0没有,1有
						{
							$(obj).next().next().next().html("");
							//(1表示主表，0表示明细表)+字段的id+是否新表单字段
							$(obj).next().next().next().next().val("");
						}else
						{
							$(obj).next().val("");
				 			$(obj).next().next().html("");
				 			$(obj).next().next().next().html("<img src='/images/BacoError.gif' align=absMiddle>");
				 			$(obj).next().next().next().next().val("");
						}
					<%	
					}
					%>
				 }
		 	}
 	}
 	
 	
 	//所有单个字段操作
 	//type=1表示输入参数,obj表示sap字段浏览按钮
 	//type=2表示输入结构,obj表示结构体名浏览按钮的id
 	//type=3表示输入结构-->>某个结构体-->>sap字段,并且需要提供结构体的id
 	//type=4表示输出参数，obj表示sap字段浏览按钮
 	//type=5表示输出结构,obj表示结构体名浏览按钮
 	//type=6表示输出结构-->>某个结构-->>sap字段,并且需要提供结构体的的id
 	//type=7表示输出表,obj表示表名浏览按钮
 	//type=8表示输出表-->>某个表-->>>>sap字段,并且需要提供表的文本框的id
 	//type=9 ""留着不用
 	//type=10表示输入表，obj表示表名浏览按钮
 	//type=11表示输入表，>>某个表-->>>>sap字段,并且需要提供表的文本框的id
 	//type=12表示输出表的where条件管理表
 	function addOneFieldObj(type,obj,stuname)
 	{
 			//if(type=="3")
 			//{
 				//alert("输入结构的名称"+$("#"+stuname).val());
 			//}
 			//if(type=="6")
 			//{
 				//alert("输出结构的名称"+$("#"+stuname).val());
 			//}
 			//if(type=="8")
 			//{
 				//alert("输出表的名称"+$("#"+stuname).val());
 			//}
 			var islocal=$("#islocal").val();//判断本地获取参数，还是远程获取参数
 			var stuortablevalue=$("#"+stuname).val();
 			var checkvalue=$(obj).next().val();
 		 	var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&checkvalue="+checkvalue+"&operation=2&stuortablemark="+stuname+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>"+"&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
 			if(temp)
		 	{
		 		 if (temp.id!="" && temp.id != 0)
		 		 {
					var tempsz=temp.id.split(",");
					$(obj).next().val(tempsz[1]);
					$(obj).next().next().html(tempsz[1]);
					$(obj).next().next().next().html("");
				 }else
				 {
				 	$(obj).next().val("");
				 	$(obj).next().next().html("");
				 	$(obj).next().next().next().html("<img src='/images/BacoError.gif' align=absMiddle>");
				 }
				 if (temp.name!="")
		 		 {
		 		 	<%
					if("0".equals(w_type))
					{
					%>
			 		 	if(type=="8"||type=="6"||type=="4")
			 		 	{
				 		 	var tempsz=temp.name.split(",");
							$(obj).parent().next().next().find("input[type='text']").attr("value",tempsz[1])//赋值给显示名
							if(tempsz[1])//表明里面有值
							{
								$(obj).parent().next().next().find("span").html("");
							}
						}
					<%
					}
					%>
		 		 }
		 	}
 	}
 	
 	//所有批量字段操作
 	//backtable表示：回写表
 	//type=1表示输入参数,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=2表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=3表示输入结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值,chtable(结构体的流水编号)必须有值
 	//type=4表示输出参数，source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=5表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=6表示输出结构,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(结构体的名称所在的文本框的id)必须有值
 	//type=7表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=8表示输出表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(输出表的名称所在的文本框的id)必须有值
 	//type=9表示内容权限设置,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=10表示输入表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮)
 	//type=11表示输入表,source=1(点击批量按钮),source=2(点击添加按钮),source=3(点击删除按钮),stuname(输入表的名称所在的文本框的id)必须有值
 	//type=12表示输出表的where条件管理表
 	function addBathFieldObj(type,source,stuname,chtable,backtable)
 	{
		var islocal=$("#islocal").val();//判断本地获取参数，还是远程获取参数
 		if(type=="1")
 		{
 				if(source=="1")
 				{
 						var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
						if(temp)
						{
	       					 if (temp.id!="" && temp.id != 0) {
								var tempsz=temp.id.split(",");
								for(var ij=0;ij<tempsz.length;ij++)
								{
									if(tempsz[ij])
									{
										var shuzi=parseInt($("#hidden01").val())+1;
										var input01="sap01_"+shuzi;
										var input01Span="sap01_"+shuzi+"Span";
										var input02="oa01_"+shuzi;
										var input02Span="oa01_"+shuzi+"Span";
										var input03="con01_"+shuzi;
										var vTb=$("#chind01");
										var address="add01_"+shuzi;
										var row = $("<tr></tr>"); 
										
										<%
											if("0".equals(w_type))
											{
										%>
											var td = $("<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'> <span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td>");
										 <%
											}else
											{
										%>
											var td = $("<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'> <span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td>");
										<%		
											}
										%>
										row.append(td); 
										vTb.append(row); 
										//得到表格的行数
										//var temp=$("#chind01").get(0).rows.length;
										$("#hidden01").attr("value",shuzi);
									}
								}
							}
						}
 				}else if(source=="2")
 				{
 						var shuzi=parseInt($("#hidden01").val())+1;
						var input01="sap01_"+shuzi;
						var input01Span="sap01_"+shuzi+"Span";
						var input02="oa01_"+shuzi;
						var input02Span="oa01_"+shuzi+"Span";
						var input03="con01_"+shuzi;
						var vTb=$("#chind01");
						var address="add01_"+shuzi;
						var row = $("<tr></tr>");
						<%
							if("0".equals(w_type))
							{
						%> 
							var td = $("<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"' ><span></span> <span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td>");
						 <%
							}else
							{
						%> 
							var td = $("<td><input type='checkbox' name='cbox1'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'> <span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(1,this)></button><input type='hidden' name='"+input01+"' ><span></span> <span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td>");
						<%		
							}
						%>
										
						row.append(td); 
						vTb.append(row); 
						//得到表格的行数
						//var temp=$("#chind01").get(0).rows.length;
						$("#hidden01").attr("value",shuzi);
 				}else if(source=="3")
 				{
						var vTb=$("#chind01");
						var checked = $("#chind01 input[type='checkbox'][name='cbox1'][checked=true]"); 
						if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parent().parent().remove(); 
									//var shuzi=parseInt($("#hidden01").val())-1;
									//得到表格的行数
									//var temp=$("#chind01").get(0).rows.length;
									//$("#hidden01").attr("value",shuzi);
								} 
							}); 
						}
						}else{
							alert("请选择需要删除的项！");
						}
 				}
 					
 		}else if(type=="2")
 		{
 			if(source=="1")
 			{
 					var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
					if(temp)
					{
						if (temp.id!="" && temp.id != 0) 
						{
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
										var chtable=parseInt($("#hidden02").val())+1;
										var shuzi=parseInt(chtable)+1;
										var newname="cbox2"+"_"+chtable;
										var newtable="sap_02"+"_"+chtable;
										var newstru="stru_"+chtable;
										var newstruSpan="stru_"+chtable+"span";
										var bath="bath2_"+chtable;
										var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
											row.append("<td><%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(2,this,'"+newstru+"')></button><input type='hidden' class='selectmax_width' id='"+newstru+"'  name='"+newstru+"' value='"+tempsz[ij]+"' ><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>" 
													+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'><TABLE class=ListStyle cellspacing=1 id='"+newtable+"' >"
													+"  <tr class=Header><td><input type='checkbox' onclick='checkbox2(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"') ><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
													+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='8'></TD></TR>"
													+" </TABLE>");
											row.append("</td></tr>");
											var vTb=$("#sap_02");
											vTb.append(row); 
											//得到表格的行数
											//var temp=$("#chind02").get(0).rows.length;
											$("#hidden02").attr("value",chtable);
								}
							}
						}
					}
 			}else if(source=="2")
 			{
 				// <COLGROUP><COL width='60px'/><COL width='80px'/><COL width='180px'/><COL width='80px'/><COL width='180px'/><COL width='60px'/><COL width='*'/></COLGROUP>
				//style='table-layout: fixed;'
				var chtable=parseInt($("#hidden02").val())+1;
				var shuzi=parseInt(chtable)+1;
				var newname="cbox2"+"_"+chtable;
				var newtable="sap_02"+"_"+chtable;
				var newstru="stru_"+chtable;
				var newstruSpan="stru_"+chtable+"span";
				var bath="bath2_"+chtable;
				var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox2'></td>"); 	
					row.append("<td><%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(2,this,'"+newstru+"')></button><input type='hidden' class='selectmax_width' name='"+newstru+"' id='"+newstru+"'><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError.gif' align=absMiddle></span>" 
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'><TABLE class=ListStyle cellspacing=1 id='"+newtable+"' >"
							+"  <tr class=Header><td><input type='checkbox' onclick='checkbox2(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(3,1,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(3,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(3,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
							+"  <TR class=Line style='height:1px'><td colspan=8></td></TR>"
							+" </TABLE>");
					row.append("</td></tr>");
					var vTb=$("#sap_02");
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind02").get(0).rows.length;
					$("#hidden02").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_02");
					var checked = $("#sap_02 input[type='checkbox'][name='cbox2'][checked=true]"); 
					if(checked.length>0){ 
					if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						}); 
					}
					}else{
							alert("请选择需要删除的项！");
					}
 			}
 		}else if(type=="3")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val()
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的对象
							 		var newtable=$("#sap_02"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
							 		var input01="sap02_"+chtable+"_"+newchtable;
									var input02="oa02_"+chtable+"_"+newchtable;
									var input03="con02_"+chtable+"_"+newchtable;
									var input01Span="sap02_"+chtable+"_"+newchtable+"span";
									var input02Span="oa02_"+chtable+"_"+newchtable+"span";
									var address="add02_"+chtable+"_"+newchtable;
									<%
										if("0".equals(w_type))
										{
									%> 
							 			var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td><td></td></tr>");
							 		 <%
										}else
										{
									%>
										var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'  value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td><td></td></tr>");
									<%
										}
									%> 
							 		newtable.append(row); 
							 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
						 		}
						 	}
					 }
				 }
 			}else if(source=="2")
 			{
 				 		//得到子表的对象
					 		var newtable=$("#sap_02"+"_"+chtable);
					 		var newchtable=parseInt($("#cbox2"+"_"+chtable).val())+1;
					 		var input01="sap02_"+chtable+"_"+newchtable;
							var input02="oa02_"+chtable+"_"+newchtable;
							var input03="con02_"+chtable+"_"+newchtable;
							var input01Span="sap02_"+chtable+"_"+newchtable+"span";
							var input02Span="oa02_"+chtable+"_"+newchtable+"span";
							var address="add02_"+chtable+"_"+newchtable;
							<%
								if("0".equals(w_type))
								{
							%> 
					 			var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+stuname+"') ></button><input type='hidden' name='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(30606 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td><td></td></tr>");
					 		<%
								}else
								{
							%>
								var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input02+"'><span></span><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(3,this,'"+stuname+"') ></button><input type='hidden' name='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"' ></td><td></td></tr>");
							<%
								}
							%> 
					 		newtable.append(row); 
					 		$("#cbox2"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				 		var checked = $("#sap_02"+"_"+chtable+" input[type='checkbox'][name='zibox'][checked=true]"); 
 				 			if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parent().parent().remove(); 
									} 
								}); 
							}
						}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="4")
 		{
 			if(source=="1")
 			{
 				
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var shuzi=parseInt($("#hidden03").val())+1;
									var input01="sap03_"+shuzi;
									var input01Span="sap03_"+shuzi+"span";
									var input02="show03_"+shuzi;//显示名--文本框
									var input02Span="show03_"+shuzi+"span";//显示名--img
									var input03="dis03_"+shuzi;//是否显示
									var input04="setoa3_"+shuzi;
									var address="add03_"+shuzi;
									//var input04Span="setoa_"+shuzi+"span";
									var vTb=$("#chind03");
									var row = $("<tr></tr>"); 
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError.gif' align=absMiddle>";
									}
									<%
										if("0".equals(w_type))
										{
									%> 
										var td = $("<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"'  id='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'><span id='"+input02Span+"'>"+showimg+"</span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input04+"'><span></span><span></span><input type=hidden name='"+address+"'></td>");
									<%
										}else
										{
									%>
										var td = $("<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"'  id='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td colSpan=4><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input04+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td>");
									<%		
										}
									%> 
									 
									row.append(td); 
									vTb.append(row); 
									//得到表格的行数
									//var temp=$("#chind03").get(0).rows.length;
									$("#hidden03").attr("value",shuzi);
								}
							}
						}
				}
 			}else if(source=="2")
 			{
 				
 					var shuzi=parseInt($("#hidden03").val())+1;
					var input01="sap03_"+shuzi;
					var input01Span="sap03_"+shuzi+"span";
					var input02="show03_"+shuzi;//显示名--文本框
					var input02Span="show03_"+shuzi+"span";//显示名--img
					var input03="dis03_"+shuzi;//是否显示
					var input04="setoa3_"+shuzi;
					//var input04Span="setoa_"+shuzi+"span";
					var vTb=$("#chind03");
					var row = $("<tr></tr>"); 
					var address="add03_"+shuzi;
					<%
						if("0".equals(w_type))
						{
					%> 
						var td = $("<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input04+"'/><span></span><span></span><input type=hidden name='"+address+"'></td>");
					<%
						}else
						{
					%>
						var td = $("<td><input type='checkbox' name='cbox3'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(4,this)></button><input type='hidden' name='"+input01+"' id='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td colSpan=4><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input04+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td>");
					<%		
						}
					%> 
					row.append(td); 
					vTb.append(row); 
					//得到表格的行数
					//var temp=$("#chind03").get(0).rows.length;
					$("#hidden03").attr("value",shuzi);
 			}else if(source=="3")
 			{
 					var vTb=$("#chind03");
					var checked = $("#chind03 input[type='checkbox'][name='cbox3'][checked=true]"); 
					if(checked.length>0){ 
					if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						}); 
					}
					}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="5")
 		{
 			if(source=="1")
 			{
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden04").val())+1;
									var newname="cbox4"+"_"+chtable;
									var newtable="sap_04"+"_"+chtable;
									var newstru="outstru_"+chtable;
									var newstruSpan="outstru_"+chtable+"span";
									var bath="bath4_"+chtable;
									var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
											row.append("<td><%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(5,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"' ><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>" 
												+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'><TABLE class=ListStyle cellspacing=1 id='"+newtable+"' > "
												+"  <tr class=Header><td><input type='checkbox' onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
												+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='6'></TD></TR>"
												+" </TABLE>");
										row.append("</td></tr>");
										var vTb=$("#sap_04");
										vTb.append(row); 
										//var shuzi=parseInt(chtable)+1;
										//得到表格的行数
										$("#hidden04").attr("value",chtable);
									}
								}
					}
				}
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden04").val())+1;
					var newname="cbox4"+"_"+chtable;
					var newtable="sap_04"+"_"+chtable;
					var newstru="outstru_"+chtable;
					var newstruSpan="outstru_"+chtable+"span";
					var bath="bath4_"+chtable;
					var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox4'></td>"); 	
						row.append("<td><%=SystemEnv.getHtmlLabelName(30609 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(5,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"'><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError.gif' align=absMiddle></span>" 
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'><TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
							+"  <tr class=Header><td><input type='checkbox' onclick='checkbox4(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='7' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(6,1,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(6,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(6,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
							+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='6'></TD></TR>"
							+" </TABLE>");
						row.append("</td></tr>");
						var vTb=$("#sap_04");
						vTb.append(row); 
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden04").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_04");
					var checked = $("#sap_04 input[type='checkbox'][name='cbox4'][checked=true]"); 
					if(checked.length>0){ 
						if(window.confirm("确定要执行删除操作吗!")){
									$(checked).each(function(){ 
										if($(this).attr("checked")==true) 
										{ 
											$(this).parent().parent().remove(); 
										} 
									});
						} 
					}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="6")
 		{
 			if(source=="1")
 			{
 					//alert("输出结构"+$("#"+stuname).val());
 					var stuortablevalue=$("#"+stuname).val();
	 				var temp=window.showModalDialog("/integration/browse/integrationBatchSAP.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&mark=<%=mark%>&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
					if(temp)
					{
			    	 	if (temp.id!="" && temp.id != 0)
			    	    {
								var tempsz=temp.id.split(",");
								var tempnames=temp.name.split(",");
								for(var ij=0;ij<tempsz.length;ij++)
								{
									if(tempsz[ij])
									{
									
													
										//得到子表的id
								 		var newtable=$("#sap_04"+"_"+chtable);
								 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
								 		var input01="sap04_"+chtable+"_"+newchtable;
								 		var input01Span="sap04_"+chtable+"_"+newchtable+"span";
								 		var input02="show04_"+chtable+"_"+newchtable;//显示名--文本框
								 		var input02Span="show04_"+chtable+"_"+newchtable+"span";//显示名--img
										var input03="dis04_"+chtable+"_"+newchtable;//是否显示
										var input04="sea04_"+chtable+"_"+newchtable;
										var input05="setoa4_"+chtable+"_"+newchtable;
										var address="add04_"+chtable+"_"+newchtable;
										var showimg="";
										if(!tempnames[ij])//空字符串默认等于false
										{
											showimg="<img src='/images/BacoError.gif' align=absMiddle>";
										}
										<%
											if("0".equals(w_type))
											{
										%> 
											var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'><span id='"+input02Span+"'>"+showimg+"</span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input05+"'><span></span><input type=hidden name='"+address+"'></td></tr>");
										<%
											}else
											{
										%>
											var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td colSpan=4><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input05+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td></tr>");
										<%		
											}
										%> 
								 		 
								 		newtable.append(row); 
								 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
								 	}
								 }
						}
					}
 			}else if(source=="2")
 			{	
 			
 			
 					//得到子表的id
			 		var newtable=$("#sap_04"+"_"+chtable);
			 		var newchtable=parseInt($("#cbox4"+"_"+chtable).val())+1;
			 		var input01="sap04_"+chtable+"_"+newchtable;
			 		var input01Span="sap04_"+chtable+"_"+newchtable+"span";
			 		var input02="show04_"+chtable+"_"+newchtable;//显示名--文本框
			 		var input02Span="show04_"+chtable+"_"+newchtable+"span";//显示名--img
					var input03="dis04_"+chtable+"_"+newchtable;//是否显示
					var input04="sea04_"+chtable+"_"+newchtable;
					var input05="setoa4_"+chtable+"_"+newchtable;
					var address="add04_"+chtable+"_"+newchtable;
					
					<%
						if("0".equals(w_type))
						{
					%> 
						var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' ><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')><span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input05+"'><span></span><input type=hidden name='"+address+"'></td></tr>");
					<%
						}else
						{
					%>
						var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(6,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' ><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td colSpan=4><button type='button' class='browser' onclick=addOneFieldObjOA(this)></button><input type='hidden' name='"+input05+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td></tr>");
					<%		
						}
					%> 
									
			 		 
			 		newtable.append(row); 
			 		$("#cbox4"+"_"+chtable).attr("value",newchtable);
 			}else if(source=="3")
 			{
 				var checked = $("#sap_04"+"_"+chtable+" input[type='checkbox'][name='zibox'][checked=true]");
 				if(checked.length>0){ 
				if(window.confirm("确定要执行删除操作吗!")){
					$(checked).each(function(){ 
						if($(this).attr("checked")==true) 
						{ 
							$(this).parent().parent().remove(); 
						} 
					}); 
				}
				}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="7")
 		{
 			
 			if(source=="1")
 			{
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden05").val())+1;
									var newname="cbox5"+"_"+chtable;
									var newtable="sap_05"+"_"+chtable;
									var newstru="outtable_"+chtable;
									var newstruSpan="outtable_"+chtable+"span";
									var bath="bath5_"+chtable;
									var newtable05son="sapson_05_"+chtable;//where条件所在的表格
									var newtable05soncount="sapson_05count_"+chtable;//where条件总行数
									var backtable="backtable5_"+chtable;	//回写表
									var backoper="backoper5_"+chtable;	//回写操作
									
									
									<%
										if("0".equals(w_type))
										{
									%>
										var row ="<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
											 row+="<td>"
											 	+"<TABLE  cellspacing=1>"
											 	+"<tr>"
											 	+"<td>"
											 	+" <%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>"
											 	+"</td>"
											 	+"<td>"
											 	+"" 
												+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
												+"</td>"
												+"</tr>"
												+"</table>"
												+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"' table-layout: fixed;'>"
												+"  <tr class=Header><td><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
												+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
												+" </TABLE>"
												+" </td></tr>";
									<%
										}else
										{
									%>
									
									
										var row ="<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
											row+="<td>"
											+"<TABLE  cellspacing=1>"
											+"<tr>"
											+"<td>"
											+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span id='"+newstruSpan+"'></span>"
											+"</td>"
											+"<td>"
											+"<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='browser' onclick=backtable(this)></button>" 
											+"<input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span><img src='/images/BacoError.gif' align=absMiddle></span><span></span>"
											+"</td>"
											+"<td>"
											+"<%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='"+backoper+"' id='"+backoper+"'><option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option></select>"
											+"</td>"
											+"<td>"
											+""
											+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
											+"</td>"
											+"</tr>"
											+"</TABLE>"
											
											+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
											+"  <tr class=Header><td><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
											+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
											+" </TABLE>"
											+" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'> "
											+" <tr> "
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>"
											+" </td>"
											+" <td colspan=4>"
											+" "
											+" </td>"
											+" </tr>"
											+" <tr class=Header>"
											+" <td>"
											+" <input type=checkbox onclick='checkbox5son(this,"+chtable+")'<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>"
											+" </td>"
											+" <td>"
											+" <%=SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())%>"
											+" </td>"
											+" <td style='text-align:right'>"
											+" <button type='button'  class='btn' onclick=addBathFieldObj(12,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(12,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(12,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button><input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='0'> "
											+" </td>"
											+" </tr>"
											+" </td></tr>";
											
							
									<%		
										}
									%>
										var vTb=$("#sap_05");
										vTb.append(row); 
										//var shuzi=parseInt(chtable)+1;
										//得到表格的行数
										$("#hidden05").attr("value",chtable);
								}
							 }
						}
				}
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden05").val())+1;
					var newname="cbox5"+"_"+chtable;
					var newtable="sap_05"+"_"+chtable;
					var newstru="outtable_"+chtable;
					var newstruSpan="outtable_"+chtable+"span";
					var bath="bath5_"+chtable;
					var newtable05son="sapson_05_"+chtable;//where条件所在的表格
					var newtable05soncount="sapson_05count_"+chtable;//where条件总行数
					
					var backtable="backtable5_"+chtable;	//回写表
					var backoper="backoper5_"+chtable;	//回写操作
					
					//sapinParameter05.append(" <TABLE  cellspacing=1>");
									//sapinParameter05.append(" <tr>");
									//sapinParameter05.append(" <td>");
									
					<%
						if("0".equals(w_type))
						{
					%>
						var row ="<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
							row+="<td>"
							
								+"<TABLE  cellspacing=1>"
								+"<tr>"
								+"<td>"
								+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' ><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError.gif' align=absMiddle></span>"
								+"</td>"
								+"<td>"
								+"" 
								+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
								+"</td>"
								+"</tr>"
								+"</table>"
								
								+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
								+"  <tr class=Header><td ><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
								+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
								+" </TABLE>"
								+" </td></tr>";
					<%
						}else
						{
						
						//sapinParameter05.append(" <TABLE  cellspacing=1>");
									//sapinParameter05.append(" <tr>");
									//sapinParameter05.append(" <td>");
					%>
						var row ="<tr><td class='tdcenter'><input type='checkbox' name='cbox5'></td>"; 	
						row+="<td>"
						
							+"<TABLE  cellspacing=1>"
							+"<tr>"
							+"<td>"
							+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(7,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' ><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError.gif' align=absMiddle></span>"
							+"</td>"
							+"<td>"
							+"<%=SystemEnv.getHtmlLabelName(30612 ,user.getLanguage())%><button type='button' class='browser' onclick=backtable(this)></button>" 
							+"<input type='hidden' name='"+backtable+"' id='"+backtable+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span>"
							+"</td>"
							+"<td>"
							+"<%=SystemEnv.getHtmlLabelName(30613 ,user.getLanguage())%><select name='"+backoper+"'><option value=0><%=SystemEnv.getHtmlLabelName(30614 ,user.getLanguage())%></option><option value=1><%=SystemEnv.getHtmlLabelName(30615 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(103 ,user.getLanguage())%></option><option value=3><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></option></select>"
							+"" 
							+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
							+"</td>"
							+"</tr>"
							+"</table>"
							
							+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
							+"  <tr class=Header><td ><input type='checkbox' onclick='checkbox5(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(8,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(8,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(8,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
							+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
							+" </TABLE>"
							+" <TABLE class=ListStyle cellspacing=1 id='"+newtable05son+"'> "
							+" <tr> "
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30616 ,user.getLanguage())%>"
							+" </td>"
							+" <td colspan=4>"
							+" <input type='hidden' name='"+newtable05soncount+"' id='"+newtable05soncount+"' value='0'> "
							+" </td>"
							+" </tr>"
							+" <tr class=Header>"
							+" <td>"
							+" <input type=checkbox onclick='checkbox5son(this,"+chtable+")'<%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30617 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30618 ,user.getLanguage())%>"
							+" </td>"
							+" <td>"
							+" <%=SystemEnv.getHtmlLabelName(30619 ,user.getLanguage())%>"
							+" </td>"
							+"<td style='text-align:right'> <button type='button'  class='btn' onclick=addBathFieldObj(12,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(12,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(12,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button>"
							+"</td>"
							+" </tr>"
							+" </td></tr>";
					<%		
						}
					%>
						var vTb=$("#sap_05");
						vTb.append(row); 
						//var shuzi=parseInt(chtable)+1;
						//得到表格的行数
						$("#hidden05").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_05");
					var checked = $("#sap_05 input[type='checkbox'][name='cbox5'][checked=true]"); 
						if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						}); 
					}
					}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="8")
 		{
 			if(source=="1")
 			{
 				//alert("输出表里面的输出参数"+($("#"+stuname).val()_);
 				var stuortablevalue=$("#"+stuname).val();
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的id
							 		var newtable=$("#sap_05"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
							 		var input01="sap05_"+chtable+"_"+newchtable;
							 		var input02="show05_"+chtable+"_"+newchtable;
							 		var input01Span="sap05_"+chtable+"_"+newchtable+"span";
							 		var input02Span="show05_"+chtable+"_"+newchtable+"span";
									var input03="dis05_"+chtable+"_"+newchtable;
									var input04="sea05_"+chtable+"_"+newchtable;
									var input05="key05_"+chtable+"_"+newchtable;
									var input06="setoa5_"+chtable+"_"+newchtable;
									var address="add05_"+chtable+"_"+newchtable;
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError.gif' align=absMiddle>";
									}
									
									<%
										if("0".equals(w_type))
										{
									%> 
										var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'/><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"') value='"+tempnames[ij]+"'><span id='"+input02Span+"'>"+showimg+"</span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1><%=SystemEnv.getHtmlLabelName(20778 ,user.getLanguage())%><input type='checkbox' name='"+input04+"' value=1><%=SystemEnv.getHtmlLabelName(28277 ,user.getLanguage())%><input type='checkbox' name='"+input05+"' value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input06+"'><span></span><span></span><input type=hidden name='"+address+"'></td></tr>");
									<%
										}else
										{
									%>
										var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'/><span>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td></tr>");
									<%		
										}
									%> 
										
							 		 
							 		newtable.append(row); 
							 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
							 	}
							 }
					}
				}
 			}else if(source=="2")
 			{
 				//得到子表的id
		 		var newtable=$("#sap_05"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox5"+"_"+chtable).val())+1;
		 		var input01="sap05_"+chtable+"_"+newchtable;
		 		var input02="show05_"+chtable+"_"+newchtable;
		 		var input01Span="sap05_"+chtable+"_"+newchtable+"span";
		 		var input02Span="show05_"+chtable+"_"+newchtable+"span";
				var input03="dis05_"+chtable+"_"+newchtable;
				var input04="sea05_"+chtable+"_"+newchtable;
				var input05="key05_"+chtable+"_"+newchtable;
				var input06="setoa5_"+chtable+"_"+newchtable;
				var address="add05_"+chtable+"_"+newchtable;
				
				<%
					if("0".equals(w_type))
					{
				%> 
					var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28247 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'><span></span> <span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(606 ,user.getLanguage())%></td><td><input type='text' name='"+input02+"' onchange=checkinput('"+input02+"','"+input02Span+"')> <span id='"+input02Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(15603 ,user.getLanguage())%><input type='checkbox' name="+input03+" value=1><%=SystemEnv.getHtmlLabelName(20778 ,user.getLanguage())%><input type='checkbox' name='"+input04+"' value=1><%=SystemEnv.getHtmlLabelName(28277 ,user.getLanguage())%><input type='checkbox' name='"+input05+"' value=1></td><td><%=SystemEnv.getHtmlLabelName(30610 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,0)></button><input type='hidden' name='"+input06+"'><span></span><span></span><input type=hidden name='"+address+"'></td></tr>");
				<%
					}else
					{
				%>
					var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(28266 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'><span></span> <span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(30611 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"'><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td></tr>");
				<%		
					}
				%> 
									
		 		 
		 		newtable.append(row); 
		 		$("#cbox5"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_05"+"_"+chtable+" input[type='checkbox'][name='zibox'][checked=true]");
 				 			if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
							$(checked).each(function(){ 
								if($(this).attr("checked")==true) 
								{ 
									$(this).parent().parent().remove(); 
								} 
							}); 
						}
						}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="9")
 		{
 			if(source=="1")
 			{
 					for(var i=0;i<2;i++)
 					{
 						var newtable=$("#sap_06_son");
		 				var newchtable=parseInt($("#hidden06").val())+1;
		 				var autotype="autotype_"+newchtable;
						var autospan="autospan_"+newchtable;
						var autotext="autotext_"+newchtable;
						var autouserorwf="autouserorwf_"+newchtable;
						var autodeti="autodeti_"+newchtable;
						var autowfid="autowfid_"+newchtable;
						var autowfidspan="autowfidspan_"+newchtable;
						var row="<tr>";
						row+="<td><input type='checkbox' name='autho'></td>"
						+" <td>"
						+" <select name='"+autotype+"' id='"+autotype+"' onchange=changerole('"+autospan+"','"+autouserorwf+"')><option value=1><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option></select>"
						+" <button type='button' class='browser' onclick=changebrotype(1,'"+autotype+"','"+autospan+"','"+autouserorwf+"')></button>"
						+"	<span id='"+autospan+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>"
						+"	<input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"'>"
						+" </td>"
						//+" <td>"
						//+" 工作流程<button type='button' class='browser' onclick=changebrotype(3,'"+autowfid+"','"+autowfidspan+"')></button>"
						//+" <input type='hidden' id='"+autowfid+"' name='"+autowfid+"'>"
						//+"<span id='"+autowfidspan+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>"
						//+" </td>"
						+" <td>"
						+" <button class=btn type=button    onclick=changebrotype(2,'"+autodeti+"','')>详细设置</button>"
						+" <input type='hidden' id='"+autodeti+"' name='"+autodeti+"'>"
						+" </td>"
						+" </tr>";	
						newtable.append($(row)); 
				 		$("#hidden06").attr("value",newchtable);
 					}
 			}else if(source=="2")
 			{
 				var newtable=$("#sap_06_son");
 				var newchtable=parseInt($("#hidden06").val())+1;
 				var autotype="autotype_"+newchtable;
				var autospan="autospan_"+newchtable;
				var autotext="autotext_"+newchtable;
				var autouserorwf="autouserorwf_"+newchtable;
				var autodeti="autodeti_"+newchtable;
				var autowfid="autowfid_"+newchtable;
				var autowfidspan="autowfidspan_"+newchtable;
				var row="<tr>";
				row+="<td><input type='checkbox' name='autho'></td>"
				+" <td>"
				+" <select name='"+autotype+"' id='"+autotype+"' onchange=changerole('"+autospan+"','"+autouserorwf+"')><option value=1><%=SystemEnv.getHtmlLabelName(179 ,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(122 ,user.getLanguage())%></option></select>"
				+" <button type='button' class='browser' onclick=changebrotype(1,'"+autotype+"','"+autospan+"','"+autouserorwf+"')></button>"
				+"	<span id='"+autospan+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>"
				+"	<input type='hidden' id='"+autouserorwf+"' name='"+autouserorwf+"'>"
				+" </td>"
				//+" <td>"
				//+" 工作流程<button type='button' class='browser' onclick=changebrotype(3,'"+autowfid+"','"+autowfidspan+"')></button>"
				//+" <input type='hidden' id='"+autowfid+"' name='"+autowfid+"'>"
				//+"	<span id='"+autowfidspan+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>"
				//+" </td>"
				+" <td>"
				+" <button class=btn type=button    onclick=changebrotype(2,'"+autodeti+"','')>详细设置</button>"
				+" <input type='hidden' id='"+autodeti+"' name='"+autodeti+"'>"
				+" </td>"
				
				+" </tr>";	
				newtable.append($(row)); 
		 		$("#hidden06").attr("value",newchtable);
				
 			}else if(source=="3")
 			{
 				var checked = $("#sap_06_son input[type='checkbox'][name='autho'][checked=true]");
 					if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						});
					}
				}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="10")
 		{
 			if(source=="1")//输入表
 			{
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									var chtable=parseInt($("#hidden07").val())+1;
									var newname="cbox7"+"_"+chtable;
									var newtable="sap_07"+"_"+chtable;
									var newstru="outtable7_"+chtable;
									var backtable="backtable7_"+chtable;	//写入表
									var newstruSpan="outtable7_"+chtable+"span";
									var bath="bath7_"+chtable;
									var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
										row.append("<td>" 
												+"<table cellspacing=1>"
												+"<tr>"
												+"<td>"
												+"<%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"' value='"+tempsz[ij]+"' ><span>"+tempsz[ij]+"</span> <span id='"+newstruSpan+"'></span>"
												+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
												+"</td>"
												+"<td>"
												+"写入表<button type='button' class='browser' onclick=backtable(this)></button>"
												+"<input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span>"
												+"</td>"
												+"</tr>"
												+"</table>"
												+"  <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
												+"  <tr class=Header><td><input type='checkbox' onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' tyle='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
												+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
												+" </TABLE>");
										row.append("</td></tr>");
										var vTb=$("#sap_07");
										vTb.append(row); 
										//得到表格的行数
										$("#hidden07").attr("value",chtable);
								}
							 }
						}
				}
			
 			}else if(source=="2")
 			{
 					var chtable=parseInt($("#hidden07").val())+1;
					var newname="cbox7"+"_"+chtable;
					var newtable="sap_07"+"_"+chtable;
					var newstru="outtable7_"+chtable;
					var backtable="backtable7_"+chtable;	//写入表
					var newstruSpan="outtable7_"+chtable+"span";
					var bath="bath7_"+chtable;
					var row = $("<tr><td class='tdcenter'><input type='checkbox' name='cbox7'></td>"); 	
						row.append("<td>" 
								+"<table  cellspacing=1>"
								+"<tr>"
								+"<td>"
								+" <%=SystemEnv.getHtmlLabelName(21900 ,user.getLanguage())%><button type='button' class='browser' onclick=addOneFieldObj(10,this)></button><input type='hidden' class='selectmax_width' id='"+newstru+"' name='"+newstru+"'><span></span><span id='"+newstruSpan+"'><img src='/images/BacoError.gif' align=absMiddle></span>"
								+" <input type='hidden' id='"+newname+"' name='"+newname+"' value='0'>"
								+"</td>"
								+"<td>"
								+" 写入表<button type='button' class='browser' onclick=backtable(this)></button>"
								+" <input type='hidden' name='"+backtable+"' id='"+backtable+"' ><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span>"
								+"</td>"
								+"</tr>"
								+"</table>"
								
								+" <TABLE class=ListStyle cellspacing=1 id='"+newtable+"'>"
								+"  <tr class=Header><td><input type='checkbox' onclick='checkbox7(this,"+chtable+")'/><%=SystemEnv.getHtmlLabelName(556 ,user.getLanguage())%></td><td colspan='8' style='text-align:right'><button type='button'  class='btn' id='"+bath+"' onclick=addBathFieldObj(11,1,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(25055 ,user.getLanguage())%></button> <button type='button' class='btn' onclick=addBathFieldObj(11,2,'"+newstru+"','"+chtable+"','"+backtable+"')><%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%></button><button type='button' class='btn' onclick=addBathFieldObj(11,3,'"+newstru+"','"+chtable+"')><%=SystemEnv.getHtmlLabelName(23777 ,user.getLanguage())%></button></td></tr>"
								+"  <TR class=Line style='height:1px'><TD  style='padding:0px' colspan='9'></TD></TR>"
								+" </TABLE>");
						row.append("</td></tr>");
						var vTb=$("#sap_07");
						vTb.append(row); 
						//得到表格的行数
						$("#hidden07").attr("value",chtable);
 			}else if(source=="3")
 			{
 					var vTb=$("#sap_07");
					var checked = $("#sap_07 input[type='checkbox'][name='cbox7'][checked=true]"); 
						if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						}); 
					}
					}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="11")
 		{
 			if(source=="1")
 			{
 				
 				var stuortablevalue=$("#"+stuname).val();
 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
				if(temp)
				{
		    	 	if (temp.id!="" && temp.id != 0)
		    	    {
							var tempsz=temp.id.split(",");
							var tempnames=temp.name.split(",");
							for(var ij=0;ij<tempsz.length;ij++)
							{
								if(tempsz[ij])
								{
									//得到子表的id
							 		var newtable=$("#sap_07"+"_"+chtable);
							 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
							 		var input01="sap07_"+chtable+"_"+newchtable;
							 		var input02="show07_"+chtable+"_"+newchtable;
							 		var input01Span="sap07_"+chtable+"_"+newchtable+"span";
							 		var input02Span="show07_"+chtable+"_"+newchtable+"span";
									var input03="con07_"+chtable+"_"+newchtable;
									var input03Span="con07_"+chtable+"_"+newchtable+"span";
									var input06="setoa7_"+chtable+"_"+newchtable;
									var input06Span="setoa7_"+chtable+"_"+newchtable+"span";
									var address="add07_"+chtable+"_"+newchtable;
									var showimg="";
									if(!tempnames[ij])//空字符串默认等于false
									{
										showimg="<img src='/images/BacoError.gif' align=absMiddle>";
									}
							 		var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"'><span></span><span id='"+input06Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(11,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"' onchange=checkinput('"+input01+"','"+input01Span+"')><span id='"+input01Span+"'>"+tempsz[ij]+"</span><span id='"+input01Span+"'></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"'  ></td></tr>"); 
							 		newtable.append(row); 
							 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
							 	}
							 }
					}
				}
 			}else if(source=="2")
 			{
 				//得到子表的id
		 		var newtable=$("#sap_07"+"_"+chtable);
		 		var newchtable=parseInt($("#cbox7"+"_"+chtable).val())+1;
		 		var input01="sap07_"+chtable+"_"+newchtable;
		 		var input02="show07_"+chtable+"_"+newchtable;
		 		var input01Span="sap07_"+chtable+"_"+newchtable+"span";
		 		var input02Span="show07_"+chtable+"_"+newchtable+"span";
				var input03="con07_"+chtable+"_"+newchtable;
				var input03Span="con07_"+chtable+"_"+newchtable+"span";
				var input06="setoa7_"+chtable+"_"+newchtable;
				var input06Span="setoa7_"+chtable+"_"+newchtable+"span";
				var address="add07_"+chtable+"_"+newchtable;
		 		var row = $("<tr><td><input type='checkbox' name='zibox'></td><td><%=SystemEnv.getHtmlLabelName(30607 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input06+"'><span></span><span id='"+input06Span+"'><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+address+"'></td><td><%=SystemEnv.getHtmlLabelName(30608 ,user.getLanguage())%></td><td><button type='button' class='browser' onclick=addOneFieldObj(11,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'><span></span><span id='"+input01Span+"'><img src='/images/BacoError.gif' align=absMiddle></span></td><td><%=SystemEnv.getHtmlLabelName(28249 ,user.getLanguage())%></td><td><input type='text' name='"+input03+"'  ></td></tr>"); 
		 		newtable.append(row); 
		 		$("#cbox7"+"_"+chtable).attr("value",newchtable);
 			}
 			else if(source=="3")
 			{
 				 		var checked = $("#sap_07"+"_"+chtable+" input[type='checkbox'][name='zibox'][checked=true]");
 				 		if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
								$(checked).each(function(){ 
									if($(this).attr("checked")==true) 
									{ 
										$(this).parent().parent().remove(); 
									} 
								}); 
							}
						}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}else if(type=="12")
 		{
 			if(source=="1")
 			{
 					var stuortablevalue=$("#"+stuname).val();
	 				var temp=window.showModalDialog("/integration/browse/integrationBatchSap.jsp?type="+type+"&stuortablevalue="+stuortablevalue+"&regservice=<%=regservice%>&islocal="+islocal,"","dialogWidth:600px;dialogHeight:600px;center:yes;scroll:yes;status:no");
					if(temp)
					{
			    	 	if (temp.id!="" && temp.id != 0)
			    	    {
								var tempsz=temp.id.split(",");
								var tempnames=temp.name.split(",");
								for(var ij=0;ij<tempsz.length;ij++)
								{
									if(tempsz[ij])
									{
											var newtable=$("#sapson_05_"+chtable);
							 				var newchtable=parseInt($("#sapson_05count_"+chtable).val())+1;
							 				var input01="sap05son_"+chtable+"_"+newchtable;
											var input02="set05son_"+chtable+"_"+newchtable;
											var input03="add05son_"+chtable+"_"+newchtable;
											var input04="con05son_"+chtable+"_"+newchtable;
							 				var row="<tr><td><input type='checkbox' name='zibox'></td>";
											row+="<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"' value='"+tempsz[ij]+"'><span>"+tempsz[ij]+"</span><span></span></td>"
												+"<td> <button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input02+"'/><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+input03+"'></td>"
												+"<td colspan=2><input type='text' name='"+input04+"'></td>"
												+"</tr>";
									 		newtable.append(row); 
									 		$("#sapson_05count_"+chtable).attr("value",newchtable);
									
									}
								}
						}
					}
					
 				
 			}else if(source=="2")
 			{
 				var newtable=$("#sapson_05_"+chtable);
 				var newchtable=parseInt($("#sapson_05count_"+chtable).val())+1;
 				var input01="sap05son_"+chtable+"_"+newchtable;
				var input02="set05son_"+chtable+"_"+newchtable;
				var input03="add05son_"+chtable+"_"+newchtable;
				var input04="con05son_"+chtable+"_"+newchtable;
 				var row="<tr><td><input type='checkbox' name='zibox'></td>";
				row+="<td><button type='button' class='browser' onclick=addOneFieldObj(8,this,'"+stuname+"')></button><input type='hidden' name='"+input01+"'><span></span><span ><img src='/images/BacoError.gif' align=absMiddle></span></td>"
					+"<td> <button type='button' class='browser' onclick=addOneFieldObjOA(this,'','"+backtable+"')></button><input type='hidden' name='"+input02+"'/><span></span><span><img src='/images/BacoError.gif' align=absMiddle></span><input type=hidden name='"+input03+"'></td>"
					+"<td colspan=2><input type='text' name='"+input04+"'></td>"
					+"</tr>";
		 		newtable.append(row); 
		 		$("#sapson_05count_"+chtable).attr("value",newchtable);
								
 			}else if(source=="3")
 			{
					var checked = $("#sapson_05"+"_"+chtable+" input[type='checkbox'][name='zibox'][checked=true]");
						if(checked.length>0){ 
							if(window.confirm("确定要执行删除操作吗!")){
						$(checked).each(function(){ 
							if($(this).attr("checked")==true) 
							{ 
								$(this).parent().parent().remove(); 
							} 
						}); 
					}
					}else{
							alert("请选择需要删除的项！");
						}
 			}
 		}
 	}

 	function checkRequired()
 	{
 		var temp=0;
		$(" span img").each(function (){
			if($(this).attr("align")=='absMiddle')
			{
				if($(this).css("display")=='inline')
				{
					temp++;
				}
			}
		});
		if(temp!=0)
		{
			
			alert("<%=SystemEnv.getHtmlLabelName(30622 ,user.getLanguage())%>"+"!");
			return false;
		}else
		{
			return true;
		}
 	}

 	function changebrotype(type,objone,objtwo,objthree)
 	{
 		if(type=="1")
 		{
			var selevalue=$("#"+objone).val();
			
			if(selevalue=="1")
			{
			    var  tmpids = $("#"+objthree).val();
			    var url="";
			    if(tmpids==""){ 
			    	 url="/hrm/resource/MutiResourceBrowser.jsp";
			    }else{
					url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
			    }
			    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
			   if(id){
					    var jsid="";
						try {
					        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
					    } catch(e) {
					        return;
					    }
					    if (jsid != null) {
					        if (jsid[0] != "" && jsid[1]!="") {
					            $GetEle(objtwo).innerHTML = jsid[1].substring(1);
					            $GetEle(objthree).value = jsid[0].substring(1);
					        } else {
					            $GetEle(objtwo).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
					            $GetEle(objthree).value = "";
					        }
					    }
			    }
			}else if(selevalue=="2")
			{
				var  tmpids = $("#"+objthree).val();
			    if(tmpids!="-1"){ 
			      url=escape("/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids);
			    }else{
			      url=escape("/hrm/roles/MutiRolesBrowser.jsp");
			    }
			    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
			    if(id){
				    try {
				        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
				        
				    } catch(e) {
				        return;
				    }
				    if (jsid != null) {
				        if (jsid[0] != "0" && jsid[1]!="") {
				            $GetEle(objtwo).innerHTML = jsid[1].substring(1);
				            $GetEle(objthree).value = jsid[0].substring(1);
				        } else {
				            $GetEle(objtwo).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				            $GetEle(objthree).value = "";
				        }
				    }
				  }
			}
		
 		}else if(type=="2")
 		{
 			var rightid=$("#"+objone).val();
 			if(rightid=="")
 			{
 				alert("<%=SystemEnv.getHtmlLabelName(30623 ,user.getLanguage())%>"+"!");
 			}else
 			{
	 			var mark=$("#mark").val();
	 			var  temp = window.showModalDialog("/integration/browse/integrationSAPDataAuthSetting.jsp?mark="+mark+"&rightid="+rightid, "", "dialogWidth:550px;dialogHeight:550px;");
 			}
 		}
 		else if(type=="3")
 		{
 			var wfids=$("#"+objone).val();
 			var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+wfids);
 			if (id){
		        if (id.id!="" && id.id != 0) {
		        	var wfcheckids=id.id;
		        	var wfchecknames=id.name;
		        	wfcheckids =wfcheckids.substr(1);
		            $G(objone).value= wfcheckids;
		            wfchecknames =wfchecknames.substr(1);
		            
		              var sHtml="";
		              wfcheckids=wfcheckids.split(",");
			          wfchecknames=wfchecknames.split(",");
			          for(var i=0;i<wfcheckids.length;i++){
			              sHtml = sHtml+wfchecknames[i]+"&nbsp;";
			          }
			          $G(objtwo).innerHTML = sHtml;
		        }else
		        {
		        	 $G(objtwo).innerHTML ="<IMG src='/images/BacoError.gif' align=absMiddle>";
	          		 $G(objone).value="";
		        }
	       }
 		}
 	}
 	function changerole(autospan,autodeti)
 	{
 		$("#"+autospan).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
 		$("#"+autodeti).attr("value","");
 	}
 	function backtable(obj)
 	{
 		
 		var temp = window.showModalDialog("/integration/browse/integrationBackTable.jsp?workflowid=<%=workflowid%>&formid=<%=formid%>&isbill=<%=isbill%>");
 		if(temp)
 		{
 		 if (temp.id!="" && temp.id != 0)
 		 {
			var tempsz=temp.id.split(",");
			$(obj).next().val(tempsz[1]);
			$(obj).next().next().html(tempsz[1]);
			$(obj).next().next().next().html("");
		 }else
		 {
		 	$(obj).next().val("");
		 	$(obj).next().next().html("");
		 	$(obj).next().next().next().html("<img src='/images/BacoError.gif' align=absMiddle>");
		 }
		}
 	}
	</script>
</html>



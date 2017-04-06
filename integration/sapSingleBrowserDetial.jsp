<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="com.weaver.integration.entity.NewSapBrowserComInfo"%>
<%@page import="com.weaver.integration.entity.NewSapBrowser"%>
<%@page import="com.weaver.integration.entity.NewSapBaseBrowser"%>
<%@page import="com.weaver.integration.entity.Sap_outParameterBean"%>
<%@page import="com.weaver.integration.entity.Sap_outTableBean"%>
<%@page import="com.weaver.integration.entity.Sap_inParameterBean"%>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.params.BrowserReturnParamsBean"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.entity.Sap_inStructureBean"%>
<%@page import="com.weaver.integration.entity.Sap_outStructureBean"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.util.List" %>
<%@ page import="weaver.parseBrowser.*" %>
<%@ page import="weaver.interfaces.sap.SAPConn" %>
<%@ page import="com.sap.mw.jco.JCO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs01" class="weaver.conn.RecordSet" scope="page" />
<script language="javascript" src="/js/weaver.js"></script>
<link href="/integration/css/intepublic.css" type=text/css rel=stylesheet>
<link href="/integration/css/loading.css" type=text/css rel=stylesheet>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<html>
	<body>
	
			<% 
				//如果是新建流程，只能从页面取数据
				String imagefilename = "/images/hdSystem.gif";
				String titlename = "SAP"+SystemEnv.getHtmlLabelName(30688 ,user.getLanguage());
				String needfav ="1";
				String needhelp ="";
				String type=Util.null2String(request.getParameter("type"));//集成流程按钮标识 
				String operate=Util.null2String(request.getParameter("operate"));
				if("".equals(operate)){operate="select";}
				String fromfieldid=Util.null2String(request.getParameter("fromfieldid"));//字段id
				String detailrow=Util.null2String(request.getParameter("detailrow"));//行号
				NewSapBrowserComInfo NewSapBrowserComInfo=new NewSapBrowserComInfo();
				NewSapBaseBrowser nb=NewSapBrowserComInfo.getSapBaseBrowser(type);//获取浏览按钮的缓存信息
				IntegratedSapUtil integratedSapUtil=new IntegratedSapUtil();
				int rows=50;//每页显示多少行
				int rownum=1;//行号
				int countdata=1;//得到总数据
				int curpage=Util.getIntValue(request.getParameter("curpage"),1);//当前页
				List outParameter=nb.getSap_outParameter();//获取输出参数
				List outTable=nb.getSap_outTable();//获取输出表
				List outStructure=nb.getSap_outStructure();//获取输出结构
				List inParameter=nb.getSap_inParameter();//获取输入参数
				List inStructure=nb.getSap_inStructure();//获取输入结构
				
				 String hpid = nb.getHpid();//异构系统的id
				 String poolid=nb.getPoolid();//连接池的id
				 String regservice=nb.getRegservice();//服务id
				 int loadDate=0;
				 if(rs.execute("select loadDate from sap_service where id='"+regservice+"'")&&rs.next()){
				 	loadDate=Util.getIntValue(Util.null2String(rs.getString("loadDate")),0);
				 }
				
				boolean isOnlyOutTable=true;//判断是否只有输出表，如果只有输出表，回写“主键”的值到表单，如果没有输出表，就不回写“主键”的值到表单，因为目前输出参数和输出结构没有主键的概念
				
				StringBuffer intablefield=new StringBuffer(); //记录输入参数的字段
				StringBuffer intstrufield=new StringBuffer(); //记录输入结构的字段
				StringBuffer outtablesb=new StringBuffer(); //记录输出表的搜索字段
				StringBuffer outtablestr=new StringBuffer();//记录输出表的显示字段
				StringBuffer outtablelist=new StringBuffer();//记录输出表的数据list
				List listoafield=new ArrayList();//封装赋值字段
				List listsapfield=new ArrayList();//封装输出表的sap显示列字段名
				List listsapfielddisplay=new ArrayList();//封装输出表的sap隐藏列字段名
				List listparamy=new ArrayList();//封装主键字段
				List seachfield=new ArrayList();//封装查询字段
				Map TableList=new HashMap();
				SAPInterationOutUtil saputil=new SAPInterationOutUtil();
				HashMap hashmap=new HashMap();
				
				//记录从流程页面带过来的参数
				String oncelistinput="";
				//处理页面输入参数
				for(int i=0;i<inParameter.size();i++)
				{
					Sap_inParameterBean sap_inParameterBean=(Sap_inParameterBean)inParameter.get(i);
					String Constant=sap_inParameterBean.getConstant();//输入参数的固定值
					String Oafield=sap_inParameterBean.getOafield();//输入参数来源于OA字段的值
					String sapfield=sap_inParameterBean.getSapfield();//输入参数的sap字段
					String oafieldid=sap_inParameterBean.getFromfieldid();//OA字段的id
					String ismainfieldmy=sap_inParameterBean.getIsmainfield();//是否主表字段
					String inpar="";
					if("1".equals(ismainfieldmy))//主表
					{
						 inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toUpperCase();
					}else//明细表字段
					{
						 inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toUpperCase();
					}
					if("".equals(Constant))//表示没有固定值
					{
							Constant=inpar;//赋予页面的默认值
						
							if("1".equals(ismainfieldmy))//主表
							{
									//记录流程页面输入的参数
								  oncelistinput+=("<input type='hidden' name='field"+oafieldid+"' value='"+Constant+"'>");
							}else{
									//记录流程页面输入的参数
								  oncelistinput+=("<input type='hidden' name='field"+oafieldid+"_"+detailrow+"' value='"+Constant+"'>");
							}
					}
					//System.out.println("---输入参数日志(基本参数)----");
					//System.out.println("--------------sap取值字段----"+sapfield);
					//System.out.println("--------------对应的oa字段----"+Oafield);
					//System.out.println("--------------是否主表字段----"+ismainfieldmy);
					//System.out.println("--------------固定值----"+Constant);
					hashmap.put(sapfield,Constant);
					//System.out.println("---处理后的输入参数日志----");
					//System.out.println("--------------输入参数----"+sapfield);
					//System.out.println("--------------固定值----"+Constant);
					//System.out.println("                   ");
				}
				//处理页面输入结构
				for(int i=0;i<inStructure.size();i++)
				{
					Sap_inStructureBean sap_instructureBean=(Sap_inStructureBean)inStructure.get(i);
					String Constant=sap_instructureBean.getConstant();//输入参数的固定值
					String Oafield=sap_instructureBean.getOafield();//输入参数来源于OA字段的值
					String sapfield=sap_instructureBean.getSapfield();//输入参数的sap字段
					String oafieldid=sap_instructureBean.getFromfieldid();//OA字段的id
					String ismainfieldmy=sap_instructureBean.getIsmainfield();//是否主表字段
					String stuname=sap_instructureBean.getName();//结构体的名字
					String inpar="";
					if("1".equals(ismainfieldmy))//主表
					{
						 inpar=Util.null2String(request.getParameter("field"+oafieldid)).trim().toUpperCase();
					}else//明细表字段
					{
						 inpar=Util.null2String(request.getParameter("field"+oafieldid+"_"+detailrow)).trim().toUpperCase();
					}
					if("".equals(Constant))//表示没有固定值
					{
							Constant=inpar;//赋予页面的默认值
							if("1".equals(ismainfieldmy))//主表
							{
								   //记录流程页面输入的参数
								  oncelistinput+=("<input type='hidden' name='field"+oafieldid+"' value='"+Constant+"'>");
							}else{
								   //记录流程页面输入的参数
								  oncelistinput+=("<input type='hidden' name='field"+oafieldid+"_"+detailrow+"' value='"+Constant+"'>");
							}
					}
					//System.out.println("---输入参数日志(结构体)----");
					//System.out.println("--------------sap取值字段----"+sapfield);
					//System.out.println("--------------对应的oa字段----"+Oafield);
					//System.out.println("--------------是否主表字段----"+ismainfieldmy);
					//System.out.println("--------------固定值----"+Constant);
					hashmap.put(stuname+"."+sapfield,Constant);
					//System.out.println("---处理后的输入参数日志----");
					//System.out.println("--------------输入参数----"+stuname+"."+sapfield);
					//System.out.println("--------------固定值----"+Constant);
					//System.out.println("                   ");
				}
				int display=0;//得到显示列的总数
				if(outTable.size()>0)//说明有输出表,返回多行值
				{
							//输出表--start
							int tempj=0;
							for(int i=0;i<outTable.size();i++)//循环参数
							{
								Sap_outTableBean s=(Sap_outTableBean)outTable.get(i);
								//判断是否有查询字段
								if((s.getSearch()).equals("1"))
								{
									if(tempj%2==0&&tempj!=0)
									{
										outtablesb.append("<TR class='Spacing'  style='height:1px;'><TD class='Line1' colspan=4></TD></TR>");
										outtablesb.append("<TR class='Spacing'  style='height:1px;'>");
									}
									outtablesb.append("<td>"+s.getShowname()+"</td>");

									outtablesb.append("<td class=field><input type='text' name='"+s.getName()+"."+s.getSapfield()+"' value='"+Util.null2String(request.getParameter(s.getName()+"."+s.getSapfield())).toUpperCase()+"'></td>");
									if(tempj%2==1)
									{
										outtablesb.append("</TR>");
									}
									tempj++;
									seachfield.add(s.getName()+"."+s.getSapfield());
									hashmap.put(s.getSapfield(),Util.null2String(request.getParameter(s.getSapfield())).toUpperCase());
								}
								if(display==0)
								{
									outtablestr.append("<th style='display:none'>"+SystemEnv.getHtmlLabelName(30689 ,user.getLanguage()));
									outtablestr.append("</th>");
									outtablestr.append("<th>");
										outtablestr.append(SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()));
									outtablestr.append("</th>");
								}
								//判断是否有显示字段
								if((s.getDisplay()).equals("1"))//显示列
								{
									outtablestr.append("<th>");
										outtablestr.append(s.getShowname());
									outtablestr.append("</th>");
									display++;
									listsapfield.add(s.getName()+"."+s.getSapfield());//表明.字段名
								}else//隐藏列
								{
									outtablestr.append("<th style='display:none'>");
										outtablestr.append(s.getShowname());
									outtablestr.append("</th>");
									display++;
									listsapfielddisplay.add(s.getName()+"."+s.getSapfield());//表明.字段名
								}
								//判断是否有赋值字段
								if(!"".equals(s.getFromfieldid()))
								{
									listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getName()+"."+s.getSapfield());
								}
								//判断是否为主键
								if("1".equals(s.getPrimarykey()))
								{
									listparamy.add(s.getName()+"."+s.getSapfield());//表明.字段名
								}
							}
							if(tempj%2!=0)
							{
								outtablesb.append("</TR>");
								outtablesb.append("<TR class='Spacing'  style='height:1px;'><TD class='Line1' colspan=4></TD></TR>");
							}
							if(!"".equals(outtablesb.toString().trim()))
							{	
								
								outtablesb=new StringBuffer("<table width=100% class='viewform' id='seachtable'><colgroup><col width='25%'><col width='25%'><col width='25%'><col width='25%'></colgroup>"+outtablesb);
								outtablesb.append("</table>");
							}
							//输出表--end	
							//System.out.println("------调用sap函数的基本参数信息----");
							//System.out.println("------输入参数的个数----"+hashmap.size());
							//System.out.println("------浏览按钮的标识----"+type);
							//System.out.println("---------------------------------");
							BrowserReturnParamsBean returnpar=new BrowserReturnParamsBean ();
							if("search".equals(operate)||loadDate==1)
							{
								  //System.out.println("执行搜索来得");
								 returnpar=saputil.executeABAPFunction(hashmap,type,new LogInfo());
							}
							
							if(null!=returnpar)
							{
								TableList=returnpar.getTableMap();
								if(null!=TableList)
								{
									Iterator iteratorm=TableList.entrySet().iterator();
									while(iteratorm.hasNext())
									{
										Map.Entry entry = (Map.Entry)iteratorm.next();
										Object key=entry.getKey();
										List valuelist = (List)entry.getValue();
										//System.out.println("输出表的表名为:-------------"+key);
										if(null!=valuelist)
										{
											for(int ji=0;ji<valuelist.size();ji++)
											{
													boolean flag=false;
													Map hashmap02=(HashMap)valuelist.get(ji);//表示一行数据
													//过滤数据
													for(int jk=0;jk<seachfield.size();jk++)
													{
														
														//解决大小写过滤问题
														String seaflied=Util.null2String(request.getParameter(seachfield.get(jk)+"")).trim().toUpperCase();
														//System.out.println("过滤条件"+seaflied);
													//	System.out.println("数据"+hashmap02.get(seachfield.get(jk)+""));
														if((hashmap02.get(seachfield.get(jk)+"")+"").indexOf(seaflied)==-1)//条件过滤数据
														{
															
															flag=true;//表示这条数据不符合条件
															break;
														}
														
													}
													if(flag)
													{
														rownum++;
														continue;
													}
													if(listsapfield.size()>0)//说明有可显示的字段或有隐藏的字段
													{
														if("search".equals(operate))//如果来源于搜索
														{
																	String prarmlie="";
																	//循环主键列
																	for(int bj=0;bj<listparamy.size();bj++)//主键列可能有很多，复合主键
																	{
																		prarmlie+=hashmap02.get(listparamy.get(bj))+"$_$";
																	}
																	//验证权限--start
																	if(integratedSapUtil.checkUserOperate(type,prarmlie,user))
																	{
																	
																		if(countdata<=(rows*curpage)&&countdata>rows*(curpage-1))
																		{
																					if(countdata%2==0)
																					{
																						outtablelist.append("<tr class='DataDark'>");
																					}else
																					{
																						outtablelist.append("<tr class='DataLight'>");
																					}
																					outtablelist.append("<td style='display:none'>"+prarmlie.replaceAll("\\$_\\$"," "));
																					outtablelist.append("</td>");
																					outtablelist.append("<td>"+countdata);
																					outtablelist.append("</td>");
															         				for(int jk=0;jk<listsapfield.size();jk++)//输出显示列
															         				{
															         						Object result=hashmap02.get(listsapfield.get(jk));
															         						if(null==result)
															         						{
															         							result="";
															         						}
															         						outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value='"+result+"'></td>");
															         				}
															         				for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
															         				{
															         						Object result=hashmap02.get(listsapfielddisplay.get(jk));
															         						if(null==result)
															         						{
															         							result="";
															         						}
															         						outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value='"+result+"'></td>");
															         				}
															         				outtablelist.append("</tr>");
												         					}
											         				countdata++;
																	rownum++;
																	continue;
																}
																//验证权限--end
														}else//不来源于搜索
														{	
																	String prarmlie="";
																	//循环主键列
																	for(int bj=0;bj<listparamy.size();bj++)//主键列可能有很多，复合主键
																	{
																		prarmlie+=hashmap02.get(listparamy.get(bj))+"$_$";
																	}
																	
																	
																	//验证权限--start
																	if(integratedSapUtil.checkUserOperate(type,prarmlie,user))
																	{
																	
																		if(rownum<=(rows*curpage)&&rownum>rows*(curpage-1))
																		{
																				if(rownum%2==0)
																				{
																					outtablelist.append("<tr class='DataDark'>");
																				}else
																				{
																					outtablelist.append("<tr class='DataLight'>");
																				}
																				outtablelist.append("<td style='display:none'>"+prarmlie.replaceAll("\\$_\\$"," "));
																				outtablelist.append("</td>");
																				outtablelist.append("<td>"+rownum);
																				outtablelist.append("</td>");
																				for(int jk=0;jk<listsapfield.size();jk++)//输出显示列
														         				{
														         						Object result=hashmap02.get(listsapfield.get(jk));
														         						if(null==result)
														         						{
														         							result="";
														         						}
														         						outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value='"+result+"'></td>");
														         				}
														         				for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
														         				{
														         						Object result=hashmap02.get(listsapfielddisplay.get(jk));
														         						if(null==result)
														         						{
														         							result="";
														         						}
														         						outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value='"+result+"'></td>");
														         				}
														         				outtablelist.append("</tr>");
																		}
																	
																	countdata++;
																	rownum++;
																	continue;
																}
																//验证权限--end
														}
														
							         			}
																
											}
										}
									}
								}
							}
				}else  //下面为输出结构和输出参数
				{
				
					
					isOnlyOutTable=false;
					for(int i=0;i<outStructure.size();i++)
					{
						Sap_outStructureBean s=(Sap_outStructureBean)outStructure.get(i);
						
						if(display==0)
						{
							outtablestr.append("<th style='display:none'>"+SystemEnv.getHtmlLabelName(30689 ,user.getLanguage()));
							outtablestr.append("</th>");
							outtablestr.append("<th>");
								outtablestr.append(SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()));
							outtablestr.append("</th>");
						}
								
						//判断是否有显示字段
						if((s.getDisplay()).equals("1"))//显示列
						{
							outtablestr.append("<th>");
								outtablestr.append(s.getShowname());
							outtablestr.append("</th>");
							display++;
							listsapfield.add(s.getName()+"."+s.getSapfield());//表明.字段名
						}else//隐藏列
						{
							outtablestr.append("<th style='display:none'>");
								outtablestr.append(s.getShowname());
							outtablestr.append("</th>");
							display++;
							listsapfielddisplay.add(s.getName()+"."+s.getSapfield());//表明.字段名
						}
						
						//判断是否有赋值字段
						if(!"".equals(s.getFromfieldid()))
						{
							listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getSapfield());
						}
						
						outtablelist=new StringBuffer("<tr class='DataDark'>");
						BrowserReturnParamsBean returnpar=saputil.executeABAPFunction(hashmap,type,new LogInfo());
						if(null!=returnpar)
						{
							outtablelist.append("<td style='display:none'>");
							outtablelist.append("</td>");
							outtablelist.append("<td>"+rownum);
							outtablelist.append("</td>");
							Map stmap=returnpar.getStrMap();
							for(int jk=0;jk<listsapfield.size();jk++)
	         				{
	         						Object result=stmap.get(listsapfield.get(jk));
	         						if(null==result)
	         						{
	         							result="";
	         						}
	         						outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value='"+result+"'></td>");
	         				}
	         				for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
	         				{
	         						Object result=stmap.get(listsapfielddisplay.get(jk));
	         						if(null==result)
	         						{
	         							result="";
	         						}
	         						outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value='"+result+"'></td>");
	         				}
						}
						outtablelist.append("</tr>");
					
					}
					for(int i=0;i<outParameter.size();i++)
					{
						Sap_outParameterBean s=(Sap_outParameterBean)outParameter.get(i);
						if(display==0)
						{
							outtablestr.append("<th style='display:none'>"+SystemEnv.getHtmlLabelName(30689 ,user.getLanguage()));
							outtablestr.append("</th>");
							outtablestr.append("<th>");
								outtablestr.append(SystemEnv.getHtmlLabelName(15486 ,user.getLanguage()));
							outtablestr.append("</th>");
						}
						//判断是否有显示字段
						if((s.getDisplay()).equals("1"))//显示列
						{
							outtablestr.append("<th>");
								outtablestr.append(s.getShowname());
							outtablestr.append("</th>");
							display++;
							listsapfield.add(s.getSapfield());//表明.字段名
						}else//隐藏列
						{
							outtablestr.append("<th style='display:none'>");
								outtablestr.append(s.getShowname());
							outtablestr.append("</th>");
							display++;
							listsapfielddisplay.add(s.getSapfield());//表明.字段名
						}
						
						//判断是否有赋值字段
						if(!"".equals(s.getFromfieldid()))
						{
							listoafield.add(s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getIsmainfield()+"-"+s.getSapfield());
						}
					}
					outtablelist=new StringBuffer("<tr class='DataDark'>");
					BrowserReturnParamsBean returnpar=saputil.executeABAPFunction(hashmap,type,new LogInfo());
					if(null!=returnpar)
					{
						outtablelist.append("<td style='display:none'>");
						outtablelist.append("</td>");
						outtablelist.append("<td>"+rownum);
						outtablelist.append("</td>");
						Map stmap=returnpar.getStrMap();
						
						for(int jk=0;jk<listsapfield.size();jk++)
         				{
         						
         						Object result=stmap.get(listsapfield.get(jk));
         						if(null==result)
         						{
         							result="";
         						}
         						outtablelist.append("<td>"+result+"<input name='"+listsapfield.get(jk)+"' type='hidden' value='"+result+"'></td>");
         				}
         				for(int jk=0;jk<listsapfielddisplay.size();jk++)//输出隐藏列
         				{
         						Object result=stmap.get(listsapfielddisplay.get(jk));
         						if(null==result)
         						{
         							result="";
         						}
         						outtablelist.append("<td style='display:none'>"+result+"<input name='"+listsapfielddisplay.get(jk)+"' type='hidden' value='"+result+"'></td>");
         				}
					}
					outtablelist.append("</tr>");
					
					countdata=2;//表示只有一行数据
				}
				
			 %>
			 
			 
			<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:btnseach(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			if(curpage>1)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1258 ,user.getLanguage())+",javascript:nextpage(2),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
			if((countdata-1)>(curpage*rows))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1259 ,user.getLanguage())+",javascript:nextpage(1),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/TopTitle.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
		
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" id="bjsap">
			<colgroup>
			<col width="10">
			<col width="*">
			<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td ></td>
				<td valign="top">
					<TABLE class=Shadow>
					<tr>
					<td valign="top" width="100%">
					
								<form action="/integration/sapSingleBrowserDetial.jsp" name="weaver" method="post" >
										<%=oncelistinput %>
										<input type="hidden" name="operate" id="operate" value="<%=operate%>">
										<input type="hidden" name="type"  id="type" value="<%=type%>">
										<input type="hidden" name="curpage"  id="curpage" value="<%=curpage%>">
										<input type="hidden" name="fromfieldid"  id="curpage" value="<%=fromfieldid%>">
										<input type="hidden" name="detailrow"  id="detailrow" value="<%=detailrow%>">
										<%=outtablesb%>
							</form>
							
							<br>
							<table class=viewform>
							<TR class='Spacing'  style='height:1px;'><TD class='Line1' ></TD></TR>
							<tr>
								<td class=field style="text-align: right">
								    <%=SystemEnv.getHtmlLabelName(30640,user.getLanguage())%><%=curpage%><%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%>&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%>
									<%out.println((countdata-1));%>
									<%=SystemEnv.getHtmlLabelName(30690,user.getLanguage())%>&nbsp;&nbsp;
									<%=SystemEnv.getHtmlLabelName(30643,user.getLanguage())%><%=rows%><%=SystemEnv.getHtmlLabelName(30690,user.getLanguage())%>&nbsp;&nbsp;
								</td>
							</tr>
							<TR class='Spacing'  style='height:1px;'><TD class='Line1'></TD></TR>
							</table>
							<table  ID=BrowseTable class=BroswerStyle cellspacing="1"  style="width:100%">
								<tr class="DataHeader">
									<%=outtablestr%>
								</tr>
									<%=outtablelist %>
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
		
	</body>

	<DIV class=huotu_dialog_overlay id="hidediv"></DIV>
	     <div  id="hidedivmsg" class="bd_dialog_main"></div>

</html>

<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr").bind("click",function(event){
			setParentWindowValue($(this));
			<%if(isOnlyOutTable){%>
				var temparry=Array($.trim($(this).find("td")[0].innerHTML),$.trim($(this).find("td")[0].innerHTML));
				window.parent.returnValue = Array($.trim($(this).find("td")[0].innerHTML),$.trim($(this).find("td")[0].innerHTML));
			<%}
				//主键优先赋值，如果设置了赋值字段，那么赋值字段不能覆盖主键的字段的值（把上面的setParentWindowValue方法放到returnvalue下面执行好像有问题，不起作用）
			%>
			window.parent.close();
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});
function btnclear_onclick(){
	window.parent.returnValue = Array(0,"");
	window.parent.close();
}
$(document).ready(function(){ 
	         $("input").keydown(function(e){ 
	             var curKey = e.which; 
	             if(curKey == 13){ 
	                 btnseach();
	                 return false; 
	             } 
	         }); 
}); 

function setParentWindowValue(checkvalue)
{
	//$(checkvalue).children("td").each(function(index) {
			//var tdvalue=$(this).text();
	//});

	<%
		//得到需要赋值的oa字段
		for(int jk=0;jk<listoafield.size();jk++)
		{
			//T_DATA.MATNR
			//s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
			String temp=listoafield.get(jk)+"";
			String tempa[]=temp.split("-");
			String jie="field"+tempa[0];
			String jiespan="field"+tempa[0]+"span";
			String ismainfield=tempa[2];
			String filename=tempa[3];
			//s.getFromfieldid()+"-"+s.getOafield()+"-"+s.getismainfield()
			if("0".equals(ismainfield)){
				jie = jie+"_"+detailrow;
				jiespan=jie+"span";
			}
	%>
	
	if($.browser.msie) { 
		//ie
			try{
					if($(checkvalue).find("input[name=<%=filename%>]").val()){
					 	window.dialogArguments.document.getElementById("<%=jie%>").value = $(checkvalue).find("input[name=<%=filename%>]").val();
					}else{
						window.dialogArguments.document.getElementById("<%=jie%>").value="";
					}
			}catch(e){
			}
			
			try{
			if(window.dialogArguments.document.getElementById("<%=jie%>").type=="hidden"){
				if($(checkvalue).find("input[name=<%=filename%>]").val())
				{
				 window.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML = $(checkvalue).find("input[name=<%=filename%>]").val();
				}else
				{
					window.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML="";
				}
			}else{
				window.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML = "";
			} 
			}catch(e){
			}
	}else{
			//非ie			
			//说明：老表单的明细字段解析
			//input对面没有id属性，只有name属性
			//导致在非ie浏览器下，js脚本找不到对象
			//所以在非ie浏览器下，用	window.parent.dialogArguments.document.getElementsByName("<%=jie%>")[0]来取对象
			//另外非ie浏览器下，非空字符串默认不等于ture么？？
			
			try{
				if($(checkvalue).find("input[name=<%=filename%>]").val()){
						
				 		window.parent.dialogArguments.document.getElementsByName("<%=jie%>")[0].value = $(checkvalue).find("input[name=<%=filename%>]").val();
				}else{
						window.parent.dialogArguments.document.getElementsByName("<%=jie%>")[0].value="";
				}
				}catch(e){
						
				}
				try{
						
					if(	window.parent.dialogArguments.document.getElementsByName("<%=jie%>")[0].type=="hidden"){
						
						if($(checkvalue).find("input[name=<%=filename%>]").val()!=""){
							
						 	window.parent.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML = $(checkvalue).find("input[name=<%=filename%>]").val();
							
						}else{
							window.parent.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML="";
						}
					}else{
							window.parent.dialogArguments.document.getElementById("<%=jiespan%>").innerHTML = "";
					} 
				}catch(e){
						
							
				}
	}		
<%		
	}
%>
}
function btnseach()
{
	$("#operate").attr("value","search");
	$("#curpage").attr("value","1");
	weaver.submit();

	enableAllmenu();
	var temp=parseInt($("#bjsap").css("height"))+50;
	$("#hidediv").css("height",temp);
	var h2=$("#hidedivmsg").css("height");
	var w2=$("#hidedivmsg").css("width");
	var a=(document.body.clientWidth)/2-140; 
	var b=(document.body.clientHeight)/2-40;
	$("#hidedivmsg").css("left",a);
	$("#hidedivmsg").css("top",b);
	$("#hidediv").show();
	$("#hidedivmsg").html("数据搜索中"+"...").show();

}
function submitClear()
{
	btnclear_onclick();
}
function onClose()
{
	window.close();
}
function nextpage(type)
{
	if(type=="1")
	{
		var temp=parseInt($("#curpage").val())+1;
		$("#curpage").attr("value",temp);
		weaver.submit();
	}else
	{
		var temp=parseInt($("#curpage").val())-1;
		$("#curpage").attr("value",temp);
		weaver.submit();
	}
	
}
</script>
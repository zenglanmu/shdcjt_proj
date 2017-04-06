<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="org.apache.commons.configuration.XMLConfiguration" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Arrays" %>


<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageManager" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%

System.setProperty("javax.xml.transform.TransformerFactory",   "org.apache.xalan.processor.TransformerFactoryImpl");
System.setProperty("javax.xml.parsers.DocumentBuilderFactory",   "org.apache.xerces.jaxp.DocumentBuilderFactoryImpl");
System.setProperty("javax.xml.parsers.SAXParserFactory",   "org.apache.xerces.jaxp.SAXParserFactoryImpl");
System.setProperty("org.xml.sax.driver",   "org.apache.xerces.parsers.SAXParser");

String method = Util.null2String(request.getParameter("method"));	
String type = Util.null2String(request.getParameter("type"));
String styleid = Util.null2String(request.getParameter("styleid"));	
//out.println("type:"		+type);
//out.println("method:"		+method);
String pageEdit="";
List paraList=new ArrayList();
if("edit".equals(method)){
	
	pageEdit="";
	String confPath="";
	String[] configArray=null; 
	if("element".equals(type)){			
		String tempStr[]={"title","desc","css","cornerTop","cornerBottom","imgMode","titleState","settingState","refreshIconState","settingIconState","closeIconState","moreLocal","iconLogo","iconMenu","iconLock","iconUnLock","iconRefresh","iconSetting","iconClose","iconMore","iconEsymbol","cornerTopRadian","cornerBottomRadian"};		paraList=Arrays.asList(tempStr); 
		paraList=Arrays.asList(tempStr);
		pageEdit="ElementStyleEdit.jsp";
		confPath="style.conf";
	} else if("menuh".equals(type)){
		String tempStr[]={"title","desc","cornerTop","cornerBottom","cornerTopRadian","cornerBottomRadian","css","iconMainDown","iconSubDown","showSelectedState"};
		paraList=Arrays.asList(tempStr);

		pageEdit="MenuStyleEditH.jsp";
		confPath="menuh.conf";
	} else if("menuv".equals(type)){
		String tempStr[]={"title","desc","css"};
		paraList=Arrays.asList(tempStr);

		pageEdit="MenuStyleEditV.jsp";
		confPath="menuv.conf";
	}

	//循环及更改配置文件里的配置项

	String file=pc.getConfig().getString(confPath)+styleid+".xml";
	XMLConfiguration configStyle=pm.getConfig(file);
	configStyle.setEncoding("UTF-8");
	for(int i=0;i<paraList.size();i++){
		String prop=(String)paraList.get(i);
		String value=Util.null2String(request.getParameter(prop));
		if(!prop.equals("") && (prop.equals("title") || prop.equals("desc"))){
			char c[] = value.toCharArray();
	        char ch;
	        int j = 0;
	        StringBuffer buf = new StringBuffer();
	
	        while (j < c.length) {
	            ch = c[j++];
	            if (ch == '<'){
	                buf.append("&lt;");
	           	}else if (ch == '>'){
	                buf.append("&gt;");
	            }else if (ch == '"'){
	                buf.append("&quot;");
	            }else{
	                buf.append(ch);
	            }
	        }
			value = buf.toString();
		}
		//TD29739 begin : css中逗号转义    否则生成xml时，会认为value结束
		if(!prop.equals("") && (prop.equals("css") )){
			char c[] = value.toCharArray();
	        char ch;
	        int j = 0;
	        StringBuffer buf = new StringBuffer();
	
	        while (j < c.length) {
	            ch = c[j++];
	            if (ch == ','){           	
	            	buf.append("&#44;");
	            }else{
	                buf.append(ch);
	            }
	        }
			value = buf.toString();
		}
		//TD29739  end 
		//out.println(prop+":"+value+"<br>");
		configStyle.setProperty(prop,value);
	}
	//configStyle.setSystemID("");
	configStyle.save(); 

	//更新缓存
	
	
	if("element".equals(type)){				
		//esc.updateCache(styleid);
		esc.clearCominfoCache();
	} else if("menuh".equals(type)){
		//mhsc.updateCache(styleid);
		mhsc.clearCominfoCache();
	} else if("menuv".equals(type)){
		//mvsc.updateCache(styleid);
		mvsc.clearCominfoCache();
	}
	response.sendRedirect(pageEdit+"?type="+type+"&styleid="+styleid+"&message=1");
} else if("del".equals(method)){
	String path="";
	
	String pageList="";
	String strSql="";
	boolean isUsed=false;
	if("element".equals(type)){					
		pageEdit="ElementStyleEdit.jsp";
		pageList="/page/maint/style/StyleList.jsp?type=element";
		path=pc.getConfig().getString("style.conf");
		
		StringBuffer areaelementsBf=new StringBuffer();
    	String areaelements="";
    	rs.execute("select areaelements from hplayout");
    	while(rs.next()){
    		areaelementsBf.append(rs.getString("areaelements"));
    	}
    	areaelements = areaelementsBf.toString();
    	if(areaelements.length()>0){
    		areaelements = areaelements.substring(0,areaelements.length()-1);
    	}
    	ArrayList list = Util.TokenizerString(areaelements, ",");
    	Set  set = new HashSet(list);
    	Iterator   iterator   =   set.iterator(); 
    	areaelementsBf.setLength(0);
    	while (iterator.hasNext()){ 
            areaelementsBf.append(iterator.next().toString()+",");      
    	} 
    	areaelements = areaelementsBf.toString();
    	if(areaelements.length()>0){
    		areaelements = areaelements.substring(0,areaelements.length()-1);
    	}
    	if(!areaelements.equals("")){
    		
    		strSql="select count(*) from hpelement where styleid='"+styleid+"' and id in("+areaelements+")";
    		//System.out.println(strSql);
    		rs.executeSql(strSql);
    		rs.next();
    		isUsed=rs.getInt(1)==0?false:true;
    	}	
		
		if(!isUsed){
			strSql="select count(*) from hpinfo where styleid='"+styleid+"'";
			rs.executeSql(strSql);
			rs.next();
			isUsed=rs.getInt(1)==0?false:true;
		}
	} else if("menuh".equals(type)){
		pageEdit="MenuStyleEditH.jsp";
		pageList="/page/maint/style/StyleList.jsp?type=menuh";
		path=pc.getConfig().getString("menuh.conf");
		strSql="select count(*) from hpElementSetting where name='menuids' and eid in "+
			   "(select distinct eid from hpelementsetting where name='menutype' and value='menuh') and value='"+styleid+"'";
		rs.executeSql(strSql);
		rs.next();
		isUsed=rs.getInt(1)==0?false:true;
		if(!isUsed){
			strSql="select count(*) from extendHpWebCustom where menustyleid='"+styleid+"'";
			rs.executeSql(strSql);
			rs.next();
			isUsed=rs.getInt(1)==0?false:true;
		}
		if(!isUsed){
			strSql="select count(*) from hpinfo where menustyleid='"+styleid+"'";
			rs.executeSql(strSql);
			rs.next();
			isUsed=rs.getInt(1)==0?false:true;
		}
		
	} else if("menuv".equals(type)){
		pageEdit="MenuStyleEditV.jsp";
		pageList="/page/maint/style/StyleList.jsp?type=menuv";
		path=pc.getConfig().getString("menuv.conf");
		strSql="select count(*) from hpElementSetting where name='menuids' and eid in "+
		   "(select distinct eid from hpelementsetting where name='menutype' and value='menuv') and value='"+styleid+"'";
		rs.executeSql(strSql);
		rs.next();
		isUsed=rs.getInt(1)==0?false:true;
	}

	if(!isUsed){
		//删除文件
		File target=new File(pm.getRealPath(path+styleid+".xml"));
		target.delete();
		
		//删除缓存
		if("element".equals(type)){		
			//esc.removeCache(styleid);
			esc.clearCominfoCache();
		} else if("menuh".equals(type)){
			//mhsc.removeCache(styleid);
			mhsc.clearCominfoCache();
		} else if("menuv".equals(type)){
			//mvsc.removeCache(styleid);
			mvsc.clearCominfoCache();
		}
		response.sendRedirect(pageList);
		
	} else {		
		response.sendRedirect(pageEdit+"?type="+type+"&styleid="+styleid+"&msg=isused");
	}	
} else if("addFromTemplate".equals(method)){

	String template = Util.null2String(request.getParameter("template"));	
	long now = System.currentTimeMillis();
	String id=""+now;	
	
	//copy 文件
	String path="";
	if("element".equals(type)){				
		path=pc.getConfig().getString("style.conf");
	} else if("menuh".equals(type)){
		path=pc.getConfig().getString("menuh.conf");
	} else if("menuv".equals(type)){
		path=pc.getConfig().getString("menuv.conf");
	}

	File src=new File(pm.getRealPath(path+template+".xml"));
	File target=new File(pm.getRealPath(path+id+".xml"));
	
	FileUtils.copyFile(src,target);
	
	//修改新的文件
	XMLConfiguration configStyle=pm.getConfig(path+id+".xml");
	configStyle.setEncoding("UTF-8");
	configStyle.setProperty("id",id);
	configStyle.setProperty("title",id);
	configStyle.setProperty("desc",id);
	//configStyle.setSystemID("");
	configStyle.save();
	
	
	if("element".equals(type)){		
		pageEdit="ElementStyleEdit.jsp";
		//esc.updateCache(id);
		esc.clearCominfoCache();
	} else if("menuh".equals(type)){
		pageEdit="MenuStyleEditH.jsp";
		//mhsc.updateCache(id);
		mhsc.clearCominfoCache();
	} else if("menuv".equals(type)){
		pageEdit="MenuStyleEditV.jsp";
		//mvsc.updateCache(id);
		mvsc.clearCominfoCache();
	}
	
	//转发新的地址
	response.sendRedirect(pageEdit+"?type="+type+"&styleid="+id);
}
%>
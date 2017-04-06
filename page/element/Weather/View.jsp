<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.general.WeatherData"%>
<%@page import="java.io.File"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="weatherData" class="weaver.general.WeatherData" scope="page" />
<%
	String weathersrc = (String)valueList.get(nameList.indexOf("weathersrc"));
    String autoScroll= (String)valueList.get(nameList.indexOf("autoScroll"));   //如果autoScroll 值为"1"则自动滚动，为"0"则不自动滚动
    String width= (String)valueList.get(nameList.indexOf("width"));
	//weatherData.getWeaherByCity(weathersrc,7); 单个城市读取方式
	String imgPath=request.getRealPath("")+"resource"+File.separatorChar+"image"+File.separatorChar+"weather";
	List weatherDataList=weatherData.getWeaherByCitys(weathersrc,7,imgPath);
	int wcount=weatherDataList.size();
%>

	<%if(weatherDataList!=null){ %>
	<table id="weatherTable_<%=eid %>" style="overflow: hidden; background-color: #FFFFFF; width: 100%;" align="center" onresize="">
  <tr>
    <td VALIGN="middle" style="vertical-align:middle;">
    <div  id="weatherback_<%=eid %>" style="cursor:hand;"  <%if(autoScroll.equals("1")||wcount*80<Integer.parseInt(width)){ %> class="" <% } else{%> class=pictureback <% }%> onclick="backWeatherMarquee(<%=eid %>);"></div>
    </td>
    <td align="center">
	  <div id="weather_<%=eid%>" align="center">
		  <div id="weather_<%=eid%>_0" style="overflow:hidden;width:<%=width%>;">
		  <%if(autoScroll.equals("1")){ %>
	  		<marquee direction="left" scrollamount="2" onMouseOver="stop();" onMouseOut="start();">
	  	  <% } %>
            <table align=center cellpadding=0 cellspace=0 border=0>
				<tr> 
				  <td id="weather_<%=eid%>_1" valign=top style="float: left;">
				      <table>
				         <tr>
				           <%
				           		if(weatherDataList.size()==0){
				           			%>
				           			<td width="*" align="top">
				           			<span height='20' style='padding-top:5px'>
									<img src='/images/icon.gif'/>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24956,7) %>
									</span>
							</td>	
							<% 
				           		}else{
				           %>
				           <%for(int i=0;i<weatherDataList.size();i++){
				        	   weatherData=(WeatherData)weatherDataList.get(i);
				        	   %>
						       <td width="80" align="center">
										<span class="wetCityName"><%=weatherData.getCity()%> <%=weatherData.getCondition()%></span><br>
										   <div style="width: 80"><%=weatherData.getIcon()%></div> 
											<br>
											<%=weatherData.getTemperature()%>
								</td>			
							<%} %>	
							<%} %>
						  </tr> 
					   </table>
		          </td>
				  <td id="weather_<%=eid%>_2" valign=top >
				
				  </td>
                 </tr>
               </table>
			<%if(autoScroll.equals("1")){ %>
			  	</marquee>
			<%} %>
	  </div>
	  <%-- 
	     <%if(autoScroll.equals("1")){ %>
			<script>
				weatherAutoScroll("weather_<%=eid%>");
			</script>
		 <%} %>	--%>
	 </div>
	 </td>
    <td VALIGN="middle" style="vertical-align:middle;">
    	<div id="weathernext_<%=eid %>"  <%if(autoScroll.equals("1")||wcount*80<Integer.parseInt(width)){ %> class="" <%}else{%> class="picturenext"  <%}%> style="cursor:hand;" onclick="nextWeatherMarquee(<%=eid%>);"></div>
    </td>
  </tr>
</table>
	<%} %>


package weaver.hrm.report.schedulediff;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.general.TimeUtil;
import weaver.hrm.company.DepartmentComInfo;
import weaver.hrm.User;
import weaver.hrm.report.schedulediff.HrmScheduleDiffUtil;
import weaver.hrm.report.schedulediff.HrmScheduleDiffDetBeLateManager;
import weaver.hrm.report.schedulediff.HrmScheduleDiffDetLeaveEarlyManager;
import weaver.hrm.report.schedulediff.HrmScheduleDiffDetAbsentFromWorkManager;
import weaver.hrm.report.schedulediff.HrmScheduleDiffDetNoSignManager;

public class HrmScheduleDiffManagerNew  extends BaseBean {
	private User user;//当前用户对象
	public HrmScheduleDiffManagerNew() {
		user=null;
	}
	
	   /**
	    * 设置请求当前操作用户
	    * @param user 当前操作用户  @see User
	    */ 
	public void setUser(User user) {
		this.user = user;
	}
	
	/**
	 *  计算合计的工作天数
	 * 
	 * @param fromDate  开始日期
	 * @param toDate    结束日期          
	 * @return int 合计的工作天数
	 */		
	public int getTotalWorkingDays(String fromDate,String toDate){
		int totalWorkingDays=0;

		//安全检查
		if(fromDate==null||fromDate.trim().equals("")
		 ||toDate==null||toDate.trim().equals("")	
		 ||fromDate.compareTo(toDate)>0){
			return totalWorkingDays;
		}		
		
		String currentDate="";
		String nextDate="";
	    boolean hasReachToDate=false;
	    boolean isWorkday=true;
	    HrmScheduleDiffUtil hrmScheduleDiffUtil=new HrmScheduleDiffUtil();
	    hrmScheduleDiffUtil.setUser(this.user);
	    
		for(currentDate=fromDate;!hasReachToDate;){
			
	        if(currentDate.equals(toDate)){
	        	hasReachToDate=true;
			}
	        
	        isWorkday=hrmScheduleDiffUtil.getIsWorkday(currentDate);
	        
	        if(!isWorkday){
				//获取下一日期
				nextDate=TimeUtil.dateAdd(currentDate,1);
				currentDate=nextDate;
				continue;
	        }
	        
			//获取下一日期
	        
			nextDate=TimeUtil.dateAdd(currentDate,1);
			currentDate=nextDate;
			totalWorkingDays++;
	        
		}		
		return totalWorkingDays;
	}
	/**
	 *  获得考勤列表
	 *  
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 * @return List   考勤列表
	 */ 	
	public List getScheduleList(String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		List scheduleList=new ArrayList();
		Map scheduleMap=null;
		Map resourceIdIndexMapping=new HashMap();

		RecordSet rs=new RecordSet();		
		
		StringBuffer sb=new StringBuffer();
		sb.append("select id,lastName,departmentId from HrmResource where status in(0,1,2,3) ");
		
		if("oracle".equals(rs.getDBType())){
			sb.append(" and loginid is not null ");
		}else{
			sb.append(" and loginid is not null and loginid<>'' ");
		}
		
		if(subCompanyId>0){
			sb.append(" and  subCompanyId1=").append(subCompanyId);
		}

		if(departmentId>0){
			sb.append(" and  departmentId=").append(departmentId);
		}
		
		if(resourceId>0){
			sb.append(" and  id=").append(resourceId);
		}
		
		sb.append("  order by subCompanyId1 asc,departmentId asc,id asc ");
		
		try{
			
			DepartmentComInfo departmentComInfo=new DepartmentComInfo();
			
			int tempDepartmentId=0;
			String tempDepartmentName="";
			int tempResourceId=0;
			String tempResourceName="";
			
			int index=0;

			rs.executeSql(sb.toString());
			while(rs.next()){
				tempDepartmentId=rs.getInt("departmentId");
				tempDepartmentName=departmentComInfo.getDepartmentname(""+tempDepartmentId);
				tempResourceId=rs.getInt("id");
				tempResourceName=Util.null2String(rs.getString("lastName"));
				
				scheduleMap=new HashMap();
				scheduleMap.put("departmentName",tempDepartmentName);
				scheduleMap.put("resourceName",tempResourceName);	
				
				resourceIdIndexMapping.put(String.valueOf(tempResourceId),String.valueOf(index));
				scheduleList.add(scheduleMap);
				index++;
			}
			
			//更新迟到（A、B）的数据
			updateDataOfBeLate(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);
			
			//更新早退（A、B）的数据
			updateDataOfLeaveEarly(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);			
			
			//更新旷工的数据
			updateDataOfAbsentFromWork(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);
			
			//更新漏签的数据
			updateDataOfNoSign(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);
			
			//更新请假（病假、事假、其他假别、备注）的数据
			updateDataOfLeave(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);
			
			//更新出差的数据
			updateDataOfEvection(scheduleList,resourceIdIndexMapping,fromDate,toDate,subCompanyId,departmentId,resourceId);
			
			//更新公出的数据
			//updateDataOfOut();
			
			return scheduleList;			
		}catch(Exception ex){
			return scheduleList;			
		}finally{
			
		}
	}
	
	/**
	 *  更新迟到（A、B）的数据
	 *  
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfBeLate(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得迟到列表
		HrmScheduleDiffDetBeLateManager beLateManager=new HrmScheduleDiffDetBeLateManager();
		beLateManager.setUser(this.user);
		beLateManager.setSortForResult(false);
		List beLateList=beLateManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
		Map beLateMap=null;
		
		String tempResourceId="";
		String tempSignTime="";
		int index=-1;
		
		Map scheduleMap=null;
		String beLateA="";
		String beLateB="";
		
		for(int i=0;i<beLateList.size();i++){
			beLateMap=(Map)beLateList.get(i);
			tempResourceId=Util.null2String((String)beLateMap.get("resourceId"));
			tempSignTime=Util.null2String((String)beLateMap.get("signTime"));
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);
				//迟到：A：09点以前迟到，B：09点后迟到(包括09点)；
//				if(tempSignTime.compareTo(criticalOfAandBForAM)<0){
//					beLateA=(String)scheduleMap.get("beLateA");
//					beLateA=String.valueOf(Util.getIntValue(beLateA,0)+1);
//					scheduleMap.put("beLateA",beLateA);
//				}else{
//				}
				beLateB=(String)scheduleMap.get("beLateB");
				beLateB=String.valueOf(Util.getIntValue(beLateB,0)+1);
				scheduleMap.put("beLateB",beLateB);					
			}
		}
	}
	
	/**
	 *  更新早退（A、B）的数据
	 *  
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfLeaveEarly(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得早退列表
		HrmScheduleDiffDetLeaveEarlyManager leaveEarlyManager=new HrmScheduleDiffDetLeaveEarlyManager();
		leaveEarlyManager.setUser(this.user);
		leaveEarlyManager.setSortForResult(false);
		List leaveEarlyList=leaveEarlyManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
		Map leaveEarlyMap=null;
		
		String tempResourceId="";
		String tempSignTime="";
		int index=-1;
		
		Map scheduleMap=null;
		String leaveEarlyA="";
		String leaveEarlyB="";
		
		for(int i=0;i<leaveEarlyList.size();i++){
			leaveEarlyMap=(Map)leaveEarlyList.get(i);
			tempResourceId=Util.null2String((String)leaveEarlyMap.get("resourceId"));
			tempSignTime=Util.null2String((String)leaveEarlyMap.get("signTime"));
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);
				//早退：A：17点以后早退，B：17点前早退（包括17点）；
//				if(tempSignTime.compareTo(criticalOfAandBForPM)>0){
//					leaveEarlyA=(String)scheduleMap.get("leaveEarlyA");
//					leaveEarlyA=String.valueOf(Util.getIntValue(leaveEarlyA,0)+1);
//					scheduleMap.put("leaveEarlyA",leaveEarlyA);
//				}else{
//				}
				leaveEarlyB=(String)scheduleMap.get("leaveEarlyB");
				leaveEarlyB=String.valueOf(Util.getIntValue(leaveEarlyB,0)+1);
				scheduleMap.put("leaveEarlyB",leaveEarlyB);					
			}
		}
	}
	
	/**
	 *  更新旷工的数据
	 *  
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表 
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfAbsentFromWork(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得旷工列表
		HrmScheduleDiffDetAbsentFromWorkManager absentFromWorkManager=new HrmScheduleDiffDetAbsentFromWorkManager();
		absentFromWorkManager.setUser(this.user);
		absentFromWorkManager.setSortForResult(false);
		List absentFromWorkList=absentFromWorkManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
		Map absentFromWorkMap=null;
		
		String tempResourceId="";
		int index=-1;
		
		Map scheduleMap=null;
		String absentFromWork="";
		
		for(int i=0;i<absentFromWorkList.size();i++){
			absentFromWorkMap=(Map)absentFromWorkList.get(i);
			tempResourceId=Util.null2String((String)absentFromWorkMap.get("resourceId"));
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);
				absentFromWork=(String)scheduleMap.get("absentFromWork");
				absentFromWork=String.valueOf(Util.getIntValue(absentFromWork,0)+1);
				scheduleMap.put("absentFromWork",absentFromWork);
			}
		}
	}
	
	/**
	 *  更新漏签的数据
	 *  
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfNoSign(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得漏签列表
		HrmScheduleDiffDetNoSignManager noSignManager=new HrmScheduleDiffDetNoSignManager();
		noSignManager.setUser(this.user);
		noSignManager.setSortForResult(false);
		List noSignList=noSignManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
		Map noSignMap=null;
		
		String tempResourceId="";
		int index=-1;
		
		Map scheduleMap=null;
		String noSign="";
		
		for(int i=0;i<noSignList.size();i++){
			noSignMap=(Map)noSignList.get(i);
			tempResourceId=Util.null2String((String)noSignMap.get("resourceId"));
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);
				noSign=(String)scheduleMap.get("noSign");
				noSign=String.valueOf(Util.getIntValue(noSign,0)+1);
				scheduleMap.put("noSign",noSign);
			}
		}
	}
	
	/**
	 *  更新请假（病假、事假、其他假别、备注）的数据
	 * 
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表 
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfLeave(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得请假列表
		List leaveList=new ArrayList();;
		Map leaveMap=null;
		HrmScheduleDiffUtil hrmScheduleDiffUtil=new HrmScheduleDiffUtil();
		hrmScheduleDiffUtil.setUser(user);		

		String tempResourceId="";
		String tempFromDate="";
		String tempFromTime="";
		String tempToDate="";
		String tempToTime="";		
		String tempLeaveDays="";
		String tempLeaveType="";
		String tempOtherLeaveType="";		
		
		StringBuffer sb=new StringBuffer();
		sb.append(" select c.id as resourceId,b.fromDate,b.fromTime,b.toDate,b.toTime,b.leaveDays,b.leaveType,b.otherLeaveType ")
		  .append("   from Workflow_Requestbase a,Bill_BoHaiLeave b,HrmResource c ")
		  .append("  where a.requestId=b.requestId ")
		  .append("    and b.resourceId=c.id ")
		  .append("    and a.currentNodeType='3' ")		  
		  .append("    and c.status in(0,1,2,3) ");
			
		if(!fromDate.equals("")){
			sb.append(" and  b.toDate>='").append(fromDate).append("'");
		}

		if(!toDate.equals("")){
			sb.append(" and  b.fromDate<='").append(toDate).append("'");
		}

		if(subCompanyId>0){
			sb.append(" and  c.subCompanyId1=").append(subCompanyId);
		}

		if(departmentId>0){
			sb.append(" and  c.departmentId=").append(departmentId);
		}
			
		if(resourceId>0){
			sb.append(" and  c.id=").append(resourceId);
		}
		
		RecordSet rs=new RecordSet();
		rs.executeSql(sb.toString());
		while(rs.next()){
			tempResourceId=Util.null2String(rs.getString("resourceId"));	
			tempFromDate=Util.null2String(rs.getString("fromDate"));	
			tempFromTime=Util.null2String(rs.getString("fromTime"));	
			tempToDate=Util.null2String(rs.getString("toDate"));				
			tempToTime=Util.null2String(rs.getString("toTime"));
			tempLeaveDays=Util.null2String(rs.getString("leaveDays"));			
			tempLeaveType=Util.null2String(rs.getString("leaveType"));					
			tempOtherLeaveType=Util.null2String(rs.getString("otherLeaveType"));					
			
			leaveMap=new HashMap();
			leaveMap.put("resourceId",tempResourceId);
			leaveMap.put("fromDate",tempFromDate);
			leaveMap.put("fromTime",tempFromTime);
			leaveMap.put("toDate",tempToDate);			
			leaveMap.put("toTime",tempToTime);	
			leaveMap.put("leaveDays",tempLeaveDays);			
			leaveMap.put("leaveType",tempLeaveType);	
			leaveMap.put("otherLeaveType",tempOtherLeaveType);						
			leaveList.add(leaveMap);						
		}			

		int index=-1;
		
		Map scheduleMap=null;
		String leave="";
		String remark="";
		String leaveTypeName="";
		String otherLeaveTypeName="";
		
		for(int i=0;i<leaveList.size();i++){
			leaveMap=(Map)leaveList.get(i);
			tempResourceId=Util.null2String((String)leaveMap.get("resourceId"));
			//tempLeaveDays=Util.null2String((String)leaveMap.get("leaveDays"));				
			tempLeaveType=Util.null2String((String)leaveMap.get("leaveType"));				
			tempOtherLeaveType=Util.null2String((String)leaveMap.get("otherLeaveType"));
			
			tempFromDate=Util.null2String((String)leaveMap.get("fromDate"));			
			tempFromTime=Util.null2String((String)leaveMap.get("fromTime"));
			tempToDate=Util.null2String((String)leaveMap.get("toDate"));
			tempToTime=Util.null2String((String)leaveMap.get("toTime"));
			
			if(tempFromDate.compareTo(fromDate)<0){
				tempFromDate=fromDate;
				tempFromTime="00:00";
			}
			
			if(tempToDate.compareTo(toDate)>0){
				tempToDate=toDate;
				tempToTime="23:59";
			}
			
			//tempLeaveDays=hrmScheduleDiffUtil.getTotalWorkingDays(tempFromDate,tempFromTime,tempToDate,tempToTime);
			tempLeaveDays=hrmScheduleDiffUtil.getTotalWorkingDays(tempFromDate,tempFromTime,tempToDate,tempToTime,subCompanyId);			
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);

				
				//如果请假类型为事假
				if(tempLeaveType.trim().equals("1")){
					
					leave=Util.null2String((String)scheduleMap.get("privateAffairLeave"));
					leave=String.valueOf(Util.getDoubleValue(leave,0)+Util.getDoubleValue(tempLeaveDays,0));					
					scheduleMap.put("privateAffairLeave",leave);
					
				//如果请假类型为病假
				}else if(tempLeaveType.trim().equals("2")){

					leave=Util.null2String((String)scheduleMap.get("sickLeave"));
					leave=String.valueOf(Util.getDoubleValue(leave,0)+Util.getDoubleValue(tempLeaveDays,0));					
					scheduleMap.put("sickLeave",leave);					
					
				//如果请假类型为其它非带薪假  B
				}else if(tempLeaveType.trim().equals("3")){
					
					leave=Util.null2String((String)scheduleMap.get("otherLeaveB"));
					leave=String.valueOf(Util.getDoubleValue(leave,0)+Util.getDoubleValue(tempLeaveDays,0));					
					scheduleMap.put("otherLeaveB",leave);

					leaveTypeName=hrmScheduleDiffUtil.getBillSelectName(180,"leaveType",Util.getIntValue(tempLeaveType,-1));
					otherLeaveTypeName=hrmScheduleDiffUtil.getBillSelectName(180,"otherLeaveType",Util.getIntValue(tempOtherLeaveType,-1));
					
					remark=Util.null2String((String)scheduleMap.get("remark"));	
					if(remark.trim().equals("")){
						remark+=leaveTypeName+"（"+otherLeaveTypeName+"）";
					}else{
						remark+="，"+leaveTypeName+"（"+otherLeaveTypeName+"）";
					}
					scheduleMap.put("remark",remark);
					
				//如果请假类型为其它带薪假  A
				}else if(tempLeaveType.trim().equals("4")){	
					
					leave=Util.null2String((String)scheduleMap.get("otherLeaveA"));
					leave=String.valueOf(Util.getDoubleValue(leave,0)+Util.getDoubleValue(tempLeaveDays,0));					
					scheduleMap.put("otherLeaveA",leave);
					
					leaveTypeName=hrmScheduleDiffUtil.getBillSelectName(180,"leaveType",Util.getIntValue(tempLeaveType,-1));
					otherLeaveTypeName=hrmScheduleDiffUtil.getBillSelectName(180,"otherLeaveType",Util.getIntValue(tempOtherLeaveType,-1));
					
					remark=Util.null2String((String)scheduleMap.get("remark"));	
					if(remark.trim().equals("")){
						remark+=leaveTypeName+"（"+otherLeaveTypeName+"）";
					}else{
						remark+="，"+leaveTypeName+"（"+otherLeaveTypeName+"）";
					}
					scheduleMap.put("remark",remark);					
					
				}
				//leave=(String)scheduleMap.get("noSign");
				//leave=String.valueOf(Util.getDoubleValue(leave,0)+Util.getDoubleValue(tempLeaveDays,0));
				//scheduleMap.put("noSign",noSign);
				
			}
		}
	}
	
	/**
	 *  更新出差的数据
	 *  
	 * @param scheduleList 考勤列表
	 * @param resourceIdIndexMapping  人力资源与索引对应表 
	 * @param fromDate 开始日期
	 * @param toDate 结束日期
	 * @param subCompanyId  分部id
	 * @param departmentId  部门id
	 * @param resourceId  人力资源id
	 * 
	 */ 	
	private void updateDataOfEvection(List scheduleList,Map resourceIdIndexMapping,String fromDate,String toDate,int subCompanyId,int departmentId,int resourceId){
		
		//获得请假列表
		List evectionList=new ArrayList();;
		Map evectionMap=null;
		HrmScheduleDiffUtil hrmScheduleDiffUtil=new HrmScheduleDiffUtil();
		hrmScheduleDiffUtil.setUser(user);

		String tempResourceId="";
		String tempFromDate="";
		String tempFromTime="";
		String tempToDate="";
		String tempToTime="";
		String tempEvectionDays="";
		
		
		StringBuffer sb=new StringBuffer();
		sb.append(" select c.id as resourceId,b.fromDate,b.fromTime,b.toDate,b.toTime ")
		  .append("   from Workflow_Requestbase a,Bill_BoHaiEvection b,HrmResource c ")
		  .append("  where a.requestId=b.requestId ")
		  .append("    and b.resourceId=c.id ")
		  .append("    and a.currentNodeType='3' ")		  
		  .append("    and c.status in(0,1,2,3) ");
			
		if(!fromDate.equals("")){
			sb.append(" and  b.toDate>='").append(fromDate).append("'");
		}

		if(!toDate.equals("")){
			sb.append(" and  b.fromDate<='").append(toDate).append("'");
		}

		if(subCompanyId>0){
			sb.append(" and  c.subCompanyId1=").append(subCompanyId);
		}

		if(departmentId>0){
			sb.append(" and  c.departmentId=").append(departmentId);
		}
			
		if(resourceId>0){
			sb.append(" and  c.id=").append(resourceId);
		}
		
		RecordSet rs=new RecordSet();
		rs.executeSql(sb.toString());
		while(rs.next()){
			tempResourceId=Util.null2String(rs.getString("resourceId"));
			tempFromDate=Util.null2String(rs.getString("fromDate"));
			tempFromTime=Util.null2String(rs.getString("fromTime"));
			tempToDate=Util.null2String(rs.getString("toDate"));					
			tempToTime=Util.null2String(rs.getString("toTime"));
											
			evectionMap=new HashMap();
			evectionMap.put("resourceId",tempResourceId);	
			evectionMap.put("fromDate",tempFromDate);	
			evectionMap.put("fromTime",tempFromTime);	
			evectionMap.put("toDate",tempToDate);
			evectionMap.put("toTime",tempToTime);			
			
			evectionList.add(evectionMap);						
		}			

		int index=-1;
		
		Map scheduleMap=null;
		String evection="";
		
		
		for(int i=0;i<evectionList.size();i++){
			evectionMap=(Map)evectionList.get(i);
			tempResourceId=Util.null2String((String)evectionMap.get("resourceId"));
			//tempEvectionDays=Util.null2String((String)evectionMap.get("evectionDays"));
			tempFromDate=Util.null2String((String)evectionMap.get("fromDate"));			
			tempFromTime=Util.null2String((String)evectionMap.get("fromTime"));
			tempToDate=Util.null2String((String)evectionMap.get("toDate"));
			tempToTime=Util.null2String((String)evectionMap.get("toTime"));
			
			if(tempFromDate.compareTo(fromDate)<0){
				tempFromDate=fromDate;
				tempFromTime="00:00";
			}
			
			if(tempToDate.compareTo(toDate)>0){
				tempToDate=toDate;
				tempToTime="23:59";
			}
			
			//tempEvectionDays=hrmScheduleDiffUtil.getTotalWorkingDays(tempFromDate,tempFromTime,tempToDate,tempToTime);
			tempEvectionDays=hrmScheduleDiffUtil.getTotalWorkingDays(tempFromDate,tempFromTime,tempToDate,tempToTime,subCompanyId);
			
			
			index=Util.getIntValue((String)resourceIdIndexMapping.get(tempResourceId),-1);
			if(index>=0){
				scheduleMap=(Map)scheduleList.get(index);
				
				evection=(String)scheduleMap.get("evection");
				//evection=String.valueOf(Util.getDoubleValue(evection,0)+Util.getDoubleValue(tempEvectionDays,0));
				evection=Util.getPointValue(Util.round(String.valueOf(Util.getDoubleValue(evection,0)+Util.getDoubleValue(tempEvectionDays,0)),2));
				scheduleMap.put("evection",evection);
				
			}
		}
	}	
}
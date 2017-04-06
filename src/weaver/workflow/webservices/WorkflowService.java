package weaver.workflow.webservices;

public interface WorkflowService {
	
	/**
	 * 获取待办流程列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 待办流程信息
	 */
	public WorkflowRequestInfo[] getToDoWorkflowRequestList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);
	
	/**
	 * 获取待办流程数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 待办流程数量
	 */
	public int getToDoWorkflowRequestCount(int userId, String[] conditions);

	/**
	 * 获取抄送流程列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 抄送流程信息
	 */
	public WorkflowRequestInfo[] getCCWorkflowRequestList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);
	
	/**
	 * 获取抄送流程数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 抄送流程数量
	 */
	public int getCCWorkflowRequestCount(int userId, String[] conditions);
	
	/**
	 * 获取已办流程列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 已办流程信息
	 */
	public WorkflowRequestInfo[] getHendledWorkflowRequestList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);
	
	/**
	 * 获取已办流程数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 已办流程数量
	 */
	public int getHendledWorkflowRequestCount(int userId, String[] conditions);

	/**
	 * 获取归档流程列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 归档流程信息
	 */
	public WorkflowRequestInfo[] getProcessedWorkflowRequestList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);

	/**
	 * 获取归档流程数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 归档流程数量
	 */
	public int getProcessedWorkflowRequestCount(int userId, String[] conditions);

	/**
	 * 获取我的请求列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 待办流程信息
	 */
	public WorkflowRequestInfo[] getMyWorkflowRequestList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);

	/**
	 * 获取我的请求数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 待办流程数量
	 */
	public int getMyWorkflowRequestCount(int userId, String[] conditions);
	
	/**
	 * 搜索所有可用流程数量
	 * @param keyword 流程标题
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 所有可用流程数量
	 */
	public int getAllWorkflowRequestCount(int userid, String[] conditions);
	
	/**
	 * 搜索所有可用流程
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param keyword 流程标题
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowRequestInfo 所有可用流程信息
	 */
	public WorkflowRequestInfo[] getAllWorkflowRequestList(int pageNo, int pageSize, int recordCount, int userid, String[] conditions);

	/**
	 * 取得流程详细信息
	 * 
	 * @param requestid 流程请求ID
	 * @param userid 当前用户
	 * @return WorkflowRequestInfo 流程信息
	 */
	public WorkflowRequestInfo getWorkflowRequest(int requestid,int userId,int fromrequestid);
	
	/**
	 * 取得流程详细信息
	 * 
	 * @param requestid 流程请求ID
	 * @param userid 当前用户
	 * @param pagesize 签字意见的条数
	 * @return WorkflowRequestInfo 流程信息
	 */
	public WorkflowRequestInfo getWorkflowRequest4split(int requestid, int userid,int fromrequestid, int pagesize);
	
	public WorkflowRequestLog[] getWorkflowRequestLogs(String workflowId, String requestId, int userid, int pagesize, int endId) throws Exception;
	/**
	 * 流程提交
	 * 
	 * @param WorkflowRequestInfo 流程信息
	 * @param requestid 流程请求ID
	 * @param userid 当前用户
	 * @param type 提交类型
	 * @param remark 签字意见
	 * @return String 提交结果
	 */
	public String submitWorkflowRequest(WorkflowRequestInfo wri,int requestid,int userId,String type,String remark);
	
	/**
	 * 流程转发
	 * 
	 * @param requestid 流程请求ID
	 * @param recipients 转发人
	 * @param userid 当前用户
	 * @param remark 签字意见
	 * @param clientip 用户IP
	 * @return String 转发结果
	 */
	public String forwardWorkflowRequest(int requestid,String recipients,String remark,int userId,String clientip);
	
	/**
	 * 取得可创建的工作流列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param workflowType 工作流类型
	 * @return WorkflowBaseInfo 工作流列表
	 */
	public WorkflowBaseInfo[] getCreateWorkflowList(int pageNo,int pageSize,int recordCount,int userId, int workflowType, String[] conditions);
	
	/**
	 * 取得可创建的工作流数量
	 * 
	 * @param userid 当前用户
	 * @param workflowType 工作流类型
	 * @param conditions 查询条件
	 * @return int 工作流数量
	 */
	public int getCreateWorkflowCount(int userId, int workflowType, String[] conditions);

	/**
	 * 取得可创建的工作流类型列表
	 * 
	 * @param pageNo 当前页数
	 * @param pageSize 每页记录数
	 * @param recordCount 记录总数
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return WorkflowBaseInfo 工作流类型列表
	 */
	public WorkflowBaseInfo[] getCreateWorkflowTypeList(int pageNo,int pageSize,int recordCount,int userId, String[] conditions);
	
	/**
	 * 取得可创建的工作流类型数量
	 * 
	 * @param userid 当前用户
	 * @param conditions 查询条件
	 * @return int 工作流类型数量
	 */
	public int getCreateWorkflowTypeCount(int userId, String[] conditions);

	/**
	 * 取得创建流程的相关信息
	 * 
	 * @param workflowId 工作流ID
	 * @param userid 当前用户
	 * @return WorkflowRequestInfo 流程信息
	 */
	public WorkflowRequestInfo getCreateWorkflowRequestInfo(int workflowId,int userId);
	
	/**
	 * 执行创建流程
	 * 
	 * @param WorkflowRequestInfo 流程信息
	 * @param userid 当前用户
	 * @return String 返回结果
	 */
	public String doCreateWorkflowRequest(WorkflowRequestInfo wri,int userId);
	
	/**
	 * 请假申请单特殊处理
	 * 根据起始日期、起始时间、结束日期、结束时间获得请假天数
	 * @param fromDate
	 * @param fromTime
	 * @param toDate
	 * @param toTime
	 * @param resourceId
	 * @return String 请假天数
	 */
	public String getLeaveDays(String fromDate,String fromTime,String toDate,String toTime,String resourceId);
	
	/**
	 * 取得流程new标记
	 * @param requestids
	 * @param resourceid
	 * @return
	 */
	public String[] getWorkflowNewFlag(String[] requestids, String resourceid);

	/**
	 * 删除流程
	 * @param requestid 请求id
	 * @param userId 用户id
	 * @return 删除是否成功 true成功，false失败
	 */
	public boolean deleteRequest(int requestid,int userId);
	
	/**
	 * 写入流程查看日志
	 * @param requestid
	 * @param userid
	 */
	public void writeWorkflowReadFlag(String requestid, String userid);
	
	/**
	 * 将签字意见信息更新到流程的最新签字意见信息中
	 * @param requestid
	 * @param userid
	 */
	public void updateWorkflowLog(String requestid, String log);
	
	/**
	 * 将南康的人员、部门、分部、岗位的主键信息同步到oa中
	 * @param requestid
	 * @param userid
	 */
	public void updateOaHrpkcode(String oaHrmId, String nkHrmId);
	/**
	 * 将南康的人员、部门、分部、岗位的主键信息同步到oa中
	 * @param requestid
	 * @param userid
	 */
	public void updateOaDeptpkcode(String oaDeptId, String nkDeptId);
	/**
	 * 将南康的人员、部门、分部、岗位的主键信息同步到oa中
	 * @param requestid
	 * @param userid
	 */
	public void updateOaSubCompkcode(String oaSubComId, String nkSubComId);
	/**
	 * 将南康的人员、部门、分部、岗位的主键信息同步到oa中
	 * @param requestid
	 * @param userid
	 */
	public void updateOaJobTitlepkcode(String oaJobTitleId, String nkJobTitleId);
}

delete from HtmlLabelIndex where id=21253 
GO
delete from HtmlLabelInfo where indexid=21253 
GO
INSERT INTO HtmlLabelIndex values(21253,'是否确定变更付款性质？') 
GO
INSERT INTO HtmlLabelInfo VALUES(21253,'是否确定变更付款性质？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21253,'Are you sure to change the Character?',8) 
GO
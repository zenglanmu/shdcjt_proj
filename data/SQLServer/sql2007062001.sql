delete from HtmlLabelIndex where id in(20509,20510,19113)
GO
delete from HtmlLabelInfo where indexId in(20509,20510,19113)
GO
INSERT INTO HtmlLabelIndex values(20509,'���Ĵ���') 
GO
INSERT INTO HtmlLabelIndex values(20510,'����С��') 
GO
INSERT INTO HtmlLabelInfo VALUES(20509,'���Ĵ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20509,'Dispatch Abstract Type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20510,'����С��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20510,'Dispatch Detail Type',8) 
GO

INSERT INTO HtmlLabelIndex values(19113,'ֵ') 
GO
INSERT INTO HtmlLabelInfo VALUES(19113,'ֵ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19113,'value',8) 
GO
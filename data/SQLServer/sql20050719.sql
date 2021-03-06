
alter  PROCEDURE CptCapital_Update 
	(@id_1 	int,
	 @mark_2        varchar(60),
	 @name_3 	varchar(60),
	 @barcode_4 	varchar(30),
	 @startdate		char(10),
	 @enddate		char(10),
	 @seclevel_7 	tinyint,
	 @resourceid	int,
	 @sptcount 	char(1),
	 @currencyid_11 	int,
	 @capitalcost_12 	decimal(18,3),
	 @startprice_13 	decimal(18,3),
	@depreendprice decimal(18,3),
	@capitalspec		varchar(60),			
	@capitallevel		varchar(30),			
	@manufacturer		varchar(100),
	@manudate		char(10),			
	 @capitaltypeid_14 	int,
	 @capitalgroupid_15 	int,
	 @unitid_16 	int,
	 @replacecapitalid_18 	int,
	 @version_19 	varchar(60),
	 @location      varchar(100),
	 @remark_21 	text,
	 @capitalimageid_22 	int,
	 @depremethod1_23 	int,
	 @depremethod2_24 	int,
	 @deprestartdate	char(10),
	 @depreenddate		char(10),
	 @customerid_27 	int,
	 @attribute_28 	tinyint,
	 @datefield1_31 	char(10),
	 @datefield2_32 	char(10),
	 @datefield3_33 	char(10),
	 @datefield4_34 	char(10),
	 @datefield5_35 	char(10),
	 @numberfield1_36 	float,
	 @numberfield2_37 	float,
	 @numberfield3_38 	float,
	 @numberfield4_39 	float,
	 @numberfield5_40 	float,
	 @textfield1_41 	varchar(100),
	 @textfield2_42 	varchar(100),
	 @textfield3_43 	varchar(100),
	 @textfield4_44 	varchar(100),
	 @textfield5_45 	varchar(100),
	 @tinyintfield1_46 	char(1),
	 @tinyintfield2_47 	char(1),
	 @tinyintfield3_48 	char(1),
	 @tinyintfield4_49 	char(1),
	 @tinyintfield5_50 	char(1),
	 @lastmoderid_51 	int,
	 @lastmoddate_52 	char(10),
	 @lastmodtime_53 	char(8),
	 @relatewfid		int,
	 @alertnum          decimal(18,3),
	 @fnamark			varchar(60),
	 @isinner			char(1),
	 @flag integer output,
	 @msg varchar(80) output)
AS 
/*更新资产组中的资产卡片数量信息*/
declare @tempgroupid int
select @tempgroupid=capitalgroupid from CptCapital where id=@id_1
if @tempgroupid<>@capitalgroupid_15
begin
	update CptCapitalAssortment set capitalcount = capitalcount-1 
	where id=@tempgroupid
	update CptCapitalAssortment set capitalcount = capitalcount+1 
	where id=@capitalgroupid_15
end
UPDATE CptCapital 
SET  	 mark	 = @mark_2,
	 name	 = @name_3,
	 barcode	 = @barcode_4,
	 startdate = @startdate,
	 enddate	 = @enddate,	
	 seclevel	 = @seclevel_7,
	 resourceid = @resourceid,
	 sptcount	= @sptcount,	
	 currencyid	 = @currencyid_11,
	 capitalcost	 = @capitalcost_12,
	 startprice	 = @startprice_13,
	 depreendprice	= @depreendprice,
	 capitalspec	= @capitalspec,
	 capitallevel	= @capitallevel,
	 manufacturer	= @manufacturer,
	 manudate      = @manudate,
	 capitaltypeid	 = @capitaltypeid_14,
	 capitalgroupid	 = @capitalgroupid_15,
	 unitid	 = @unitid_16,
	 replacecapitalid	 = @replacecapitalid_18,
	 version	 = @version_19,
	 location	  = @location,
	 remark	 = @remark_21,
	 capitalimageid	 = @capitalimageid_22,
	 depremethod1	 = @depremethod1_23,
	 depremethod2	 = @depremethod2_24,
	 deprestartdate= @deprestartdate,
	 depreenddate  = @depreenddate,
	 customerid	 = @customerid_27,
	 attribute	 = @attribute_28,
	 datefield1	 = @datefield1_31,
	 datefield2	 = @datefield2_32,
	 datefield3	 = @datefield3_33,
	 datefield4	 = @datefield4_34,
	 datefield5	 = @datefield5_35,
	 numberfield1	 = @numberfield1_36,
	 numberfield2	 = @numberfield2_37,
	 numberfield3	 = @numberfield3_38,
	 numberfield4	 = @numberfield4_39,
	 numberfield5	 = @numberfield5_40,
	 textfield1	 = @textfield1_41,
	 textfield2	 = @textfield2_42,
	 textfield3	 = @textfield3_43,
	 textfield4	 = @textfield4_44,
	 textfield5	 = @textfield5_45,
	 tinyintfield1	 = @tinyintfield1_46,
	 tinyintfield2	 = @tinyintfield2_47,
	 tinyintfield3	 = @tinyintfield3_48,
	 tinyintfield4	 = @tinyintfield4_49,
	 tinyintfield5	 = @tinyintfield5_50,
	 lastmoderid	 = @lastmoderid_51,
	 lastmoddate	 = @lastmoddate_52,
	 lastmodtime	 = @lastmodtime_53,
	 relatewfid	= @relatewfid,
	 alertnum	 = @alertnum,
	 fnamark	= @fnamark,
	 isinner	= @isinner
	 
WHERE 
	( id	 = @id_1)


GO



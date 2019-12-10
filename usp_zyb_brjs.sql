if exists(select * from sysobjects where name='usp_zyb_brjs')
	drop proc usp_zyb_brjs  
go
create proc usp_zyb_brjs
	@syxh ut_syxh,
	@jsfs smallint = 2,
	@jsqk smallint = 0,
	@czyh ut_czyh = null,
	@jsje_bsxj numeric(12,2) = 0,
	@skfs_xj ut_dm2 = '1',
	@jsje_bszp numeric(12,2) = 0,
	@skfs_zp ut_dm2 = '2',
	@zhbz ut_zhbz = null,
	@zddm ut_zddm = null,
	@zxlsh ut_lsh = null,
	@jslsh ut_lsh = null,
	@qfdnzhzfje numeric(12,2) = null,
	@qflnzhzfje numeric(12,2) = null,
	@qfxjzfje numeric(12,2) = null,
	@tclnzhzfje numeric(12,2) = null,
	@tcxjzfje numeric(12,2) = null,
	@tczfje numeric(12,2) = null,
	@fjlnzhzfje numeric(12,2) = null,
	@fjxjzfje numeric(12,2) = null,
	@dffjzfje numeric(12,2) = null,
	@dnzhye numeric(12,2) = null,
	@lnzhye numeric(12,2) = null,
	@dfpbz smallint = 0,
	@khyh  ut_mc64=null,
	@zph   varchar(50)=null
	,@ylcardno ut_cardno=''
	,@ylksqxh ut_lsh=''
	,@ylkzxlsh ut_lsh=''
	,@rqbz ut_bz=0
	,@jsrq ut_rq16=null
	--,@mxxh varchar(8000) =null	--明细费用序号列表,以,号分割
	,@mxxh text =null	--明细费用序号列表,以,号分割
	,@jsjein_txj numeric(12,2) = 0.00
	,@jsjein_tzp numeric(12,2) = 0.00
	,@yjjxh	varchar(1000) =null	--预交金序号列表,以,号分割
	,@fpkxh	ut_xh12=null --发票库序号
	,@dbkxh ut_xh12= 0 --代币卡序号
	--,@zpzh  varchar(32)='' --支票账号
	--,@zpdw  ut_mc64= ''  --支票单位
	,@zxgxbgrzf numeric(12,2) = 0.00 --造血干细胞个人支付
    ,@dbjfje	numeric(12,2) = 0.00 
    ,@sfksdm	ut_ksdm=''
as 
/**********
[版本号]4.0.0.0.0
[创建时间]2004.11.13
[作者]王奕
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]病人结算
[功能说明]
	住院病人费用结算，包括在院结算和出院结算
[参数说明]
	@syxh ut_syxh,				首页序号
	@jsfs smallint = 2,			结算方式1=在院，2=出院
	@jsqk smallint = 0,			结算情况0=结算金额，1=结算1，2=执行结算，3=欠款出院
	@czyh ut_czyh = null		操作员号
	@jsje_bsxj numeric(12,2) = 0,	在院结算或欠款结算时追加金额（现金类）
	@skfs_xj ut_dm2 = '0'		收款方式(现金类）
	@jsje_bszp numeric(12,2) = 0,	在院结算或欠款结算时追加金额（支票类）
	@skfs_zp ut_dm2 = '0'		收款方式（支票类）
	@zhbz ut_zhbz = null,		账户标志	
	@zddm ut_zddm = null,		诊断代码
	@zxlsh ut_lsh = null,		中心流水号
	@jslsh ut_lsh = null,		计算流水号
	@qfdnzhzfje numeric(12,2) = null, 	起付段当年账户支付
	@qflnzhzfje numeric(12,2) = null,	起付段历年帐户支付
	@qfxjzfje numeric(12,2) = null,		起付段现金支付
	@tclnzhzfje numeric(12,2) = null,	统筹段历年帐户支付
	@tcxjzfje numeric(12,2) = null,		统筹段现金支付
	@tczfje numeric(12,2) = null,		统筹段统筹支付
	@fjlnzhzfje numeric(12,2) = null,	附加段历年帐户支付
	@fjxjzfje numeric(12,2) = null,		附加段历金支付
	@dffjzfje numeric(12,2) = null		附加段地方附加支付
	@dnzhye numeric(12,2) = null,		当年账户余额
	@lnzhye numeric(12,2) = null,		历年账户余额
	@dfpbz smallint = 0					多发票打印标志0=单发票，1=多发票
	@khyh  ut_mc64=null,		开户银行
	@zph   varchar(50)=null			支票号
--mit ,, 2oo3-o5-o8 ,, 银联卡参数
	,@ylcardno ut_cardno=''		--银联卡卡号
	,@ylksqxh ut_lsh=''		--银联卡新申请序号
	,@ylkzxlsh ut_lsh=''		--银联卡新中心流水号
--tony 2003.09.16	在院结算到日期
	,@rqbz ut_bz=0				0在院结算到当前为止,1在院结算到指定日期
	,@jsrq ut_rq16=null			在院结算日期
	,@mxxh varchar(500) =null	--明细费用序号列表,以,号分割
	,@yjjxh	varchar(1000) =null	--预交金序号列表,以,号分割
	,@dbkxh ut_xh12= 0 --代币卡序号
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
	20030219 增加对欠款病人的处理
	Modify By Koala 2003.03.24 在判断是否有未记帐药品时，增加对自备药的去除处理
	modify by qxh   2003.4.16  增加了开户银行和支票号
	modify by hkh   2003.6.21  结帐补收增加一种方式，原@jsje拆分成@jsje_bsxj和@jsje_bszp；
			   原@skfs拆分成@skfs_xj和@skfs_zp
	2003.09.16 tony 新增在院结算到日期的功能，修改上海医保四期
	2004.1.7 tony 在院结算到日期时，zfje和yhje直接取ZY_BRFYMXK中的zfje和yhje
	2004.2.10 yxp 在院结算的住院天数算法与结算费用一致(在院结算天数按当天一整天计算)
	2004-02-12 yxp add  如果病人费用明细中存在归类科目(大类)不正确的药品则提示
	2004-07-08 Wxp 在出院结算时的判断“是否还有未记账的”改在预结算处判断
	2004-11-07	Koala	合并广州在院单项目结算功能
	2004-12-22 Wxp 增加退费现金和退支票
	2006-12-15 gzy 出院结算增加开关判断是否要做出院审核
	2007-01-30 ozb 在计算zje1 时排除单项目结算的数据
	2007-11-02 ozb	新发票打印模式下，是否打印发票通过存储过程usp_zy_getfpprintflag获得  
	2008-02-28 ozb	修改定额金额的处理，要考虑多次中结，多次取消中结、以及自费药的情况
**********/
set nocount on
declare @ybdm ut_ybdm,		--医保代码
		@now ut_rq16,		--当前时间
		@zfbz smallint,		--比例标志
		@zje ut_money,		--总金额
		@zje1 ut_money,		--已结算总金额
		@zfyje ut_money,	--自费金额
		@zfyje1 ut_money,	--已结算自费金额
		@yhje ut_money,		--优惠金额
		@yhje1 ut_money,	--已结算优惠金额
		@ybje ut_money,		--可用于医保计算的金额
		@ybje1 ut_money,	--已结算可用于医保计算的金额
		@pzlx ut_dm2,		--凭证类型
		@sfje ut_money,		--实收金额
		@sfje1 ut_money,	--已结算实收金额
		@sfje_all ut_money,	--实收金额(包含自费金额)
		@errmsg varchar(50),
		@srbz char(1),		--舍入标志
		@srje ut_money,		--舍入金额
		@sfje2 ut_money,	--舍入后的实收金额
		@xhtemp ut_xh12,
		@fph bigint,			--发票号
		@fpjxh ut_xh12,		--发票卷序号
		@deje ut_money,		--定额金额
		@deje1 ut_money,	--剩余定额金额
		@ryrq ut_rq16,		--入院日期
		@rqrq ut_rq16,		--入区日期
		@cqrq ut_rq16,		--出区日期
		@maxjsrq ut_rq16,	--最大在院结算日期
		@jgbz smallint,		--急观标志0=住院，1=在观，2=出观
		@cardtype ut_dm2,	--卡类型
		@brlx char(1),		--病人类型
		@ybstr varchar(350),	--医保字符串(加长)
		@cardno ut_cardno,		--卡号
		@tsrybz char(1),		--特殊人员标志
		@strybje char(10),		--医保费用总额
		@zyts numeric(10,1),	--住院天数
		@zyts1 numeric(10,1),	--已结算住院天数
		@jsxh ut_xh12,			--结算序号
		@yjlj money,			--押金累计
		@xjlj money,			--现金累计
		@zplj money,			--支票累计
		@print smallint,		--预交金收据打印标志0=不打，1=打印
		@tcljje numeric(12,2),	--统筹累计金额
		@ybjsfs ut_bz,			--医保计算方式
		@qqqklj ut_money       --前期欠款累计
		--tony 2003.09.16 医保四期
		,@flzfje ut_money		--分类自负金额
		,@flzfje1 ut_money		--已结算分类自负金额
		,@strybjsje char(10)	--医保结算范围金额
		,@strzyf char(10)		--住院费
		,@strzlf char(10)		--诊疗费
		,@strzlf1 char(10)		--治疗费
		,@strhlf char(10)		--护理费
		,@strssclf char(10)		--手术材料费
		,@strjcf char(10)		--检查费
		,@strhyf char(10)		--化验费
		,@strspf char(10)		--摄片费
		,@strtsf char(10)		--透视费
		,@strsxf char(10)		--输血费
		,@strsyf char(10)		--输氧费
		,@strxyf char(10)		--西药费
		,@strzcyf char(10)		--中成药费
		,@strcyf char(10)		--中草药费
		,@strqtf char(10)		--其他费
		,@strzfje char(10)		--非医保计算范围金额
		,@zje2 ut_money			--剩余总金额
		,@zfyje2 ut_money		--剩余自费金额
		,@yhje2 ut_money		--剩余优惠金额
		,@flzfje2 ut_money		--剩余分类自负金额
        ,@yjejz smallint		--预交金结转标志 0=不结转，1=结转
		--mit , 广州增加, 单项目结算
		,@strsql varchar(8000)		--执行strsql,mit, 2004-07-22
		,@zyjslb ut_bz			--在院结算类别,mit, 2004-07-22
		,@isztjz ut_bz			--预交金是否中途结转,jjw, 2005-02-19
		,@tsyhje ut_money 		--特殊优惠金额		
		,@tsyhje2 ut_money
		,@spzlx varchar(10) 		--双凭证类型
		,@spzbz char(2)           	--双凭证标志
		,@gbbz ut_bz			--干保标志
		,@gbje ut_money			--干保金额
		,@pzh ut_pzh
		,@ysybzfje ut_money --原始医保自负金额,2005-11-14 干保要求打印干保现金支付金额
		,@gbzfje2 ut_money  --干保金额自费2
		,@dyzfyje ut_money --打印自费药金额 
		--当既有学保又有儿保时打印在发票上的金额
		,@xbzfje ut_money --学保支付金额 
		,@ebzfje ut_money --儿保支付金额 
		,@rqfldm	ut_dm4	--人群分类   04 儿保 05 儿童学保 06 学保
		,@skfs_xjmc ut_name --现金支付方式名称
		,@skfs_zpmc ut_name --支票支付方式名称
		,@patid ut_syxh
		,@tcljybdm varchar(500)  --统筹累计医保集合
		,@nconfigdyms	ut_bz	--打印模式(5212) 0 否 1 是
		,@printjsfp	ut_bz	--打印发票标志	
		,@lcyhje ut_money  --病人发生总的零差优惠金额
		,@lcyhje1 ut_money --病人本次结算的零差优惠金额
		,@lcyhje2 ut_money 	--病人本次结算后剩余的零差优惠金额
		,@nconfigupdatezcbz ut_bz --是否在病人结帐时才更新病人对应床位的占床标志(为否在病人出区时更新)
		,@returnmsg varchar(100) --存储过程返回信息
		,@yhljje ut_money		--优惠累计金额
		,@ebdeje ut_money --儿保定额金额
		,@jfzf_flzfje ut_money ---减负支付的分类自负金额
        ,@srtjfzf_flzfje char(10)--减负
		,@strjf varchar(11) --减负 
        , @ybjfzje ut_money--减负
        ,@brzt     ut_bz   --病人状态
        ,@ybzyts numeric(10,1)
        ,@ybksrq ut_rq8
        ,@ybjsrq ut_rq8
        ,@config5436 char(2)
declare @lastksrq ut_rq16
        ,@spzmc ut_mc32
		,@ksrq ut_rq16
		,@config5235	VARCHAR(2000)	--病人结算需要审核的凭证类型
        ,@config5210    varchar(2)      --公用发票的模式
        ,@config5320 varchar(2)       
		,@config5309 varchar(2) --是否使用多种支付方式
		,@config5369 varchar(2)
		,@config5478 varchar(2)--退支票是否支持退支票总额大于预交金支票总额
 
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0,
	@deje=0, @deje1=0, @zyts=0, @zyts1=0,
	@yjlj=0, @xjlj=0, @zplj=0, @print=0, @tcljje=0,@qqqklj=0
	--tony 2003.09.16 医保四期
	,@flzfje=0,@flzfje1=0,@zje2=0,@zfyje2=0,@yhje2=0,@flzfje2=0
	,@zyjslb=0,@spzlx = '',@spzmc='',@ybjfzje = 0--减负
	,@fph=0,@fpjxh=0,@gbbz=0, @gbje=0,@gbzfje2 = 0,@ysybzfje = 0,@dyzfyje = 0
	,@printjsfp=0,@nconfigdyms=0	--add by ozb 20071111
	,@lcyhje = 0,@lcyhje1 = 0 ,@lcyhje2 = 0, @config5235="", @yhljje = 0,@config5210="",@jfzf_flzfje = 0
	,@ebdeje =0,@config5320='否',@config5309='否',@config5369 = '否',@ybzyts=0,@ybksrq='',@ybjsrq=''
	,@config5478='否'
select @skfs_xjmc = name from YY_ZFFSK nolock where id =@skfs_xj 
select @skfs_zpmc = name from YY_ZFFSK nolock where id =@skfs_zp

DECLARE @selectmx	ut_bz	--是否有选择明细 0 否 1 是
--add by ozb 2007-11-20 处理明细长度超过8000的问题
/*declare @mxtmp	varchar(8000)
declare @npos	int
declare @lastpos	int

select @npos=7900,@lastpos=1,@mxtmp='',@selectmx=0
select @npos=charindex(',',@mxxh,7000)

create table #mxxh_tt(xh	int	primary key (xh))
while @npos>@lastpos
begin
	select @mxtmp=replace(replace(substring(@mxxh,@lastpos+1,@npos-@lastpos-1),'(',''),')','')
	exec('
	insert	into #mxxh_tt (xh)
	select xh from ZY_BRFYMXK  where  xh in ('+@mxtmp+
	') ')
	select @lastpos=@npos
	select @npos=charindex(',',@mxxh,@lastpos+7000)
end
select @mxtmp=replace(replace(substring(@mxxh,@lastpos+1,7000),'(',''),')','')
if @mxtmp<>''
	exec('
		insert	into #mxxh_tt (xh)
		select xh from ZY_BRFYMXK  where  xh in ('+@mxtmp+
		') ')
*/
SELECT @selectmx=0
SELECT @jsxh=xh FROM ZY_BRJSK WHERE syxh=@syxh AND jszt=0 AND jlzt=0
SELECT xh INTO #mxxh_tt FROM ZY_BRFYMXK WHERE dxmjsxh=@jsxh and syxh=@syxh
if (select count(*) from #mxxh_tt)>0 
	select @selectmx=1
--add by ozb 2007-11-20 处理明细长度超过8000的问题

--mit , 2004-07-22 ,如果是选择项目结算,则归入选择日期的在院结算
--if isnull(@mxxh,'')<>'' 
if @selectmx=1
begin
	if @jsfs=2 
	select @jsfs=1,@rqbz=1,@zyjslb=1      --将出院结算标志更新为在院结算
	else
	select @rqbz=1,@zyjslb=1,@ksrq=min(zxrq),@jsrq=max(zxrq) 
		from VW_BRFYMXK a(nolock),#mxxh_tt b 
			where a.syxh=@syxh and a.xh=b.xh	
end

--yxp add 2004-02-12 如果病人费用明细中存在归类科目(大类)不正确的药品则提示
if exists(select 1 from ZY_BRFYMXK (nolock)
	where syxh=@syxh and ltrim(rtrim(isnull(dxmdm,''))) not in (select id from YY_SFDXMK (nolock)) )
begin
	select "F","病人费用明细中存在归类科目(大类)不正确的药品，请检查药品字典设置！"
	return
end

-- add kcs 20160801 by 84703 
if exists(select 1 from ZY_BRFZXXK where syxh = @syxh and jlzt = 0)
begin
    select "F","病人目前处于封账状态,无法结算！"
	return
end

if exists (select * from YY_CONFIG (nolock) where id='5036' and config='是')
	update ZY_BRSYK set cqrq= @now,gxrq=@now where syxh=@syxh and jgbz=1

--add by ozb begin 2007-11-11 打印模式
if exists(select 1 from YY_CONFIG where id='5212' and config='是')
	select @nconfigdyms=1
else
	select @nconfigdyms=0
--add by ozb end 2007-11-11 打印模式

select @config5210=config from YY_CONFIG where id='5210'

--add by gxf begin 2008-9-27 是否在病人结帐时才更新病人对应床位的占床标志(为否在病人出区时更新)。
if exists(select 1 from YY_CONFIG where id='5242' and config='是')
	select @nconfigupdatezcbz=1
else
	select @nconfigupdatezcbz=0
--add by gxf end 2008-9-27 是否在病人结帐时才更新病人对应床位的占床标志(为否在病人出区时更新)。
if exists (select 1 from YY_CONFIG (nolock) where id='5320' and config='是')
  select @config5320='是'

if exists (select 1 from YY_CONFIG where id='5309' and config='是')
  select @config5309='是'
  
if exists (select 1 from YY_CONFIG where id='5369' and config='是')
  select @config5369='是' 
if exists (select 1 from YY_CONFIG where id='5436' and config='是')
    select @config5436='是'
else
    select @config5436='否' 
--    
if exists (select 1 from YY_CONFIG where id='5478' and config='是')
  select @config5478='是'        

if @jsqk in (0,1,2,3)
begin
	select * into #brsyk from ZY_BRSYK where syxh=@syxh and brzt not in (0, 3, 8, 9)
	if @@error<>0 or @@rowcount=0
	begin
		select "F","病人首页信息不存在！"
		return
	end

	select @ybdm=ybdm, @deje=deje, @ryrq=ryrq, @rqrq=rqrq, @cqrq=cqrq, @jgbz=jgbz, @cardtype=cardtype, @brlx=brlx, 
		@zhbz=(case when @jsqk=0 and zhbz<>'' then zhbz else @zhbz end), @cardno=cardno, @jgbz=jgbz, @maxjsrq=ryrq,
		@tcljje=isnull(tcljje,0), @gbbz=gbbz, @pzh=pzh,@brzt=brzt
		from #brsyk
    --用首页库的定额减去已经使用的定额得到本次结算的定额 后面不能再对@deje付值
	--select @deje=@deje-isnull(sum(isnull(deje,0)),0) from ZY_BRJSK where syxh=@syxh and ybjszt=2
	--考虑跨年的情况 mod by ozb 20080721
	select @deje=isnull(deje,0) from ZY_BRJSK where syxh=@syxh and xh=@jsxh
	if isnull(@deje,0)<=0 
		select @deje=0
	--tony 2003.09.16 在院结算到日期
	if @jsfs=1 and @rqbz=0
		select @cqrq=@now
	else if @jsfs=1 and @rqbz=1 and isnull(@cqrq,'')=''--add by l_jj 2012-12-22 单项目出院结算时@jsrq=''
		select @cqrq=@jsrq
		
    --add by l_jj 2014-07-01 出区病人在院结算时zyts不对
    if @jsfs=1 and @rqbz=1 and @brzt in (2,4) and @cqrq>@jsrq
    begin
        select @cqrq=@jsrq
    end		

	select @pzlx=pzlx, @tsrybz=tsrydm, @ybjsfs=jsfs,@rqfldm=rqfldm from YY_YBFLK where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","患者费用类别不正确！"
		return
	end

	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12'  
	and exists(select 1 from BQ_FYQQK where syxh=@syxh and jlzt=0 and qqlx<>2 and zbbz <> 1 
	and (@config5369 = '否' or (@config5369 = '是' and ispreqf <> 1)) ) 
	begin
		select "F","病人尚有药品未发，请先发药再出院！"
		return
	end
	
	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12' 
	and exists(select 1 from BQ_SYCFMXK where syxh=@syxh and jlzt=0 and zbbz <> 1
	and (@config5369 = '否' or (@config5369 = '是' and ispreqf <> 1)) ) 
	begin
		select "F","病人尚有输液药品未发，请先发药再出院！"
		return
	end
	
	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12' and exists(select 1 from BQ_YJQQK where syxh=@syxh and jlzt=0
	and (@config5369 = '否' or (@config5369 = '是' and ispreqf <> 1)) )
	begin
		select "F","病人医技项目未确认，请先确认再出院！"
		return
	end
	SELECT @config5235=LTRIM(RTRIM(config)) FROM YY_CONFIG WHERE id="5235"
	IF @jsfs=2	-- add by gzy in 20061215
	BEGIN        
		IF (SELECT ISNULL(config,"是") FROM YY_CONFIG WHERE id="5224")="否"
		BEGIN
			IF EXISTS(SELECT 1 FROM ZY_BRJSK j WHERE j.syxh=@syxh AND j.shbz IN (0,2) AND j.jlzt=0
				AND EXISTS(SELECT 1 FROM YY_YBFLK WHERE j.ybdm=ybdm
				AND ((CHARINDEX('"'+LTRIM(RTRIM(pzlx))+'"',@config5235)>0) OR (@config5235=""))))
			BEGIN
				SELECT "F","请先进行结算审核然后再结帐!"
				RETURN
			END
		END
	END
	
	if @pzlx='12'
	begin
		select @tsrybz=isnull(substring(@zhbz,4,1),'0')

		--增加干保标志
		if @gbbz=1 and substring(@zhbz,2,1) in ('1','2')
			select @tsrybz='3'

		if @tsrybz='3' and @rqbz=1
		begin
			select "F","干保病人暂不支持选日期结算！"
			return
		end
	end
    --医保病人计算特殊项目限额 add by xxl 20091214  for 要求52586
    if @jsqk in (0)  
    begin  
		select @jsxh=xh from ZY_BRJSK where syxh=@syxh and jszt=0 and jlzt=0 
		
  		exec usp_zyb_brjs_xejs @syxh,@jsxh,@gbbz,@pzlx,@errmsg output   
  		if substring(@errmsg,1,1)='F'   
  		begin  
   			select "F",@errmsg  
   			return  
  		end   
    end  
	--医保病人不支持重复预算！可能造成多次结算
	if exists(select 1 from ZY_BRJSK where syxh=@syxh and ybjszt=1 ) and @pzlx='12' and @jsqk in (0,1)
	begin
		select "F","存在医保结算状态为1的记录，无法再次结算,可能你已经预算了！"
		return
	end

	if exists(select 1 from ZY_BRJSK where syxh=@syxh and ybjszt=0) and @pzlx='12' and @jsqk in (2,3)
	begin
		select "F","请先进行预结算！"
		return
	end
  if @jsqk=0 and @pzlx="12" and exists (select 1 from YY_YBJYMX(nolock) where jsxh=@jsxh and ((ISNULL(zxlsh,'')<>'' and ISNULL(zxlsh,'')<>jslsh) or ybjszt=2))
  begin
    select "F","该记录在医保中心已结算，不能再次结算！"
    return
  end
	--W20080928  增加上海关于flzfje保留3位小数，并重新计算,因为考虑到参数胡乱打开，5241不控制
	-- usp_zyb_recalcjsje @syxh，@jsxh，@error F错误信息
	exec usp_zyb_recalcjsje @syxh,@jsxh,@returnmsg output 
	if substring(@returnmsg,1,1) = 'F'
	begin
		select "F",substring(@returnmsg,2,100)
		return
	end
	if (@pzlx = '12') and exists(select 1 from ZY_BRSYK nolock where syxh = @syxh and isnull(ylxm,'0') in ('3','4','6')) 
       and exists(select 1 from ZY_BRSYK where syxh=@syxh and substring(zhbz,12,1) = '0' )--减负
	begin	                                                                                       ---尿毒症透析																				
		exec usp_zyb_recalcbrfy @syxh,@jsxh,@returnmsg output                                              ---肾移植
		if substring(@returnmsg,1,1) = 'F'
		begin
			select "F",substring(@returnmsg,2,100)
			return
		end
	end
	else
	begin
    if @jsqk=0 and exists (select 1 from ZY_DBBRFYMXK_YSJL where syxh=@syxh and jsxh=@jsxh)
    begin
      update ZY_BRFYMXK set jfbz=1 where syxh=@syxh and jsxh=@jsxh
      if @@error<>0
      begin
        select 'F','更新ZY_BRFYMXK减负标志出错！'
        return
      end
      exec usp_zyb_recalcbrfy @syxh,@jsxh,@returnmsg output
	    if substring(@returnmsg,1,1) = 'F'
	    begin
	      select "F",substring(@returnmsg,2,100)
	      return
	    end      
    end
	end
  if @jsqk=0
  begin
    exec usp_zyb_checkybdata @syxh,@jsxh,@returnmsg output
    if substring(@returnmsg,1,1) = 'F'
    begin
      select "F",substring(@returnmsg,2,100)
      return
    end
  end
	--下面一句计算已经在院结算的部分，但不包含但项目结算的部分
	--zyjslb  在院结算类别,0 正常, 1 单项目
	select @zje1=isnull(sum(zje),0), @zfyje1=isnull(sum(zfyje),0), @yhje1=isnull(sum(yhje),0),
		@sfje1=isnull(sum(zfje-srje),0), @zyts1=isnull(sum(zyts),0), @maxjsrq=isnull(max(jzrq),@maxjsrq),
		@flzfje1=isnull(sum(flzfje),0), 
		@lcyhje1 = isnull(sum(isnull(lcyhje,0)),0) 
		from ZY_BRJSK where syxh=@syxh and jszt=1 and ybjszt=2 and jlzt=0 and zyjslb=0 --add by ozb 20070130 and zyjslb=0

end

select * into #brjsk from ZY_BRJSK where syxh=@syxh and jszt=0 and jlzt=0
if @@rowcount=0 or @@error<>0
begin
	select "F","患者结算库中没有该患者记录！"
	return
end
select @spzlx = a.spzlx ,@spzbz = c.spzbz from ZY_BRJSK a ,ZY_BRXXK b(nolock),YY_YBFLK c  where a.syxh=@syxh and a.jszt=0 and a.jlzt=0 and a.patid = b.patid and a.ybdm = c.ybdm
update ZY_BRJSK set spzlx = @spzlx where syxh=@syxh and jszt=0 and jlzt=0
if  @@error<>0
begin
	select "F","更新患者双凭证类型时错！"
	return
end
-- add by ydj 2005-7-21 增加双凭证信息
if @spzlx<>''
select @spzmc=name from YY_SPZLXK where id=@spzlx and xtbz=1
select @zje=zje, @zfyje=zfyje, @yhje=yhje, @flzfje=flzfje, @jsxh=xh ,@lastksrq=ksrq, 
	@lcyhje=lcyhje from #brjsk

--tony 2003.09.16 在院结算到日期
if @jsqk <> 1
begin
	select dxmdm, dxmmc, xmje, zfje, yhje, flzfje, yeje, lcyhje into #jsmxk	
		from ZY_BRJSMXK where jsxh=@jsxh
	if @@error<>0
	begin
		select "F","计算病人结算明细出错!"
		return
	end
end

--modify by Wang Yi, 2003.09.29, 先判断结算情况，然后再根据结算方式生成临时表
if @jsqk in (0,1,2,3)
begin
	--add by Wang Yi, 2003.09.29, 先创建#fymxk的结构	
	select dxmdm, zje xmje, zfje, yhje, flzfje, zje  yeje,0 lcyhje  into #fymxk	
		from ZY_BRFYMXK where 1=2
	if @@error<>0
	begin
		select "F","创建临时表结构失败!"
		return
	end

	--待结算金额	2004.03.08	zwj
	select dxmdm, zje xmje, zfje, yhje, flzfje, zje yeje,0 lcyhje  into #fymxk1	
		from ZY_BRFYMXK where 1=2

	--tony 2003.09.16 在院结算到日期，
	--W20080928  增加上海关于flzfje保留3位小数，指定保留2位小数，不影响原来操作
	--if @jsfs=1 and isnull(@mxxh,'')<>''
	if (@jsfs=1 and @selectmx=1) --在院按照单项目结算
	begin
		select @strsql='insert into #fymxk '
			+ ' select dxmdm, sum(zje) xmje, round(sum(zfje),2) zfje, '
			+ ' sum(yhje) yhje, round(sum(flzfje),2) flzfje, sum(case when yexh>0 then zje else 0 end) yeje,' 
			+ ' sum(case when isnull(lcjsdj,0) <> 0 then round(ypdj*ypsl/ykxs,2)-round(lcjsdj*ypsl/ykxs,2) else 0 end ) lcyhje'
			+ ' from ZY_BRFYMXK '
			+ ' where syxh=' + convert(varchar(16),@syxh) 
			--+ ' and xh in ' + @mxxh
			+ ' and xh in (select xh from #mxxh_tt) ' + 
			+ ' and jsxh not in(select xh from ZY_BRJSK where syxh=' + convert(varchar(16),@syxh) + ' and ybjszt=2 and jlzt=0 and jszt=1 and zyjslb=1) '
			+ ' group by dxmdm '
		exec(@strsql)
        -----add by sqf 20101122大病减负
		select @ybjfzje = sum(zje - zfje-yhje) from VW_BRFYMXK where  syxh = @syxh 
										and xh in (select xh from #mxxh_tt)
										and jsxh not in(select xh from ZY_BRJSK where syxh = @syxh and  ybjszt=2 and jlzt=0 and jszt=1 and zyjslb=1)
										and isnull(jfbz,'0') = '0'	
	end
	else if @jsfs=1 and @rqbz=1
	begin
		insert into #fymxk
		select dxmdm, sum(zje) xmje, round(sum(zfje),2) zfje, 
			sum(yhje) yhje, round(sum(flzfje),2) flzfje, sum(case when yexh>0 then zje else 0 end) yeje, 
			sum(case when isnull(lcjsdj,0) <> 0 then round(ypdj*ypsl/ykxs,2)-round(lcjsdj*ypsl/ykxs,2) else 0 end ) lcyhje
			from ZY_BRFYMXK 
			where syxh=@syxh and zxrq<=@jsrq 
				and jsxh not in(select xh from ZY_BRJSK where syxh=@syxh and ybjszt=2 and jlzt=0 and jszt=1 and zyjslb=1)
			group by dxmdm
		if not exists(select 1 from #fymxk)
		begin
			select 'F','选择的时间段内没有费用发生'
			return
		end
         -----add by sqf 20101122大病减负
		select @ybjfzje = sum(zje - zfje-yhje) from ZY_BRFYMXK 
			where syxh=@syxh and zxrq<=@jsrq 
				and jsxh not in(select xh from ZY_BRJSK where syxh=@syxh and ybjszt=2 and jlzt=0 and jszt=1 and zyjslb=1)
				and isnull(jfbz,'0') = '0' 
	end
	else
	begin
		--正常结算直接取结算库信息	zwj 2004.03.08
		insert into #fymxk1
		select dxmdm, xmje, zfje,
			yhje, flzfje, yeje
			,isnull(lcyhje,0)
			from ZY_BRJSMXK where jsxh=@jsxh	--update by zwj 2003.12.5	取结算库信息
/*
		select dxmdm, sum(zje) xmje, sum(round(zfdj*ypsl/ykxs,2)) zfje, 
			sum(round(yhdj*dwxs*ypsl/ykxs,2)) yhje, sum(flzfje) flzfje, sum(case when yexh>0 then zje else 0 end) yeje
			from ZY_BRFYMXK where syxh=@syxh group by dxmdm
*/
		select @ybjfzje = sum(zje - zfje-yhje) from ZY_BRFYMXK --减负
			where syxh=@syxh and jsxh=@jsxh
				and isnull(jfbz,'0') = '0' 	
	end
	if @@rowcount=0
	begin
		select "F","患者这段时间内没有发生费用，不用结算！"
		return
	end

	if @jsfs=1 and @selectmx=1 --在院按照单项目结算
	begin
		select @zje2=@zje, @zfyje2=@zfyje, @yhje2=@yhje, @flzfje2=@flzfje, @lcyhje2=@lcyhje
		select @zje=sum(xmje), @zfyje=sum(zfje), @yhje=sum(yhje), @flzfje=sum(flzfje), 
				@lcyhje=sum(isnull(lcyhje,0)) from #fymxk
		select @zje2=@zje2-@zje, @zfyje2=@zfyje2-@zfyje, @yhje2=@yhje2-@yhje, @flzfje2=@flzfje2-@flzfje,
				@lcyhje2=@lcyhje2-@lcyhje
		select @zje1=0, @zfyje1=0, @yhje1=0, @flzfje1=0, @sfje1=0, @lcyhje1=0
	end
	else if @jsfs=1 and @rqbz=1
	begin
		select @zje2=@zje, @zfyje2=@zfyje, @yhje2=@yhje, @flzfje2=@flzfje, @lcyhje2=@lcyhje
		select @zje=sum(xmje)-@zje1, @zfyje=sum(zfje)-@zfyje1, @yhje=sum(yhje)-@yhje1, @flzfje=sum(flzfje)-@flzfje1,
				@lcyhje=sum(lcyhje)-@lcyhje1 from #fymxk
		select @zje2=@zje2-@zje, @zfyje2=@zfyje2-@zfyje, @yhje2=@yhje2-@yhje, @flzfje2=@flzfje2-@flzfje,
				@lcyhje2=@lcyhje2-@lcyhje

	end
	else
	begin
		--正常结算置剩余金额和中途结算金额为0，不参与计算	zwj 2004.03.08
		select @zje2=0, @zfyje2=0, @yhje2=0, @flzfje2=0, @lcyhje2=0
		select @zje1=0, @zfyje1=0, @yhje1=0, @flzfje1=0, @sfje1=0, @lcyhje1=0
	end

	if @jsfs=1 and @selectmx=1 --在院按照单项目结算
	begin
		--mit , 2004-07-22
		insert into #fymxk1
		select a.dxmdm, a.xmje, a.zfje, a.yhje, a.flzfje, a.yeje, a.lcyhje	
		from #fymxk a
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end
	end
	else if @jsfs=1 and @rqbz=1
	begin
		select dxmdm, sum(xmje) xmje, sum(zfje) zfje, sum(yhje) yhje, sum(flzfje) flzfje, sum(yeje) yeje, sum(isnull(lcyhje,0)) lcyhje
			into #jsmxk1
			from ZY_BRJSMXK a where exists(select 1 from ZY_BRJSK b where b.syxh=@syxh and b.jszt=1 and b.ybjszt=2 and b.jlzt=0 and a.jsxh=b.xh and zyjslb=0)
			group by a.dxmdm
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end
		 
    --sql2012 yfq
    insert into #fymxk1
    select a.dxmdm, a.xmje-isnull(b.xmje,0) xmje, a.zfje-isnull(b.zfje,0) zfje, a.yhje-isnull(b.yhje,0) yhje,
				a.flzfje-isnull(b.flzfje,0) flzfje, a.yeje-isnull(b.yeje,0) yeje, 
				a.lcyhje-isnull(b.lcyhje,0) lcyhje	
		from #fymxk a
    left join #jsmxk1 b on a.dxmdm=b.dxmdm
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end

	end
end

if @zje<0
begin
	select "F","患者费用总额小于等于零，无法结算！"
	return
end

if @jsqk in (0,1,2,3)
begin
	if isnull(@yjjxh,'')=''
	begin
		select @yjlj=isnull(sum(jje-dje),0) from ZYB_BRYJK where syxh=@syxh and jsxh=@jsxh
	--	select @xjlj=isnull(sum(jje-dje),0) from ZYB_BRYJK where syxh=@syxh and jsxh=@jsxh and zffs='1'
	--	select @zplj=isnull(sum(jje-dje),0) from ZYB_BRYJK where syxh=@syxh and jsxh=@jsxh and zffs<>'1'
		select @xjlj=isnull(sum(jje-dje),0) from ZYB_BRYJK a,YY_ZFFSK b where a.syxh=@syxh and a.jsxh=@jsxh and a.zffs=b.id and substring(b.memo,1,1)='1'
		select @zplj=isnull(sum(jje-dje),0) from ZYB_BRYJK a,YY_ZFFSK b where a.syxh=@syxh and a.jsxh=@jsxh and a.zffs=b.id and substring(b.memo,1,1)<>'1'
	end
	else
	begin	--mit ,2004-7-24 , 选择预交金预算
		create table #xzyjjk
		(
			xh ut_xh12 not null,
			jje ut_money not null,
			dje ut_money not null,
			syxh ut_syxh not null,
			jsxh ut_xh12 null,
			zffs ut_dm2 not null
		)
		create table #wxzyjjk
		(
			xh ut_xh12 not null,
			jje ut_money not null,
			dje ut_money not null,
			syxh ut_syxh not null,
			jsxh ut_xh12 null,
			zffs ut_dm2 not null
		)
		select @strsql=' insert into #xzyjjk '
			+ ' select xh,jje,dje,syxh,jsxh,zffs from ZYB_BRYJK '
			+ ' where xh in'+ @yjjxh
		exec(@strsql)

		select @yjlj=isnull(sum(jje-dje),0) from #xzyjjk where syxh=@syxh and jsxh=@jsxh
		select @xjlj=isnull(sum(jje-dje),0) from #xzyjjk a,YY_ZFFSK b where a.syxh=@syxh and a.jsxh=@jsxh and a.zffs=b.id and substring(b.memo,1,1)='1'
		select @zplj=isnull(sum(jje-dje),0) from #xzyjjk a,YY_ZFFSK b where a.syxh=@syxh and a.jsxh=@jsxh and a.zffs=b.id and substring(b.memo,1,1)<>'1'

		select @strsql=' insert into #wxzyjjk '
			+ ' select xh,jje,dje,syxh,jsxh,zffs from ZYB_BRYJK '
			+ ' where xh not in'+ @yjjxh
			+ ' and czlb in (0,1,9,3,4) '
			+ ' and syxh=' + convert(varchar(16),@syxh)
			+ ' and jsxh=' + convert(varchar(16),@jsxh)
			+ ' and jlzt in (0,1) and (jje <> 0 or dje <> 0) '
		exec(@strsql)
	end
end

if @jsqk=0
begin
	declare @ts1 numeric(4,1),
		@ts2 numeric(4,1),
		@ts3 numeric(4,1),
		@ts4 numeric(4,1)

	select @ts1=0, @ts2=0, @ts3=0, @ts4=0
	select @ts1=convert(numeric(4,1),config) from YY_CONFIG (nolock) where id='5010'
	select @ts2=convert(numeric(4,1),config) from YY_CONFIG (nolock) where id='5011'
	select @ts3=convert(numeric(4,1),config) from YY_CONFIG (nolock) where id='5012'
	select @ts4=convert(numeric(4,1),config) from YY_CONFIG (nolock) where id='5013'

	--yxp add 2004.2.10 在院与出院结算的住院天数算法区分
	if @jsfs=1 and @selectmx<>1
		select @zyts=datediff(day,substring(@ryrq,1,8),substring(@cqrq,1,8))
		+(case when substring(@ryrq,9,2)>='12' then @ts2 else @ts1 end)--在院结算天数按当天一整天计算
	else
		select @zyts=datediff(day,substring(@ryrq,1,8),substring(@cqrq,1,8))
		+(case when substring(@ryrq,9,2)>='12' then @ts2 else @ts1 end)
		+(case when substring(@cqrq,9,2)>='12' then @ts4-1 else @ts3-1 end)

	select @zyts=@zyts-@zyts1

	if @zyts<0 
		select @zyts=0

	if exists (select * from YY_CONFIG (nolock) where id='6384' and config='是') 
			and substring(@rqrq,1,8)=substring(@cqrq,1,8)
		select @zyts=0.5
	
	if @pzlx='12'
	begin
		select @ybje=@zje-@zfyje-@yhje
		select @strybje=str(@ybje,10,2)
		select @strybje=replicate('0',10-datalength(ltrim(rtrim(@strybje))))+ltrim(rtrim(@strybje))

		--tony 2003.09.16 医保四期
		select @strybjsje=str(@ybje+@flzfje,10,2)
		select @strzfje=str(@zfyje-@flzfje,10,2)
        --add by sqf 20101103医保四期升级--减负
		select @strjf = '00000000.00'
		if exists(select 1 from ZY_BRSYK where syxh = @syxh and isnull(ylxm,'0') in ('3','4','6','A'))
			and exists(select 1 from ZY_BRSYK where syxh=@syxh and substring(zhbz,12,1) = '0' )
		begin
			declare @jfbz varchar(2),@msg varchar(300)
			exec usp_yy_yb_getylxm '1',@syxh,'',@jfbz output ,@msg output
			if @msg <>'R'
			begin
				if @jfbz = '0'
					select @strjf = '00000000.00'
				select @strjf = @jfbz+replicate('0',10-datalength(ltrim(rtrim(str(@ybjfzje,10,2)))))+ltrim(rtrim(str(@ybjfzje,10,2)))
				if exists(select 1 from ZY_BRJSK_DBJFJE where jsxh = @jsxh and syxh = @syxh ) 
				delete from  ZY_BRJSK_DBJFJE where jsxh = @jsxh and syxh = @syxh
				insert into ZY_BRJSK_DBJFJE(jsxh,syxh,jsczyh,jsrq,zje,jfje,jfbz)
				select @jsxh,@syxh,@czyh, @now,@zje,@ybjfzje,@jfbz  			
			end
		end
		if @jsfs=1 and @rqbz=1
		begin
			select @strzyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='01')
			select @strzlf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='02')
			select @strzlf1=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='03')
			select @strhlf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='04')
			select @strssclf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='05')
			select @strjcf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='06')
			select @strhyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='07')
			select @strspf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='08')
			select @strtsf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='09')
			select @strsxf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='10')
			select @strsyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='11')
			select @strxyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='12')
			select @strzcyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='13')
			select @strcyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='14')
			select @strqtf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #fymxk1 a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='15')
		end
		else begin
			select @strzyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='01')
			select @strzlf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='02')
			select @strzlf1=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='03')
			select @strhlf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='04')
			select @strssclf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='05')
			select @strjcf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='06')
			select @strhyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='07')
			select @strspf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='08')
			select @strtsf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='09')
			select @strsxf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='10')
			select @strsyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='11')
			select @strxyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='12')
			select @strzcyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='13')
			select @strcyf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='14')
			select @strqtf=str(isnull(sum(xmje-zfje+flzfje-yhje),0),10,2) from #jsmxk a where exists(select 1 from YY_SFDXMK b where a.dxmdm=b.id and b.zyyb_id='15')
		end
		select @strybjsje=replicate('0',10-datalength(ltrim(rtrim(@strybjsje))))+ltrim(rtrim(@strybjsje))
		select @strzfje=replicate('0',10-datalength(ltrim(rtrim(@strzfje))))+ltrim(rtrim(@strzfje))
		select @strzyf=replicate('0',10-datalength(ltrim(rtrim(@strzyf))))+ltrim(rtrim(@strzyf))
		select @strzlf=replicate('0',10-datalength(ltrim(rtrim(@strzlf))))+ltrim(rtrim(@strzlf))
		select @strzlf1=replicate('0',10-datalength(ltrim(rtrim(@strzlf1))))+ltrim(rtrim(@strzlf1))
		select @strhlf=replicate('0',10-datalength(ltrim(rtrim(@strhlf))))+ltrim(rtrim(@strhlf))
		select @strssclf=replicate('0',10-datalength(ltrim(rtrim(@strssclf))))+ltrim(rtrim(@strssclf))
		select @strjcf=replicate('0',10-datalength(ltrim(rtrim(@strjcf))))+ltrim(rtrim(@strjcf))
		select @strhyf=replicate('0',10-datalength(ltrim(rtrim(@strhyf))))+ltrim(rtrim(@strhyf))
		select @strspf=replicate('0',10-datalength(ltrim(rtrim(@strspf))))+ltrim(rtrim(@strspf))
		select @strtsf=replicate('0',10-datalength(ltrim(rtrim(@strtsf))))+ltrim(rtrim(@strtsf))
		select @strsxf=replicate('0',10-datalength(ltrim(rtrim(@strsxf))))+ltrim(rtrim(@strsxf))
		select @strsyf=replicate('0',10-datalength(ltrim(rtrim(@strsyf))))+ltrim(rtrim(@strsyf))
		select @strxyf=replicate('0',10-datalength(ltrim(rtrim(@strxyf))))+ltrim(rtrim(@strxyf))
		select @strzcyf=replicate('0',10-datalength(ltrim(rtrim(@strzcyf))))+ltrim(rtrim(@strzcyf))
		select @strcyf=replicate('0',10-datalength(ltrim(rtrim(@strcyf))))+ltrim(rtrim(@strcyf))
		select @strqtf=replicate('0',10-datalength(ltrim(rtrim(@strqtf))))+ltrim(rtrim(@strqtf))

		if @cardtype='1'
			select @ybstr='0'+convert(char(28),@cardno)+replicate(' ',35)
		else 
			select @ybstr='1'+replicate(' ',63)

		if @jsfs=1
			select @ybstr=substring(@ybstr,1,64)+'1'
		else
			select @ybstr=substring(@ybstr,1,64)+'0'
		if @config5436='是'
		begin	
	        --医保病人单独计算计算住院天数,计算结果可能与HIS内住院天数不同
	        --有过中途结算的开始日期加一秒
	        if exists (select 1 from ZY_BRJSK(nolock) where syxh=@syxh and jszt=1 and ybjszt=2 and jlzt=0)
	            select @ybksrq=convert(char(8),dateadd(ss,1,substring(ksrq,1,8)+' '+substring(ksrq,9,8)),112) from #brjsk
	        else
	            select @ybksrq=substring(ksrq,1,8) from #brjsk
	        --结算日期，如果在原结算到日期为当前选择结算日期,否则为当前日期
	        if @jsfs=1 and @rqbz=1
	            select @ybjsrq=substring(@jsrq,1,8)
	        else
	            select @ybjsrq=substring(@now,1,8)
	        select @ybzyts=datediff(day,@ybksrq,@ybjsrq)
	    end
	    else
	    begin
	        if substring(@zhbz,12,1)='2' and exists (select 1 from ZY_BRJSK(nolock) where syxh=@syxh and jszt=1 and ybjszt=2 and jlzt=0)
            begin
                select @ybksrq=convert(char(8),dateadd(ss,1,substring(ksrq,1,8)+' '+substring(ksrq,9,8)),112) from #brjsk
            end
            else
		        select @ybksrq=substring(ksrq,1,8) from #brjsk
		    select @ybjsrq=case when @jsfs=1 and @rqbz=1 then substring(@jsrq,1,8) else substring(@now,1,8) end
	        select @ybzyts=@zyts    
	    end
		if @jsfs=1
		    select @ybstr=@ybstr+'1'
		else
		    select @ybstr=@ybstr+'0'
		select @ybstr=substring(@ybstr,1,65)+@ybksrq
		select @ybstr=substring(@ybstr,1,73)+@ybjsrq
						
		select @ybstr=substring(@ybstr,1,81)+replicate('0',6-len(ltrim(rtrim(str(@ybzyts,6,1)))))
			+ltrim(rtrim(str(@ybzyts,6,1)))+convert(char(5),isnull(b.ybks_id,'E'))
			+convert(char(16),a.blh)+convert(char(7),isnull(a.zddm,''))+@tsrybz+@brlx+@strybje
			+@strybjsje+@strzyf+@strzlf+@strzlf1+@strhlf+@strssclf+@strjcf+@strhyf+@strspf+@strtsf+@strsxf+@strsyf
			+@strxyf+@strzcyf+@strcyf+@strqtf+@strzfje
			from #brsyk a, YY_KSBMK b (nolock) 
			where a.syxh=@syxh and a.ksdm=b.id
        if @config5436='否' and @jgbz in (1,2)
            select @ybstr=substring(@ybstr,1,64)+substring(@ybstr,66,255)
		---add by sqf 减负修改
		select @ybstr = @ybstr +@strjf
	end
	else begin
		--select @ybje=@zje-@zfyje-@yhje+@zje1-@zfyje1-@yhje1
		select @ybje=@zje-@zfyje-@yhje

		/*取得实收金额*/
        --wxp 20100901上海儿保计算新规则修改
		if exists(select 1 from YY_CONFIG where id = '5275' and charindex(ltrim(rtrim(@ybdm)),config) > 0)
        begin
            select @ebdeje = @deje
            select @deje = 0 
        end
		execute usp_yy_ybjs @ybdm,1,@ybje,0,@errmsg output,@deje,@tcljje,@ybjsfs
		if @errmsg like "F%"
		begin
			select "F",substring(@errmsg,2,49)
			return
		end
		else begin
			select @sfje=convert(numeric(10,2),substring(@errmsg,2,11)) 
			if @ybje <= (@ebdeje+@sfje)
				select @sfje = @ybje
			else
				select @sfje = @sfje+@ebdeje
        end

		/*
		select @sfje_all=@sfje-(@sfje1-@zfyje1)+@zfyje
		*/

		--mit, 2oo4-o7-23 , 如果是只对当前的费用明细进行计算,不用减去以往的在院结算信息
		--if isnull(@mxxh,'')<>''
		if @selectmx=1
			select @sfje_all=@sfje+@zfyje
		else
		begin
			--select @sfje_all=@sfje-(@sfje1-@zfyje1)+@zfyje
			select @sfje_all=@sfje+@zfyje
		end

		select @srbz=config from YY_CONFIG (nolock) where id='5007'
		if @@error<>0 or @@rowcount=0
			select @srbz='0'

		if @srbz='5'
			select @sfje2=round(@sfje_all, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje_all,1,@sfje2 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje_all

		select @srje=@sfje2-@sfje_all
	end

	begin tran
	
	if exists(select 1 from ZY_BRJSJEK where jsxh=@jsxh)
	begin
		delete ZY_BRJSJEK where jsxh=@jsxh
		if @@error<>0
		begin
			rollback tran
			select "F","更新住院结算金额库出错！"
			return		
		end
	end   
	update ZY_BRJSK set zfje=@sfje2, srje=@srje, zyts=@zyts, jsrq=@now, jsczyh=@czyh, zhbz=@zhbz,sfksdm=@sfksdm--,ybzyts=isnull(@ybzyts,@zyts)
		where syxh=@syxh and xh=@jsxh
	if @@error<>0
	begin
		rollback tran
		select "F","更新住院结算库出错！"
		return
	end

	commit tran
	if (select config from YY_CONFIG (nolock) where id='5023')='是'
	begin
	    if exists (select 1 from YY_CONFIG(nolock) where id='5544' and config='是')
	        and exists (select 1 from #fymxk1 where yeje<>0)
	    begin
			select "T",@zje,@sfje2,@ybje,@xjlj,@zplj,substring(@ybstr,1,255) fpxmdm,@yhje,0 ord,@maxjsrq,@cqrq,
					substring(@ybstr,256,255),@jsxh,@gbbz,@pzh, @zje-@lcyhje as lczje	,@lcyhje
			union all
			select b.zyfp_mc fpxmmc,sum(a.xmje-a.yeje),sum(a.zfje-a.yeje-a.flzfje),0,0,0,b.zyfp_id fpxmdm,
					sum(a.yhje),1 ord,'','','',0, 0 ,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where a.jsxh=@jsxh and xmje-yeje<>0 group by fpxmmc, fpxmdm
				where a.xmje-a.yeje<>0 and a.dxmdm = b.id group by b.zyfp_mc, b.zyfp_id
			union all
			select '婴儿费',sum(a.yeje),sum(a.yeje),0,0,0,'' fpxmdm,0,2 ord,'','','',0, 0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0 group by fpxmmc, fpxmdm
				where a.yeje<>0 and a.dxmdm = b.id
			order by ord, fpxmdm
		end
		else
		begin
		    select "T",@zje,@sfje2,@ybje,@xjlj,@zplj,substring(@ybstr,1,255) fpxmdm,@yhje,0 ord,@maxjsrq,@cqrq,
				substring(@ybstr,256,255),@jsxh,@gbbz,@pzh, @zje-@lcyhje as lczje	,@lcyhje
			union all
			select b.zyfp_mc fpxmmc,sum(a.xmje-a.yeje),sum(a.zfje-a.yeje-a.flzfje),0,0,0,b.zyfp_id fpxmdm,
					sum(a.yhje),1 ord,'','','',0, 0 ,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where a.jsxh=@jsxh and xmje-yeje<>0 group by fpxmmc, fpxmdm
				where a.xmje-a.yeje<>0 and a.dxmdm = b.id group by b.zyfp_mc, b.zyfp_id
			union all
			select '婴儿'+b.zyfp_mc,sum(a.yeje),sum(a.yeje),0,0,0,b.zyfp_id fpxmdm,0,2 ord,'','','',0, 0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0 group by fpxmmc, fpxmdm
				where a.yeje<>0 and a.dxmdm = b.id group by b.zyfp_mc, b.zyfp_id
			order by ord, fpxmdm
		end
	end
	else 
	begin
	    if exists (select 1 from YY_CONFIG(nolock) where id='5544' and config='是')
	        and exists (select 1 from #fymxk1 where yeje<>0)
	    begin
	        select "T",@zje,@sfje2,@ybje,@xjlj,@zplj,substring(@ybstr,1,255) dxmdm,@yhje,0 ord,@maxjsrq,@cqrq,
					substring(@ybstr,256,255),@jsxh,@gbbz,@pzh, @zje-@lcyhje as lczje,@lcyhje
			union all
			select b.name dxmmc,a.xmje-a.yeje,a.zfje-a.yeje-a.flzfje,0,0,0,a.dxmdm,a.yhje,1 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and xmje-yeje<>0
				where a.xmje-a.yeje<>0 and a.dxmdm = b.id
			union all
			select '婴儿费',sum(a.yeje),sum(a.yeje),0,0,0,'',0,2 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0
				where a.yeje<>0 and a.dxmdm = b.id
			union all
			select '合计',sum(a.xmje),sum(a.zfje-a.flzfje),0,0,0,'ZZ',sum(a.yhje),1 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
				where a.dxmdm = b.id
			order by ord, dxmdm
	    end
	    else
	    begin 
			select "T",@zje,@sfje2,@ybje,@xjlj,@zplj,substring(@ybstr,1,255) dxmdm,@yhje,0 ord,@maxjsrq,@cqrq,
				substring(@ybstr,256,255),@jsxh,@gbbz,@pzh, @zje-@lcyhje as lczje,@lcyhje
			union all
			select b.name dxmmc,a.xmje-a.yeje,a.zfje-a.yeje-a.flzfje,0,0,0,a.dxmdm,a.yhje,1 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and xmje-yeje<>0
				where a.xmje-a.yeje<>0 and a.dxmdm = b.id
			union all
			select '婴儿'+b.name,a.yeje,a.yeje,0,0,0,a.dxmdm,0,2 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0
				where a.yeje<>0 and a.dxmdm = b.id
			union all
			select '合计',sum(a.xmje),sum(a.zfje-a.flzfje),0,0,0,'ZZ',sum(a.yhje),1 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
				where a.dxmdm = b.id
			order by ord, dxmdm
		end
	end
	return
end
else if @jsqk=1
begin
	select @sfje=@qfxjzfje+@tcxjzfje+@fjxjzfje
	select @sfje_all=@sfje+@zfyje

	select @srbz=config from YY_CONFIG (nolock) where id='5007'
	if @@error<>0 or @@rowcount=0
		select @srbz='0'

	if @srbz='5'
		select @sfje2=round(@sfje_all, 1)
	else if @srbz='6'
		exec usp_yy_wslr @sfje_all,1,@sfje2 output
	else if @srbz>='1' and @srbz<='9'
		exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz
	else
		select @sfje2=@sfje_all

	select @srje=@sfje2-@sfje_all

	begin tran
	update ZY_BRJSK set zfje=@sfje2, srje=@srje, jsrq=@now, jsczyh=@czyh, zhbz=@zhbz, zddm=@zddm,
		dnzhye=@dnzhye, lnzhye=@lnzhye, jslsh=@jslsh, ybjszt=1,sfksdm=@sfksdm
		where syxh=@syxh and xh=@jsxh
	if @@rowcount=0 or @@error<>0
	begin
		rollback tran
		select "F","更新住院结算库出错！"
		return		
	end

	delete ZY_BRJSJEK where jsxh=@jsxh
	if @@error<>0
	begin
		rollback tran
		select "F","更新住院结算金额库出错！"
		return		
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '01', '起付段当年账户支付', @qfdnzhzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '02', '起付段历年帐户支付', @qflnzhzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '03', '起付段现金支付', @qfxjzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '04', '统筹段历年帐户支付', @tclnzhzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '05', '统筹段现金支付', @tcxjzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '06', '统筹段统筹支付', @tczfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '07', '附加段历年帐户支付', @fjlnzhzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '08', '附加段现金支付', @fjxjzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '09', '附加段地方附加支付', @dffjzfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end
----add by sqf 20101103
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '10', '造血干细胞个人自负', @zxgxbgrzf, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '11', '大病减负金额', @dbjfje, null)
	if @@error<>0
	begin
		select "F","保存结算1信息出错！"
		rollback tran
		return
	end
	commit tran
	select "T",@sfje2
	return
end
else begin
	--处理预交金
	--定额金额已经在前面计算过，不能直接取结算库的定额金额
	--select @sfje2=zfje-gbje, @deje=deje, @srje=srje,@isztjz=isnull(isztjz,0)
	select @sfje2=zfje-gbje,  @srje=srje,@isztjz=isnull(isztjz,0),@ybje=zje-zfyje-yhje
		,@tsyhje = tsyhje, @gbje=gbje,@gbbz = gbbz, @tsyhje2 = isnull(tsyhje2,0)
		from #brjsk
	
	--if @deje>@sfje2-@srje
	--	select @deje1=@deje-@sfje2+@srje
	--else
	--	select @deje1=0
	if @deje>@ybje
		select @deje1=@deje-@ybje
	else
		select @deje1=0

	if exists (select 1 from ZY_BRSYK a,YY_YBFLK b where a.syxh = @syxh and a.ybdm =b.ybdm 
				and b.spzbz = '2')  -- 双凭证标志 0 无 1 邮电优惠 2 儿保后学保
	begin
		select @ebzfje = je from ZY_BRJSJEK where jsxh = @jsxh and lx = '25'
		select @xbzfje = je from ZY_BRJSJEK where jsxh = @jsxh and lx = '26'
	end
	if @rqfldm='04' --儿保
		select @ebzfje=(case when @jsfs=1 and @rqbz=1 then @zje else zje end)+srje-
               (case when @jsfs=1 and @rqbz=1 then @yhje else yhje end)
               -zfje  from ZY_BRJSK nolock where syxh=@syxh and xh=@jsxh
	if @rqfldm='06' --学保
		select @xbzfje=(case when @jsfs=1 and @rqbz=1 then @zje else zje end)+srje-
               (case when @jsfs=1 and @rqbz=1 then @yhje else yhje end)
               -zfje  from ZY_BRJSK nolock where syxh=@syxh and xh=@jsxh
	select @ebzfje = isnull(@ebzfje,0),@xbzfje = isnull(@xbzfje,0)
	--add by ozb 20080731 增加保存儿保学保基金支付，方便新发票打印
	if not exists(select 1 from ZY_BRJSJEK where jsxh = @jsxh and lx = '25')
	begin
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, '25', '(儿保学保)少儿住院基金支付', @ebzfje, null)
		if @@error<>0
		begin
			select "F","保存结算1信息出错！"
			rollback tran
			return
		end
	end
	if not exists(select 1 from ZY_BRJSJEK where jsxh = @jsxh and lx = '26')
	begin
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, '26', '(儿保学保)少儿学生医疗保障支付', @xbzfje, null)
		if @@error<>0
		begin
			select "F","保存结算1信息出错！"
			rollback tran
			return
		end
	end

	if (select config from YY_CONFIG (nolock) where id='5029')='否'
	begin
--		if @jsfs=1 and @yjlj+@jsje<@sfje2
		if @jsfs=1 and (@yjlj + @jsje_bsxj + @jsje_bszp) <@sfje2
		begin
			select "F","在院结算预交金不足，请先补足预交金再进行在院结算！"
			return
		end
	
		if @jsqk=3 and @jsfs=1
		begin
			select "F","在院结算不允许欠款！"
			return
		end
	end

--	if @jsqk=3 and @yjlj+@jsje>=@sfje2
  if @config5320='否'
  begin
	  if @jsqk=3 and (@yjlj + @jsje_bsxj + @jsje_bszp) >=@sfje2
	  begin
		  select "F","患者支付金额大于应付金额，请用正常结算出院！"
		  return
	  end
  end

	declare @jsje_xj ut_money,	--退款金额（现金）
			@jsje_zp ut_money,	--退款金额（支票）
			@yje	 ut_money,	--押金余额
			@czym ut_mc64,		--操作员名
			@qkbz smallint,		--欠款标志
			@qkje ut_money,		--欠款金额
			@hzxh ut_xh12,		--汇总序号
			@fph1 bigint,			--发票号
			@maxxh ut_xh12		--最大的ZY_BRFYMXK.xh
			,@jsje_xjtmp ut_money	--退款金额暂存（现金）
			,@jsje_zptmp ut_money	--退款金额暂存（支票）
			 
	select @czym=name from czryk where id=@czyh
	select @jsje_xj=0, @jsje_zp=0, @yje=@yjlj, @qkbz=0, @qkje=0,@fph1=0

	--出院结算
	if @config5309='否'
	begin
		if @jsfs=2 and @jsqk=2
		begin
	    /*  if @sfje2-@yjlj>=0
				select @jsje=@sfje2-@yjlj
			else begin
				select @jsje=0
				if @zplj>=@sfje2
					select @jsje_zp=@zplj-@sfje2, @jsje_xj=@xjlj
				else
					select @jsje_zp=0, @jsje_xj=@yjlj-@sfje2
			end
		*/

			if @sfje2 - @yjlj < 0
			begin			
				select @jsje_bsxj = 0,@jsje_bszp = 0
				if @zplj>=@sfje2
					select @jsje_zp=@zplj-@sfje2, @jsje_xj=@xjlj
				else
					select @jsje_zp=0, @jsje_xj=@yjlj-@sfje2
					--===========================出院结算退款重算begin==================
			    if @config5478 = '是'
			    begin
		            select @jsje_xjtmp=tkje,@skfs_xj=zffs From ZYB_BRTKZCK where jsxh =@jsxh and tkfs=0
		            select @jsje_xjtmp=ISNULL(@jsje_xjtmp,0)
		            select @jsje_zptmp=tkje,@skfs_zp=zffs From ZYB_BRTKZCK where jsxh =@jsxh and tkfs=1	
		            select @jsje_zptmp=ISNULL(@jsje_zptmp,0)
		            
                    if (@jsje_zp+@jsje_xj)<>(@jsje_xjtmp+@jsje_zptmp)
                    begin
                        select 'F',"重算退金额不相等，请重新录入退金额结算"
                        return
                    end	
                    else
                    begin
                        select @jsje_xj=@jsje_xjtmp,@jsje_zp=@jsje_zptmp
                    end
			    end
			    --================出院结算退款重算end==========================
			end
			else
			begin
				--add by ozb 20080630 检查预算是否错误，如果预算错误,直接通过后台计算收退款
				if abs((@jsje_bsxj+@jsje_bszp)-(@jsjein_txj+@jsjein_tzp)-(@sfje2 - @yjlj))>1
				begin
					select @jsje_xj = @jsjein_txj,@jsje_zp = @jsjein_tzp
					if @jsje_bsxj>0
						select @jsje_bsxj=(@sfje2 - @yjlj)-(@jsje_bszp-(@jsjein_txj+@jsjein_tzp))
					else
						select @jsje_bszp=(@sfje2 - @yjlj)-(@jsje_bsxj-(@jsjein_txj+@jsjein_tzp))
					if @jsje_bsxj<0
						select @jsje_xj=@jsjein_txj-@jsje_bsxj

					if @jsje_bszp<0
						select @jsje_zp=@jsjein_tzp-@jsje_bszp
					
				end
			end
			if (@jsjein_txj+@jsjein_tzp) = (@jsje_zp+@jsje_xj)
			begin
				select @jsje_xj = @jsjein_txj,@jsje_zp = @jsjein_tzp
			end 
		end

		--在院结算
		if @jsfs=1 and @jsqk=2
		begin
	--		select @xjlj=@xjlj+@jsje, @yjlj=@yjlj+@jsje
			select @xjlj=@xjlj+@jsje_bsxj, @zplj = @zplj + @jsje_bszp ,@yjlj=@yjlj+@jsje_bsxj +@jsje_bszp
			if @zplj>=@sfje2
				select @jsje_zp=@zplj-@sfje2, @jsje_xj=@xjlj
			else
				select @jsje_zp=0, @jsje_xj=@yjlj-@sfje2
			if (@jsjein_txj+@jsjein_tzp) = (@jsje_zp+@jsje_xj)
			begin
				select @jsje_xj = @jsjein_txj,@jsje_zp = @jsjein_tzp
			end
		end
    end
	if @jsqk=3
--		select @qkbz=1, @qkje=@sfje2-@yjlj-@jsje
		select @qkbz=1, @qkje=@sfje2-@yjlj-@jsje_bsxj-@jsje_bszp --@config5320为是的情况下qkje有正有负,正的是结存结算,负的是结存结算

	--处理病人费用月汇总
	if @jsqk=3
--		select @yjlj=@yjlj+@jsje
		select @yjlj=@yjlj+@jsje_bsxj + @jsje_bszp
	else
		select @yjlj=@sfje2

	select * into #brfyyhz from ZY_BRFYYHZ where syxh=@syxh and jsxh=@jsxh and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select "F","住院病人当前费用月汇总记录不存在！"
		return
	end
	
	select dxmdm, sum(xmje) xmje, sum(zfje) zfje, sum(yhje) yhje, sum(isnull(lcyhje,0)) lcyhje into #hzmxk
		from ZY_BRFYYMX a where exists(select 1 from ZY_BRFYYHZ b where b.syxh=@syxh 
		and b.jsxh=@jsxh and b.jlzt>0 and a.hzxh=b.xh)
		group by dxmdm
	if @@error<>0
	begin
		select "F","计算病人费用月明细出错!"
		return
	end

-- 	select dxmdm, dxmmc, xmje, zfje, yhje into #jsmxk
-- 		from ZY_BRJSMXK where jsxh=@jsxh
-- 	if @@error<>0
-- 	begin
-- 		select "F","计算病人费用月明细出错!"
-- 		return
-- 	end

	--tony 2003.09.16 在院结算到日期
	if @jsfs=1 and @rqbz=1
	begin
		--在院结算选日期后剩余的结算明细 
    --sql2012 yfq
    select a.dxmdm, a.xmje-isnull(b.xmje,0) xmje, a.zfje-isnull(b.zfje,0) zfje, a.yhje-isnull(b.yhje,0) yhje,
				a.flzfje-isnull(b.flzfje,0) flzfje, a.yeje-isnull(b.yeje,0) yeje, a.lcyhje-isnull(b.lcyhje,0) lcyhje
		into #jsmxk2
		from #jsmxk a
    left join  #fymxk1 b on a.dxmdm=b.dxmdm
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end

		delete #jsmxk
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end

		--在院结算选日期的结算明细
		insert into #jsmxk(dxmdm, dxmmc, xmje, zfje, yhje, flzfje, yeje, lcyhje)	
		select a.dxmdm, b.name, a.xmje, a.zfje, a.yhje, a.flzfje, a.yeje, a.lcyhje
		from #fymxk1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error<>0
		begin
			select "F","计算病人结算明细出错!"
			return
		end

		select @maxxh=isnull(max(xh),0) from ZY_BRFYMXK where syxh=@syxh and zxrq<=@jsrq
	end

	update #jsmxk set xmje=a.xmje-b.xmje,
		zfje=a.zfje-b.zfje,
		yhje=a.yhje-b.yhje,
		lcyhje = a.lcyhje - b.lcyhje
		from #jsmxk a, #hzmxk b
		where a.dxmdm=b.dxmdm
	if @@error<>0
	begin
		select "F","计算病人费用月明细出错!"
		return
	end
	--add by ozb begin 2007-11-11 新打印模式下根据存储过程返回的打印标志usp_zy_getfpprintflag决定是否打印
	if @nconfigdyms=1
	begin
		select @printjsfp=1	--ozb 2007-12-03 新发票模式下，不在这边走发票
		/*
		exec usp_zy_getfpprintflag @jsxh,0,@errmsg output
		if left(@errmsg,1)='F'
		begin 
			select 'F',substring(@errmsg,2,49)
			return
		end	
		else
			select @printjsfp= case cast(substring(@errmsg,2,49) as int) when 0 then 1 else 0 end
		*/
	end
	else
	begin
		if exists (select 1 from YY_CONFIG (nolock) where id='5204' and config='否') and @jsqk=3
			select @printjsfp=1
		else --mod by ozb 20071222 5230原来是 “是” 或 “否”，现在改为医保代码 注意config中没有引号
		if exists (select 1 from YY_CONFIG where id='5230' and charindex(','+ltrim(rtrim(@ybdm))+',',','+ltrim(rtrim(config))+',')>0) and @sfje2<=0
		--if exists (select 1 from YY_CONFIG (nolock) where id='5230' and config='是') and @sfje2<=0
			select @printjsfp=1
	end
	--add by ozb end 2007-11-11 新打印模式下根据存储过程返回的打印标志决定是否打印

	begin tran

/*	if @jsje>0
	begin
		select @yje=@yje+@jsje

		insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
			czlb, jsxh, hcxh, jlzt, jszt, memo)
		values(0, 0, @syxh, @czyh, @czym, @now, @jsje, 0, @yje, @skfs, @khyh,@zph,
			2, @jsxh, null, 0, 0, null)
		if @@error<>0
		begin
			rollback tran
			select "F","插入结算收款出错！"
			return
		end
	end
*/

-- 20151014 add kcs 存在优惠记录信息 更新jlzt beign
    if exists(select 1 from YY_HZYHFSJLK_ZY where syxh = @syxh and jsxh = @jsxh)
    begin
        update YY_HZYHFSJLK_ZY set jlzt = '2' where syxh = @syxh and jsxh = @jsxh
        if @@ERROR <> 0 
        begin
            rollback tran
            select 'F','更新患者优惠方式记录信息出错！'
            return
        end
    end
--end

	if @jsje_bsxj>0 and @config5309='否'
	begin
		select @yje=@yje+@jsje_bsxj

		if @jsje_bsxj<>0 
		begin 
			insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
				czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
			values(0, 0, @syxh, @czyh, @czym, @now, @jsje_bsxj, 0, @yje, @skfs_xj, "","",
				2, @jsxh, null, 0, 0, null,@sfksdm)
			if @@error<>0
			begin
				rollback tran
				select "F","插入结算收款出错！"
				return
			end
		end
	end
	if @jsje_bszp>0 and @config5309='否'
	begin
		select @yje=@yje+@jsje_bszp

		if @jsje_bszp<>0 
		begin
			insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
				czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
			values(0, 0, @syxh, @czyh, @czym, @now, @jsje_bszp, 0, @yje, @skfs_zp,@khyh ,@zph,
				2, @jsxh, null, 0, 0, null,@sfksdm)
			if @@error<>0
			begin
				rollback tran
				select "F","插入结算收款出错！"
				return
			end
		end
	end

	if @jsje_xj>0 and @config5309='否'
	begin
		select @yje=@yje-@jsje_xj

		if @jsje_xj <>0 
		begin
			insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
				czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
	--		values(0, 0, @syxh, @czyh, @czym, @now, 0, @jsje_xj, @yje, '1', @khyh, @zph,
	--			(case @jsfs when 1 then 3 else 2 end), @jsxh, null, 0, 0, null)
			values(0, 0, @syxh, @czyh, @czym, @now, 0, @jsje_xj, @yje, @skfs_xj, "", "",
				(case @jsfs when 1 then 3 else 2 end), @jsxh, null, 0, 0, null,@sfksdm)
			if @@error<>0
			begin
				rollback tran
				select "F","插入结算退款出错！"
				return
			end
		end
	end

	if @jsje_zp>0 and @config5309='否'
	begin
		select @yje=@yje-@jsje_zp

		if @jsje_zp<>0 
		begin
			insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
				czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
	--		values(0, 0, @syxh, @czyh, @czym, @now, 0, @jsje_zp, @yje, '2', @khyh, @zph,
	--			(case @jsfs when 1 then 3 else 2 end), @jsxh, null, 0, 0, null)
			values(0, 0, @syxh, @czyh, @czym, @now, 0, @jsje_zp, @yje, @skfs_zp, @khyh, @zph,
				(case @jsfs when 1 then 3 else 2 end), @jsxh, null, 0, 0, null,@sfksdm)
			if @@error<>0
			begin
				rollback tran
				select "F","插入结算退款出错！"
				return
			end
		end
	end
	if @config5309='是' 
    begin

--================退充值卡begin===add by yjn 2015-07-17================

		if (exists (select xh From ZYB_BRYJZCK where zffs='6' and jsxh=@jsxh)) and ((@jsfs = 2) or ((@jsfs = 1) and (@yjejz = 0)))
		begin
			declare @tmpcardno ut_cardno
			select @tmpcardno=cardno From ZY_BRSYK where syxh=@syxh
			
			if @tmpcardno='' 
			begin
			    rollback tran
			    select 'F','卡号为空不能退充值卡'			    
			    return
			end
			
			if  exists(select xh From YY_JZBRK where cardno=@tmpcardno and (jlzt=1 or gsbz=1))
			begin
			    rollback tran
				select 'F','该病人卡号以挂失或作废，请办理换卡！'
				return
			end  			
																						
			if exists(select xh From YY_JZBRK where patid in (select patid From SF_BRXXK where cardno=@tmpcardno))
			begin                          	        
				declare
					@yjye ut_money,
					@yjbz int,
					@czkje ut_money,
					@czkjje ut_money,
					@czkdje ut_money,
					@sjyjye ut_money,
					@jzxh int,
					@tmppatid int
				
				select @tmppatid=patid From SF_BRXXK where cardno=@tmpcardno 	
				    
				select @czkje=dje,@czkjje=jje,@czkdje=dje From ZYB_BRYJZCK where zffs=6 and jsxh=@jsxh 
		    
				select @yjye=yjye from YY_JZBRK where patid=@tmppatid and jlzt=0
				if @@rowcount=0
					select @yjye=0
				else
					select @yjbz=1
						
	
				if @yjbz=1
				begin				
					if @czkdje>0 
					begin
						update YY_JZBRK set yjye=yjye+@czkje
							   ,@jzxh=xh,@sjyjye=yjye+@czkje
							--,@sjyjye=yjye+@xjje_old, @sjdjje=djje
						where patid=@tmppatid and jlzt=0
							
						if @@error<>0
						begin							
							rollback tran
							select "F","更新记账病人库预交金余额出错！"
							return
						end
							
						update SF_BRXXK set zhje=@sjyjye where patid=@tmppatid
						
						if @@error<>0
						begin
						    rollback tran
							select "F","更新SF_BRXXK账户金额出错！"							
							return
						end
						
						insert YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,  
							zffs,czlb,hcxh,jlzt,memo,sjh,ybdm)  
						values(0,0,@jzxh,@czyh,@czym,@now,@czkje,0,@sjyjye,  
							6,0,null,0,'住院退卡',@jsxh,@ybdm)
						if @@error<>0 or @@rowcount=0  
						begin 
						    rollback tran   
							select "F","插入充值卡预交金信息时出错！"  							
							return  
						end 											
					end		
					if @czkjje>0 
					begin
					    if @yjye-@czkjje<0
					    begin
					        select 'F','卡余额:'+convert(varchar(20),@yjye)+',不足不能扣卡!'
							rollback tran
							return					     
					    end 
										
						update YY_JZBRK set yjye=yjye-@czkjje
							   ,@jzxh=xh,@sjyjye=yjye-@czkjje
							--,@sjyjye=yjye+@xjje_old, @sjdjje=djje
						where patid=@tmppatid and jlzt=0
							
						if @@error<>0
						begin
							select "F","更新记账病人库余额出错！"
							rollback tran
							return
						end
							
						update SF_BRXXK set zhje=@sjyjye where patid=@tmppatid
						
						if @@error<>0
						begin
						    rollback tran  
							select "F","更新SF_BRXXK账户金额出错！"						
							return
						end
						
						insert YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,  
							zffs,czlb,hcxh,jlzt,memo,sjh,ybdm)  
						values(0,0,@jzxh,@czyh,@czym,@now,@czkjje,0,@sjyjye,  
							1,3,null,0,'转入住院预交金',@jsxh,@ybdm)
						if @@error<>0 or @@rowcount=0  
						begin 
						    rollback tran   
							select "F","插入扣卡信息时出错！"  							
							return  
						end 											
					end																																	
				end	else
				begin
				    rollback tran  
					select "F","该病人没有启用充值卡功能！不能退充值卡病人！"  					
					return
				end
			end                
		end												
	--===================退充值卡end========================

		insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
		czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
		select 0,0,@syxh,@czyh,@czym,@now,jje,dje,yje,zffs,khyh,zph,
		case when dje>0 and @jsfs=1 then 3 else 2 end,@jsxh,null,0,0,'结算生成',@sfksdm
		from ZYB_BRYJZCK where jsxh=@jsxh
		if @@error<>0
		begin
			rollback tran
			select "F","插入结算退款出错！"
		    return									
        end		        
    
    end
	-- mit ,2004-7-24
	if isnull(@yjjxh,'')=''
	begin
		update ZYB_BRYJK set jszt=1, jsrq=@now where syxh=@syxh and jsxh=@jsxh
		if @@error<>0
		begin
			rollback tran
			select "F","回收预交金收据出错！"
			return
		end
	end
	else
	begin
		update ZYB_BRYJK set jszt=1, jsrq=@now
		where syxh=@syxh and jsxh=@jsxh
			and xh not in(select xh from #wxzyjjk)
		if @@error<>0
		begin
			rollback tran
			select "F","回收预交金收据出错！"
			return
		end
	end

	--更新住院病人结算库
	if @dfpbz=0 
	begin
		/* del by ozb 2007.11.11 移到事务前判断，根据判断结果修改变量@printjsfp
		if exists (select 1 from YY_CONFIG (nolock) where id='5204' and config='否') and @jsqk=3
		begin
			select @fph=0, @fpjxh=0
		end
		else
		if exists (select 1 from YY_CONFIG (nolock) where id='5230' and config='是') and @sfje2<=0
		begin
			select @fph=0, @fpjxh=0
		end	*/ 
		if @printjsfp=1	--不打印结算发票
		begin
			select @fph=0, @fpjxh=0
		end
		else 
		begin
            if @config5210='2' 
            begin
				select @fph=fpxz, @fpjxh=0 from SF_GYFPK where czyh=@czyh  and xtlb=2
				if @@rowcount=0
				begin
					rollback tran
					select "F","住院发票生成错误！"
					return
				end
				select @fph1=@fph
		
				exec usp_yy_gxzsj 2, @czyh, @errmsg output,1,@fpkxh
				if @errmsg like 'F%'
				begin
					rollback tran
					select "F",substring(@errmsg,2,49)
					return
				end
            end
			else
			begin
				if @fpkxh is null
				begin
					select @fph=fpxz, @fpjxh=xh from SF_FPDJK where jlzt=1 and xtlb=2 and lyry=@czyh
					if @@rowcount=0
					begin
						rollback tran
						select "F","没有可用住院发票！"
						return
					end
				end
				else
				begin
					select @fph=fpxz, @fpjxh=xh from SF_FPDJK where jlzt=1 and xtlb=2 and xh=@fpkxh
					if @@rowcount=0
					begin
						rollback tran
						select "F","没有可用住院发票！"
						return
					end
				end
			
				select @fph1=@fph
		
				exec usp_yy_gxzsj 2, @czyh, @errmsg output,0,@fpkxh
				if @errmsg like 'F%'
				begin
					rollback tran
					select "F",substring(@errmsg,2,49)
					return
				end
			end
		end

		insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
			czlb, jsxh, hcxh, jlzt, jszt, jsrq, memo,sfksdm)
		values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @sfje2, 0, 0, '1', @khyh, @zph,
			8, @jsxh, null, 0, 1, @now, null,@sfksdm)
		if @@error<>0
		begin
			rollback tran
			select "F","插入结算金额出错！"
			return
		end

		select @xhtemp=@@identity

		if (select config from YY_CONFIG where id='5015')='是'
		begin
			if @jsfs=1 and @rqbz=1
			begin
				insert into ZY_BRJSFPMXK(jsxh, yjxh, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje)
				select @jsxh, @xhtemp, b.zyfp_id, b.zyfp_mc, sum(a.xmje), sum(a.zfje), sum(a.yhje), sum(a.yeje)
					from #fymxk1 a, YY_SFDXMK b (nolock)	
					where a.dxmdm=b.id group by b.zyfp_id, b.zyfp_mc
				if @@error<>0
				begin
					rollback tran
					select "F","插入结算发票明细出错！"
					return
				end
			end
			else begin
				insert into ZY_BRJSFPMXK(jsxh, yjxh, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje)
				select jsxh, @xhtemp, fpxmdm, fpxmmc, sum(xmje), sum(zfje), sum(yhje), sum(yeje)
					from ZY_BRJSMXK where jsxh=@jsxh
					group by jsxh, fpxmdm, fpxmmc
				if @@error<>0
				begin
					rollback tran
					select "F","插入结算发票明细出错！"
					return
				end
			end
		end
	end
	else
		select @fph=0, @fpjxh=0
	--在院结算选日期的方式下重新生成结算明细
	if (@jsfs=1 and @rqbz=1)
	begin
		delete from ZY_BRJSMXK where jsxh = @jsxh
		if @@error <> 0 
		begin
			rollback tran
			select "F","删除病人结算库出错！"
			return		
		end
		insert into ZY_BRJSMXK(jsxh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje, memo, flzfje, lcyhje)
		select @jsxh, a.dxmdm, b.name, b.zyfp_id, b.zyfp_mc, a.xmje, a.zfje, a.yhje, a.yeje, null, a.flzfje, a.lcyhje
			from #fymxk1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error <> 0 
		begin
			rollback tran
			select "F","插入病人结算库出错！"
			return		
		end
	end
	
	--add by gxf 2008-9-27  如果是出院结算时更新病人对应床位的zcbz=0和syxh=null
	if @jsfs = 2
	begin
		if @nconfigupdatezcbz = 1
		begin
			update ZY_BCDMK set zcbz = 0,syxh = null where syxh = @syxh
			if @@error<>0
			begin
				rollback tran
				select "F","更新病人结算库出错！"
				return
			end
		end
	end
	--add by gxf 2008-9-27  如果是出院结算时更新病人对应床位的zcbz=0和syxh=null、cqrq=''     
     
	update ZY_BRJSK set jszt=@jsfs, ybjszt=2, jsrq=@now, jsczyh=@czyh, zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
		qfbz=@qkbz, qfje=@qkje, deje=@deje-@deje1, fph=@fph, fpjxh=@fpjxh
		,ylcardno=@ylcardno,ylksqxh=@ylksqxh,ylkzxlsh=@ylkzxlsh	--mit ,, 2oo3-o5-o8 ,, 银联卡
		,jzrq=(case when @jsfs=1 and @rqbz=1 then @jsrq else @now end)
		,ksrq=(case when @jsfs=1 and @rqbz=1 and isnull(@ksrq,'')<>'' then @ksrq else ksrq end)
		,zje=  (case when (@jsfs=1 and @rqbz=1)  then @zje else zje end)
		,zfyje=(case when (@jsfs=1 and @rqbz=1)  then @zfyje else zfyje end)
		,yhje= (case when (@jsfs=1 and @rqbz=1)  then @yhje else yhje end)
--		,zfje=(case when @jsfs=1 and @rqbz=1 then @zje - @yhje else zje - yhje end)
		,flzfje=(case when (@jsfs=1 and @rqbz=1) then @flzfje else flzfje end)
		,zyjslb=@zyjslb
		,lcyhje=(case when (@jsfs=1 and @rqbz=1) then @lcyhje else lcyhje end)	
		,gxrq=@now --add by yfq @20120529
		,sfksdm=@sfksdm
		where syxh=@syxh and xh=@jsxh
	if @@error<>0 and @@rowcount<>1 --增加判断更新行数,不等于1时报错 
	begin
		rollback tran
		select "F","更新病人结算库出错！"
		return
	end

	--更新住院病人月汇总
	update ZY_BRFYYHZ set byfyhj=@zje-syfylj,
		byylf=@zje-@zfyje-@yhje-syylflj,
		byzf=@zfyje-syzflj,
	    byyh=@yhje-syyhlj,
	    byysje=(case when @yjlj-syyslj>0 then @yjlj-syyslj else 0 end),
	    bytkje=(case when @yjlj-syyslj<0 then syyslj-@yjlj else 0 end),
	    byfylj=@zje,
		byylflj=@zje-@zfyje-@yhje,
		byzflj=@zfyje,
	    byyhlj=@yhje,
		byyslj=@yjlj,
		jlzt=1,
		jzzt=@jsfs,
		jsrq=@now,
		@hzxh=xh,
		bylcyhjelj = @lcyhje
		where syxh=@syxh and jsxh=@jsxh and jlzt=0
	if @@error<>0
	begin
		rollback tran
		select "F","更新病人费用月汇总出错!"
		return
	end

	delete ZY_BRFYYMX where hzxh=@hzxh
	if @@error<>0
	begin
		rollback tran
		select "F","更新病人费用月明细出错!"
		return
	end

	insert into ZY_BRFYYMX(hzxh, dxmdm, dxmmc, xmje, zfje, yhje, memo, lcyhje)
	select @hzxh, dxmdm, dxmmc, xmje, zfje, yhje, null, lcyhje from #jsmxk where xmje<>0 or zfje<>0 or yhje<>0
	if @@error<>0
	begin
		rollback tran
		select "F","更新病人费用月明细出错!"
		return
	end

	if @jsfs=1
	begin
		insert into ZY_BRJSK(syxh, fph, fpjxh, hzxm, patid, blh, djrq, djczyh, jsrq, jsczyh, 
			zyts, ybdm, sfzh, dwbm, brlx, pzh, cardno, cardtype, deje, zje, zfyje, yhje, zfje, 
			srje, qfbz, qfje, jszt, ybjszt, jlzt, hcxh, zhbz, zddm, dnzhye, lnzhye, zxlsh, jslsh, memo, flzfje, ksrq
			,lcyhje,spzlx,sfksdm,ybzyts)	
		select syxh, 0, 0, hzxm, patid, blh, @now, @czyh, null, null,
			0, ybdm, sfzh, dwbm, brlx, pzh, cardno, cardtype, @deje1, @zje2, @zfyje2, @yhje2, 0,
			0, 0, 0, 0, 0, 0, null, zhbz, zddm, dnzhye, lnzhye, null, null, null,
			@flzfje2, (case when @rqbz=0 then @now else @jsrq end), @lcyhje2,spzlx,@sfksdm,0	
			from #brjsk
		if @@error<>0
		begin
			rollback tran
			select "F","生成病人结算库出错!"
			return
		end

		select @xhtemp=@@identity
		--mit ,2004-7-22, 将为选择结算的预交金改为下个结算序号
		if isnull(@yjjxh,'')<>''
		begin
			update ZYB_BRYJK
			set jsxh=@xhtemp
			where xh in(select xh from #wxzyjjk)
			--and syxh=@syxh and jsxh=@jsxh
		end

		if @rqbz=1
		begin
			insert into ZY_BRJSMXK(jsxh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje, memo, flzfje, lcyhje)
			select @xhtemp, a.dxmdm, b.name, b.zyfp_id, b.zyfp_mc, a.xmje, a.zfje, a.yhje, a.yeje, null, a.flzfje, a.lcyhje
				from #jsmxk2 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
			if @@error<>0
			begin
				rollback tran
				select "F","生成病人结算明细库出错!"
				return
			end

			/*update ZY_BRFYMXK set jsxh=@xhtemp where syxh=@syxh and xh>@maxxh
			if @@error<>0
			begin
				rollback tran
				select "F","更新病人费用明细库出错!"
				return
			end
			*/

			--mit , 2004-7-24, 单项目结算
			--if isnull(@mxxh,'')=''
			if @selectmx=0 ----cjt bug187917 单项目结算将已经结算的jsxh给更新了 
			begin
				update ZY_BRFYMXK set jsxh=@xhtemp where syxh=@syxh and ((xh>@maxxh) or (xh<@maxxh and zxrq>@jsrq )) and
			    jsxh not in (select xh from ZY_BRJSK a where a.syxh=@syxh and a.ybjszt=2 and  a.jlzt = '0' and a.jsrq<>@now )
				if @@error<>0 
				begin
					rollback tran
					select "F","更新病人费用明细库出错!"
					return
				end
			end
			else
			begin
				--mit, 单项目结算时将除了这次结算项目序号外的所有当前结算序号的置为新的结算序号
				select @strsql=' update ZY_BRFYMXK set jsxh='+ convert(varchar(16),@xhtemp)
						+ ' where syxh=' + convert(varchar(16),@syxh) 
						+ ' and jsxh=' + convert(varchar(16),@jsxh)
						--+ ' and xh not in' + @mxxh
						+ ' and xh not in (select xh from #mxxh_tt)'
				exec(@strsql)
				if @@error<>0
				begin
					rollback tran
					select "F","更新病人费用明细库出错!"
					return
				end
			end
		end

		select @yje=0
		if (select config from YY_CONFIG (nolock) where id='5017')='是'
			select @print=1
		else
			select @print=0

        --modify by dn 2003.11.10
        select @yjejz=0 
        if (select config from YY_CONFIG (nolock) where id ='5054')='否'
                select @yjejz=1  --找零
        else   
                select @yjejz=0  --结转
		
		--modify by jjw 2005-02-19
		if @jsfs=1 and (select config from YY_CONFIG (nolock) where id='5184')='是'
		begin
			if @isztjz=1 select @yjejz=0   --结转
			else select @yjejz=1		   --找零
		end
		--if @yjejz=1  --找零
		begin
			if @jsqk in (1,2,3) 
			begin
				if  @jsjein_tzp<>0 and @skfs_zp='S'
				begin
					if @yjejz=1  --找零
					begin 
						select "F","请到预交金界面红冲退[S-结算支付中心]多余金额." 
					end
					else
					begin 
						select "F","[S-结算支付中心]预交金不能进行结转，请先到预交金界面红冲." 
					end
					rollback tran 
					return 
				end
			end
		end 
        if @config5309='否'
        begin
			if @jsje_xj>0
			begin
				select @yje=@jsje_xj

				if @print=1
				begin
					if @config5210='2' 
					begin
						select @fph=fpxz, @fpjxh=0 from SF_GYFPK where czyh=@czyh  and xtlb=3
						if @@rowcount=0
						begin
							rollback tran
							select "F","没有可用预交金收据！"
							return
						end
				
						exec usp_yy_gxzsj 3, @czyh, @errmsg output,1
						if @errmsg like 'F%'
						begin
							rollback tran
							select "F",substring(@errmsg,2,49)
							return
						end
					end
					else
					begin                
						select @fph=fpxz, @fpjxh=xh from SF_FPDJK where lyry=@czyh and jlzt=1 and xtlb=3
						if @@rowcount=0
						begin
							rollback tran
							select "F","没有可用预交金收据！"
							return
						end
						exec usp_yy_gxzsj 3, @czyh, @errmsg output
						if @errmsg like 'F%'
						begin
							rollback tran
							select "F",substring(@errmsg,2,49)
							return
						end
					end
				end
				else
					select @fph=0, @fpjxh=0

				if @yjejz=1 --找零
				begin
				  update ZYB_BRYJK set czlb=2 where czlb=3 and jsxh=@jsxh and syxh=@syxh
				   -- select @yjejz=1
				end
				else --结转
				begin
					insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
						czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
		--			values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @jsje_xj, 0, @yje, '1', @khyh, @zph,
		--				3, @xhtemp, null, 0, 0, null)
					values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @jsje_xj, 0, @yje, @skfs_xj, "", "",
						3, @xhtemp, null, 0, 0, null,@sfksdm)
					if @@error<>0
					begin
						rollback tran
						select "F","插入结转预交金出错！"
						return
					end

					select @jsje_xj=0
				end
			end

			if @jsje_zp>0
			begin
				select @yje=@yje+@jsje_zp

				if @print=1
				begin
					if @config5210='2' 
					begin
						select @fph=fpxz, @fpjxh=0 from SF_GYFPK where czyh=@czyh  and xtlb=3
						if @@rowcount=0
						begin
							rollback tran
							select "F","没有可用预交金收据！"
							return
						end
				
						exec usp_yy_gxzsj 3, @czyh, @errmsg output,1
						if @errmsg like 'F%'
						begin
							rollback tran
							select "F",substring(@errmsg,2,49)
							return
						end
					end
					else
					begin
						select @fph=fpxz, @fpjxh=xh from SF_FPDJK where lyry=@czyh and jlzt=1 and xtlb=3
						if @@rowcount=0
						begin
							rollback tran
							select "F","没有可用预交金收据！"
							return
						end

						exec usp_yy_gxzsj 3, @czyh, @errmsg output
						if @errmsg like 'F%'
						begin
							rollback tran
							select "F",substring(@errmsg,2,49)
							return
						end
					end
				end
				else 
					select @fph=0, @fpjxh=0

				if @yjejz=1 --找零
				begin
				  update ZYB_BRYJK set czlb=2 where syxh=@syxh and czlb=3 and jsxh=@jsxh
				   -- select @yjejz=1
				end
				else --结转
				begin
					insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
						czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
				--			values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @jsje_zp, 0, @yje, '2', @khyh, @zph,
				--				3, @xhtemp, null, 0, 0, null)
					values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @jsje_zp, 0, @yje, @skfs_zp, @khyh, @zph,
						3, @xhtemp, null, 0, 0, null,@sfksdm)
					if @@error<>0
					begin
						rollback tran
						select "F","插入结转预交金出错！"
						return
					end

					select @jsje_zp=0
				end
			end
		end
		else
		begin
		    if @yjejz=1 --找零
		    begin
			  update ZYB_BRYJK set czlb=2 where syxh=@syxh and czlb=3 and jsxh=@jsxh
			   -- select @yjejz=1
		    end
		    else --结转
		    begin
			  declare @yjjye ut_money
			  declare @zcdje ut_money,@zczffs ut_dm2,@zckhyh ut_mc64,@zczph ut_mc32 
			  declare cs_yjjcl cursor for select dje,zffs,khyh,zph from ZYB_BRYJK (nolock) where syxh=@syxh and jsxh=@jsxh and dje>0 and czlb=3
			  open cs_yjjcl
			  fetch cs_yjjcl into @zcdje,@zczffs,@zckhyh,@zczph
			  while @@fetch_status=0            
			  begin
			      if @print=1
				  begin
				  if @config5210='2' 
				  begin
				    select @fph=fpxz, @fpjxh=0 from SF_GYFPK where czyh=@czyh  and xtlb=3
					if @@rowcount=0
					begin
						rollback tran
						close cs_yjjcl
						deallocate cs_yjjcl
						select "F","没有可用预交金收据！"
						return
					end
    			
					exec usp_yy_gxzsj 3, @czyh, @errmsg output,1
					if @errmsg like 'F%'
					begin
						rollback tran
						close cs_yjjcl
						deallocate cs_yjjcl
						select "F",substring(@errmsg,2,49)
						return
					end
					end
					else
					begin
						select @fph=fpxz, @fpjxh=xh from SF_FPDJK where lyry=@czyh and jlzt=1 and xtlb=3
						if @@rowcount=0
						begin
							rollback tran
							close cs_yjjcl
							deallocate cs_yjjcl
							select "F","没有可用预交金收据！"
							return
						end

						exec usp_yy_gxzsj 3, @czyh, @errmsg output
						if @errmsg like 'F%'
						begin
							rollback tran
							close cs_yjjcl
							deallocate cs_yjjcl
							select "F",substring(@errmsg,2,49)
							return
						end
				    end
				  end
				  else 
				    select @fph=0, @fpjxh=0

			      select @yjjye=isnull(sum(jje-dje),0) from ZYB_BRYJK (nolock) where syxh=@syxh and jsxh=@xhtemp and czlb not in (8,9)
			      insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
				    czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
				  values(@fpjxh, @fph, @syxh, @czyh, @czym, @now, @zcdje, 0, @yjjye+@zcdje, @zczffs, @zckhyh, @zczph,
				    3, @xhtemp, null, 0, 0, null,@sfksdm)
				  if @@error<>0
				  begin
				      deallocate cs_yjjcl
				      rollback tran            
				      select "F","插入结转预交金出错！"
					  return
				  end
			      fetch cs_yjjcl into @zcdje,@zczffs,@zckhyh,@zczph
			  end
			  close cs_yjjcl
			  deallocate cs_yjjcl
		    end
		end

		insert into ZY_BRFYYHZ(syxh, ny, ksrq, jsrq, bqdm, ybdm, jlzt, hcxh, jsxh, jzzt, 
			byfyhj, byylf, byzf, byyh, byysje, bytkje, syfylj, syylflj, syzflj, syyhlj, syyslj, 
			byfylj, byylflj, byzflj, byyhlj, byyslj, memo,sylcyhjelj,bylcyhjelj)
		select syxh, ny, @now, null, bqdm, ybdm, 0, null, @xhtemp, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, null,0,0
			from #brfyyhz
		if @@error<>0
		begin
			rollback tran
			select "F","生成病人费用月汇总出错!"
			return
		end
	end
	else begin
	    if @jsqk in (1,2,3) 
		begin
			if  @jsjein_tzp<>0 and @skfs_zp='S'
			begin  
				select "F","请到预交金界面红冲退[S-结算支付中心]多余金额."  
				rollback tran 
				return 
			end
		end

        ---增加判断，如果参数5009为是，则出院日期不能更新为当前日期 add by sqf 20100916 ID76047
        if exists(select 1 from YY_CONFIG where id ='5009' and config = '是')
			update ZY_BRSYK set cyrq=cqrq, brzt=3, jgbz=(case @jgbz when 1 then 2 else 0 end),gxrq=@now where syxh=@syxh
		else
			update ZY_BRSYK set cyrq=@now, brzt=3, jgbz=(case @jgbz when 1 then 2 else 0 end),gxrq=@now where syxh=@syxh
		if @@error<>0
		begin
			rollback tran
			select "F","病人出院时出错!"
			return
		end
		--koala ,2004-11-26, 将为未选择结算的预交金改为-1
		if isnull(@yjjxh,'')<>''
		begin
			update ZYB_BRYJK
			set jsxh= -1,yjsxh = @jsxh, jszt =0
			where jsxh = @jsxh
			and xh in(select xh from #wxzyjjk )
			and  syxh=@syxh 
		end
	end
		
	update a
	set a.sl=isnull(b.sl,0)
		,a.se=(a.zje-a.yhje)*isnull(b.sl,0)
		,a.sqje=a.zje-a.yhje
		,a.shje=(a.zje-a.yhje)*(1-isnull(b.sl,0))
	from ZY_BRFYMXK a 
		left join YY_SFXXMK b on a.ypdm=b.id and a.idm=0
	where a.jsxh=@jsxh	
	if @@error<>0
	begin
		rollback tran
		select "F","处理税费信息时出错！"
		return
	end

	--若医保本地未更新成功时更新本地记录
	update YY_YBJYMX set zxlsh=@zxlsh, ybjszt=2 where zxlsh=@jslsh
	if @@error<>0
	begin
		select "F","更新医保交易明细出错！"
		rollback tran
		return
	end

	if ltrim(rtrim(isnull(@spzbz,'0'))) <> '1'
		select @spzlx = ''
	--20030219 增加对欠款病人的处理
	select @qqqklj=(select isnull(sum(qfje),0) from ZYB_QFBRJLK where syxh=@syxh and jlzt=0) 
	if @jsqk=3 
	begin
		insert into ZYB_QFBRJLK (jsxh,syxh,hzxm,zje,zfje,yjje,qfje,dbr,dbrxm,dbrdh,dbrks,czyh,lrrq,jlzt)
		select @jsxh,s.syxh,s.hzxm,@zje,@zfyje,@yjlj,@qkje,s.lxr,s.lxr,lxrdh,null,@czyh,@now,0
		from ZY_BRSYK  s
		where s.syxh = @syxh
	end

	--2007-07-11 增加对代币卡的处理开始
	if @dbkxh <> 0 
	begin
		declare @dbkje ut_money,
				@kdm  ut_dm2,
				@dbkye ut_money,
				@yjkxh ut_xh12

		if @skfs_xj = '4'
			select @dbkje = @jsje_bsxj
		else
			select @dbkje = @jsje_bszp
		--本次结算，czlb = 2,且支付方式 = 4 的归为代币卡支付
		select @yjkxh = xh from ZYB_BRYJK nolock
			where syxh=@syxh and jsxh=@jsxh and czlb = 2 and zffs = '4'

		update YY_CARDXXK set yjye=yjye-@dbkje,zjrq=substring(@now,1,8)
		where kxh=@dbkxh and jlzt=0
		if @@error<>0
		begin
			select "F","更新代币卡病人帐户余额出错！"
			rollback tran
			return
		end		
	
		select @kdm=a.kdm,@dbkye=yjye
	      		from YY_CARDXXK a(nolock)
		 where a.kxh=@dbkxh 
		
		insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
		values(@dbkxh,@jsxh,@yjkxh,@kdm,@czyh,@czym,@now,@dbkje,@dbkye,0,0,0,0,1,'')
		if @@error<>0
		begin
			rollback tran
			select "F","更新代币卡金额库出错！"
			return
		end
	end
	--2007-07-11 增加对代币卡的处理开始结束
	--2007-07-13 修改信息库的统筹累计金额
	if @spzbz='1'
	begin
		select @yhljje = isnull(tsyhje2,0),@patid = patid , @tcljje=zje-zfyje-yhje
		from ZY_BRJSK (nolock)	where xh = @jsxh
	end
	else
	begin
		select @tcljje = zje-(zfje-srje)-isnull(yhje,0)-isnull(tsyhje,0),@patid = patid 
		from ZY_BRJSK(nolock)
		where xh = @jsxh
	end

	select @tcljje = isnull(@tcljje,0), @yhljje=isnull(@yhljje,0)
	update ZY_BRXXK set tcljje = tcljje + @tcljje, yhljje=yhljje+@yhljje,gxrq=@now where patid = @patid --add by yfq @20120531
	if @@error<>0
	begin
		rollback tran
		select "F","更新信息库的统筹累计金额出错！"
		return
	end
	select @tcljybdm = config from YY_CONFIG where id = '0115'
	if charindex('"'+rtrim(@ybdm)+'"',@tcljybdm) > 0
	begin
		declare @mzpatid ut_xh12
		select @mzpatid=mzpatid from YY_BRLJXXK nolock where cardno = @cardno and cardtype = @cardtype
		if @@rowcount <> 0
		begin
			exec usp_zy_tcljjegl @cardno,@mzpatid,@tcljje,0,0,1,4,@czyh
			if @@error <> 0 
			begin
				rollback tran
				select "F","更新YY_BRLJXXK的统筹累计金额出错！"
				return
			end
		end
	end
	commit tran

	select @ysybzfje = isnull(sum(je),0) from  ZY_BRJSJEK(nolock) where lx in ('20','22') and jsxh = @jsxh
	select @gbzfje2 = isnull(sum(je),0) from  ZY_BRJSJEK(nolock) where lx in ('24') and jsxh = @jsxh
	select @dyzfyje = zfyje-flzfje
		from ZY_BRJSK nolock where syxh=@syxh and xh=@jsxh
	--add by yyx 2009-05-18
    if @jsje_xj=0 and @jsje_bsxj=0
        select @skfs_xjmc=''
    if @jsje_zp=0 and @jsje_bszp=0
        select @skfs_zpmc=''
   --add by yyx 2009-05-18
	select "T", @zje, @sfje2, @deje, @jsje_xj, @jsje_zp, convert(varchar(20),@fph1),  --0-6
		@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje, @tczfje, @dffjzfje, @dnzhye,  -- 7-10
		@lnzhye, @jsxh, @yjlj,@qqqklj,@flzfje,@qfxjzfje+@tcxjzfje+@fjxjzfje --11-16
		,@tsyhje,@sfje2+@tsyhje+@tsyhje2,@sfje2+@tsyhje-@zfyje,@spzlx,@spzmc,@gbje ,@ysybzfje,  --17-23  特殊优惠金额/优惠前现金金额/
		case when @gbbz = '0' then @dyzfyje else @gbzfje2 end -- 24
		,@ebzfje,@xbzfje,@rqfldm,@skfs_xjmc,@skfs_zpmc  --25-27,28,29
		,@lcyhje,@zplj,@xjlj,@zje - @lcyhje as lczje,@lcyhje	--30-34
	return
end
go
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
	--,@mxxh varchar(8000) =null	--��ϸ��������б�,��,�ŷָ�
	,@mxxh text =null	--��ϸ��������б�,��,�ŷָ�
	,@jsjein_txj numeric(12,2) = 0.00
	,@jsjein_tzp numeric(12,2) = 0.00
	,@yjjxh	varchar(1000) =null	--Ԥ��������б�,��,�ŷָ�
	,@fpkxh	ut_xh12=null --��Ʊ�����
	,@dbkxh ut_xh12= 0 --���ҿ����
	--,@zpzh  varchar(32)='' --֧Ʊ�˺�
	--,@zpdw  ut_mc64= ''  --֧Ʊ��λ
	,@zxgxbgrzf numeric(12,2) = 0.00 --��Ѫ��ϸ������֧��
    ,@dbjfje	numeric(12,2) = 0.00 
    ,@sfksdm	ut_ksdm=''
as 
/**********
[�汾��]4.0.0.0.0
[����ʱ��]2004.11.13
[����]����
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]���˽���
[����˵��]
	סԺ���˷��ý��㣬������Ժ����ͳ�Ժ����
[����˵��]
	@syxh ut_syxh,				��ҳ���
	@jsfs smallint = 2,			���㷽ʽ1=��Ժ��2=��Ժ
	@jsqk smallint = 0,			�������0=�����1=����1��2=ִ�н��㣬3=Ƿ���Ժ
	@czyh ut_czyh = null		����Ա��
	@jsje_bsxj numeric(12,2) = 0,	��Ժ�����Ƿ�����ʱ׷�ӽ��ֽ��ࣩ
	@skfs_xj ut_dm2 = '0'		�տʽ(�ֽ��ࣩ
	@jsje_bszp numeric(12,2) = 0,	��Ժ�����Ƿ�����ʱ׷�ӽ�֧Ʊ�ࣩ
	@skfs_zp ut_dm2 = '0'		�տʽ��֧Ʊ�ࣩ
	@zhbz ut_zhbz = null,		�˻���־	
	@zddm ut_zddm = null,		��ϴ���
	@zxlsh ut_lsh = null,		������ˮ��
	@jslsh ut_lsh = null,		������ˮ��
	@qfdnzhzfje numeric(12,2) = null, 	�𸶶ε����˻�֧��
	@qflnzhzfje numeric(12,2) = null,	�𸶶������ʻ�֧��
	@qfxjzfje numeric(12,2) = null,		�𸶶��ֽ�֧��
	@tclnzhzfje numeric(12,2) = null,	ͳ��������ʻ�֧��
	@tcxjzfje numeric(12,2) = null,		ͳ����ֽ�֧��
	@tczfje numeric(12,2) = null,		ͳ���ͳ��֧��
	@fjlnzhzfje numeric(12,2) = null,	���Ӷ������ʻ�֧��
	@fjxjzfje numeric(12,2) = null,		���Ӷ�����֧��
	@dffjzfje numeric(12,2) = null		���Ӷεط�����֧��
	@dnzhye numeric(12,2) = null,		�����˻����
	@lnzhye numeric(12,2) = null,		�����˻����
	@dfpbz smallint = 0					�෢Ʊ��ӡ��־0=����Ʊ��1=�෢Ʊ
	@khyh  ut_mc64=null,		��������
	@zph   varchar(50)=null			֧Ʊ��
--mit ,, 2oo3-o5-o8 ,, ����������
	,@ylcardno ut_cardno=''		--����������
	,@ylksqxh ut_lsh=''		--���������������
	,@ylkzxlsh ut_lsh=''		--��������������ˮ��
--tony 2003.09.16	��Ժ���㵽����
	,@rqbz ut_bz=0				0��Ժ���㵽��ǰΪֹ,1��Ժ���㵽ָ������
	,@jsrq ut_rq16=null			��Ժ��������
	,@mxxh varchar(500) =null	--��ϸ��������б�,��,�ŷָ�
	,@yjjxh	varchar(1000) =null	--Ԥ��������б�,��,�ŷָ�
	,@dbkxh ut_xh12= 0 --���ҿ����
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
	20030219 ���Ӷ�Ƿ��˵Ĵ���
	Modify By Koala 2003.03.24 ���ж��Ƿ���δ����ҩƷʱ�����Ӷ��Ա�ҩ��ȥ������
	modify by qxh   2003.4.16  �����˿������к�֧Ʊ��
	modify by hkh   2003.6.21  ���ʲ�������һ�ַ�ʽ��ԭ@jsje��ֳ�@jsje_bsxj��@jsje_bszp��
			   ԭ@skfs��ֳ�@skfs_xj��@skfs_zp
	2003.09.16 tony ������Ժ���㵽���ڵĹ��ܣ��޸��Ϻ�ҽ������
	2004.1.7 tony ��Ժ���㵽����ʱ��zfje��yhjeֱ��ȡZY_BRFYMXK�е�zfje��yhje
	2004.2.10 yxp ��Ժ�����סԺ�����㷨��������һ��(��Ժ��������������һ�������)
	2004-02-12 yxp add  ������˷�����ϸ�д��ڹ����Ŀ(����)����ȷ��ҩƷ����ʾ
	2004-07-08 Wxp �ڳ�Ժ����ʱ���жϡ��Ƿ���δ���˵ġ�����Ԥ���㴦�ж�
	2004-11-07	Koala	�ϲ�������Ժ����Ŀ���㹦��
	2004-12-22 Wxp �����˷��ֽ����֧Ʊ
	2006-12-15 gzy ��Ժ�������ӿ����ж��Ƿ�Ҫ����Ժ���
	2007-01-30 ozb �ڼ���zje1 ʱ�ų�����Ŀ���������
	2007-11-02 ozb	�·�Ʊ��ӡģʽ�£��Ƿ��ӡ��Ʊͨ���洢����usp_zy_getfpprintflag���  
	2008-02-28 ozb	�޸Ķ�����Ĵ���Ҫ���Ƕ���нᣬ���ȡ���нᡢ�Լ��Է�ҩ�����
**********/
set nocount on
declare @ybdm ut_ybdm,		--ҽ������
		@now ut_rq16,		--��ǰʱ��
		@zfbz smallint,		--������־
		@zje ut_money,		--�ܽ��
		@zje1 ut_money,		--�ѽ����ܽ��
		@zfyje ut_money,	--�Էѽ��
		@zfyje1 ut_money,	--�ѽ����Էѽ��
		@yhje ut_money,		--�Żݽ��
		@yhje1 ut_money,	--�ѽ����Żݽ��
		@ybje ut_money,		--������ҽ������Ľ��
		@ybje1 ut_money,	--�ѽ��������ҽ������Ľ��
		@pzlx ut_dm2,		--ƾ֤����
		@sfje ut_money,		--ʵ�ս��
		@sfje1 ut_money,	--�ѽ���ʵ�ս��
		@sfje_all ut_money,	--ʵ�ս��(�����Էѽ��)
		@errmsg varchar(50),
		@srbz char(1),		--�����־
		@srje ut_money,		--������
		@sfje2 ut_money,	--������ʵ�ս��
		@xhtemp ut_xh12,
		@fph bigint,			--��Ʊ��
		@fpjxh ut_xh12,		--��Ʊ�����
		@deje ut_money,		--������
		@deje1 ut_money,	--ʣ�ඨ����
		@ryrq ut_rq16,		--��Ժ����
		@rqrq ut_rq16,		--��������
		@cqrq ut_rq16,		--��������
		@maxjsrq ut_rq16,	--�����Ժ��������
		@jgbz smallint,		--���۱�־0=סԺ��1=�ڹۣ�2=����
		@cardtype ut_dm2,	--������
		@brlx char(1),		--��������
		@ybstr varchar(350),	--ҽ���ַ���(�ӳ�)
		@cardno ut_cardno,		--����
		@tsrybz char(1),		--������Ա��־
		@strybje char(10),		--ҽ�������ܶ�
		@zyts numeric(10,1),	--סԺ����
		@zyts1 numeric(10,1),	--�ѽ���סԺ����
		@jsxh ut_xh12,			--�������
		@yjlj money,			--Ѻ���ۼ�
		@xjlj money,			--�ֽ��ۼ�
		@zplj money,			--֧Ʊ�ۼ�
		@print smallint,		--Ԥ�����վݴ�ӡ��־0=����1=��ӡ
		@tcljje numeric(12,2),	--ͳ���ۼƽ��
		@ybjsfs ut_bz,			--ҽ�����㷽ʽ
		@qqqklj ut_money       --ǰ��Ƿ���ۼ�
		--tony 2003.09.16 ҽ������
		,@flzfje ut_money		--�����Ը����
		,@flzfje1 ut_money		--�ѽ�������Ը����
		,@strybjsje char(10)	--ҽ�����㷶Χ���
		,@strzyf char(10)		--סԺ��
		,@strzlf char(10)		--���Ʒ�
		,@strzlf1 char(10)		--���Ʒ�
		,@strhlf char(10)		--�����
		,@strssclf char(10)		--�������Ϸ�
		,@strjcf char(10)		--����
		,@strhyf char(10)		--�����
		,@strspf char(10)		--��Ƭ��
		,@strtsf char(10)		--͸�ӷ�
		,@strsxf char(10)		--��Ѫ��
		,@strsyf char(10)		--������
		,@strxyf char(10)		--��ҩ��
		,@strzcyf char(10)		--�г�ҩ��
		,@strcyf char(10)		--�в�ҩ��
		,@strqtf char(10)		--������
		,@strzfje char(10)		--��ҽ�����㷶Χ���
		,@zje2 ut_money			--ʣ���ܽ��
		,@zfyje2 ut_money		--ʣ���Էѽ��
		,@yhje2 ut_money		--ʣ���Żݽ��
		,@flzfje2 ut_money		--ʣ������Ը����
        ,@yjejz smallint		--Ԥ�����ת��־ 0=����ת��1=��ת
		--mit , ��������, ����Ŀ����
		,@strsql varchar(8000)		--ִ��strsql,mit, 2004-07-22
		,@zyjslb ut_bz			--��Ժ�������,mit, 2004-07-22
		,@isztjz ut_bz			--Ԥ�����Ƿ���;��ת,jjw, 2005-02-19
		,@tsyhje ut_money 		--�����Żݽ��		
		,@tsyhje2 ut_money
		,@spzlx varchar(10) 		--˫ƾ֤����
		,@spzbz char(2)           	--˫ƾ֤��־
		,@gbbz ut_bz			--�ɱ���־
		,@gbje ut_money			--�ɱ����
		,@pzh ut_pzh
		,@ysybzfje ut_money --ԭʼҽ���Ը����,2005-11-14 �ɱ�Ҫ���ӡ�ɱ��ֽ�֧�����
		,@gbzfje2 ut_money  --�ɱ�����Է�2
		,@dyzfyje ut_money --��ӡ�Է�ҩ��� 
		--������ѧ�����ж���ʱ��ӡ�ڷ�Ʊ�ϵĽ��
		,@xbzfje ut_money --ѧ��֧����� 
		,@ebzfje ut_money --����֧����� 
		,@rqfldm	ut_dm4	--��Ⱥ����   04 ���� 05 ��ͯѧ�� 06 ѧ��
		,@skfs_xjmc ut_name --�ֽ�֧����ʽ����
		,@skfs_zpmc ut_name --֧Ʊ֧����ʽ����
		,@patid ut_syxh
		,@tcljybdm varchar(500)  --ͳ���ۼ�ҽ������
		,@nconfigdyms	ut_bz	--��ӡģʽ(5212) 0 �� 1 ��
		,@printjsfp	ut_bz	--��ӡ��Ʊ��־	
		,@lcyhje ut_money  --���˷����ܵ�����Żݽ��
		,@lcyhje1 ut_money --���˱��ν��������Żݽ��
		,@lcyhje2 ut_money 	--���˱��ν����ʣ�������Żݽ��
		,@nconfigupdatezcbz ut_bz --�Ƿ��ڲ��˽���ʱ�Ÿ��²��˶�Ӧ��λ��ռ����־(Ϊ���ڲ��˳���ʱ����)
		,@returnmsg varchar(100) --�洢���̷�����Ϣ
		,@yhljje ut_money		--�Ż��ۼƽ��
		,@ebdeje ut_money --����������
		,@jfzf_flzfje ut_money ---����֧���ķ����Ը����
        ,@srtjfzf_flzfje char(10)--����
		,@strjf varchar(11) --���� 
        , @ybjfzje ut_money--����
        ,@brzt     ut_bz   --����״̬
        ,@ybzyts numeric(10,1)
        ,@ybksrq ut_rq8
        ,@ybjsrq ut_rq8
        ,@config5436 char(2)
declare @lastksrq ut_rq16
        ,@spzmc ut_mc32
		,@ksrq ut_rq16
		,@config5235	VARCHAR(2000)	--���˽�����Ҫ��˵�ƾ֤����
        ,@config5210    varchar(2)      --���÷�Ʊ��ģʽ
        ,@config5320 varchar(2)       
		,@config5309 varchar(2) --�Ƿ�ʹ�ö���֧����ʽ
		,@config5369 varchar(2)
		,@config5478 varchar(2)--��֧Ʊ�Ƿ�֧����֧Ʊ�ܶ����Ԥ����֧Ʊ�ܶ�
 
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0,
	@deje=0, @deje1=0, @zyts=0, @zyts1=0,
	@yjlj=0, @xjlj=0, @zplj=0, @print=0, @tcljje=0,@qqqklj=0
	--tony 2003.09.16 ҽ������
	,@flzfje=0,@flzfje1=0,@zje2=0,@zfyje2=0,@yhje2=0,@flzfje2=0
	,@zyjslb=0,@spzlx = '',@spzmc='',@ybjfzje = 0--����
	,@fph=0,@fpjxh=0,@gbbz=0, @gbje=0,@gbzfje2 = 0,@ysybzfje = 0,@dyzfyje = 0
	,@printjsfp=0,@nconfigdyms=0	--add by ozb 20071111
	,@lcyhje = 0,@lcyhje1 = 0 ,@lcyhje2 = 0, @config5235="", @yhljje = 0,@config5210="",@jfzf_flzfje = 0
	,@ebdeje =0,@config5320='��',@config5309='��',@config5369 = '��',@ybzyts=0,@ybksrq='',@ybjsrq=''
	,@config5478='��'
select @skfs_xjmc = name from YY_ZFFSK nolock where id =@skfs_xj 
select @skfs_zpmc = name from YY_ZFFSK nolock where id =@skfs_zp

DECLARE @selectmx	ut_bz	--�Ƿ���ѡ����ϸ 0 �� 1 ��
--add by ozb 2007-11-20 ������ϸ���ȳ���8000������
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
--add by ozb 2007-11-20 ������ϸ���ȳ���8000������

--mit , 2004-07-22 ,�����ѡ����Ŀ����,�����ѡ�����ڵ���Ժ����
--if isnull(@mxxh,'')<>'' 
if @selectmx=1
begin
	if @jsfs=2 
	select @jsfs=1,@rqbz=1,@zyjslb=1      --����Ժ�����־����Ϊ��Ժ����
	else
	select @rqbz=1,@zyjslb=1,@ksrq=min(zxrq),@jsrq=max(zxrq) 
		from VW_BRFYMXK a(nolock),#mxxh_tt b 
			where a.syxh=@syxh and a.xh=b.xh	
end

--yxp add 2004-02-12 ������˷�����ϸ�д��ڹ����Ŀ(����)����ȷ��ҩƷ����ʾ
if exists(select 1 from ZY_BRFYMXK (nolock)
	where syxh=@syxh and ltrim(rtrim(isnull(dxmdm,''))) not in (select id from YY_SFDXMK (nolock)) )
begin
	select "F","���˷�����ϸ�д��ڹ����Ŀ(����)����ȷ��ҩƷ������ҩƷ�ֵ����ã�"
	return
end

-- add kcs 20160801 by 84703 
if exists(select 1 from ZY_BRFZXXK where syxh = @syxh and jlzt = 0)
begin
    select "F","����Ŀǰ���ڷ���״̬,�޷����㣡"
	return
end

if exists (select * from YY_CONFIG (nolock) where id='5036' and config='��')
	update ZY_BRSYK set cqrq= @now,gxrq=@now where syxh=@syxh and jgbz=1

--add by ozb begin 2007-11-11 ��ӡģʽ
if exists(select 1 from YY_CONFIG where id='5212' and config='��')
	select @nconfigdyms=1
else
	select @nconfigdyms=0
--add by ozb end 2007-11-11 ��ӡģʽ

select @config5210=config from YY_CONFIG where id='5210'

--add by gxf begin 2008-9-27 �Ƿ��ڲ��˽���ʱ�Ÿ��²��˶�Ӧ��λ��ռ����־(Ϊ���ڲ��˳���ʱ����)��
if exists(select 1 from YY_CONFIG where id='5242' and config='��')
	select @nconfigupdatezcbz=1
else
	select @nconfigupdatezcbz=0
--add by gxf end 2008-9-27 �Ƿ��ڲ��˽���ʱ�Ÿ��²��˶�Ӧ��λ��ռ����־(Ϊ���ڲ��˳���ʱ����)��
if exists (select 1 from YY_CONFIG (nolock) where id='5320' and config='��')
  select @config5320='��'

if exists (select 1 from YY_CONFIG where id='5309' and config='��')
  select @config5309='��'
  
if exists (select 1 from YY_CONFIG where id='5369' and config='��')
  select @config5369='��' 
if exists (select 1 from YY_CONFIG where id='5436' and config='��')
    select @config5436='��'
else
    select @config5436='��' 
--    
if exists (select 1 from YY_CONFIG where id='5478' and config='��')
  select @config5478='��'        

if @jsqk in (0,1,2,3)
begin
	select * into #brsyk from ZY_BRSYK where syxh=@syxh and brzt not in (0, 3, 8, 9)
	if @@error<>0 or @@rowcount=0
	begin
		select "F","������ҳ��Ϣ�����ڣ�"
		return
	end

	select @ybdm=ybdm, @deje=deje, @ryrq=ryrq, @rqrq=rqrq, @cqrq=cqrq, @jgbz=jgbz, @cardtype=cardtype, @brlx=brlx, 
		@zhbz=(case when @jsqk=0 and zhbz<>'' then zhbz else @zhbz end), @cardno=cardno, @jgbz=jgbz, @maxjsrq=ryrq,
		@tcljje=isnull(tcljje,0), @gbbz=gbbz, @pzh=pzh,@brzt=brzt
		from #brsyk
    --����ҳ��Ķ����ȥ�Ѿ�ʹ�õĶ���õ����ν���Ķ��� ���治���ٶ�@deje��ֵ
	--select @deje=@deje-isnull(sum(isnull(deje,0)),0) from ZY_BRJSK where syxh=@syxh and ybjszt=2
	--���ǿ������� mod by ozb 20080721
	select @deje=isnull(deje,0) from ZY_BRJSK where syxh=@syxh and xh=@jsxh
	if isnull(@deje,0)<=0 
		select @deje=0
	--tony 2003.09.16 ��Ժ���㵽����
	if @jsfs=1 and @rqbz=0
		select @cqrq=@now
	else if @jsfs=1 and @rqbz=1 and isnull(@cqrq,'')=''--add by l_jj 2012-12-22 ����Ŀ��Ժ����ʱ@jsrq=''
		select @cqrq=@jsrq
		
    --add by l_jj 2014-07-01 ����������Ժ����ʱzyts����
    if @jsfs=1 and @rqbz=1 and @brzt in (2,4) and @cqrq>@jsrq
    begin
        select @cqrq=@jsrq
    end		

	select @pzlx=pzlx, @tsrybz=tsrydm, @ybjsfs=jsfs,@rqfldm=rqfldm from YY_YBFLK where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","���߷��������ȷ��"
		return
	end

	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12'  
	and exists(select 1 from BQ_FYQQK where syxh=@syxh and jlzt=0 and qqlx<>2 and zbbz <> 1 
	and (@config5369 = '��' or (@config5369 = '��' and ispreqf <> 1)) ) 
	begin
		select "F","��������ҩƷδ�������ȷ�ҩ�ٳ�Ժ��"
		return
	end
	
	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12' 
	and exists(select 1 from BQ_SYCFMXK where syxh=@syxh and jlzt=0 and zbbz <> 1
	and (@config5369 = '��' or (@config5369 = '��' and ispreqf <> 1)) ) 
	begin
		select "F","����������ҺҩƷδ�������ȷ�ҩ�ٳ�Ժ��"
		return
	end
	
	if @jsfs=2 and @jsqk in (2,3) and @pzlx <> '12' and exists(select 1 from BQ_YJQQK where syxh=@syxh and jlzt=0
	and (@config5369 = '��' or (@config5369 = '��' and ispreqf <> 1)) )
	begin
		select "F","����ҽ����Ŀδȷ�ϣ�����ȷ���ٳ�Ժ��"
		return
	end
	SELECT @config5235=LTRIM(RTRIM(config)) FROM YY_CONFIG WHERE id="5235"
	IF @jsfs=2	-- add by gzy in 20061215
	BEGIN        
		IF (SELECT ISNULL(config,"��") FROM YY_CONFIG WHERE id="5224")="��"
		BEGIN
			IF EXISTS(SELECT 1 FROM ZY_BRJSK j WHERE j.syxh=@syxh AND j.shbz IN (0,2) AND j.jlzt=0
				AND EXISTS(SELECT 1 FROM YY_YBFLK WHERE j.ybdm=ybdm
				AND ((CHARINDEX('"'+LTRIM(RTRIM(pzlx))+'"',@config5235)>0) OR (@config5235=""))))
			BEGIN
				SELECT "F","���Ƚ��н������Ȼ���ٽ���!"
				RETURN
			END
		END
	END
	
	if @pzlx='12'
	begin
		select @tsrybz=isnull(substring(@zhbz,4,1),'0')

		--���Ӹɱ���־
		if @gbbz=1 and substring(@zhbz,2,1) in ('1','2')
			select @tsrybz='3'

		if @tsrybz='3' and @rqbz=1
		begin
			select "F","�ɱ������ݲ�֧��ѡ���ڽ��㣡"
			return
		end
	end
    --ҽ�����˼���������Ŀ�޶� add by xxl 20091214  for Ҫ��52586
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
	--ҽ�����˲�֧���ظ�Ԥ�㣡������ɶ�ν���
	if exists(select 1 from ZY_BRJSK where syxh=@syxh and ybjszt=1 ) and @pzlx='12' and @jsqk in (0,1)
	begin
		select "F","����ҽ������״̬Ϊ1�ļ�¼���޷��ٴν���,�������Ѿ�Ԥ���ˣ�"
		return
	end

	if exists(select 1 from ZY_BRJSK where syxh=@syxh and ybjszt=0) and @pzlx='12' and @jsqk in (2,3)
	begin
		select "F","���Ƚ���Ԥ���㣡"
		return
	end
  if @jsqk=0 and @pzlx="12" and exists (select 1 from YY_YBJYMX(nolock) where jsxh=@jsxh and ((ISNULL(zxlsh,'')<>'' and ISNULL(zxlsh,'')<>jslsh) or ybjszt=2))
  begin
    select "F","�ü�¼��ҽ�������ѽ��㣬�����ٴν��㣡"
    return
  end
	--W20080928  �����Ϻ�����flzfje����3λС���������¼���,��Ϊ���ǵ��������Ҵ򿪣�5241������
	-- usp_zyb_recalcjsje @syxh��@jsxh��@error F������Ϣ
	exec usp_zyb_recalcjsje @syxh,@jsxh,@returnmsg output 
	if substring(@returnmsg,1,1) = 'F'
	begin
		select "F",substring(@returnmsg,2,100)
		return
	end
	if (@pzlx = '12') and exists(select 1 from ZY_BRSYK nolock where syxh = @syxh and isnull(ylxm,'0') in ('3','4','6')) 
       and exists(select 1 from ZY_BRSYK where syxh=@syxh and substring(zhbz,12,1) = '0' )--����
	begin	                                                                                       ---��֢͸��																				
		exec usp_zyb_recalcbrfy @syxh,@jsxh,@returnmsg output                                              ---����ֲ
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
        select 'F','����ZY_BRFYMXK������־����'
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
	--����һ������Ѿ���Ժ����Ĳ��֣�������������Ŀ����Ĳ���
	--zyjslb  ��Ժ�������,0 ����, 1 ����Ŀ
	select @zje1=isnull(sum(zje),0), @zfyje1=isnull(sum(zfyje),0), @yhje1=isnull(sum(yhje),0),
		@sfje1=isnull(sum(zfje-srje),0), @zyts1=isnull(sum(zyts),0), @maxjsrq=isnull(max(jzrq),@maxjsrq),
		@flzfje1=isnull(sum(flzfje),0), 
		@lcyhje1 = isnull(sum(isnull(lcyhje,0)),0) 
		from ZY_BRJSK where syxh=@syxh and jszt=1 and ybjszt=2 and jlzt=0 and zyjslb=0 --add by ozb 20070130 and zyjslb=0

end

select * into #brjsk from ZY_BRJSK where syxh=@syxh and jszt=0 and jlzt=0
if @@rowcount=0 or @@error<>0
begin
	select "F","���߽������û�иû��߼�¼��"
	return
end
select @spzlx = a.spzlx ,@spzbz = c.spzbz from ZY_BRJSK a ,ZY_BRXXK b(nolock),YY_YBFLK c  where a.syxh=@syxh and a.jszt=0 and a.jlzt=0 and a.patid = b.patid and a.ybdm = c.ybdm
update ZY_BRJSK set spzlx = @spzlx where syxh=@syxh and jszt=0 and jlzt=0
if  @@error<>0
begin
	select "F","���»���˫ƾ֤����ʱ��"
	return
end
-- add by ydj 2005-7-21 ����˫ƾ֤��Ϣ
if @spzlx<>''
select @spzmc=name from YY_SPZLXK where id=@spzlx and xtbz=1
select @zje=zje, @zfyje=zfyje, @yhje=yhje, @flzfje=flzfje, @jsxh=xh ,@lastksrq=ksrq, 
	@lcyhje=lcyhje from #brjsk

--tony 2003.09.16 ��Ժ���㵽����
if @jsqk <> 1
begin
	select dxmdm, dxmmc, xmje, zfje, yhje, flzfje, yeje, lcyhje into #jsmxk	
		from ZY_BRJSMXK where jsxh=@jsxh
	if @@error<>0
	begin
		select "F","���㲡�˽�����ϸ����!"
		return
	end
end

--modify by Wang Yi, 2003.09.29, ���жϽ��������Ȼ���ٸ��ݽ��㷽ʽ������ʱ��
if @jsqk in (0,1,2,3)
begin
	--add by Wang Yi, 2003.09.29, �ȴ���#fymxk�Ľṹ	
	select dxmdm, zje xmje, zfje, yhje, flzfje, zje  yeje,0 lcyhje  into #fymxk	
		from ZY_BRFYMXK where 1=2
	if @@error<>0
	begin
		select "F","������ʱ��ṹʧ��!"
		return
	end

	--��������	2004.03.08	zwj
	select dxmdm, zje xmje, zfje, yhje, flzfje, zje yeje,0 lcyhje  into #fymxk1	
		from ZY_BRFYMXK where 1=2

	--tony 2003.09.16 ��Ժ���㵽���ڣ�
	--W20080928  �����Ϻ�����flzfje����3λС����ָ������2λС������Ӱ��ԭ������
	--if @jsfs=1 and isnull(@mxxh,'')<>''
	if (@jsfs=1 and @selectmx=1) --��Ժ���յ���Ŀ����
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
        -----add by sqf 20101122�󲡼���
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
			select 'F','ѡ���ʱ�����û�з��÷���'
			return
		end
         -----add by sqf 20101122�󲡼���
		select @ybjfzje = sum(zje - zfje-yhje) from ZY_BRFYMXK 
			where syxh=@syxh and zxrq<=@jsrq 
				and jsxh not in(select xh from ZY_BRJSK where syxh=@syxh and ybjszt=2 and jlzt=0 and jszt=1 and zyjslb=1)
				and isnull(jfbz,'0') = '0' 
	end
	else
	begin
		--��������ֱ��ȡ�������Ϣ	zwj 2004.03.08
		insert into #fymxk1
		select dxmdm, xmje, zfje,
			yhje, flzfje, yeje
			,isnull(lcyhje,0)
			from ZY_BRJSMXK where jsxh=@jsxh	--update by zwj 2003.12.5	ȡ�������Ϣ
/*
		select dxmdm, sum(zje) xmje, sum(round(zfdj*ypsl/ykxs,2)) zfje, 
			sum(round(yhdj*dwxs*ypsl/ykxs,2)) yhje, sum(flzfje) flzfje, sum(case when yexh>0 then zje else 0 end) yeje
			from ZY_BRFYMXK where syxh=@syxh group by dxmdm
*/
		select @ybjfzje = sum(zje - zfje-yhje) from ZY_BRFYMXK --����
			where syxh=@syxh and jsxh=@jsxh
				and isnull(jfbz,'0') = '0' 	
	end
	if @@rowcount=0
	begin
		select "F","�������ʱ����û�з������ã����ý��㣡"
		return
	end

	if @jsfs=1 and @selectmx=1 --��Ժ���յ���Ŀ����
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
		--����������ʣ�������;������Ϊ0�����������	zwj 2004.03.08
		select @zje2=0, @zfyje2=0, @yhje2=0, @flzfje2=0, @lcyhje2=0
		select @zje1=0, @zfyje1=0, @yhje1=0, @flzfje1=0, @sfje1=0, @lcyhje1=0
	end

	if @jsfs=1 and @selectmx=1 --��Ժ���յ���Ŀ����
	begin
		--mit , 2004-07-22
		insert into #fymxk1
		select a.dxmdm, a.xmje, a.zfje, a.yhje, a.flzfje, a.yeje, a.lcyhje	
		from #fymxk a
		if @@error<>0
		begin
			select "F","���㲡�˽�����ϸ����!"
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
			select "F","���㲡�˽�����ϸ����!"
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
			select "F","���㲡�˽�����ϸ����!"
			return
		end

	end
end

if @zje<0
begin
	select "F","���߷����ܶ�С�ڵ����㣬�޷����㣡"
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
	begin	--mit ,2004-7-24 , ѡ��Ԥ����Ԥ��
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

	--yxp add 2004.2.10 ��Ժ���Ժ�����סԺ�����㷨����
	if @jsfs=1 and @selectmx<>1
		select @zyts=datediff(day,substring(@ryrq,1,8),substring(@cqrq,1,8))
		+(case when substring(@ryrq,9,2)>='12' then @ts2 else @ts1 end)--��Ժ��������������һ�������
	else
		select @zyts=datediff(day,substring(@ryrq,1,8),substring(@cqrq,1,8))
		+(case when substring(@ryrq,9,2)>='12' then @ts2 else @ts1 end)
		+(case when substring(@cqrq,9,2)>='12' then @ts4-1 else @ts3-1 end)

	select @zyts=@zyts-@zyts1

	if @zyts<0 
		select @zyts=0

	if exists (select * from YY_CONFIG (nolock) where id='6384' and config='��') 
			and substring(@rqrq,1,8)=substring(@cqrq,1,8)
		select @zyts=0.5
	
	if @pzlx='12'
	begin
		select @ybje=@zje-@zfyje-@yhje
		select @strybje=str(@ybje,10,2)
		select @strybje=replicate('0',10-datalength(ltrim(rtrim(@strybje))))+ltrim(rtrim(@strybje))

		--tony 2003.09.16 ҽ������
		select @strybjsje=str(@ybje+@flzfje,10,2)
		select @strzfje=str(@zfyje-@flzfje,10,2)
        --add by sqf 20101103ҽ����������--����
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
		if @config5436='��'
		begin	
	        --ҽ�����˵����������סԺ����,������������HIS��סԺ������ͬ
	        --�й���;����Ŀ�ʼ���ڼ�һ��
	        if exists (select 1 from ZY_BRJSK(nolock) where syxh=@syxh and jszt=1 and ybjszt=2 and jlzt=0)
	            select @ybksrq=convert(char(8),dateadd(ss,1,substring(ksrq,1,8)+' '+substring(ksrq,9,8)),112) from #brjsk
	        else
	            select @ybksrq=substring(ksrq,1,8) from #brjsk
	        --�������ڣ������ԭ���㵽����Ϊ��ǰѡ���������,����Ϊ��ǰ����
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
        if @config5436='��' and @jgbz in (1,2)
            select @ybstr=substring(@ybstr,1,64)+substring(@ybstr,66,255)
		---add by sqf �����޸�
		select @ybstr = @ybstr +@strjf
	end
	else begin
		--select @ybje=@zje-@zfyje-@yhje+@zje1-@zfyje1-@yhje1
		select @ybje=@zje-@zfyje-@yhje

		/*ȡ��ʵ�ս��*/
        --wxp 20100901�Ϻ����������¹����޸�
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

		--mit, 2oo4-o7-23 , �����ֻ�Ե�ǰ�ķ�����ϸ���м���,���ü�ȥ��������Ժ������Ϣ
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
			select "F","����סԺ����������"
			return		
		end
	end   
	update ZY_BRJSK set zfje=@sfje2, srje=@srje, zyts=@zyts, jsrq=@now, jsczyh=@czyh, zhbz=@zhbz,sfksdm=@sfksdm--,ybzyts=isnull(@ybzyts,@zyts)
		where syxh=@syxh and xh=@jsxh
	if @@error<>0
	begin
		rollback tran
		select "F","����סԺ��������"
		return
	end

	commit tran
	if (select config from YY_CONFIG (nolock) where id='5023')='��'
	begin
	    if exists (select 1 from YY_CONFIG(nolock) where id='5544' and config='��')
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
			select 'Ӥ����',sum(a.yeje),sum(a.yeje),0,0,0,'' fpxmdm,0,2 ord,'','','',0, 0,'', 0,0
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
			select 'Ӥ��'+b.zyfp_mc,sum(a.yeje),sum(a.yeje),0,0,0,b.zyfp_id fpxmdm,0,2 ord,'','','',0, 0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0 group by fpxmmc, fpxmdm
				where a.yeje<>0 and a.dxmdm = b.id group by b.zyfp_mc, b.zyfp_id
			order by ord, fpxmdm
		end
	end
	else 
	begin
	    if exists (select 1 from YY_CONFIG(nolock) where id='5544' and config='��')
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
			select 'Ӥ����',sum(a.yeje),sum(a.yeje),0,0,0,'',0,2 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0
				where a.yeje<>0 and a.dxmdm = b.id
			union all
			select '�ϼ�',sum(a.xmje),sum(a.zfje-a.flzfje),0,0,0,'ZZ',sum(a.yhje),1 ord,'','','',0,0,'', 0,0
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
			select 'Ӥ��'+b.name,a.yeje,a.yeje,0,0,0,a.dxmdm,0,2 ord,'','','',0,0,'', 0,0
				from #fymxk1 a, YY_SFDXMK b (nolock)
	--			where jsxh=@jsxh and yeje<>0
				where a.yeje<>0 and a.dxmdm = b.id
			union all
			select '�ϼ�',sum(a.xmje),sum(a.zfje-a.flzfje),0,0,0,'ZZ',sum(a.yhje),1 ord,'','','',0,0,'', 0,0
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
		select "F","����סԺ��������"
		return		
	end

	delete ZY_BRJSJEK where jsxh=@jsxh
	if @@error<>0
	begin
		rollback tran
		select "F","����סԺ����������"
		return		
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '01', '�𸶶ε����˻�֧��', @qfdnzhzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '02', '�𸶶������ʻ�֧��', @qflnzhzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '03', '�𸶶��ֽ�֧��', @qfxjzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '04', 'ͳ��������ʻ�֧��', @tclnzhzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '05', 'ͳ����ֽ�֧��', @tcxjzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '06', 'ͳ���ͳ��֧��', @tczfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '07', '���Ӷ������ʻ�֧��', @fjlnzhzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '08', '���Ӷ��ֽ�֧��', @fjxjzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '09', '���Ӷεط�����֧��', @dffjzfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end
----add by sqf 20101103
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '10', '��Ѫ��ϸ�������Ը�', @zxgxbgrzf, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, '11', '�󲡼������', @dbjfje, null)
	if @@error<>0
	begin
		select "F","�������1��Ϣ����"
		rollback tran
		return
	end
	commit tran
	select "T",@sfje2
	return
end
else begin
	--����Ԥ����
	--�������Ѿ���ǰ������������ֱ��ȡ�����Ķ�����
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
				and b.spzbz = '2')  -- ˫ƾ֤��־ 0 �� 1 �ʵ��Ż� 2 ������ѧ��
	begin
		select @ebzfje = je from ZY_BRJSJEK where jsxh = @jsxh and lx = '25'
		select @xbzfje = je from ZY_BRJSJEK where jsxh = @jsxh and lx = '26'
	end
	if @rqfldm='04' --����
		select @ebzfje=(case when @jsfs=1 and @rqbz=1 then @zje else zje end)+srje-
               (case when @jsfs=1 and @rqbz=1 then @yhje else yhje end)
               -zfje  from ZY_BRJSK nolock where syxh=@syxh and xh=@jsxh
	if @rqfldm='06' --ѧ��
		select @xbzfje=(case when @jsfs=1 and @rqbz=1 then @zje else zje end)+srje-
               (case when @jsfs=1 and @rqbz=1 then @yhje else yhje end)
               -zfje  from ZY_BRJSK nolock where syxh=@syxh and xh=@jsxh
	select @ebzfje = isnull(@ebzfje,0),@xbzfje = isnull(@xbzfje,0)
	--add by ozb 20080731 ���ӱ������ѧ������֧���������·�Ʊ��ӡ
	if not exists(select 1 from ZY_BRJSJEK where jsxh = @jsxh and lx = '25')
	begin
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, '25', '(����ѧ��)�ٶ�סԺ����֧��', @ebzfje, null)
		if @@error<>0
		begin
			select "F","�������1��Ϣ����"
			rollback tran
			return
		end
	end
	if not exists(select 1 from ZY_BRJSJEK where jsxh = @jsxh and lx = '26')
	begin
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, '26', '(����ѧ��)�ٶ�ѧ��ҽ�Ʊ���֧��', @xbzfje, null)
		if @@error<>0
		begin
			select "F","�������1��Ϣ����"
			rollback tran
			return
		end
	end

	if (select config from YY_CONFIG (nolock) where id='5029')='��'
	begin
--		if @jsfs=1 and @yjlj+@jsje<@sfje2
		if @jsfs=1 and (@yjlj + @jsje_bsxj + @jsje_bszp) <@sfje2
		begin
			select "F","��Ժ����Ԥ�����㣬���Ȳ���Ԥ�����ٽ�����Ժ���㣡"
			return
		end
	
		if @jsqk=3 and @jsfs=1
		begin
			select "F","��Ժ���㲻����Ƿ�"
			return
		end
	end

--	if @jsqk=3 and @yjlj+@jsje>=@sfje2
  if @config5320='��'
  begin
	  if @jsqk=3 and (@yjlj + @jsje_bsxj + @jsje_bszp) >=@sfje2
	  begin
		  select "F","����֧��������Ӧ�����������������Ժ��"
		  return
	  end
  end

	declare @jsje_xj ut_money,	--�˿���ֽ�
			@jsje_zp ut_money,	--�˿��֧Ʊ��
			@yje	 ut_money,	--Ѻ�����
			@czym ut_mc64,		--����Ա��
			@qkbz smallint,		--Ƿ���־
			@qkje ut_money,		--Ƿ����
			@hzxh ut_xh12,		--�������
			@fph1 bigint,			--��Ʊ��
			@maxxh ut_xh12		--����ZY_BRFYMXK.xh
			,@jsje_xjtmp ut_money	--�˿����ݴ棨�ֽ�
			,@jsje_zptmp ut_money	--�˿����ݴ棨֧Ʊ��
			 
	select @czym=name from czryk where id=@czyh
	select @jsje_xj=0, @jsje_zp=0, @yje=@yjlj, @qkbz=0, @qkje=0,@fph1=0

	--��Ժ����
	if @config5309='��'
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
					--===========================��Ժ�����˿�����begin==================
			    if @config5478 = '��'
			    begin
		            select @jsje_xjtmp=tkje,@skfs_xj=zffs From ZYB_BRTKZCK where jsxh =@jsxh and tkfs=0
		            select @jsje_xjtmp=ISNULL(@jsje_xjtmp,0)
		            select @jsje_zptmp=tkje,@skfs_zp=zffs From ZYB_BRTKZCK where jsxh =@jsxh and tkfs=1	
		            select @jsje_zptmp=ISNULL(@jsje_zptmp,0)
		            
                    if (@jsje_zp+@jsje_xj)<>(@jsje_xjtmp+@jsje_zptmp)
                    begin
                        select 'F',"�����˽���ȣ�������¼���˽�����"
                        return
                    end	
                    else
                    begin
                        select @jsje_xj=@jsje_xjtmp,@jsje_zp=@jsje_zptmp
                    end
			    end
			    --================��Ժ�����˿�����end==========================
			end
			else
			begin
				--add by ozb 20080630 ���Ԥ���Ƿ�������Ԥ�����,ֱ��ͨ����̨�������˿�
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

		--��Ժ����
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
		select @qkbz=1, @qkje=@sfje2-@yjlj-@jsje_bsxj-@jsje_bszp --@config5320Ϊ�ǵ������qkje�����и�,�����ǽ�����,�����ǽ�����

	--�����˷����»���
	if @jsqk=3
--		select @yjlj=@yjlj+@jsje
		select @yjlj=@yjlj+@jsje_bsxj + @jsje_bszp
	else
		select @yjlj=@sfje2

	select * into #brfyyhz from ZY_BRFYYHZ where syxh=@syxh and jsxh=@jsxh and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select "F","סԺ���˵�ǰ�����»��ܼ�¼�����ڣ�"
		return
	end
	
	select dxmdm, sum(xmje) xmje, sum(zfje) zfje, sum(yhje) yhje, sum(isnull(lcyhje,0)) lcyhje into #hzmxk
		from ZY_BRFYYMX a where exists(select 1 from ZY_BRFYYHZ b where b.syxh=@syxh 
		and b.jsxh=@jsxh and b.jlzt>0 and a.hzxh=b.xh)
		group by dxmdm
	if @@error<>0
	begin
		select "F","���㲡�˷�������ϸ����!"
		return
	end

-- 	select dxmdm, dxmmc, xmje, zfje, yhje into #jsmxk
-- 		from ZY_BRJSMXK where jsxh=@jsxh
-- 	if @@error<>0
-- 	begin
-- 		select "F","���㲡�˷�������ϸ����!"
-- 		return
-- 	end

	--tony 2003.09.16 ��Ժ���㵽����
	if @jsfs=1 and @rqbz=1
	begin
		--��Ժ����ѡ���ں�ʣ��Ľ�����ϸ 
    --sql2012 yfq
    select a.dxmdm, a.xmje-isnull(b.xmje,0) xmje, a.zfje-isnull(b.zfje,0) zfje, a.yhje-isnull(b.yhje,0) yhje,
				a.flzfje-isnull(b.flzfje,0) flzfje, a.yeje-isnull(b.yeje,0) yeje, a.lcyhje-isnull(b.lcyhje,0) lcyhje
		into #jsmxk2
		from #jsmxk a
    left join  #fymxk1 b on a.dxmdm=b.dxmdm
		if @@error<>0
		begin
			select "F","���㲡�˽�����ϸ����!"
			return
		end

		delete #jsmxk
		if @@error<>0
		begin
			select "F","���㲡�˽�����ϸ����!"
			return
		end

		--��Ժ����ѡ���ڵĽ�����ϸ
		insert into #jsmxk(dxmdm, dxmmc, xmje, zfje, yhje, flzfje, yeje, lcyhje)	
		select a.dxmdm, b.name, a.xmje, a.zfje, a.yhje, a.flzfje, a.yeje, a.lcyhje
		from #fymxk1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error<>0
		begin
			select "F","���㲡�˽�����ϸ����!"
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
		select "F","���㲡�˷�������ϸ����!"
		return
	end
	--add by ozb begin 2007-11-11 �´�ӡģʽ�¸��ݴ洢���̷��صĴ�ӡ��־usp_zy_getfpprintflag�����Ƿ��ӡ
	if @nconfigdyms=1
	begin
		select @printjsfp=1	--ozb 2007-12-03 �·�Ʊģʽ�£���������߷�Ʊ
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
		if exists (select 1 from YY_CONFIG (nolock) where id='5204' and config='��') and @jsqk=3
			select @printjsfp=1
		else --mod by ozb 20071222 5230ԭ���� ���ǡ� �� ���񡱣����ڸ�Ϊҽ������ ע��config��û������
		if exists (select 1 from YY_CONFIG where id='5230' and charindex(','+ltrim(rtrim(@ybdm))+',',','+ltrim(rtrim(config))+',')>0) and @sfje2<=0
		--if exists (select 1 from YY_CONFIG (nolock) where id='5230' and config='��') and @sfje2<=0
			select @printjsfp=1
	end
	--add by ozb end 2007-11-11 �´�ӡģʽ�¸��ݴ洢���̷��صĴ�ӡ��־�����Ƿ��ӡ

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
			select "F","��������տ����"
			return
		end
	end
*/

-- 20151014 add kcs �����Żݼ�¼��Ϣ ����jlzt beign
    if exists(select 1 from YY_HZYHFSJLK_ZY where syxh = @syxh and jsxh = @jsxh)
    begin
        update YY_HZYHFSJLK_ZY set jlzt = '2' where syxh = @syxh and jsxh = @jsxh
        if @@ERROR <> 0 
        begin
            rollback tran
            select 'F','���»����Żݷ�ʽ��¼��Ϣ����'
            return
        end
    end
--end

	if @jsje_bsxj>0 and @config5309='��'
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
				select "F","��������տ����"
				return
			end
		end
	end
	if @jsje_bszp>0 and @config5309='��'
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
				select "F","��������տ����"
				return
			end
		end
	end

	if @jsje_xj>0 and @config5309='��'
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
				select "F","��������˿����"
				return
			end
		end
	end

	if @jsje_zp>0 and @config5309='��'
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
				select "F","��������˿����"
				return
			end
		end
	end
	if @config5309='��' 
    begin

--================�˳�ֵ��begin===add by yjn 2015-07-17================

		if (exists (select xh From ZYB_BRYJZCK where zffs='6' and jsxh=@jsxh)) and ((@jsfs = 2) or ((@jsfs = 1) and (@yjejz = 0)))
		begin
			declare @tmpcardno ut_cardno
			select @tmpcardno=cardno From ZY_BRSYK where syxh=@syxh
			
			if @tmpcardno='' 
			begin
			    rollback tran
			    select 'F','����Ϊ�ղ����˳�ֵ��'			    
			    return
			end
			
			if  exists(select xh From YY_JZBRK where cardno=@tmpcardno and (jlzt=1 or gsbz=1))
			begin
			    rollback tran
				select 'F','�ò��˿����Թ�ʧ�����ϣ����������'
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
							select "F","���¼��˲��˿�Ԥ����������"
							return
						end
							
						update SF_BRXXK set zhje=@sjyjye where patid=@tmppatid
						
						if @@error<>0
						begin
						    rollback tran
							select "F","����SF_BRXXK�˻�������"							
							return
						end
						
						insert YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,  
							zffs,czlb,hcxh,jlzt,memo,sjh,ybdm)  
						values(0,0,@jzxh,@czyh,@czym,@now,@czkje,0,@sjyjye,  
							6,0,null,0,'סԺ�˿�',@jsxh,@ybdm)
						if @@error<>0 or @@rowcount=0  
						begin 
						    rollback tran   
							select "F","�����ֵ��Ԥ������Ϣʱ����"  							
							return  
						end 											
					end		
					if @czkjje>0 
					begin
					    if @yjye-@czkjje<0
					    begin
					        select 'F','�����:'+convert(varchar(20),@yjye)+',���㲻�ܿۿ�!'
							rollback tran
							return					     
					    end 
										
						update YY_JZBRK set yjye=yjye-@czkjje
							   ,@jzxh=xh,@sjyjye=yjye-@czkjje
							--,@sjyjye=yjye+@xjje_old, @sjdjje=djje
						where patid=@tmppatid and jlzt=0
							
						if @@error<>0
						begin
							select "F","���¼��˲��˿�������"
							rollback tran
							return
						end
							
						update SF_BRXXK set zhje=@sjyjye where patid=@tmppatid
						
						if @@error<>0
						begin
						    rollback tran  
							select "F","����SF_BRXXK�˻�������"						
							return
						end
						
						insert YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,  
							zffs,czlb,hcxh,jlzt,memo,sjh,ybdm)  
						values(0,0,@jzxh,@czyh,@czym,@now,@czkjje,0,@sjyjye,  
							1,3,null,0,'ת��סԺԤ����',@jsxh,@ybdm)
						if @@error<>0 or @@rowcount=0  
						begin 
						    rollback tran   
							select "F","����ۿ���Ϣʱ����"  							
							return  
						end 											
					end																																	
				end	else
				begin
				    rollback tran  
					select "F","�ò���û�����ó�ֵ�����ܣ������˳�ֵ�����ˣ�"  					
					return
				end
			end                
		end												
	--===================�˳�ֵ��end========================

		insert into ZYB_BRYJK(fpjxh, fph, syxh, czyh, czym, lrrq, jje, dje, yje, zffs, khyh, zph, 
		czlb, jsxh, hcxh, jlzt, jszt, memo,sfksdm)
		select 0,0,@syxh,@czyh,@czym,@now,jje,dje,yje,zffs,khyh,zph,
		case when dje>0 and @jsfs=1 then 3 else 2 end,@jsxh,null,0,0,'��������',@sfksdm
		from ZYB_BRYJZCK where jsxh=@jsxh
		if @@error<>0
		begin
			rollback tran
			select "F","��������˿����"
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
			select "F","����Ԥ�����վݳ���"
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
			select "F","����Ԥ�����վݳ���"
			return
		end
	end

	--����סԺ���˽����
	if @dfpbz=0 
	begin
		/* del by ozb 2007.11.11 �Ƶ�����ǰ�жϣ������жϽ���޸ı���@printjsfp
		if exists (select 1 from YY_CONFIG (nolock) where id='5204' and config='��') and @jsqk=3
		begin
			select @fph=0, @fpjxh=0
		end
		else
		if exists (select 1 from YY_CONFIG (nolock) where id='5230' and config='��') and @sfje2<=0
		begin
			select @fph=0, @fpjxh=0
		end	*/ 
		if @printjsfp=1	--����ӡ���㷢Ʊ
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
					select "F","סԺ��Ʊ���ɴ���"
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
						select "F","û�п���סԺ��Ʊ��"
						return
					end
				end
				else
				begin
					select @fph=fpxz, @fpjxh=xh from SF_FPDJK where jlzt=1 and xtlb=2 and xh=@fpkxh
					if @@rowcount=0
					begin
						rollback tran
						select "F","û�п���סԺ��Ʊ��"
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
			select "F","������������"
			return
		end

		select @xhtemp=@@identity

		if (select config from YY_CONFIG where id='5015')='��'
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
					select "F","������㷢Ʊ��ϸ����"
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
					select "F","������㷢Ʊ��ϸ����"
					return
				end
			end
		end
	end
	else
		select @fph=0, @fpjxh=0
	--��Ժ����ѡ���ڵķ�ʽ���������ɽ�����ϸ
	if (@jsfs=1 and @rqbz=1)
	begin
		delete from ZY_BRJSMXK where jsxh = @jsxh
		if @@error <> 0 
		begin
			rollback tran
			select "F","ɾ�����˽�������"
			return		
		end
		insert into ZY_BRJSMXK(jsxh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje, memo, flzfje, lcyhje)
		select @jsxh, a.dxmdm, b.name, b.zyfp_id, b.zyfp_mc, a.xmje, a.zfje, a.yhje, a.yeje, null, a.flzfje, a.lcyhje
			from #fymxk1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error <> 0 
		begin
			rollback tran
			select "F","���벡�˽�������"
			return		
		end
	end
	
	--add by gxf 2008-9-27  ����ǳ�Ժ����ʱ���²��˶�Ӧ��λ��zcbz=0��syxh=null
	if @jsfs = 2
	begin
		if @nconfigupdatezcbz = 1
		begin
			update ZY_BCDMK set zcbz = 0,syxh = null where syxh = @syxh
			if @@error<>0
			begin
				rollback tran
				select "F","���²��˽�������"
				return
			end
		end
	end
	--add by gxf 2008-9-27  ����ǳ�Ժ����ʱ���²��˶�Ӧ��λ��zcbz=0��syxh=null��cqrq=''     
     
	update ZY_BRJSK set jszt=@jsfs, ybjszt=2, jsrq=@now, jsczyh=@czyh, zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
		qfbz=@qkbz, qfje=@qkje, deje=@deje-@deje1, fph=@fph, fpjxh=@fpjxh
		,ylcardno=@ylcardno,ylksqxh=@ylksqxh,ylkzxlsh=@ylkzxlsh	--mit ,, 2oo3-o5-o8 ,, ������
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
	if @@error<>0 and @@rowcount<>1 --�����жϸ�������,������1ʱ���� 
	begin
		rollback tran
		select "F","���²��˽�������"
		return
	end

	--����סԺ�����»���
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
		select "F","���²��˷����»��ܳ���!"
		return
	end

	delete ZY_BRFYYMX where hzxh=@hzxh
	if @@error<>0
	begin
		rollback tran
		select "F","���²��˷�������ϸ����!"
		return
	end

	insert into ZY_BRFYYMX(hzxh, dxmdm, dxmmc, xmje, zfje, yhje, memo, lcyhje)
	select @hzxh, dxmdm, dxmmc, xmje, zfje, yhje, null, lcyhje from #jsmxk where xmje<>0 or zfje<>0 or yhje<>0
	if @@error<>0
	begin
		rollback tran
		select "F","���²��˷�������ϸ����!"
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
			select "F","���ɲ��˽�������!"
			return
		end

		select @xhtemp=@@identity
		--mit ,2004-7-22, ��Ϊѡ������Ԥ�����Ϊ�¸��������
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
				select "F","���ɲ��˽�����ϸ�����!"
				return
			end

			/*update ZY_BRFYMXK set jsxh=@xhtemp where syxh=@syxh and xh>@maxxh
			if @@error<>0
			begin
				rollback tran
				select "F","���²��˷�����ϸ�����!"
				return
			end
			*/

			--mit , 2004-7-24, ����Ŀ����
			--if isnull(@mxxh,'')=''
			if @selectmx=0 ----cjt bug187917 ����Ŀ���㽫�Ѿ������jsxh�������� 
			begin
				update ZY_BRFYMXK set jsxh=@xhtemp where syxh=@syxh and ((xh>@maxxh) or (xh<@maxxh and zxrq>@jsrq )) and
			    jsxh not in (select xh from ZY_BRJSK a where a.syxh=@syxh and a.ybjszt=2 and  a.jlzt = '0' and a.jsrq<>@now )
				if @@error<>0 
				begin
					rollback tran
					select "F","���²��˷�����ϸ�����!"
					return
				end
			end
			else
			begin
				--mit, ����Ŀ����ʱ��������ν�����Ŀ���������е�ǰ������ŵ���Ϊ�µĽ������
				select @strsql=' update ZY_BRFYMXK set jsxh='+ convert(varchar(16),@xhtemp)
						+ ' where syxh=' + convert(varchar(16),@syxh) 
						+ ' and jsxh=' + convert(varchar(16),@jsxh)
						--+ ' and xh not in' + @mxxh
						+ ' and xh not in (select xh from #mxxh_tt)'
				exec(@strsql)
				if @@error<>0
				begin
					rollback tran
					select "F","���²��˷�����ϸ�����!"
					return
				end
			end
		end

		select @yje=0
		if (select config from YY_CONFIG (nolock) where id='5017')='��'
			select @print=1
		else
			select @print=0

        --modify by dn 2003.11.10
        select @yjejz=0 
        if (select config from YY_CONFIG (nolock) where id ='5054')='��'
                select @yjejz=1  --����
        else   
                select @yjejz=0  --��ת
		
		--modify by jjw 2005-02-19
		if @jsfs=1 and (select config from YY_CONFIG (nolock) where id='5184')='��'
		begin
			if @isztjz=1 select @yjejz=0   --��ת
			else select @yjejz=1		   --����
		end
		--if @yjejz=1  --����
		begin
			if @jsqk in (1,2,3) 
			begin
				if  @jsjein_tzp<>0 and @skfs_zp='S'
				begin
					if @yjejz=1  --����
					begin 
						select "F","�뵽Ԥ�����������[S-����֧������]������." 
					end
					else
					begin 
						select "F","[S-����֧������]Ԥ�����ܽ��н�ת�����ȵ�Ԥ���������." 
					end
					rollback tran 
					return 
				end
			end
		end 
        if @config5309='��'
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
							select "F","û�п���Ԥ�����վݣ�"
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
							select "F","û�п���Ԥ�����վݣ�"
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

				if @yjejz=1 --����
				begin
				  update ZYB_BRYJK set czlb=2 where czlb=3 and jsxh=@jsxh and syxh=@syxh
				   -- select @yjejz=1
				end
				else --��ת
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
						select "F","�����תԤ�������"
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
							select "F","û�п���Ԥ�����վݣ�"
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
							select "F","û�п���Ԥ�����վݣ�"
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

				if @yjejz=1 --����
				begin
				  update ZYB_BRYJK set czlb=2 where syxh=@syxh and czlb=3 and jsxh=@jsxh
				   -- select @yjejz=1
				end
				else --��ת
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
						select "F","�����תԤ�������"
						return
					end

					select @jsje_zp=0
				end
			end
		end
		else
		begin
		    if @yjejz=1 --����
		    begin
			  update ZYB_BRYJK set czlb=2 where syxh=@syxh and czlb=3 and jsxh=@jsxh
			   -- select @yjejz=1
		    end
		    else --��ת
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
						select "F","û�п���Ԥ�����վݣ�"
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
							select "F","û�п���Ԥ�����վݣ�"
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
				      select "F","�����תԤ�������"
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
			select "F","���ɲ��˷����»��ܳ���!"
			return
		end
	end
	else begin
	    if @jsqk in (1,2,3) 
		begin
			if  @jsjein_tzp<>0 and @skfs_zp='S'
			begin  
				select "F","�뵽Ԥ�����������[S-����֧������]������."  
				rollback tran 
				return 
			end
		end

        ---�����жϣ��������5009Ϊ�ǣ����Ժ���ڲ��ܸ���Ϊ��ǰ���� add by sqf 20100916 ID76047
        if exists(select 1 from YY_CONFIG where id ='5009' and config = '��')
			update ZY_BRSYK set cyrq=cqrq, brzt=3, jgbz=(case @jgbz when 1 then 2 else 0 end),gxrq=@now where syxh=@syxh
		else
			update ZY_BRSYK set cyrq=@now, brzt=3, jgbz=(case @jgbz when 1 then 2 else 0 end),gxrq=@now where syxh=@syxh
		if @@error<>0
		begin
			rollback tran
			select "F","���˳�Ժʱ����!"
			return
		end
		--koala ,2004-11-26, ��Ϊδѡ������Ԥ�����Ϊ-1
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
		select "F","����˰����Ϣʱ����"
		return
	end

	--��ҽ������δ���³ɹ�ʱ���±��ؼ�¼
	update YY_YBJYMX set zxlsh=@zxlsh, ybjszt=2 where zxlsh=@jslsh
	if @@error<>0
	begin
		select "F","����ҽ��������ϸ����"
		rollback tran
		return
	end

	if ltrim(rtrim(isnull(@spzbz,'0'))) <> '1'
		select @spzlx = ''
	--20030219 ���Ӷ�Ƿ��˵Ĵ���
	select @qqqklj=(select isnull(sum(qfje),0) from ZYB_QFBRJLK where syxh=@syxh and jlzt=0) 
	if @jsqk=3 
	begin
		insert into ZYB_QFBRJLK (jsxh,syxh,hzxm,zje,zfje,yjje,qfje,dbr,dbrxm,dbrdh,dbrks,czyh,lrrq,jlzt)
		select @jsxh,s.syxh,s.hzxm,@zje,@zfyje,@yjlj,@qkje,s.lxr,s.lxr,lxrdh,null,@czyh,@now,0
		from ZY_BRSYK  s
		where s.syxh = @syxh
	end

	--2007-07-11 ���ӶԴ��ҿ��Ĵ���ʼ
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
		--���ν��㣬czlb = 2,��֧����ʽ = 4 �Ĺ�Ϊ���ҿ�֧��
		select @yjkxh = xh from ZYB_BRYJK nolock
			where syxh=@syxh and jsxh=@jsxh and czlb = 2 and zffs = '4'

		update YY_CARDXXK set yjye=yjye-@dbkje,zjrq=substring(@now,1,8)
		where kxh=@dbkxh and jlzt=0
		if @@error<>0
		begin
			select "F","���´��ҿ������ʻ�������"
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
			select "F","���´��ҿ��������"
			return
		end
	end
	--2007-07-11 ���ӶԴ��ҿ��Ĵ���ʼ����
	--2007-07-13 �޸���Ϣ���ͳ���ۼƽ��
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
		select "F","������Ϣ���ͳ���ۼƽ�����"
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
				select "F","����YY_BRLJXXK��ͳ���ۼƽ�����"
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
		,@tsyhje,@sfje2+@tsyhje+@tsyhje2,@sfje2+@tsyhje-@zfyje,@spzlx,@spzmc,@gbje ,@ysybzfje,  --17-23  �����Żݽ��/�Ż�ǰ�ֽ���/
		case when @gbbz = '0' then @dyzfyje else @gbzfje2 end -- 24
		,@ebzfje,@xbzfje,@rqfldm,@skfs_xjmc,@skfs_zpmc  --25-27,28,29
		,@lcyhje,@zplj,@xjlj,@zje - @lcyhje as lczje,@lcyhje	--30-34
	return
end
go
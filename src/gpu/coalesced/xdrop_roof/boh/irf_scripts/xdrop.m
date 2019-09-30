clear all
clc
dir='/Users/nanding/0-Mywork/4-cuda/xDrop/xdrop-'
name='_extendSeedLGappedXDropOneDirectionShared.csv'

%memBW=900 %B/s
l1=14*1e3; %B/s
l2=2.9968*1e3; %B/s
memBW=828;

%peakiop=80*4*1*1.53;% ops
peakiop=80*4*1.38;
int_peakiop=80*4*1.38*0.5;
ldst_peakiop=peakiop*0.25


% peakiop=1.57*1e4 % ops
% empeakiop=80*64*1.48*2

Tsize=32;
%exabiom-SW
%xval=[100 500 1000 2500 5000]
%time=[1.70084 2.37950 2.84574 3.58964 4.06058]
xval=[100 500 1000 2500 5000]
time=[1.70084 2.37950 2.84574 3.58964 4.06058]
color=['r' 'b' 'g' 'm' 'k']
idx=1
cases=0
startcol=3

%for xval_i=xval
%STR=sprintf('%s%d%s',dir,xval_i,name)   
%share_ld(idx)=csvread(STR,15,startcol,[15,startcol,15,startcol+cases]);
%share_st(idx)=csvread(STR,16,startcol,[16,startcol,16,startcol+cases]);
%conf_ld(idx)=csvread(STR,32,startcol,[32,startcol,32,startcol+cases]);
%conf_st(idx)=csvread(STR,33,startcol,[33,startcol,33,startcol+cases]);
%idx=idx+1
%end
%
%y=share_ld+share_st
%y1=conf_ld+conf_st
%r=y1./y
%bar(r)

 
 
ceilings L1
 c=1;
 flag=0;
 x=logspace(-3,3);
 for i=1:length(x);
     if l1*x(i) < peakiop
         ceiling2(c)=l1*x(i);
     else
         if flag==0
             minempirical=x(i-1);
             flag=1;
         end
         ceiling2(c)=peakiop;
     end
     c=c+1;
 end
 
 loglog(x,ceiling2,'k-','linewidth',2);
 hold on
 
 
 % ceilings HBM
 c=1;
 for i=1:length(x);
     if memBW*x(i) < peakiop;
         ceiling1(c)=memBW*x(i);
     else
         ceiling1(c)=peakiop;
     end
     c=c+1;
 end
 
 
 loglog(x,ceiling1,'k-','linewidth',2);
 hold on
 
 
 
 %ceilings L2
 memBW=l2;
 c=1;
 for i=1:length(x);
     if memBW*x(i) < peakiop
         ceiling4(c)=memBW*x(i);
     else
         ceiling4(c)=peakiop;
     end
     c=c+1;
 end
 
 loglog(x,ceiling4,'k-','linewidth',2);
 hold on
 
 % overall empirical ceiling
 
 % 
 % xx=logspace(log10(minempirical/6),3);
 % for i=1:length(xx);
 %     ceiling5(i)=ldst_peakiop
 % end
 % 
 % loglog(xx,ceiling5,'b-','linewidth',2);
 % hold on
 
 for xval_i=xval
 STR=sprintf('%s%d%s',dir,xval_i,name)   
 inst_integer=csvread(STR,1,startcol,[1,startcol,1,startcol+cases]);
 inst_ldst=csvread(STR,2,startcol,[2,startcol,2,startcol+cases]);
 fstlevelByte=Tsize.*(csvread(STR,18,startcol,[18,startcol,18,startcol+cases])+csvread(STR,17,startcol,[17,startcol,17,startcol+cases])+csvread(STR,16,startcol,[16,startcol,16,startcol+cases])+csvread(STR,13,startcol,[13,startcol,13,startcol+cases])+csvread(STR,14,startcol,[14,startcol,14,startcol+cases])+csvread(STR,15,startcol,[15,startcol,15,startcol+cases]))
 scndlevelByte=Tsize.*(csvread(STR,19,startcol,[19,startcol,19,startcol+cases])+csvread(STR,20,startcol,[20,startcol,20,startcol+cases]))
 dramlevelByte=Tsize.*(csvread(STR,22,startcol,[22,startcol,22,startcol+cases])+csvread(STR,21,startcol,[21,startcol,21,startcol+cases]))
 
 colorplot=[color(idx),'square']
 colorplot_1=[color(idx),'>']
 colorplot_2=[color(idx),'o']
 
 inst_tot=(inst_integer+inst_ldst)/32;
 
 fstAI=(inst_tot)./fstlevelByte
 scndAI=(inst_tot)./(scndlevelByte)
 dramAI=(inst_tot)./(dramlevelByte)
 
 int_inst_tot=inst_integer./32
 int_fstAI=(int_inst_tot)./fstlevelByte
 int_scndAI=(int_inst_tot)./(scndlevelByte)
 int_dramAI=(int_inst_tot)./(dramlevelByte)
 
 fp_inst_tot=inst_ldst./32
 fp_fstAI=(fp_inst_tot)./fstlevelByte
 fp_scndAI=(fp_inst_tot)./(scndlevelByte)
 fp_dramAI=(fp_inst_tot)./(dramlevelByte)
  
 %lemark=sprintf("%s%d",'p',idx)
 %lemark=sprintf("%s%d",'pp',idx)
 %lemark=sprintf("%s%d",'ppp',idx)
 
 % p1=loglog((fstAI),(inst_tot./1e9/time(idx)),'ksquare','MarkerFaceColor','k','MarkerSize',10)
 % hold on
 % p2=loglog((scndAI),(inst_tot./1e9/time(idx)),'k>','MarkerFaceColor','k','MarkerSize',10)
 % hold on
 % p3=loglog((dramAI),(inst_tot./1e9/time(idx)),'ko','MarkerFaceColor','k','MarkerSize',10)
 % hold on
 
 p4(idx)=loglog((int_fstAI),(int_inst_tot./1e9/time(idx)),colorplot,'MarkerFaceColor',color(idx),'MarkerSize',10)
 hold on
 p5(idx)=loglog((int_scndAI),(int_inst_tot./1e9/time(idx)),colorplot_1,'MarkerFaceColor',color(idx),'MarkerSize',10)
 hold on
 p6(idx)=loglog((int_dramAI),(int_inst_tot./1e9/time(idx)),colorplot_2,'MarkerFaceColor',color(idx),'MarkerSize',10)
 hold on
 
 % p4(idx)=loglog((fp_fstAI),(fp_inst_tot./1e9/time(idx)),'bsquare','MarkerFaceColor','b','MarkerSize',10)
 % hold on
 % p5(idx)=loglog((fp_scndAI),(fp_inst_tot./1e9/time(idx)),'b>','MarkerFaceColor','b','MarkerSize',10)
 % hold on
 % p6(idx)=loglog((fp_dramAI),(fp_inst_tot./1e9/time(idx)),'bo','MarkerFaceColor','b','MarkerSize',10)
 % hold on
 
  xx=logspace(log10(minempirical/5),3);
 for i=1:length(xx);
     ceiling3(i)=fstlevelByte/4/32/1e9
 end
 
 loglog(xx,ceiling3,'r-','linewidth',2);
 hold on
 
 idx=idx+1
 
 
 end
 
 x=0;
 y=0
 t1=loglog(x,y,'ksquare','MarkerSize',10)
 hold on
 t2=loglog(x,y,'k>','MarkerSize',10)
 hold on
 t3=loglog(x,y,'ko','MarkerSize',10)
 %y=[fstAI,scndAI] 
 legend([t1(1),t2(1),t3(1), p4(1),p4(2),p4(3),p4(4),p4(5)],'L1','L2','HBM','v=100','v=500','v=1000','v=2500','v=5000','Location','southeast','Orientation','vertical','FontName', 'Times New Roman','FontSize',16)
 %legend([p1(1),p2(1),p3(1),p4(1),p5(1),p6(1),p7(1),p8(1),p9(1)],'L1 TOT','L2 TOT','HBM TOT','L1 INT32','L2 INT32','HBM INT32','L1 LDST','L2 LDST','HBM LDST','Location','southeast','Orientation','vertical','FontName', 'Times New Roman','FontSize',16)
 
 xlabel('Instuction Intensity [Inst/Byte]') 
 ylabel('Performance [GInst/sec]') 
 % 
 % ht = text(-3.6,-1,'HBM 900GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',35);
 % ht = text(-4.2,-1,'L2 4000GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',35)
 % ht = text(-1.8,2,'L1 14000GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',35)
 % 
 %text(minempirical*10,peakiop*2,'Peak #inst/sec: 489.6 GInst/s','FontSize', 16,'FontName','Times New Roman');
 text(minempirical/20,peakiop/2,'Empirical Peak #TOT inst/sec: 331.2 GInst/s','FontSize', 16,'FontName','Times New Roman');
 text(minempirical/20,peakiop/2,'Empirical Peak #INT inst/sec: 220.8 GInst/s','FontSize', 16,'FontName','Times New Roman');
 text(minempirical/20,peakiop/2,'Empirical Peak #LDST inst/sec: 110.4 GInst/s','FontSize', 16,'FontName','Times New Roman');
 % 
 % 
 % 
 ht = text(minempirical/200,2,'HBM 828GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30);
 ht = text(minempirical/300,25,'L2 2996.8GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30)
 ht = text(minempirical/300,90,'L1 14000GB/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30)
 
 % 
 set(gca,'FontSize',16)
 set(gca,'FontName','Times New Roman') 






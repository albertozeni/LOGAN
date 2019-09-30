clear all
clc
dir='/Users/nanding/0-Mywork/4-cuda/xDrop/xdrop-'
name='_extendSeedLGappedXDropOneDirectionShared.csv'

%memBW=900 %B/s
l1=14*1e3; %B/s
l2=2.9968*1e3; %B/s
memBW=828;

%peakiop=80*4*1*1.53;% ops
int_peakiop=80*4*1.38*0.5;
ldst_peakiop=80*4*1.38*0.25
% peakiop=1.57*1e4 % ops
% empeakiop=80*64*1.48*2
peakiop=int_peakiop;

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

 
 
%ceilings L1
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
 

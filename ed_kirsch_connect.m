 % 函数名: ed_kirsch_connect
 % 功能简介: hough变换提取边缘
 % 输入参数:
 %  half_img_h: 图像高度的中线
 %  half_img_w: 图像宽度的中线
 %  ed_kir: kirsch边缘, 即kirschEdge函数的输出结果
 %  im_bi: 对候选图像进行双边滤波后的结果
 %  th_area: 常数, 一般取值为50
 %  dis_thresh: 常数, 距离阈值, 一般取值为50
 %  choice: 1~4, 处理的数据库的标识
 % 输出参数:
 %  level: 1~3, 提取的边缘属于几级; 默认level=1, level=2表示减少了1次阈值, level=3表示减少了2次阈值
 %  layer_time: 程序运行时间
 %  super_hough: 提取到的hough边缘
 %  super_hough_fix: 对super_hough进行修补后的边缘(有时会出现虚假边缘，所以从位置进行判断)
 %  
 %  
 %  2021-11-10
function [level,layer_time,super_hough,super_hough_fix]=ed_kirsch_connect(half_img_h,half_img_w,ed_kir,im_bi,th_area,dis_thresh,choice)%在图像每个部分分别提取超像素边缘
    
level=1;
length_th=3;

a=reshape(ed_kir,[size(ed_kir,1)*size(ed_kir,2) 1]);
    
m=mean(a);
s=std(a);
level_1=m+2*s;
ed_kir_1=ed_kir>level_1;
ed_kir_1(1:2,:)=0;
ed_kir_1(end-1:end,:)=0;
ed_kir_1(:,1:2)=0;
ed_kir_1(:,end-1:end)=0;

level_2=m+s;
ed_kir_2=ed_kir>m+s;
ed_kir_2(1:2,:)=0;
ed_kir_2(end-1:end,:)=0;
ed_kir_2(:,1:2)=0;
ed_kir_2(:,end-1:end)=0;

level_3=m+0.5*s;
ed_kir_3=ed_kir>level_3;
ed_kir_3(1:2,:)=0;
ed_kir_3(end-1:end,:)=0;
ed_kir_3(:,1:2)=0;
ed_kir_3(:,end-1:end)=0;

t=strcat('阈值',num2str(m+2*s));
subplot(4,5,5),imshow(ed_kir_1),title(t)
ed_kir_1=bwmorph(ed_kir_1,'thin',Inf);
subplot(4,5,6),imshow(ed_kir_1),title('细化')
ed_kir_2=bwmorph(ed_kir_2,'thin',Inf);
ed_kir_3=bwmorph(ed_kir_3,'thin',Inf);

      
%       %图像中线
%遇到手指中间曝光的问题，中间手指边缘检测不到
%       %将图像分为四个部分
%       %  up_left    1   up_right    3
%       %  lower_left 2   lower_right 4
%       
%       %为了画出检测的直线
%       %第二个参数是row要增加几行，如左下区域,row要加图像一半尺寸
%       %第三个参数是col要增加即行，如右上区域，col要增加图像一般尺寸
%       %第四参数是原图
%       %第5个参数，实在第几个图像块画图
      
      %左上
tic %计时
up_left=ed_kir_1(1:half_img_h,1:half_img_w); 

[ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
if  long_1<size(ed_1,2)/length_th && (bounds_1(1)>15 || bounds_1(1)==0) %如果长度过短并且靠近中心位置则需要重新检测
  t=strcat('减少左上阈值',num2str(level_2)); 
  subplot(4,5,7),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  up_left=ed_kir_2(1:half_img_h,1:half_img_w);
  [ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
  level=2;
   if  long_1<size(ed_1,2)/length_th && (bounds_1(1)>15 || bounds_1(1)==0) %如果长度过短并且靠近中心位置则需要重新检测
       t=strcat('再次减少左上阈值',num2str(level_3));
       subplot(4,5,8),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(num2str(t))
       up_left=ed_kir_3(1:half_img_h,1:half_img_w);
       [ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
       level=3;
   end

end
       
%         %右上
up_right=ed_kir_1(1:half_img_h,half_img_w+1:end);
[ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
if  long_3<size(ed_3,2)/length_th  && ( bounds_3(1)+bounds_3(3)<size(ed_3,2)-15 || bounds_3(1)==0)
 t=strcat('减少右上阈值',num2str(level_2));
 subplot(4,5,9),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
 up_right=ed_kir_2(1:half_img_h,half_img_w+1:end);
 [ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
 if level<2
     level=2;
 end
  if  long_3<size(ed_3,2)/length_th  && ( bounds_3(1)+bounds_3(3)<size(ed_3,2)-15 || bounds_3(1)==0)
       t=strcat('再次减少右上阈值',num2str(level_3));
       subplot(4,5,10),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(t)
       up_right=ed_kir_3(1:half_img_h,half_img_w+1:end);
       [ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
       if level<3
            level=3;
       end
  end          
end
        %左下
lower_left=ed_kir_1(half_img_h+1:end,1:half_img_w);
[ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
%如果联通区域检测长度过短，并且位于中心位置，部分边缘线没检测到，则需要降低阈值检测
if long_2<size(ed_2,2)/length_th && ( bounds_2(1)>15 || bounds_2(1)==0)
  t=strcat('减少左下阈值',num2str(level_2)); 
  subplot(4,5,11),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  lower_left=ed_kir_2(half_img_h+1:end,1:half_img_w);%降低阈值检测
  [ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
  if level<2
     level=2;
  end
  if long_2<size(ed_2,2)/length_th && ( bounds_2(1)>15 || bounds_2(1)==0)  
       t=strcat('再次减少左下阈值',num2str(level_3)); 
       subplot(4,5,12),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(t)
       lower_left=ed_kir_3(half_img_h+1:end,1:half_img_w);%降低阈值检测
       [ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
       if level<3
            level=3;
       end
  end
end
%       %右下
lower_right=ed_kir_1(half_img_h+1:end,half_img_w+1:end);
[ed_4,long_4,bounds_4]=ed_connect(lower_right,half_img_h,half_img_w);
if long_4<size(ed_4,2)/length_th && (bounds_4(1)+bounds_4(3)>size(lower_right,2)-15 || bounds_4(1)==0)
  t=strcat('减少右下阈值',num2str(level_2)); 
  subplot(4,5,13),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  lower_right=ed_kir_2(half_img_h+1:end,half_img_w+1:end);
  [ed_4,long_4,bounds_4]=ed_connect(lower_right,half_img_h,half_img_w);
  if level<2
     level=2;
  end
  if long_4<size(ed_4,2)/length_th && (bounds_4(1)+bounds_4(3)>size(lower_right,2)-15 || bounds_4(1)==0)
       t=strcat('再次减少右下阈值',num2str(level_3)); 
       subplot(4,5,14),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(t)
       lower_right=ed_kir_3(half_img_h+1:end,half_img_w+1:end);
      [ed_4,long_4,bounds_4]=ed_connect(lower_right,half_img_h,half_img_w);
       if level<3
            level=3;
       end
  end
end   
super_hough=[ed_1 ed_3;ed_2 ed_4];
layer_time=toc;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %有时会出现虚假边缘，所以从位置进行判断
[super_hough_fix]=ed_fix(ed_1,ed_2,ed_3,ed_4,half_img_h,dis_thresh,choice);
   
   
    
   
     

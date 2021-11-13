 % 函数名: ed_fix
 % 功能简介: 辨别虚假边缘。有时会出现虚假边缘，所以从位置进行判断
 % 输入参数:
%  ed_1: 左上边缘
%  ed_2: 左下边缘
%  ed_3: 右上边缘
%  ed_4: 右下边缘
 %  half_img_h: 图像高度的中线
 %  dis_thresh: 常数, 距离阈值, 一般取值为50
 %  choice: 1~4, 处理的数据库的标识
 % 输出参数:
 %  super_hough_fix: 修正后的边缘
 %
 % 2021-11-11

function [super_hough_fix]=ed_fix(ed_1,ed_2,ed_3,ed_4,half_img_h,dis_thresh,choice);
jump_thresh=15;%左上部分最后一个点和右上部分第一个点的距离阈值
switch choice
    case 1
        left_high=70;
        right_high=60;
    case 2
       left_high=70;
        right_high=60;
   case 3
        left_high=100;
        right_high=90;
    case 4
        left_high=100;
        right_high=90;
end
%有时会出现虚假边缘，所以从位置进行判断
   [r1,c1]=find(ed_1);
    [r3,c3]=find(ed_3);
    r=[r1;r3];
    mean_up=mean(r);
    [r2,c2]=find(ed_2);
    [r4,c4]=find(ed_4);
    r=[r2;r4];
     mean_lower=mean(r)+half_img_h;
      
      if length(r1)>0 && length(r3)>0                
         if abs(r1(end)-r3(1))>jump_thresh
            %如果左右两边端点距离超过20,
            dis_1=mean_lower-mean(r1);
            dis_3=mean_lower-mean(r3);
           
               if dis_1<dis_3%选择与下边距近的直线
               %判断取那条边界
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     if dis_1>dis_thresh%与下边距近的直线，需要至少和下边距保持120像素的距离，预防假边缘
                         ed_3(:,:)=0;
                      else
                         ed_1(:,:)=0;
                      end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                else
                      if dis_3>dis_thresh    %与下边距近的直线，需要至少和下边距保持120像素的距离，预防假边缘
                        ed_1(:,:)=0;
                      else
                        ed_3(:,:)=0;              
                      end
                end
            end
      
   end   
  %如果左右下边界距离差20，
      %如果左下与左上距离小于120，则选下方的边界线
      %否则选上方边界线
      [r1,c1]=find(ed_1);
      [r3,c3]=find(ed_3);
      r=[r1;r3];
      mean_up=mean(r);
     if length(r2)==0 && length(r4)==0
         b=round(mean_up+right_high-half_img_h);
         if b>size(ed_2,1)
             b=size(ed_2,1);
         end
         ed_2(b,:)=1;
         ed_4(b,:)=1;
     elseif length(r2)>0 && length(r4)>0       
         if abs(r2(end)-r4(1))>jump_thresh
                dis_2=mean(r2)-mean_up+half_img_h;
                dis_4=mean(r4)-mean_up+half_img_h;
                if dis_2<dis_4%选择与上边距近的直线，并且与上边距要保持至少120像素的距离
                    if dis_2>dis_thresh
                        ed_4(:,:)=0;
                     else
                        ed_2(:,:)=0;
                     end
                else
                    if dis_4>dis_thresh
                        ed_2(:,:)=0;          
                    else
                        ed_4(:,:)=0;                   
                    end
               end
         end
     elseif length(r2)==0 && length(r4)>0
         b=round(mean_up+right_high-half_img_h);
         if b>size(ed_2,1)
             b=size(ed_2,1);
         end
         ed_2(b,:)=1;
         dis_4=mean(r4)-mean_up+half_img_h;
         if dis_4<right_high
            ed_4(:,:)=0;
            ed_4(b,:)=1;
         end
      
     end
     a=find(ed_1);
     if length(a)==0
          [r2,c2]=find(ed_2);
          [r4,c4]=find(ed_4);
          r=[r2;r4];
           mean_lower=mean(r)+half_img_h;
           a=round(mean_lower-left_high);
           if a<1
               a=1;
           end
           ed_1(a,:)=1;
     end
      a=find(ed_3);
     if length(a)==0
          [r2,c2]=find(ed_2);
          [r4,c4]=find(ed_4);
          r=[r2;r4];
           mean_lower=mean(r)+half_img_h;
           a=round(mean_lower-right_high);
           if a<0
               a=1;
           end
           ed_3(a,:)=1;
     end
     a=find(ed_2);
     if length(a)==0
          [r1,c1]=find(ed_1);
          [r3,c3]=find(ed_3);
          r=[r1;r3];
           mean_up=mean(r);
           a=round(mean_up+left_high-half_img_h);
           if a>size(ed_2,1)
               a=size(ed_2,1);
           end
           ed_2(a,:)=1;
     end
     a=find(ed_4);
     if length(a)==0
          [r1,c1]=find(ed_1);
          [r3,c3]=find(ed_3);
          r=[r1;r3];
           mean_up=mean(r);
           a=round(mean_up+right_high-half_img_h);
           if a>size(ed_4,1)
               a=size(ed_4,1);
           end
           
           ed_4(a,:)=1;
     end
    %完整的
     super_hough_fix=[ed_1 ed_3;ed_2 ed_4]; 
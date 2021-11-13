 % ������: ed_kirsch_connect
 % ���ܼ��: hough�任��ȡ��Ե
 % �������:
 %  half_img_h: ͼ��߶ȵ�����
 %  half_img_w: ͼ���ȵ�����
 %  ed_kir: kirsch��Ե, ��kirschEdge������������
 %  im_bi: �Ժ�ѡͼ�����˫���˲���Ľ��
 %  th_area: ����, һ��ȡֵΪ50
 %  dis_thresh: ����, ������ֵ, һ��ȡֵΪ50
 %  choice: 1~4, ��������ݿ�ı�ʶ
 % �������:
 %  level: 1~3, ��ȡ�ı�Ե���ڼ���; Ĭ��level=1, level=2��ʾ������1����ֵ, level=3��ʾ������2����ֵ
 %  layer_time: ��������ʱ��
 %  super_hough: ��ȡ����hough��Ե
 %  super_hough_fix: ��super_hough�����޲���ı�Ե(��ʱ�������ٱ�Ե�����Դ�λ�ý����ж�)
 %  
 %  
 %  2021-11-10
function [level,layer_time,super_hough,super_hough_fix]=ed_kirsch_connect(half_img_h,half_img_w,ed_kir,im_bi,th_area,dis_thresh,choice)%��ͼ��ÿ�����ֱַ���ȡ�����ر�Ե
    
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

t=strcat('��ֵ',num2str(m+2*s));
subplot(4,5,5),imshow(ed_kir_1),title(t)
ed_kir_1=bwmorph(ed_kir_1,'thin',Inf);
subplot(4,5,6),imshow(ed_kir_1),title('ϸ��')
ed_kir_2=bwmorph(ed_kir_2,'thin',Inf);
ed_kir_3=bwmorph(ed_kir_3,'thin',Inf);

      
%       %ͼ������
%������ָ�м��ع�����⣬�м���ָ��Ե��ⲻ��
%       %��ͼ���Ϊ�ĸ�����
%       %  up_left    1   up_right    3
%       %  lower_left 2   lower_right 4
%       
%       %Ϊ�˻�������ֱ��
%       %�ڶ���������rowҪ���Ӽ��У�����������,rowҪ��ͼ��һ��ߴ�
%       %������������colҪ���Ӽ��У�����������colҪ����ͼ��һ��ߴ�
%       %���Ĳ�����ԭͼ
%       %��5��������ʵ�ڵڼ���ͼ��黭ͼ
      
      %����
tic %��ʱ
up_left=ed_kir_1(1:half_img_h,1:half_img_w); 

[ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
if  long_1<size(ed_1,2)/length_th && (bounds_1(1)>15 || bounds_1(1)==0) %������ȹ��̲��ҿ�������λ������Ҫ���¼��
  t=strcat('����������ֵ',num2str(level_2)); 
  subplot(4,5,7),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  up_left=ed_kir_2(1:half_img_h,1:half_img_w);
  [ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
  level=2;
   if  long_1<size(ed_1,2)/length_th && (bounds_1(1)>15 || bounds_1(1)==0) %������ȹ��̲��ҿ�������λ������Ҫ���¼��
       t=strcat('�ٴμ���������ֵ',num2str(level_3));
       subplot(4,5,8),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(num2str(t))
       up_left=ed_kir_3(1:half_img_h,1:half_img_w);
       [ed_1,long_1,bounds_1]=ed_connect(up_left,0,0);
       level=3;
   end

end
       
%         %����
up_right=ed_kir_1(1:half_img_h,half_img_w+1:end);
[ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
if  long_3<size(ed_3,2)/length_th  && ( bounds_3(1)+bounds_3(3)<size(ed_3,2)-15 || bounds_3(1)==0)
 t=strcat('����������ֵ',num2str(level_2));
 subplot(4,5,9),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
 up_right=ed_kir_2(1:half_img_h,half_img_w+1:end);
 [ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
 if level<2
     level=2;
 end
  if  long_3<size(ed_3,2)/length_th  && ( bounds_3(1)+bounds_3(3)<size(ed_3,2)-15 || bounds_3(1)==0)
       t=strcat('�ٴμ���������ֵ',num2str(level_3));
       subplot(4,5,10),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(t)
       up_right=ed_kir_3(1:half_img_h,half_img_w+1:end);
       [ed_3,long_3,bounds_3]=ed_connect(up_right,0,half_img_w);
       if level<3
            level=3;
       end
  end          
end
        %����
lower_left=ed_kir_1(half_img_h+1:end,1:half_img_w);
[ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
%�����ͨ�����ⳤ�ȹ��̣�����λ������λ�ã����ֱ�Ե��û��⵽������Ҫ������ֵ���
if long_2<size(ed_2,2)/length_th && ( bounds_2(1)>15 || bounds_2(1)==0)
  t=strcat('����������ֵ',num2str(level_2)); 
  subplot(4,5,11),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  lower_left=ed_kir_2(half_img_h+1:end,1:half_img_w);%������ֵ���
  [ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
  if level<2
     level=2;
  end
  if long_2<size(ed_2,2)/length_th && ( bounds_2(1)>15 || bounds_2(1)==0)  
       t=strcat('�ٴμ���������ֵ',num2str(level_3)); 
       subplot(4,5,12),imshow(imoverlay(im_bi,ed_kir_3,'red'),'InitialMagnification',67),title(t)
       lower_left=ed_kir_3(half_img_h+1:end,1:half_img_w);%������ֵ���
       [ed_2,long_2,bounds_2]=ed_connect(lower_left,half_img_h,0);
       if level<3
            level=3;
       end
  end
end
%       %����
lower_right=ed_kir_1(half_img_h+1:end,half_img_w+1:end);
[ed_4,long_4,bounds_4]=ed_connect(lower_right,half_img_h,half_img_w);
if long_4<size(ed_4,2)/length_th && (bounds_4(1)+bounds_4(3)>size(lower_right,2)-15 || bounds_4(1)==0)
  t=strcat('����������ֵ',num2str(level_2)); 
  subplot(4,5,13),imshow(imoverlay(im_bi,ed_kir_2,'red'),'InitialMagnification',67),title(t)
  lower_right=ed_kir_2(half_img_h+1:end,half_img_w+1:end);
  [ed_4,long_4,bounds_4]=ed_connect(lower_right,half_img_h,half_img_w);
  if level<2
     level=2;
  end
  if long_4<size(ed_4,2)/length_th && (bounds_4(1)+bounds_4(3)>size(lower_right,2)-15 || bounds_4(1)==0)
       t=strcat('�ٴμ���������ֵ',num2str(level_3)); 
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
   %��ʱ�������ٱ�Ե�����Դ�λ�ý����ж�
[super_hough_fix]=ed_fix(ed_1,ed_2,ed_3,ed_4,half_img_h,dis_thresh,choice);
   
   
    
   
     

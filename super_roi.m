 % 函数名: super_roi
 % 功能简介: 提取出最终的roi
 % 输入参数:
 %  inputImg: 输入图像(源图)
 %  super_hough: 提取出来的4段边缘(左上、右上、左下、右下)
 %  half_img_h: 图像调试的中线
 % 输出参数:
 %  roi: ROI图像
 %  mask: ROI的Mask
 %
 %  
 %  2021-11-11
function [roi,mask]=super_roi(inputImg,super_hough,half_img_h)     
 subplot(4,5,17),imshow(super_hough),title('插值')
 %上边界
 ed_1=super_hough(1:half_img_h,:); 
 m=1;
    for k=1:size(ed_1,2)
    ind=find(ed_1(:,k));
       if length(ind)>0
           x(m)=k;
           v_up(m)=ind(1); 
           m=m+1;
       end
    end
     xq_up=x(1):x(end);
     vq_up=interp1(x,v_up,xq_up);
     hold on,plot(xq_up,vq_up,'.g') 
     %下边界
      ed_2=super_hough(half_img_h+1:end,:);
      m=1;
      x=[];
      for k=1:size(ed_2,2)
        ind=find(ed_2(:,k));
           if length(ind)>0
               x(m)=k;
               v_lower(m)=ind(1); 
               m=m+1;
           end
       end
       xq_lower=x(1):x(end);
       vq_lower=interp1(x,v_lower,xq_lower)+half_img_h;
       hold on,plot(xq_lower,vq_lower,'.g') 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       
       subplot(4,5,18),imshow(super_hough),title('修正')
       %上边曲线修正
       %预测左边
       x_left=1:xq_up(1)-1;
       if length(x_left)<10
           p = polyfit(xq_up(1:10),vq_up(1:10),1);%如果左边只有几个点要预测，则少选些点，要精确些
       else
           p = polyfit(xq_up(1:50),vq_up(1:50),1);
       end
       
       upper_left= polyval(p,x_left);
       %预测右边
       x_right=xq_up(end)+1:size(super_hough,2);
       if length(x_right)<10 
            p = polyfit(xq_up(end-10:end),vq_up(end-10:end),1);%如果右边只有几个点要预测，则少选些点，要精确些
       else
            p = polyfit(xq_up(end-40:end),vq_up(end-40:end),1);
       end
      
       upper_right= polyval(p,x_right);
       upper_fix=[upper_left,vq_up,upper_right];
       hold on,plot(1:size(ed_1,2),upper_fix,'.r')
       
       %下边曲线修正
       %预测左边
       if length(xq_lower)<51
           m=mean(vq_lower);
           lower_left(1:xq_lower(1)-1)=m;
           lower_right(1:size(super_hough,2)-xq_lower(end))=m;
       else
            x_left=1:xq_lower(1)-1;
            if length(x_left)<10
                p = polyfit(xq_lower(1:10),vq_lower(1:10),1);
            else
                p = polyfit(xq_lower(1:50),vq_lower(1:50),1);
            end
            lower_left= polyval(p,x_left);
            x_right=xq_lower(end)+1:size(super_hough,2);
            if length(x_right)<10
                p = polyfit(xq_lower(end-10:end),vq_lower(end-10:end),1);
            else
                p = polyfit(xq_lower(end-50:end),vq_lower(end-50:end),1);
            end
            
            lower_right= polyval(p,x_right);
           
       end
       %预测右边
        lower_fix=[lower_left,vq_lower,lower_right];
         hold on,plot(1:size(ed_2,2),lower_fix,'.r')
         
      mask=zeros(size(inputImg));
      for k=1:length(upper_fix)
          a=round(upper_fix(k));
          if a<1
              a=1;
          end
          
          b=round(lower_fix(k));
          if b>size(inputImg,1)
              b=size(inputImg,1);
          end
          mask(a:b,k)=1;
      end
% 这里是调试使用过的代码, 需注释掉。 2021-11-11
%         subplot(4,5,15),imshow(mask),title('原mask')
%       left=find(mask(:,1));
%       right=find(mask(:,end));
%       if abs(left(1)-left(end))<90 | abs(right(1)-right(end))<70
%            mask=zeros(size(inputImg));
%            a=round(mean(upper_fix));
%            b=a+60;
%           if b>size(inputImg,1)
%               b=size(inputImg,1);
%           end
%             for k=1:length(upper_fix)
%                 a=upper(k);
%                 if a<1
%                     a=1;
%                 end
%                 mask(a:b,k)=1;
%           end
%        end

      %se=strel('line',30,0);
     
%       se=strel('sphere',3);
%      mask=imerode(mask,se);%平滑边缘
%      se=strel('line',30,0);
%       mask=imopen(mask,se);
       roi=double(mask).*double(inputImg);
      
%      
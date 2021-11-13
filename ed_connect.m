 % 函数名: ed_connect
 % 功能简介: 对提取出的边缘进行连接和完善
 % 输入参数:
 %  ed: 已经取得的边缘, 为二值图像
 %  row: 待连接和完善的边缘线起点行数
 %  col: 待连接和完善的边缘线起点列数
 % 输出参数:
 %  im_bw: 二值图像, 拼接后的边缘图像
 %  max_long: 最大长度
 %  b: im_bw中边缘的边框, 可能有多个
 %
 % 2021-11-11
function [im_bw,max_long,b]=ed_connect(ed,row,col)
%为了画出检测的直线
%第二个参数是row要增加几行，如左下区域,row要加图像一半尺寸
%第三个参数是col要增加即行，如右上区域，col要增加图像一半尺寸
% function [im,y]=im_hough(ed) 
%ed是二值图像
%在图像每个部分分别提取最大水平连通区域'
   im_bw=zeros(size(ed,1),size(ed,2));
    ed=bwareaopen(ed,10);
    CC=bwconncomp(ed,8);%找到连通区域
   
    s = regionprops(CC,'centroid','Area','BoundingBox');
    if length(s)>0
       bounds=cat(1,s.BoundingBox);
       areas=cat(1,s.Area);
       centroids = cat(1,s.Centroid);
       long=bounds(:,3);   
       if length(long)>1
            [~,in]=sort(long,'descend');
   %选择最长联通区域                
             if long(in(1))-long(in(2))<28 && long(in(2))>size(ed,2)/3
           %如果有两条线相隔很近
                 if row==0%讨论上半部分噪声边缘
                     if centroids(in(1),2)<centroids(in(2),2)
                        ind=in(2);
                     else
                        ind=in(1);
                     end
                 else
                     if centroids(in(1),2)<centroids(in(2),2)
                        ind=in(1);
                     else
                        ind=in(2);
                     end
                 end
             else
                ind=in(1);
             end
       else
           ind=1;
       end
       max_long=long(ind);
       b=[bounds(ind,1)+col, bounds(ind,2)+row,bounds(ind,3), bounds(ind,4)];
       hold on,rectangle('Position',b,'EdgeColor','cyan','LineWidth',2)
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
%        case1=(centroids(ind,1)<size(ed,2)-20) & (bounds(ind,4)/bounds(ind,3))<0.5;%如果中心位置没有有靠近右边缘，那么长宽比例要<0.5
%        case2=(centroids(ind,1)>size(ed,2)-20) & (bounds(ind,4)/bounds(ind,3))<0.61;%如果中心位置靠近右缘，那么长宽比例要<0.6
      
       if  (bounds(ind,4)/bounds(ind,3))<0.5
            im_bw(CC.PixelIdxList{ind})=1;
       else
           max_long=0;
           im_bw(CC.PixelIdxList{ind})=0;
           b=zeros(1,4);    
       end
         
    else
        max_long=0;
        b=zeros(1,4);    
    end
    %如果最大长度不够，看看还有没有在一条线上的连通区域
    if length(s)>0
        if max_long<size(ed,2)/2 && length(long)>1
            for k=2:length(in)
                case1=centroids(in(k),1)<bounds(ind,1);%中心点的坐标在最大联通区域的左边
                case2= (bounds(in(k),4)/bounds(in(k),3))<0.25;
                case3=abs(centroids(in(k),2)-bounds(ind,2))<5;
            
                if  case1 && case2 && case3
                    im_bw(CC.PixelIdxList{in(k)})=1;
                    max_long=max_long+long(in(k));
                    tt=[bounds(in(k),1)+col, bounds(in(k),2)+row,bounds(in(k),3), bounds(in(k),4)];
                    hold on,rectangle('Position',tt,'EdgeColor','cyan','LineWidth',2)
                    b=[b;tt];
                end
            end
        end
    end
                   
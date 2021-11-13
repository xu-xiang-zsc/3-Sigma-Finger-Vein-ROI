 % ������: ed_connect
 % ���ܼ��: ����ȡ���ı�Ե�������Ӻ�����
 % �������:
 %  ed: �Ѿ�ȡ�õı�Ե, Ϊ��ֵͼ��
 %  row: �����Ӻ����Ƶı�Ե���������
 %  col: �����Ӻ����Ƶı�Ե���������
 % �������:
 %  im_bw: ��ֵͼ��, ƴ�Ӻ�ı�Եͼ��
 %  max_long: ��󳤶�
 %  b: im_bw�б�Ե�ı߿�, �����ж��
 %
 % 2021-11-11
function [im_bw,max_long,b]=ed_connect(ed,row,col)
%Ϊ�˻�������ֱ��
%�ڶ���������rowҪ���Ӽ��У�����������,rowҪ��ͼ��һ��ߴ�
%������������colҪ���Ӽ��У�����������colҪ����ͼ��һ��ߴ�
% function [im,y]=im_hough(ed) 
%ed�Ƕ�ֵͼ��
%��ͼ��ÿ�����ֱַ���ȡ���ˮƽ��ͨ����'
   im_bw=zeros(size(ed,1),size(ed,2));
    ed=bwareaopen(ed,10);
    CC=bwconncomp(ed,8);%�ҵ���ͨ����
   
    s = regionprops(CC,'centroid','Area','BoundingBox');
    if length(s)>0
       bounds=cat(1,s.BoundingBox);
       areas=cat(1,s.Area);
       centroids = cat(1,s.Centroid);
       long=bounds(:,3);   
       if length(long)>1
            [~,in]=sort(long,'descend');
   %ѡ�����ͨ����                
             if long(in(1))-long(in(2))<28 && long(in(2))>size(ed,2)/3
           %���������������ܽ�
                 if row==0%�����ϰ벿��������Ե
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
       
%        case1=(centroids(ind,1)<size(ed,2)-20) & (bounds(ind,4)/bounds(ind,3))<0.5;%�������λ��û���п����ұ�Ե����ô�������Ҫ<0.5
%        case2=(centroids(ind,1)>size(ed,2)-20) & (bounds(ind,4)/bounds(ind,3))<0.61;%�������λ�ÿ�����Ե����ô�������Ҫ<0.6
      
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
    %�����󳤶Ȳ�������������û����һ�����ϵ���ͨ����
    if length(s)>0
        if max_long<size(ed,2)/2 && length(long)>1
            for k=2:length(in)
                case1=centroids(in(k),1)<bounds(ind,1);%���ĵ�������������ͨ��������
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
                   
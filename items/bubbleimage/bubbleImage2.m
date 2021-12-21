% 彩色图生成气泡图,气泡圆不重叠,颜色根据圆位置选
clear;
close all;

img= imread('timg.jpg');
img = imresize(img, 0.2);
[h,w,c] = size(img);
% imshow(img);
black = ones(h,w,c,'uint8')*255;
imshow(black);
statemap=zeros(h,w,'uint8'); %
% randi([1555,11100],1,1)
% poslist = zeros(w*h,2);
Npts = 200;
coverRatio = 1;
circles=[];%zeros(Npts,3);% x,y, r
colors=[];
radiuslim = [3,15];
next=true;
changelim = false;
changelim2 = false;
n=1;
while ( n<Npts || coverRatio>0.35)
    [posy, posx] =  find(statemap(1:h,1:w)==0);
    coverRatio = size(posy,1)/double(h*w);
%     if length(posy)<w*h*0.2
%         next=false;
%     end
    indxmax = length(posy);
    indxRandom = randi([1,indxmax],1,1);
   
    y=posy(indxRandom);
    x=posx(indxRandom);
%     clear posx posy indxRandom;
    color = double(img(y,x,:))/255;
    radius = randi(radiuslim,1,1);
%     rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1],'FaceColor',color,'EdgeColor',[0,0,0]);
    % check current circle pos of old circles
    ddmin = w+h;
    flag = true;
    % 
    if size(circles,1)<1
        circles = [x,y, radius];
        
        circ = circles(:);
        fcircle = @(posx,posy)sqrt((posx-circ(1)).^2+(posy-circ(2)).^2);
        dist2center = arrayfun(fcircle, posx,posy);
        indxincircel = find(dist2center<=circ(3));
        posyin = posy(indxincircel);
        posxin = posx(indxincircel);
        indxsel = sub2ind(size(statemap),posyin, posxin);
        statemap(indxsel) = 1;
%         figure(2);imagesc(statemap);
        r = radius;
        figure(1);
        imshow(black);
%         rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1],'FaceCol
%         or',color,'EdgeColor',[0,0,0]);
       rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1],'FaceColor',color,'EdgeColor',color);
        continue;
    end
   
    newcenter = repmat([x,y],size(circles,1),1);
    fdist=@(cir,c0,d)floor(sqrt(sum((cir-c0).^2,2)))-d; 
    distall = fdist(circles(:,1:2),newcenter,circles(:,3));
    [distmin,indx] = min(distall);
    if distmin<1
       continue; 
    end
    rdistmin = circles(indx,3);
    
    if distmin<(radius)
        radius = floor(distmin);
    end
    
    if radius<max(1,radiuslim(1))
       continue;
    end
     circles = [circles;[x,y, radius]];
     colors = [colors;color];
     r = radius;
%     figure(1);
%     rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1],'FaceColor',
%     color,'EdgeColor',[0,0,0]);
    rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1,1],'FaceColor',color,'EdgeColor',color);
    n=n+1;
%     fstateupdate
    if 1
%     for c =1: size(circles,1)
%         [posy, posx] =  find(statemap(1:h,1:w)==0);
        
        circ = circles(n,:);
        fcircle = @(posx,posy)sqrt((posx-circ(1)).^2+(posy-circ(2)).^2);
        dist2center = arrayfun(fcircle, posx,posy);
        indxincircel = find(dist2center<=circ(3));
        posyin = posy(indxincircel);
        posxin = posx(indxincircel);
        indxsel = sub2ind(size(statemap),posyin, posxin);
        statemap(indxsel) = 1;
%         figure(2);imagesc(statemap);

    end
%     disp(size(posy,1)/double(h*w));
    % change rand radius limit
    if size(posy,1)/double(h*w)<0.5 && ~changelim
        radiuslim = radiuslim -2;
        changelim = true;
%         disp('changelim');
    end
   if size(posy,1)/double(h*w)<0.3 && ~changelim2
        radiuslim = radiuslim -1;
        changelim2 = true;
%         disp('changelim2');
    end
end
 figure(1);
 %%%%%%%%%%%%只取图像中间圆形区域 
white = ones(h,w,'uint8')*255;
circ = [w/2, h/2];
[posy, posx] =  find(white);
fcircle = @(posx,posy)sqrt((posx-circ(1)).^2+((posy-circ(2))).^2);
dist2center = arrayfun(fcircle, posx,posy);
indxincircel = find(dist2center>min(w,h)/2);
posyin = posy(indxincircel);
posxin = posx(indxincircel);
indxsel = sub2ind(size(white),posyin, posxin);
white(indxsel) = 0;
% figure(2); imshow(white);
% 取3个通道对应的indx
% sub2ind(size(img),indxsel,c);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
set(gca,'units','pixels','Visible','off')
position = get(gca,"Position");
im = getframe(gcf, position);
im2 = frame2im(im);
figure(3);imshow(im2)
rr = im2(:,:,1);
gg = im2(:,:,2);
bb = im2(:,:,3);
% draw circle
rr(indxsel) = 255;
gg(indxsel) = 255;
bb(indxsel) = 255;
im2(:,:,1)=rr;
im2(:,:,2)=gg;
im2(:,:,3)=bb;
figure(3);imshow(im2)

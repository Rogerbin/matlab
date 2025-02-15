% lineplot ms  uV
% test line 
function Untitled
% ±56.85  ±19.63  ±28.17   ±38.57    ±2.08
% N1 P2 N2 P3
% B   102.27±52.65    168.35±18.51   230.82±26.55    432.36±40.11     7.23±1.64
% C   101.37±57.82    167.19±17.97   228.69±25.17    435.34±40.12     7.19±1.78
% D   102.16±54.29    169.12±18.61   230.76±25.38    437.21±54.48     7.15±1.68

% A    99.64±57.91   169.41±19.73   230.74±27.99   401.19±41.52     7.64±1.63
% B   99.27±59.68   166.65±18.91   220.56±25.57    371.90±47.79     9.59±2.2
% C   98.39±57.71   164.50±17.49   214.42±24.58    349.39±51.10   10.30±1.97
% D   96.19±57.69   161.82±16.79   210.65±24.59   318.42±43.32   12.15±2.18

% 正常组98.36±49.78    167.38±19.38   222.36±25.78    309.16±49.77  13.08±2.52
% 
grp = {'A(前)', 'B(前)','C(前)','D(前)','A(后)','B(后)','C(后)','D(后)', '正常'};

% A1
xa = [ 102.38    169.45  230.37    437.27 ];
ya = [   7.5   6.24   8.14     5.14];

% B1
% xa = [ 102.27    168.35  230.82    432.36];
% ya = [ ];


x = [ 1 ,50 , xa, 500 600];
y = [6.5 ,6 , ya , 9.2 8.79];
xi = round(x(1)):5:round(x(end));
len = length(xi);
a = -0.2; b = 0.2;
r = a + (b-a).*rand([1 len]);
figure;

yi = interp1(x,y, xi,'cubic');
yii = yi+r;
idy = find(yii>9.22);
yii(idy) = yi(idy);
idy = find(yii<5.06);
yii(idy) = yi(idy);
plot(xi,yii);
xlim([0, 600]);
ylim([0 , 12]);
grid on;
xlabel('ms')
ylabel('uV')

lb = {'N1', 'P2', 'N2', 'P3'};

% hold on;
% xp = xa(1);
% % yp = yii(find(xi==101));
% [~,yd] = min(abs(xi-round(xp)));
% yp = yii(yd);
% plot([xp xp],[ yp-.5 yp+.5],'r');
% text(xp,yp+.5, lb{1})
% hold off;

for nm = 1:4
hold on;
xp = xa(nm);
% yp = yii(find(xi==101));
[~,yd] = min(abs(xi-round(xp)));
yp = yii(yd);
plot([xp xp],[ yp-.5 yp+.5],'r');
text(xp,yp+.5, lb{nm})
hold off;
end

hold on;
plot([400 500] , [2 2],'b', 'LineWidth',2); text(400, 1.5,'100ms')
plot([500 500] , [2 4],'b', 'LineWidth',2); text(500, 2.5, '2uV')
hold off;

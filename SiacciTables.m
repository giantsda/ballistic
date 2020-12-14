%% get Data from book
% % b=[a(:,1:5);a(:,6:10)];
% % a=sortrows(b,1);
% % 
% % 
% %  
% % %%
% % a=real(a);
% % a=sortrows(a,1);
% % b=[];
% % V=100;
% % j=1;
% % for i=1:length(a)
% %     if mod(a(i,1),10)==0
% %         b(j,:)=a(i,:);
% %         j=j+1;
% %     end
% % end
% 
% b=sortrows(b,1);
% for i=1:length(b)-1
%     if b(i+1,1)-b(i,1)~=10
%         break;
%     end   
% end
% i



%% get drag curve
b=siacci.G8;
 
xq=linspace(b(1,1),b(end,1),10000); 
vq = interp1(b(:,1),b(:,2),xq,'spline');
c=1./-diff(vq)./diff(xq)./xq(1:end-1)*1e3;

plot(xq(1:1:end-1),c(1:1:end));
hold on;
c = smoothdata(c,'gaussian',200);
plot(xq(1:1:end-1),c(1:1:end));
siacci.G8DragCurve=[xq(1:end-1).' c.'];
%% Calculate and Plot the State Maxima
umax = 0.5;
u = linspace(0,umax,30)
N = 1e4; 
% Code for plotting state maxima in DSM

T = ones(1,N);
maxima = zeros(order,length(u));
for i = 1:length(u)
    ui = u(i);
    [v,xn,xmax,y] = simulateDSM(ui(T), ABCD);
    maxima(:,i) = xmax(:);
    if any(xmax>1e2) 
	umax = ui;
	%u = u(1:i);
	maxima = maxima(:,1:i);
    	break;
    end
end

figure(); clf
for i = 1:order
    semilogy(u,maxima(i,:),'o');
    if i==1
    	hold on;
    end
    semilogy(u,maxima(i,:),'--');
end
grid on;
xlabel('DC input')
%axis([ 0 0.6 4e-2 4]);

% EOF
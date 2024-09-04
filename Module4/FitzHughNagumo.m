% model parameters
eps = 0.08;
a = 1;
b = 0.2;

% current injection
I_0 = 1.0;
start = 40;
stop = 47;
I = @(t) I_0*(t>start).*(t<stop);

% model definition
f = @(v,w) v - 1/3*v.^3 - w;
g = @(v,w) eps*(v + a -b*w);


%% single cell
%dxdt =@ (t,x) [f(x(1),x(2)) + I(t); g(x(1),x(2));];

% solve!
%[T,X] = ode45(dxdt,[0,100], [-1.5,-0.5]);

D = 0.9;
% multiple cells

dxdt = @(t,x) [
    f(x(1), x(11)) + D*(x(10)-2*x(1)+x(2));
    f(x(2), x(12)) + D*(x(1)-2*x(2)+x(3));
    f(x(3), x(13)) + D*(x(2)-2*x(3)+x(4));
    f(x(4), x(14)) + I(t) + D*(x(3)-2*x(4)+x(5));
    f(x(5), x(15)) + D*(x(4)-2*x(5)+x(6));
    f(x(6), x(16)) + D*(x(5)-2*x(6)+x(7));
    f(x(7), x(17)) + D*(x(6)-2*x(7)+x(8));
    f(x(8), x(18)) + D*(x(7)-2*x(8)+x(9));
    f(x(9), x(19)) + D*(x(8)-2*x(9)+x(10));
    f(x(10), x(20)) + D*(x(9)-2*x(10)+x(1));
    g(x(1), x(11));
    g(x(2), x(12));
    g(x(3), x(13));
    g(x(4), x(14));
    g(x(5), x(15));
    g(x(6), x(16));
    g(x(7), x(17));
    g(x(8), x(18));
    g(x(9), x(19));
    g(x(10), x(20));
    ];

ic = [-1.1*ones(10,1);-0.6*ones(10,1)];
[T,X] = ode45(dxdt,[0,100], ic);

figure(405); 
clf; 
hold on;
set(gca, 'xlim', [-2.5, 2.5], 'ylim', [-2.5,2.5])
ylabel('w');
xlabel('v')

uArray = linspace(-2.5, 2.5,32);
wArray = linspace(-2.5, 2.52,32);

[uMesh,wMesh] = meshgrid(uArray, wArray);

% the Matlab plot command for a field of arrows is:
quiver(uMesh, wMesh, f(uMesh, wMesh), g(uMesh,wMesh), 0.5)

plot(X(:,1),X(:,2),'-r')
plot(X(end,1),X(end,2), 'or')

% movie
for nt=1:numel(T)
    figure(5); clf; hold on; box on;
    plot(X(nt,1:10)); 
    set(gca,'ylim', [-2.5,2.5])
    xlabel('Cell');
    ylabel('Voltage')
    drawnow;
end

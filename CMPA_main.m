set(0, 'DefaultFigureWindowStyle', 'Docked')

clc
clear
close all

% ELEC 4700 - PA8: Diode Parameter Extraction
% Brandon Schelhaas
% 101036851

selectableTraces = 0;
if selectableTraces
    plotBrowser
end

% -------------------------------
%            Question 1
% -------------------------------

% Define variables
Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

% Implement diode current equation
ideal_diode = @(V) Is * (exp( (1.2*V) / (0.025) ) - 1);
para_res = @(V) Gp * V;
breakdown = @(V) Ib * (exp( (-1.2*(V+Vb) ) / (0.025) ) - 1);
Id = @(V) ideal_diode(V) + para_res(V) - breakdown(V);

% Voltage vector from -1.95 to 0.7V
Vin = linspace(-1.95, 0.7, 200);
% i1 = ideal_diode(Vin)
% i2 = para_res(Vin)
% i3 = breakdown(Vin)

% Create I vector
Iq1_1 = Id(Vin);

% Create second I vector for experimental noise
percent_variation = 0.2; % 20 percent
a = 1 - percent_variation;
b = 1 + percent_variation;
randNoise = (b-a).*rand(1, length(Vin)) + a;
Iq1_2 = randNoise .* Iq1_1;

% Plot with plot and semilogy
figure
subplot(2,1,1)
sgtitle('Question 1')
plot(Vin, Iq1_1, Vin, Iq1_2)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');
subplot(2,1,2)
semilogy(Vin, abs(Iq1_1), Vin, abs(Iq1_2))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');

% -------------------------------
%            Question 2
% -------------------------------

% Fit 4th order and 8th order curves to each current
order4Fit_noNoise = polyfit(Vin, Iq1_1, 4);
order4Fit_Noise = polyfit(Vin, Iq1_2, 4);
order8Fit_noNoise = polyfit(Vin, Iq1_1, 8);
order8Fit_Noise = polyfit(Vin, Iq1_2, 8);

% Evalate fitted curved to solve for currents
vals_order4_noNoise = polyval(order4Fit_noNoise, Vin);
vals_order4_Noise = polyval(order4Fit_Noise, Vin);
vals_order8_noNoise = polyval(order8Fit_noNoise, Vin);
vals_order8_Noise = polyval(order8Fit_Noise, Vin);

% Plot fitted curves
figure
subplot(2,1,1)
sgtitle('Question 2')
plot(Vin, Iq1_1, Vin, Iq1_2, Vin, vals_order4_noNoise, Vin, vals_order4_Noise, Vin, vals_order8_noNoise, Vin, vals_order8_Noise)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise', '4th Order', '4th Order: Noise', '8th Order', '8th Order: Noise'}, 'Location', 'northwest');
xlabel('Vin [V]'); ylabel('Current [mA]');
ylim([-6 10]);
subplot(2,1,2)
semilogy(Vin, abs(Iq1_1), Vin, abs(Iq1_2), Vin, abs(vals_order4_noNoise), Vin, abs(vals_order4_Noise), Vin, abs(vals_order8_noNoise), Vin, abs(vals_order8_Noise))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise', '4th Order', '4th Order: Noise', '8th Order', '8th Order: Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');

% 4th order fit is faily good, but 8th order fit has too many zeroes
% Try to keep low order polynomial fits

% -------------------------------
%            Question 3
% -------------------------------

% Fit 2 Variables

% B = 0.1
% D = 1.3
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + (0.1).*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');

% fit requires rows, so transpose Vin, Iq1_1
ff_2var = fit(Vin', Iq1_1', fo);
ff_noise_2var = fit(Vin', Iq1_2', fo);
I_ff_2var = ff_2var(Vin);
I_ff_noise_2var = ff_noise_2var(Vin);

figure
subplot(2,1,1)
sgtitle('Question 3 - 2 Variables')
plot(Vin, I_ff_2var, Vin, I_ff_noise_2var)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');
ylim([-6 10]);
subplot(2,1,2)
semilogy(Vin, abs(I_ff_2var), Vin, abs(I_ff_noise_2var))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');

% Fit 3 Variables

% D = 1.3
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');

% fit requires rows, so transpose Vin, Iq1_1
ff_3var = fit(Vin', Iq1_1', fo);
ff_noise_3var = fit(Vin', Iq1_2', fo);
I_ff_3var = ff_3var(Vin);
I_ff_noise_3var = ff_noise_3var(Vin);

figure
subplot(2,1,1)
sgtitle('Question 3 - 3 Variables')
plot(Vin, I_ff_3var, Vin, I_ff_noise_3var)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');
ylim([-6 10]);
subplot(2,1,2)
semilogy(Vin, abs(I_ff_3var), Vin, abs(I_ff_noise_3var))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');

% Fit 4 Variables

fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');

% fit requires rows, so transpose Vin, Iq1_1
ff_4var = fit(Vin', Iq1_1', fo);
ff_noise_4var = fit(Vin', Iq1_2', fo);
I_ff_4var = ff_4var(Vin);
I_ff_noise_4var = ff_noise_4var(Vin);

figure
subplot(2,1,1)
sgtitle('Question 3 - 4 Variables')
plot(Vin, I_ff_4var, Vin, I_ff_noise_4var)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');
ylim([-6 10]);
subplot(2,1,2)
semilogy(Vin, abs(I_ff_4var), Vin, abs(I_ff_noise_4var))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');


% Fitting more variables causes for more error - much like higher order polynomials
% Therefore, define as many coefficients/constants as possible

% -------------------------------
%            Question 4
% -------------------------------

% Neural Net - No Noise
inputs = Vin.';
targets = Iq1_1.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn_noNoise = outputs

% Neural Net - Noise
targets = Iq1_2.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn_Noise = outputs

% Plot neural net answers
figure
subplot(2,1,1)
sgtitle('Question 4 - Neural Network')
plot(Vin, Inn_noNoise, Vin, Inn_Noise)
title('Calculated and Experimental Current - Plot');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');
subplot(2,1,2)
semilogy(Vin, abs(Inn_noNoise), Vin, abs(Inn_Noise))
title('Calculated and Experimental Current - Semilog');
legend({'Calculated', 'Experimental Noise'}, 'Location', 'north');
xlabel('Vin [V]'); ylabel('Current [mA]');

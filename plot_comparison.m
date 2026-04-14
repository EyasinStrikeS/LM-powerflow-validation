clc;
clear;

load('results.mat');

figure;

% Left axis → LM residual
yyaxis left
plot(lambda_values, lm_residual, 'o-', ...
    'Color', [0 0.4470 0.7410], 'LineWidth', 2);
ylabel('LM Residual');

% Right axis → Success indicators
yyaxis right

% Newton → RED
plot(lambda_values, newton_success, 's--', ...
    'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2);
hold on

% LM → GREEN
plot(lambda_values, lm_success, 'd--', ...
    'Color', [0.4660 0.6740 0.1880], 'LineWidth', 2);

ylabel('Success (1 = Converged)');

xlabel('\lambda');
title('Newton vs LM Performance Near Critical Loading');

legend('LM Residual', 'Newton Success', 'LM Success', 'Location', 'best');

grid on;
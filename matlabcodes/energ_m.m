close all ;
clear;
clc;
%%plota graficos dos sinais juntos e a energia dos sinais separado
% numero de sinais analizados
sinais = input ('Fornecer o número de sinais n.wav:\n');
energia = (1:sinais);
caminho = 'F:\\varios\\wav_files\\m\\';
for i = 1:sinais
    disp(i);
    audio_name = sprintf('%d.wav ',i); %cria o nome do arquivo de audio de acordo com a sequencia salva na pasta
    path_audio = strcat(caminho,audio_name);
    amplitude = audioread(path_audio);% leitura do sinal convertido para o formato wave
    samples = size(amplitude,1);% pega o numero de amostras do sinal
    samples_mono = amplitude(1:samples,1);     % cria um sinal mono (apenas um canas dos dois canais existentes no sinal wav
    samples2 = samples_mono.^2;              % calcula sinal (x(t))^2
 	energia(i) = sum( samples2(:) ) % calcula a energia do sinal (x(t))^2
    figure; % cria uma nova janela
s_title = sprintf('Sinal %s',audio_name); % string de nome do arquivo;
%subplot(3,ceil(sinais/3),i);
subplot(2,1,1);plot(samples_mono); title(s_title); xlabel('Amostras'); ylabel('Amplitude');
%figure; % cria uma nova janela
subplot(2,1,2);s_title = sprintf('Sinal ^2%s',audio_name); % string de nome do arquivo;
plot(samples2); title(s_title); xlabel('Amostras'); ylabel('Amplitude');
end
figure('Name','Bíceps Masculino');
pesos = [555 1145 1700 2221 2793 3279 3882 4482 5022 5584 6175 6772 7297 7811 8356 8826];
stem(pesos,energia);
title('Energia do sinal captado');
xlabel('peso em gramas');
ylabel('energia')



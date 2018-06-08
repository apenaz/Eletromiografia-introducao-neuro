
%%plota graficos dos sinais juntos e a energia dos sinais separado

clc;
% numero de sinais analizados
sinais = (1:16)
for i = size(sinais)
    audio_name = sprintf('%d.wav ',i) %cria o nome do arquivo de audio de acordo com a sequencia salva na pasta
    y = audioread(audio_name)% leitura do sinal convertido para o formato wave
    samples = size(y,1)      % pega o numero de amostras do sinal
    ym = y(1:samples,1)      % cria um sinal mono (apenas um canas dos dois canais existentes no sinal wav
    yq = ym.^2;              % calcula sinal (x(t))^2
    sinais(i) = sum( yq(:) ) % calcula a energia do sinal (x(t))^2


    figure; % cria uma nova janela
    s_title = sprintf('Sinal %s',audio_name); % string de nome do arquivo;
    subplot(3,en/3,i);plot(ym); title(s_title); xlabel('Amostras'); ylabel('Amplitude');
end


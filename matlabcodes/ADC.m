%% %run('clean');
%http://mycola.info/2011/04/02/plotting-the-serial-port-data-with-matlab/
delete(instrfindall); %limpa todos os instrumentos anteriormente abertos na serial
clear all; %limpa as variaveis
close all; %fecha janelas...
clc; % limpa console
amostas = 200

s = serial('COM15');             %assigns the object s to serial port

set(s, 'InputBufferSize', amostas*2); % tamamnho do buffer  (tanto de coisa que vai ler)
set(s, 'FlowControl', 'hardware');% de onde vem a informação (serial do microcontrolador etc)
set(s, 'BaudRate', 9600);       % "velocidade de comunicação" taxa de transmissão de dados
set(s, 'Parity', 'none');       % se existe bit de paridade
s.ReadAsyncMode = 'continuous';

set(s, 'DataBits', 8);         %Procurar por "Serial Configuration" no help
set(s, 'StopBit', 1);
set(s, 'Timeout', 1);          %tempo em segundos que o matlab aguarda por novos dados. Deve "casar" com o do Arduino

disp(get(s,'Name'));           %mostra o nome "Serial -COM3"
prop(1)=(get(s,'BaudRate'));   %prop é apenas um vetor de strings que nesse caso tem 4 posições
prop(2)=(get(s,'DataBits'));
prop(3)=(get(s, 'StopBit'));
prop(4)=(get(s, 'InputBufferSize'));

disp(['Port Setup Done!!  ',num2str(prop)]);  %help num2str: converte numeros
%para uma string

fopen(s);                   % abre a serial
t=1;
disp('Running');

% fprintf('\nAguardando 1s para setar o zero.')
% pause(1.0);                %gera uma pausa de 1 segundos
% fprintf('\nFim da espera, iniciando coleta.')

while(t <= amostas)             %Runs for 200 cycles - if you cant see the
    %symbol, it is "less than" sign. so while
    %(t less than 200)
    a = fgetl(s);            % ler o que vem como texto (string) %fread(s,4,'single');%,'SIZE',16.000,'PRECISION','%f'); %reads the data from the serial port and stores it to the matrix a
    fprintf('%s',a);
    try
        y(t)=str2num(a);
        
        
%         a = fgetl(s);            % ler o que vem como texto (string) %fread(s,4,'single');%,'SIZE',16.000,'PRECISION','%f'); %reads the data from the serial port and stores it to the matrix a
%         fprintf('%s',a);
%         y(t)=str2num(a);
        %     x(t)=t*0.005;            % multiplicando pela taxa de amostragem % x(t)
        %e y(t) são para construir um gráfico no final
        %     y(t)=str2num(a); % a é uma string, srt2num converte uma string
        %para um número
        t=t+1;
    end
    %a=0;                     %Clear the buffer
end

fprintf('\nFim da coleta, tratando dados.')
t=1;
while(t <= amostas)
    if(y(t)<0)
        y(t) = 0.00;
    end
    t = t + 1;
end
fclose(s); %close the serial port

%%
fprintf('\nFim do tratamento, gravando arquivo.')
time = clock;
adress='F:\';  %endereço para salvar o arquivo
dia = num2str(time(3));
mes = num2str(time(2));
ano = num2str(time(1));
horas = num2str(time(4));
minutos = num2str(time(5));
nome_do_arquivo = strcat(adress,dia,'-',mes,'-',ano,'_',horas,'-',minutos,'.txt.');
id_do_arquivo = fopen(nome_do_arquivo,'wt'); % wt = write, refere-se à ação que se deseja fazer com o arquivo
t=1;
% while(t <= 200)
%     fprintf(id_do_arquivo,'\t%5.3f\t%8.2f\n',x(t),y(t));
%     t=t+1;
% end
fclose(id_do_arquivo);
fprintf('\nArquivo gravado.\n\n')


plot(y)
% z = trapz(x,y);
%y está em gramas e x está em segundos
% 1Kg = 9.81 N = 1000g -> y*9.81/1000
% z = z*9.81/1000;

% fprintf('Valor da integral: %f N.s',z)



% %% FFT do sinal com 0 de entrada para pegar interferências
% % nota: não existem interferências externas, a FFT revelou ruido branco
% % desativar o "y(t) = 0 se y(t) < 0" para analisar isso.
% %---------------------------------------------------------------------
% Fs = 200; %sampling rate do sinal
% L = size(x,2); %pega o número de linhas do vetor tempo
% NFFT = 2^nextpow2(L); %next power os 2 from the lenght of tempo
% f = Fs/2*linspace(0,1,NFFT/2+1);% linspace(X1, X2, N) generates N points between X1 and X2.
% %this means that there will be frequencies from 0Hz to (Fs/2)Hz
% y2 = fft(y(1,:),NFFT)/L;
% % Plot single-sided amplitude spectrum.
% figure(2);
% plot(f,2*abs(y2(1:NFFT/2+1)))
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|x(f)|')
% grid on;
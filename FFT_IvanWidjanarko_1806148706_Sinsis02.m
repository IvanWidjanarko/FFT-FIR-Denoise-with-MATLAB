% Proyek Sinyal dan Sistem - 02
% FFT, FIR, and Denoise
%   Nama        : Ivan Widjanarko
%   NPM         : 1806148706
%   Jurusan     : Teknik Komputer
%   Departemen  : Teknik Elektro
%   Fakultas    : Teknik
%   Universitas : Universitas Indonesia

function varargout = FFT_IvanWidjanarko_1806148706_Sinsis02(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FFT_IvanWidjanarko_1806148706_Sinsis02_OpeningFcn, ...
    'gui_OutputFcn',  @FFT_IvanWidjanarko_1806148706_Sinsis02_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FFT_IvanWidjanarko_1806148706_Sinsis02 is made visible.
function FFT_IvanWidjanarko_1806148706_Sinsis02_OpeningFcn(hObject, eventdata, handles, varargin)
%disable button
set(handles.ReplayButton,'enable','off');
set(handles.FIRFilterButton,'enable','off');
set(handles.PlayFIRFilterButton,'enable','off');
set(handles.FFTFilterButton,'enable','off');
set(handles.PlayFFTFilterButton,'enable','off');
set(handles.DenoiseButton,'enable','off');
set(handles.PlayDenoiseButton,'enable','off');

handles.output = hObject;
handles.state = 0;
handles.Fs = 8192;
handles.lowBound = 300
handles.highBound = 3800

global nBits;
nBits = 16;
global recObj;
recObj = audiorecorder(handles.Fs,nBits,1);
set(recObj,'TimerPeriod',0.05,'TimerFcn',{@audioTimerCallback,handles});

xlabel(handles.OriginalTimeDomain,'Time');
ylabel(handles.OriginalTimeDomain, 'Amplitude');
xlabel(handles.FFTFrequency,'Frequency (Hz)');
ylabel(handles.FFTFrequency,'|Y(f)|')
xlabel(handles.FIRFrequency,'Frequency (Hz)');
ylabel(handles.FIRFrequency,'|Y(f)|')
xlabel(handles.DenoiseTimeDomain,'Time');
ylabel(handles.DenoiseTimeDomain, 'Amplitude');

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = FFT_IvanWidjanarko_1806148706_Sinsis02_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function audioTimerCallback(hObject,event,handles)
if(isempty(hObject))
    return;
end
signal = getaudiodata(hObject);
plot(handles.OriginalTimeDomain, signal);

% --- Executes on button press in RecordButton.
function RecordButton_Callback(hObject, eventdata, handles)
%prepare parameter
global recObj;

if handles.state == 0
    disp('Start Recording')
    set(hObject,'String','Pause');
    record(recObj);
    handles.state =1 ;
    
    %disable button
    set(handles.ReplayButton,'enable','off');
    set(handles.FIRFilterButton,'enable','off');
    set(handles.PlayFIRFilterButton,'enable','off');
    set(handles.FFTFilterButton,'enable','off');
    set(handles.PlayFFTFilterButton,'enable','off');
    set(handles.DenoiseButton,'enable','off');
    set(handles.PlayDenoiseButton,'enable','off');

else
    disp('Stop Recording')
    set(hObject,'String','Record');
    stop(recObj);
    handles.state = 0;
    
    %enable button
    set(handles.ReplayButton,'enable','on');
    set(handles.FIRFilterButton,'enable','on');
    set(handles.PlayFIRFilterButton,'enable','on');
    set(handles.FFTFilterButton,'enable','on');
    set(handles.PlayFFTFilterButton,'enable','on');
    set(handles.DenoiseButton,'enable','on');
    set(handles.PlayDenoiseButton,'enable','on');
    
    xlabel(handles.OriginalTimeDomain,'Time');
    ylabel(handles.OriginalTimeDomain, 'Amplitude');
    xlabel(handles.FFTFrequency,'Frequency (Hz)');
    ylabel(handles.FFTFrequency,'|Y(f)|')
end
guidata(hObject,handles)


% --- Executes on button press in btn_stoprecord.
function btn_stoprecord_Callback(hObject, eventdata, handles)
disp('Stop Recording')
global recordFlag;
recordFlag = 0;

% --- Executes on button press in ReplayButton.
function ReplayButton_Callback(hObject, eventdata, handles)
global recObj;
global nBits;
sig = getaudiodata(recObj);
[n m] = size(sig)
load gong.mat;
soundsc(sig, handles.Fs, nBits);

% --- Executes on button press in FFTFilterButton.
function FFTFilterButton_Callback(hObject, eventdata, handles)
global recObj;
sig = getaudiodata(recObj);
nfft = 2^nextpow2(length(sig));

global fftRecord
fftRecord = fft(sig,nfft);

plot(handles.FFTFrequency,abs(fftRecord(1:nfft)));
xlabel(handles.FFTFrequency,'Frequency (Hz)');
ylabel(handles.FFTFrequency,'|Y(f)|')

% --- Executes on button press in PlayFFTFilterButton.
function PlayFFTFilterButton_Callback(hObject, eventdata, handles)
global FIROut
global nBits
load gong.mat;
soundsc(FIROut, handles.Fs, nBits);

% --- Executes on button press in FIRFilterButton.
function FIRFilterButton_Callback(hObject, eventdata, handles)
global recObj;
sig = getaudiodata(recObj);
lowFreq = 2*(handles.lowBound)/handles.Fs
highFreq = 2*(handles.highBound)/ handles.Fs
n = 10
% [n, Wn] = buttord(3800*2*pi, 4200*2*pi, 3, 55, 'bandpass');
win = fir1(n,[lowFreq highFreq]);

global FIROut
FIROut = filter(win,1,sig);
nfir = 2^nextpow2(length(FIROut));
FIRRecord = fft(FIROut,nfir);

plot(handles.FIRFrequency, abs(FIRRecord(1:nfir)));
xlabel(handles.FIRFrequency,'Frequency (Hz)');
ylabel(handles.FIRFrequency,'|Y(f)|')

% --- Executes on button press in PlayFIRFilterButton.
function PlayFIRFilterButton_Callback(hObject, eventdata, handles)
global FIROut
global nBits
load gong.mat;
soundsc(FIROut, handles.Fs, nBits);

% --- Executes on button press in DenoiseButton.
function DenoiseButton_Callback(hObject, eventdata, handles)
global recObj;
sig = getaudiodata(recObj);
M = 10;
lambda = (M-1)/M;
h = (1-lambda)*lambda.^(0:100);

global filterSound
filterSound = conv(sig,h,'valid');

plot(handles.DenoiseTimeDomain, sig);
xlabel(handles.DenoiseTimeDomain,'Time');
ylabel(handles.DenoiseTimeDomain,'Amplitude')

% --- Executes on button press in PlayDenoiseButton.
function PlayDenoiseButton_Callback(hObject, eventdata, handles)
global filterSound
global nBits
load gong.mat;
soundsc(filterSound, handles.Fs, nBits);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
cl = questdlg('Do you want to EXIT?','EXIT',...
    'Yes','No','No');
switch cl
    case 'Yes'
        close();
        clear all;
        return;
    case 'No'
        quit cancel;
end

% --- Executes during object creation, after setting all properties.
function OriginalTimeDomain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OriginalTimeDomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate OriginalTimeDomain

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ExitButton.
function ExitButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on mouse press over axes background.
function OriginalTimeDomain_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OriginalTimeDomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when Project is resized.
function Project_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

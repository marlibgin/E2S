function RUN_ele(config_name)
%
%
% MA 8/2/2018
%
% if 1 == 0 
%     %twi.filename = config_name;
%     %lattice      = 'DTBA_C1a_AA.lte';
%     %line         = 'RINGRF';
%     %twi.filename = 'VMX';
%     %lattice      = 'VMX.lte';
%     %line         = 'VMX4D';
% else
%     twi.filename = 'ESRF_EX';
%     line = 'ARCA'; 
% end

if nargin<1
    config_name = 'VMX';
end


addpath /home/xph53246/elegant/elegant2matlab/
addpath(genpath('/home/xph53246/matlabscripts/'))
% addpath /home/xph53246/matlabscripts/general
setpathelegant

%twi.filename = 'andriEx'; 
% runelegant([twi.filename '.ele'])
% -macro=chrox=' num2str(CHROX) ',chroy=' num2str(CHROY)])


% twi.filename = 'injCell-000000'; 


% config_name = 'DTBA_C1a_AA';
switch config_name
    case 'DTBA_C1a_AA'
        twi.filename = 'DTBA_C1a_AA';
        lattice      = 'DTBA_C1a_AA.lte'; 
        line         = 'RINGRF';
    case 'VMX'
        twi.filename = 'VMX';
        lattice      = 'VMX.lte'; 
        line         = 'VMX4D';
    otherwise
        display('no configuration found ...')
end

% if 1 == 0 
%     %twi.filename = config_name;
%     %lattice      = 'DTBA_C1a_AA.lte';
%     %line         = 'RINGRF';
%     %twi.filename = 'VMX';
%     %lattice      = 'VMX.lte';
%     %line         = 'VMX4D';
% else
%     twi.filename = 'ESRF_EX';
%     line = 'ARCA'; 
% end
runelegant([twi.filename '.ele  -macro=lattice=' lattice ' -macro=beamline=' line] )
 
TWI = eleloadMA([twi.filename '.twi']);
MAG = eleloadMA([twi.filename '.mag']);
figure(1)

[a istwi]  = intersect(TWI{1}.columns.names,'s');
[a ibetax] = intersect(TWI{1}.columns.names,'betax');
[a ialfax] = intersect(TWI{1}.columns.names,'alphax');
[a ipsix]  = intersect(TWI{1}.columns.names,'psix');
[a ibetay] = intersect(TWI{1}.columns.names,'betay');
[a ialfay] = intersect(TWI{1}.columns.names,'alphay');
[a ipsiy]  = intersect(TWI{1}.columns.names,'psiy');
[a ietax]  = intersect(TWI{1}.columns.names,'etax');
[a ietaxp] = intersect(TWI{1}.columns.names,'etaxp');

stwi  = TWI{1}.columns.data(istwi,:);

betax = TWI{1}.columns.data(ibetax,:);
betay = TWI{1}.columns.data(ibetay,:);
etax  = TWI{1}.columns.data(ietax,:);
etaxp  = TWI{1}.columns.data(ietaxp,:);

alfax =  TWI{1}.columns.data(ialfax,:);
alfay =  TWI{1}.columns.data(ialfay,:);

psix =  TWI{1}.columns.data(ipsix,:);
psiy =  TWI{1}.columns.data(ipsiy,:);

smag  = MAG{1}.columns.data(3,:);
prof  = MAG{1}.columns.data(4,:);

SXMARK = [];
ElNam  = {MAG{1}.columns.ElementName};
cnt = 0; cc = 0; 
for i=1:length(ElNam{1})
   cnt =cnt+1; 
   if strcmpi(strtrim(ElNam{1}(cnt,:)),'SEXTMARK')
       cc = cc+1; 
       SXMARK(cc) = cnt; 
   end
end

sSEXTMARK = smag(SXMARK);

if 1 == 0
ipsix1 = find(abs(stwi-sSEXTMARK(1))<1e-5); ipsix1 = ipsix1(1); 
ipsix2 = find(abs(stwi-sSEXTMARK(2))<1e-5); ipsix2 = ipsix2(1); 
end


title('TWISS - twi')
plot(stwi,betax,'b-','LineWidth',3); hold on;
plot(stwi,betay,'r-','LineWidth',3);
plot(stwi,etax*100,'Color',[.3 1 .5],'LineWidth',3);
plot(smag,prof*5,'Color',[.7 .7 .7])
legend('\beta_x','\beta_y','\eta_x')

figure()
plot(stwi,alfax,'b-','LineWidth',3); hold on;
plot(stwi,alfay,'r-','LineWidth',3);
plot(stwi,etaxp*100,'Color',[.3 1 .5],'LineWidth',3);
plot(smag,prof*5,'Color',[.7 .7 .7])
legend('\alpha_x','\alpha_y','\eta_x^{,}')


figure()
plot(stwi,psix,'b-','LineWidth',3); hold on
plot(stwi,psiy,'r-','LineWidth',3)
plot(smag,prof*5,'Color',[.7 .7 .7])
legend('\psi_x','\psi_y')

    [stat,emix_]=system(['sdds2stream -par=ex0 ' twi.filename '.twi']);
    [stat,dE_]=system(['sdds2stream -par=Sdelta0 ' twi.filename '.twi']);
    [stat,nux_]=system(['sdds2stream -par=nux ' twi.filename '.twi']);
    [stat,nuy_]=system(['sdds2stream -par=nuy ' twi.filename '.twi']);
    [stat,chrox_]=system(['sdds2stream -par=dnux/dp ' twi.filename '.twi']);
    [stat,chroy_]=system(['sdds2stream -par=dnuy/dp ' twi.filename '.twi']);

% ---------------------------------
% retrieve some parameters from TWI
% ---------------------------------
     emix = str2num(emix_);
     dE   = str2num(dE_);
     nux  = str2num(nux_);
     nuy  = str2num(nuy_);
     chrox= str2num(chrox_);
     chroy= str2num(chroy_);
     

    display('+-- TWISS - twi ---------------------------')
    display(['| emix calculated as: ' num2str(emix,16) ])
    display(['| dE   calculated as: ' num2str(dE,16) ])
    display(['| nux  calculated as: ' num2str(nux,16) ])
    display(['| nuy  calculated as: ' num2str(nuy,16) ])
    display(['| chx  calculated as: ' num2str(chrox,16) ])
    display(['| chy  calculated as: ' num2str(chroy,16) ])
    display('+------------------------------------------')


end


% universala gaskonstanto [J/mol/K]
const('R',8.31446261815324).

% specifa gasknstanto por akvo [J/kg/K]
% vd. https://de.wikipedia.org/wiki/Gaskonstante
const('Rv',461.4).


% vd. https://de.wikipedia.org/wiki/Verdampfungsenthalpie
% varmo (entalpiŝanĝo) en kJ/mol, bezonata por vaporigi unu molon da akvo 
% ĉe temperaturo T [273..473]
h2o_vaporigvarmo(T,Hv) :- 
  T >= 273, T =< 473,
  Hv is 50.09 - 0.9298*T/1e3 - 65.19*T*T/1e6.

% varmo (entalpiŝanĝo) en kJ/kg [=J/g], bezonata por vaporigi unu molon da akvo 
% ĉe temperaturo T [273..473]
h2o_vaporigvarmo_kg(T,Hv) :- 
  h2o_vaporigvarmo(T,Hvm),
  Hv is Hvm/18.02*1e3.

% [kJ/mol] vd https://en.wikipedia.org/wiki/Water_(data_page)
h2o_sublimvarmo(273.15,51.1).

h2o_sublimvarmo_kg(_T,Hs) :-
  h2o_sublimvarmo(_,Hsm), % provizore ni ignoras la temperaturon supozante 0°C
  Hs is Hsm/18.02*1e3.

% [kJ/mol] vd https://en.wikipedia.org/wiki/Water_(data_page)
h2o_degelvarmo(273.15,6.01). 

h2o_degelvarmo_kg(_T,Hf) :-
  h2o_degelvarmo(_,Hfm), % provizore ni ignoras la temperaturon supozante 0°C
  Hf is Hfm/18.02*1e3.


h2o_vaporigentropio(T,_dS) :-
  h2o_vaporigvarmo(T,Hv),
  _dS is Hv / T.

% ekvilibra vaporpremo de H2O ĉe temepraturo T 
% vd. https://www.e-education.psu.edu/meteo300/node/584
h2o_ekvivaporpremo(T,P) :-
  % ĉe 100°C t.e. 100 kPa
  T = 373.15,!, P = 1e5.

h2o_ekvivaporpremo(T,P) :-
  P0 = 1e5, T0 = 373.15,
  _dT is 0.01 * sign(T - T0),
  h2o_evp_(T0,T,_dT,P0,P,h2o_vaporigvarmo_kg).

h2o_ekvisublimpremo(T,P) :-
  % ĉe 0°C t.e. 0.61 kPa
  T = 273.15,!, P = 6.1e2.

h2o_ekvisublimpremo(T,P) :-
  P0 = 6.1e2, T0 = 273.15,
  _dT is 0.01 * sign(T - T0),
  h2o_evp_(T0,T,_dT,P0,P,h2o_sublimvarmo_kg).  

h2o_ekvidegelpremo(T,P) :-
  % ĉe 0°C t.e. 0.61 kPa
  T = 273.15,!, P = 6.1e2.

% https://de.wikipedia.org/wiki/Schmelzenthalpie
% https://de.wikipedia.org/wiki/Gibbs-Energie#Folgerungen
% https://www.engineeringtoolbox.com/water-melting-temperature-point-pressure-d_2005.html
% https://water.lsbu.ac.uk/water/thermodynamic_anomalies.html#fus
%h2o_ekvidegelpremo(T,P) :-
%  P0 = 6.1e2, T0 = 273.15,
%  _dT is 0.01 * sign(T - T0),
  %...? kiu formulo? h2o_evp_(T0,T,_dT,P0,P,h2o_degelvarmo_kg).    

% inkrementado atingis la celtemperaturon T, ni redonas la premon P1 kiel rezulton
h2o_evp_(T1,T,_dT,P1,P1,_) :- (T<T1, T1+_dT<T ; T>T1, T1+_dT>T),!.

% inkrementado ankoraŭ ne atingis la celtemperaturon T, ni plu inkrementas
h2o_evp_(T1,T,_dT,P1,P,Vf) :-
  call(Vf,T1,Hv),
  const('Rv',Rv),
  % inkrementu temperaturon kaj kalkulu novan premon
  % per la ekvacio de Clausius-Clapeyron
  T2 is T1 + _dT,
  P2 is P1 + Hv*1e3 * P1 / Rv / T1 / T1 * _dT,
  h2o_evp_(T2,T,_dT,P2,P,Vf).



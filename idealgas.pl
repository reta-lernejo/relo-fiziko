const(kB,1.380649e-23).  % konstanto de Boltzmann (en J/K)
const(u,1.66053906660e-27). % atoma masunuo en kg
const(h,6.62607015e-34). % konstanto de Planck en Js

const(norm_p,1e5). % normpremo estas 1000 hPa
const(norm_T,293.15). % normtemperaturo en K

nombro(Nombro,Premo,Volumeno,Temperaturo) :-
    const(kB,Boltzmann),
    Nombro is Premo*Volumeno / Boltzmann / Temperaturo.

norm_nombro(Nombro,Volumeno) :-
    const(norm_p,NPremo), 
    const(norm_T,NTemp),
    nombro(Nombro,NPremo,Volumeno,NTemp).

/**
 * Redonas mezuman rapidon de gaseroj ĉe donita atommaso kaj temperaturo (K)
 */
rapido(Rapido,Maso,Temperaturo) :-
    const(kB,Boltzmann),
    const(u,Masunuo),
    Ekin is 3/2*Temperaturo*Boltzmann,
    Rapido is sqrt(2*Ekin/Maso/Masunuo).

/**
 * Redonas la entropikonstanton por atommaso (u)
 */
entropikonstanto(Sigma,UMaso) :-
    const(kB,Boltzmann),
    const(h,Planck),
    Term1 is 2*pi*UMaso*Boltzmann^(3/2),
    Sigma is Boltzmann * (log(Term1 / Planck^3) + 5/2).


/**
 * Redonas la entropion depende de volumeno, temperaturo, ero-nombro kaj ties atommaso (u-oblo)
 * vd. https://de.wikipedia.org/wiki/Ideales_Gas#Mischungsentropie_eines_idealen_Gasgemischs
 * (https://en.wikipedia.org/wiki/Stirling%27s_approximation)
 */
entropio(Entropio,Nombro,UMaso,Volumeno,Temperaturo) :-
    const(kB,Boltzmann),
    entropikonstanto(Sigma,UMaso),
    Term1 is log(Volumeno/Nombro) + 3/2*log(Temperaturo),
    Entropio is Nombro*Boltzmann*Term1 + Nombro*Sigma.

/**
 * Entropiŝanĝo por du diversaj gasoj kun sama premo kaj temperaturo en kunigita volumeno
 * vd. https://de.wikipedia.org/wiki/Ideales_Gas#Ideales_Gasgemisch
 */ 
entropikresko(DeltoS,N1,N2) :-
    const(kB,Boltzmann),
    N is N1+N2,
    DeltoS is Boltzmann * (N1*log(N/N1)+N2*log(N/N2)).


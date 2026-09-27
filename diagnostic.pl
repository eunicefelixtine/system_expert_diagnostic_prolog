% MOTEUR DE RÈGLES DE DIAGNOSTIC TÉLÉCOM

% Règle 1 : Signal inférieur à -90 dBm
diagnostic(Signal, _TEB, _Temp, 'Coupure de fibre optique suspectée') :-
    Signal < -90.

% Règle 2 : TEB > 5% ET Température > 70°C
diagnostic(Signal, TEB, Temp, 'Surchauffe de l\'équipement suspectée avec taux d\'erreur élevé') :-
    Signal >= -90,
    TEB > 5,
    Temp > 70.

% Règle 3 : TEB > 5% SANS surchauffe (Température <= 70°C)
diagnostic(Signal, TEB, Temp, 'Interférence ou congestion du lien suspectée (sans surchauffe)') :-
    Signal >= -90,
    TEB > 5,
    Temp =< 70.

% Règle 4 : Température > 70°C SANS erreur excessive (TEB <= 5%)
diagnostic(Signal, TEB, Temp, 'Simple alerte de surveillance : température élevée sans erreur excessive') :-
    Signal >= -90,
    TEB =< 5,
    Temp > 70.

% Règle 5 (Sinon) : Aucun des cas d'anomalie ci-dessus
diagnostic(Signal, TEB, Temp, 'Aucune anomalie détectée') :-
    Signal >= -90,
    TEB =< 5,
    Temp =< 70.


% INTERFACE INTERACTIVE UTILISATEUR

lire_mesure(Message, Valeur) :-
    repeat,
    write(Message),
    flush_output,
    read_line_to_string(user_input, Texte),
    (   catch(number_string(Valeur, Texte), _, fail)
    ->  !
    ;   writeln('Veuillez entrer une valeur numérique valide.'),
        fail
    ).

expert :-
    writeln('=== SYSTEME EXPERT DE DIAGNOSTIC TELECOM ==='),
    lire_mesure('Niveau de signal (en dBm, ex: -95) : ', Signal),
    lire_mesure('Taux d\'erreur binaire (en %, ex: 6) : ', TEB),
    lire_mesure('Température (en °C, ex: 75) : ', Temp),
    nl,
    diagnostic(Signal, TEB, Temp, Resultat),
    format('RÉSULTAT DU DIAGNOSTIC : ~w~n', [Resultat]), !.
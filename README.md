# Système expert de diagnostic télécom

Mini système expert écrit en **Prolog** avec SWI-Prolog. Il propose un
diagnostic à partir de trois mesures :

- le niveau de signal, en dBm ;
- le taux d'erreur binaire (TEB), en pourcentage ;
- la température de l'équipement, en °C.

## Fonctionnement

Le prédicat principal est `diagnostic/4` :

```prolog
diagnostic(Signal, TEB, Temperature, Diagnostic).
```

Les règles sont évaluées dans l'ordre suivant :

| Condition | Diagnostic |
| --- | --- |
| `Signal < -90` | Coupure de fibre optique suspectée |
| `Signal >= -90`, `TEB > 5` et `Temperature > 70` | Surchauffe avec taux d'erreur élevé |
| `Signal >= -90`, `TEB > 5` et `Temperature =< 70` | Interférence ou congestion du lien, sans surchauffe |
| `Signal >= -90`, `TEB =< 5` et `Temperature > 70` | Alerte de surveillance pour température élevée |
| `Signal >= -90`, `TEB =< 5` et `Temperature =< 70` | Aucune anomalie détectée |

Les seuils sont donc les suivants : un signal égal à `-90` est acceptable,
un TEB égal à `5` est acceptable et une température égale à `70` °C est acceptable.

## Prérequis

Installer [SWI-Prolog](https://www.swi-prolog.org/).

## Utilisation

Depuis le répertoire du projet, charger le fichier dans SWI-Prolog :

```bash
swipl diagnostic.pl
```

Puis lancer l'interface interactive :

```prolog
?- expert.
```

Le programme demande successivement le signal, le TEB et la température.
Chaque valeur doit être numérique.: saisissez
simplement `-95`, `6` ou `75`, puis appuyez sur Entrée. 
En cas de saisie invalide, le programme demande à nouveau la valeur.

Il est également possible d'interroger directement le moteur :

```prolog
?- diagnostic(-95, 2, 45, Diagnostic).
Diagnostic = 'Coupure de fibre optique suspectée'.

?- diagnostic(-70, 8, 75, Diagnostic).
Diagnostic = 'Surchauffe de l'équipement suspectée avec taux d'erreur élevé'.
```

## Cas de validation

| Cas | Signal | TEB | Température | Résultat attendu |
| --- | ---: | ---: | ---: | --- |
| 1 | `-95` | `2` | `45` | Coupure de fibre optique suspectée |
| 2 | `-70` | `8` | `75` | Surchauffe avec taux d'erreur élevé |
| 3 | `-80` | `6` | `50` | Interférence ou congestion du lien, sans surchauffe |
| 4 | `-85` | `1` | `72` | Alerte de surveillance pour température élevée |
| 5 | `-75` | `2` | `40` | Aucune anomalie détectée |


## Projet réalisé par NZEUTEM DOMMOE EUNICE FELIXTINE - 22G00347
# Stratégie de Cache

Nous avons décidé de mettre en place un système de cache coté application mobile, indépendamment de ce qui est fait coté
back-end.

## 1. Cache Http (Dio)

### a. Librairie utilisée

Nous utilisons une librairie Flutter pour gérer les appels HTTP : [dio](https://pub.dev/packages/dio)

Cette librairie nous permet d'effectuer des appels HTTP vers l'extérieur pour récupérer ou modifier de la donnée.

Nous utilisons une librairie complémentaire pour gérer le
cache : [dio_cache_interceptor](https://pub.dev/packages/dio_cache_interceptor)

Nous avons configuré le cache HTTP Dio dans le fichier : `lib/common/manager/repository_manager.dart`

Dans la méthode : `createBaseDio()`

### b. Fonctionnement

Après avoir configuré le cache, tout se joue coté header HTTP. Il faut que les réponses des requêtes HTTP renvoyé par le
back-end contiennent des headers indiquant que le contenu de cette réponse doit être mis en Cache.

Le header que nous utilisons est : `cache-control`

Les directives que nous lui mettons sont : `max-age` et `public` / `private`

`max-age` contient en secondes le temps qu'il faut garder la donnée renvoyée en réponse dans le cache.

`public` indique que les données peuvent être stockée dans un cache partagé

`private` indique que les données ne peuvent être stockée que dans un cache sécurisé

[Plus d'information sur les headers de Cache HTTP.](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)

### c. Application

Nous avons mis en place les headers HTTP de cache sur les réponses renvoyés par le back-end sur les endpoints suivants

- `/concertations`
- `/consultations`
- `/v2/qags`
- `/qags/responses`
- `/referentiels/regions-et-departements`
- `/thematiques`
- `/content/*`

On a choisi ces endpoints car ce sont les plus appelés sur l'application mobile.

## 2. Cache Applicatif

### a. Problématique

Après avoir mis en place le cache HTTP comme expliqué ci-dessus, nous nous sommes rendu compte que lorsque l'on passe
d'un écran dont les données sont mis en cache à un autre, la page repassait en chargement un court instant avant
d'afficher les données. Cela provoquait un effet de clignotement ce qui ne rend pas l'expérience utilisateur très fluide
ou agréable.

### b. Explications

L'origine de ce problème de clignotement vient du fait que lorsque l'on arrive sur l'écran, on déclenche un événement
pour récupérer nos données. Cet événement est "attrapé" par notre Bloc qui gère l'état de l'écran. Ce Bloc appelle une
méthode de callback lorsqu'il voit notre événement passé. Cette méthode de callback est chargé de passé l'état de
l'écran en chargement le temps de faire l'appel au repository qui fait l'appel réseau puis de passer l'état en succès ou
en erreur selon la réponse du serveur.

On commence donc à voir le souci, même si les données sont mises en cache et donc que l'appel réseau au serveur n'est
pas réellement effectué et que les données sont retournées directement, notre écran passe quand même en chargement un
cours instant le temps d'avoir la réponse de notre repository.

### c. Solution envisagée

#### Repository de cache

Pour essayer de résoudre ce problème, nous allons mettre en place un système de cache au niveau des repository. Nous
avons créé un repository de cache auquel on injecte le repository classique qui utilise DIO. Ce repository va nous
servir de cache au sens propre, on enregistre l'instance pour en faire un singleton et il contient nos données avec une
date et heure de dernière mise à jour. Son rôle est de servir nos données stockées s'il y en a et qu'elles sont assez
récente et sinon de faire l'appel au répository classique pour qu'il réalise l'appel HTTP avec DIO.

Puis, au moment de créer notre Bloc, on injecte notre repository de cache au lieu de notre repository classique.

#### Bloc

Pour pouvoir éviter de passer la page en chargement au moment de faire l'appel au repository, nous allons quelque peu
modifier l'implémentation de notre Bloc.

Dans un premier temps, on lui ajoute en attribut un state qui sera le state initial à la création du Bloc. La ou avant
le state initial était toujours vide, maintenant, il pourra contenir des données utilisables.

On crée donc une factory qui prend en paramètre notre repository de cache et qui aura pour but de vérifier si des
données sont présentes dans le cache et si elles sont fraiches. Si oui, de renvoyer un Bloc avec un state initial en
succès avec les données de cache.

Nous avons à présent un Bloc créer avec des données de cache qui lorsqu'il attrapera
un évènement, pourra vérifier que le state et déjà en success avec des données et alors ne pas passer l'écran en
chargement, mais affiché directement les données sur l'écran. Ainsi, nous n'avons plus d'effet de clignotement observé.

#### Durée d'expiration

J'ai mentionné plus haut le fait que la donnée soit "fraiche", lorsqu'on met une donnée en cache, c'est courant de lui
donnée une sorte de durée d'expirations. Et si cette durée est dépassé alors, on considère que la donnée n'est plus
pertinente et qu'il faut refaire l'appel au serveur.

Dans le cas ou la donnée stockée ne change jamais ou très rarement cette durée d'expiration peut être mis très loin dans
le temps voir considérer que la donnée est toujours valide. Pour obtenir cette information, il faut d'abord voir comment
la donnée peut être modifiée.

Par exemple, prenons application de To-Do liste où seul l'utilisateur peut ajouter ou supprimer des éléments. Dans ce
cas, la liste n'est jamais modifié depuis l'extérieur donc bien qu'elle soit stocké sur le serveur. Ainsi, lorsqu'il
s'agit de récupérer la liste, une fois récupéré depuis le serveur, on peut la stocker en cache et considéré qu'elle ne
changera jamais tant que notre utilisateur ne l'aura pas modifié lui-même. On peut alors considérer qu'elle n'a pas de
durée d'expiration.

Dans le cas où la donnée peut être modifié depuis l'extérieur, il faut convenir avec nos collègues du métier comment
fixer cette durée d'expiration. Dans notre cas, nous l'avons fixé à 5 min pour les données qui changent régulièrement et
30 min pour les données statiques.

#### Rafraichir la donnée

Dans le cas où on veut pouvoir forcer le rafraichissement de la donnée, sur mobile, il existe un composant
appelé `pull-to-refresh`. Ce composant permet à l'utilisateur de rafraichir son écran en faisant glisser son doigt du
haut de l'écran vers le bas.

Ainsi, sur les écrans où vous avez mis des données en cache, vous pouvez mettre ce composant pour permettre à vos
utilisateurs d'avoir les données les plus récentes.

Pour l'implémentation, il suffit d'ajouter un boolean `forceRefresh` dans l'événement qui est propagé pour récupérer les
données. Puis dans la méthode de callback du Bloc qui est déclenché par l'événement on ajoute une condition sur ce
boolean pour refaire l'appel auprès du serveur sans passer par le cache.

#### Implémentation

Nous avons implémenté cette solution pour deux des écrans les plus utilisés de l'application. L'écran des consultations
et l'écran des réponses aux questions du gouvernement. Nous ne l'avons pas implémenté sur l'écran des questions au
gouvernement pour un souci de rafraichissement assez régulier des données.

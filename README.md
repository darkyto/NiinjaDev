NiinjaDev 2D Game IOS
===================

Game Description
-------
2D World Game in which your hero enters the world and starts collection his precious gems and also some bonus artifacts. Of course there are a lot of obstacles and enemies to deal with.
The hero can run, jump and shoot - its main purpose is to avoid all obstacles as fire, mines, snakes and similar and to collect all possible gems. The high score depends on collection of different types of gems.

---------

![enter image description here](https://scontent-frt3-1.xx.fbcdn.net/hphotos-xtp1/v/t1.0-9/12472266_10206745545575292_5558828561792023798_n.jpg?oh=9ea51f76fb5fdb7d62b433e471342567&oe=572DE300)

Functionality & Code
-------------

The game is developed for IOS using **Objcetive-C** (mainly with a bit of Swift) and **X-Code** as IDE for IOS development.

The game uses **Sprite Kit** which provides a graphics rendering and animation infrastructure.
After starting the app the first page provides you with an view from where you can select the type of your hero and the world (level) you want to play in.
Then the initial view controller passes its parameters to the GameViewController which presents the GameScene which loads the game world,, hero, obstacles, enemies and logic.

The game relies on models files (in /SupportedFiles) for creating the different types of objects - all models are prefixed with **NI** example : ***NIHero.h*** and ***NIHero.m***  and each of them later is initialized with some physicsBody properties and collision markers.
The hero can jump with **double-tap** (left or right depending on the position of double-tap event) and can run faster with **tap**.
(Beta version update: the hero can shoot with tap and movement is made auto but can be easily changed with two lines of code).
> **Note:**

> - This game is still in beta version. Please report any bugs or considerations to the admin of this repository.

----------
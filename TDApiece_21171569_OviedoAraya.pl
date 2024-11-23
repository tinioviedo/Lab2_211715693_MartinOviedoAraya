:- module('TDApiece_21171569_OviedoAraya', [piece/2]).
% RF2
% Dominio: color (string)
% Metaprimaria: piece/2.

piece(Color, [Color]) :- 
    (Color = "red" ; Color = "yellow").

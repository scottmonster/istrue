#!/usr/bin/env bash

blue="#5d6dfd"
green="#5ffd67"
yellow="#f8fa6b"


perl -0777 -pe '
  s/\e\[0;34m/<span style="color: '"$blue"'">/g;
  s/\e\[1;33m/<span style="color: '"$yellow"'">/g;
  s/\e\[0;32m/<span style="color: '"$green"'">/g;
  s/\e\[0m/<\/span>/g;
  s/\r?\n/<br>/g;                                # newline -> <br> (no \n)
' $1
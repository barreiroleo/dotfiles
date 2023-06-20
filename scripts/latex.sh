#!/bin/bash

# texlive-bin: TeX Live binaries
#
# texlive-most (group):
#     texlive-bibtexextra  : Additional BibTeX styles and bibliography databases
#     texlive-core         : Core distribution
#     texlive-fontsextra   : all sorts of extra fonts
#     texlive-formatsextra : collection of extra TeX 'formats'
#     texlive-games        : Setups for typesetting various board games, including chess
#     texlive-humanities   : LaTeX packages for law, linguistics, social sciences, and humanities
#     texlive-latexextra   : Large collection of add-on packages for LaTeX
#     texlive-music        : Music typesetting packages
#     texlive-pictures     : Packages for drawings graphics
#     texlive-pstricks     : Additional PSTricks packages
#     texlive-publishers   : LaTeX classes and packages for specific publishers
#     texlive-science      : Typesetting for mathematics, natural and computer sciences
#
# texlive-lang (group):
#     texlive-langchinese  : Fonts and macro packages to typeset Chinese texts
#     texlive-langcyrillic : Fonts and macro packages to typeset Cyrillic texts
#     texlive-langextra    : Bundle of all extra language support
#     texlive-langgreek    : Fonts and support for typesetting Greek
#     texlive-langjapanese : Fonts and macro packages to typeset Japanese texts
#     texlive-langkorean   : Fonts and macro packages to typeset Korean texts
#
# tectonic: Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
#
# Perl modules for latexindent: perl-yaml-tiny perl-file-homedir

PACKAGES="texlive-bin latexmk biber tectonic \
    texlive-{bibtexextra,core,fontsextra,formatsextra,latexextra} \
    texlive-{pictures,pstricks,publishers,science} \
    texlive-{games,humanities,music} \
    perl-yaml-tiny perl-file-homedir"

sh ./scripts/query_install.sh pacman $PACKAGES

echo "[WARN]: tllocalmgr-git not more compatible. Use tlmgr instead [provided by texlive-basic]."
# # tllocalmgr-git: A shell and command-line utility to manage TeXLive on Arch Linux                                                                /1.4s
# sh ./scripts/query_install.sh yay tllocalmgr-git
# # Icon fonts
# tllocalmgr install academicons fontawesome fontawesome5

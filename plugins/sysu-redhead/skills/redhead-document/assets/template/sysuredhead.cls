%% SYSURedHead document class
%% This project is intended for typesetting research, teaching, and drafts.
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{sysuredhead}
  [2026/09/02 v2.0.0 Chinese red-head document class]

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{sysuredhead}
    {The sysuredhead class requires XeLaTeX}
    {Compile this document with XeLaTeX. PDFLaTeX and LuaLaTeX are not supported.}
\fi

% Resolve mutually exclusive side options here so the base class receives only
% the final value. All other document options are forwarded before it loads.
\def\sysuredhead@sideoption{twoside}
\newif\ifsysuredhead@fontset
\def\sysuredhead@fontsetkey{fontset}
\def\sysuredhead@checkfontset#1=#2\@nil{%
  \def\sysuredhead@optionkey{#1}%
  \ifx\sysuredhead@optionkey\sysuredhead@fontsetkey
    \sysuredhead@fontsettrue
  \fi
}
\PassOptionsToClass{UTF8,a4paper}{ctexart}
\DeclareOption{oneside}{\def\sysuredhead@sideoption{oneside}}
\DeclareOption{twoside}{\def\sysuredhead@sideoption{twoside}}
\DeclareOption*{%
  \expandafter\sysuredhead@checkfontset\CurrentOption=\@nil
  \PassOptionsToClass{\CurrentOption}{ctexart}%
}
\ProcessOptions\relax
\PassOptionsToClass{\sysuredhead@sideoption}{ctexart}
\ifsysuredhead@fontset\else
  \PassOptionsToClass{fontset=fandol}{ctexart}
\fi
\LoadClass{ctexart}

\RequirePackage{sysuredhead-fonts}
\RequirePackage{sysuredhead-layout}
\RequirePackage{sysuredhead-components}

\endinput

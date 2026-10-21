(* ::Package:: *)
(* ************************************************************************* *)
(*                                                                           *)
(*         FeynRules script for SMEFTdipole model                            *)
(*         Generates FeynArts and UFO model files                            *)
(*                                                                           *)
(* ************************************************************************* *)

(* Determine current directory *)
currentDir = DirectoryName[$InputFileName];
If[currentDir === "" || !StringQ[currentDir],
  currentDir = Directory[];
];
SetDirectory[currentDir];

(* Locate FeynRules package in parent directory *)
$FeynRulesPath = ExpandFileName[FileNameJoin[{currentDir, "..", ".."}]];
If[!MemberQ[$Path, $FeynRulesPath], PrependTo[$Path, $FeynRulesPath]];

(* Default target if not specified before loading this script *)
If[!ValueQ[target] || !StringQ[target],
  target = "UFO_Feynman";
];

Print["========================================================"];
Print["[SMEFTdipole] Target:            ", target];
Print["[SMEFTdipole] Working Directory: ", currentDir];
Print["[SMEFTdipole] FeynRules Path:    ", $FeynRulesPath];
Print["========================================================"];

(* Load FeynRules package *)
<< FeynRules`;
SetDirectory[currentDir];

(* Set derivative sign convention *)
FR$DSign = -1;

(* Execute requested target *)
Switch[target,
  "FA_Unitary",
    Print["--> Setting FeynmanGauge = False (Unitary Gauge)"];
    FeynmanGauge = False;
    LoadModel["SMEFTdipole.fr"];
    Print["--> Generating FeynArts Output (Unitary Gauge) ..."];
    WriteFeynArtsOutput[LTotal,
      FlavorExpand -> SU2W,
      Output -> "SMEFTdipole_UnitaryGauge_FA"
    ],

  "FA_Feynman",
    Print["--> Setting FeynmanGauge = True (Feynman Gauge)"];
    FeynmanGauge = True;
    LoadModel["SMEFTdipole.fr"];
    Print["--> Generating FeynArts Output (Feynman Gauge) ..."];
    WriteFeynArtsOutput[LTotal,
      FlavorExpand -> SU2W,
      Output -> "SMEFTdipole_FeynmanGauge_FA"
    ],

  "UFO_Unitary",
    Print["--> Setting FeynmanGauge = False (Unitary Gauge)"];
    FeynmanGauge = False;
    LoadModel["SMEFTdipole.fr"];
    Print["--> Generating UFO Output (Unitary Gauge) ..."];
    WriteUFO[LTotal,
      Output -> "SMEFTdipole_UnitaryGauge_UFO"
    ],

  "UFO_Feynman",
    Print["--> Setting FeynmanGauge = True (Feynman Gauge)"];
    FeynmanGauge = True;
    LoadModel["SMEFTdipole.fr"];
    Print["--> Generating UFO Output (Feynman Gauge) ..."];
    WriteUFO[LTotal,
      Output -> "SMEFTdipole_FeynmanGauge_UFO"
    ],

  _,
    Print["[ERROR] Unknown target: ", target];
    Print["Valid targets are: FA_Unitary, FA_Feynman, UFO_Unitary, UFO_Feynman"];
    Quit[1];
];

Print["\n[SUCCESS] Target ", target, " finished successfully!"];

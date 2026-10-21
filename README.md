# SMEFTdipole

A [FeynRules](https://feynrules.irmp.ucl.ac.be/) model implementing dimension-6 leptonic dipole operators within the Standard Model Effective Field Theory (SMEFT).

---

## 1. Physical Content

### 1.1 Effective Operators
The model extends the Standard Model (SM) with dimension-6 dipole operators for all three lepton generations ($e, \mu, \tau$):

$$
\mathcal{O}_{eW}^{ij} = (\bar{L}_i \sigma^{\mu\nu} \tau^I e_{R,j}) \Phi W_{\mu\nu}^I, \qquad
\mathcal{O}_{eB}^{ij} = (\bar{L}_i \sigma^{\mu\nu} e_{R,j}) \Phi B_{\mu\nu}
$$

Focusing on flavor-diagonal entries ($i = j$), the effective interaction Lagrangian is parametrized as:

$$
\mathcal{L}_{\text{BSM}} = \sum_{f = e, \mu, \tau} \left[ \frac{C_{fW}}{\Lambda^2} \mathcal{O}_{fW} + \frac{C_{fB}}{\Lambda^2} \mathcal{O}_{fB} + \text{h.c.} \right]
$$

where each Wilson coefficient is split into its real and imaginary parts:
- **Real parts** ($C_{fB}^{\text{Re}}, C_{fW}^{\text{Re}}$): CP-conserving;
- **Imaginary parts** ($C_{fB}^{\text{Im}}, C_{fW}^{\text{Im}}$): CP-violating.

### 1.2 Mapping to Physical Dipole Moments
After electroweak symmetry breaking, the gauge eigenstates $B_{\mu\nu}$ and $W^3_{\mu\nu}$ rotate into the photon ($F_{\mu\nu}$) and $Z$ boson ($Z_{\mu\nu}$) field strength tensors:

$$
C_{f\gamma} = \cos\theta_W C_{fB} - \sin\theta_W C_{fW}, \qquad
C_{fZ} = -\sin\theta_W C_{fB} - \cos\theta_W C_{fW}
$$

The interaction with the photon takes the standard electromagnetic dipole form:

$$
\mathcal{L}_{\ell\ell\gamma} = \frac{v}{\sqrt{2} \Lambda^2} \left[ \text{Re}(C_{\ell\gamma}) \, \bar{\ell} \sigma^{\mu\nu} \ell \, F_{\mu\nu} + i \, \text{Im}(C_{\ell\gamma}) \, \bar{\ell} \sigma^{\mu\nu} \gamma_5 \ell \, F_{\mu\nu} \right]
$$

This directly connects the Wilson coefficients to the experimental observables:
- **Anomalous Magnetic Dipole Moment** ($\Delta a_\ell \equiv (g-2)_\ell / 2$):
  $$
  \Delta a_\ell = \frac{4 \sqrt{2} \, m_\ell v}{e \, \Lambda^2} \text{Re}(C_{\ell\gamma})
  $$
- **Electric Dipole Moment** ($d_\ell$):
  $$
  d_\ell = \frac{\sqrt{2} \, e \, v}{\Lambda^2} \text{Im}(C_{\ell\gamma})
  $$

---

## 2. Directory Structure

- [`SMEFTdipole.fr`](SMEFTdipole.fr): Core FeynRules model definition.
- [`SMEFTdipole.m`](SMEFTdipole.m): Mathematica script for batch model generation with independent clean-kernel execution.
- [`run.sh`](run.sh): Shell executable wrapper for convenient command-line generation.
- [`SMEFTdipole.nb`](SMEFTdipole.nb): Interactive Mathematica notebook for interactive exploration.

---

## 3. Generating the Model Files

### 3.1 Prerequisites
- **Wolfram Mathematica** (version 10 or later).
- **FeynRules** (version 2.3+) installed in `../../` (the parent `feynrules-current` folder).

### 3.2 Automated Generation via `run.sh`

In FeynRules, changing gauges (`FeynmanGauge = True` vs `False`) or running consecutive exports pollutes global variables and cached definitions. The driver script [`run.sh`](run.sh) automatically runs each target in a **separate, fresh Mathematica kernel**, avoiding memory leaks and kernel pollution:

```bash
# 1. Generate ALL model files (Unitary & Feynman gauges for both FA and UFO)
./run.sh

# 2. Generate only UFO models (both Unitary and Feynman gauges)
./run.sh UFO

# 3. Generate only FeynArts models (both Unitary and Feynman gauges)
./run.sh FA

# 4. Generate a single specific target
./run.sh UFO_Unitary     # UFO in Unitary Gauge (standard tree-level for MG5)
./run.sh UFO_Feynman     # UFO in Feynman Gauge (tree-level with Goldstones/ghosts)
./run.sh FA_Unitary      # FeynArts in Unitary Gauge
./run.sh FA_Feynman      # FeynArts in Feynman Gauge
```

Alternatively, you can invoke MathKernel directly:
```bash
/Applications/Mathematica.app/Contents/MacOS/MathKernel -noprompt -run 'target="UFO_Unitary"; << SMEFTdipole.m; Quit[];'
```

### 3.3 Generated Model Outputs

All generated models are strictly **tree-level** (no NLO loop counterterms / $R_2$ vertices):

| Target | Output Directory | Format | Gauge | Recommended Use |
|:---|:---|:---|:---|:---|
| `UFO_Unitary` | `SMEFTdipole_UnitaryGauge_UFO` | UFO (Python) | Unitary | Standard tree-level event generation in MadGraph5 |
| `UFO_Feynman` | `SMEFTdipole_FeynmanGauge_UFO` | UFO (Python) | Feynman | Tree-level with explicit Goldstone and ghost couplings |
| `FA_Unitary`  | `SMEFTdipole_UnitaryGauge_FA`  | FeynArts (`.gen`, `.mod`) | Unitary | Tree-level calculations in FeynArts |
| `FA_Feynman`  | `SMEFTdipole_FeynmanGauge_FA`  | FeynArts (`.gen`, `.mod`) | Feynman | Tree-level calculations in FeynArts |

### 3.4 Fast Generation Tip (`ComputeDecays -> False`)

By default, FeynRules analytically computes $1 \to 2$ squared matrix elements to generate `decays.py` for MadGraph, which takes ~12–15 minutes due to derivative dipole contractions. 

If you do not need FeynRules to precompute analytical decay widths (MadGraph can compute decays dynamically with `set width auto` via `MadWidth`), you can add `ComputeDecays -> False` to `WriteUFO` in [`SMEFTdipole.m`](SMEFTdipole.m):

```mathematica
WriteUFO[LTotal, Output -> "...", ComputeDecays -> False]
```

This reduces the generation time from **~15 minutes down to ~30 seconds**.

---

## 4. Using the UFO Model in MadGraph5_aMC@NLO

### 4.1 Installation in MadGraph5

Copy or link the generated UFO directory into the `models/` directory of your MadGraph5 installation:

```bash
cp -r SMEFTdipole_UnitaryGauge_UFO /path/to/MG5_aMC_v3_x_x/models/
```

> **Gauge Choice**: For standard tree-level simulation (cross sections, collider events), always use **`SMEFTdipole_UnitaryGauge_UFO`**. Unphysical Goldstone and ghost degrees of freedom are decoupled, matching standard MadGraph physics.

### 4.2 Coupling Orders Hierarchy

The model defines a granular, 4-tier coupling order scheme:

| Coupling Order | Scope | Description |
|:---|:---|:---|
| **`NP`** | Global EFT | Overall EFT power expansion ($\Lambda^{-2}$) |
| **`NPRe`** / **`NPIm`** | Global CP | Global switch to filter all CP-even (real) or all CP-odd (imaginary) interactions |
| **`NPCeB`**, **`NPCeW`**, etc. | Operator | Filters a specific operator (both Re and Im parts) |
| **`NPC...Re`**, **`NPC...Im`** | Component | Filters the real or imaginary part of a specific operator |

### 4.3 Practical MadGraph5 Generation Examples

Start MadGraph5 and import the model:
```text
MG5_aMC> import model SMEFTdipole_UnitaryGauge_UFO
```

#### Example 1: Isolating SM-EFT Interference Terms ($e^+ e^- \to \tau^+ \tau^-$)
```text
# SM baseline only (NP = 0)
generate e+ e- > ta+ ta- NP=0

# Full SM + EFT at dimension-6 (linear interference + quadratic terms)
generate e+ e- > ta+ ta- NP<=1

# Isolate the linear SM - CtaW(Re) interference term (tau g-2 effect):
generate e+ e- > ta+ ta- NP^2==1 NPCtaWRe==1

# Isolate the linear SM - CtaW(Im) interference term (tau EDM effect):
generate e+ e- > ta+ ta- NP^2==1 NPCtaWIm==1

# Isolate the pure quadratic EFT term (|M_NP|^2):
generate e+ e- > ta+ ta- NP^2==2 NPCtaWRe==2
```

#### Example 2: Global CP Studies (EDMs / CP-Asymmetries)
```text
# Turn OFF all imaginary (CP-violating) parts globally:
generate p p > mu+ mu- NP<=1 NPIm=0

# Select ONLY CP-violating linear contributions across all operators:
generate p p > mu+ mu- NP^2==1 NPIm==1
```

#### Example 3: Decays and Widths in MadGraph
When launching event generation in MadGraph:
```text
# Compute particle decay widths dynamically with MadWidth:
set width 23 auto   # Z width
set width 24 auto   # W width
set width 15 auto   # tau width
```

---

## 5. Setting Parameters in `param_card.dat`

The external parameters are structured into standard SLHA blocks:

### 5.1 Cutoff Scale: `BLOCK EFTINPUTS`
```text
Block EFTINPUTS
    1   1.000000e+03   # LambdaEFT (in GeV, default: 1000.0)
```

### 5.2 Real Parts of Wilson Coefficients: `BLOCK RealWCs`
```text
Block RealWCs
    1   1.000000e+00   # CeBRe   (Real part of CeB)
    2   1.000000e+00   # CeWRe   (Real part of CeW)
    3   1.000000e+00   # CmuBRe  (Real part of CmuB)
    4   1.000000e+00   # CmuWRe  (Real part of CmuW)
    5   1.000000e+00   # CtaBRe  (Real part of CtaB)
    6   1.000000e+00   # CtaWRe  (Real part of CtaW)
```

### 5.3 Imaginary Parts of Wilson Coefficients: `BLOCK ImaginaryWCs`
```text
Block ImaginaryWCs
    1   1.000000e+00   # CeBIm   (Imaginary part of CeB)
    2   1.000000e+00   # CeWIm   (Imaginary part of CeW)
    3   1.000000e+00   # CmuBIm  (Imaginary part of CmuB)
    4   1.000000e+00   # CmuWIm  (Imaginary part of CmuW)
    5   1.000000e+00   # CtaBIm  (Imaginary part of CtaB)
    6   1.000000e+00   # CtaWIm  (Imaginary part of CtaW)
```

> **Note**: `RealWCs` and `ImaginaryWCs` use an identical 1-to-6 index structure corresponding to $\{eB, eW, \mu B, \mu W, \tau B, \tau W\}$.

---

## 6. Author & Citation Information

- **Author**: Yang Ma (Université catholique de Louvain / University of Pittsburgh)
- **Contact**: `mayangluon@pitt.edu`
- **FeynRules Version**: 2.3+



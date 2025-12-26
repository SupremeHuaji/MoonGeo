# MoonGeo - Geotechnical Engineering Calculation Library

**MoonGeo** is a comprehensive geotechnical engineering calculation library written in **Moonbit**, providing functions for soil mechanics, foundation engineering, and earth pressure analysis.

---

## Features

### Earth Pressure Theory

* **Rankine Theory**: Active and passive earth pressure coefficients and forces
* **Coulomb Theory**: Earth pressure analysis for inclined walls and backfill
* **At-Rest Pressure**: Earth pressure under no lateral deformation conditions

---

### Foundation Engineering

* **Bearing Capacity**: Ultimate and allowable bearing capacity calculations (Terzaghi theory)
* **Settlement Analysis**: Immediate and consolidation settlement calculations
* **Consolidation**: Time-dependent settlement and degree of consolidation

---

### Soil Mechanics

* **Soil Properties**: Void ratio, porosity, degree of saturation, density calculations
* **Effective Stress**: Stress analysis in saturated and unsaturated soils
* **Seepage Analysis**: Darcy flow, hydraulic gradient, and piping analysis

---

## Usage

### Rankine Earth Pressure

```moonbit
test "rankine earth pressure" {
  // Rankine active earth pressure coefficient: φ=30°
  // K_a = tan²(45° - 30°/2) = tan²(30°) = 0.333
  let ka = rankine_active_coefficient(30.0)
  assert_eq(approx_equal(ka, 0.333, 0.01), true)

  // Rankine passive earth pressure coefficient: φ=30°
  // K_p = tan²(45° + 30°/2) = tan²(60°) = 3.0
  let kp = rankine_passive_coefficient(30.0)
  assert_eq(approx_equal(kp, 3.0, 0.1), true)

  // Active earth pressure: K_a=0.333, γ=18kN/m³, z=3m
  // σ_a = 0.333*18*3 = 18 kPa
  let pa = rankine_active_pressure(0.333, 18.0, 3.0)
  assert_eq(approx_equal(pa, 18.0, 0.5), true)

  // Active earth pressure resultant force: H=5m
  // E_a = 0.5*0.333*18*5² = 75 kN/m
  let ea = rankine_active_force(0.333, 18.0, 5.0)
  assert_eq(approx_equal(ea, 75.0, 1.0), true)
}
```

---

### Bearing Capacity

```moonbit
test "bearing capacity" {
  // Terzaghi bearing capacity factors: φ=30°
  let nc = terzaghi_nc(30.0)
  assert_eq(nc > 0.0, true)
  let nq = terzaghi_nq(30.0)
  assert_eq(nq > 1.0, true)
  let ngamma = terzaghi_ngamma(30.0)
  assert_eq(ngamma > 0.0, true)

  // Terzaghi ultimate bearing capacity: c=10kPa, q=20kPa, γ=18kN/m³, B=2m, φ=30°
  let qu = terzaghi_bearing_capacity(10.0, 20.0, 18.0, 2.0, 30.0)
  assert_eq(qu > 0.0, true)

  // Allowable bearing capacity: F_s=3.0
  let fd = bearing_capacity_design(qu, 3.0)
  assert_eq(approx_equal(fd, qu / 3.0, 0.1), true)
}
```

---

### Settlement Analysis

```moonbit
test "settlement" {
  // Single layer settlement: a_v=0.5MPa⁻¹, e_0=0.8, σ_z=100kPa, H_i=2m
  // s_i = 0.5*100*2/(1+0.8) = 55.6 mm
  let si = settlement_layer(0.5, 0.8, 100.0, 2.0)
  assert_eq(approx_equal(si * 1000.0, 55.6, 1.0), true)

  // Settlement using compression modulus: E_s=5MPa, σ_z=100kPa, H_i=2m
  // s_i = (100/1000)*2/5 = 0.1*2/5 = 0.04 m = 40 mm
  let si2 = settlement_layer_es(5.0, 100.0, 2.0)
  assert_eq(approx_equal(si2 * 1000.0, 40.0, 1.0), true)
}
```

---

### Seepage Analysis

```moonbit
test "seepage" {
  // Darcy velocity: k=1e-5 m/s, i=0.1
  // v = 1e-5*0.1 = 1e-6 m/s
  let v = darcy_velocity(1.0e-5, 0.1)
  assert_eq(approx_equal(v, 1.0e-6, 1.0e-8), true)

  // Darcy flow rate: k=1e-4, i=0.2, A=10m²
  // Q = 1e-4*0.2*10 = 0.0002 m³/s
  let q = darcy_flow_rate(1.0e-4, 0.2, 10.0)
  assert_eq(approx_equal(q, 0.0002, 0.00001), true)

  // Hydraulic gradient: Δh=2m, L=10m
  // i = 2/10 = 0.2
  let i = hydraulic_gradient(2.0, 10.0)
  assert_eq(i, 0.2)

  // Critical hydraulic gradient: G_s=2.65, e=0.8
  // i_cr = (2.65-1)/(1+0.8) = 0.917
  let icr = critical_hydraulic_gradient(2.65, 0.8)
  assert_eq(approx_equal(icr, 0.917, 0.01), true)

  // Check for piping
  assert_eq(is_piping(1.0, 0.917), true)
  assert_eq(is_piping(0.5, 0.917), false)
}
```

---

### Consolidation

```moonbit
test "consolidation" {
  // Time factor: C_v=1e-8 m²/s, t=1年=3.15e7s, H=5m
  // T_v = 1e-8*3.15e7/25 = 0.0126
  let tv = time_factor(1.0e-8, 3.15e7, 5.0)
  assert_eq(approx_equal(tv, 0.0126, 0.001), true)

  // Degree of consolidation: T_v=0.1
  // U ≈ 2√(0.1/π) = 0.357
  let u1 = consolidation_degree(0.1)
  assert_eq(approx_equal(u1, 0.357, 0.05), true)

  // Final consolidation settlement: m_v=0.5MPa⁻¹, σ_z=100kPa, H=3m
  // s_f = m_v * (σ_z/1000) * H = 0.5 * 0.1 * 3 = 0.15 m = 150 mm
  let sf = consolidation_settlement_final(0.5, 100.0, 3.0)
  assert_eq(approx_equal(sf * 1000.0, 150.0, 1.0), true)
}
```

---

### Soil Properties

```moonbit
test "soil properties" {
  // Void ratio: n=0.5
  // e = 0.5/(1-0.5) = 1.0
  let e = void_ratio(0.5)
  assert_eq(e, 1.0)

  // Porosity: e=0.8
  // n = 0.8/(1+0.8) = 0.444
  let n = porosity(0.8)
  assert_eq(approx_equal(n, 0.444, 0.01), true)

  // Degree of saturation: V_w=0.4, V_v=0.5
  // S_r = 0.4/0.5*100 = 80%
  let sr = degree_of_saturation(0.4, 0.5)
  assert_eq(approx_equal(sr, 80.0, 1.0), true)

  // Dry density: ρ=1800kg/m³, w=20%
  // ρ_d = 1800/(1+0.2) = 1500 kg/m³
  let rho_d = dry_density(1800.0, 20.0)
  assert_eq(approx_equal(rho_d, 1500.0, 10.0), true)
}
```

---

## Parameter Ranges

### Valid Input Ranges

* **Friction Angle**: 0–50° (soil friction angles)
* **Cohesion**: 0–500 kPa (soil cohesion)
* **Unit Weight**: 10–25 kN/m³ (soil unit weights)
* **Depth**: 0–50 m (foundation depths)
* **Width**: 0.1–20 m (foundation widths)
* **Permeability**: 10⁻¹⁰–10⁻² m/s (soil permeability)
* **Void Ratio**: 0.1–2.0 (soil void ratios)

---

### Typical Soil Properties

* **Sand**: φ = 30–40°, γ = 17–20 kN/m³, k = 10⁻⁴–10⁻² m/s
* **Clay**: φ = 0–25°, γ = 16–19 kN/m³, k = 10⁻¹⁰–10⁻⁶ m/s
* **Silt**: φ = 25–35°, γ = 16–20 kN/m³, k = 10⁻⁶–10⁻³ m/s
* **Gravel**: φ = 35–45°, γ = 18–22 kN/m³, k = 10⁻²–10⁰ m/s

---

## Testing

The project includes a comprehensive test suite covering all major functionalities:

```bash
moon test
```

### Test Coverage

* Earth pressure analysis (Rankine, Coulomb, at-rest conditions)
* Bearing capacity calculations (ultimate and allowable)
* Settlement analysis (immediate and consolidation)
* Seepage and groundwater flow
* Soil property calculations
* Effective stress analysis
* Mathematical utility functions

---

## Technical Details

### Engineering Standards

* **Terzaghi Bearing Capacity Theory**: Ultimate bearing capacity calculations
* **Rankine Earth Pressure Theory**: Lateral earth pressure coefficients
* **Darcy Law**: Groundwater flow and seepage analysis
* **Consolidation Theory**: Time-dependent settlement calculations
* **SI Units**: Consistent use of International System of Units

---

### Applications

* **Foundation Design**: Bearing capacity and settlement analysis
* **Retaining Walls**: Earth pressure and stability calculations
* **Slope Stability**: Factor of safety and critical slip surface analysis
* **Geotechnical Investigations**: Soil property interpretation
* **Groundwater Engineering**: Seepage and drainage design
* **Earth Structures**: Dams, embankments, and landfills design

---

## Notes

1. **Units**: All calculations use SI units (meters, kilograms, seconds, Pascals)
2. **Soil Parameters**: Default values provided for typical soil types
3. **Safety Factors**: Engineering calculations include appropriate safety margins
4. **Boundary Conditions**: Physical limits enforced to prevent unrealistic results
5. **Standards Compliance**: Functions follow geotechnical engineering standards
6. **Validation**: Results should be verified against established geotechnical methods

---

## Version Information

The current version (0.1.0) implements **core geotechnical engineering calculation functions** including:

* Earth pressure analysis (Rankine and Coulomb theories)
* Bearing capacity calculations (Terzaghi theory)
* Settlement analysis (immediate and consolidation)
* Seepage analysis (Darcy flow, hydraulic gradient)
* Soil property calculations (void ratio, porosity, density)
* Effective stress analysis
* Mathematical utilities and tools

The library is actively developed and aims to provide comprehensive coverage of geotechnical engineering calculations while being optimized for MoonBit.
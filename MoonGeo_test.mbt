// MoonGeo - 测试代码

///|
test "rankine earth pressure" {
  // 朗肯主动土压力系数: φ=30°
  // K_a = tan²(45° - 30°/2) = tan²(30°) = 0.333
  let ka = rankine_active_coefficient(30.0)
  assert_eq(approx_equal(ka, 0.333, 0.01), true)

  // 朗肯被动土压力系数: φ=30°
  // K_p = tan²(45° + 30°/2) = tan²(60°) = 3.0
  let kp = rankine_passive_coefficient(30.0)
  assert_eq(approx_equal(kp, 3.0, 0.1), true)

  // 主动土压力: K_a=0.333, γ=18kN/m³, z=3m
  // σ_a = 0.333*18*3 = 18 kPa
  let pa = rankine_active_pressure(0.333, 18.0, 3.0)
  assert_eq(approx_equal(pa, 18.0, 0.5), true)

  // 主动土压力合力: H=5m
  // E_a = 0.5*0.333*18*5² = 75 kN/m
  let ea = rankine_active_force(0.333, 18.0, 5.0)
  assert_eq(approx_equal(ea, 75.0, 1.0), true)
}

///|
test "coulomb earth pressure" {
  // 库仑主动土压力系数 (简化情况，α=0, β=0, δ=0)
  // 应该等于朗肯系数
  let ka_coulomb = coulomb_active_coefficient(30.0, 0.0, 0.0, 0.0)
  let ka_rankine = rankine_active_coefficient(30.0)
  assert_eq(approx_equal(ka_coulomb, ka_rankine, 0.1), true)
}

///|
test "at rest pressure" {
  // 静止土压力系数: φ=30°
  // K_0 = 1 - sin(30°) = 1 - 0.5 = 0.5
  let k0 = at_rest_coefficient(30.0)
  assert_eq(approx_equal(k0, 0.5, 0.01), true)

  // 静止土压力: K_0=0.5, γ=18, z=4m
  // σ_0 = 0.5*18*4 = 36 kPa
  let p0 = at_rest_pressure(0.5, 18.0, 4.0)
  assert_eq(approx_equal(p0, 36.0, 0.5), true)
}

///|
test "bearing capacity" {
  // 太沙基承载力系数: φ=30°
  let nc = terzaghi_nc(30.0)
  assert_eq(nc > 0.0, true)
  let nq = terzaghi_nq(30.0)
  assert_eq(nq > 1.0, true)
  let ngamma = terzaghi_ngamma(30.0)
  assert_eq(ngamma > 0.0, true)

  // 太沙基极限承载力: c=10kPa, q=20kPa, γ=18kN/m³, B=2m, φ=30°
  let qu = terzaghi_bearing_capacity(10.0, 20.0, 18.0, 2.0, 30.0)
  assert_eq(qu > 0.0, true)

  // 承载力设计值: F_s=3.0
  let fd = bearing_capacity_design(qu, 3.0)
  assert_eq(approx_equal(fd, qu / 3.0, 0.1), true)
}

///|
test "settlement" {
  // 单层压缩量: a_v=0.5MPa⁻¹, e_0=0.8, σ_z=100kPa, H_i=2m
  // s_i = 0.5*100*2/(1+0.8) = 55.6 mm
  let si = settlement_layer(0.5, 0.8, 100.0, 2.0)
  assert_eq(approx_equal(si * 1000.0, 55.6, 1.0), true)

  // 使用压缩模量: E_s=5MPa, σ_z=100kPa, H_i=2m
  // s_i = (100/1000)*2/5 = 0.1*2/5 = 0.04 m = 40 mm
  let si2 = settlement_layer_es(5.0, 100.0, 2.0)
  assert_eq(approx_equal(si2 * 1000.0, 40.0, 1.0), true)
}

///|
test "seepage" {
  // 达西定律 - 渗流速度: k=1e-5 m/s, i=0.1
  // v = 1e-5*0.1 = 1e-6 m/s
  let v = darcy_velocity(1.0e-5, 0.1)
  assert_eq(approx_equal(v, 1.0e-6, 1.0e-8), true)

  // 渗流量: k=1e-4, i=0.2, A=10m²
  // Q = 1e-4*0.2*10 = 0.0002 m³/s
  let q = darcy_flow_rate(1.0e-4, 0.2, 10.0)
  assert_eq(approx_equal(q, 0.0002, 0.00001), true)

  // 水力梯度: Δh=2m, L=10m
  // i = 2/10 = 0.2
  let i = hydraulic_gradient(2.0, 10.0)
  assert_eq(i, 0.2)

  // 临界水力梯度: G_s=2.65, e=0.8
  // i_cr = (2.65-1)/(1+0.8) = 0.917
  let icr = critical_hydraulic_gradient(2.65, 0.8)
  assert_eq(approx_equal(icr, 0.917, 0.01), true)

  // 判断流土
  assert_eq(is_piping(1.0, 0.917), true)
  assert_eq(is_piping(0.5, 0.917), false)
}

///|
test "consolidation" {
  // 时间因子: C_v=1e-8 m²/s, t=1年=3.15e7s, H=5m
  // T_v = 1e-8*3.15e7/25 = 0.0126
  let tv = time_factor(1.0e-8, 3.15e7, 5.0)
  assert_eq(approx_equal(tv, 0.0126, 0.001), true)

  // 固结度: T_v=0.1
  // U ≈ 2√(0.1/π) = 0.357
  let u1 = consolidation_degree(0.1)
  assert_eq(approx_equal(u1, 0.357, 0.05), true)

  // 固结度: T_v=0.5
  let u2 = consolidation_degree(0.5)
  assert_eq(u2 > 0.5 && u2 < 1.0, true)

  // 最终固结沉降: m_v=0.5MPa⁻¹, σ_z=100kPa, H=3m
  // s_f = m_v * (σ_z/1000) * H = 0.5 * 0.1 * 3 = 0.15 m = 150 mm
  let sf = consolidation_settlement_final(0.5, 100.0, 3.0)
  assert_eq(approx_equal(sf * 1000.0, 150.0, 1.0), true)

  // 任意时刻沉降: U=0.5, s_f=150mm
  // s_t = 0.5*150 = 75 mm
  let st = consolidation_settlement_time(0.5, 0.15)
  assert_eq(approx_equal(st * 1000.0, 75.0, 1.0), true)
}

///|
test "soil properties" {
  // 孔隙比: n=0.5
  // e = 0.5/(1-0.5) = 1.0
  let e = void_ratio(0.5)
  assert_eq(e, 1.0)

  // 孔隙率: e=0.8
  // n = 0.8/(1+0.8) = 0.444
  let n = porosity(0.8)
  assert_eq(approx_equal(n, 0.444, 0.01), true)

  // 饱和度: V_w=0.4, V_v=0.5
  // S_r = 0.4/0.5*100 = 80%
  let sr = degree_of_saturation(0.4, 0.5)
  assert_eq(approx_equal(sr, 80.0, 1.0), true)

  // 干密度: ρ=1800kg/m³, w=20%
  // ρ_d = 1800/(1+0.2) = 1500 kg/m³
  let rho_d = dry_density(1800.0, 20.0)
  assert_eq(approx_equal(rho_d, 1500.0, 10.0), true)

  // 饱和密度: G_s=2.65, e=0.8, ρ_w=1000
  // ρ_sat = (2.65+0.8)*1000/(1+0.8) = 1917 kg/m³
  let rho_sat = saturated_density(2.65, 0.8, 1000.0)
  assert_eq(approx_equal(rho_sat, 1917.0, 10.0), true)

  // 浮容重: γ_sat=20kN/m³, γ_w=10kN/m³
  // γ' = 20-10 = 10 kN/m³
  let gamma_sub = submerged_unit_weight(20.0, 10.0)
  assert_eq(gamma_sub, 10.0)
}

///|
test "effective stress" {
  // 有效应力: σ=100kPa, u=30kPa
  // σ' = 100-30 = 70 kPa
  let sigma_prime = effective_stress(100.0, 30.0)
  assert_eq(sigma_prime, 70.0)

  // 总应力: γ=18kN/m³, z=5m
  // σ = 18*5 = 90 kPa
  let sigma = total_stress(18.0, 5.0)
  assert_eq(sigma, 90.0)

  // 孔隙水压力: γ_w=10kN/m³, h_w=3m
  // u = 10*3 = 30 kPa
  let u = pore_water_pressure(10.0, 3.0)
  assert_eq(u, 30.0)
}

///|
test "tools functions" {
  // 基本数学运算
  assert_eq(square(5.0), 25.0)
  assert_eq(cube(3.0), 27.0)
  assert_eq(abs(-10.0), 10.0)
  assert_eq(max(3.0, 5.0), 5.0)
  assert_eq(min(3.0, 5.0), 3.0)

  // 角度转换
  assert_eq(approx_equal(deg_to_rad(90.0), PI / 2.0, 0.01), true)
  assert_eq(approx_equal(rad_to_deg(PI), 180.0, 0.1), true)
}

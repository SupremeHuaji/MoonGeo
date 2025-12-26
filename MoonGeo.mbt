// MoonGeo - 土力学/岩土工程库
// 主模块：包含核心计算功能

// ==================== 土压力计算 - 朗肯理论 ====================

///|
/// 朗肯主动土压力系数
/// K_a = tan²(45° - φ/2)
/// 参数: phi_deg - 内摩擦角 (度)
pub fn rankine_active_coefficient(phi_deg : Double) -> Double {
  let phi_rad = deg_to_rad(phi_deg)
  let tan_val = tan_approx(PI / 4.0 - phi_rad / 2.0)
  square(tan_val)
}

///|
/// 朗肯被动土压力系数
/// K_p = tan²(45° + φ/2)
pub fn rankine_passive_coefficient(phi_deg : Double) -> Double {
  let phi_rad = deg_to_rad(phi_deg)
  let tan_val = tan_approx(PI / 4.0 + phi_rad / 2.0)
  square(tan_val)
}

///|
/// 朗肯主动土压力 (无粘性土)
/// σ_a = K_a * γ * z
/// 参数: ka - 主动土压力系数, gamma - 土容重 (kN/m³), z - 深度 (m)
pub fn rankine_active_pressure(
  ka : Double,
  gamma : Double,
  z : Double,
) -> Double {
  ka * gamma * z
}

///|
/// 朗肯主动土压力 (粘性土)
/// σ_a = K_a * γ * z - 2c√K_a
/// 参数: ka, gamma, z, c - 粘聚力 (kPa)
pub fn rankine_active_pressure_cohesive(
  ka : Double,
  gamma : Double,
  z : Double,
  c : Double,
) -> Double {
  let term = ka * gamma * z - 2.0 * c * ka.sqrt()
  max(0.0, term)
}

///|
/// 朗肯被动土压力 (无粘性土)
/// σ_p = K_p * γ * z
pub fn rankine_passive_pressure(
  kp : Double,
  gamma : Double,
  z : Double,
) -> Double {
  kp * gamma * z
}

///|
/// 朗肯被动土压力 (粘性土)
/// σ_p = K_p * γ * z + 2c√K_p
pub fn rankine_passive_pressure_cohesive(
  kp : Double,
  gamma : Double,
  z : Double,
  c : Double,
) -> Double {
  kp * gamma * z + 2.0 * c * kp.sqrt()
}

///|
/// 朗肯主动土压力合力 (无粘性土，矩形分布)
/// E_a = 0.5 * K_a * γ * H²
/// 参数: ka, gamma, h - 墙高 (m)
pub fn rankine_active_force(ka : Double, gamma : Double, h : Double) -> Double {
  0.5 * ka * gamma * square(h)
}

///|
/// 朗肯主动土压力合力作用点 (距墙底)
/// y = H / 3
pub fn rankine_active_force_position(h : Double) -> Double {
  h / 3.0
}

///|
/// 朗肯主动土压力 (有超载)
/// σ_a = K_a * (γ * z + q)
/// 参数: ka, gamma, z, q - 超载 (kPa)
pub fn rankine_active_pressure_surcharge(
  ka : Double,
  gamma : Double,
  z : Double,
  q : Double,
) -> Double {
  ka * (gamma * z + q)
}

// ==================== 土压力计算 - 库仑理论 ====================

///|
/// 库仑主动土压力系数
/// K_a = cos²(φ - α) / [cos²α * cos(α + δ) * (1 + √(sin(φ+δ)sin(φ-β)/(cos(α+δ)cos(α-β)))²)]
/// 简化公式（α=0, β=0, δ=0时退化为朗肯）
/// 参数: phi_deg - 内摩擦角, alpha_deg - 墙背倾角, beta_deg - 填土坡角, delta_deg - 墙土摩擦角
pub fn coulomb_active_coefficient(
  phi_deg : Double,
  alpha_deg : Double,
  beta_deg : Double,
  delta_deg : Double,
) -> Double {
  let phi = deg_to_rad(phi_deg)
  let alpha = deg_to_rad(alpha_deg)
  let beta = deg_to_rad(beta_deg)
  let delta = deg_to_rad(delta_deg)
  let cos_phi_alpha = cos_approx(phi - alpha)
  let cos_alpha = cos_approx(alpha)
  let cos_alpha_delta = cos_approx(alpha + delta)
  let sin_phi_delta = sin_approx(phi + delta)
  let sin_phi_beta = sin_approx(phi - beta)
  let cos_alpha_beta = cos_approx(alpha - beta)
  let numerator = square(cos_phi_alpha)
  let denom1 = square(cos_alpha) * cos_alpha_delta
  let sqrt_term = (sin_phi_delta *
  sin_phi_beta /
  (cos_alpha_delta * cos_alpha_beta)).sqrt()
  let denom2 = square(1.0 + sqrt_term)
  if abs(denom1 * denom2) < EPSILON {
    return 0.0
  }
  numerator / (denom1 * denom2)
}

///|
/// 库仑主动土压力合力
/// E_a = 0.5 * K_a * γ * H²
pub fn coulomb_active_force(ka : Double, gamma : Double, h : Double) -> Double {
  0.5 * ka * gamma * square(h)
}

// ==================== 静止土压力 ====================

///|
/// 静止土压力
/// σ_0 = K_0 * γ * z
/// 参数: k0 - 静止土压力系数, gamma - 土容重, z - 深度
pub fn at_rest_pressure(k0 : Double, gamma : Double, z : Double) -> Double {
  k0 * gamma * z
}

///|
/// 静止土压力系数 (经验公式)
/// K_0 = 1 - sin(φ)
pub fn at_rest_coefficient(phi_deg : Double) -> Double {
  let phi_rad = deg_to_rad(phi_deg)
  1.0 - sin_approx(phi_rad)
}

// ==================== 地基承载力 ====================

///|
/// 太沙基承载力系数 N_c
/// N_c = (N_q - 1) * cot(φ) (当 φ > 0)
/// N_c = 5.7 (当 φ = 0)
pub fn terzaghi_nc(phi_deg : Double) -> Double {
  if abs(phi_deg) < EPSILON {
    return 5.7
  }
  let phi_rad = deg_to_rad(phi_deg)
  let nq = terzaghi_nq(phi_deg)
  (nq - 1.0) / tan_approx(phi_rad)
}

///|
/// 太沙基承载力系数 N_q
/// N_q = e^(πtanφ) * tan²(45° + φ/2)
pub fn terzaghi_nq(phi_deg : Double) -> Double {
  if abs(phi_deg) < EPSILON {
    return 1.0
  }
  let phi_rad = deg_to_rad(phi_deg)
  let exp_term = exp_approx(PI * tan_approx(phi_rad))
  let tan_term = square(tan_approx(PI / 4.0 + phi_rad / 2.0))
  exp_term * tan_term
}

///|
/// 太沙基承载力系数 N_γ
/// N_γ ≈ 2(N_q + 1)tan(φ) (简化)
pub fn terzaghi_ngamma(phi_deg : Double) -> Double {
  if abs(phi_deg) < EPSILON {
    return 0.0
  }
  let phi_rad = deg_to_rad(phi_deg)
  let nq = terzaghi_nq(phi_deg)
  2.0 * (nq + 1.0) * tan_approx(phi_rad)
}

///|
/// 太沙基极限承载力 (条形基础)
/// q_u = c*N_c + q*N_q + 0.5*γ*B*N_γ
/// 参数: c - 粘聚力 (kPa), q - 基础埋深处超载 (kPa), gamma - 土容重 (kN/m³), b - 基础宽度 (m), phi_deg - 内摩擦角
pub fn terzaghi_bearing_capacity(
  c : Double,
  q : Double,
  gamma : Double,
  b : Double,
  phi_deg : Double,
) -> Double {
  let nc = terzaghi_nc(phi_deg)
  let nq = terzaghi_nq(phi_deg)
  let ngamma = terzaghi_ngamma(phi_deg)
  c * nc + q * nq + 0.5 * gamma * b * ngamma
}

///|
/// 太沙基承载力 (考虑基础形状修正)
/// 矩形基础: q_u = c*N_c*s_c + q*N_q*s_q + 0.5*γ*B*N_γ*s_γ
/// 参数: sc, sq, sgamma - 形状系数
pub fn terzaghi_bearing_capacity_shape(
  c : Double,
  q : Double,
  gamma : Double,
  b : Double,
  phi_deg : Double,
  sc : Double,
  sq : Double,
  sgamma : Double,
) -> Double {
  let nc = terzaghi_nc(phi_deg)
  let nq = terzaghi_nq(phi_deg)
  let ngamma = terzaghi_ngamma(phi_deg)
  c * nc * sc + q * nq * sq + 0.5 * gamma * b * ngamma * sgamma
}

///|
/// 汉森承载力系数 N_c
pub fn hansen_nc(phi_deg : Double) -> Double {
  terzaghi_nc(phi_deg) // 与太沙基相同
}

///|
/// 汉森承载力系数 N_q
pub fn hansen_nq(phi_deg : Double) -> Double {
  terzaghi_nq(phi_deg) // 与太沙基相同
}

///|
/// 汉森承载力系数 N_γ
/// N_γ = 1.5(N_q - 1)tan(φ)
pub fn hansen_ngamma(phi_deg : Double) -> Double {
  if abs(phi_deg) < EPSILON {
    return 0.0
  }
  let phi_rad = deg_to_rad(phi_deg)
  let nq = terzaghi_nq(phi_deg)
  1.5 * (nq - 1.0) * tan_approx(phi_rad)
}

///|
/// 地基承载力设计值
/// f = q_u / F_s
/// 参数: qu - 极限承载力 (kPa), fs - 安全系数
pub fn bearing_capacity_design(qu : Double, fs : Double) -> Double {
  if fs <= 0.0 {
    return 0.0
  }
  qu / fs
}

// ==================== 沉降计算 ====================

///|
/// 分层总和法 - 单层压缩量
/// s_i = (a_v / (1 + e_0)) * σ_z * H_i
/// 参数: av - 压缩系数 (MPa⁻¹), e0 - 初始孔隙比, sigma_z - 附加应力 (kPa), hi - 层厚 (m)
/// 注意: 需要单位统一，σ_z(kPa) 转 MPa
pub fn settlement_layer(
  av : Double,
  e0 : Double,
  sigma_z : Double,
  hi : Double,
) -> Double {
  if abs(1.0 + e0) < EPSILON {
    return 0.0
  }
  // σ_z 从 kPa 转为 MPa
  let sigma_z_mpa = sigma_z / 1000.0
  av * sigma_z_mpa * hi / (1.0 + e0)
}

///|
/// 分层总和法 - 使用压缩模量
/// s_i = σ_z * H_i / E_s
/// 参数: es - 压缩模量 (MPa), sigma_z - 附加应力 (kPa), hi - 层厚 (m)
/// 注意: 需要单位统一，σ_z(kPa) 转 MPa
pub fn settlement_layer_es(
  es : Double,
  sigma_z : Double,
  hi : Double,
) -> Double {
  if es <= 0.0 {
    return 0.0
  }
  // σ_z 从 kPa 转为 MPa
  let sigma_z_mpa = sigma_z / 1000.0
  sigma_z_mpa * hi / es
}

///|
/// 总沉降量 (分层总和法)
/// s = Σ s_i
pub fn total_settlement(settlements : Array[Double]) -> Double {
  let mut sum = 0.0
  for i = 0; i < settlements.length(); i = i + 1 {
    sum = sum + settlements[i]
  }
  sum
}

///|
/// 基础中心点下附加应力 (均布荷载)
/// σ_z = p * I_c
/// 参数: p - 基底压力 (kPa), ic - 应力影响系数
pub fn additional_stress_center(p : Double, ic : Double) -> Double {
  p * ic
}

///|
/// 基础角点下附加应力系数 (Boussinesq解，简化)
/// I_c = 1 / (2π) * [z³/(r²+z²)^(5/2)]
/// 这里使用简化公式
pub fn stress_influence_coefficient_simplified(
  z : Double,
  b : Double,
) -> Double {
  if z <= 0.0 || b <= 0.0 {
    return 0.0
  }
  // 简化: I_c ≈ 0.25 (当 z/b = 1 时)
  // 更精确需要查表或数值计算
  let ratio = z / b
  if ratio <= 0.5 {
    0.9
  } else if ratio <= 1.0 {
    0.7
  } else if ratio <= 2.0 {
    0.5
  } else {
    0.3
  }
}

// ==================== 边坡稳定 ====================

///|
/// 瑞典圆弧法 - 安全系数
/// F_s = Σ(c*l + W*cos(α)*tan(φ)) / Σ(W*sin(α))
/// 参数: c - 粘聚力, phi_deg - 内摩擦角, slices - 条块数组 [(l, w, alpha_deg), ...]
pub fn swedish_circle_safety_factor(
  c : Double,
  phi_deg : Double,
  slices : Array[(Double, Double, Double)],
) -> Double {
  let phi_rad = deg_to_rad(phi_deg)
  let tan_phi = tan_approx(phi_rad)
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i = 0; i < slices.length(); i = i + 1 {
    let (l, w, alpha_deg) = slices[i]
    let alpha_rad = deg_to_rad(alpha_deg)
    let cos_alpha = cos_approx(alpha_rad)
    let sin_alpha = sin_approx(alpha_rad)
    numerator = numerator + c * l + w * cos_alpha * tan_phi
    denominator = denominator + w * sin_alpha
  }
  if abs(denominator) < EPSILON {
    return 0.0
  }
  numerator / denominator
}

///|
/// 简化Bishop法 - 安全系数 (迭代求解，这里提供单次计算)
/// F_s = Σ[(c*b + W*tan(φ)) / m_α] / Σ(W*sin(α))
/// 其中 m_α = cos(α) + sin(α)*tan(φ)/F_s
pub fn bishop_safety_factor_iteration(
  c : Double,
  phi_deg : Double,
  slices : Array[(Double, Double, Double)],
  fs_initial : Double,
) -> Double {
  let phi_rad = deg_to_rad(phi_deg)
  let tan_phi = tan_approx(phi_rad)
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i = 0; i < slices.length(); i = i + 1 {
    let (b, w, alpha_deg) = slices[i]
    let alpha_rad = deg_to_rad(alpha_deg)
    let cos_alpha = cos_approx(alpha_rad)
    let sin_alpha = sin_approx(alpha_rad)
    let m_alpha = cos_alpha + sin_alpha * tan_phi / fs_initial
    if abs(m_alpha) > EPSILON {
      numerator = numerator + (c * b + w * tan_phi) / m_alpha
    }
    denominator = denominator + w * sin_alpha
  }
  if abs(denominator) < EPSILON {
    return 0.0
  }
  numerator / denominator
}

// ==================== 渗透性 ====================

///|
/// 达西定律 - 渗流速度
/// v = k * i
/// 参数: k - 渗透系数 (m/s), i - 水力梯度
pub fn darcy_velocity(k : Double, i : Double) -> Double {
  k * i
}

///|
/// 达西定律 - 渗流量
/// Q = k * i * A
/// 参数: k - 渗透系数, i - 水力梯度, a - 过流面积 (m²)
pub fn darcy_flow_rate(k : Double, i : Double, a : Double) -> Double {
  k * i * a
}

///|
/// 水力梯度
/// i = Δh / L
/// 参数: delta_h - 水头差 (m), l - 渗流路径长度 (m)
pub fn hydraulic_gradient(delta_h : Double, l : Double) -> Double {
  if l <= 0.0 {
    return 0.0
  }
  delta_h / l
}

///|
/// 渗透系数 (经验公式，根据有效粒径)
/// k ≈ C * d₁₀²
/// 参数: d10 - 有效粒径 (mm), c - 经验系数
pub fn permeability_from_d10(d10 : Double, c : Double) -> Double {
  c * square(d10)
}

///|
/// 临界水力梯度 (流土)
/// i_cr = (γ_sat - γ_w) / γ_w = (G_s - 1) / (1 + e)
/// 参数: gs - 土粒比重, e - 孔隙比
pub fn critical_hydraulic_gradient(gs : Double, e : Double) -> Double {
  if abs(1.0 + e) < EPSILON {
    return 0.0
  }
  (gs - 1.0) / (1.0 + e)
}

///|
/// 判断是否发生流土
/// i > i_cr
pub fn is_piping(i : Double, i_cr : Double) -> Bool {
  i > i_cr
}

// ==================== 固结理论 ====================

///|
/// 固结度 (一维固结，时间因子法)
/// U = 1 - (8/π²) * Σ[1/(2n-1)² * exp(-(2n-1)²π²T_v/4)]
/// 简化: U ≈ 2√(T_v/π) (当 T_v < 0.2)
/// U ≈ 1 - (8/π²) * exp(-π²T_v/4) (当 T_v > 0.2)
pub fn consolidation_degree(tv : Double) -> Double {
  if tv < 0.2 {
    2.0 * (tv / PI).sqrt()
  } else {
    let exp_term = exp_approx(-square(PI) * tv / 4.0)
    1.0 - 8.0 / square(PI) * exp_term
  }
}

///|
/// 时间因子
/// T_v = C_v * t / H²
/// 参数: cv - 固结系数 (m²/s), t - 时间 (s), h - 排水距离 (m)
pub fn time_factor(cv : Double, t : Double, h : Double) -> Double {
  if h <= 0.0 {
    return 0.0
  }
  cv * t / square(h)
}

///|
/// 固结沉降 (最终沉降)
/// s_f = m_v * σ_z * H
/// 参数: mv - 体积压缩系数 (MPa⁻¹), sigma_z - 附加应力 (kPa), h - 层厚 (m)
/// 注意: 需要单位统一，σ_z(kPa) 转 MPa
pub fn consolidation_settlement_final(
  mv : Double,
  sigma_z : Double,
  h : Double,
) -> Double {
  // σ_z 从 kPa 转为 MPa
  let sigma_z_mpa = sigma_z / 1000.0
  mv * sigma_z_mpa * h
}

///|
/// 固结沉降 (任意时刻)
/// s_t = U * s_f
pub fn consolidation_settlement_time(u : Double, sf : Double) -> Double {
  u * sf
}

///|
/// 固结系数
/// C_v = k / (m_v * γ_w)
/// 参数: k - 渗透系数 (m/s), mv - 体积压缩系数 (MPa⁻¹), gamma_w - 水容重 (kN/m³)
pub fn consolidation_coefficient(
  k : Double,
  mv : Double,
  gamma_w : Double,
) -> Double {
  if mv <= 0.0 || gamma_w <= 0.0 {
    return 0.0
  }
  k / (mv * gamma_w * 0.001) // 单位转换
}

// ==================== 土的物理性质 ====================

///|
/// 孔隙比
/// e = V_v / V_s = (n / (1 - n))
/// 参数: n - 孔隙率
pub fn void_ratio(n : Double) -> Double {
  if n >= 1.0 || n <= 0.0 {
    return 0.0
  }
  n / (1.0 - n)
}

///|
/// 孔隙率
/// n = V_v / V = e / (1 + e)
pub fn porosity(e : Double) -> Double {
  if e < 0.0 {
    return 0.0
  }
  e / (1.0 + e)
}

///|
/// 饱和度
/// S_r = V_w / V_v * 100%
/// 参数: vw - 水的体积, vv - 孔隙体积
pub fn degree_of_saturation(vw : Double, vv : Double) -> Double {
  if vv <= 0.0 {
    return 0.0
  }
  clamp(vw / vv * 100.0, 0.0, 100.0)
}

///|
/// 干密度
/// ρ_d = ρ / (1 + w)
/// 参数: rho - 湿密度 (kg/m³), w - 含水量 (%)
pub fn dry_density(rho : Double, w : Double) -> Double {
  if w < 0.0 {
    return 0.0
  }
  rho / (1.0 + w / 100.0)
}

///|
/// 饱和密度
/// ρ_sat = (G_s + e) * ρ_w / (1 + e)
/// 参数: gs - 土粒比重, e - 孔隙比, rho_w - 水的密度
pub fn saturated_density(gs : Double, e : Double, rho_w : Double) -> Double {
  if abs(1.0 + e) < EPSILON {
    return 0.0
  }
  (gs + e) * rho_w / (1.0 + e)
}

///|
/// 浮容重
/// γ' = γ_sat - γ_w
pub fn submerged_unit_weight(gamma_sat : Double, gamma_w : Double) -> Double {
  gamma_sat - gamma_w
}

// ==================== 有效应力原理 ====================

///|
/// 有效应力
/// σ' = σ - u
/// 参数: sigma - 总应力 (kPa), u - 孔隙水压力 (kPa)
pub fn effective_stress(sigma : Double, u : Double) -> Double {
  sigma - u
}

///|
/// 总应力 (自重应力)
/// σ = γ * z
pub fn total_stress(gamma : Double, z : Double) -> Double {
  gamma * z
}

///|
/// 孔隙水压力 (静水压力)
/// u = γ_w * h_w
pub fn pore_water_pressure(gamma_w : Double, hw : Double) -> Double {
  gamma_w * hw
}

// ==================== 辅助函数 ====================

///|
/// 计算土压力合力作用点 (考虑超载)
pub fn earth_pressure_force_position_with_surcharge(
  h : Double,
  q : Double,
  gamma : Double,
) -> Double {
  if abs(gamma * h + q) < EPSILON {
    return h / 3.0
  }
  // 梯形分布合力作用点
  let top = q
  let bottom = gamma * h + q
  let y = h * (2.0 * top + bottom) / (3.0 * (top + bottom))
  y
}

///|
/// 判断土压力分布类型
/// 返回: "active", "passive", "at_rest"
pub fn earth_pressure_type(
  ka : Double,
  kp : Double,
  k0 : Double,
  k_actual : Double,
) -> String {
  if approx_equal(k_actual, ka, 0.01) {
    "active"
  } else if approx_equal(k_actual, kp, 0.01) {
    "passive"
  } else if approx_equal(k_actual, k0, 0.01) {
    "at_rest"
  } else {
    "unknown"
  }
}
